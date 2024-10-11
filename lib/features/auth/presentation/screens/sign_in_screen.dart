import 'package:erickshawapp/features/auth/domain/entities/auth_user.dart';
import 'package:erickshawapp/features/auth/presentation/bloc/sign_in/sign_in_cubit.dart';
import 'package:erickshawapp/features/auth/presentation/bloc/sign_in/sign_in_state.dart';
import 'package:erickshawapp/features/current_user/presentation/bloc/user_cubit.dart';
import 'package:erickshawapp/shared/app_images.dart';
import 'package:erickshawapp/shared/toast_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import '../../../../shared/constants.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/auth/auth_state.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late SignInCubit signInCubit;

  @override
  void initState() {
    signInCubit = context.read<SignInCubit>();
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
                          'Login',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Spacing.hlg,
                        Text(
                          'Welcome Back, We are happy to have you back',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Spacing.hlg,
                        TextFormField(
                          style: Theme.of(context).textTheme.bodySmall,
                          onChanged: (String value) {
                            context.read<SignInCubit>().emailChanged(value);
                          },
                          decoration: InputDecoration(
                            label: const Text('Email'),
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.grey),
                            errorText: signInCubit.state.emailStatus ==
                                    EmailStatus.invalid
                                ? 'Invalid email'
                                : null,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        Spacing.hlg,
                        TextFormField(
                          style: Theme.of(context).textTheme.bodySmall,
                          decoration: InputDecoration(
                            label: const Text('Password'),
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.grey),
                            errorText: signInCubit.state.passwordStatus ==
                                    PasswordStatus.invalid
                                ? 'Invalid password'
                                : null,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onChanged: (String value) {
                            context.read<SignInCubit>().passwordChanged(value);
                          },
                        ),
                        Spacing.hlg,
                        SizedBox(
                          width: double.infinity,
                          height: 0.04.sh,
                          child: ElevatedButton(
                            onPressed: () {
                              bool isValid =
                                  context.read<SignInCubit>().inputValidator();
                              if (isValid == false) {
                                showSnackbar('Invalid input', Colors.red);
                              } else {
                                final signInCubit =
                                    context.read<SignInCubit>().state;
                                context.read<AuthCubit>().signIn(
                                    signInCubit.email ?? "",
                                    signInCubit.password ?? "", () {
                                  Navigator.pushNamed(context, '/Home');
                                  setState(() {
                                    // Any additional state updates can be done here
                                  });
                                  emailController.clear();
                                  passwordController.clear();
                                });
                              }
                            },
                            child: state.isLoading == true
                                ? const CircularProgressIndicator()
                                : const Text('Sign In'),
                          ),
                        ),
                        Spacing.hlg,
                        const Center(
                          child: Text(
                            'Or',
                          ),
                        ),
                        Spacing.hlg,
                        SizedBox(
                          width: double.infinity,
                          height: 0.05.sh,
                          child: SignInButton(
                            Buttons.Google,
                            onPressed: () {
                              context
                                  .read<AuthCubit>()
                                  .signInWithGoogle((value) {
                                context.read<UserCubit>().addUser(AuthUser(
                                    id: '',
                                    email: value.email ?? "",
                                    name: value.name ?? "",
                                    photoURL: value.photoURL ?? "",
                                    phone: value.phone ?? ""));
                                Navigator.pushNamed(context, '/Home');
                              });
                            },
                          ),
                        ),
                        Spacing.hlg,
                        Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Don\'t have an account ? ',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                TextSpan(
                                  text: 'Sign Up',
                                  style: const TextStyle(
                                    color: Colors.teal,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(context, '/SignUp');
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
