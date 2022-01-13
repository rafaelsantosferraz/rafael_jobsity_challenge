import 'package:flutter/cupertino.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/values.dart';

class TvShowTile extends StatelessWidget {

  final TvShow tvShow;

  const TvShowTile({Key? key, required this.tvShow}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _goToEpisode(context),
      child: SizedBox(
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(kDefaultPadding/2)),
          child: Image(
            fit: BoxFit.cover,
            image: NetworkImage(tvShow.posterUrl ?? ''),
          ),
        ),
      ),
    );
  }

  void _goToEpisode(BuildContext context){
    //NavigationController.addEvent(NavigationEvent.goToEpisode(context, episode));
  }
}
