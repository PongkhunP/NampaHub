import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nampa_hub/mid/activity_services.dart';
import 'package:nampa_hub/src/activity.dart';
import 'package:nampa_hub/src/widget.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ActivityDetailsPage extends StatefulWidget {
  final int activityId;
  const ActivityDetailsPage({super.key, required this.activityId});

  @override
  State<ActivityDetailsPage> createState() => _ActivityDetailsPage();
}

class _ActivityDetailsPage extends State<ActivityDetailsPage> {
  late Future<Activity> futureActivity;

  @override
  void initState() {
    super.initState();
    futureActivity = ActivityService.getActivityDetails(widget.activityId);
  }

  void attendActivity() {}

  void donateActivity() {}

  void editActivity() {}

  void showActivityAdditionDetails({List<String> goals = const []}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Additional Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                goals.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Goals",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: goals.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4),
                                    child: Icon(
                                      Icons.circle,
                                      color: Colors.black,
                                      size: 10,
                                    ),
                                  ),
                                  Text(goals[index])
                                ],
                              );
                            },
                          )
                        ],
                      )
                    : const Text(""),
              ],
            ),
          ),
        );
      },
    );
  }

  double calculatePercent(num? budget, num? maxDonation) {
    if (budget == null || maxDonation == null || maxDonation == 0) {
      return 0.0;
    }
    return (budget / maxDonation).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Logo(),
        ),
        backgroundColor: const Color(0xFF1B8900),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder(
            future: futureActivity,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                FlutterError.reportError(FlutterErrorDetails(
                  exception: snapshot.error!,
                  stack: snapshot.stackTrace,
                  library: 'your_library_name',
                  context: ErrorDescription('Error loading activity data'),
                  informationCollector: () sync* {
                    yield DiagnosticsProperty<AsyncSnapshot>(
                        'Snapshot', snapshot);
                  },
                ));
                return const Center(
                    child: Text('An error occurred. Please try again later.'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No Activity data'));
              } else {
                Activity activity = snapshot.data!;
                Uint8List imageBytes =
                    base64Decode(activity.activityMedia!.base64Image);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    screenWidth < 600
                        ? Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: MemoryImage(imageBytes),
                                    fit: BoxFit.cover, // Adjust as needed
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          activity.title ?? 'Unknow activity',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: editActivity,
                                          icon: const Icon(Icons.edit)),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(activity.activityLocation
                                              ?.eventLocation ??
                                          'Unknown location'),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Donation Goal'),
                                      Container(
                                        width: 220,
                                        decoration: const BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 2))
                                            ]),
                                        child: LinearPercentIndicator(
                                          lineHeight: 30.0,
                                          percent: calculatePercent(
                                              activity.activitySupport?.budget,
                                              activity.activitySupport
                                                  ?.maxDonation),
                                          center: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Text(
                                                "${activity.activitySupport?.budget} / ${activity.activitySupport?.maxDonation} Bath"),
                                          ),
                                          progressColor: const Color.fromARGB(
                                              255, 27, 137, 0),
                                          barRadius: const Radius.circular(5),
                                          backgroundColor: Colors.white,
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      const Text('Participants'),
                                      Container(
                                        width: 150,
                                        decoration: const BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 2))
                                            ]),
                                        child: LinearPercentIndicator(
                                          lineHeight: 30.0,
                                          percent: calculatePercent(
                                              activity.activitySupport
                                                  ?.currentParticipants,
                                              activity.activitySupport
                                                  ?.participants),
                                          center: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Text(
                                                "${activity.activitySupport?.currentParticipants}/${activity.activitySupport?.participants}"),
                                          ),
                                          barRadius: const Radius.circular(5),
                                          progressColor: const Color.fromARGB(
                                              255, 27, 137, 0),
                                          backgroundColor: Colors.white,
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              AttendAndDonateButton(
                                  attendFunction: attendActivity,
                                  donateFunction: donateActivity,
                                  attenFee: 200)
                            ],
                          )
                        : Row(
                            children: [
                              Container(
                                width: 200,
                                height: 200,
                                color: Colors.black,
                                // Replace with your image widget
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            activity.title ??
                                                'Unknown activity',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: editActivity,
                                            icon: const Icon(Icons.edit)),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Text(activity.activityLocation
                                                ?.eventLocation ??
                                            'Unknown location'),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Donation Goal'),
                                        LinearPercentIndicator(
                                          width: 150.0,
                                          lineHeight: 30.0,
                                          percent: calculatePercent(
                                              activity.activitySupport?.budget,
                                              activity.activitySupport
                                                  ?.maxDonation),
                                          center: Text(
                                              "${activity.activitySupport?.budget} / ${activity.activitySupport?.maxDonation} Bath"),
                                          progressColor: Colors.green,
                                          barRadius: const Radius.circular(10),
                                          backgroundColor: Colors.white,
                                          padding: EdgeInsets.zero,
                                        ),
                                        const SizedBox(height: 5),
                                        const Text('Participants'),
                                        LinearPercentIndicator(
                                          width: 150.0,
                                          lineHeight: 30.0,
                                          percent: calculatePercent(
                                              activity.activitySupport
                                                  ?.currentParticipants,
                                              activity.activitySupport
                                                  ?.participants),
                                          center: Text(
                                              "${activity.activitySupport?.currentParticipants}/${activity.activitySupport?.participants}"),
                                          progressColor: Colors.green,
                                          barRadius: const Radius.circular(5),
                                          backgroundColor: Colors.white,
                                          padding: EdgeInsets.zero,
                                        ),
                                      ],
                                    ),
                                    AttendAndDonateButton(
                                        attendFunction: attendActivity,
                                        donateFunction: donateActivity,
                                        attenFee: activity
                                                .activitySupport?.attendFee ??
                                            0)
                                  ],
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Description',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                            onPressed: () {
                              showActivityAdditionDetails(goals: [
                                'Feed the animal',
                                'travel through the international park'
                              ]);
                            },
                            icon:
                                const Icon(Icons.format_list_bulleted_rounded))
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      activity.description ?? 'Unknown description',
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Meeting location',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      activity.activityLocation?.meetLocation ??
                          'Unknown location',
                    ),
                    const SizedBox(height: 40),
                    const Divider(),
                    const SizedBox(height: 20),
                    const Text(
                      'Owner',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ratchanon HeeTad',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                'King Mongkut’s University of Technology Thonburi (KMUTT)',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star_border_outlined,
                                  ),
                                  Text('4.6/5'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class AttendAndDonateButton extends StatefulWidget {
  final double attenFee;
  final VoidCallback attendFunction;
  final VoidCallback donateFunction;
  const AttendAndDonateButton(
      {super.key,
      required this.attendFunction,
      required this.donateFunction,
      required this.attenFee});

  @override
  State<AttendAndDonateButton> createState() => _AttendAndDonateButtonState();
}

class _AttendAndDonateButtonState extends State<AttendAndDonateButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 15),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: widget.attendFunction,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B8900),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              '${widget.attenFee} bath/person',
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(width: 20),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                color: const Color(0xFF1797BF), // Your border color
                width: 2.0, // Border width
              ),
            ),
            child: ElevatedButton(
              onPressed: widget.donateFunction,
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFF1797BF),
                backgroundColor:
                    Colors.white, // Ensure background color is white
                padding: const EdgeInsets.all(18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Donate',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
