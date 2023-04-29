import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/service/http_service.dart';

import '../models/Plant.dart';
import '../models/PlantDetails.dart';
import '../plants/plant_info.dart';

// Define your constants and options here.
List<String> categories = ['Indoor', 'Outdoor', 'Succulents', 'Cacti'];
List<String> climates = ['Tropical', 'Arid', 'Temperate', 'Mediterranean'];
List<String> uses = ['Ornamental', 'Medicinal', 'Edible', 'Air-Purifying'];

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

  List<Plant> _plants = [];
  ScrollController _scrollController = ScrollController();
  int _offset = 0;
  String _currentQuery = '';


  @override
  void initState() {
    super.initState();
    fetchMorePlants('');
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent / 2) {
        fetchMorePlants(_currentQuery);
      }
    });
  }

  Future<void> fetchMorePlants(String query) async {
    _offset += 1;
    try {
      List<Plant> newPlants = await searchPlants(query, offset: _offset);
      setState(() {
        _plants.addAll(newPlants);
      });
    } catch (e) {
      print('Error fetching more plants: $e');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildFilterDropdown(String label,
      List<String> items,
      String? selectedItem,
      void Function(String? newValue) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
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
                  .map((item) =>
                  DropdownMenuItem<String>(
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
                _buildFilterDropdown(
                    'Category', categories, selectedCategory, (newValue) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                }),
                const SizedBox(height: 10),
                _buildFilterDropdown(
                    'Climate', climates, selectedClimate, (newValue) {
                  setState(() {
                    selectedClimate = newValue;
                  });
                }),
                const SizedBox(height: 10),
                _buildFilterDropdown('Use', uses, selectedUse, (newValue) {
                  setState(() {
                    selectedUse = newValue;
                  });
                }),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Temperature Range",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
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
                                decoration: const InputDecoration(
                                  hintText: "Min",
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 5),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                  '°C -', style: TextStyle(fontSize: 14)),
                            ),
                            SizedBox(
                              width: 50,
                              child: TextField(
                                controller: maxTempController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: "Max",
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 5),
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
                const SnackBar(
                  content: Text(
                      'Minimum temperature should be lower than maximum.'),
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


  void applyFilters(String? category,
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
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: SafeArea(
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
                      decoration: BoxDecoration(
                        color: Consts.primaryColor.withOpacity(.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.black54.withOpacity(.6),
                          ),
                          Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  _offset = 0;
                                  _currentQuery = value;
                                  searchPlants(value, offset: _offset).then((plants) {
                                    setState(() {
                                      _plants = plants;
                                      print(_plants);
                                    });
                                    fetchMorePlants(value);
                                  }).catchError((error) {
                                    print('Error searching plants: $error');
                                  });
                                },
                                showCursor: false,
                                decoration: const InputDecoration(
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
            ),
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: size.height * 0.8),
                child: ListView.builder(
                  itemCount: _plants.length,
                  itemBuilder: (context, index) {
                    Plant plant = _plants[index];
                    return InkWell(
                      onTap: () async {
                        PlantDetails plantDetails;
                        try {
                          plantDetails = await fetchPlantDetails(plant.id);
                        } catch (e) {
                          // Show an error message or handle the exception
                          print("Error fetching plant details: $e");
                          return;
                        }
                        // Navigate to the PlantDetailsScreen with the selected plant details
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlantDetailsScreen(plantDetails: plantDetails,),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: SizedBox(
                            width: 80,
                            height: 100,
                            child: Image.network(
                              plant.plantPhoto,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.error);
                              },
                            ),
                          ),
                          title: Text(
                            plant.common[0] == '' ? plant.latin : plant.common[0],
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: plant.common[0] == ''
                              ? null
                              : Text(
                            plant.latin,
                            style: TextStyle(color: Colors.grey[700], fontSize: 14),
                          ),
                        ),
                      ),
                    );

                  },
                  controller: _scrollController,
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
