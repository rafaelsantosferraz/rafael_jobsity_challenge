import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/colors.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/values.dart';

import 'dart:math' as math;

import 'package:rafael_jobsity_challenge/presenter/ui/tv_show/tv_show_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


class TvShowsList extends StatefulWidget {

  final List<TvShow> tvShows;
  final ValueNotifier<Color> color;

  const TvShowsList({Key? key,required this.tvShows, required this.color}) : super(key: key);

  @override
  _TvShowsListState createState() => _TvShowsListState();
}

class _TvShowsListState extends State<TvShowsList> {
  late PageController _pageController;
  int initialPage = 0;

  // final tvShows = List<TvShow>.generate(3, (index) =>
  //   TvShow(
  //     id: 0,
  //     name: '$index',
  //     posterUrl: "",
  //     airs: DateTime.now(),
  //     genres: [],
  //     summary: "",
  //     episodes: []
  //   )
  // );



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
          itemCount: widget.tvShows.length, // we have 3 demo movies
          itemBuilder: (context, index) =>
            AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: kAnimationDuration),
                  opacity: initialPage == index ? 1 : 0.8,
                  child: _TvShowCard(tvShow: widget.tvShows[index], index: index, color: widget.color,),
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
  final int index;
  final ValueNotifier<Color> color;

  const _TvShowCard({Key? key, required this.tvShow, required this.index, required this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: OpenContainer(
        closedElevation: 0,
        openElevation: 0,
        closedBuilder: (context, action) {
          return Column(
            children: <Widget>[
              Expanded(
                child: AspectRatio(
                  aspectRatio: 0.85,
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const [kDefaultShadow],
                          color: kTextLightColor,
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                                'assets/icons/movie.png',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const [kDefaultShadow],
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(tvShow.posterUrl),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              kVerticalGap,
              kVerticalGap,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  // SvgPicture.asset(
                  //   "assets/icons/star_fill.svg",
                  //   height: 20,
                  // ),
                  // const SizedBox(width: kDefaultPadding / 2),
                  // Text(
                  //   "${tvshow.rating}",
                  //   style: Theme.of(context).textTheme.bodyText2,
                  // )
                ],
              )
            ],
          );
        },
        openBuilder: (context, action)   => TvShowPage(tvShow: tvShow, color: color),
      ),
    );
  }
}