import 'package:erickshawapp/features/auth/presentation/bloc/auth/auth_cubit.dart';
import 'package:erickshawapp/shared/toast_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../design-system/styles.dart';
import '../../../../shared/app_images.dart';
import '../../../../shared/constants.dart';
import '../../../current_user/presentation/bloc/user_cubit.dart';
import '../../domain/entities/auth_user.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/sign_in/sign_in_state.dart';
import '../bloc/sign_up/sign_up_cubit.dart';
import '../bloc/sign_up/sign_up_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  late SignUpCubit signUpCubit;

  @override
  void initState() {
    signUpCubit = context.read<SignUpCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return Stack(
            children: [
              Positioned(
                top: 0,
                child: Image.asset(
                  AppImages.campus,
                  alignment: Alignment.topCenter,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 0.6.sh,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(50.0), // Adjust radius as needed
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 30, top: 50, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sign Up',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Spacing.hlg,
                        Text(
                          'Create your account to start using RideMate',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Spacing.hlg,
                        TextFormField(
                          style: Theme.of(context).textTheme.bodySmall,
                          onChanged: (String value) {
                            context.read<SignUpCubit>().usernameChanged(value);
                          },
                          decoration: InputDecoration(
                            label: const Text('Username'),
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.grey),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        Spacing.hlg,
                        TextFormField(
                          style: Theme.of(context).textTheme.bodySmall,
                          onChanged: (String value) {
                            context.read<SignUpCubit>().emailChanged(value);
                          },
                          decoration: InputDecoration(
                            label: const Text('Email'),
                            errorText: signUpCubit.state.emailStatus ==
                                    EmailStatus.invalid
                                ? 'Invalid email'
                                : null,
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.grey),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        Spacing.hlg,
                        TextFormField(
                          style: Theme.of(context).textTheme.bodySmall,
                          decoration: InputDecoration(
                            label: const Text('Password'),
                            errorText: signUpCubit.state.passwordStatus ==
                                    PasswordStatus.invalid
                                ? 'Invalid password'
                                : null,
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.grey),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onChanged: (String value) {
                            context.read<SignUpCubit>().passwordChanged(value);
                          },
                        ),
                        Spacing.hlg,
                        TextFormField(
                          style: Theme.of(context).textTheme.bodySmall,
                          onChanged: (String value) {
                            context.read<SignUpCubit>().phoneChanged(value);
                          },
                          decoration: InputDecoration(
                            label: const Text('Phone'),
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.grey),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        Spacing.hlg,
                        SizedBox(
                          width: double.infinity,
                          height: 0.06.sh,
                          child: ElevatedButton(
                            onPressed: () {
                              final isValid =
                                  context.read<SignUpCubit>().inputValidator();
                              if (isValid == false) {
                                showSnackbar('Invalid Input', Colors.red);
                              } else {
                                final signUpCubitState =
                                    context.read<SignUpCubit>().state;
                                context.read<AuthCubit>().signUp(
                                    signUpCubitState.email ?? "",
                                    signUpCubitState.password ?? "", () {
                                  context.read<UserCubit>().addUser(AuthUser(
                                      id: '',
                                      email: signUpCubitState.email ?? "",
                                      name: signUpCubitState.userName ?? "",
                                      photoURL: '',
                                      phone: signUpCubitState.phone ?? ""));
                                  Navigator.pushNamed(
                                    context,
                                    '/Home',
                                  );
                                  emailController.clear();
                                  phoneNumberController.clear();
                                  passwordController.clear();
                                });
                              }
                            },
                            child: state.isLoading == true
                                ? const CircularProgressIndicator()
                                : const Text('Sign Up'),
                          ),
                        ),
                        Spacing.hlg,
                        Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Already have an account ? ',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                TextSpan(
                                  text: 'Sign In',
                                  style: const TextStyle(color: Colors.teal),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(context, '/SignIn');
                                    },
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
