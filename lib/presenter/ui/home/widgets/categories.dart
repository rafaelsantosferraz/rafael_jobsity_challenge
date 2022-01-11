import 'package:flutter/material.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/values.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/colors.dart';


class CategoryList extends StatelessWidget {

  final Function(String category) onCategoryChange;
  final List<String> categories;
  final String initialSelectedCategory;
  final List<ValueNotifier<bool>> selectedCategories;

  CategoryList({Key? key, required this.onCategoryChange, required this.categories, required this.initialSelectedCategory}):
    selectedCategories = List.generate(categories.length, (index) => ValueNotifier(categories[index] == initialSelectedCategory)),
    super(key: key);



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) => buildCategory(index, context),
      ),
    );
  }

  Padding buildCategory(int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ValueListenableBuilder<bool>(
                valueListenable: selectedCategories[index],
                builder: (context, isSelect, _) {
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: kAnimationDuration),
                  opacity: isSelect ? 1 : 0.2,
                  child: Text(
                    categories[index],
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: kTextColor
                    ),
                  ),
                );
              }
            ),
            _Underline(isSelect: selectedCategories[index], color: kCategoryColors[categories[index]]!,)
          ],
        ),
      ),
    );
  }

  //region Private -------------------------------------------------------------
  void onTap(int index){
    for (var e in selectedCategories) {
      e.value = selectedCategories.indexOf(e) == index;
    }
    assert(selectedCategories.where((category) => category.value == true).length == 1);
    onCategoryChange(categories[index]);
  }
  //endregion
}

class _Underline extends StatelessWidget {

  final ValueNotifier<bool> isSelect;
  final Color color;

  const _Underline({Key? key, required this.isSelect, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isSelect,
      builder: (context, isSelect, _) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
          height: 6,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isSelect ? color : Colors.transparent,
          ),
        );
      }
    );
  }
}
