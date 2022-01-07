import 'package:flutter/material.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/colors.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/values.dart';





class Genres extends StatelessWidget {

  final List<String> genres;
  final Function(String genre) onGenreTap;
  final Color selectedColor;

  const Genres({Key? key, required this.genres,
    required this.onGenreTap,
    this.selectedColor = Colors.black
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: genres.length,
        itemBuilder: (context, index) =>
          GenreCard(genre: genres[index], onTap: (genre) => onGenreTap(genre), selectedColor: selectedColor),
      ),
    );
  }
}

class GenreCard extends StatelessWidget {
  final String genre;
  final Function(String) onTap;
  final Color selectedColor;

  GenreCard({Key? key, required this.genre, required this.onTap, required this.selectedColor}) : super(key: key);

  final ValueNotifier<bool> isSelect = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isSelect.value = !isSelect.value;
        onTap(genre);
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: isSelect,
        builder: (context, isSelect, _) {
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: kDefaultPadding),
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
              vertical: kDefaultPadding / 4, // 5 padding top and bottom
            ),
            decoration: BoxDecoration(
              border: Border.all(color: !isSelect ? Colors.black26 : selectedColor),
              borderRadius: BorderRadius.circular(20),
              color: isSelect ? selectedColor : kBackgroundColor
            ),
            child: Text(
              genre,
              style: TextStyle(color: !isSelect ? Colors.black26 : kBackgroundColor, fontSize: 16),
            ),
          );
        }
      ),
    );
  }
}