import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/colors.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/values.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.tvShow,
  }) : super(key: key);

  final TvShow tvShow;

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
          FavoriteIcon(startState: false)
        ],
      ),
    );
  }
}

class FavoriteIcon extends StatelessWidget {

  final bool startState;
  final ValueNotifier<bool> _isSelect;

  FavoriteIcon({Key? key, this.startState = false}) :
    _isSelect = ValueNotifier(startState),
    super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding/4),
      child: IconButton(
        onPressed: () => _isSelect.value = !_isSelect.value,
        icon: ValueListenableBuilder<bool>(
          valueListenable: _isSelect,
          builder: (context, _isSelect, _) {
            return Icon(
              Icons.favorite,
              size: 32,
              color: _isSelect ? Colors.red : Colors.grey,
            );
          }
        ),
      ),
    );
  }
}
