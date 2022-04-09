import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysportmart/configs/size_configs.dart';
import 'package:mysportmart/configs/user_model.dart';
import 'package:mysportmart/widgets/widgets.dart';
import 'package:http/http.dart' as http;

String apiKey = 'Web45k87u23bNR64g094h5wFWa9v56Q1L';
String userExistUrl =
    'https://api.wowcatholic.org/dating/user-exist?system=WebAPI&key=$apiKey&email=';
String signUpUrl =
    'https://api.wowcatholic.org/dating/auth/signup?system=WebAPI&key=$apiKey';
String signInUrl =
    'https://api.wowcatholic.org/dating/auth/login?system=WebAPI&key=$apiKey';
String type = 'Continue';
int pageState = 0;
final formKey = GlobalKey<FormState>();
TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController username = TextEditingController();
TextEditingController phone = TextEditingController();
double textMultiplier = SizeConfig.textMultiplier;
double widthMultiplier = SizeConfig.widthMultiplier;

onSubmit(BuildContext context) async {
  if (formKey.currentState!.validate()) {
    formKey.currentState!.save();
    String message = 'Something went wrong. Try again later';
    context.read<SubmitCubit>().add(LoadingTrue());
    print('bool = ${context.read<SubmitCubit>().state}');
    switch (pageState) {
      case 0:
        try {
          var res = await http.get(Uri.parse(userExistUrl + email.text));
          if (res.statusCode == 200) {
            print('response = ${res.body}');
            var response = jsonDecode(res.body);
            if (response['response']['subject'] == 'Record Found') {
              message = 'User exist';
              context.read<SubmitCubit>().add(LoadingFalse());
              context.read<WidgetBloc>().add(SignIn());
            } else {
              message = 'User does not exist';
              context.read<WidgetBloc>().add(SignUp());
              // UiWidgets.showAlert(
              //     context: context, value: {'message': message});
            }
            print('response = ${res.body}');
          } else {
            message = 'Something went wrong';
            print('response = ${res.reasonPhrase}');
          }
        } catch (e) {
          message = e.toString();
        }
        break;
      case 1:
        try {
          var res = await http.post(Uri.parse(signInUrl),
              body: {'username': email.text, 'password': password.text});
          if (res.statusCode == 200) {
            message = 'Sign in was successful';
            print('response = ${res.body}');
            var response = jsonDecode(res.body);
            if (response['response']['subject'] == 'Record Found') {
              context.read<Models>().setUserAuth(
                  id: response['response']['data']['1']['userguid'],
                  email: response['response']['data']['1']['email'],
                  username: response['response']['data']['1']['username']);
              // Models.authentication = UserModel(
              //     id: response['response']['data']['1']['userguid'],
              //     email: response['response']['data']['1']['email'],
              //     username: response['response']['data']['1']['username']);
              context.read<SubmitCubit>().add(LoadingFalse());
              Navigator.pushReplacementNamed(context, '/Dashboard');
            } else {
              message = 'Invalid Email/Password';
              context.read<SubmitCubit>().add(LoadingFalse());
              UiWidgets.showAlert(
                  context: context, value: {'message': message});
            }
          } else {
            message = 'Something went wrong';
            context.read<SubmitCubit>().add(LoadingFalse());
            UiWidgets.showAlert(context: context, value: {'message': message});
            print('response = ${res.reasonPhrase}');
          }
        } catch (e) {
          message = e.toString();
        }
        break;
      case 2:
        try {
          var res = await http.post(Uri.parse(signUpUrl), body: {
            'email': email.text,
            'phone': phone.text,
            'username': username.text,
            'password': password.text
          });
          if (res.statusCode == 200) {
            message = 'Sign up was successful';
            print('response = ${res.body}');
            var response = jsonDecode(res.body);
            if (response['response']['subject'] == 'Record Found') {
              context.read<Models>().setUserAuth(
                  id: response['response']['data']['1']['userguid'],
                  email: response['response']['data']['1']['email'],
                  username: response['response']['data']['1']['username']);
              // Models.authentication = UserModel(
              //     id: response['response']['data']['1']['userguid'],
              //     email: response['response']['data']['1']['email'],
              //     username: response['response']['data']['1']['username']);
              context.read<SubmitCubit>().add(LoadingFalse());
              Navigator.pushReplacementNamed(context, '/Dashboard');
            } else {
              message = 'Invalid Email/Password';
              context.read<SubmitCubit>().add(LoadingFalse());
              UiWidgets.showAlert(
                  context: context, value: {'message': message});
            }
          } else {
            message = 'Something went wrong';
            context.read<SubmitCubit>().add(LoadingFalse());
            UiWidgets.showAlert(context: context, value: {'message': message});
            print('response = ${res.reasonPhrase}');
          }
        } catch (e) {
          message = e.toString();
          context.read<SubmitCubit>().add(LoadingFalse());
          UiWidgets.showAlert(context: context, value: {'message': message});
        }
        break;
      default:
    }
    context.read<SubmitCubit>().add(LoadingFalse());
    print('bool = ${context.read<SubmitCubit>().state}');
    print('message = $message');
  }
}

Widget signInSignUp(
    {required TextEditingController controller,
    String hint = 'Password',
    String message = 'enter password',
    bool isSignIn = false}) {
  return Column(
    children: [
      isSignIn
          ? Container()
          : Column(
              children: [
                UiWidgets.form(
                    // context: context,
                    controller: username,
                    hint: 'Username',
                    isUsername: true,
                    message: message),
                SizedBox(height: textMultiplier * 1.2),
                UiWidgets.form(
                    // context: context,
                    controller: phone,
                    isPhone: true,
                    hint: 'Phone No',
                    message: 'enter phone number'),
              ],
            ),
      SizedBox(height: textMultiplier * 1.2),
      UiWidgets.form(emailController: email),
      SizedBox(height: textMultiplier * 1.2),
      UiWidgets.form(
          // context: context,
          controller: controller,
          hint: hint,
          isPassword: true,
          message: message),
      SizedBox(height: textMultiplier * 1.5),
    ],
  );
}

abstract class FormWidget {}

class SignIn extends FormWidget {}

class SignUp extends FormWidget {}

class WidgetBloc extends Bloc<FormWidget, Widget> {
  // final BuildContext context;
  WidgetBloc() : super(UiWidgets.form(emailController: email)) {
    on<SignIn>((event, emit) {
      type = 'SignIn';
      pageState = 1;
      emit(signInSignUp(controller: password, isSignIn: true));
    });
    on<SignUp>((event, emit) {
      type = 'SignUp';
      pageState = 2;
      emit(signInSignUp(controller: password));
    });
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WidgetBloc(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 2.5;
    return BlocBuilder<WidgetBloc, Widget>(builder: (contexts, widget) {
      return Scaffold(
        body: Stack(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              height: height,
              child: Center(
                child: Text(
                  pageState == 0 ? 'Test Project' : type,
                  style: TextStyle(
                      fontSize: textMultiplier * 2,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: widthMultiplier * 3),
                  child: Material(
                    borderRadius: BorderRadius.circular(30),
                    elevation: 30,
                    child: Column(
                      children: [
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              SizedBox(height: textMultiplier * 2),
                              widget,
                              SizedBox(height: textMultiplier * 1.5),
                              UiWidgets.submitButton(
                                  context: context,
                                  text: type,
                                  function: onSubmit),
                              SizedBox(height: textMultiplier * 1.2),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
