import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nampa_hub/mid/auth.dart';
import 'package:http/http.dart' as http;
import 'package:nampa_hub/pages/edit_profile_page.dart';
import 'package:nampa_hub/src/config.dart';
import 'package:nampa_hub/auth/login.dart';
import 'package:nampa_hub/mid/token_manager.dart';
import 'package:nampa_hub/src/user.dart';
import 'package:nampa_hub/src/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  @override
  void initState() {
    super.initState();
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

    print("Response : ${response.body}");
    print("URI : $getuser");
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      if (body['status'] == true) {
        var user = body['success'];
        print("User data : $user");
        return User.fromJson(user);
      } else {
        throw Exception('Failed to load user: ${body['message']}');
      }
    } else {
      throw Exception('Failed to load user');
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
          future: getUser(),
          builder: (context, userData) {
            if (userData.hasError) {
              return Text('Error ${userData.error}');
            } else if (userData.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (!userData.hasData) {
              return Text('Unknown user');
            } else {
              User user = userData.data!;

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
                    padding: EdgeInsets.all(10),
                    child: Text(
                      '${user.firstname} ${user.lastname}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  user.companyName.isNotEmpty ? 
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      user.companyName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ) : const Text(""),
                  user.instituteName.isNotEmpty?
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                        user.instituteName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ) : const Text(""),

                  Padding(
                    padding: const EdgeInsets.only(right: 18, top: 10, bottom: 0),
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
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('On going'),
                              SizedBox(height: 5),
                              Text(
                                '3',
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
                                '0',
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
                                '1',
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
                              Text('Cancel'),
                              SizedBox(height: 5),
                              Text(
                                '0',
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
                          onTap: null,
                        ),
                        ListTile(
                          leading: Icon(Icons.person),
                          title: Text('Edit account information'),
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context) {
                              return MyEditProfilePage(user: user,);
                            },));
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
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text(
                            'Delete account',
                            style: TextStyle(color: Colors.red),
                          ),
                          onTap: null,
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
