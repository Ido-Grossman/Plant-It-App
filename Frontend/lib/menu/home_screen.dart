import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/plant_info.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../service/http_service.dart';
import '../widgets/calendar_helper.dart';
import '../plants/plant_info_screen.dart';

class HomeScreen extends StatefulWidget {
  final String? username;
  final String email;
  final String? token;

  const HomeScreen({Key? key, required this.username, required this.email, required this.token}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver, TickerProviderStateMixin {
  CalendarHelper _calendarHelper = CalendarHelper();
  List<Event> _upcomingEvents = [];
  String? _calendarId;
  List<PlantInfo> recommendedPlants = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUpcomingEvents();
    _fetchRecommendations();
    // Refresh events every 30 seconds
    Timer.periodic(Duration(seconds: 20), (timer) {
      if (!mounted) {
        timer.cancel();
      } else {
        _loadUpcomingEvents();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _loadUpcomingEvents();
      _fetchRecommendations();
    }
  }

  Future<void> _fetchRecommendations() async {
    final plants = await fetchRecommendations(widget.email, widget.token);
    setState(() {
      recommendedPlants = plants;
    });
  }

  Future<void> _loadUpcomingEvents() async {
    final hasPermissions = await _calendarHelper.requestPermissions();
    if (hasPermissions) {
      final calendars = await _calendarHelper.retrieveCalendars();
      _calendarId = calendars.firstWhere((calendar) => calendar.isDefault == true).id;
      final now = DateTime.now();
      final oneMonthLater = now.add(Duration(days: 30));
      List<Event> tempUpcomingEvents = [];
      for (final calendar in calendars) {
        final events = await _calendarHelper.retrieveEvents(calendar.id, now, oneMonthLater);
        final plantWateringEvents = events.where((event) => event.title?.contains('Water') ?? false).toList();
        tempUpcomingEvents.addAll(plantWateringEvents);
      }
      // Sorting events by start time
      tempUpcomingEvents.sort((a, b) => a.start!.compareTo(b.start!));
      setState(() {
        _upcomingEvents = tempUpcomingEvents;
      });
    }
  }


  Future<void> makeWaterEvents(int frequencyInHours, String plantName) async {
    final hasPermissions = await _calendarHelper.requestPermissions();
    if (!hasPermissions) {
      return;
    }

    final calendars = await _calendarHelper.retrieveCalendars();
    if (calendars.isEmpty) {
      return;
    }

    // Select the first calendar by default.
    final calendarId = calendars.first.id;
    final now = DateTime.now();
    final twoWeeksLater = now.add(Duration(days: 14));

    for (DateTime startTime = now.add(Duration(hours: frequencyInHours));
    startTime.isBefore(twoWeeksLater);
    startTime = startTime.add(Duration(hours: frequencyInHours))) {
      final eventTitle = 'Water $plantName';
      final eventEndTime = startTime.add(Duration(minutes: 30)); // End event 30 minutes after the start time

      final eventId = await _calendarHelper.createOrUpdateEvent(calendarId!, eventTitle, startTime, eventEndTime);
    }

    _loadUpcomingEvents(); // Refresh the events list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 48,
            ),
            Text(
              'Hello, ${widget.username}!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 48,
            ),
            Text(
              "Recommended plants based on your plants other users",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchRecommendations,
                child: ListView.builder(
                  itemCount: recommendedPlants.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlantDetailsScreen(
                                email: widget.email,
                                token: widget.token,
                                plantInfo: recommendedPlants[index],
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              // Plant image
                              Container(
                                width: 60,  // Set as needed
                                height: 60, // Set as needed
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(recommendedPlants[index].plantPhoto),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              // Plant info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(recommendedPlants[index].common[0],
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                    ),
                                    Text(recommendedPlants[index].family,
                                      style: TextStyle(fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              // Icon
                              Icon(Icons.local_florist, color: Colors.green),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "When should you water your plants",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: _upcomingEvents.isEmpty
                  ? const Center(
                child: Text('No upcoming events found.'),
              )
                  : ListView.separated(
                itemCount: _upcomingEvents.length,
                separatorBuilder: (context, index) {
                  if (index < _upcomingEvents.length - 1) {
                    DateTime currentDate = _upcomingEvents[index].start!.toLocal();
                    DateTime nextDate = _upcomingEvents[index + 1].start!.toLocal();

                    if (currentDate.day != nextDate.day) {
                      return Column(
                        children: [
                          SizedBox(height: 8),
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                        ],
                      );
                    }
                  }
                  return SizedBox.shrink();
                },
                itemBuilder: (context, index) {
                  final event = _upcomingEvents[index];
                  final eventTime = event.start!.toLocal();
                  final timeString = DateFormat.jm().format(eventTime);
                  final dateString = DateFormat.yMd().format(eventTime);

                  // Check if the current event has the same date as the previous event.
                  // If it does, don't display the date again.
                  bool showDate = true;
                  if (index > 0) {
                    final previousEvent = _upcomingEvents[index - 1];
                    final previousEventTime = previousEvent.start!.toLocal();
                    showDate = eventTime.day != previousEventTime.day;
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showDate) ...[
                        SizedBox(height: 16),
                        Text(
                          dateString,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                      AnimatedSize(
                        curve: Curves.easeInOut,
                        duration: Duration(milliseconds: 300),
                        child: AnimatedOpacity(
                          opacity: _upcomingEvents.contains(event) ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 300),
                          child: Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Icon(
                                  Icons.local_drink,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                event.title!,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(timeString),
                              trailing: IconButton(
                                icon: Icon(Icons.check, color: Colors.green),
                                onPressed: () async {
                                  setState(() {
                                    _upcomingEvents.removeAt(index);
                                  });
                                  await _calendarHelper.deleteEvent(_calendarId!, event.eventId!);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },

              ),
            ),
          ],
        ),
      ),
    );
  }
}
