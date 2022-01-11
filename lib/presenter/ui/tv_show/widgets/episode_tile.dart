import 'package:flutter/material.dart';
import 'package:rafael_jobsity_challenge/domain/entities/episode.dart';
import 'package:rafael_jobsity_challenge/presenter/navigation/navigation_controller.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/values.dart';

class EpisodeTile extends StatelessWidget {

  final Episode episode;

  const EpisodeTile({Key? key, required this.episode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _goToEpisode(context),
      child: Padding(
        padding: const EdgeInsets.only(bottom: kDefaultPadding/2),
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * .25,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(kDefaultPadding/2)),
                child: Image(
                  fit: BoxFit.cover,
                  image: NetworkImage(episode.thumb ?? ''),
                ),
              ),
            ),
            const SizedBox(width: kDefaultPadding/2,),
            Flexible(child:Text(episode.name))
          ],
        ),
      ),
    );
  }

  void _goToEpisode(BuildContext context){
    NavigationController.addEvent(NavigationEvent.goToEpisode(context, episode));
  }
}
