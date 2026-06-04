import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nampa_hub/mid/token_manager.dart';
import 'package:nampa_hub/src/activity.dart';
import 'package:nampa_hub/src/config.dart';
import 'package:http/http.dart' as http;

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'NAMPAHUB',
      style: TextStyle(
        fontFamily: GoogleFonts.rubikWetPaint().fontFamily,
        color: Colors.white,
        fontSize: 32,
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String activityName;
  final String location;
  final Uint8List imageBytes;
  final double cardWidth;
  final double cardHeight;

  const ActivityCard({
    Key? key,
    required this.activityName,
    required this.location,
    required this.imageBytes,
    required this.cardHeight,
    required this.cardWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      height: cardHeight, // Adjust the height as needed
      width: cardWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: cardHeight - 80,
              width: cardWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: MemoryImage(imageBytes),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activityName,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  location,
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnGoingHistoryCard extends StatelessWidget {
  final ActivityListItem activity;

  const OnGoingHistoryCard({
    Key? key,
    required this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      height: 150, // Adjust the height as needed
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: MemoryImage(
                    base64Decode(activity.activityMedia.base64Image),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    activity.title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    activity.eventLocation,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 5),
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'Participation',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    activity.participants.toString(),
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SuccessHistoryCard extends StatefulWidget {
  final ActivityListItem activity;

  const SuccessHistoryCard({
    Key? key,
    required this.activity,
  }) : super(key: key);

  @override
  _SuccessHistoryCardState createState() => _SuccessHistoryCardState();
}

class _SuccessHistoryCardState extends State<SuccessHistoryCard> {
  double? _rating;
  bool submitted = false; // Flag to track if rating is submitted

  // void _submitRating(double rating) {
  //   // Simulate an API call or local storage update
  //   print('Submitting rating: $rating');
  //   setState(() {
  //     _rating = rating;
  //     submitted = true; // Mark as submitted
  //   });

  Future<void> _submitRating(double rating) async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        print('User not authenticated');
        return;
      }

      final response = await http.patch(
        Uri.parse(updaterating),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'activity_id': widget.activity.id,
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
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      height: 150, // Adjust the height as needed
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: MemoryImage(
                    base64Decode(widget.activity.activityMedia.base64Image),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.activity.title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.activity.eventLocation,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 5),

                  Row(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 8), // Adjusted padding
                        child: Text(
                          widget.activity.rating.toString(),
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (!submitted || _rating == null)
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: RatingButton(
                            onPressed: _submitRating,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8), // Adjusted padding
                  const Padding(
                    padding: EdgeInsets.only(top: 8), // Adjusted padding
                    child: Text(
                      'Participation',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    widget.activity.participants.toString(),
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RatingButton extends StatefulWidget {
  final Function(double) onPressed;

  const RatingButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  _RatingButtonState createState() => _RatingButtonState();
}

class _RatingButtonState extends State<RatingButton> {
  double? _rating;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _showRatingDialog(context);
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      child: Text(
        'Rating here',
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Rate this activity'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                 const Text('Tap a star to rate:'),
                  Row(
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
                        },
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:const  Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_rating != null) {
                      widget.onPressed(_rating!);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class CreatedHistoryCard extends StatelessWidget {
  final ActivityListItem activity;

  const CreatedHistoryCard({
    Key? key,
    required this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      height: 150, // Adjust the height as needed
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: MemoryImage(
                      base64Decode(activity.activityMedia.base64Image)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    activity.title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    activity.eventLocation,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 5),
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'Participation',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    activity.participants.toString(),
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RewardItem extends StatefulWidget {
  final ActivityReward reward;

  RewardItem({required this.reward});

  @override
  _RewardItemState createState() => _RewardItemState();
}

class _RewardItemState extends State<RewardItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.memory(
          widget.reward.rewardImage!.imageBytes,
          fit: BoxFit.cover,
          width: 100,
          height: 70,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.reward.name!,
                  softWrap: true,
                  maxLines: null,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.reward.description!,
                  softWrap: true,
                  maxLines: isExpanded ? 25 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Text(
                    isExpanded ? 'Show less' : 'Read more',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
