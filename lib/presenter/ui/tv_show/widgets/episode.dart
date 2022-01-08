import 'package:flutter/cupertino.dart';
import 'package:rafael_jobsity_challenge/domain/entities/episode.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/values.dart';

class EpisodeView extends StatelessWidget {

  final Episode episode;

  const EpisodeView({Key? key, required this.episode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kDefaultPadding/2),
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            width: MediaQuery.of(context).size.width * .25,
            child: Image(
              image: NetworkImage(episode.imageUrl ?? ''),
            ),
          ),
          const SizedBox(width: kDefaultPadding/2,),
          Text(episode.name)
        ],
      ),
    );
  }
}
