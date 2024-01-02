import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Logo
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: SvgPicture.asset("assets/svg/logo.svg"),
                    ),

                    // Login Register Switch
                    ToggleSwitch(
                        fontSize: 16,
                        minWidth: 125,
                        initialLabelIndex: activeLabelIndex,
                        cornerRadius: 10,
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

                    const SizedBox(height: 20),
                    isLogin ? const Login() : const Register()
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
