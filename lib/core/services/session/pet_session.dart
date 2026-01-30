import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:petcare/features/pet/domain/entities/pet_entity.dart';
import 'package:petcare/features/pet/domain/usecase/addpet_usecase.dart';
import 'package:petcare/features/pet/domain/usecase/get_all_pets_usecase.dart';

// Pet State
class PetState {
  final bool isLoading;
  final List<PetEntity> pets;
  final String? error;
  final PetEntity? recentlyAddedPet; // For showing success message

  const PetState({
    this.isLoading = false,
    this.pets = const [],
    this.error,
    this.recentlyAddedPet,
  });

  PetState copyWith({
    bool? isLoading,
    List<PetEntity>? pets,
    String? error,
    PetEntity? recentlyAddedPet,
    bool clearError = false,
    bool clearRecentPet = false,
  }) {
    return PetState(
      isLoading: isLoading ?? this.isLoading,
      pets: pets ?? this.pets,
      error: clearError ? null : (error ?? this.error),
      recentlyAddedPet: clearRecentPet
          ? null
          : (recentlyAddedPet ?? this.recentlyAddedPet),
    );
  }
}

// Pet Notifier
class PetNotifier extends StateNotifier<PetState> {
  final AddPetUsecase _addPetUsecase;
  final GetAllUserPetsUsecase _getAllPetsUsecase;

  PetNotifier({
    required AddPetUsecase addPetUsecase,
    required GetAllUserPetsUsecase getAllPetsUsecase,
  }) : _addPetUsecase = addPetUsecase,
       _getAllPetsUsecase = getAllPetsUsecase,
       super(const PetState());

  // Add a new pet
  Future<bool> addPet(AddPetUsecaseParams params) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _addPetUsecase.call(params);

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (createdPet) {
        // Add the new pet to the list
        final updatedPets = [...state.pets, createdPet];
        state = state.copyWith(
          isLoading: false,
          pets: updatedPets,
          recentlyAddedPet: createdPet,
        );
        return true;
      },
    );
  }

  // Get all pets for current user
  Future<void> getAllPets() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _getAllPetsUsecase.call();

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (pets) {
        state = state.copyWith(isLoading: false, pets: pets);
      },
    );
  }

  // Clear recent pet (after showing success message)
  void clearRecentPet() {
    state = state.copyWith(clearRecentPet: true);
  }

  // Clear error message
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
