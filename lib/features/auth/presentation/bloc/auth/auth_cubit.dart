import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erickshawapp/core/api/api_url.dart';
import 'package:erickshawapp/features/auth/domain/entities/auth_user.dart';
import 'package:erickshawapp/features/auth/domain/usecase/change_password.usecase.dart';
import 'package:erickshawapp/features/auth/domain/usecase/delete_account.usecase.dart';
import 'package:erickshawapp/features/auth/domain/usecase/sign_in_with_google.usecase.dart';
import 'package:erickshawapp/features/auth/presentation/bloc/sign_in/sign_in_state.dart';
import 'package:erickshawapp/shared/toast_alert.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/usecase/sign_in.usecase.dart';
import '../../../domain/usecase/sign_out.usecase.dart';
import '../../../domain/usecase/sign_up.usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase _signInUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final SignOutUseCase _signOutUseCase;
  final SignUpUseCase _signUpUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;

  AuthCubit(
      {required SignInUseCase signInUseCase,
      required SignInWithGoogleUseCase signInWithGoogleUseCase,
      required SignOutUseCase signOutUseCase,
      required SignUpUseCase signUpUseCase,
      required DeleteAccountUseCase deleteAccountUseCase,
      required ChangePasswordUseCase changePasswordUseCase})
      : _signInUseCase = signInUseCase,
        _signInWithGoogleUseCase = signInWithGoogleUseCase,
        _signOutUseCase = signOutUseCase,
        _signUpUseCase = signUpUseCase,
        _deleteAccountUseCase = deleteAccountUseCase,
        _changePasswordUseCase = changePasswordUseCase,
        super(const AuthState());

  late final AuthUser authUser;

  Future<void> signIn(String email, String password, Function onSuccess) async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = await _signInUseCase(
        SignInParams(email: email, password: password),
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      showSnackbar('Login Successfully', Colors.green);
      onSuccess();
      emit(state.copyWith(isLoading: false, authUser: user));
    } catch (err) {
      showSnackbar(err.toString(), Colors.red);
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> signInWithGoogle(Function onSuccess) async {
    emit(state.copyWith(isLoading: true));

    try {
      final user = await _signInWithGoogleUseCase.call();

      final querySnapshot =
          await ApiUrl.users.where('email', isEqualTo: user.email).get();

      if (querySnapshot.docs.isEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        showSnackbar('Login Successfully', Colors.green);

      }
      onSuccess(user);
      emit(state.copyWith(authUser: user, isLoading: false));
    } catch (err) {
      print(err.toString());
      showSnackbar(err.toString(), Colors.red);
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> signUp(String email, String password, Function onSuccess) async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = await _signUpUseCase(
        SignUpParams(email: email, password: password),
      );
      showSnackbar('SignUp Successfully', Colors.green);
      emit(state.copyWith(isLoading: false, authUser: user));
      onSuccess();
    } catch (err) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> signOut(Function onSuccess) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _signOutUseCase.call();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      showSnackbar('Log Out Successfully', Colors.green);
      emit(state.copyWith(isLoading: false));
      onSuccess();
    } catch (e) {
      showSnackbar(e.toString(), Colors.red);
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> changePassword(String newPassword) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _changePasswordUseCase.call(newPassword);
      showSnackbar('Password changed successfully!', Colors.green);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      showSnackbar(e.toString(), Colors.red);
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> deleteAccount(Function onSuccess) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _deleteAccountUseCase.call();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');
      showSnackbar('Account Deleted successfully!', Colors.green);
      onSuccess();
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      showSnackbar(e.toString(), Colors.red);
      emit(state.copyWith(isLoading: false));
    }
  }
}
