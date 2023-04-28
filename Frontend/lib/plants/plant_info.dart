import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/PlantDetails.dart';

class PlantDetailsScreen extends StatelessWidget {
  final PlantDetails plantDetails;

  const PlantDetailsScreen({Key? key, required this.plantDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Theme.of(context);
    Color textColor = currentTheme.brightness == Brightness.light
        ? Consts.primaryColor
        : Consts.greenDark;

    String commonNames = plantDetails.common.join(', ');
    String howToUse = plantDetails.use.join(', ');
    String temperatureRange =
        '${plantDetails.minCelsius}°C - ${plantDetails.maxCelsius}°C (${plantDetails.minFahrenheit}°F - ${plantDetails.maxFahrenheit}°F)';
    String wateringFrequency = 'Every ${plantDetails.waterDuration} days';

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
              child: Image.network(plantDetails.plantPhoto, fit: BoxFit.cover),
            ),
            SizedBox(height: 16),
            Text(
              plantDetails.latin,
              style: GoogleFonts.pacifico(fontSize: 28, color: textColor),
            ),
            SizedBox(height: 8),
            Text(
              'Common Names: $commonNames',
              style: GoogleFonts.lato(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Plant Family: ${plantDetails.family}',
              style: GoogleFonts.lato(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Light',
              style: GoogleFonts.robotoSlab(fontSize: 22, color: textColor),
            ),
            SizedBox(height: 4),
            Text(
              '${plantDetails.toleratedLight} (Tolerated), ${plantDetails.idealLight} (Ideal)',
              style: GoogleFonts.lato(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'How to Water',
              style: GoogleFonts.robotoSlab(fontSize: 22, color: textColor),
            ),
            SizedBox(height: 4),
            Text(
              plantDetails.watering,
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
