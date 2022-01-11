import 'package:flutter/material.dart';
import 'package:rafael_jobsity_challenge/domain/entities/actor.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/colors.dart';
import 'package:rafael_jobsity_challenge/presenter/ui/common/values.dart';





class Actors extends StatelessWidget {

  final List<Actor> actors;
  final Function(Actor) onActorTap;


  const Actors({Key? key,
    required this.actors,
    required this.onActorTap,
  }) :

        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) =>
          Padding(
            padding: EdgeInsets.only(left: index == 0 ? kDefaultPadding - 8 : kDefaultPadding/2, right: index == actors.length - 1 ? kDefaultPadding : 0),
            child: ActorAvatar(actor: actors[index], onTap: (actor) => onActorTap(actor)),
          ),
      ),
    );
  }
}

class ActorAvatar extends StatelessWidget {
  final Actor actor;
  final Function(Actor) onTap;

  const ActorAvatar({Key? key,
    required this.actor,
    required this.onTap
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(actor);
      },
      child: SizedBox(
        width: 56 + 16,
        height: 56 + 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(200)),
                boxShadow: [kDefaultShadow]
              ),
              child: SizedBox(
                width : 56,
                height: 56,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(200)),
                  child: Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(actor.thumb ?? ''),
                  ),
                ),
              ),
            ),
            const SizedBox(height: kDefaultPadding/2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(actor.name.split(' ').first, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText1, maxLines: 1, overflow: TextOverflow.ellipsis,),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(actor.name.split(' ').last, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText1, maxLines: 1, overflow: TextOverflow.ellipsis,),
            )
          ],
        ),
      ),
    );
  }
}