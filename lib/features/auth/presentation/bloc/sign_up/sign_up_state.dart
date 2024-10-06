
import 'package:equatable/equatable.dart';

import '../../../domain/entities/auth_user.dart';
import '../sign_in/sign_in_state.dart';

class SignUpState extends Equatable {
  final String? email;
  final String? password;
  final String? userName;
  final EmailStatus emailStatus;
  final String? phone;
  final PasswordStatus passwordStatus;
  final bool isInputValid;
  final bool isLoading;
  final AuthUser? authUser;

  const SignUpState({
    this.email,
    this.password,
    this.phone,
    this.userName,
    this.isLoading=false,
    this.emailStatus = EmailStatus.unknown,
    this.passwordStatus = PasswordStatus.unknown,
    this.isInputValid=false,
    this.authUser
  });

  SignUpState copyWith({
    String? email,
   String? password,
    String? userName,
    String? phone,
    EmailStatus? emailStatus,
    PasswordStatus? passwordStatus,
    bool? isInputValid,
    bool? isLoading,
    AuthUser? authUser
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      userName: userName ?? this.userName,
      phone: phone ?? this.phone,
      emailStatus: emailStatus ?? this.emailStatus,
      passwordStatus: passwordStatus ?? this.passwordStatus,
      isInputValid:  isInputValid ?? this.isInputValid,
      isLoading: isLoading ?? this.isLoading,
      authUser: authUser ?? this.authUser
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    emailStatus,
    passwordStatus,
    isInputValid,
    isLoading,
    userName,
    phone
  ];
}