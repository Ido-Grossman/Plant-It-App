

import 'package:flutter/material.dart';

class PlantCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String healthStatus;
  final VoidCallback onPlantTap;
  final VoidCallback onSickIndicatorTap;

  PlantCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.healthStatus,
    required this.onPlantTap,
    required this.onSickIndicatorTap,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onPlantTap,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(imageUrl),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: InkWell(
                    onTap: healthStatus == 'Sick' ? onSickIndicatorTap : null,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: healthStatus == 'Healthy' ? Colors.green : Colors.red,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      child: Text(
                        healthStatus,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
