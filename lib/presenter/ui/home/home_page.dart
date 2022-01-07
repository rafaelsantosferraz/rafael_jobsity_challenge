
import 'package:flutter/material.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/colors.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/strings.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/values.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/home/home_controller.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/home/widgets/appbar.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/home/widgets/categories.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/home/widgets/genres.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/home/widgets/tv_shows.dart';

class HomePage extends StatelessWidget {

  final HomeController _homeController;

  HomePage({Key? key}):
    _homeController = HomeController(),
    super(key: key){
      _homeController.addEvent(HomeEvent.start());
    }

  final ValueNotifier<String> _selectCategory = ValueNotifier(categories[0]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    selectedColor: kCategoryColors[_selectCategory]!
                  );
                }
              ),
              kVerticalGap,
              const TvShowsList(),
            ],
          ),
        ),
      )
    );
  }

  //region Private -------------------------------------------------------------
  void _onCategoryChange(String category){
    _homeController.addEvent(HomeEvent.categorySelect(category));
    _selectCategory.value = category;
  }

  void _onGenreTap(String genre) =>
    _homeController.addEvent(HomeEvent.genreTapEvent(genre));
  //endregion
}
