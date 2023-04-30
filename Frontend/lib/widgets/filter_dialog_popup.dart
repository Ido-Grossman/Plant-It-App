

import 'package:flutter/material.dart';

import '../menu/search_screen.dart';

class FilterDialogContent extends StatefulWidget {
  final Function onReset;
  const FilterDialogContent({super.key, required this.onReset});

  @override
  FilterDialogContentState createState() => FilterDialogContentState();
}

class FilterDialogContentState extends State<FilterDialogContent> {
  String? selectedCategory;
  String? selectedClimate;
  String? selectedUse;
  TextEditingController minTempController = TextEditingController();
  TextEditingController maxTempController = TextEditingController();

  void resetFilters() {
    setState(() {
      selectedCategory = null;
      selectedClimate = null;
      selectedUse = null;
      minTempController.clear();
      maxTempController.clear();
    });
    widget.onReset();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.minPositive,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          // Category dropdown
          Text("Category"),
          DropdownButton<String>(
            value: selectedCategory,
            isExpanded: true,
            onChanged: (String? newValue) {
              setState(() {
                selectedCategory = newValue;
              });
            },
            items: categories.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),

          // Climate dropdown
          Text("Climate"),
          DropdownButton<String>(
            value: selectedClimate,
            isExpanded: true,
            onChanged: (String? newValue) {
              setState(() {
                selectedClimate = newValue;
              });
            },
            items: climates.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),

          // Use dropdown
          Text("Use"),
          DropdownButton<String>(
            value: selectedUse,
            isExpanded: true,
            onChanged: (String? newValue) {
              setState(() {
                selectedUse = newValue;
              });
            },
            items: uses.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),

          // Min temperature
          Text("Minimum Temperature (°C)"),
          TextField(
            controller: minTempController,
            keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
            decoration: InputDecoration(
              hintText: "Enter min temperature",
            ),
          ),

          // Max temperature
          Text("Maximum Temperature (°C)"),
          TextField(
            controller: maxTempController,
            keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
            decoration: InputDecoration(
              hintText: "Enter max temperature",
            ),
          ),
        ],
      ),
    );
  }
}
