import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:erickshawapp/features/rides/domain/entity/pre_book_ride_entity.dart';
import 'package:flutter/material.dart';

class PreBookRideModel extends Equatable {
  final String userId;
  final String id;
  final DateTime date;
  final String time;
  final String startLocation;
  final String endLocation;
  final String vehicleType;
  final double price;
  final bool isScheduled;
  final String status;
  final String userName;
  final DateTime createdAt;

  const PreBookRideModel({
    required this.userId,
    required this.id,
    required this.date,
    required this.time,
    required this.startLocation,
    required this.endLocation,
    required this.vehicleType,
    required this.price,
    required this.userName,
    required this.isScheduled,
    required this.createdAt,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'id': id,
      'username': userName,
      'date': date.toIso8601String(),
      'time': time.toString(),
      'startLocation': startLocation,
      'endLocation': endLocation,
      'vehicleType': vehicleType,
      'createdAt': createdAt,
      'price': price,
      'isScheduled': isScheduled,
      'status': status,
    };
  }

  factory PreBookRideModel.fromMap(Map<String, dynamic> map) {
    return PreBookRideModel(
        userId: map['userId'] ?? '',
        id: map['id'] ?? "",
        date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
        time: map['time'] ?? "",
        startLocation: map['startLocation'] ?? '',
        endLocation: map['endLocation'] ?? '',
        vehicleType: map['vehicleType'] ?? '',
        userName: map['userName'] ?? "",
        createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        price: map['price']?.toDouble() ?? 0.0,
        status: map['status'] ?? 'pending',
        isScheduled: map['isScheduled'] ?? false);
  }

  PreBookRideEntity toEntity() {
    return PreBookRideEntity(
        userId: userId,
        date: date,
        time: time,
        id: id,
        userName: userName,
        isScheduled: isScheduled,
        startLocation: startLocation,
        endLocation: endLocation,
        vehicleType: vehicleType,
        price: price,
        status: status,
        createdAt: createdAt);
  }

  @override
  List<Object?> get props => [
        userId,
        date,
        time,
        startLocation,
        endLocation,
        vehicleType,
        price,
        status,
      ];
}
