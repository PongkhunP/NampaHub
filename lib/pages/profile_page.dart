import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nampa_hub/mid/auth.dart';
import 'package:http/http.dart' as http;
import 'package:nampa_hub/pages/edit_profile_page.dart';
import 'package:nampa_hub/pages/history_page.dart';
import 'package:nampa_hub/src/config.dart';
import 'package:nampa_hub/mid/token_manager.dart';
import 'package:nampa_hub/src/user.dart';
import 'package:nampa_hub/src/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nampa_hub/mid/activity_services.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  late Future<Map<String, int>> _futureActivityCount;

  @override
  void initState() {
    super.initState();
    _futureActivityCount = ActivityService.getActivityCount();
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return const AuthPage();
      },
    ));
  }

  Future<User> getUser() async {
    final String? token = await TokenManager.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }
    final response = await http.get(
      Uri.parse(getuser),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      if (body['status'] == true) {
        var user = body['success'];
        return User.fromJson(user);
      } else {
        throw Exception('Failed to load user: ${body['message']}');
      }
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> deleteUser() async {
    try {
      final String? token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      if (mounted) {
        await logout(context);
      }
      final response = await http.delete(
        Uri.parse(deleteuser),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      setState(() {});

      if (response.statusCode == 200) {
        print("Delete user successfully");
      } else {
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Logo(),
        ),
        backgroundColor: const Color(0xFF1B8900),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: Future.wait([
            getUser(),
            _futureActivityCount,
          ]),
          builder: (context, userData) {
            if (userData.hasError) {
              return Text('Error ${userData.error}');
            } else if (userData.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (!userData.hasData) {
              return const Text('Unknown user');
            } else {
              User user = userData.data![0] as User;
              Map<String, int> activityCounts =
                  userData.data![1] as Map<String, int>;

              return Column(
                children: [
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: ClipOval(
                        child: Image(
                          image: AssetImage('assets/images/Beach.jpg'),
                          width: 180,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      '${user.firstname} ${user.middlename} ${user.lastname}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  user.companyName.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            ("Company name : ${user.companyName}"),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : const SizedBox(),
                  user.instituteName.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(1),
                          child: Text(
                            ("Education name : ${user.instituteName}"),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 18, top: 10, bottom: 0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            user.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Container(
                      height: 100, // Fixed height for the container
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('On going'),
                              SizedBox(height: 5),
                              Text(
                                activityCounts['On-going'].toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Created'),
                              SizedBox(height: 5),
                              Text(
                                activityCounts['Created'].toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Success'),
                              SizedBox(height: 5),
                              Text(
                                activityCounts['Success'].toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.history),
                          title: Text('History'),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return MyHistoryPage();
                            }));
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.person),
                          title: Text('Edit account information'),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return MyEditProfilePage(
                                  user: user,
                                );
                              },
                            ));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text('Log-out'),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: IntrinsicHeight(
                                    child: IntrinsicWidth(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                                'Are you sure you want to logout?'),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                        vertical: 4),
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('No')),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4,
                                                        vertical: 4),
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      logout(context);
                                                    },
                                                    child: const Text('Yes')),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete, color: Colors.red),
                          title: const Text(
                            'Delete account',
                            style: TextStyle(color: Colors.red),
                          ),
                          onTap: deleteUser,
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
    );
  }
}
