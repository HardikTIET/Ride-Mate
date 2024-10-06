import 'package:erickshawapp/features/auth/presentation/bloc/sign_in/sign_in_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(const SignInState());

  void emailChanged(String value) {
    final email = value.toString();

    final emailRegex = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

    if (emailRegex.hasMatch(email)) {
      emit(
        state.copyWith(
            email: email,
            emailStatus: EmailStatus.valid,
        ),
      );
    } else {
      emit(state.copyWith(emailStatus: EmailStatus.invalid));
    }
  }

  void passwordChanged(String value) {
    final password = value.toString();

    if (password.length >= 6) {
      emit(
        state.copyWith(
            password: password,
            passwordStatus: PasswordStatus.valid,
        ),
      );
    } else {
      emit(state.copyWith(passwordStatus: PasswordStatus.invalid));
    }
  }

  bool inputValidator() {
    if (!(state.emailStatus == EmailStatus.valid) ||
        !(state.passwordStatus == PasswordStatus.valid)) {
      return false;
    }
    return true;
  }
}
