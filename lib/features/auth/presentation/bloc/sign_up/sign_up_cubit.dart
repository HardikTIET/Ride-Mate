import 'package:bloc/bloc.dart';
import 'package:erickshawapp/features/auth/presentation/bloc/sign_up/sign_up_state.dart';
import '../sign_in/sign_in_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(const SignUpState());

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

  void usernameChanged(String name) async {
    if (name.isNotEmpty) {
      emit(state.copyWith(userName: name,));
    }
  }

  void phoneChanged(String phone) async {
    if (phone.isNotEmpty && phone.length == 10) {
      emit(state.copyWith(phone: phone));
    }
  }

  bool inputValidator() {
    final isEmailValid = state.emailStatus == EmailStatus.valid;
    final isPasswordValid = state.passwordStatus == PasswordStatus.valid;
    final isUserNameValid = state.userName?.isNotEmpty ?? false;

    return isEmailValid && isPasswordValid && isUserNameValid;
  }
}
