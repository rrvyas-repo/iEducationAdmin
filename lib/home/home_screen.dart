// ignore_for_file: use_build_context_synchronously

import 'package:admin_app/common/widget_animation.dart/fade_animation.dart';
import 'package:admin_app/constant.dart';
import 'package:admin_app/database/database_api.dart';
import 'package:admin_app/home/attendence/attendence_screen.dart';
import 'package:admin_app/home/fees/fees_screen.dart';
import 'package:admin_app/home/home_page_widget.dart';
import 'package:admin_app/home/teaching_work/teaching_work_screen.dart';
import 'package:admin_app/navigation/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const route = 'home';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Press Again to Exit',
          style: TextStyle(color: kPrimaryColor),
          textAlign: TextAlign.center,
        ),
        backgroundColor: kSecondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
        behavior: SnackBarBehavior.floating,
      ));
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            GestureDetector(
              onTap: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Row(
                        children: const [
                          Icon(Icons.logout),
                          kWidthSizedBox,
                          Text("Logout"),
                        ],
                      ),
                      content: const Text("Sure you want to logout"),
                      actions: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            setState(() {});
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.2,
                            decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(5)),
                            child: const Center(
                              child: Text(
                                'Cancle',
                                style: TextStyle(color: kOtherColor),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.remove("userID");
                            AppNavigation.shared.goNextFromSplash();
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const LoginScreen(),
                            //   ),
                            // );
                            setState(() {});
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.2,
                            decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(5)),
                            child: const Center(
                              child: Text(
                                'Ok',
                                style: TextStyle(color: kOtherColor),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Icon(
                Icons.logout,
                color: kOtherColor,
                size: 25,
              ),
            ),
            kHalfWidthSizedBox,
          ],
          title: const Text("Dashboard"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: kPrimaryColor,
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (notification) {
            notification.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    animation(
                      context,
                      seconds: 1000,
                      horizontalOffset: -50,
                      child: HomeCard(
                        title: "Students",
                        icon: 'assets/icons/students.png',
                        onPress: () {
                          AppNavigation.shared.movetoStudent();
                          setState(() {});
                        },
                      ),
                    ),
                    animation(
                      context,
                      seconds: 700,
                      horizontalOffset: 50,
                      child: HomeCard(
                        title: 'Time Table',
                        icon: 'assets/icons/timetable.png',
                        onPress: () {
                          AppNavigation.shared.movetoTimeTableScreen();
                        },
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    animation(
                      context,
                      seconds: 900,
                      horizontalOffset: -50,
                      child: HomeCard(
                        title: "Notice",
                        icon: 'assets/icons/notice.png',
                        onPress: () {
                          AppNavigation.shared.moveToNoticeScreen();
                          setState(() {});
                        },
                      ),
                    ),
                    animation(
                      context,
                      seconds: 900,
                      horizontalOffset: 50,
                      child: HomeCard(
                        title: "Materials",
                        icon: 'assets/icons/materials.png',
                        onPress: () async {
                          await MaterialApi.fetchData();
                          AppNavigation.shared.moveToMaterialsScreen();
                          setState(() {});
                        },
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    animation(
                      context,
                      seconds: 800,
                      horizontalOffset: -50,
                      child: HomeCard(
                        title: "Course",
                        icon: 'assets/icons/course.png',
                        onPress: () async {
                          await CourseApi.fetchData();
                          AppNavigation.shared.moveToCourseScreen();
                          setState(() {});
                        },
                      ),
                    ),
                    animation(
                      context,
                      seconds: 800,
                      horizontalOffset: 50,
                      child: HomeCard(
                        title: "Attendence",
                        icon: 'assets/icons/attendence.png',
                        onPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AttendenceScreen(),
                            ),
                          );
                          setState(() {});
                        },
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    animation(
                      context,
                      seconds: 700,
                      horizontalOffset: -50,
                      child: HomeCard(
                        title: "Results",
                        icon: 'assets/icons/results.png',
                        onPress: () {
                          AppNavigation.shared.moveToResultScreen();
                          setState(() {});
                        },
                      ),
                    ),
                    animation(
                      context,
                      seconds: 700,
                      horizontalOffset: 50,
                      child: HomeCard(
                        title: "Staff List",
                        icon: 'assets/icons/staff.png',
                        onPress: () {
                          AppNavigation.shared.movetoStaffList();
                        },
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    animation(
                      context,
                      seconds: 600,
                      horizontalOffset: -50,
                      child: HomeCard(
                        title: "Fees",
                        icon: 'assets/icons/fees.png',
                        onPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FeesScreen(),
                            ),
                          );
                          setState(() {});
                        },
                      ),
                    ),
                    animation(
                      context,
                      seconds: 500,
                      horizontalOffset: 50,
                      child: HomeCard(
                        title: "Teaching Work",
                        icon: 'assets/icons/teachingwork.png',
                        onPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TeachingWorkScreen(),
                            ),
                          );
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: animation(
                        context,
                        seconds: 400,
                        horizontalOffset: -50,
                        child: HomeCard(
                          title: "Assignment",
                          icon: 'assets/icons/assignment.png',
                          onPress: () {
                            AppNavigation.shared.moveToAssignmentScreen();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
