import 'package:hive/hive.dart';

part 'user.g.dart';

class User {
  final String uid;
  User({required this.uid});
}

@HiveType(typeId: 3)
class UserData {
  @HiveField(0)
  final String emailAddress;

  @HiveField(1)
  final String displayName;

  @HiveField(2)
  final List<dynamic> preferences;

  @HiveField(3)
  final List<dynamic> restrictions;

  @HiveField(4)
  final List<dynamic> yourProducts;

  @HiveField(5)
  final List<dynamic> recentlyScannedProducts;

  @HiveField(6)
  final List<dynamic> pinnedProducts;

  @HiveField(7)
  final int createdAtTimestamp;

  UserData({
    required this.emailAddress,
    required this.displayName,
    required this.preferences,
    required this.restrictions,
    required this.yourProducts,
    required this.recentlyScannedProducts,
    required this.pinnedProducts,
    required this.createdAtTimestamp,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      emailAddress: json["email_address"],
      displayName: json["display_name"],
      preferences: json["preferences"],
      restrictions: json["restrictions"],
      yourProducts: json["your_products"],
      recentlyScannedProducts: json["recently_scanned_products"],
      pinnedProducts: json["pinned_products"],
      createdAtTimestamp: json["created_at_timestamp"],
    );
  }
}
