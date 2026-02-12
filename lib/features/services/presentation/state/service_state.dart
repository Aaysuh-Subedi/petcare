import 'package:petcare/features/services/domain/entities/service_entity.dart';

class ServiceState {
  final bool isLoading;
  final String? error;
  final List<ServiceEntity> services;

  const ServiceState({
    this.isLoading = false,
    this.error,
    this.services = const [],
  });

  ServiceState copyWith({
    bool? isLoading,
    String? error,
    List<ServiceEntity>? services,
  }) {
    return ServiceState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      services: services ?? this.services,
    );
  }
}
