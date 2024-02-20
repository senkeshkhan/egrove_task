import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/modules/login/view/login_screen.dart';
import 'package:login/modules/signup/bloc/signup_bloc.dart';
import 'package:login/utils/app_colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false);
            },
          ),
          elevation: 0,
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          backgroundColor: const Color(0xff235A2D),
          title: const Text(
            "Register",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
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
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              children: [
                const SizedBox(height: 32),
                const FlutterLogo(
                  size: 100,
                  textColor: Colors.blue,
                  style: FlutterLogoStyle.stacked,
                ), //FlutterL

                const SizedBox(
                  height: 40,
                ),
                textBox(
                  "First Name",
                  "Enter your first name",
                  firstNameController,
                  const Icon(Icons.person),
                ),
                textBox(
                  "Last name",
                  "Enter your last name",
                  lastNameController,
                  const Icon(Icons.person),
                ),
                textBox(
                  "Email",
                  "Enter your email",
                  emailController,
                  const Icon(Icons.email_outlined),
                ),
                textBox(
                  "Password",
                  "Enter your password",
                  passwordController,
                ),
                const SizedBox(height: 16),
                buttonWidget()
              ],
            ),
          ],
        ),
      ),
    );
  }

  BlocProvider<SignupBloc> buttonWidget() {
    return BlocProvider(
      create: (context) => SignupBloc(),
      child: BlocConsumer<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is SignupUserLoadingState) {
            loading(context);
          } else if (state is SignupUserSuccessState) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (route) => false);
          } else if (state is SignupUserErrorState) {
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
                ctx.read<SignupBloc>().add(
                      SignupUserEvent(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                        firstName: firstNameController.text.trim(),
                        lastName: lastNameController.text.trim(),
                      ),
                    );
              },
              child: const Text(
                "Submit",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          );
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

  Widget textBox(String title, String hint, TextEditingController controller,
      [Icon? icon]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: BlocProvider(
        create: (context) => SignupBloc(),
        child: BlocBuilder<SignupBloc, SignupState>(
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
                  suffixIcon:
                      title == "Password" ? changeVisibilityButton(ctx) : icon,
                ),
                maxLines: 1,
                obscureText: title == "Password"
                    ? !ctx.read<SignupBloc>().isVisible
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
        ctx.read<SignupBloc>().add(
              ChangeVisibilityEvent(
                isVisible: !ctx.read<SignupBloc>().isVisible,
              ),
            );
      },
      child: Icon(
        ctx.read<SignupBloc>().isVisible
            ? Icons.visibility
            : Icons.visibility_off,
      ),
    );
  }
}
