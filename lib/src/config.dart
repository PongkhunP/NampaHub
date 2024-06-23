import 'package:flutter_dotenv/flutter_dotenv.dart';

//configuration
final String ip = dotenv.env['BHOST'] ?? 'localhost';
final String port = dotenv.env['PORT'] ?? '3000';
final url = 'http://$ip:$port/';

//controller
const activity = 'activity';
const payment = 'api/payment';

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
final attendactivity = '$url$activity/attend';
final getattendee = '$url$activity/attendee-list';
final checkin = '$url$activity/check-in';
//payment path
final createorder = '$url$payment/order';
final captureorder = '$url$payment/capture';
final attendpaid = '$url$payment/attend-paid';
final returnpayment = '$url$payment/return';
final cancelpayment = '$url$payment/cancel';
