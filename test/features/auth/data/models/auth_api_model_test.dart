import 'package:flutter_test/flutter_test.dart';
import 'package:petcare/features/auth/data/models/auth_api_model.dart';
import 'package:petcare/features/auth/domain/entities/auth_entity.dart';

void main() {
  group('AuthApiModel Tests', () {
    final tAuthApiModel = AuthApiModel(
      id: '1',
      Firstname: 'Aayush',
      Lastname: 'Sharma',
      email: 'aayush@gmail.com',
      phoneNumber: '9800000000',
      username: 'aayush',
      password: 'password123',
      confirmPassword: 'password123',
      avatar: 'avatar.png',
    );

    final tAuthEntity = AuthEntity(
      userId: '1',
      FirstName: 'Aayush',
      LastName: 'Sharma',
      email: 'aayush@gmail.com',
      phoneNumber: '9800000000',
      username: 'aayush',
      password: 'password123',
      avatar: 'avatar.png',
    );

    test('should convert AuthApiModel to JSON correctly', () {
      final result = tAuthApiModel.toJSON();

      expect(result, {
        "Firstname": "Aayush",
        "Lastname": "Sharma",
        "email": "aayush@gmail.com",
        "phone": "9800000000",
        "username": "aayush",
        "password": "password123",
        "confirmPassword": "password123",
        "imageUrl": "avatar.png",
      });
    });

    test('should create AuthApiModel from JSON correctly', () {
      final jsonMap = {
        "_id": "1",
        "Firstname": "Aayush",
        "Lastname": "Sharma",
        "email": "aayush@gmail.com",
        "phone": "9800000000",
        "username": "aayush",
        "imageUrl": "avatar.png",
      };

      final result = AuthApiModel.fromJSON(jsonMap);

      expect(result.id, '1');
      expect(result.Firstname, 'Aayush');
      expect(result.Lastname, 'Sharma');
      expect(result.email, 'aayush@gmail.com');
      expect(result.phoneNumber, '9800000000');
      expect(result.username, 'aayush');
      expect(result.avatar, 'avatar.png');
    });

    test('should convert AuthApiModel to AuthEntity correctly', () {
      final result = tAuthApiModel.toEntity();

      expect(result, tAuthEntity);
    });

    test('should create AuthApiModel from AuthEntity correctly', () {
      final result = AuthApiModel.fromEntity(tAuthEntity);

      expect(result.id, '1');
      expect(result.Firstname, 'Aayush');
      expect(result.Lastname, 'Sharma');
      expect(result.email, 'aayush@gmail.com');
      expect(result.phoneNumber, '9800000000');
      expect(result.username, 'aayush');
      expect(result.avatar, 'avatar.png');
    });

    test('should convert list of AuthApiModel to list of AuthEntity', () {
      final models = [tAuthApiModel];

      final result = AuthApiModel.toEntityList(models);

      expect(result, [tAuthEntity]);
    });
  });
}
