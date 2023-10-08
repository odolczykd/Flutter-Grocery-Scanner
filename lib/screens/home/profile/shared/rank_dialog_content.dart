import 'package:flutter/material.dart';

class RankDialogContent extends StatelessWidget {
  const RankDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          // NEW_USER
          Row(
            children: [
              Icon(
                Icons.spa,
                color: Color(0xFF4FB000),
              ),
              SizedBox(width: 5.0),
              Text("Świeżak", style: TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
          Text(
              "Jesteś nowym użytkownikiem aplikacji. Z tego względu nie możesz jeszcze dodawać nowych produktów. Aby uzyskać kolejną rangę, korzystaj z aplikacji przez 7 dni!",
              style: TextStyle(fontSize: 14.0)),
          SizedBox(height: 10.0),

          // USER
          Row(
            children: [
              Icon(
                Icons.person,
                color: Color(0xFFEF6C00),
              ),
              SizedBox(width: 5.0),
              Text("Użytkownik", style: TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
          Text(
              "Jako użytkownik możesz skanować i dodawać produkty, ale nie możesz edytować produktów dodanych przez innych. Aby uzyskać kolejną rangę, dodaj poprawne informacje dotyczące min. 5 produktów!",
              style: TextStyle(fontSize: 14.0)),
          SizedBox(height: 10.0),

          // EDITOR
          Row(
            children: [
              Icon(
                Icons.edit,
                color: Color(0xFF0083EF),
              ),
              SizedBox(width: 5.0),
              Text("Edytor", style: TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
          Text(
              "Jesteś zaufanym użytkownikiem, dlatego możesz edytować informacje o produktach dodanych przez innych użytkowników. Dbaj o to, aby dane o produktach nie wprowadzały innych w błąd!",
              style: TextStyle(fontSize: 14.0)),
          SizedBox(height: 10.0),

          // MORDERATOR
          Row(
            children: [
              Icon(
                Icons.verified_user,
                color: Color(0xFF8000E9),
              ),
              SizedBox(width: 5.0),
              Text("Moderator", style: TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
          Text(
              "Moderator weryfikuje słuszność zgłoszeń dotyczących poprawności danych o produktach, a także może blokować konta innych użytkowników.",
              style: TextStyle(fontSize: 14.0)),
          SizedBox(height: 10.0),

          // ADMINISTRATOR
          // Row(
          //   children: [
          //     Icon(
          //       Icons.star,
          //       color: Color(0xFFEFAF00),
          //     ),
          //     SizedBox(width: 5.0),
          //     Text("Administrator",
          //         style: TextStyle(fontWeight: FontWeight.bold))
          //   ],
          // ),
          // Text(
          //     "Profil oznaczony taką rangą należy do osoby, która bezpośrednio odpowiada za rozwój aplikacji.",
          //     style: TextStyle(fontSize: 14.0)),
          // SizedBox(height: 10.0),

          // SUSPENDED
          Row(
            children: [
              Icon(
                Icons.running_with_errors,
                color: Color(0xFFEF0000),
              ),
              SizedBox(width: 5.0),
              Text("Tymczasowo zablokowano",
                  style: TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
          Text(
              "Twój profil został zgłoszony przez innych użytkowników z racji naruszenia zasad obowiązujących w aplikacji i tymczasowo zablokowany. Przez określony czas masz ograniczony dostęp do aplikacji!",
              style: TextStyle(fontSize: 14.0)),
          SizedBox(height: 10.0),

          // BANNED
          Row(
            children: [
              Icon(
                Icons.person_off,
                color: Color(0xFF4B4B4B),
              ),
              SizedBox(width: 5.0),
              Text("Zablokowano na stałe",
                  style: TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
          Text(
              "Ten profil rażąco naruszał zasady obowiązujące w aplikacji i został permanentnie zablokowany!",
              style: TextStyle(fontSize: 14.0)),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
