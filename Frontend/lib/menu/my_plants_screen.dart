import 'package:frontend/constants.dart';
import 'package:frontend/service/http_service.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/plant_details.dart';
import '../models/plant_info.dart';
import '../plants/plant_card_list.dart';
import '../plants/plant_care_page.dart';
import '../plants/plant_info_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/calendar_helper.dart';

class MyPlants extends StatefulWidget {
  final VoidCallback onNavigateAway;
  final ValueNotifier<bool> refreshNotifier;
  final String email;
  final String? token;

  const MyPlants(
      {Key? key,
      required this.email,
      required this.token,
      required this.refreshNotifier,
      required this.onNavigateAway})
      : super(key: key);

  @override
  State<MyPlants> createState() => _MyPlantsState();
}

class _MyPlantsState extends State<MyPlants> {
  List<PlantDetails> plants = [];
  final CalendarHelper _calendarHelper = CalendarHelper();
  String? _calendarId;

  @override
  void initState() {
    super.initState();
    _fetchAndSetPlants();
    _retrieveDefaultCalendar();
  }

  Future<void> _retrieveDefaultCalendar() async {
    final calendars = await _calendarHelper.retrieveCalendars();
    _calendarId = calendars.firstWhere((calendar) => calendar.isDefault == true).id;
  }

  Future<void> _fetchAndSetPlants() async {
    try {
      List<PlantDetails> fetchedPlants =
          await fetchMyPlants(widget.email, widget.token);
      setState(() {
        plants = fetchedPlants;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<List<String>> getEventIdsForPlant(String plantNickname) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> eventIds = prefs.getStringList(plantNickname) ?? [];
    return eventIds;
  }

  Future<void> _showDeleteConfirmationDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Plant'),
          content: const Text('Are you sure you want to delete this plant?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                int statusCode = await deletePlantFromList(
                    widget.email, widget.token, plants[index].idOfUser);
                if (statusCode == 204) {
                  if (_calendarId != null) {
                    List<String> eventIds = await getEventIdsForPlant(plants[index].nickname);
                    for (String eventId in eventIds) {
                      await _calendarHelper.deleteEvent(_calendarId!, eventId);
                    }
                  }


                  setState(() {
                    _fetchAndSetPlants();
                  });
                } else {
                  Consts.alertPopup(context,
                      'Error Could not delete plant. Please try again.');
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.refreshNotifier,
      builder: (context, value, child) {
        if (value) {
          _fetchAndSetPlants();
          widget.refreshNotifier.value = false;
        } else if (!value) {
          widget.onNavigateAway();
        }
        return Scaffold(
          body: plants.isEmpty
              ? const Center(
                  child: Text(
                    "You don't have any plants yet!",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(4),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 1.4,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 4,
                  ),
                  itemCount: plants.length,
                  itemBuilder: (context, index) {
                    return PlantCard(
                      imageUrl: plants[index].plantPhoto,
                      name: plants[index].nickname,
                      healthStatus: plants[index].disease,
                      onPlantTap: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Scaffold(
                              body: Center(
                                child: Container(
                                  height: 150.0,
                                  width: 150.0,
                                  child: LiquidCircularProgressIndicator(
                                    value: 0.6, // Defaults to 0.5.
                                    valueColor: AlwaysStoppedAnimation(Consts.primaryColor), // Defaults to the current Theme's accentColor.
                                    backgroundColor: Colors.white, // Defaults to the current Theme's backgroundColor.
                                    borderColor: Consts.primaryColor,
                                    borderWidth: 5.0,
                                    direction: Axis.vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                                    center: Text("Loading..."),
                                  ),
                                ),
                              ),
                            );
                          },
                          barrierDismissible: false,
                        );

                        PlantInfo plantInfo;
                        try {
                          plantInfo = await fetchPlantInfo(plants[index].plantId);
                        } catch (e) {
                          // Show an error message or handle the exception
                          Navigator.of(context).pop(); // Close the dialog
                          print("Error fetching plant details: $e");
                          return;
                        }

                        Navigator.of(context).pop(); // Close the dialog

                        // Navigate to the PlantDetailsScreen with the selected plant details
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlantDetailsScreen(
                              email: widget.email,
                              token: widget.token,
                              plantInfo: plantInfo,
                            ),
                          ),
                        );
                      },
                      onSickIndicatorTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlantCareScreen(plantDetails: plants[index]),
                          ),
                        );

                      },
                      onDeletePressed: () async {
                        await _showDeleteConfirmationDialog(index);
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
