import 'package:erickshawapp/features/payment/payment_screen.dart';
import 'package:erickshawapp/features/rides/domain/usecase/cancel_ride.usecase.dart';
import 'package:erickshawapp/features/rides/presentation/bloc/ride_cubit.dart';
import 'package:erickshawapp/features/rides/presentation/bloc/ride_state.dart';
import 'package:erickshawapp/features/rides/presentation/screens/check_out.dart';
import 'package:erickshawapp/shared/dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../shared/app_images.dart';
import '../../../../shared/constants.dart';
import '../../../drawer.dart';

class MyRides extends StatefulWidget {
  @override
  State<MyRides> createState() => _MyRidesState();
}

class _MyRidesState extends State<MyRides> {
  late RideCubit rideCubit;
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    context.read<RideCubit>().getAllRidesList(currentUser?.uid ?? "");
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
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
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
                    Text('Your Rides',
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
                      if (state.isLoading == true) ...[
                        const Center(child: CircularProgressIndicator())
                      ] else ...[
                        if ((state.allRidesList ?? []).isEmpty) ...[
                          const Center(child: Text("No Request Yet"))
                        ] else ...[
                          Expanded(
                            child: ListView.separated(
                              separatorBuilder: (context, index) => SizedBox(
                                height: 0.02.sh,
                              ),
                              itemBuilder: (context, index) {
                                final item = state.allRidesList?[index];
                                String time = DateFormat('yyyy-MM-dd')
                                    .format(item!.createdAt);
                                return Container(
                                  // height: 0.17.sh,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey)),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, left: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Requested At',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                Text(time),
                                                Text(
                                                  "Start Location",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                Text(item.startLocation),
                                                Text(
                                                  "Destination Location",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                Text(item.endLocation)
                                              ],
                                            ),
                                          ),
                                          Spacing.wmed,
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Image.asset(
                                              AppImages.erickshaw,
                                              height: 100,
                                              width: 100,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8, top: 8),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: OutlinedButton(
                                              onPressed: () {
                                                if (item.status ==
                                                        'cancelled' ||
                                                    item.status ==
                                                        'completed') {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            CheckOutScreen(
                                                                startLocation: item
                                                                    .startLocation,
                                                                endLocation: item
                                                                    .endLocation),
                                                      ));
                                                }

                                                if (item.status == 'accepted') {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            PaymentScreen(
                                                          rideId: item.id,
                                                          userId: currentUser
                                                                  ?.uid ??
                                                              "",
                                                              isPreBook: false,
                                                        ),
                                                      ));
                                                }
                                              },
                                              child: Text(item.status ==
                                                          'completed' ||
                                                      item.status == 'cancelled'
                                                  ? 'Book Again'
                                                  : item.status == 'accepted'
                                                      ? 'Pay For Ride'
                                                      : item.status)),
                                        ),
                                      ),
                                      if (item.status == 'active' ||
                                          item.status == 'pending' ||
                                          item.status == 'accepted')
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, right: 8),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: OutlinedButton(
                                                onPressed: () {
                                                  showDeleteDialog(
                                                      context: context,
                                                      onTap: () {
                                                        context
                                                            .read<RideCubit>()
                                                            .cancelRideRequest(
                                                                CancelRequestParams(
                                                                    userId:
                                                                        currentUser?.uid ??
                                                                            "",
                                                                    requestId:
                                                                        item.id));
                                                      });
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(
                                                      color: Colors.red),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Cancel',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                )),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                              itemCount: state.allRidesList?.length ?? 0,
                            ),
                          )
                        ],
                      ],
                      Spacing.hmed,
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
