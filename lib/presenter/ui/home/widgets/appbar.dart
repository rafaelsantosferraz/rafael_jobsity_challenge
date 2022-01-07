import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/colors.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/values.dart';

final appBar = AppBar(
  backgroundColor: kBackgroundColor,
  elevation: 0,
  leading: IconButton(
    padding: const EdgeInsets.only(left: kDefaultPadding),
    icon: SvgPicture.asset("assets/icons/menu.svg"),
    onPressed: () {},
  ),
  actions: <Widget>[
    IconButton(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      icon: SvgPicture.asset("assets/icons/search.svg"),
      onPressed: () {},
    ),
  ],
);
