import 'package:flutter/material.dart';
import 'package:grocery_scanner/screens/auth/login.dart';
import 'package:grocery_scanner/screens/auth/register.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:grocery_scanner/shared/colors.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({super.key});

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  bool isLogin = true;
  int activeLabelIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyBg,
      body: SafeArea(
        child: Center(
          child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 50.0),
                  // LOGO
                  const Text(
                    "Grocery\nScanner",
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // =========
                  const SizedBox(height: 50.0),
                  ToggleSwitch(
                      fontSize: 16.0,
                      minWidth: 125.0,
                      initialLabelIndex: activeLabelIndex,
                      cornerRadius: 10.0,
                      activeFgColor: white,
                      inactiveBgColor: grey,
                      inactiveFgColor: white,
                      activeBgColors: const [
                        [green],
                        [orange]
                      ],
                      totalSwitches: 2,
                      labels: const ["Logowanie", "Rejestracja"],
                      onToggle: (index) => setState(() {
                            isLogin = (index == 0);
                            activeLabelIndex = index!;
                          })),
                  const SizedBox(
                    height: 50.0,
                  ),
                  isLogin ? const Login() : const Register()
                ],
              )),
        ),
      ),
    );
    ;
  }
}
