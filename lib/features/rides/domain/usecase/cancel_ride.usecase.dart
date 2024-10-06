
import '../respository_impl/requested_ride_repository_impl.dart';

class CancelRequestParams {
  final String requestId;
  final String userId;

  CancelRequestParams({required this.requestId,required this.userId});
}

class CancelRideRequestUseCase {
  final RideRequestRepositoryImpl rideRequestRepository;

  CancelRideRequestUseCase(this.rideRequestRepository);

  Future<void> call(CancelRequestParams params) async {
    return await rideRequestRepository.cancelRideRequest(params.requestId,params.userId);
  }
  Future<void> cancelPreBookRide(CancelRequestParams params) async {
    return await rideRequestRepository.cancelPreBookRideRequest(params.requestId,params.userId);
  }
}
