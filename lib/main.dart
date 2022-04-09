import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mysportmart/configs/size_configs.dart';
import 'package:mysportmart/configs/user_model.dart';
import 'package:mysportmart/screens/dashboard.dart';
import 'package:mysportmart/screens/sign_in.dart';

void main() {
  BlocOverrides.runZoned(
    () => runApp(const MyApp()),
    blocObserver: AppBlocObserver(),
  );
}

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (bloc is Cubit) print(change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Models(),
      child: const MyAppPage(),
    );
  }
}

class MyAppPage extends StatelessWidget {
  const MyAppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: const App(),
    );
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubmitCubit(),
      child: const AppPage(),
    );
  }
}

class AppPage extends StatelessWidget {
  const AppPage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeData>(builder: (_, theme) {
      return LayoutBuilder(builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          SizeConfig().init(constraints, orientation);
          return MaterialApp(
            title: 'Test Project',
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: const LoginPage(),
            routes: {
              '/Dashboard': (context) => const DashboardPage(),
            },
          );
        });
      });
    });
  }
}

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(_lightTheme);
  static final _lightTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
    ),
  );

  void toggleTheme() {
    emit(_lightTheme);
  }
}
