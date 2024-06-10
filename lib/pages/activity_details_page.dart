import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:nampa_hub/src/widget.dart'; // Ensure this import is correct

class ActivityDetailsPage extends StatefulWidget {
  const ActivityDetailsPage({Key? key});

  @override
  State<ActivityDetailsPage> createState() => _ActivityDetailsPage();
}

class _ActivityDetailsPage extends State<ActivityDetailsPage> {
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
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 230,
                width: double.infinity,
                child: Row(
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      color: Colors.black,
                    ),
                    Expanded(
                      child: Container(
                        height: 200,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Beach clean up',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Icon(Icons
                                    .edit_square), // Replace 'icon_name' with the name of your icon
                              ],
                            ),
                            const Row(
                              children: [
                                Text('Patong beach'),
                                Text(', Phuket'),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Donation Goal'),
                                LinearPercentIndicator(
                                  width: 150.0,
                                  lineHeight: 30.0,
                                  percent: 0.5,
                                  center: const Text("1,000 / 2,000 Bath"),
                                  progressColor: Colors.green,
                                  barRadius: const Radius.circular(10),
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.zero,
                                ),
                                const Text('Participants'),
                                LinearPercentIndicator(
                                  width: 70.0,
                                  lineHeight: 30.0,
                                  percent: 0.5,
                                  center: const Text("10/20"),
                                  progressColor: Colors.green,
                                  barRadius: const Radius.circular(5),
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B8900),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          '200 bath/person',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                            color: const Color(0xFF1797BF), // Your border color
                            width: 2.0, // Border width
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color(0xFF1797BF),
                            padding: const EdgeInsets.all(18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Donate',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider()
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Description',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Goals'),
                                contentPadding: const EdgeInsets.fromLTRB(
                                    24.0, 8.0, 24.0, 0.0),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "-Able to collect the plastic waste for at least 1 kg.",
                                    ),
                                    const SizedBox(height: 30),
                                    const Text('Expense',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                    const SizedBox(height: 5),
                                    SingleChildScrollView(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: DataTable(
                                          columns: const [
                                            DataColumn(label: Text('Service')),
                                            DataColumn(label: Text('Price')),
                                          ],
                                          rows: const [
                                            DataRow(cells: [
                                              DataCell(Text('Food supplies')),
                                              DataCell(Text('500 Bath')),
                                            ]),
                                            DataRow(cells: [
                                              DataCell(Text('Water supplies')),
                                              DataCell(Text('200 Bath')),
                                            ]),
                                            DataRow(cells: [
                                              DataCell(Text('Bus')),
                                              DataCell(Text('2000 Bath')),
                                            ]),
                                            // Add more DataRow widgets for additional attributes
                                          ],
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              0.0, 10.0, 10.0, 10.0),
                                          child: Text(
                                            'Reward',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              height: 100,
                                              width: 100,
                                              color: Colors.red,
                                            ),
                                            const SizedBox(width: 8),
                                            const Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'NampaHub Volunteer Certification',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                  Text(
                                                    'This certification can last 2 years long',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Close'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.menu),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Collect plastic waste on the Patong beach at Phuket with “Nampa” group for 1 days.',
                  ),
                  const SizedBox(height: 40),
                  const Text('Meeting location',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text(
                    'Collect plastic waste on the Patong beach at Phuket with “Nampa” group for 1 days.',
                  ),
                ],
              ),
              const SizedBox(height: 150),
              const Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Owner',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Row(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ratchanon HeeTad',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              'King Mongkut’s University of Technology Thonburi (KMUTT)',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star_border_outlined,
                                ),
                                Text('4.6/5'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
