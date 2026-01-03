import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:petcare/core/error/failures.dart';
import 'package:petcare/core/usecases/app_usecase.dart';
import 'package:petcare/features/provider/domain/repository/provider_repository.dart';

class DeleteProviderUsecaseParams extends Equatable {
  final String providerId;

  const DeleteProviderUsecaseParams({required this.providerId});

  @override
  List<Object?> get props => [providerId];
}

class DeleteProviderUsecase
    implements UsecaseWithParams<bool, DeleteProviderUsecaseParams> {
  final IProviderRepository _repository;

  DeleteProviderUsecase({required IProviderRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(DeleteProviderUsecaseParams params) {
    return _repository.deleteProvider(params.providerId);
  }
}
