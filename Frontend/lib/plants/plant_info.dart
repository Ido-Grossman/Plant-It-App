import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class PlantDetailsScreen extends StatelessWidget {
  final String imageUrl;
  final String plantName;
  final String commonNames;
  final String plantFamily;
  final String light;
  final String howToWater;
  final String howToUse;
  final String temperatureRange;
  final String wateringFrequency;

  const PlantDetailsScreen({
    Key? key,
    required this.imageUrl,
    required this.plantName,
    required this.commonNames,
    required this.plantFamily,
    required this.light,
    required this.howToWater,
    required this.howToUse,
    required this.temperatureRange,
    required this.wateringFrequency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Theme.of(context);
    Color textColor = currentTheme.brightness == Brightness.light
        ? Consts.primaryColor
        : Consts.greenDark;
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
              child: Image.network(imageUrl, fit: BoxFit.cover),
            ),
            SizedBox(height: 16),
            Text(
              plantName,
              style: GoogleFonts.pacifico(fontSize: 28, color: textColor),
            ),
            SizedBox(height: 8),
            Text(
              'Common Names: $commonNames',
              style: GoogleFonts.lato(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Plant Family: $plantFamily',
              style: GoogleFonts.lato(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Light',
              style: GoogleFonts.robotoSlab(fontSize: 22, color: textColor),
            ),
            SizedBox(height: 4),
            Text(
              light,
              style: GoogleFonts.lato(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'How to Water',
              style: GoogleFonts.robotoSlab(fontSize: 22, color: textColor),
            ),
            SizedBox(height: 4),
            Text(
              howToWater,
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
      floatingActionButton: SizedBox(
        width: 130, // Adjust the width to your preference
        height: 48, // Adjust the height to your preference
        child: FloatingActionButton.extended(
          onPressed: () {
            // Add your logic for adding the plant to the list
          },
          backgroundColor: textColor,
          label: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: Text("Add to List"),
          ),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}
