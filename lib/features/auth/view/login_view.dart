import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/features/auth/view/signup_view.dart';
import 'package:twitter_clone/theme/pallete.dart';

import '../../../common/common.dart';
import '../../../constants/constants.dart';
import '../widgets/auth_filed.dart';

class LoginView extends StatefulWidget {

  static route() => MaterialPageRoute(builder: (context) => const LoginView());
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Using final the app bar is not recreated
  final appBar = UIConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            AuthField(
              controller: emailController,
              hintText: 'Email',
            ),
            const SizedBox(
              height: 25,
            ),
            AuthField(
              controller: passwordController,
              hintText: 'Password',
            ),
            const SizedBox(
              height: 40,
            ),
            Align(
              alignment: Alignment.topRight,
              child: RoundedSmallButton(
                label: 'Done',
                onTap: () {},
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            RichText(
                text: TextSpan(
                    text: "Don't have an account?",
                    style: const TextStyle(fontSize: 16),
                    children: [
                  TextSpan(
                    text: ' Sign up',
                    style: const TextStyle(color: Pallete.blueColor, fontSize: 16),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      Navigator.push(context, SignUpView.route());
                    },
                  ),
                ]))
          ]),
        ),
      ),
    );
  }
}
