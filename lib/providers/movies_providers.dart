

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/helpers/debouncer.dart';
import 'package:movies_app/models/models.dart';

class MoviesProvider extends ChangeNotifier{

  final String _apiKey = '4b27ea452475636770808b451d208b9d';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 1000)
  );

  final StreamController<List<Movie>> _suggestionsStreamController = StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => _suggestionsStreamController.stream;

  MoviesProvider(){
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String mod, [int page = 1])async{

    final url = Uri.https(
      _baseUrl, 
      '3$mod', 
      {
        'api_key': _apiKey,
        'language':_language,
        'page': '$page'
      }
    );
    final response = await http.get(url);
    return response.body;

  }

  getOnDisplayMovies()async{

    final jsonData = await _getJsonData('/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);

    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies()async{
    _popularPage++;

    final jsonData = await _getJsonData('/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);

    popularMovies = [...popularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(movieId)async{
    
    if(moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final jsonData = await _getJsonData('/movie/$movieId/credits', _popularPage);
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;
    
    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovie(String query)async{

    final url = Uri.https(
      _baseUrl, 
      '3/search/movie', 
      {
        'api_key': _apiKey,
        'language':_language,
        'query': query
      }
    );
    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);
    return searchResponse.results;
  }

  void getSuggestionsByQuery(String searchTerm){

    debouncer.value = '';
    debouncer.onValue = (value)async{

      final results = await searchMovie(searchTerm);
      _suggestionsStreamController.add(results);

    };

  }




}