import 'package:flutter/material.dart';
import 'package:rafael_jobsity_challenge/domain/entities/actor.dart';
import 'package:rafael_jobsity_challenge/domain/entities/episode.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';
import 'package:rafael_jobsity_challenge/presenter/navigation/navigation_controller.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/colors.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/values.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/widgets/genres.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/tv_show/tv_show_controller.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/tv_show/tv_show_state.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/tv_show/widgets/actors.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/tv_show/widgets/episode_tile.dart';

import 'widgets/backdrop_rating.dart';
import 'widgets/header.dart';

class TvShowPageArguments {
  final TvShow tvShow;
  final ValueNotifier<Color> color;

  TvShowPageArguments({required this.tvShow, required this.color});
}
class TvShowPage extends StatelessWidget {

  final TvShow _tvShow;
  final ValueNotifier<Color> _color;
  final TvShowController _tvShowController;

  TvShowPage({Key? key,
    required TvShowPageArguments tvShowPageArguments,
  }):
    _tvShow = tvShowPageArguments.tvShow,
    _color = tvShowPageArguments.color,
    _tvShowController = TvShowController(tvShowPageArguments.tvShow),
    super(key: key){
      _tvShowController.state.listen(onStateChange);
    }

  final ValueNotifier<List<Episode>?> _episodes = ValueNotifier([]);
  final ValueNotifier<List<Actor>?> _actors = ValueNotifier([]);
  final ValueNotifier<bool?> _isFavorite = ValueNotifier(null);

  onStateChange(TvShowState state){
    _episodes.value = state.episodes;
    _isFavorite.value = state.isFavorite;
    _actors.value = state.actors;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BackdropAndRating(size: size, tvShow: _tvShow),
            const SizedBox(height: kDefaultPadding / 2),
            Header(
                tvShow: _tvShow,
                isFavorite: _isFavorite,
                favoriteClick: _favoriteClick
            ),
            if(_tvShow.genres.isNotEmpty)...[
              Genres(
                genres: _tvShow.genres,
                onGenreTap: (genre){},
                color: _color,
                isSelectable: false,
              ),
              kVerticalGap,
            ],
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: kDefaultPadding / 2,
                horizontal: kDefaultPadding,
              ),
              child: Text(
                "Summary",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Text(
                _tvShow.summary.replaceAll(RegExp(r'<[^>]*>'), ""),
                style: const TextStyle(
                  color: kTextLightColor,
                ),
              ),
            ),
            //CastAndCrew(casts: tvShow.cast),
            kVerticalGap,
            ValueListenableBuilder<List<Actor>?>(
                valueListenable: _actors,
                builder: (context, _actors, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: kDefaultPadding / 2,
                          horizontal: kDefaultPadding,
                        ),
                        child: Text(
                          "Cast",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      Actors(
                        actors: _actors ?? [],
                        onActorTap: (actor) => _onActorTap(context, actor),
                      ),
                      kVerticalGap,
                    ],
                  );
                }
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding,
              ),
              child: Text(
                "Episodes",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: ValueListenableBuilder<List<Episode>?>(
                  valueListenable: _episodes,
                  builder: (context, _episodes, _) {
                    if(_episodes == null) {
                      return const Padding(
                        padding:  EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      );
                    }
                    var season = 0;
                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _episodes.length,
                        itemBuilder: (context, index){
                          var episode = _episodes[index];
                          if(season != episode.season){
                            season = episode.season;
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if(index != 0) kVerticalGap,
                                  Text('Season ${episode.season}', style: Theme.of(context).textTheme.headline6,),
                                  kVerticalGap,
                                  EpisodeTile(episode: episode)
                                ]
                            );
                          }
                          return EpisodeTile(episode: episode);
                        }
                    );
                  }
              ),
            ),
            kVerticalGap,
            kVerticalGap,
          ],
        ),
      ),
    );
  }

  //region Private -------------------------------------------------------------
  void _favoriteClick(bool isFavorite){
    isFavorite
      ? _tvShowController.addEvent(TvShowEvent.addFavorite(_tvShow))
      : _tvShowController.addEvent(TvShowEvent.removeFavorite(_tvShow));
  }

  void _onActorTap(BuildContext context, Actor actor){
    NavigationController.addEvent(NavigationEvent.goToActor(context, actor));
  }
  //endregion
}
