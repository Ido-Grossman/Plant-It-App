import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/plant_info.dart';
import 'package:frontend/service/http_service.dart';
import 'package:google_fonts/google_fonts.dart';

import '../forum/forum_main_screen.dart';
import '../models/plant_details.dart';

class PlantDetailsScreen extends StatelessWidget {
  final PlantInfo plantInfo;
  final String? token;
  final String email;

  const PlantDetailsScreen(
      {Key? key,
      required this.plantInfo,
      required this.token,
      required this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Theme.of(context);
    Color textColor = currentTheme.brightness == Brightness.light
        ? Consts.primaryColor
        : Consts.greenDark;

    String commonNames = plantInfo.common.join(', ');
    String howToUse = plantInfo.use.join(', ');
    String temperatureRange =
        '${plantInfo.minCelsius}°C - ${plantInfo.maxCelsius}°C (${plantInfo.minFahrenheit}°F - ${plantInfo.maxFahrenheit}°F)';
    String wateringFrequency = 'Every ${plantInfo.waterDuration} days';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(plantInfo.plantPhoto, fit: BoxFit.cover),
            ),
            SizedBox(height: 16),
            Text(
              plantInfo.latin,
              style: GoogleFonts.pacifico(fontSize: 28, color: textColor),
            ),
            SizedBox(height: 8),
            Text(
              'Common Names: $commonNames',
              style: GoogleFonts.lato(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Plant Family: ${plantInfo.family}',
              style: GoogleFonts.lato(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Light',
              style: GoogleFonts.robotoSlab(fontSize: 22, color: textColor),
            ),
            SizedBox(height: 4),
            Text(
              '${plantInfo.toleratedlight} (Tolerated), ${plantInfo.idealight} (Ideal)',
              style: GoogleFonts.lato(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'How to Water',
              style: GoogleFonts.robotoSlab(fontSize: 22, color: textColor),
            ),
            SizedBox(height: 4),
            Text(
              plantInfo.watering,
              style: GoogleFonts.lato(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'How to Use',
              style: GoogleFonts.robotoSlab(fontSize: 22, color: textColor),
            ),
            SizedBox(height: 4),
            Text(
              howToUse,
              style: GoogleFonts.lato(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Temperature Range',
              style: GoogleFonts.robotoSlab(fontSize: 22, color: textColor),
            ),
            SizedBox(height: 4),
            Text(
              temperatureRange,
              style: GoogleFonts.lato(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Watering Frequency',
              style: GoogleFonts.robotoSlab(fontSize: 22, color: textColor),
            ),
            SizedBox(height: 4),
            Text(
              wateringFrequency,
              style: GoogleFonts.lato(fontSize: 18),
            ),
          ],
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
                  builder: (context) => ForumScreen(plantId: plantInfo.id),
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
          SizedBox(width: 8), // Add some space between the buttons
          SizedBox(
            width: 130, // Adjust the width to your preference
            height: 48, // Adjust the height to your preference
            child: FloatingActionButton.extended(
              onPressed: () async {
                TextEditingController nicknameController = TextEditingController();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Enter a nickname for the plant'),
                      content: TextField(
                        controller: nicknameController,
                        decoration: InputDecoration(hintText: 'Nickname'),
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
                              int statusCode =
                              await addPlantToList(email, token!, plantInfo.id, nickname);
                              if (statusCode == 201) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Plant added to list'),
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
              backgroundColor: textColor,
              label: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Text("Add to List"),
              ),
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),


    );
  }
}
