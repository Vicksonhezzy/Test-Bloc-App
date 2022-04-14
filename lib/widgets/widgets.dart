import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysportmart/configs/size_configs.dart';
import 'package:mysportmart/configs/user_model.dart';

double textMultiplier = SizeConfig.textMultiplier;
double widthMultiplier = SizeConfig.widthMultiplier;

class UiWidgets {
  static showAlert(
      {Map<String, dynamic>? value,
      BuildContext? context,
      int pop = 1,
      bool signOut = false,
      bool push = false,
      String pushRoute = ''}) {
    showDialog(
      barrierDismissible: false,
      context: context!,
      builder: (context) => AlertDialog(
        content: Text(value!['message']),
        actions: [
          TextButton(
              onPressed: () {
                if (push == false) {
                  for (var i = 0; i < pop; i++) {
                    Navigator.pop(context);
                  }
                } else if (signOut == true) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacementNamed(context, '/SignIn');
                } else {
                  Navigator.pushNamed(context, pushRoute);
                }
              },
              child: const Text('OK'))
        ],
      ),
    );
  }

  static Widget form(
      {bool isPassword = false,
      bool isPhone = false,
      bool isUsername = false,
      TextEditingController? controller,
      TextEditingController? emailController,
      String message = 'enter email',
      String hint = 'Email'}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widthMultiplier * 3.2),
      child: Material(
        elevation: 2,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        child: TextFormField(
          controller: controller ?? emailController,
          onChanged: (value) {},
          keyboardType: isPassword
              ? TextInputType.visiblePassword
              : isPhone
                  ? TextInputType.phone
                  : isUsername
                      ? TextInputType.text
                      : TextInputType.emailAddress,
          validator: (value) => value!.isEmpty ? message : null,
          obscureText: isPassword,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            prefixIcon: Icon(
              isPassword
                  ? Icons.security
                  : isPhone
                      ? Icons.phone
                      : isUsername
                          ? Icons.account_circle
                          : Icons.email,
              // color: Theme.of(context).primaryColor,
            ),
            contentPadding: EdgeInsets.symmetric(
                horizontal: widthMultiplier * 2.3,
                vertical: textMultiplier * 0.9),
          ),
        ),
      ),
    );
  }

  static submitButton(
      {required BuildContext context,
      required BuildContext widgetContexts,
      required String text,
      required Function function}) {
    return BlocBuilder<SubmitCubit, bool>(builder: (contexts, loading) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: widthMultiplier * 3.2),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            color: Theme.of(context).primaryColor,
          ),
          child: loading
              ? Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: const CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  ),
                )
              : TextButton(
                  child: Text(
                    text,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
                  onPressed: () => function(context, contexts, widgetContexts)),
        ),
      );
    });
  }
}
