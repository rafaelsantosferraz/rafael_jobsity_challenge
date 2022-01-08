
import 'package:flutter/material.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/colors.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/strings.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/values.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/home/home_controller.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/home/widgets/appbar.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/home/widgets/categories.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/widgets/genres.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/home/widgets/tv_shows.dart';

class HomePage extends StatelessWidget {

  final HomeController _homeController;

  HomePage({Key? key}):
    _homeController = HomeController(),
    super(key: key){
      _homeController.state.listen((state){
        _tvShows.value = state.tvShows;
      });
      _homeController.addEvent(HomeEvent.start());
    }

  final ValueNotifier<String> _selectCategory = ValueNotifier(categories[0]);
  final ValueNotifier<Color> _color = ValueNotifier(kCategoryColors[categories[0]]!);
  final ValueNotifier<List<TvShow>> _tvShows = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _homeController.close();
        return true;
      },
      child: Scaffold(
        appBar: appBar,
        body: Container(
          color: kBackgroundColor,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                CategoryList(
                  categories: categories,
                  onCategoryChange: _onCategoryChange,
                ),
                ValueListenableBuilder(
                  valueListenable: _selectCategory,
                  builder: (context, _selectCategory, _) {
                    return Genres(
                      genres: genres,
                      onGenreTap: _onGenreTap,
                      color: _color
                    );
                  }
                ),
                kVerticalGap,
                ValueListenableBuilder<List<TvShow>>(
                    valueListenable: _tvShows,
                    builder: (context, _tvShows, _) {
                    return TvShowsList(tvShows: _tvShows, color: _color);
                  }
                ),
              ],
            ),
          ),
        )
      ),
    );
  }



  //region Private -------------------------------------------------------------
  void _onCategoryChange(String category){
    _homeController.addEvent(HomeEvent.categorySelect(category));
    _selectCategory.value = category;
    _color.value = kCategoryColors[category]!;
  }

  void _onGenreTap(String genre) =>
    _homeController.addEvent(HomeEvent.genreTapEvent(genre));
  //endregion
}
