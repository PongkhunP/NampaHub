import 'package:flutter/material.dart';
import 'package:nampa_hub/pages/register_edu_page.dart';
import 'package:nampa_hub/pages/register_workinfo_page.dart';
import 'package:nampa_hub/src/user.dart';

class RegisWorkEdu extends StatefulWidget {
  final User user;
  const RegisWorkEdu({super.key, required this.user});

  @override
  State<RegisWorkEdu> createState() => _RegisWorkEduState();
}

class _RegisWorkEduState extends State<RegisWorkEdu> {
  bool showWorkregisPage = true;

  void toggleScreens() {
    setState(() {
      showWorkregisPage = !showWorkregisPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showWorkregisPage) {
      return MyRegisterWorkInfo(
        user: widget.user,
        showEduregisPage: toggleScreens,
      );
    } else {
      return MyRegisterEdu(
        user: widget.user,
        showWorkregisPage: toggleScreens,
      );
    }
  }
}
