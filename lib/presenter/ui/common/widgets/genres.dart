import 'package:flutter/material.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/colors.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/values.dart';





class Genres extends StatelessWidget {

  final List<String> genres;
  final Function(String genre) onGenreTap;
  final ValueNotifier<Color> color;
  final ValueNotifier<List<String>>? selectGenres;
  final bool isSelectable;

  const Genres({Key? key, required this.genres,
    required this.onGenreTap,
    required this.color,
    this.selectGenres,
    this.isSelectable = true,
  }) :

        super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: genres.length,
        itemBuilder: (context, index) =>
          Padding(
            padding: EdgeInsets.only(right: index == genres.length - 1 ? kDefaultPadding : 0),
            child: GenreCard(initialIsSelect: selectGenres?.value.contains(genres[index]),genre: genres[index], onTap: (genre) => onGenreTap(genre), selectedColor: color, isSelectable: isSelectable,),
          ),
      ),
    );
  }
}

class GenreCard extends StatelessWidget {
  final String genre;
  final bool? initialIsSelect;
  final Function(String) onTap;
  final ValueNotifier<Color> selectedColor;
  final bool isSelectable;
  final ValueNotifier<bool> isSelect;

  GenreCard({Key? key,
    required this.genre,
    required this.onTap,
    required this.selectedColor,
    this.initialIsSelect = false,
    this.isSelectable = true
  }) :
      isSelect = ValueNotifier(initialIsSelect ?? false),
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(isSelectable) {
          isSelect.value = !isSelect.value;
          onTap(genre);
        }
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: isSelect,
        builder: (context, isSelect, _) {
          return ValueListenableBuilder<Color>(
              valueListenable: selectedColor,
              builder: (context, selectedColor, _) {
              return Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: kDefaultPadding),
                padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding,
                  vertical: kDefaultPadding / 4, // 5 padding top and bottom
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: isSelectable ?
                    !isSelect ? Colors.black26 : selectedColor
                    : selectedColor
                  ),
                  borderRadius: BorderRadius.circular(20),
                  color: isSelectable ?
                        isSelect ? selectedColor : kBackgroundColor
                        : selectedColor
                ),
                child: Text(
                  genre,
                  style: TextStyle(
                      color: isSelectable ?
                          !isSelect ? Colors.black26 : kBackgroundColor
                          : kBackgroundColor,
                      fontSize: 16),
                ),
              );
            }
          );
        }
      ),
    );
  }
}