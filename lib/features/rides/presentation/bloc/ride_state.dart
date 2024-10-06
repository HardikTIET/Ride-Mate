import 'package:equatable/equatable.dart';
import 'package:erickshawapp/features/rides/domain/entity/pre_book_ride_entity.dart';
import '../../domain/entity/requested_ride.dart';
enum RideStatus { none, active, pending,accepted, completed, cancelled }

class RideState extends Equatable {
  final bool isLoading;
  final RideRequestEntity? rideRequestEntity;
  final List<RideRequestEntity>? allRidesList;
  final String? errorMessage;
  final List<PreBookRideEntity>? preBookRidesList;
  final RideStatus? rideStatus;
  const RideState({
    this.isLoading = false,
    this.rideRequestEntity,
    this.allRidesList=const[],
    this.errorMessage,
    this.rideStatus,
    this.preBookRidesList=const[]
  });

  RideState copyWith({
    bool? isLoading,
    RideRequestEntity? rideRequestEntity,
    String? errorMessage,
    List<RideRequestEntity>? allRidesList,
    List<PreBookRideEntity>? preBookRidesList,
    RideStatus? rideStatus
  }) {
    return RideState(
      isLoading: isLoading ?? this.isLoading,
      rideRequestEntity: rideRequestEntity ?? this.rideRequestEntity,
      errorMessage: errorMessage ?? this.errorMessage,
      allRidesList: allRidesList ?? this.allRidesList,
      preBookRidesList: preBookRidesList ?? this.preBookRidesList,
      rideStatus: rideStatus ?? this.rideStatus
    );
  }

  @override
  List<Object?> get props => [isLoading, rideRequestEntity, errorMessage,allRidesList,rideStatus,preBookRidesList];
}
