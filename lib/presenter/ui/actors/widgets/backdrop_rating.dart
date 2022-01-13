import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rafael_jobsity_challenge/domain/entities/actor.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/colors.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/values.dart';

class BackdropAndRating extends StatelessWidget {
  const BackdropAndRating({
    Key? key,
    required this.size,
    required this.actor,
  }) : super(key: key);

  final Size size;
  final Actor actor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.5,
      child: Stack(
        children: <Widget>[
          Container(
            height: size.height * 0.5 - 50,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(50)),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(actor.poster ?? ''),
              ),
            ),
          ),
          // Rating Box
          Positioned(
            bottom: 0,
            right: 0,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: size.width * .45
              ),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    topLeft: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 5),
                      blurRadius: 50,
                      color: const Color(0xFF12153D).withOpacity(0.2),
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(kDefaultPadding),
                        child: Text(
                          actor.name,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Back Button
          SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 24 + 12,
                  width:  24 + 12,
                  decoration: BoxDecoration(
                  color: kBackgroundColor.withOpacity(.6),
                    borderRadius: const BorderRadius.all(Radius.circular(100))
                  )
                ),
                const BackButton(),
              ],
            )
          ),
        ],
      ),
    );
  }
}