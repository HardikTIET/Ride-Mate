import 'package:cached_network_image/cached_network_image.dart';
import 'package:erickshawapp/features/auth/presentation/bloc/sign_in/sign_in_cubit.dart';
import 'package:erickshawapp/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:erickshawapp/features/current_user/presentation/bloc/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../shared/app_images.dart';
import '../shared/constants.dart';
import '../shared/dialog.dart';
import 'auth/presentation/bloc/auth/auth_cubit.dart';
import 'current_user/presentation/bloc/user_cubit.dart';

class CustomDrawer extends StatelessWidget {
  late UserCubit userCubit;

  @override
  Widget build(BuildContext context) {
    userCubit = context.read<UserCubit>();
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Drawer(
          width: 0.7.sw,
          child: Container(
            color: Colors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                SizedBox(
                  height: 0.23.sh,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: userCubit.state.authUser?.photoURL !=
                                      null &&
                                  userCubit.state.authUser!.photoURL!.isNotEmpty
                              ? CachedNetworkImageProvider(
                                  userCubit.state.authUser!.photoURL!)
                              : const AssetImage(AppImages.user),
                        ),
                        Spacing.hmed,
                        Text(
                          userCubit.state.authUser?.name ?? "",
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(userCubit.state.authUser?.email ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Home',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/Home');
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.bike_scooter,
                    color: Colors.black,
                  ),
                  title: Text(
                    ' Requested Rides',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/MyRides');
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.bike_scooter,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Scheduled Rides',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/PreBookList');
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Settings',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/Settings');
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.book,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Terms & Conditions',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/TermsAndConditions');
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.security,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Privacy',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/Privacy');
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Profile',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/MyProfile');
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Sign Out',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    // Navigator.pop(context);
                    showDeleteDialog(
                        context: context,
                        onTap: () {
                          context.read<AuthCubit>().signOut(() {
                            Navigator.of(appNavigationKey.currentContext!)
                                .pushNamedAndRemoveUntil(
                                    '/SignIn', (Route<dynamic> route) => false);
                          });
                        });
                  },
                ),
                // Add more items here
              ],
            ),
          ),
        );
      },
    );
  }
}
