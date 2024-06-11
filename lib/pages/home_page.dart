import 'package:flutter/material.dart';
import 'package:nampa_hub/pages/activity_details_page.dart';
import 'package:nampa_hub/pages/create_activity_one_page.dart';
import 'package:nampa_hub/pages/profile_page.dart';
import 'package:nampa_hub/src/widget.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final List<String> activityNames = [
    'Beach Bitch',
    'Mountain Hiking',
    'Forest Trek',
    'Wildlife Safari',
    'River Rafting',
    'Cave Exploration',
  ];

  final List<String> locations = [
    'Phuket',
    'Rocky Mountains',
    'Pacific Northwest',
    'Serengeti',
    'Colorado River',
    'Carlsbad Caverns',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(
              flex: 3,
            ),
            const Center(
              child: Logo(),
            ),
            const Spacer(
              flex: 2,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const MyProfilePage();
                  },
                ));
              },
              child: const Icon(Icons.person),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1B8900),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              // controller: _textController,
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(1),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1797BF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Water',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B8900),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Forest',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Text(
                      'Found ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Text color set to black
                      ),
                    ),
                    Text(
                      '5,000 Activities',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green, // Text color set to green
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const CreateActivityOnePage();
                      },
                    ));
                  },
                  icon: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 15,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double height = 230;
                  double width = 180;
                  int itemsPerRow = 2;

                  if (constraints.maxWidth < 600) {
                    height = 250;
                    width = 300;
                    itemsPerRow = 1;
                  }

                  return ListView.builder(
                    itemCount: (activityNames.length / itemsPerRow).ceil(),
                    itemBuilder: (BuildContext context, int index) {
                      int startIndex = index * itemsPerRow;
                      int endIndex = (index * itemsPerRow + itemsPerRow)
                          .clamp(0, activityNames.length);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            endIndex - startIndex,
                            (subIndex) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return const ActivityDetailsPage();
                                    },
                                  ));
                                },
                                child: ActivityCard(
                                  activityName:
                                      activityNames[startIndex + subIndex],
                                  location: locations[startIndex + subIndex],
                                  cardHeight: height,
                                  cardWidth: width,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
