import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erickshawapp/features/rides/domain/entity/requested_ride.dart';
import 'package:erickshawapp/features/rides/domain/usecase/get_pre_book_rides_list.usecase.dart';
import 'package:erickshawapp/features/rides/presentation/bloc/ride_state.dart';
import 'package:erickshawapp/shared/toast_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/api/api_url.dart';
import '../../domain/entity/pre_book_ride_entity.dart';
import '../../domain/usecase/cancel_ride.usecase.dart';
import '../../domain/usecase/get_all_rides.usecase.dart';
import '../../domain/usecase/get_requested_ride_details.usecase.dart';
import '../../domain/usecase/pre_book_ride.usecase.dart';
import '../../domain/usecase/send_request.usecase.dart';

class RideCubit extends Cubit<RideState> {
  final SendRideRequestUseCase sendRideRequestUseCase;
  final GetRideRequestDetailsUseCase getRideRequestDetailsUseCase;
  final CancelRideRequestUseCase cancelRideRequestUseCase;
  final GetAllRideRequestsForUserUseCase getAllRideRequestsForUserUseCase;
  final SendPreBookRideRequestUseCase sendPreBookRideRequestUseCase;
  final GetAllPreBookRideRequestsForUserUseCase
      getAllPreBookRideRequestsForUserUseCase;

  RideCubit(
      {required this.sendRideRequestUseCase,
      required this.getRideRequestDetailsUseCase,
      required this.cancelRideRequestUseCase,
      required this.sendPreBookRideRequestUseCase,
      required this.getAllPreBookRideRequestsForUserUseCase,
      required this.getAllRideRequestsForUserUseCase})
      : super(const RideState());

  bool isActiveRide = false;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  Future<void> sendRideRequest(SendRequestParams params) async {
    emit(state.copyWith(isLoading: true));

    try {
      final QuerySnapshot canceledRideSnapshot = await ApiUrl.requested_rides
          .doc(params.userId)
          .collection('rides')
          .where('status', isEqualTo: 'cancelled')
          .get();

      if (canceledRideSnapshot.docs.isNotEmpty) {
        final existingRideDoc = canceledRideSnapshot.docs.first;
        await existingRideDoc.reference.update({
          'status': 'pending',
          'startLocation': params.startLocation,
          'endLocation': params.endLocation,
          'vehicleType': params.vehicleType,
          'price': params.price,
          'createdAt': DateTime.now(),
        });

        showSnackbar('Ride request updated successfully', Colors.green);
      } else {
        await sendRideRequestUseCase.call(params);
        showSnackbar('Ride request sent successfully', Colors.green);
      }

      isActiveRide = true;
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> getRideRequestDetails(GetRideRequestParams params) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await getRideRequestDetailsUseCase.call(params);
      emit(state.copyWith(isLoading: false, rideRequestEntity: result));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> cancelRideRequest(CancelRequestParams params) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await cancelRideRequestUseCase.call(params);

      final List<RideRequestEntity> updatedList =
          List.from(state.allRidesList!);
      final index =
          updatedList.indexWhere((ride) => ride.id == params.requestId);

      if (index != -1) {
        updatedList[index] = updatedList[index].copyWith(status: 'cancelled');
      }
      isActiveRide = false;
      emit(state.copyWith(isLoading: false, allRidesList: updatedList));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> cancelPreBookRideRequest(CancelRequestParams params) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await cancelRideRequestUseCase.cancelPreBookRide(params);

      final List<RideRequestEntity> updatedList =
          List.from(state.preBookRidesList!);
      final index =
          updatedList.indexWhere((ride) => ride.id == params.requestId);

      if (index != -1) {
        updatedList.removeAt(index);
      }
      isActiveRide = false;
      emit(state.copyWith(isLoading: false, allRidesList: updatedList));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> getAllRidesList(String userId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await getAllRideRequestsForUserUseCase.call(userId);
      emit(state.copyWith(isLoading: false, allRidesList: result));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> sendPreBookRideRequest(PreBookRideParams params) async {
    emit(state.copyWith(isLoading: true));
    try {
      await sendPreBookRideRequestUseCase.call(params);
      showSnackbar('Request send successfully', Colors.green);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> getAllPreBookRidesList(String userId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final result = await getAllPreBookRideRequestsForUserUseCase.call(userId);
      emit(state.copyWith(isLoading: false, preBookRidesList: result));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> hasActiveRide(String userId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final rides = await getAllRideRequestsForUserUseCase.call(userId);

      if (rides.any((ride) => ride.status == 'active')) {
        isActiveRide = true;
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> paymentCompleted(
      String requestId, String userId, bool isPreBook) async {
    if (isPreBook == false) {
      final List<RideRequestEntity> updatedList =
          List.from(state.allRidesList!);
      final index = updatedList.indexWhere((ride) => ride.id == requestId);

      if (index != -1) {
        updatedList[index] = updatedList[index].copyWith(status: 'completed');

        try {
          await ApiUrl.requested_rides
              .doc(userId)
              .collection('rides')
              .doc(requestId)
              .update({'status': 'completed'});
          isActiveRide = false;
          showSnackbar(
              'You have successfully completed your ride', Colors.green);
          emit(state.copyWith(allRidesList: updatedList));
        } catch (e) {
          showSnackbar('Error updating ride status: $e', Colors.red);
        }
      }
    } else {
      final List<PreBookRideEntity> updatedList =
          List.from(state.preBookRidesList!);
      final index = updatedList.indexWhere((ride) => ride.id == requestId);

      if (index != -1) {
        updatedList[index] = updatedList[index].copyWith(status: 'completed');

        try {
          await ApiUrl.prebook_rides
              .doc(userId)
              .collection('rides')
              .doc(requestId)
              .update({'status': 'completed'});
          isActiveRide = false;
          showSnackbar(
              'You have successfully completed your ride', Colors.green);
          emit(state.copyWith(preBookRidesList: updatedList));
        } catch (e) {
          showSnackbar('Error updating ride status: $e', Colors.red);
        }
      }
    }
  }
}
