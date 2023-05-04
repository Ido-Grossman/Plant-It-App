import 'package:flutter/material.dart';

class PlantCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String healthStatus;
  final VoidCallback onPlantTap;
  final VoidCallback onSickIndicatorTap;
  final VoidCallback onDeletePressed;

  PlantCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.healthStatus,
    required this.onPlantTap,
    required this.onSickIndicatorTap,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.25),
                BlendMode.darken,
              ),
            ),
          ),
          child: Stack(
            children: [
              InkWell(
                onTap: onPlantTap,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Positioned(
                bottom: 15,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    GestureDetector(
                      onTap: healthStatus == 'Sick' ? onSickIndicatorTap : null,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: healthStatus == 'Healthy'
                              ? Colors.green
                              : Colors.red,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text(
                          healthStatus,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  onPressed: onDeletePressed,
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }
}
