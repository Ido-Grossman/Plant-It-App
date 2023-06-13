import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/plant_info.dart';
import 'package:frontend/service/http_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/calendar_helper.dart';
import '../forum/forum_main_screen.dart';

const String nineAm = '09:00';
const String threePm = '15:00';
const String ninePm = '21:00';
const String noReminders = 'No reminders';

class PlantDetailsScreen extends StatefulWidget {
  final PlantInfo plantInfo;
  final String? token;
  final String email;

  PlantDetailsScreen(
      {Key? key,
      required this.plantInfo,
      required this.token,
      required this.email})
      : super(key: key);

  @override
  State<PlantDetailsScreen> createState() => _PlantDetailsScreenState();
}

class _PlantDetailsScreenState extends State<PlantDetailsScreen> {
  final CalendarHelper _calendarHelper = CalendarHelper();
  String? _calendarId;
  String? selectedReminderTime;

  @override
  void initState() {
    super.initState();
    _retrieveDefaultCalendar();
  }

  Future<void> _retrieveDefaultCalendar() async {
    final calendars = await _calendarHelper.retrieveCalendars();
    _calendarId = calendars.firstWhere((calendar) => calendar.isDefault == true).id;
  }

  Future<void> createCalendarEvents(
      String eventTitle,
      String reminderTime,
      int waterDuration,
      ) async {
    DateTime now = DateTime.now();
    DateTime startDate = DateTime(now.year, now.month, now.day);
    DateTime endDate = startDate.add(Duration(days: 90)); // 90 days for 3 months

    DateTime eventStartTime = DateTime.parse(
        "${startDate.toIso8601String().substring(0, 11)}$reminderTime:00Z");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> eventIds = prefs.getStringList(eventTitle) ?? [];
    while (eventStartTime.isBefore(endDate)) {
      DateTime eventEndTime = eventStartTime.add(Duration(minutes: 30)); // 30 minutes event duration
      String? eventId = await _calendarHelper.createOrUpdateEvent(
        _calendarId!,
        'Water $eventTitle',
        eventStartTime,
        eventEndTime,
      );
      if (eventId != null) {
        eventIds.add(eventId);
      }
      eventStartTime = eventStartTime.add(Duration(days: waterDuration));
    }
    await prefs.setStringList(eventTitle, eventIds);
  }

  Widget buildTitleText(String title, Color color) {
    return Text(
      title,
      style: GoogleFonts.robotoSlab(fontSize: 22, color: color),
    );
  }

  Widget buildBodyText(String body) {
    return Text(
      body,
      style: GoogleFonts.lato(fontSize: 18),
    );
  }


  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Theme.of(context);
    Color textColor = currentTheme.brightness == Brightness.light
        ? Consts.primaryColor
        : Consts.greenDark;

    String commonNames = widget.plantInfo.common.join(', ');
    String howToUse = widget.plantInfo.use.join(', ');
    String temperatureRange =
        '${widget.plantInfo.minCelsius}°C - ${widget.plantInfo.maxCelsius}°C (${widget.plantInfo.minFahrenheit}°F - ${widget.plantInfo.maxFahrenheit}°F)';
    String wateringFrequency = 'Every ${widget.plantInfo.waterDuration} days';


    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Plant Details',
          style: GoogleFonts.robotoSlab(fontSize: 22),
        ),
        backgroundColor: Consts.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(widget.plantInfo.plantPhoto, fit: BoxFit.cover),
              ),
              SizedBox(height: 16),
              Text(
                widget.plantInfo.latin,
                style: GoogleFonts.pacifico(fontSize: 28, color: textColor),
              ),
              SizedBox(height: 8),
              buildBodyText('Common Names: $commonNames'),
              SizedBox(height: 8),
              buildBodyText('Plant Family: ${widget.plantInfo.family}'),
              SizedBox(height: 16),
              buildTitleText('Light', textColor),
              SizedBox(height: 4),
              buildBodyText('${widget.plantInfo.toleratedlight} (Tolerated), ${widget.plantInfo.idealight} (Ideal)'),
              SizedBox(height: 16),
              buildTitleText('How to Water', textColor),
              SizedBox(height: 4),
              buildBodyText(widget.plantInfo.watering),
              SizedBox(height: 16),
              buildTitleText('How to Use', textColor),
              SizedBox(height: 4),
              buildBodyText(howToUse),
              SizedBox(height: 16),
              buildTitleText('Temperature Range', textColor),
              SizedBox(height: 4),
              buildBodyText(temperatureRange),
              SizedBox(height: 16),
              buildTitleText('Watering Frequency', textColor),
              SizedBox(height: 4),
              buildBodyText(wateringFrequency),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'forum',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ForumScreen(plantId: widget.plantInfo.id, token: widget.token),
                ),
              );
            },
            backgroundColor: textColor,
            label: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Text("To discussions"),
            ),
            icon: const Icon(Icons.forum),
          ),
          SizedBox(width: 8),
          SizedBox(
            width: 130,
            height: 48,
            child: FloatingActionButton.extended(
              heroTag: 'add-plant',
              onPressed: () async {
                TextEditingController nicknameController = TextEditingController();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String? selectedReminderTime;
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return AlertDialog(
                          title: Text('Enter a nickname for the plant'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: nicknameController,
                                decoration: InputDecoration(hintText: 'Nickname'),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Time for watering reminders:',
                                style: GoogleFonts.lato(fontSize: 18),
                              ),
                              SizedBox(height: 8),
                              DropdownButton<String>(
                                value: selectedReminderTime,
                                hint: Text('Select reminder time'),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedReminderTime = newValue;
                                  });
                                },
                                items: <String>[nineAm, threePm, ninePm, noReminders]
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                String nickname = nicknameController.text;
                                if (nickname.isNotEmpty) {
                                  int statusCode = await addPlantToList(
                                      widget.email, widget.token!, widget.plantInfo.id, nickname);
                                  if (statusCode == 201) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Plant added to list'),
                                      ),
                                    );

                                    if (selectedReminderTime != noReminders && selectedReminderTime != null) {
                                      String reminderTime;
                                      switch (selectedReminderTime) {
                                        case nineAm:
                                          reminderTime = nineAm;
                                          break;
                                        case threePm:
                                          reminderTime = threePm;
                                          break;
                                        case ninePm:
                                          reminderTime = ninePm;
                                          break;
                                        default:
                                          reminderTime = nineAm;
                                      }

                                      await createCalendarEvents(
                                        nickname,
                                        reminderTime,
                                        widget.plantInfo.waterDuration,
                                      );
                                    }

                                  } else if (statusCode == 409){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Nickname is already in list, choose another'),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Could not add plant to list'),
                                      ),
                                    );
                                  }
                                }
                                Navigator.of(context).pop();
                              },

                              child: Text('Add to List'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
              backgroundColor: textColor,
              label: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Text("Add to List"),
              ),
              icon: const Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }
}
