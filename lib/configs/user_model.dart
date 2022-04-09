import 'package:flutter_bloc/flutter_bloc.dart';

class UserModel {
  final String id;
  final String email;
  final String username;

  UserModel({required this.id, required this.email, required this.username});
}

class Models extends Cubit<UserModel?> {
  Models() : super(authentication);
  static UserModel? authentication;
  void setUserAuth(
      {required String id, required String email, required String username}) {
    emit(authentication = UserModel(id: id, email: email, username: username));
  }
}

abstract class SetLoading {}

class LoadingTrue extends SetLoading {}

class LoadingFalse extends SetLoading {}

class SubmitCubit extends Bloc<SetLoading, bool> {
  static bool isLoading = false;
  SubmitCubit() : super(isLoading) {
    on<LoadingTrue>((event, emit) => emit(true));
    on<LoadingFalse>((event, emit) => emit(false));
  }
  // void setLoading() {
  //   isLoading = !isLoading;
  //   emit(isLoading);
  // }
}
