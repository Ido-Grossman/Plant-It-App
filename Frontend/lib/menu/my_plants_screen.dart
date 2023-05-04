import 'package:frontend/constants.dart';
import 'package:frontend/service/http_service.dart';

import '../models/PlantDetails.dart';
import '../models/plant_info.dart';
import '../plants/plant_card_list.dart';
import '../plants/plant_info_screen.dart';
import 'package:flutter/material.dart';

final _floatingActionButtonTag = UniqueKey();

class MyPlants extends StatefulWidget {
  final VoidCallback onNavigateAway;
  final ValueNotifier<bool> refreshNotifier;
  final String email;
  final String? token;
  const MyPlants({Key? key, required this.email, required this.token, required this.refreshNotifier, required this.onNavigateAway}) : super(key: key);

  @override
  State<MyPlants> createState() => _MyPlantsState();
}

class _MyPlantsState extends State<MyPlants>  {
  List<PlantDetails> plants = [];

  @override
  void initState() {
    super.initState();
    _fetchAndSetPlants();
  }

  Future<void> _fetchAndSetPlants() async {
    try {
      List<PlantDetails> fetchedPlants = await fetchMyPlants(widget.email, widget.token);
      setState(() {
        plants = fetchedPlants;
      });
    } catch (e) {
      print(e);
    }
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                healthStatus: plants[index].disease['disease'],
                onPlantTap: () async {
                  PlantInfo plantInfo;
                  try {
                    plantInfo = await fetchPlantInfo(plants[index].id);
                  } catch (e) {
                    // Show an error message or handle the exception
                    print("Error fetching plant details: $e");
                    return;
                  }
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
                  // Show popup with plant care instructions
                },
                onDeletePressed: () async {
                  int statusCode = await deletePlantFromList(widget.email, widget.token, plants[index].idToDelete);
                  if (statusCode == 204){
                    setState(() {
                      _fetchAndSetPlants();
                    });
                  } else {
                    Consts.alertPopup(context, 'Error Could not delete plant. Please try again.');
                  }
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: _floatingActionButtonTag,
            onPressed: () {
              // Navigate to the plant addition screen
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
