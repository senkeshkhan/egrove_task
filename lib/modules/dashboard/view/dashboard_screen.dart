import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/modules/dashboard/bloc/dashboard_bloc.dart';
import 'package:login/modules/login/view/login_screen.dart';
import 'package:login/utils/app_utils.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc()..add(GetCustomerDetailsEvent()),
      child: PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            backgroundColor: const Color(0xff235A2D),
            title: const Text(
              "Profile",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          body: BlocConsumer<DashboardBloc, DashboardState>(
            listener: (context, state) {
              if (state is GetCustomerDetailsErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message,
                    ),
                    showCloseIcon: true,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is GetCustomerDetailsLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is GetCustomerDetailsSuccessState) {
                return Center(
                  child: Column(
                    children: [
                      Text(state.customer.firstname),
                      Text(state.customer.lastname),
                      Text(state.customer.email),
                      Text(state.customer.id.toString()),
                    ],
                  ),
                );
              }
              if (state is GetCustomerDetailsErrorState) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Column(
                      children: [
                        TextFormField(
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'First Name',
                            suffixIcon: Icon(Icons.person),
                          ),
                        ),
                        TextFormField(
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Last Name',
                            suffixIcon: Icon(Icons.person),
                          ),
                        ),
                        TextFormField(
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            suffixIcon: Icon(Icons.email),
                          ),
                        ),
                        TextFormField(
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            suffixIcon: Icon(Icons.phone),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: const BorderSide(
                                    color: Color(0xff235A2D),
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            ),
                            child: const Text('Submit'),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(left: 10),
                          height: 40,
                          color: Color(0xffe0e0e0),
                          child: const Row(
                            children: [
                              Text("Others"),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(left: 10),
                          height: 40,
                          color: const Color(0xfffafafa),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.lock_open,
                                color: Color(0xffd0d0d0),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Change Password",
                                style: TextStyle(color: Color(0xffbfbfbf)),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        GestureDetector(
                          onTap: () {
                            AppUtils.setToken('');
                            AppUtils.setUserId('');
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                                (route) => false);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(left: 10),
                            height: 40,
                            color: const Color(0xfffafafa),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Color(0xffd0d0d0),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Logout",
                                  style: TextStyle(color: Color(0xffbfbfbf)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(left: 10),
                          height: 40,
                          color: const Color(0xfffafafa),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.power_settings_new,
                                color: Color(0xffd0d0d0),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Delete Account",
                                style: TextStyle(color: Color(0xffbfbfbf)),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                );
              }
              return Center(
                child: ElevatedButton(
                  child: const Text("Log Out"),
                  onPressed: () {
                    AppUtils.setToken('');
                    AppUtils.setUserId('');
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
