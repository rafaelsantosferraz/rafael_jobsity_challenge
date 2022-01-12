
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

import 'widgets/tv_shows_list.dart';

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
    } else if (state.selectCategory == favorites) {
      _tvShowList.value = state.favorites;
    } else {
      _tvShowList.value = state.tvShows;
    }
    _selectedGenres.value   = state.selectedGenres ?? [];
    if(_isSearching.value != state.isSearching || state.selectCategory != _homeController.previousState?.selectCategory){
      _pageIndex.value = 0;
    }
    _selectCategory.value = state.isSearching ? search : state.selectCategory;
    _isSearching.value    = state.isSearching;
    _color.value          = kCategoryColors[_selectCategory.value]!;
  }

  final ValueNotifier<String> _selectCategory = ValueNotifier(categories[0]);
  final ValueNotifier<List<String>> _selectedGenres = ValueNotifier([]);
  final ValueNotifier<Color> _color = ValueNotifier(kCategoryColors[categories[0]]!);
  final ValueNotifier<List<TvShow>?> _tvShowList = ValueNotifier(null);
  final ValueNotifier<bool> _isSearching = ValueNotifier(false);
  final ValueNotifier<bool> _isEnd = ValueNotifier(false);
  final ValueNotifier<int> _pageIndex = ValueNotifier(0);

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
                ValueListenableBuilder<String>(
                    valueListenable: _selectCategory,
                    builder: (context, _selectCategory, _) {
                    return CategoryList(
                      categories: _selectCategory == search ? [search] : categories,
                      initialSelectedCategory: _selectCategory,
                      onCategoryChange: _onCategoryChange,
                    );
                  }
                ),
                ValueListenableBuilder(
                  valueListenable: _selectCategory,
                  builder: (context, _selectCategory, _) {
                    return Genres(
                      genres: genres,
                      selectGenres: _selectedGenres,
                      onGenreTap: _onGenreTap,
                      color: _color
                    );
                  }
                ),
                kVerticalGap,
                ValueListenableBuilder<List<TvShow>?>(
                    valueListenable: _tvShowList,
                    builder: (context, _tvShows, _) {
                    if(_tvShows == null) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      );
                    }
                    if(_tvShows.isEmpty) {
                      return const Text('No result');
                    }
                    return ValueListenableBuilder<List<String>>(
                      valueListenable: _selectedGenres,
                      builder: (context, _selectGenres, _) {
                        return TvShowsList(
                          pageIndex: _pageIndex,
                          tvShows: _tvShows,
                          color: _color,
                          selectedGenres: _selectGenres,
                          isEnd: _isEnd,
                          onListEnd: () => _onListEnd(),
                        );
                      }
                    );
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

  void _onListEnd() =>
      _homeController.addEvent(HomeEvent.listEnd());
  //endregion
}
