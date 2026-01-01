import 'package:petcare/features/auth/data/models/auth_hive_model.dart';

abstract interface class IAuthDataSource {
  Future<AuthHiveModel> register(AuthHiveModel model);
  Future<AuthHiveModel?> login(String email, String password);
  Future<AuthHiveModel?> getCurrentUser(String userId);
  Future<bool> logout(String userId);
}
