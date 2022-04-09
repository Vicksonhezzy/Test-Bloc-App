import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysportmart/configs/user_model.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Models(),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Models, UserModel?>(builder: (context, authentication) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
        ),
        body: Center(
          child: Text('Welcome ' +
              authentication!.username.replaceFirst(
                  authentication.username.substring(0, 1),
                  authentication.username.substring(0, 1).toUpperCase())),
        ),
      );
    });
  }
}
