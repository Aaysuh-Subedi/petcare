import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:petcare/features/services/data/datasource/remote/service_remote_datasource.dart';
import 'package:petcare/features/services/data/repositories/service_repository_impl.dart';
import 'package:petcare/features/services/domain/repositories/service_repository.dart';
import 'package:petcare/features/services/domain/usecases/get_services_usecase.dart';

final serviceRepositoryProvider = Provider<IServiceRepository>((ref) {
  final remote = ref.read(serviceRemoteDatasourceProvider);
  return ServiceRepositoryImpl(remoteDataSource: remote);
});

final getServicesUsecaseProvider = Provider<GetServicesUsecase>((ref) {
  final repo = ref.read(serviceRepositoryProvider);
  return GetServicesUsecase(repository: repo);
});
