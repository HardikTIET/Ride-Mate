import 'package:equatable/equatable.dart';

class RideRequestEntity extends Equatable {
  final String id;
  final String startLocation;
  final String userName;
  final String endLocation;
  final String vehicleType;
  final double price;
  final String status;
  final DateTime createdAt;
  final bool isScheduled;
  final String? preBookRideDate;
  final String? preBookRideTime;

  const RideRequestEntity(
      {required this.id,
        required this.startLocation,
        required this.endLocation,
        required this.vehicleType,
        required this.userName,
        required this.status,
        required this.price,
        this.preBookRideDate,
        this.preBookRideTime,
        required this.createdAt,
        required this.isScheduled});

  RideRequestEntity copyWith(
      {String? id,
        String? startLocation,
        String? endLocation,
        String? vehicleType,
        String? status,
        double? price,
        String? userName,
        DateTime? createdAt,
        String? preBookRideDate,
        String? preBookRideTime,
        bool? isScheduled}) {
    return RideRequestEntity(
        id: id ?? this.id,
        startLocation: startLocation ?? this.startLocation,
        endLocation: endLocation ?? this.endLocation,
        vehicleType: vehicleType ?? this.vehicleType,
        status: status ?? this.status,
        price: price ?? this.price,
        preBookRideDate: preBookRideDate ?? this.preBookRideDate,
        preBookRideTime: preBookRideTime ?? this.preBookRideTime,
        userName: userName ?? this.userName,
        createdAt: createdAt ?? this.createdAt,
        isScheduled: isScheduled ?? this.isScheduled);
  }

  @override
  List<Object> get props => [
    id,
    startLocation,
    endLocation,
    vehicleType,
    status,
    price,
    createdAt,
    isScheduled,
    userName,
  ];
}
