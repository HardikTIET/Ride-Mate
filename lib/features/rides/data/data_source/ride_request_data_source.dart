import 'package:erickshawapp/core/api/api_url.dart';
import 'package:erickshawapp/features/rides/data/model/pre_book_ride_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/ride_request_model.dart';

abstract class RideRequestDataSource {
  Future<void> sendRideRequest(
      {required String userId,
      required String startLocation,
      required String endLocation,
      required String vehicleType,
      required double price});

  Future<List<RideRequest>> getAllRideRequestsForUser(String userId);

  Future<RideRequest> getRideRequestDetails(String requestId);

  Future<void> cancelRideRequest(String requestId, String userId);
  Future<void> cancelPreBookRideRequest(String requestId, String userId);


  Future<void> sendPreBookRideRequest(
      {required String userId,
      required DateTime date,
      required String time,
      required String startLocation,
      required String endLocation,
      required String vehicleType,
      required double price});

  Future<List<PreBookRideModel>> getAllPreBookRidesForUser(String userId);
}

class RideRequestDataSourceImpl implements RideRequestDataSource {
  @override
  Future<void> sendRideRequest(
      {required String userId,
      required String startLocation,
      required String endLocation,
      required String vehicleType,
      required double price}) async {
    try {
      final rideRequestRef =
          ApiUrl.requested_rides.doc(userId).collection('rides').doc();

      final rideRequest = RideRequest(
          id: rideRequestRef.id,
          userId: userId,
          preBookRideTime: '',
          preBookRideDate: '',
          isScheduled: false,
          userName: FirebaseAuth.instance.currentUser?.displayName ?? '',
          startLocation: startLocation,
          endLocation: endLocation,
          vehicleType: vehicleType,
          price: price,
          status: 'pending',
          createdAt: DateTime.now());
      await rideRequestRef.set(rideRequest.toMap());
    } catch (e) {
      throw Exception('Failed to send ride request: $e');
    }
  }

  @override
  Future<RideRequest> getRideRequestDetails(String requestId) async {
    try {
      final doc = await ApiUrl.requested_rides.doc(requestId).get();

      if (doc.exists) {
        return RideRequest.fromMap(doc.get(requestId));
      } else {
        throw Exception('Ride request not found');
      }
    } catch (e) {
      throw Exception('Failed to get ride request details: $e');
    }
  }

  @override
  Future<void> cancelRideRequest(String requestId, String userId) async {
    try {
      await ApiUrl.requested_rides
          .doc(userId)
          .collection('rides')
          .doc(requestId)
          .update({
        'status': 'cancelled',
      });
    } catch (e) {
      throw Exception('Failed to cancel ride request: $e');
    }
  }

  @override
  Future<void> cancelPreBookRideRequest(String requestId, String userId) async {
    try {
      await ApiUrl.requested_rides
          .doc(userId)
          .collection('rides')
          .doc(requestId)
          .update({
        'status': 'cancelled',
      });
    } catch (e) {
      throw Exception('Failed to cancel ride request: $e');
    }
  }

  @override
  Future<List<RideRequest>> getAllRideRequestsForUser(String userId) async {
    try {
      final querySnapshot =
          await ApiUrl.requested_rides.doc(userId).collection('rides').get();

      return querySnapshot.docs
          .map((doc) => RideRequest.fromMap(doc.data()))
          .toList();
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
      required double price}) async {
    try {
      final rideRequestRef =
          ApiUrl.prebook_rides.doc(userId).collection('rides').doc();

      final rideRequest = PreBookRideModel(
          date: date,
          id: rideRequestRef.id,
          time: time,
          userId: userId,
          userName: FirebaseAuth.instance.currentUser?.displayName??"",
          startLocation: startLocation,
          endLocation: endLocation,
          vehicleType: vehicleType,
          isScheduled: true,
          price: price,
          status: 'pending',
          createdAt: DateTime.now());
      await rideRequestRef.set(rideRequest.toMap());
    } catch (e) {
      throw Exception('Failed to send ride request: $e');
    }
  }

  @override
  Future<List<PreBookRideModel>> getAllPreBookRidesForUser(
      String userId) async {
    try {
      final querySnapshot =
          await ApiUrl.prebook_rides.doc(userId).collection('rides').get();

      return querySnapshot.docs
          .map((doc) => PreBookRideModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to getpre book  ride requests for user: $e');
    }
  }
}
