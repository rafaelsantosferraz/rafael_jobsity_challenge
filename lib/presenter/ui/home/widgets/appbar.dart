import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/colors.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/values.dart';



class HomeAppBar extends StatefulWidget implements PreferredSizeWidget{

  final Function(String) onSearchText;
  final Function(bool) onSearchToggle;

  @override
  final _PreferredAppBarSize preferredSize;

  HomeAppBar({Key? key, required this.onSearchText, required this.onSearchToggle}) :
      preferredSize = _PreferredAppBarSize(null, null),
        super(key: key);

  @override
  _HomeAppBarState createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {


  final ValueNotifier<bool> isSearch = ValueNotifier(false);
  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isSearch,
      builder: (context, isSearch, _) {
        return AppBar(
          backgroundColor: kBackgroundColor,
          elevation: 0,
          flexibleSpace: isSearch
            ? Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Expanded(child:
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: kDefaultPadding/2, right: kDefaultPadding/2, top: kDefaultPadding/4, bottom: kDefaultPadding/4),
                    padding: const EdgeInsets.only(left: kDefaultPadding, right: kDefaultPadding),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(200)),
                      color: Colors.grey.withOpacity(.2),
                    ),
                    child: TextField(
                      onChanged: (text) => widget.onSearchText(text),
                      controller: _editingController,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Search...',
                        hintStyle: TextStyle(fontStyle: FontStyle.italic, color: kTextLightColor,)
                      ),
                    ),
                  )
                ),
              ],
            )
            : null,
          leading: !isSearch
            ? IconButton(
              padding: const EdgeInsets.only(left: kDefaultPadding),
              icon: SvgPicture.asset("assets/icons/menu.svg"),
              onPressed: () {},
            )
            : null,
          actions: <Widget>[
            isSearch
              ? IconButton(
                padding: const EdgeInsets.only(right: kDefaultPadding),
                icon: const Icon(Icons.close, color: kTextColor,),
                onPressed: _toggleSearch,
              )
              : IconButton(
                padding: const EdgeInsets.only(right: kDefaultPadding),
                icon: SvgPicture.asset("assets/icons/search.svg"),
                onPressed: _toggleSearch,
              ),
          ],
        );
      }
    );
  }

  _toggleSearch(){
    widget.onSearchToggle(!isSearch.value);
    isSearch.value = !isSearch.value;
  }
}

class _PreferredAppBarSize extends Size {
  _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight)
      : super.fromHeight((toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));

  final double? toolbarHeight;
  final double? bottomHeight;
}