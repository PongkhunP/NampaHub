import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class Activity {
  int? id;
  String? title;
  String? description;
  List<String>? goals;
  String? contactEmail;
  String? organizer;
  String? activityType;
  ActivityDate? activityDate;
  ActivityMedia? activityMedia;
  ActivityLocation? activityLocation;
  ActivitySupport? activitySupport;
  List<ActivityReward>? rewards;
  List<ActivityExpense>? expenses;
  int? userId;

  Activity(
      {this.id,
      this.title,
      this.description,
      this.goals,
      this.contactEmail,
      this.organizer,
      this.activityType,
      this.activityDate,
      this.activityMedia,
      this.activityLocation,
      this.activitySupport,
      this.rewards,
      this.expenses,
      this.userId});

  void setTitle(String title) => this.title = title;
  void setDescription(String description) => this.description = description;
  void setGoals(List<String> goals) => this.goals = goals;
  void setContactEmail(String contactEmail) => this.contactEmail = contactEmail;
  void setOrganizer(String organizer) => this.organizer = organizer;
  void setActivityDate(ActivityDate activityDate) =>
      this.activityDate = activityDate;
  void setActivityMedia(ActivityMedia activityMedia) =>
      this.activityMedia = activityMedia;
  void setActivityLocation(ActivityLocation activityLocation) =>
      this.activityLocation = activityLocation;
  void setActivitySupport(ActivitySupport activitySupport) =>
      this.activitySupport = activitySupport;
  void setRewards(List<ActivityReward> rewards) => this.rewards = rewards;
  void setExpenses(List<ActivityExpense> expenses) => this.expenses = expenses;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'goals': goals,
      'contact_email': contactEmail,
      'organizer': organizer,
      'activity_type': activityType,
      'activity_date': activityDate?.toJson(),
      'activity_media': activityMedia?.toJson(), // Serialize ActivityMedia
      'activity_location': activityLocation?.toJson(),
      'activity_support': activitySupport?.toJson(),
      'rewards': rewards?.map((reward) => reward.toJson()).toList(),
      'expenses': expenses?.map((expense) => expense.toJson()).toList(),
    };
  }

  factory Activity.fromJson(Map<String, dynamic> json, int id) {
    return Activity(
      id: id,
      title: json['title'],
      description: json['description'],
      goals: json['goals'] is String
          ? [json['goals']]
          : List<String>.from(json['goals'] ?? []),
      contactEmail: json['contact_email'] ?? '',
      organizer: json['organizer'] ?? '',
      activityType: json['activity_type'] ?? '',
      activityDate: json['activity_date'] != null
          ? ActivityDate.fromJson(json['activity_date'])
          : null,
      activityMedia: ActivityMedia.fromJson(
          json['activity_media']), // Deserialize ActivityMedia
      activityLocation: json['activity_location'] != null
          ? ActivityLocation.fromJson(json['activity_location'])
          : null,
      activitySupport: json['activity_support'] != null
          ? ActivitySupport.fromJson(json['activity_support'])
          : null,
      rewards: (json['rewards'] as List<dynamic>?)
          ?.map((item) => ActivityReward.fromJson(item as Map<String, dynamic>))
          .toList(),
      expenses: (json['expenses'] as List<dynamic>)
          .map((item) => ActivityExpense.fromJson(item as Map<String, dynamic>))
          .toList(),
      userId: json['user_id'] ?? 0,
    );
  }

  Activity mergeActivity(ActivityListItem activity) {
    return Activity(
      id: activity.id,
      title: activity.title,
      activityLocation: ActivityLocation(eventLocation: activity.eventLocation),
    );
  }

  void printDetails() {
    print('Title: $title');
    print('Description: $description');
    print('Goals: ${goals?.join(", ")}');
    print('Contact Email: $contactEmail');
    print('Activity Type: $activityType');
    print('Activity Date: ${activityDate?.toJson()}');
    print('Activity Media: ${activityMedia?.toJson()}');
    print('Activity Location: ${activityLocation?.toJson()}');
    print('Activity Support: ${activitySupport?.toJson()}');
    print('Rewards:');
    rewards?.forEach((reward) => reward.printDetails());
    print('Expenses:');
    expenses?.forEach((expense) => expense.printDetails());
  }
}

class ActivityMedia {
  String? activityImage;

  ActivityMedia({this.activityImage});

  void setActivityImage(String activityImage) =>
      this.activityImage = activityImage;

  String get base64Image => activityImage ?? '';

  Map<String, dynamic> toJson() {
    return {
      'activity_image': activityImage,
    };
  }

  factory ActivityMedia.fromJson(Map<String, dynamic> json) {
    return ActivityMedia(
      activityImage: json['activity_image'],
    );
  }

  // Decode base64 string to image bytes
  Uint8List get imageBytes {
    if (activityImage != null) {
      return base64Decode(activityImage!);
    }
    return Uint8List(0);
  }

  // Convert image bytes to Image widget
  Image get imageWidget {
    return Image.memory(imageBytes);
  }
}

class ActivityDate {
  DateTime? startRegisDate;
  DateTime? endRegisDate;
  DateTime? eventDate;

  ActivityDate({this.startRegisDate, this.endRegisDate, this.eventDate});

  Map<String, dynamic> toJson() {
    return {
      'start_regis_date': startRegisDate?.toIso8601String(),
      'end_regis_date': endRegisDate?.toIso8601String(),
      'event_date': eventDate?.toIso8601String(),
    };
  }

  factory ActivityDate.fromJson(Map<String, dynamic> json) {
    return ActivityDate(
      startRegisDate: DateTime.parse(json['start_regis_date']),
      endRegisDate: DateTime.parse(json['end_regis_date']),
      eventDate: DateTime.parse(json['event_date']),
    );
  }
}

class ActivityLocation {
  String? eventLocation;
  String? meetLocation;

  ActivityLocation({this.eventLocation, this.meetLocation});

  Map<String, dynamic> toJson() {
    return {
      'event_location': eventLocation,
      'meet_location': meetLocation,
    };
  }

  factory ActivityLocation.fromJson(Map<String, dynamic> json) {
    return ActivityLocation(
      eventLocation: json['event_location'],
      meetLocation: json['meet_location'],
    );
  }
}

class ActivitySupport {
  double? maxDonation;
  int? participants;
  double? attendFee;
  double? budget;
  int? currentParticipants;

  ActivitySupport({
    this.maxDonation,
    this.participants,
    this.attendFee,
    this.budget,
    this.currentParticipants,
  });

  Map<String, dynamic> toJson() {
    return {
      'max_donation': maxDonation,
      'participants': participants,
      'attend_fee': attendFee,
      'budget': budget,
      'current_participants': currentParticipants,
    };
  }

  factory ActivitySupport.fromJson(Map<String, dynamic> json) {
    return ActivitySupport(
      maxDonation: json['max_donation']?.toDouble(),
      participants: json['participants'],
      attendFee: json['attend_fee']?.toDouble(),
      budget: json['budget']?.toDouble(),
      currentParticipants: json['current_participants'],
    );
  }
}

class ActivityReward {
  String? name;
  ActivityMedia? rewardImage;
  String? description;

  ActivityReward({
    this.name,
    this.description,
    this.rewardImage,
  });

  void setName(String name) => this.name = name;
  void setRewardImage(ActivityMedia rewardImage) =>
      this.rewardImage = rewardImage;
  void setDescription(String description) => this.description = description;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'reward_image': rewardImage,
      'description': description,
    };
  }

  factory ActivityReward.fromJson(Map<String, dynamic> json) {
    return ActivityReward(
      name: json['name'],
      description: json['description'],
      rewardImage: ActivityMedia(activityImage: json['reward_image']),
    );
  }

  void printDetails() {
    print('Reward Name: $name');
    print('Description: $description');
    print('Reward Image: $rewardImage');
  }
}

class ActivityExpense {
  String? name;
  String? expense;

  ActivityExpense({
    this.name,
    this.expense,
  });

  void setName(String name) => this.name = name;
  void setExpense(String expense) => this.expense = expense;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'expense': expense,
    };
  }

  factory ActivityExpense.fromJson(Map<String, dynamic> json) {
    return ActivityExpense(
      name: json['name'],
      expense: json['expense'],
    );
  }

  void printDetails() {
    print('Expense Name: $name');
    print('Expense: $expense');
  }
}

class ActivityListItem {
  final int id;
  final String title;
  final String eventLocation;
  final ActivityMedia
      activityMedia; // Use ActivityMedia instead of String for the image
  final int userId;

  ActivityListItem({
    required this.id,
    required this.title,
    required this.eventLocation,
    required this.activityMedia,
    required this.userId,
  });

  factory ActivityListItem.fromJson(Map<String, dynamic> json) {
    return ActivityListItem(
      id: json['Id'],
      title: json['title'],
      eventLocation:
          ActivityLocation.fromJson(json['event_location']).eventLocation ??
              'Unknown Location',
      activityMedia: ActivityMedia(
          activityImage: json[
              'activity_image']), // Convert buffer to base64 string in ActivityMedia
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'title': title,
      'event_location': eventLocation,
      'activity_image': activityMedia.toJson(), // Convert ActivityMedia to JSON
      'user_id': userId,
    };
  }
}
