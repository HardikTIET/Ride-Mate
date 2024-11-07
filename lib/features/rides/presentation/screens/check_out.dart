import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/app_images.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/toast_alert.dart';
import '../../../drawer.dart';
import '../../domain/usecase/send_request.usecase.dart';
import '../bloc/ride_cubit.dart';
import '../bloc/ride_state.dart';

class CheckOutScreen extends StatefulWidget {
  final String startLocation;
  final String endLocation;

  CheckOutScreen({required this.startLocation, required this.endLocation});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideCubit, RideState>(
      builder: (context, state) {
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
          ),
          drawer: CustomDrawer(),
          body: Stack(children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Theme.of(context).primaryColor,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your Ride',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.white)),
                  ],
                ),
              ),
            ),
            Spacing.hmed,
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 0.82.sh,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(50.0), // Adjust radius as needed
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, top: 30, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 0.15.sh,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey)),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Image.asset(
                                AppImages.erickshaw,
                                height: 120,
                                width: 120,
                              ),
                            ),
                            Spacing.wmed,
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "PickUp Location",
                                  ),
                                  Text(
                                    widget.startLocation ?? "",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  Spacing.hmed,
                                  const Text(
                                    "Destination Location",
                                  ),
                                  Text(
                                    widget.endLocation ?? "",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Spacing.hmed,
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sub Total",
                          ),
                          Text("\u{20B9}10"),
                        ],
                      ),
                      Spacing.hmed,
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tax",
                          ),
                          Text(
                            "0",
                          ),
                        ],
                      ),
                      Spacing.hlg,
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                          ),
                          Text(
                            "\u{20B9}10",
                          ),
                        ],
                      ),
                      const Spacer(),
                      Spacing.hmed,
                      SizedBox(
                        width: double.infinity,
                        height: 0.06.sh,
                        child: ElevatedButton(
                          onPressed: ()async {
                         // await  context.read<RideCubit>().hasActiveRide(userId!);
                            if (context.read<RideCubit>().isActiveRide ==
                                false) {
                              context.read<RideCubit>().sendRideRequest(
                                  SendRequestParams(
                                      startLocation: widget.startLocation ?? "",
                                      endLocation: widget.endLocation,
                                      price: double.parse('10.0'),
                                      userId: userId ?? "",
                                      vehicleType: 'E Rickshaw'));
                            } else {
                              showSnackbar(
                                  'You already have an active ride,Your have to cancel the previous one to book a new ride',
                                  Colors.red);
                            }
                            // Navigator.pushNamed(context, '/Payment');
                          },
                          child: state.isLoading == true
                              ? const CircularProgressIndicator()
                              : const Text('Send Request'),
                        ),
                      ),
                      Spacing.hlg,
                    ],
                  ),
                ),
              ),
            )
          ]),
        );
      },
    );
  }
}
