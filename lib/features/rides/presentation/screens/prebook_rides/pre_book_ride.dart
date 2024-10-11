import 'package:erickshawapp/design-system/styles.dart';
import 'package:erickshawapp/features/rides/domain/usecase/pre_book_ride.usecase.dart';
import 'package:erickshawapp/features/rides/presentation/bloc/ride_cubit.dart';
import 'package:erickshawapp/shared/toast_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../shared/constants.dart';
import '../../bloc/ride_state.dart';
import '../home_screen.dart';

class PreBookRide extends StatefulWidget {
  const PreBookRide({super.key});

  @override
  _PreBookRideState createState() => _PreBookRideState();
}

class _PreBookRideState extends State<PreBookRide> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  VehicleType selectedVehicle = VehicleType.none;
  String? _startLocation;
  String? _endLocation;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RideCubit, RideState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("PreBook Your Ride"),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Theme.of(context).primaryColor,
              ),
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
                    padding:
                        const EdgeInsets.only(left: 20, top: 50, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Date',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacing.hmed,
                        TextFormField(
                          style: Theme.of(context).textTheme.bodySmall,
                          controller: _dateController,
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          decoration: InputDecoration(
                            labelText: 'Choose Date',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            labelStyle: Theme.of(context).textTheme.bodySmall,
                            suffixIcon: InkWell(
                              onTap: () => _selectDate(context),
                              child: const Icon(
                                  Icons.calendar_today), // Calendar icon
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.h, horizontal: 20.w),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        Spacing.hmed,
                        const Text(
                          'Select Time',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacing.hmed,
                        TextFormField(
                          style: Theme.of(context).textTheme.bodySmall,
                          controller: _timeController,
                          readOnly: true,
                          onTap: () => _selectTime(context),
                          decoration: InputDecoration(
                            labelText: 'Choose Time',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            labelStyle: Theme.of(context).textTheme.bodySmall,
                            suffixIcon: InkWell(
                              onTap: () => _selectTime(context),
                              child:
                                  const Icon(Icons.lock_clock), // Calendar icon
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.h, horizontal: 20.w),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                        Spacing.hmed,
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Select PickUp Location',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacing.hmed,
                            startLocation(),
                            Spacing.hlg,
                            const Text(
                              'Select Destination Location',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacing.hmed,
                            destination(destinations),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Confirm booking logic here
                              if (_selectedDate != null &&
                                  _selectedTime != null &&
                                  _startLocation!=null && _startLocation!.isNotEmpty &&
                                  _endLocation!=null && _endLocation!.isNotEmpty) {
                                context
                                    .read<RideCubit>()
                                    .sendPreBookRideRequest(PreBookRideParams(
                                      userId: userId!,
                                      date: _selectedDate!,
                                      time: formatTimeOfDay(_selectedTime!),
                                      startLocation: _startLocation!,
                                      endLocation: _endLocation!,
                                      vehicleType: 'E Rickshaw',
                                      price: double.parse('10'),
                                    ));
                              } else {
                                // Show a message to select both date and time
                              showSnackbar('Please fill all fields', Colors.red);

                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: state.isLoading == true
                                ? const CircularProgressIndicator()
                                : Text(
                                    'Confirm Ride',
                                    style: TextStyle(fontSize: 18.sp),
                                  ),
                          ),
                        ),
                        Spacing.hmed,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget startLocation() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Start Location",
        labelStyle: Theme.of(context).textTheme.bodySmall,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0), // Rounded corners
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      dropdownColor: Colors.white,
      iconEnabledColor: Colors.black,
      value: _startLocation,
      items: destinations.map((String location) {
        return DropdownMenuItem<String>(
          value: location,
          child: Text(
            location,
            style: const TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _startLocation = newValue;
        });
      },
    );
  }

  Widget destination(List<String> destinations) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "End Location",
        labelStyle: Theme.of(context).textTheme.bodySmall,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0), // Rounded corners
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      dropdownColor: Colors.white,
      // White background for the dropdown
      iconEnabledColor: Colors.black,

      value: _endLocation,
      items: destinations.map((String location) {
        return DropdownMenuItem<String>(
          value: location,
          child: Text(
            location,
            style: const TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _endLocation = newValue;
        });
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay now = TimeOfDay.now();
    final DateTime nowDateTime = DateTime.now();

    // Calculate the time 30 minutes from now
    final DateTime nowPlus30Minutes = nowDateTime.add(Duration(minutes: 30));
    final TimeOfDay minSelectableTime =
        TimeOfDay.fromDateTime(nowPlus30Minutes);

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? minSelectableTime,
    );

    if (picked != null && picked != _selectedTime) {
      // Convert the picked time to a comparable DateTime
      final DateTime pickedDateTime = DateTime(
        _selectedDate?.year ?? nowDateTime.year,
        _selectedDate?.month ?? nowDateTime.month,
        _selectedDate?.day ?? nowDateTime.day,
        picked.hour,
        picked.minute,
      );

      // Check if a date is selected
      if (_selectedDate != null) {
        // Check if the selected date is today
        if (_selectedDate!.year == nowDateTime.year &&
            _selectedDate!.month == nowDateTime.month &&
            _selectedDate!.day == nowDateTime.day) {
          // Apply the 30-minute rule for the current day
          if (pickedDateTime.isBefore(nowPlus30Minutes)) {
            showSnackbar("Please select a time at least 30 minutes from now.",
                Colors.red);
          } else {
            setState(() {
              _selectedTime = picked;
              _timeController.text = _selectedTime!.format(context);
            });
          }
        } else {
          // Allow any time for future dates
          setState(() {
            _selectedTime = picked;
            _timeController.text = _selectedTime!.format(context);
          });
        }
      } else {
        // Handle case where no date is selected (optional)
        showSnackbar("Please select a date first.", Colors.red);
      }
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return "${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period";
  }
}
