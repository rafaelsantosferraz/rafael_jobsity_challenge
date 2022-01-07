import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/values.dart';

import 'dart:math' as math;


class TvShowsList extends StatefulWidget {
  const TvShowsList({Key? key}) : super(key: key);

  @override
  _TvShowsListState createState() => _TvShowsListState();
}

class _TvShowsListState extends State<TvShowsList> {
  late PageController _pageController;
  int initialPage = 1;

  final tvShows = List<TvShow>.generate(3, (index) =>
    TvShow(
      name: '$index',
      posterUrl: "",
      airs: DateTime.now(),
      genres: [],
      summary: "",
      episodes: []
    )
  );



  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      // so that we can have small portion shown on left and right side
      viewportFraction: 0.8,
      // by default our movie poster
      initialPage: initialPage,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: AspectRatio(
        aspectRatio: 0.85,
        child: PageView.builder(
          onPageChanged: (value) {
            setState(() {
              initialPage = value;
            });
          },
          controller: _pageController,
          physics: const ClampingScrollPhysics(),
          itemCount: tvShows.length, // we have 3 demo movies
          itemBuilder: (context, index) =>
            AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: kAnimationDuration),
                  opacity: initialPage == index ? 1 : 0.4,
                  child: _TvShowCard(tvShow: tvShows[index]),
                );
              }
            ),
        ),
      ),
    );
  }
}

class _TvShowCard extends StatelessWidget {
  final TvShow tvShow;

  const _TvShowCard({Key? key, required this.tvShow}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: OpenContainer(
        closedElevation: 0,
        openElevation: 0,
        closedBuilder: (context, action) => buildMovieCard(context),
        openBuilder: (context, action) => Container(),
      ),
    );
  }

  Column buildMovieCard(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              boxShadow: const [kDefaultShadow],
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(tvShow.posterUrl),
              ),
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
        //   child: Text(
        //     tvShow.name,
        //     style: Theme.of(context)
        //         .textTheme
        //         .headline5!
        //         .copyWith(fontWeight: FontWeight.w600),
        //   ),
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              "assets/icons/star_fill.svg",
              height: 20,
            ),
            // const SizedBox(width: kDefaultPadding / 2),
            // Text(
            //   "${tvshow.rating}",
            //   style: Theme.of(context).textTheme.bodyText2,
            // )
          ],
        )
      ],
    );
  }
}