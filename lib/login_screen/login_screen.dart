import 'package:admin_app/constant.dart';
import 'package:admin_app/login_screen/login_screen_widget.dart';
import 'package:admin_app/navigation/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String route = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late bool _passwordVisible = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController txtIDController = TextEditingController();
  TextEditingController txtPasswordController = TextEditingController();
  String userID = 'admin';
  String password = '12345';

  DateTime? currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          'Press Again to Exit',
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color.fromRGBO(91, 62, 144, 0.6),
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
        backgroundColor: kSecondaryColor,
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (notification) {
              notification.disallowIndicator();
              return true;
            },
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: Image.asset(
                          'assets/images/ieducation.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      textField(
                        controller: txtIDController,
                        lableText: 'User Id',
                        prefixIcon: Icons.person,
                        obscureText: false,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      textField(
                          controller: txtPasswordController,
                          lableText: 'Password',
                          prefixIcon: Icons.lock,
                          obscureText: _passwordVisible,
                          suffixIcon: _passwordVisible
                              ? Icons.visibility_off
                              : Icons.remove_red_eye_outlined,
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          }),
                      const SizedBox(
                        height: 60,
                      ),
                      MaterialButton(
                        onPressed: () async {
                          if (userID == txtIDController.text &&
                              password == txtPasswordController.text) {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setBool(
                              "userID",
                              true,
                            );
                            await AppNavigation.shared.goNextFromSplash();
                            setState(() {});
                          } else {
                            if (userID != txtIDController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Invalid User Id",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  backgroundColor: Colors.red[200],
                                  margin: const EdgeInsets.all(20),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            } else if (password != txtPasswordController.text) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Invalid Password",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                backgroundColor: Colors.red[200],
                                margin: const EdgeInsets.all(20),
                                behavior: SnackBarBehavior.floating,
                              ));
                            }
                          }
                        },
                        minWidth: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.065,
                        color: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
