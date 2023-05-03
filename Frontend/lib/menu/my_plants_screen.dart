import 'package:flutter/material.dart';

import '../models/Plant.dart';
import '../plants/plant_card_list.dart';

class MyPlants extends StatefulWidget {
  const MyPlants({Key? key}) : super(key: key);

  @override
  State<MyPlants> createState() => _MyPlantsState();
}

class _MyPlantsState extends State<MyPlants> {
  List<Plant> plants = [
    Plant(id: 1, latin: 'Monstera', common: ['Swiss Cheese Plant'], plantPhoto: 'https://cdn.shopify.com/s/files/1/0150/6262/products/the-sill_monstera_variant_medium_hyde_mint_f0e6d601-426c-40fe-abc6-b0a1f4dce17b.jpg?v=1672212220', category: 'Indoor', health: 'Healthy'),
    Plant(id: 2, latin: 'Snake Plant', common: ['Mother-in-Law\'s Tongue'], plantPhoto: 'https://cdn.shopify.com/s/files/1/0150/6262/products/the-sill_monstera_variant_medium_hyde_mint_f0e6d601-426c-40fe-abc6-b0a1f4dce17b.jpg?v=1672212220', category: 'Indoor', health: 'Healthy'),
    Plant(id: 3, latin: 'Pothos', common: ['Devil\'s Ivy'], plantPhoto: 'https://cdn.shopify.com/s/files/1/0150/6262/products/the-sill_monstera_variant_medium_hyde_mint_f0e6d601-426c-40fe-abc6-b0a1f4dce17b.jpg?v=1672212220', category: 'Indoor', health: 'Sick'),
    Plant(id: 4, latin: 'Spider Plant', common: ['Airplane Plant'], plantPhoto: 'https://cdn.shopify.com/s/files/1/0150/6262/products/the-sill_monstera_variant_medium_hyde_mint_f0e6d601-426c-40fe-abc6-b0a1f4dce17b.jpg?v=1672212220', category: 'Indoor', health: 'Healthy'),
    Plant(id: 5, latin: 'ZZ Plant', common: ['Zanzibar Gem'], plantPhoto: 'https://cdn.shopify.com/s/files/1/0150/6262/products/the-sill_monstera_variant_medium_hyde_mint_f0e6d601-426c-40fe-abc6-b0a1f4dce17b.jpg?v=1672212220', category: 'Indoor', health: 'Sick'),
    Plant(id: 6, latin: 'Fiddle Leaf Fig', common: ['Banjo Fig'], plantPhoto: 'https://cdn.shopify.com/s/files/1/0150/6262/products/the-sill_monstera_variant_medium_hyde_mint_f0e6d601-426c-40fe-abc6-b0a1f4dce17b.jpg?v=1672212220', category: 'Indoor', health: 'Healthy'),
  ];

  @override
  Widget build(BuildContext context) {
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
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemCount: plants.length,
        itemBuilder: (context, index) {
          return PlantCard(
            imageUrl: plants[index].plantPhoto,
            name: plants[index].common[0],
            healthStatus: plants[index].health,
            onPlantTap: () {
              // Navigate to plant info page
            },
            onSickIndicatorTap: () {
              // Show popup with plant care instructions
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the plant addition screen
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
