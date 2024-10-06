import 'package:equatable/equatable.dart';

class PreBookRideEntity extends Equatable {
  final String userId;
  final String id;
  final DateTime date;
  final String time;
  final String startLocation;
  final String endLocation;
  final String vehicleType;
  final double price;
  final String status;
  final String userName;
  final bool isScheduled;
  final DateTime createdAt;

  const PreBookRideEntity({
    required this.userId,
    required this.date,
    required this.time,
    required this.id,
    required this.isScheduled,
    required this.startLocation,
    required this.endLocation,
    required this.vehicleType,
    required this.price,
    required this.userName,
    required this.createdAt,
    this.status = 'pending',
  });

  // The copyWith method
  PreBookRideEntity copyWith({
    String? userId,
    DateTime? date,
    String? time,
    String? id,
    bool? isScheduled,
    String? startLocation,
    String? endLocation,
    String? vehicleType,
    double? price,
    String? status,
    String? userName,
    DateTime? createdAt,
  }) {
    return PreBookRideEntity(
      userId: userId ?? this.userId,
      date: date ?? this.date,
      time: time ?? this.time,
      id: id ?? this.id,
      isScheduled: isScheduled ?? this.isScheduled,
      startLocation: startLocation ?? this.startLocation,
      endLocation: endLocation ?? this.endLocation,
      vehicleType: vehicleType ?? this.vehicleType,
      price: price ?? this.price,
      status: status ?? this.status,
      userName: userName ?? this.userName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    date,
    id,
    time,
    isScheduled,
    startLocation,
    endLocation,
    vehicleType,
    price,
    status,
    userName,
  ];
}
