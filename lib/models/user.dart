class User {
  final String uid;
  User({required this.uid});
}

class UserData {
  final String username;
  final String displayName;
  final List<dynamic> preferences;
  final List<dynamic> restrictions;
  final List<dynamic> yourProducts;
  final List<dynamic> recentlyScannedProducts;
  final List<dynamic> pinnedProducts;
  final int createdAtTimestamp;

  UserData(
      {required this.username,
      required this.displayName,
      required this.preferences,
      required this.restrictions,
      required this.yourProducts,
      required this.recentlyScannedProducts,
      required this.pinnedProducts,
      required this.createdAtTimestamp});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
        username: json["username"],
        displayName: json["display_name"],
        preferences: json["preferences"],
        restrictions: json["restrictions"],
        yourProducts: json["your_products"],
        recentlyScannedProducts: json["recently_scanned_products"],
        pinnedProducts: json["pinned_products"],
        createdAtTimestamp: json["created_at_timestamp"]);
  }
}
