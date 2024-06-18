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

//activity path
final getactivities = '$url$activity?';
final getactivity = '$url$activity/activity-details?';
final createactivity = '$url$activity/create-activity';
