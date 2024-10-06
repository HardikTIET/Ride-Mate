

import 'package:erickshawapp/features/rides/domain/entity/pre_book_ride_entity.dart';

import '../../data/data_source/ride_request_data_source.dart';
import '../../data/repositroy/requested_ride_repository.dart';
import '../entity/requested_ride.dart';

class RideRequestRepositoryImpl implements RideRequestRepository {
  final RideRequestDataSourceImpl dataSource;

  RideRequestRepositoryImpl({required this.dataSource});

  @override
  Future<void> sendRideRequest(
      {required String startLocation,
      required String endLocation,
      required String vehicleType,
      required double price,
      required String userId}) async {
    try {
      await dataSource.sendRideRequest(
          startLocation: startLocation,
          endLocation: endLocation,
          vehicleType: vehicleType,
          price: price,
          userId: userId);
    } catch (e) {
      throw Exception('Failed to send ride request: $e');
    }
  }


  @override
  Future<RideRequestEntity> getRideRequestDetails(String requestId) async {
    try {
      final data = await dataSource.getRideRequestDetails(requestId);
      return data.toEntity();
    } catch (e) {
      throw Exception('Failed to get ride request details: $e');
    }
  }

  //
  @override
  Future<void> cancelRideRequest(String requestId,String userId) async {
    try {
      await dataSource.cancelRideRequest(requestId,userId);
    } catch (e) {
      throw Exception('Failed to cancel ride request: $e');
    }
  }
  @override
  Future<void> cancelPreBookRideRequest(String requestId,String userId) async {
    try {
      await dataSource.cancelPreBookRideRequest(requestId,userId);
    } catch (e) {
      throw Exception('Failed to cancel ride request: $e');
    }
  }

  @override
  Future<List<RideRequestEntity>> getAllRideRequestsForUser(
      String userId) async {
    try {
      final rideRequests = await dataSource.getAllRideRequestsForUser(userId);

      return rideRequests.map((rideRequest) => rideRequest.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get ride requests for user: $e');
    }
  }

  @override
  Future<void> sendPreBookRideRequest(
      {required String userId,
      required DateTime date,
      required String time,
      required String startLocation,
      required String endLocation,
      required String vehicleType,
      required double price})async {
    try {
      await dataSource.sendPreBookRideRequest(
        time: time,
          date:date ,
          startLocation: startLocation,
          endLocation: endLocation,
          vehicleType: vehicleType,
          price: price,
          userId: userId);
    } catch (e) {
      throw Exception('Failed to send pre book ride request: $e');
    }
  }

  @override
  Future<List<PreBookRideEntity>> getAllPreBookRidesForUser(String userId) async{
    try {
      final rideRequests = await dataSource.getAllPreBookRidesForUser(userId);

      return rideRequests.map((rideRequest) => rideRequest.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get ride requests for user: $e');
    }
  }
}
