import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart';
import 'package:movies_app/providers/movies_providers.dart';
import 'package:provider/provider.dart';


class CastingCards extends StatelessWidget {

  final int movieId;
   
  const CastingCards(
    {
      Key? key, 
      required this.movieId
    }
  ) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context, listen:false);

    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieId),
      builder: (_, AsyncSnapshot<List<Cast>> snapshot) {

        if(!snapshot.hasData){
          return const SizedBox(
            height: 180,
            child: Center(
              child: CircularProgressIndicator(),
            ),
            //child: CupertinoActivityIndicator(),
          ); 
        }

        final List<Cast> cast = snapshot.data!;

        return Container(
          height: 180,
          margin: const EdgeInsets.only(bottom: 30),
          width: double.infinity,
          child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return _CastCard(actor: cast[index]);
              }
            ),
        );


      },
    );

    
  }
}

class _CastCard extends StatelessWidget {

  final Cast actor;

  const _CastCard({Key? key, required this.actor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
                placeholder: const AssetImage('assets/images/no-image.jpg'),
                image: NetworkImage(actor.fullProfilePath),
                height: 140,
                width: 100,
                fit: BoxFit.cover
              ),
          ),

          const SizedBox(height:5),

          Text(
            actor.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            )

        ]
      ),
    );
  }
}