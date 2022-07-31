import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart';
import 'package:movies_app/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  
  const DetailsScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(image:movie.fullBackdropPath, title:movie.title),
          SliverList(
            delegate: SliverChildListDelegate([
              _PosterTitle(movie:movie),
              _Overview(movie:movie),
              CastingCards(movieId: movie.id)
            ])
          )
        ],
      )
    );
  }
}

class _CustomAppBar extends StatelessWidget {

  final String image;
  final String title;

  const _CustomAppBar(
    {
      Key? key, 
      required this.image, 
      required this.title
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          color: Colors.black12,
          padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
            )
        ),
        background: FadeInImage(
          placeholder: const AssetImage('assets/images/loading.gif'),
          image: NetworkImage(image),
          fit: BoxFit.cover
        ),
      ),

    );
    
  }
}

class _PosterTitle extends StatelessWidget {

  final Movie movie;

  const _PosterTitle(
    {Key? key, 
    required this.movie
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme useClass = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top:20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/images/no-image.jpg'),
                image: NetworkImage(movie.fullBackdropPath),
                height: 150,
                width: 120,
                fit: BoxFit.cover
              )
            ),
          ),
          const SizedBox(width: 20),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width-190),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title, style: useClass.headline5, overflow: TextOverflow.ellipsis, maxLines: 2),
                
                Text(movie.originalTitle, style: useClass.subtitle1, overflow: TextOverflow.ellipsis, maxLines: 2),
                Row(
                   children: [
                    const Icon(Icons.star_outline, size: 15, color: Colors.grey),
                    const SizedBox(width: 5,),
                    Text(movie.voteAverage.toString(), style: useClass.caption)
                   ],
                )
              ],
            ),
          )
      ])
    );
  }
}

class _Overview extends StatelessWidget {
  final Movie movie;
  const _Overview({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        movie.overview, 
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1
      ),
    );
  }
}