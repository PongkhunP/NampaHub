import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nampa_hub/src/activity.dart';
import 'package:nampa_hub/src/config.dart';
import 'package:nampa_hub/src/user.dart';
import 'token_manager.dart';

class ActivityService {
  static Future<List<ActivityListItem>> getActivities(
      String? activityType) async {
    final uri = Uri.parse(
        '$getactivities${activityType != null ? 'activity_type=$activityType' : 'activity_type=Other'}');
    final String? token = await TokenManager.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      if (body['status'] == true) {
        List<dynamic> activitiesJson = body['success'];
        print("Body : $activitiesJson");
        return activitiesJson
            .map((dynamic item) => ActivityListItem.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load activities: ${body['message']}');
      }
    } else {
      throw Exception('Failed to load activities');
    }
  }

  static Future<Map<String, dynamic>> getActivityDetails(int activityId) async {
    final uri = Uri.parse('${getactivity}activity_id=$activityId');
    final String? token = await TokenManager.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      if (body['status'] == true) {
        // Convert reward image data to base64 if needed
        if (body['success']['activity']['rewards'] != null) {
          body['success']['activity']['rewards'].forEach((reward) {
            if (reward['reward_image'] != null) {
              List<dynamic> imageData = reward['reward_image']['data'];
              List<int> imageBytes = imageData.map((e) => e as int).toList();
              reward['reward_image'] =
                  base64Encode(Uint8List.fromList(imageBytes));
            }
          });
        }

        bool isOwner = body['is_owner'];
        return {
          'activity':
              Activity.fromJson(body['success']['activity'], activityId),
          'user': User.fromJson(body['success']['user']),
          'is_owner': isOwner
        };
      } else {
        throw Exception('Failed to load activities: ${body['message']}');
      }
    } else {
      throw Exception('Failed to load activities');
    }
  }

  static Future<Map<String, int>> getActivityCount() async {
    final uri = Uri.parse(getactivitycount);
    final String? token = await TokenManager.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      if (body['status'] == true) {
        Map<String, int> activityCounts =
            (body['success'] as Map<String, dynamic>)
                .map((key, value) => MapEntry(key, value as int));
        return activityCounts;
      } else {
        throw Exception('Failed to load activities: ${body['message']}');
      }
    } else {
      throw Exception('Failed to load activities');
    }
  }

  static Future<bool> validateEmail(String email) async {
    final url = Uri.parse('$validateemail?email=$email');
    final response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      if (body['status'] == true) {
        bool isUserExisted = body['exists'];
        print(isUserExisted);
        return isUserExisted;
      } else {
        throw Exception('Failed to load activities: ${body['message']}');
      }
    } else {
      throw Exception('Failed to load activities');
    }
  }

  static Future<List<ActivityListItem>> searchActivities(String query) async {
    final allActivities = await getActivities('');
    return allActivities.where((activity) {
      final titleLower = activity.title.toLowerCase();
      final locationLower = activity.eventLocation.toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower) ||
          locationLower.contains(searchLower);
    }).toList();
  }

  static Future<void> attendActivity(
      BuildContext context, int activityId) async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final uri = Uri.parse(attendactivity);
      final response = await http.post(uri,
          headers: {
            'Content-type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode({'activity_id': activityId}));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Attend activity successfully!!')),
        );
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception(
            errorResponse['message'] ?? 'Failed to attend activity');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  static Future<List<Attendee>> getAttendees(int activityId) async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final uri = Uri.parse('$getattendee?activity_id=$activityId');
      final response = await http.get(
        uri,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);

        if (body['status'] == true && body['success'] != null) {
          List<dynamic> attendees = body['success'];
          print("Attendees : $attendees");
          return attendees
              .map((attendee) => Attendee.fromJson(attendee))
              .toList();
        } else {
          throw Exception('Body do not exist or invalid');
        }
      } else {
        throw Exception('Failed to load activities');
      }
    } catch (e) {
      throw Exception('Failed to get Attendees with error : $e');
    }
  }

  static Future<void> checkIn(
      int activityId, Map<int, bool> checkinList) async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }

      final checkinListStringKeys =
          checkinList.map((key, value) => MapEntry(key.toString(), value));
      final reqbody = {
        'activity_id': activityId,
        'checkin_list': checkinListStringKeys
      };

      final uri = Uri.parse(checkin);
      final response = await http.patch(
        uri,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(reqbody),
      );

      if (response.statusCode == 200) {
        print("Check in the user successfully.");
      } else {
        throw Exception('Failed to load activities');
      }
    } catch (e) {
      throw Exception('Failed to get Attendees with error : $e');
    }
  }

  static submitRating(int id, double rating) {}
}
