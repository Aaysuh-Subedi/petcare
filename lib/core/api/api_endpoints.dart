import 'dart:io';

class ApiEndpoints {
  ApiEndpoints._();

  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5050/';
    } else {
      return 'http://localhost:5050/';
    }
  }

  static String get mediaServerUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5050/';
    } else {
      return 'http://localhost:5050/';
    }
  }

  static String resolveMediaUrl(String path) {
    if (path.isEmpty) return '';
    final base = mediaServerUrl.endsWith('/')
        ? mediaServerUrl.substring(0, mediaServerUrl.length - 1)
        : mediaServerUrl;
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return '$base/$cleanPath';
  }

  static const Duration connectionTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // -------------------------- AUTH -------------------------
  static const String user = 'api/auth/user';
  static const String userLogin = 'api/auth/login';
  static const String userRegister = 'api/auth/register';
  static const String userWhoAmI = 'api/auth/whoami';
  static const String userUploadPhoto = 'api/auth/update-profile';
  static String userPicture(String filename) =>
      resolveMediaUrl('user_photos/$filename');
  // ------------------------ PROVIDER -----------------------
  static const String provider = 'api/provider';
  static const String providerLogin = 'login';
  static const String providerRegister = 'register';

  static const String providerGetAll = 'api/provider';
  static const String providerById = 'api/provider';
  static const String providerCreate = 'api/provider';
  static const String providerUpdate = 'api/provider';
  static const String providerDelete = 'api/provider';

  // ------------------ PROVIDER SERVICE --------------------
  static const String providerServiceApply =
      'api/provider/provider-service/apply';
  static const String providerServiceMy = 'api/provider/provider-service/my';
  static const String providerServiceById = 'api/provider/provider-service';

  // ------------------------ PET ----------------------------
  static const String petGetAll = 'api/user/pet';
  static const String petById = 'api/user/pet';
  static const String petCreate = 'api/user/pet';
  static const String petUpdate = 'api/user/pet';
  static const String petDelete = 'api/user/pet';

  // ----------------------- BOOKING -------------------------
  static const String bookingCreate = 'api/booking';
  static const String bookingList = 'api/booking';
  static const String bookingById = 'api/booking';
  static const String bookingUpdate = 'api/booking';
  static const String bookingDelete = 'api/booking';
  static const String bookingByUser = 'api/booking/user';
  static const String providerBookings = 'api/provider/booking/my';
  static const String providerBookingStatus = 'api/provider/booking';

  // ----------------------- SERVICE -------------------------
  static const String serviceList = 'api/service';
  static const String serviceById = 'api/service';
  static const String serviceByProvider = 'api/service/provider';

  // ---------------------- INVENTORY ------------------------
  static const String inventoryByProvider = 'api/provider/inventory';
  static const String inventoryCreate = 'api/provider/inventory';
  static const String inventoryUpdate = 'api/provider/inventory';
  static const String inventoryDelete = 'api/provider/inventory';
  static const String inventoryById = 'api/provider/inventory';

  // ----------------------- ORDER ---------------------------
  static const String orderCreate = 'api/order';
  static const String orderMy = 'api/order/my';
  static const String orderById = 'api/order';
  static const String orderUpdate = 'api/order';
  static const String orderDelete = 'api/order';

  // -------------------- HEALTH RECORD ----------------------
  static const String healthRecord = 'api/health-record';
  static const String healthRecordByPet = 'api/health-record/pet';
}
