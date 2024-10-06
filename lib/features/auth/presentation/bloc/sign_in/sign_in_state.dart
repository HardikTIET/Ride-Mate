import 'package:equatable/equatable.dart';
import 'package:erickshawapp/features/auth/domain/entities/auth_user.dart';

enum EmailStatus { unknown, valid, invalid }

enum PasswordStatus { unknown, valid, invalid }

class SignInState extends Equatable {
  final String? email;
  final String? password;
  final EmailStatus emailStatus;
  final PasswordStatus passwordStatus;
  final bool isLoading;
  final AuthUser? authUser;

  const SignInState({
    this.email,
    this.password,
    this.isLoading = false,
    this.emailStatus = EmailStatus.unknown,
    this.passwordStatus = PasswordStatus.unknown,
    this.authUser,
  });

  SignInState copyWith(
      {String? email,
      String? password,
      EmailStatus? emailStatus,
      PasswordStatus? passwordStatus,
      bool? isLoading,
      AuthUser? authUser}) {
    return SignInState(
        email: email ?? this.email,
        password: password ?? this.password,
        emailStatus: emailStatus ?? this.emailStatus,
        passwordStatus: passwordStatus ?? this.passwordStatus,
        isLoading: isLoading ?? this.isLoading,
        authUser: authUser ?? this.authUser);
  }

  @override
  List<Object?> get props =>
      [email, password, emailStatus, passwordStatus, authUser, isLoading];
}
