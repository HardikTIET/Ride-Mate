import 'package:flutter/material.dart';

import '../../domain/entity/pre_book_ride_entity.dart';
import '../../domain/entity/requested_ride.dart';

abstract class RideRequestRepository {
  Future<void> sendRideRequest(
      {required String startLocation,
      required String endLocation,
      required String vehicleType,
      required double price,
      required String userId});

  Future<RideRequestEntity> getRideRequestDetails(String requestId);

  Future<void> cancelRideRequest(String requestId,String userId);
  Future<void> cancelPreBookRideRequest(String requestId, String userId);


  Future<List<RideRequestEntity>> getAllRideRequestsForUser(String userId);

  Future<void> sendPreBookRideRequest(
      {required String userId,
      required DateTime date,
      required String time,
      required String startLocation,
      required String endLocation,
      required String vehicleType,
      required double price});

  Future<List<PreBookRideEntity>> getAllPreBookRidesForUser(String userId);
}
