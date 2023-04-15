import 'package:device_calendar/device_calendar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import '../widgets/calendar_helper.dart';

class HomeScreen extends StatefulWidget {
  final String? username;

  const HomeScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  CalendarHelper _calendarHelper = CalendarHelper();
  List<Event> _upcomingEvents = [];
  String? _plantName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _loadUpcomingEvents();
    // Refresh events every 30 seconds
    Timer.periodic(Duration(seconds: 30), (timer) {
      if (!mounted) {
        timer.cancel();
      } else {
        _loadUpcomingEvents();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _loadUpcomingEvents();
    }
  }

  Future<void> _loadUpcomingEvents() async {
    final hasPermissions = await _calendarHelper.requestPermissions();
    if (hasPermissions) {
      final calendars = await _calendarHelper.retrieveCalendars();
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

  void _showSuccessPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          backgroundColor: Colors.green.shade200,
          title: Text(
            'Water reminder set successfully!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
          content: Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 80.0,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addWateringEvent(String plantName, DateTime eventDateTime) async {
    final hasPermissions = await _calendarHelper.requestPermissions();
    if (!hasPermissions) {
      return;
    }

    final calendars = await _calendarHelper.retrieveCalendars();
    if (calendars.isEmpty) {
      return;
    }

    // Select the first calendar by default.
    String? calendarId;
    try {
      calendarId = calendars.elementAt(5).id;
    } catch (e) {
      print(e);
    }
    calendarId ??= calendars.first.id;
    final eventTitle = 'Water $plantName';
    final eventStartTime = eventDateTime;
    final eventEndTime = eventStartTime.add(Duration(minutes: 30)); // End event 30 minutes after the start time

    final eventId = await _calendarHelper.createOrUpdateEvent(calendarId!, eventTitle, eventStartTime, eventEndTime);
    _loadUpcomingEvents(); // Refresh the events list
  }

  Future<void> _showAddEventDialog() async {
    TextEditingController _plantNameController = TextEditingController();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.all(24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              backgroundColor: Color(0xFFF4F4F4),
              title: Text(
                'Set Date and Time',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _plantNameController,
                      decoration: InputDecoration(
                        labelText: 'Plant Name',
                        labelStyle: TextStyle(color: Colors.green),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    ListTile(
                      title: selectedDate == null
                          ? Text('Select date')
                          : Text('Selected date: ${DateFormat.yMd().format(selectedDate!)}'),
                      trailing: Icon(Icons.calendar_today, color: Colors.green),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 14)),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    ListTile(
                      title: selectedTime == null
                          ? Text('Select time')
                          : Text('Selected time: ${selectedTime!.format(context)}'),
                      trailing: Icon(Icons.access_time, color: Colors.green),
                      onTap: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            selectedTime = pickedTime;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedDate != null && selectedTime != null && _plantNameController.text.isNotEmpty) {
                      final DateTime eventDateTime = DateTime(
                        selectedDate!.year,
                        selectedDate!.month,
                        selectedDate!.day,
                        selectedTime!.hour,
                        selectedTime!.minute,
                      );
                      _addWateringEvent(_plantNameController.text, eventDateTime);
                      Navigator.of(context).pop();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Water reminder set successfully!'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
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
              "When you should water your plants",
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
                  : ListView.builder(
                      itemCount: _upcomingEvents.length,
                      itemBuilder: (context, index) {
                        final event = _upcomingEvents[index];
                        final eventTime = event.start!.toLocal();
                        final timeString = DateFormat.jm().format(eventTime);
                        final dateString = DateFormat.yMd().format(eventTime);

                        return Card(
                          elevation: 4,
                          margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                            subtitle: Text('On $dateString at $timeString'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        tooltip: 'Add Plant Watering Event',
        child: Icon(Icons.add),
      ),
    );
  }
}
