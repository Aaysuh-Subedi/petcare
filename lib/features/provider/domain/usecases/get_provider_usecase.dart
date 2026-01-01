import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:petcare/core/error/failures.dart';
import 'package:petcare/core/usecases/app_usecase.dart';
import 'package:petcare/features/provider/domain/entities/provider_entity.dart';
import 'package:petcare/features/provider/domain/repository/provider_repository.dart';

class GetProviderUsecaseParams extends Equatable {
  final String providerId;

  const GetProviderUsecaseParams({required this.providerId});

  @override
  List<Object?> get props => [providerId];
}

class GetProviderUsecase
    implements UsecaseWithParams<ProviderEntity, GetProviderUsecaseParams> {
  final IProviderRepository _repository;

  GetProviderUsecase({required IProviderRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, ProviderEntity>> call(
    GetProviderUsecaseParams params,
  ) {
    return _repository.getProviderById(params.providerId);
  }
}
