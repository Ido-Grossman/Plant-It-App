import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:google_fonts/google_fonts.dart'; // Import the Google Fonts package
import '../models/PlantDetails.dart';

class PlantCareScreen extends StatefulWidget {
  final PlantDetails plantDetails;

  PlantCareScreen({required this.plantDetails});

  @override
  _PlantCareScreenState createState() => _PlantCareScreenState();
}

class _PlantCareScreenState extends State<PlantCareScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Consts.primaryColor,
        title: Text(
          widget.plantDetails.common[0],
          style: GoogleFonts.openSans(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  widget.plantDetails.plantPhoto,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "How to care for your ${widget.plantDetails.common[0]}",
                style: GoogleFonts.openSans(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                "Ideal Lighting Conditions:",
                style: GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(widget.plantDetails.idealLight, style: GoogleFonts.openSans(fontSize: 16)),
              SizedBox(height: 8),
              Text(
                "Watering Instructions:",
                style: GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(widget.plantDetails.watering, style: GoogleFonts.openSans(fontSize: 16)),
              SizedBox(height: 8),
              Text(
                "Disease:",
                style: GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(widget.plantDetails.disease, style: GoogleFonts.openSans(fontSize: 16)),
              SizedBox(height: 8),
              Text(
                "Disease Care:",
                style: GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(widget.plantDetails.care, style: GoogleFonts.openSans(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
