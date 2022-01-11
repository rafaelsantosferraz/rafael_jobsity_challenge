import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/colors.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/values.dart';

class Header extends StatelessWidget {

  final Function(bool) favoriteClick;

  const Header({
    Key? key,
    required this.tvShow,
    required this.isFavorite,
    required this.favoriteClick,
  }) : super(key: key);

  final TvShow tvShow;
  final ValueNotifier<bool?> isFavorite;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  tvShow.name,
                  style: Theme.of(context).textTheme.headline5,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: kDefaultPadding / 2),
                Row(
                  children: <Widget>[
                    Text(
                      tvShow.premiered != null ?  'Released on ${tvShow.premiered!.year}-${tvShow.premiered!.month}-${tvShow.premiered!.day}' : '',
                      style: const TextStyle(color: kTextLightColor),
                    ),
                  ],
                )
              ],
            ),
          ),
          FavoriteIcon(isFavorite: isFavorite, favoriteClick: favoriteClick),
        ],
      ),
    );
  }
}

class FavoriteIcon extends StatelessWidget {

  final ValueNotifier<bool?> isFavorite;
  final Function(bool) favoriteClick;

  const FavoriteIcon({Key? key, required this.isFavorite, required this.favoriteClick}) :
    super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding/4),
      child: IconButton(
        onPressed: () {
          if(isFavorite.value != null){
            isFavorite.value = !isFavorite.value!;
            favoriteClick(isFavorite.value!);
          }
        },
        icon: ValueListenableBuilder<bool?>(
          valueListenable: isFavorite,
          builder: (context, isSelect, _) {
            return Icon(
              Icons.favorite,
              size: 32,
              color: isSelect == null ?
                Colors.transparent
                : isSelect ? Colors.red : Colors.grey,
            );
          }
        ),
      ),
    );
  }
}
