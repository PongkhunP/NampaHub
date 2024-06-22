import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nampa_hub/pages/activity_details_page.dart';
import 'package:nampa_hub/pages/create_activity_one_page.dart';
import 'package:nampa_hub/pages/profile_page.dart';
import 'package:nampa_hub/src/activity.dart';
import 'package:nampa_hub/src/widget.dart';
import '../mid/activity_services.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String currentFilter = 'Marine';
  late Future<List<ActivityListItem>> futureActivities;

  @override
  void initState() {
    super.initState();
    futureActivities = ActivityService.getActivities(currentFilter);
  }

  void setFilter(String option) {
    setState(() {
      currentFilter = option;
      futureActivities = ActivityService.getActivities(currentFilter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(flex: 3),
            const Center(child: Logo()),
            const Spacer(flex: 2),
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: ElevatedButton(
                      onPressed: () {
                        setFilter('Marine');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1797BF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Water',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: ElevatedButton(
                      onPressed: () {
                        setFilter('Forest');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B8900),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Forest',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: ElevatedButton(
                      onPressed: () {
                        setFilter('Other');
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return const Color(
                                  0xFFB0B0B0); // Color when pressed
                            }
                            return const Color(0xFFE0E0E0); // Default color
                          },
                        ),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.black, width: 2),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Other',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return const CreateActivityOnePage();
                                    // return const CreateActivityOnePage();
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
            ),
            const SizedBox(height: 15),
            Expanded(
              child: FutureBuilder<List<ActivityListItem>>(
                future: futureActivities,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No activities found'));
                  } else {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Found ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Colors.black, // Text color set to black
                                  ),
                                ),
                                Text(
                                  '${snapshot.data?.length} ${snapshot.data?.length == 1 ? 'Activity' : 'Activities'}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Colors.green, // Text color set to green
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                        const SizedBox(
                          height: 20,
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
                                itemCount: (snapshot.data!.length / itemsPerRow)
                                    .ceil(),
                                itemBuilder: (BuildContext context, int index) {
                                  int startIndex = index * itemsPerRow;
                                  int endIndex =
                                      (index * itemsPerRow + itemsPerRow)
                                          .clamp(0, snapshot.data!.length);

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: List.generate(
                                        endIndex - startIndex,
                                        (subIndex) {
                                          ActivityListItem activity = snapshot
                                              .data![startIndex + subIndex];
                                          Uint8List imageBytes = base64Decode(
                                              activity
                                                  .activityMedia.base64Image);
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                  builder: (context) {
                                                    return ActivityDetailsPage(
                                                        activityId:
                                                            activity.id);
                                                  },
                                                ));
                                              },
                                              child: ActivityCard(
                                                activityName: activity.title,
                                                location:
                                                    activity.eventLocation,
                                                imageBytes:
                                                    imageBytes, // Pass the decoded image bytes
                                                cardHeight: height,
                                                cardWidth: width,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
