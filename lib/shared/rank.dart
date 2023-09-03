import 'package:flutter/material.dart';

enum Rank {
  newUser("NEW_USER", Icons.spa, Color(0xFF4FB000)),
  user("USER", Icons.person, Color(0xFFEF6C00)),
  editor("EDITOR", Icons.edit, Color(0xFF0083EF)),
  moderator("MODERATOR", Icons.verified_user, Color(0xFF8000E9)),
  administrator("ADMINISTRATOR", Icons.star, Color(0xFFEFAF00)),
  suspended("SUSPENDED", Icons.running_with_errors, Color(0xFFEF0000)),
  banned("BANNED", Icons.person_off, Color(0xFF4B4B4B));

  final String desc;
  final IconData icon;
  final Color color;

  const Rank(this.desc, this.icon, this.color);
}

Rank findRankByDesc(String desc) {
  Map<String, Rank> ranks = {
    "NEW_USER": Rank.newUser,
    "USER": Rank.user,
    "EDITOR": Rank.editor,
    "MODERATOR": Rank.moderator,
    "ADMINISTRATOR": Rank.administrator,
    "SUSPENDED": Rank.suspended,
    "BANNED": Rank.banned
  };

  return ranks[desc]!;
}

String convertRank(String rank) {
  Map<String, String> ranks = {
    Rank.newUser.desc: "Świeżak",
    Rank.user.desc: "Użytkownik",
    Rank.editor.desc: "Edytor",
    Rank.moderator.desc: "Moderator",
    Rank.administrator.desc: "Administrator",
    Rank.suspended.desc: "Tymczasowo zablokowano",
    Rank.banned.desc: "Zablokowano na stałe",
  };

  return ranks[rank] ?? "";
}

Icon rankIcon(String desc) {
  Rank rank = findRankByDesc(desc);
  return Icon(rank.icon, color: rank.color);
}

Color rankColor(String desc) => findRankByDesc(desc).color;
