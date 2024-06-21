import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nampa_hub/src/activity.dart';
import 'package:nampa_hub/src/config.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

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

  const ActivityCard(
      {super.key,
      required this.activityName,
      required this.location,
      required this.imageBytes,
      required this.cardHeight,
      required this.cardWidth});

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
                    image: MemoryImage(imageBytes), fit: BoxFit.contain),
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

class ActivityHistoryCard extends StatelessWidget {
  final ActivityListItem activity;

  const ActivityHistoryCard({
    super.key,
    required this.activity,
  });

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
