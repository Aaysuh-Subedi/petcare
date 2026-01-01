class HiveTableConstant {
  // Private constructor to prevent instantiation
  HiveTableConstant._();

  // Database name
  static const String db = 'pawcare_db';

  // Table names:
  static const int userTypeId = 0;
  static const String userTable = 'user_table';

  static const int petTypeId = 1;
  static const String petType = 'pets_table';

  static const int healthTypeId = 2;
  static const String healthReport = 'health_Records';

  static const int messageTypeId = 3;
  static const String messageTable = 'message_table';

  static const int bookingTypeId = 4;
  static const String bokkingTable = 'booking_table';

  static const int providerTypeId = 5;
  static const String providerTable = 'provider_table';

  static const int inventoryTypeId = 6;
  static const String inventoryTable = 'iventory_table';
}
