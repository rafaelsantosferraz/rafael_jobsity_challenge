
import 'package:flutter/material.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';
import 'package:rafael_jobsity_challenge/presenter/navigation/navigation_controller.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/colors.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/values.dart';


class TvShowsList extends StatefulWidget {

  final List<TvShow> tvShows;
  final ValueNotifier<Color> color;
  final List<String> selectedGenres;
  final VoidCallback onListEnd;
  final ValueNotifier<bool> isEnd;
  final ValueNotifier<int> pageIndex;

  const TvShowsList({Key? key,
    required this.tvShows,
    required this.color,
    required this.selectedGenres,
    required this.onListEnd,
    required this.isEnd,
    required this.pageIndex
  }) : super(key: key);

  @override
  _TvShowsListState createState() => _TvShowsListState();
}

class _TvShowsListState extends State<TvShowsList> {
  late PageController _pageController;

  get listener => (){
    if(_pageController.page?.toInt() != widget.pageIndex.value && widget.pageIndex.value == 0){
      _pageController.jumpToPage(0);
    }
  };

  @override
  void initState() {
    super.initState();
    widget.pageIndex.addListener(listener);
    _pageController = PageController(
      viewportFraction: 0.8,
      initialPage: widget.pageIndex.value,
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.pageIndex.removeListener(listener);
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var filteredTvShows = _filter(widget.tvShows, widget.selectedGenres);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: AspectRatio(
        aspectRatio: 0.85,
        child: PageView.builder(
          onPageChanged: (value) {
            widget.pageIndex.value = value;
          },
          controller: _pageController,
          physics: const ClampingScrollPhysics(),
          itemCount: filteredTvShows.length, // we have 3 demo movies
          itemBuilder: (context, index) =>
            ValueListenableBuilder<int>(
              valueListenable: widget.pageIndex,
              builder: (context, pageIndex, _) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    if(index == filteredTvShows.length - 2 || filteredTvShows.length == 1){
                      widget.onListEnd();
                    }
                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: kAnimationDuration),
                      opacity: pageIndex == index ? 1 : 0.6,
                      child: _TvShowCard(tvShow: filteredTvShows[index], index: index, color: widget.color,),
                    );
                  }
                );
              }
            ),
        ),
      ),
    );
  }

  List<TvShow> _filter(List<TvShow> tvShows, List<String> selectedGenres){
    if(selectedGenres.isEmpty){
      return tvShows;
    }
    var filteredTvShow = tvShows.where((tvShow) {
      bool isGenre = true;
      for (var genre in selectedGenres) {
        isGenre = tvShow.genres.contains(genre) && isGenre;
      }
      return isGenre;
    }).toList();
    return filteredTvShow;
  }

  List<TvShow> _filter2(List<TvShow> tvShows, List<String> selectedGenres){
    if(selectedGenres.isEmpty){
      return tvShows;
    }
    var filteredTvShow = tvShows.where((tvShow) {
      bool isGenre = false;
      for (var genre in tvShow.genres) {
        if(selectedGenres.contains(genre)){
          isGenre = true;
          break;
        }
      }
      return isGenre;
    }).toList();
    return filteredTvShow;
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
      child: GestureDetector(
        onTap: () => _onClick(context),
        child: Column(
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
                    Hero(
                      tag: 'hero_${tvShow.id}',
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: const [kDefaultShadow],
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(tvShow.posterUrl),
                          ),
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
        ),
      ),
    );
  }

  _onClick(BuildContext context){
    NavigationController.addEvent(NavigationEvent.goToTvShow(context, tvShow, color));
  }
}