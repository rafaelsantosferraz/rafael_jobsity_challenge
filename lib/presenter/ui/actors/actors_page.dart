
import 'package:flutter/material.dart';
import 'package:rafael_jobsity_challenge/domain/entities/actor.dart';
import 'package:rafael_jobsity_challenge/domain/entities/tv_show.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/actors/actors_controller.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/actors/actors_state.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/actors/widgets/tvshow_tile.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/values.dart';

import 'widgets/backdrop_rating.dart';

class ActorPage extends StatelessWidget {

  final Actor actor;
  final ActorController _actorController;

  ActorPage({Key? key,
    required this.actor,
  }):
    _actorController = ActorController(actor),
    super(key: key){
      _actorController.state.listen(onStateChange);
    }


  onStateChange(ActorState state){
    _tvShowList.value = state.tvShows;
  }

  final ValueNotifier<List<TvShow>?> _tvShowList = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BackdropAndRating(size: size, actor: actor),
            const SizedBox(height: kDefaultPadding / 2),
            kVerticalGap,
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: kDefaultPadding/2,
                horizontal: kDefaultPadding,
              ),
              child: Text(
                "Series",
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: ValueListenableBuilder<List<TvShow>?>(
                valueListenable: _tvShowList,
                builder: (context, _tvShowList, _) {
                  if(_tvShowList == null) {
                    return const CircularProgressIndicator();
                  }
                  return GridView.builder(
                      scrollDirection: Axis.vertical,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 2/3
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _tvShowList.length,
                      itemBuilder: (context, index){
                        return TvShowTile(tvShow: _tvShowList[index]);
                      }
                  );
                }
              ),
            ),
            kVerticalGap,
            kVerticalGap,
          ],
        ),
      ),
    );
  }

  //region Private -------------------------------------------------------------
  void _favoriteClick(bool isFavorite){
  }
  //endregion
}
