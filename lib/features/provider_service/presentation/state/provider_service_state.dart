import 'package:petcare/features/provider_service/domain/entities/provider_service_entity.dart';

class ProviderServiceState {
  final bool isLoading;
  final String? error;
  final List<ProviderServiceEntity> services;
  final ProviderServiceEntity? lastApplied;

  const ProviderServiceState({
    this.isLoading = false,
    this.error,
    this.services = const [],
    this.lastApplied,
  });

  ProviderServiceState copyWith({
    bool? isLoading,
    String? error,
    List<ProviderServiceEntity>? services,
    ProviderServiceEntity? lastApplied,
  }) {
    return ProviderServiceState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      services: services ?? this.services,
      lastApplied: lastApplied ?? this.lastApplied,
    );
  }
}
