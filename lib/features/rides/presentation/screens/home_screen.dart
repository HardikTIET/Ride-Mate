import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:erickshawapp/design-system/app_colors.dart';
import 'package:erickshawapp/design-system/styles.dart';
import 'package:erickshawapp/features/current_user/presentation/bloc/user_state.dart';
import 'package:erickshawapp/features/drawer.dart';
import 'package:erickshawapp/shared/app_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../../shared/constants.dart';
import '../../../auth/presentation/bloc/sign_in/sign_in_cubit.dart';
import '../../../current_user/presentation/bloc/user_cubit.dart';
import '../bloc/ride_cubit.dart';
import 'check_out.dart';

enum VehicleType { rickshaw, none }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SignInCubit signInCubit;
  late UserCubit userCubit;
  VehicleType selectedVehicle = VehicleType.none;
  String? _startLocation;
  String? _endLocation;
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    signInCubit = context.read<SignInCubit>();
    userCubit = context.read<UserCubit>();
    userCubit.fetchUser(currentUser?.email ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: kPrimaryColor,
              backgroundImage: userCubit.state.authUser?.photoURL != null &&
                      (userCubit.state.authUser?.photoURL ?? "").isNotEmpty
                  ? CachedNetworkImageProvider(
                      userCubit.state.authUser?.photoURL ?? "")
                  : const AssetImage(AppImages.user), // Fallback image
              radius: 20.0, // Adjust radius as needed
            ),
          ),
          Spacing.hmed,
        ],
      ),
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).primaryColor,
          ),
          BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${userCubit.state.authUser?.name ?? "User"}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                          ),
                          Spacing.hmed,
                          Text("how are you ? hope you are doing great",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Spacing.hmed,
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 0.8.sh,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30.0),
                ),
              ),
              child: Padding(
                padding: Paddings.contentPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 0.15.sh,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 1.0,
                        aspectRatio: 16 / 9,
                      ),
                      items: [1, 2, 3, 4, 5].map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 4),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: const Image(
                                  image: AssetImage(AppImages.bg),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    Spacing.hmed,
                    const TextScroll(
                      delayBefore: Duration(milliseconds: 500),
                      'You can pay for your active rides from your "Requested Rides" section.',
                      style: TextStyle(color: Colors.red),
                    ),
                    Spacing.hmed,
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/PreBook');
                      },
                      child: Container(
                        width: 1.sw,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.grey.shade200),
                        padding: Paddings.contentPadding,
                        child: const Row(
                          children: [
                            Expanded(
                                child: Text(
                              'PreBook Your Ride',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )),
                            Icon(
                              Icons.keyboard_arrow_right_rounded,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    ),
                    Spacing.hmed,
                    const Text(
                      "Where you want to go ?",
                    ),
                    Spacing.hmed,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 7, color: Colors.black),
                              ),
                            ),
                            const Dash(
                              direction: Axis.vertical,
                              length: 50,
                              dashLength: 6,
                              dashColor: Colors.black,
                            ),
                            const Icon(
                              Icons.location_on,
                              color: Colors.black,
                              size: 30,
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                startLocation(),
                                Spacing.hlg,
                                destination(destinations),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacing.hmed,
                    const Text(
                      "Select Vehicle",
                    ),
                    Spacing.hmed,
                    _selectVehicle(),
                    Spacing.hlg,
                    SizedBox(
                      width: double.infinity,
                      height: 0.06.sh,
                      child: ElevatedButton(
                        onPressed: () {
                          final String? startLocation = _startLocation;
                          final String? endLocation = _endLocation;

                          if (selectedVehicle == VehicleType.none ||
                              startLocation == null ||
                              endLocation == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please select a vehicle, start and end location.')),
                            );
                            return;
                          }

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckOutScreen(
                                    startLocation: startLocation,
                                    endLocation: endLocation),
                              ));
                        },
                        child: const Text('Next'),
                      ),
                    ),
                    Spacing.hmed,
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget startLocation() {
    return SizedBox(
      height: 0.05.sh,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: "Start Location",
          labelStyle: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(5.0), // Rounded corners
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(5.0),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        dropdownColor: Colors.white,
        iconEnabledColor: Colors.black,
        value: _startLocation,
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: Colors.black, fontSize: 12),
        items: destinations
            .map((String location) {
          return DropdownMenuItem<String>(
            value: location,
            child: Text(
              location,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.black, fontSize: 12),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _startLocation = newValue;
          });
        },
      ),
    );
  }

  Widget destination(List<String> destinations) {
    return SizedBox(
      height: 0.05.sh,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: "End Location",
          labelStyle: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.grey),
          floatingLabelStyle: Theme.of(context).textTheme.bodySmall,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            // Black border when enabled
            borderRadius: BorderRadius.circular(5.0), // Rounded corners
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            // Black border when focused
            borderRadius: BorderRadius.circular(5.0),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        dropdownColor: Colors.white,
        style: Theme.of(context).textTheme.bodySmall,
        // White background for the dropdown
        iconEnabledColor: Colors.black,

        value: _endLocation,
        items: destinations.map((String location) {
          return DropdownMenuItem<String>(
            value: location,
            child: Text(
              location,
              style: const TextStyle(color: Colors.black, fontSize: 12),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _endLocation = newValue;
          });
        },
      ),
    );
  }

  Widget _selectVehicle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              selectedVehicle = selectedVehicle == VehicleType.rickshaw
                  ? VehicleType.none
                  : VehicleType.rickshaw;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: selectedVehicle == VehicleType.rickshaw
                  ? Colors.grey.shade200
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.erickshaw,
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 8),
                const Text(
                  "E Rickshaw",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
