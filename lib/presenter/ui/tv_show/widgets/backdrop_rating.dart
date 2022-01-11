import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/colors.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/values.dart';

class BackdropAndRating extends StatelessWidget {
  const BackdropAndRating({
    Key? key,
    required this.size,
    required this.tvShow,
  }) : super(key: key);

  final Size size;
  final TvShow tvShow;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.5,
      child: Stack(
        children: <Widget>[
          Hero(
            tag: 'hero',
            child: Container(
              height: size.height * 0.5 - 50,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(50)),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(tvShow.posterUrl),
                ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      if(tvShow.rating != null)...[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            SvgPicture.asset("assets/icons/star_fill.svg"),
                            const SizedBox(height: kDefaultPadding / 4),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: "${tvShow.rating}/",
                                    style:  const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  const TextSpan(text: "10\n"),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                      // Rate this
                      // Column(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: <Widget>[
                      //     SvgPicture.asset("assets/icons/star.svg"),
                      //     const SizedBox(height: kDefaultPadding / 4),
                      //     Text("Rate This",
                      //         style: Theme.of(context).textTheme.bodyText2),
                      //   ],
                      // ),
                      // Metascore
                      if(tvShow.weight != null)...[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF51CF66),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text(
                                "${tvShow.weight}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: kDefaultPadding / 4),
                            const Text(
                              "Weight",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
                        )
                      ]
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