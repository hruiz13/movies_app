import 'package:flutter/material.dart';
import 'package:movies_app/search/search_delegate.dart';

import 'package:provider/provider.dart';

import 'package:movies_app/providers/movies_providers.dart';
import 'package:movies_app/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies on theathers'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: ()=> showSearch(context: context, delegate: MovieSearchDelegate()), 
            icon: const Icon( Icons.search_outlined )
            )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardSwiper( movies: moviesProvider.onDisplayMovies ),
            MovieSlider( 
              movies: moviesProvider.popularMovies,
              genero: 'Populares',
              onNextPage: ()=>moviesProvider.getPopularMovies(),
            )
          ]
          ),
      )

    );
  }
}