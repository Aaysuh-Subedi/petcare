import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:petcare/features/services/di/service_providers.dart';
import 'package:petcare/features/services/domain/usecases/get_services_usecase.dart';
import 'package:petcare/features/services/presentation/state/service_state.dart';

class ServiceNotifier extends StateNotifier<ServiceState> {
  final Ref _ref;

  ServiceNotifier(this._ref) : super(const ServiceState());

  Future<void> loadServices() async {
    state = state.copyWith(isLoading: true, error: null);
    final usecase = _ref.read(getServicesUsecaseProvider);
    final result = await usecase(GetServicesParams());
    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (services) =>
          state = state.copyWith(isLoading: false, services: services),
    );
  }
}

final serviceProvider = StateNotifierProvider<ServiceNotifier, ServiceState>(
  (ref) => ServiceNotifier(ref),
);
