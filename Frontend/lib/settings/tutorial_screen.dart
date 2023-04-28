import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class TutorialsPage extends StatelessWidget {
  const TutorialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutorials'),
        backgroundColor: Consts.primaryColor,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: tutorialList.length,
        itemBuilder: (context, index) {
          final tutorial = tutorialList[index];
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              onTap: () async {
                if (tutorial.link.isEmpty || !Uri.parse(tutorial.link).isAbsolute) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid or empty URL please contact support')),
                  );
                } else {
                    try {
                      await launch(tutorial.link);
                    } on Exception {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Cannot open the link')),
                      );
                    }
                }
              },

              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        tutorial.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 16),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tutorial.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            tutorial.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    ),
                  ],
                ),

              ),
            ),
          );
        },
      ),
    );
  }
}

class Tutorial {
  final String title;
  final String description;
  final String imageUrl;
  final String link;

  Tutorial({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.link,
  });
}

List<Tutorial> tutorialList = [
  Tutorial(
    title: 'How to Water Your Plants',
    description: 'Learn the proper techniques for watering your plants.',
    imageUrl: 'https://floweraura-blog-img.s3.ap-south-1.amazonaws.com/Plants+Dec-19-Dec-20/water-the-soil-of-plants.jpg',
    link: 'https://www.longfield-gardens.com/article/how-to-water-your-plants'
  ),
  Tutorial(
    title: 'Understanding Plant Light Requirements',
    description: 'Discover how to provide the right amount of light for your plants.',
    imageUrl: 'https://bloomscape.com/wp-content/uploads/2021/05/Bloomscape-plant-light-guide-east-facing-window-1024x683.jpg',
    link: 'https://www.thespruce.com/understanding-plant-light-requirements-1902773'
  ),
  Tutorial(
    title: 'Fertilizing Your Plants',
    description: 'Find out the best practices for fertilizing your plants.',
    imageUrl: 'https://www.backyardboss.net/wp-content/uploads/2022/06/byb-fertilize.jpg',
    link: 'https://www.thespruce.com/fertilizing-your-plants-1902774'
  ),
  Tutorial(
    title: 'Pruning and Trimming Your Plants',
    description: 'Learn how to properly prune and trim your plants for healthy growth.',
    imageUrl: 'https://www.thespruce.com/thmb/B5HTIBllSvL9B1kJOAbBOQpIjYU=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/how-and-when-to-prune-plants-1403009_v4-34653a77929249f48dc96cd971af7411.png',
    link: 'https://www.thespruce.com/how-and-when-to-prune-plants-1403009'
  ),
  Tutorial(
    title: 'Identifying and Treating Plant Pests',
    description: 'Discover how to identify and treat common plant pests.',
    imageUrl: 'https://smartgardenguide.com/wp-content/uploads/2020/01/common-houseplant-pests-2-783x522.jpg',
    link: 'https://smartgardenguide.com/common-houseplant-pests/'
  ),
  Tutorial(
    title: 'Proper Soil Mix for Your Plants',
    description: 'Find out the right soil mix for your plants\' needs.',
    imageUrl: 'https://www.planetnatural.com/wp-content/uploads/2012/12/potting-mix1.jpg',
    link: 'https://www.planetnatural.com/soil-mix-recipe/'
  ),
  Tutorial(
    title: 'Propagation Techniques for Houseplants',
    description: 'Learn how to propagate your favorite houseplants.',
    imageUrl: 'https://www.skh.com/wp-content/uploads/2021/01/image6.jpg',
    link: 'https://www.patchplants.com/gb/en/read/plant-care/how-to-propagate-houseplants/'

  ),
  Tutorial(
    title: 'The Basics of Indoor Composting',
    description: 'Discover the basics of indoor composting for your plants.',
    imageUrl: 'https://cdn.shopify.com/s/files/1/0569/9675/7697/articles/compost-bin-indoors.jpg?v=1647966671',
    link: 'https://lomi.com/blogs/news/indoor-composting'
  ),
];

