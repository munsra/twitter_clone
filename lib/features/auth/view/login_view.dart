import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/features/auth/view/signup_view.dart';
import 'package:twitter_clone/theme/pallete.dart';

import '../../../common/common.dart';
import '../../../constants/constants.dart';
import '../controller/auth_controller.dart';
import '../widgets/auth_filed.dart';

class LoginView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginView());
  const LoginView({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
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

  void onLogin() {
    ref.read(authControllerProvider.notifier).login(
          email: emailController.text,
          password: passwordController.text,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: appBar,
      body: isLoading
          ? const Loader()
          : Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      onTap: onLogin,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  RichText(
                      text: TextSpan(
                          text: "Don't have an account?",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Pallete.whiteColor,
                          ),
                          children: [
                        TextSpan(
                          text: ' Sign up',
                          style: const TextStyle(
                              color: Pallete.blueColor, fontSize: 16),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
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
