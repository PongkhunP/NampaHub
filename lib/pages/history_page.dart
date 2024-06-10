import 'package:flutter/material.dart';
import 'package:nampa_hub/src/widget.dart';

class MyHistoryPage extends StatefulWidget {
  const MyHistoryPage({super.key});

  @override
  MyHistoryPageState createState() => MyHistoryPageState();
}

class MyHistoryPageState extends State<MyHistoryPage> {
  String? _activeButtonLabel;

  final List<String> activityNames = [
    'Beach Cleanup',
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

  final List<String> participations = [
    '12/20',
    '10/15',
    '5/10',
    '18/25',
    '8/12',
    '14/20',
  ];

  final List<String> statuses = [
    'On going',
    'Success',
    'Success',
    'Canceled',
    'On going',
    'Created',
  ];
  @override
  void initState() {
    super.initState();
    _activeButtonLabel =
        'On going'; // Automatically select 'On going' on page load
  }

  List<int> getFilteredIndexes() {
    if (_activeButtonLabel == null) {
      return List<int>.generate(activityNames.length, (index) => index);
    }
    return List<int>.generate(activityNames.length, (index) => index)
        .where((index) => statuses[index] == _activeButtonLabel)
        .toList();
  }

  void _onButtonPressed(String label) {
    setState(() {
      _activeButtonLabel = label;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<int> filteredIndexes = getFilteredIndexes();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Logo(),
        ),
        backgroundColor: const Color(0xFF1B8900),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CustomButton(
                    label: 'On going',
                    isActive: _activeButtonLabel == 'On going',
                    onPressed: () => _onButtonPressed('On going'),
                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    label: 'Success',
                    isActive: _activeButtonLabel == 'Success',
                    onPressed: () => _onButtonPressed('Success'),
                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    label: 'Canceled',
                    isActive: _activeButtonLabel == 'Canceled',
                    onPressed: () => _onButtonPressed('Canceled'),
                  ),
                  const SizedBox(width: 10),
                  CustomButton(
                    label: 'Created',
                    isActive: _activeButtonLabel == 'Created',
                    onPressed: () => _onButtonPressed('Created'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredIndexes.length,
                itemBuilder: (BuildContext context, int index) {
                  int activityIndex = filteredIndexes[index];
                  return Padding(
                    padding:
                        const EdgeInsets.only(bottom: 16, left: 10, right: 10),
                    child: ActivityHistoryCard(
                      activityName: activityNames[activityIndex],
                      location: locations[activityIndex],
                      participation: participations[activityIndex],
                      status: statuses[activityIndex],
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

class CustomButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.label,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (isActive) {
            return Colors.green;
          }
          return Colors.white;
        }),
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (isActive) {
            return Colors.white;
          }
          return Colors.black;
        }),
        side: MaterialStateProperty.all<BorderSide>(
            const BorderSide(color: Colors.black)),
      ),
      child: Text(label),
    );
  }
}
