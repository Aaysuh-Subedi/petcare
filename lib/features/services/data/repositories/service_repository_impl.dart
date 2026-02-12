import 'package:dartz/dartz.dart';
import 'package:petcare/core/error/failures.dart';
import 'package:petcare/features/services/data/datasource/remote/service_remote_datasource.dart';
import 'package:petcare/features/services/data/models/service_model.dart';
import 'package:petcare/features/services/domain/entities/service_entity.dart';
import 'package:petcare/features/services/domain/repositories/service_repository.dart';

class ServiceRepositoryImpl implements IServiceRepository {
  final IServiceRemoteDataSource _remoteDataSource;

  ServiceRepositoryImpl({required IServiceRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<ServiceEntity>>> getServices({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final models = await _remoteDataSource.getServices(
        page: page,
        limit: limit,
      );
      return Right(ServiceModel.toEntityList(models));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ServiceEntity>> getServiceById(
    String serviceId,
  ) async {
    try {
      final model = await _remoteDataSource.getServiceById(serviceId);
      if (model == null) {
        return const Left(ServerFailure(message: 'Service not found'));
      }
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ServiceEntity>>> getServicesByProvider(
    String providerId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final models = await _remoteDataSource.getServicesByProvider(
        providerId,
        page: page,
        limit: limit,
      );
      return Right(ServiceModel.toEntityList(models));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
