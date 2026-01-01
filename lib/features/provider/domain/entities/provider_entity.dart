import 'package:equatable/equatable.dart';

class ProviderEntity extends Equatable {
  final String? providerId;
  final String business_Name;
  final String? address;
  final String? phone;
  final String? rating;

  const ProviderEntity({
    this.providerId,
    required this.business_Name,
    this.address,
    this.phone,
    this.rating,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [providerId, business_Name, rating];
}
