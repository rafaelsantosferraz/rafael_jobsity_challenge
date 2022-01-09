import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rafael_jobsity_challenge/domain/entities/episode.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/colors.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/values.dart';

class EpisodeDialog extends StatelessWidget {
  final Episode episode;

  const EpisodeDialog({Key? key, required this.episode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: <Widget>[
        GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const DialogBackground()
        ),
         Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 4,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24)
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(episode.poster ?? ''),
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
                          color: kBackgroundColor
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: kDefaultPadding / 2,
                                bottom: kDefaultPadding / 2,
                                left: kDefaultPadding,
                                right: 56 + 16,
                              ),
                              child: Text(
                                episode.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: kDefaultPadding / 8,
                                horizontal: kDefaultPadding,
                              ),

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Season ${episode.season}",
                                    style: Theme.of(context).textTheme.subtitle1!.copyWith(color: kTextLightColor),
                                  ),
                                  const SizedBox(width: kDefaultPadding,),
                                  Text(
                                    "Episode ${episode.number}",
                                    style: Theme.of(context).textTheme.subtitle1!.copyWith(color: kTextLightColor),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: kDefaultPadding / 2,
                                horizontal: kDefaultPadding,
                              ),
                              child: Text(
                                "Summary",
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                              child: Text(
                                episode.summary.replaceAll(RegExp(r'<[^>]*>'), ""),
                                style: const TextStyle(
                                  color: kTextLightColor,
                                ),
                              ),
                            ),
                            kVerticalGap
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                      top: 160 - 28,
                      right: 16,
                      child: FloatingActionButton(
                        child: const Icon(Icons.play_arrow),
                        onPressed: (){}
                      )
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DialogBackground extends StatelessWidget {
  const DialogBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ClipRect(
          child: SizedBox(
            width: MediaQuery.of(context).size.width ,
            height: MediaQuery.of(context).size.height ,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
              child: Container(
                color: Colors.white.withOpacity(.5),
              ),
            ),
          ),
        )
    );
  }
}

