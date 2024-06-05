import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nampa_hub/src/widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homepage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home:  MyHomePage(),
    );
  }
}

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
        title: const Center(
          child: Logo(),
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
                    // Add your functionality here
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
              child: ListView.builder(
                itemCount: (activityNames.length / 2).ceil(),
                itemBuilder: (BuildContext context, int index) {
                  int startIndex = index * 2;
                  int endIndex = (index * 2 + 2).clamp(0, activityNames.length);

                 return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        endIndex - startIndex,
                        (subIndex) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ActivityCard(
                            activityName: activityNames[startIndex + subIndex],
                            location: locations[startIndex + subIndex],
                          ),
                        ),
                      ),
                    ),
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