import 'dart:convert';
import 'dart:typed_data';
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

        return {
          'activity':
              Activity.fromJson(body['success']['activity'], activityId),
          'user': User.fromJson(body['success']['user'])
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
}
