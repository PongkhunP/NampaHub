import 'package:flutter_dotenv/flutter_dotenv.dart';

//configuration
final String ip = dotenv.env['BHOST'] ?? 'localhost';
final String port = dotenv.env['PORT'] ?? '3000';
final url = 'http://$ip:$port/';

//controller
const activity = 'activity';

//user path
final registration = '${url}registration';
final login = '${url}login';
final getuser = '${url}show-user';
final edituser = '${url}edit-user';
final deleteuser = '${url}delete-user';
final validateemail = '${url}validate';
//activity path
final getactivities = '$url$activity?';
final updaterating = '$url$activity/update-rating';
final getactivity = '$url$activity/activity-details?';
final createactivity = '$url$activity/create-activity';
final editactivity = '$url$activity/edit-activity';
final gethistory = '$url$activity/history';
final getactivitycount = '$url$activity/activity-count';
