import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/modules/dashboard/view/dashboard_screen.dart';
import 'package:login/modules/login/bloc/login_bloc.dart';
import 'package:login/modules/signup/view/signup_screen.dart';
import 'package:login/utils/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: appBar(),
          body: Stack(
            alignment: Alignment.topLeft,
            children: [
              Container(
                width: double.infinity,
                height: 350,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/background.png',
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      const FlutterLogo(
                        size: 100,
                        textColor: Colors.blue,
                        style: FlutterLogoStyle.stacked,
                      ), //FlutterL

                      const SizedBox(
                        height: 40,
                      ),

                      textBox("Username", "Enter your username",
                          userNameController, 16.0),
                      textBox("Password", "Enter your password",
                          passwordController, 1.0),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                            direction: Axis.horizontal,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: -10,
                            children: [
                              Radio(
                                value: true,
                                groupValue: true,
                                fillColor: MaterialStateColor.resolveWith(
                                  (states) => AppColors.buttonColors,
                                ),
                                onChanged: (value) {},
                              ),
                              const Text(
                                "Remember Me",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const Text(
                            "Forgot Password",
                            style: TextStyle(color: Color(0xff235A2D)),
                          )
                        ],
                      ),

                      const SizedBox(
                        height: 14,
                      ),

                      buttonWidget(),

                      const SizedBox(
                        height: 7,
                      ),

                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.buttonColors, // background

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const SignupScreen(),
                                ),
                                (route) => false);
                          },
                          child: const Text(
                            "Sign UP",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 7,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.buttonColors, // background

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Login with OTP",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  BlocProvider<LoginBloc> buttonWidget() {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginUserLoadingState) {
            loading(context);
          } else if (state is LoginUserSuccessState) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const DashboardScreen(),
                ),
                (route) => false);
          } else if (state is LoginUserErrorState) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                showCloseIcon: true,
                closeIconColor: Colors.white,
              ),
            );
          }
        },
        builder: (ctx, state) {
          return SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonColors, // background

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: () {
                  ctx.read<LoginBloc>().add(
                        LoginUserEvent(
                          userName: userNameController.text.trim(),
                          password: passwordController.text.trim(),
                        ),
                      );
                },
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              ));
          // GestureDetector(
          //   onTap: () {
          //     ctx.read<LoginBloc>().add(
          //           LoginUserEvent(
          //             userName: userNameController.text.trim(),
          //             password: passwordController.text.trim(),
          //           ),
          //         );
          //   },
          //   child: Container(
          //     width: double.infinity,
          //     height: 45,
          //     decoration: BoxDecoration(
          //       color: AppColors.buttonColors,
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //     alignment: Alignment.center,
          //     child: const Text(
          //       "Submit",
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontSize: 16,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //   ),
          // );
        },
      ),
    );
  }

  Future<dynamic> loading(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator.adaptive(
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      backgroundColor: const Color(0xff235A2D),
      title: const Text(
        "Login",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget textBox(String title, String hint, TextEditingController controller,
      double bottomPadding) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: BlocProvider(
        create: (context) => LoginBloc(),
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (ctx, state) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                  )
                ],
              ),
              child: TextField(
                controller: controller,
                textInputAction: title == "Password"
                    ? TextInputAction.done
                    : TextInputAction.next,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: hint,
                  suffixIcon: title == "Password"
                      ? changeVisibilityButton(ctx)
                      : const Icon(Icons.mail_outline),
                ),
                maxLines: 1,
                obscureText: title == "Password"
                    ? !ctx.read<LoginBloc>().isVisible
                    : false,
              ),
            );
          },
        ),
      ),
    );
  }

  GestureDetector changeVisibilityButton(BuildContext ctx) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        ctx.read<LoginBloc>().add(
              ChangeVisibilityEvent(
                isVisible: !ctx.read<LoginBloc>().isVisible,
              ),
            );
      },
      child: Icon(
        ctx.read<LoginBloc>().isVisible
            ? Icons.visibility
            : Icons.visibility_off,
      ),
    );
  }
}
