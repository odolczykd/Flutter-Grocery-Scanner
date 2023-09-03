class User {
  final String uid;
  User({required this.uid});
}

class UserData {
  // final String uid;
  final String username;
  final String rank;
  final String avatar;
  final List<dynamic> yourProducts;
  final List<dynamic> recentlyScannedProducts;
  final List<dynamic> pinnedProducts;
  final List<dynamic> preferences;
  final List<dynamic> restrictions;
  final DateTime createdAt;

  UserData(
      {
      // required this.uid,
      required this.username,
      required this.rank,
      required this.avatar,
      required this.yourProducts,
      required this.recentlyScannedProducts,
      required this.pinnedProducts,
      required this.preferences,
      required this.restrictions,
      required this.createdAt});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
        // uid: json["id"],
        username: json["username"],
        rank: json["rank"],
        avatar: json["avatar"],
        yourProducts: json["yourProducts"],
        recentlyScannedProducts: json["recentlyScannedProducts"],
        pinnedProducts: json["pinnedProducts"],
        preferences: json["preferences"],
        restrictions: json["restrictions"],
        createdAt: json["createdAt"] ?? DateTime.now());
  }
}
