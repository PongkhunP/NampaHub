import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:nampa_hub/mid/activity_services.dart';
import 'package:nampa_hub/mid/token_manager.dart';
import 'package:nampa_hub/pages/donation.dart';
import 'package:nampa_hub/pages/edit_activities_page.dart';
import 'package:nampa_hub/pages/payment_services_test.dart';
import 'package:nampa_hub/src/activity.dart';
import 'package:nampa_hub/src/config.dart';
import 'package:nampa_hub/src/user.dart';
import 'package:nampa_hub/src/widget.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:http/http.dart' as http;

class ActivityDetailsPage extends StatefulWidget {
  final int activityId;
  const ActivityDetailsPage({super.key, required this.activityId});

  @override
  State<ActivityDetailsPage> createState() => _ActivityDetailsPage();
}

class _ActivityDetailsPage extends State<ActivityDetailsPage> {
  late Future<Map<String, dynamic>> futureActivity;
  late Future<List<Attendee>> futureAttendee;
  Map<int, bool> _attendanceChecked = {};

  double _rating = 0;
  bool submitted = false;
  Future<void> _submitRating(double rating) async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        print('User not authenticated');
        return;
      }

      final response = await http.patch(
        Uri.parse(updateuserrating),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'activity_id': widget.activityId,
          'rating': rating,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print("Rating submitted successfully");
        setState(() {
          _rating = rating;
          submitted = true;
        });
      } else {
        print("Failed to submit rating: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error submitting rating: $e");
      if (e is http.ClientException) {
        print("Network error: ${e.message}");
      } else if (e is FormatException) {
        print("Error parsing response: ${e.message}");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    futureActivity = ActivityService.getActivityDetails(widget.activityId);
    futureAttendee = ActivityService.getAttendees(widget.activityId);
    futureAttendee.then((attendees) {
      setState(() {
        for (var attendee in attendees) {
          _attendanceChecked[attendee.id] = attendee.isParticipate;
        }
      });
    });
  }

  bool isDateOutdated(DateTime date) {
    DateTime currentDate = DateTime.now();

    return date.isBefore(currentDate);
  }

  void attendActivity(double attendFee) {
    if (attendFee != 0) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return PayPalPayment(
            attendFee: attendFee,
          );
        },
      ));
      // ActivityService.attendActivity(context, widget.activityId);
    } else {
      ActivityService.attendActivity(context, widget.activityId);
    }
  }

  void donateActivity() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return MyDonation();
      },
    ));
  }

  void editActivity(Activity activity) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return EditActivityPage(
          activity: activity,
        );
      },
    ));
  }

  void showActivityAdditionDetails(
      {required BuildContext context,
      List<String> goals = const [],
      List<ActivityExpense> expenses = const [],
      List<ActivityReward> reward = const [],
      bool isOwner = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Additional Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (goals.isNotEmpty) ...[
                  const Text(
                    "Goals",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: goals.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(
                                Icons.circle,
                                color: Colors.black,
                                size: 10,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                goals[index],
                                softWrap: true,
                                maxLines: null,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
                if (expenses.isNotEmpty) ...[
                  const Text(
                    "Expenses",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Table(
                      border: TableBorder.all(
                          color: const Color.fromARGB(31, 245, 219, 219)),
                      children: expenses.map((e) {
                        return TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(e.name!),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                Text('${e.expense!.toStringAsFixed(0)} Bath'),
                          )
                        ]);
                      }).toList(),
                    ),
                  ),
                ],
                if (reward.isNotEmpty) ...[
                  const Text(
                    "Reward",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: reward.length,
                    itemBuilder: (context, index) {
                      return RewardItem(reward: reward[index]);
                    },
                  ),
                ],
                const Text(
                  "Attendance",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                FutureBuilder<List<Attendee>>(
                  future: futureAttendee,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text(
                          'There are no one attend to this activity yet');
                    } else {
                      if (_attendanceChecked.isEmpty) {
                        for (var attendee in snapshot.data!) {
                          _attendanceChecked[attendee.id] =
                              attendee.isParticipate;
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Table(
                          border: TableBorder.all(color: Colors.black12),
                          children: [
                            TableRow(children: [
                              if (isOwner)
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Attendance',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('First Name',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Last Name',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Phone',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ]),
                            ...snapshot.data!.map((attendee) {
                              return TableRow(children: [
                                if (isOwner)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Checkbox(
                                      value: _attendanceChecked[attendee.id],
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _attendanceChecked[attendee.id] =
                                              value!;
                                        });
                                      },
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(attendee.firstName),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(attendee.lastName),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(attendee.phone),
                                ),
                              ]);
                            }),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            if (isOwner && _attendanceChecked.isNotEmpty) ...[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () async {
                  await ActivityService.checkIn(
                      widget.activityId, _attendanceChecked);
                  print('Confirmed attendance: $_attendanceChecked');
                  Navigator.of(context).pop();
                },
                child: const Text('Confirm'),
              ),
            ],
          ],
        );
      },
    );
  }

  void showOwnerInformation(User user) { // Declare _rating to store user's rating

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text(
              'Activity Owner',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 16),
                    child: Container(
                      height: 100,
                      width: 100,
                      color: Colors.red,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    child: Text(
                      '${user.firstname} ${user.middlename} ${user.lastname}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  if (user.companyName.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Text(
                        'Company : ${user.companyName}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                  if (user.instituteName.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Text(
                        'Institute : ${user.instituteName}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    child: Text(
                      'Phone : ${user.phone}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Email : ',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          user.email,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    child: Text(
                      'Location : ${user.country}, ${user.city}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => IconButton(
                          icon: Icon(
                            index < (_rating ?? 0)
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: () {
                            setState(() {
                              _rating = index + 1.toDouble();
                            });
                            print('Selected rating: $_rating');
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                       if(_rating != null){
                          _submitRating(_rating);
                          print('Successfully updated send ! :${_submitRating(_rating)}');
                         Navigator.of(context).pop();
                       }
                      },
                      child: Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
                final activity = snapshot.data!['activity'] as Activity;
                final user = snapshot.data!['user'] as User;
                final isOwner = snapshot.data!['is_owner'];

                Uint8List imageBytes =
                    base64Decode(activity.activityMedia!.base64Image);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    screenWidth < 600
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                      isOwner
                                          ? IconButton(
                                              onPressed: () {
                                                editActivity(activity);
                                              },
                                              icon: const Icon(Icons.edit))
                                          : const SizedBox(),
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
                              isOwner
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        onPressed: null,
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor:
                                              const Color(0xFF1797BF),
                                          backgroundColor: const Color(
                                              0xFF1B8900), // Ensure background color is white
                                          padding: const EdgeInsets.all(18),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text(
                                          'Start',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    )
                                  : AttendAndDonateButton(
                                      attendFunction: () => attendActivity(
                                          activity.activitySupport?.attendFee ??
                                              0),
                                      donateFunction: donateActivity,
                                      attenFee:
                                          activity.activitySupport?.attendFee ??
                                              0,
                                      isOutdated: isDateOutdated(
                                          activity.activityDate!.endRegisDate!),
                                    )
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
                                            onPressed: () {
                                              editActivity(activity);
                                            },
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
                                      attendFunction: () => attendActivity(
                                          activity.activitySupport?.attendFee ??
                                              0),
                                      donateFunction: donateActivity,
                                      attenFee:
                                          activity.activitySupport?.attendFee ??
                                              0,
                                      isOutdated: isDateOutdated(
                                          activity.activityDate!.endRegisDate!),
                                    )
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
                              showActivityAdditionDetails(
                                  goals: activity.goals!,
                                  reward: activity.rewards!,
                                  expenses: activity.expenses!,
                                  isOwner: isOwner,
                                  context: context);
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
                    const Text(
                      'Start register day - Close register day',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${activity.activityDate!.startRegisDate.toString().split(' ')[0]} - ${activity.activityDate!.endRegisDate.toString().split(' ')[0]}',
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Start event day - End event day',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${activity.activityDate!.startEventDate.toString().split(' ')[0]} - ${activity.activityDate!.endEventDate.toString().split(' ')[0]}',
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
                    GestureDetector(
                      onTap: () => showOwnerInformation(user),
                      child: Row(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${user.firstname} ${user.middlename} ${user.lastname}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                user.instituteName.isNotEmpty
                                    ? Text(
                                        user.instituteName,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      )
                                    : user.companyName.isNotEmpty
                                        ? Text(
                                            user.companyName,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          )
                                        : const SizedBox(),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star_border_outlined,
                                    ),
                                    Text(user.rating.toStringAsFixed(1)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
  final bool isOutdated;
  const AttendAndDonateButton(
      {super.key,
      required this.attendFunction,
      required this.donateFunction,
      required this.attenFee,
      required this.isOutdated});

  @override
  State<AttendAndDonateButton> createState() => _AttendAndDonateButtonState();
}

class _AttendAndDonateButtonState extends State<AttendAndDonateButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 15),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ElevatedButton(
              onPressed: widget.isOutdated ? null : widget.attendFunction,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    widget.isOutdated ? Colors.grey : const Color(0xFF1B8900),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                widget.isOutdated ? 'Close' : '${widget.attenFee} bath/person',
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
      ),
    );
  }
}
