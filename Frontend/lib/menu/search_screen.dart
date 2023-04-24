import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';

// Define your constants and options here.
List<String> categories = ['Indoor', 'Outdoor', 'Succulents', 'Cacti'];
List<String> climates = ['Tropical', 'Arid', 'Temperate', 'Mediterranean'];
List<String> uses = ['Ornamental', 'Medicinal', 'Edible', 'Air-Purifying'];
RangeValues tempRange = RangeValues(0, 120);

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? selectedCategory;
  String? selectedClimate;
  String? selectedUse;
  double? minTemperature;
  double? maxTemperature;

  TextEditingController minTempController = TextEditingController();
  TextEditingController maxTempController = TextEditingController();

  Widget _buildFilterDropdown(
      String label,
      List<String> items,
      String? selectedItem,
      void Function(String? newValue) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedItem,
              items: items
                  .map((item) => DropdownMenuItem<String>(
                child: Text(item),
                value: item,
              ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }



  AlertDialog _buildFilterDialog() {
    return AlertDialog(
      title: Text(
        'Filter options',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.green[800],
        ),
      ),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            width: double.minPositive,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                _buildFilterDropdown('Category', categories, selectedCategory, (newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                }),
                SizedBox(height: 10),
                _buildFilterDropdown('Climate', climates, selectedClimate, (newValue) {
                  setState(() {
                    selectedClimate = newValue;
                  });
                }),
                SizedBox(height: 10),
                _buildFilterDropdown('Use', uses, selectedUse, (newValue) {
                  setState(() {
                    selectedUse = newValue;
                  });
                }),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Temperature Range",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 50,
                              child: TextField(
                                controller: minTempController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "Min",
                                  contentPadding: EdgeInsets.symmetric(horizontal: 5),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: Text('°C -', style: TextStyle(fontSize: 14)),
                            ),
                            SizedBox(
                              width: 50,
                              child: TextField(
                                controller: maxTempController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: "Max",
                                  contentPadding: EdgeInsets.symmetric(horizontal: 5),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            Text('°C', style: TextStyle(fontSize: 14)),
                          ],
                        ),

                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 16,
              color: Colors.red[600],
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            double? minTemp = double.tryParse(minTempController.text);
            double? maxTemp = double.tryParse(maxTempController.text);
            if (minTemp != null && maxTemp != null && minTemp >= maxTemp) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Minimum temperature should be lower than maximum.'),
                  backgroundColor: Colors.red,
                ),
              );
            } else {
              applyFilters(
                selectedCategory,
                selectedClimate,
                selectedUse,
                minTemp,
                maxTemp,
              );
              Navigator.of(context).pop();
            }
          },
          child: Text(
            'Apply',
            style: TextStyle(
              fontSize: 16,
              color: Colors.green[800],
            ),
          ),
        ),
      ],
    );
  }




  void applyFilters(
      String? category,
      String? climate,
      String? use,
      double? minTemp,
      double? maxTemp) {
    setState(() {
      selectedCategory = category;
      selectedClimate = climate;
      selectedUse = use;
      minTemperature = minTemp;
      maxTemperature = maxTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        width: size.width * 0.9,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.black54.withOpacity(.6),
                            ),
                            const Expanded(
                                child: TextField(
                                  showCursor: false,
                                  decoration: InputDecoration(
                                    hintText: "Search for Plants",
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                )),
                            Icon(
                              Icons.mic,
                              color: Colors.black54.withOpacity(.6),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: Consts.primaryColor.withOpacity(.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => _buildFilterDialog(),
                          );
                        },
                        icon: Icon(Icons.filter_list))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
