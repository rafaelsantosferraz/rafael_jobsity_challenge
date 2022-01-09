
import 'package:flutter/material.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';
import 'package:rafael_jobsity_challenge/presenter/navigation/navigation_controller.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/colors.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/strings.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/values.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/home/home_controller.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/home/home_state.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/home/widgets/appbar.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/home/widgets/categories.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/widgets/genres.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/home/widgets/tv_shows.dart';

class HomePage extends StatelessWidget {

  final HomeController _homeController;

  HomePage({Key? key}):
    _homeController = HomeController(),
    super(key: key){
      _homeController.state.listen(onStateChange);
      _homeController.addEvent(HomeEvent.start());
    }

  void onStateChange(HomeState state){
    if(state.isSearching){
      _tvShowList.value = state.tvSearch;
    } else {
      _tvShowList.value = state.tvShows;
    }
    _isSearching.value = state.isSearching;
    _color.value       = state.isSearching && !(_homeController.previousState?.isSearching ?? false) ? kCategoryColors[search]! : kCategoryColors[tvShow]!;
    if(!state.isSearching && (_homeController.previousState?.isSearching ?? true)){
      _selectCategory.value = tvShow;
    }
  }

  final ValueNotifier<String> _selectCategory = ValueNotifier(categories[0]);
  final ValueNotifier<Color>  _color = ValueNotifier(kCategoryColors[categories[0]]!);
  final ValueNotifier<List<TvShow>> _tvShowList = ValueNotifier([]);
  final ValueNotifier<bool> _isSearching = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      NavigationController.addEvent(NavigationEvent.homeReady(NavigationController.navigatorKey.currentContext!));
    });
    return WillPopScope(
      onWillPop: () async {
        _homeController.close();
        return true;
      },
      child: Scaffold(
        appBar: HomeAppBar(
          onSearchText: (text) => _onSearchText(text),
          onSearchToggle: (isOpen) => _onSearchToggle(isOpen)
        ),
        body: Container(
          color: kBackgroundColor,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                kVerticalGap,
                ValueListenableBuilder<bool>(
                    valueListenable: _isSearching,
                    builder: (context, _isSearching, _) {
                    return CategoryList(
                      categories: _isSearching ? [search] : categories,
                      onCategoryChange: _onCategoryChange,
                    );
                  }
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
                    valueListenable: _tvShowList,
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
    _homeController.addEvent(HomeEvent.genreTap(genre));

  void _onSearchText(String text) =>
      _homeController.addEvent(HomeEvent.searchText(text));

  void _onSearchToggle(bool isOpen) =>
      _homeController.addEvent(HomeEvent.searchToggle(isOpen));
  //endregion
}
