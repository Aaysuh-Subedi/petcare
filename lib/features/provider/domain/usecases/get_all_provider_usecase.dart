import 'package:dartz/dartz.dart';
import 'package:petcare/core/error/failures.dart';
import 'package:petcare/core/usecases/app_usecase.dart';
import 'package:petcare/features/provider/domain/entities/provider_entity.dart';
import 'package:petcare/features/provider/domain/repository/provider_repository.dart';

class GetAllProviderUsecase
    implements UsecaseWithoutParams<List<ProviderEntity>> {
  final IProviderRepository _repository;

  GetAllProviderUsecase({required IProviderRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<ProviderEntity>>> call() {
    return _repository.getAllProviders();
  }
}
