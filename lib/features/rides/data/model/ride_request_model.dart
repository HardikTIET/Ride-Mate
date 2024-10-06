import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entity/requested_ride.dart';

class RideRequest extends Equatable {
  final String id;
  final String userId;
  final String startLocation;
  final String endLocation;
  final String vehicleType;
  final double price;
  final String status;
  final DateTime createdAt;
  final String userName;
  final bool isScheduled;
  final String preBookRideDate;
  final String preBookRideTime;

  const RideRequest(
      {required this.id,
        required this.userId,
        required this.startLocation,
        required this.endLocation,
        required this.vehicleType,
        required this.price,
        required this.status,
        required this.isScheduled,
        required this.createdAt,
        required this.preBookRideDate,
        required this.preBookRideTime,
        required this.userName});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'startLocation': startLocation,
      'endLocation': endLocation,
      'vehicleType': vehicleType,
      'price': price,
      'status': status,
      'isScheduled': isScheduled,
      'createdAt': createdAt,
      'name': userName,
      'time': preBookRideTime,
      'date': preBookRideDate
    };
  }

  factory RideRequest.fromMap(Map<String, dynamic> map) {
    print("Mapping RideRequest from map: $map"); // Debug print statement

    return RideRequest(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '', // Ensure to handle null values properly
      isScheduled: map['isScheduled'] ?? false, // Make sure this is a boolean
      startLocation: map['startLocation'] ?? '',
      endLocation: map['endLocation'] ?? '',
      vehicleType: map['vehicleType'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] ?? 'pending',
      userName: map['username'] ?? '', // Ensure correct key name
      preBookRideTime: map['time'] ?? '',
      preBookRideDate: map['date'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }


  @override
  List<Object> get props => [
    id,
    startLocation,
    endLocation,
    vehicleType,
    price,
    status,
    createdAt,
    userName,
    userId,
    isScheduled
  ];

  RideRequestEntity toEntity() {
    return RideRequestEntity(
        id: id,
        startLocation: startLocation,
        endLocation: endLocation,
        vehicleType: vehicleType,
        price: price,
        preBookRideDate: preBookRideDate,
        preBookRideTime: preBookRideTime,
        // Mapped to entity
        status: status,
        createdAt: createdAt,
        userName: userName,
        isScheduled: isScheduled);
  }
}
