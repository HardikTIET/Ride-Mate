import 'package:erickshawapp/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:erickshawapp/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:erickshawapp/features/payment/payment_screen.dart';
import 'package:erickshawapp/features/privacy_and_terms/privacy.dart';
import 'package:erickshawapp/features/privacy_and_terms/terms_and_coditions.dart';
import 'package:erickshawapp/features/profile/my_profile.dart';
import 'package:erickshawapp/features/rides/presentation/screens/prebook_rides/pre_book_rides_list_view.dart';
import 'package:erickshawapp/features/settings/change_password.dart';
import 'package:erickshawapp/features/settings/settings_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../features/rides/presentation/screens/check_out.dart';
import '../features/rides/presentation/screens/home_screen.dart';
import '../features/rides/presentation/screens/my_rides_ui.dart';
import '../features/rides/presentation/screens/prebook_rides/pre_book_ride.dart';
import '../main.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final args = settings.arguments as Map<String, dynamic>?;

  switch (settings.name) {
    case '/':
      return MaterialPageRoute(
        builder: (context) => const MyApp(),
      );
    case '/SignIn':
      return MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      );
    case '/SignUp':
      return MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      );
    case '/Home':
      return MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      );

    case '/MyRides':
      return MaterialPageRoute(
        builder: (context) => MyRides(),
      );
    case '/Settings':
      return MaterialPageRoute(
        builder: (context) => Settings(),
      );
    case '/TermsAndConditions':
      return MaterialPageRoute(
        builder: (context) => TermsAndCoditions(),
      );
    case '/Privacy':
      return MaterialPageRoute(
        builder: (context) => const Privacy(),
      );
    case '/ChangePassword':
      return MaterialPageRoute(
        builder: (context) => const ChangePasswordScreen(),
      );

    case '/MyProfile':
      return MaterialPageRoute(
        builder: (context) => const MyProfile(),
      );
    case '/CheckOut':
      return MaterialPageRoute(
        builder: (context) => CheckOutScreen(
          startLocation: '',
          endLocation: '',
        ),
      );

    case '/Payment':
      return MaterialPageRoute(
        builder: (context) => PaymentScreen(),
      );

    case '/PreBook':
      return MaterialPageRoute(
        builder: (context) => const PreBookRide(),
      );
    case '/PreBookList':
      return MaterialPageRoute(
        builder: (context) => const MyPreBookRides(),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(
            child: Text('Page not found'),
          ),
        ),
      );
  }
}
