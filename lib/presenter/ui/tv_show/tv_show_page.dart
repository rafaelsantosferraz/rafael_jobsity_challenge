
import 'package:flutter/material.dart';
import 'package:rafael_jobsity_challenge/domain/entities/episode.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/strings.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/values.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/widgets/genres.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/tv_show/tv_show_controller.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/tv_show/widgets/episode.dart';

import 'widgets/backdrop_rating.dart';
import 'widgets/header.dart';

class TvShowPage extends StatelessWidget {

  final TvShow tvShow;
  final ValueNotifier<Color> color;
  final TvShowController _tvShowController;

  TvShowPage({Key? key,
    required this.tvShow,
    required this.color
  }):
    _tvShowController = TvShowController(tvShow),
    super(key: key){
      _tvShowController.state.listen((state){
        _episodes.value = state.episodes;
      });
    }

  final ValueNotifier<String> _selectCategory = ValueNotifier(categories[0]);
  final ValueNotifier<List<Episode>?> _episodes = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        _tvShowController.close();
        return true;
      },
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BackdropAndRating(size: size, tvShow: tvShow),
            const SizedBox(height: kDefaultPadding / 2),
            Header(tvShow: tvShow),
            Genres(
              genres: tvShow.genres,
              onGenreTap: (genre){},
              color: color,
              isSelectable: false,
            ),
            kVerticalGap,
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
                tvShow.summary.replaceAll(RegExp(r'<[^>]*>'), ""),
                style: const TextStyle(
                  color: Color(0xFF737599),
                ),
              ),
            ),
            //CastAndCrew(casts: tvShow.cast),
            kVerticalGap,
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: kDefaultPadding/2,
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
                    return const CircularProgressIndicator();
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
                              kVerticalGap,
                              Text('Season ${episode.season}', style: Theme.of(context).textTheme.headline6,),
                              kVerticalGap,
                              EpisodeView(episode: episode)
                            ]
                          );
                        }
                        return EpisodeView(episode: episode);
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
  void _onFavorite(){
    _tvShowController.addEvent(TvShowEvent.favorite(tvShow, true)); //todo: finish
  }
  //endregion
}
