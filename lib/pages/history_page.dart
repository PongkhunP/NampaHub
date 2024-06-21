import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nampa_hub/mid/token_manager.dart';
import 'package:nampa_hub/src/activity.dart';
import 'package:nampa_hub/src/config.dart';
import 'package:nampa_hub/src/widget.dart';
import 'package:http/http.dart' as http;

class MyHistoryPage extends StatefulWidget {
  const MyHistoryPage({super.key});

  @override
  MyHistoryPageState createState() => MyHistoryPageState();
}

class MyHistoryPageState extends State<MyHistoryPage> {
  String? _activeButtonLabel;
  Future<List<ActivityListItem>>? _futureHistory;

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
    'On-going',
    'Success',
    'Success',
    'Canceled',
    'On going',
    'Created',
  ];
  @override
  void initState() {
    super.initState();
    _activeButtonLabel = 'On-going';
    _futureHistory = getHistory();
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
      _futureHistory = getHistory();
    });
  }

  Future<List<ActivityListItem>> getHistory() async {
    try {
      final token = await TokenManager.getToken();

      if (token == null) {
        throw Exception("token Invalid please try again!");
      }

      final url = '$gethistory?status=$_activeButtonLabel';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);
        if (body['status'] == true) {
          List<dynamic> activitiesJson = body['success'];
          return activitiesJson.map((dynamic activity) => ActivityListItem.fromJson(activity)).toList();
        }
        else {
        throw Exception('Failed to load activities: ${body['message']}');
        }
      } 
      else {
      throw Exception('Failed to load activities');
    }
    } catch (e) {
      throw e;
    }
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
                    label: 'On-going',
                    isActive: _activeButtonLabel == 'On-going',
                    onPressed: () => _onButtonPressed('On-going'),
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
            SingleChildScrollView(
              child: FutureBuilder(
                future: getHistory(),
                builder: (context, activitys) {
                  if(activitys.hasError){
                    return Text("Error : ${activitys.error}");
                  }
                  else if(activitys.connectionState == ConnectionState.waiting){
                    return const Center(
                      child : CircularProgressIndicator(),
                    );
                  }
                  else if(!activitys.hasData){
                    return const Text("No Activity found.");
                  }
                  else{
                    List<ActivityListItem> activityList = activitys.data!;
                    return  ListView.builder(
                      shrinkWrap: true,
                  itemCount: activityList.length,
                  itemBuilder: (BuildContext context, int index) {
                    
                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: 16, left: 10, right: 10),
                      child: ActivityHistoryCard(
                       activity: activityList[index],
                      ),
                    );
                  },
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
