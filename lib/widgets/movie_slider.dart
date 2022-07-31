import 'package:flutter/material.dart';
import 'package:movies_app/models/models.dart';

class MovieSlider extends StatefulWidget {

  final List<Movie> movies;
  final String? genero;
  final Function onNextPage;
   
  const MovieSlider(
    {
      Key? key, 
      required this.movies, 
      required this.onNextPage,
      this.genero
    }
  ) : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent - 500){
          widget.onNextPage();
      }
    });
    
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:double.infinity,
      height: 260,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [ 

          if(widget.genero != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.genero!, 
              style: const TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold
              )
            ),
          ),

          const SizedBox(height: 5),

          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (_, int index)=> _MoviePoster(movie:widget.movies[index], genero:widget.genero)
              ),
          )

         ]
        ),

    );
  }
}

class _MoviePoster extends StatelessWidget {

  final Movie movie;
  final String? genero;

  const _MoviePoster({
    Key? key, 
    required this.movie, 
    this.genero = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    movie.heroId = 'slider-${movie.id}-$genero';


    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.symmetric(horizontal:10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details', arguments:movie),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/images/no-image.jpg'), 
                  image: NetworkImage(movie.fullPosterImg),
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            movie.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          )          

        ],
      )
    );
  }
}