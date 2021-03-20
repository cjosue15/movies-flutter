import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:movies/src/models/pelicula_model.dart';

class PeliculasProvider {
  String _apikey = '1bd01a2b8cdcbdf3eaa4aa5f1cd788fc';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';
  int _popularesPage = 0;
  bool _cargando = false;
  List<Pelicula> _populares = [];

  final _popularesStreamController =
      new StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  void disposeStream() {
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> getResultados(Uri url) async {
    final response = await http.get(url);
    final decodedData = await json.decode(response.body);
    final peliculas = new Peliculas.fromJsonList(decodedData['results']);
    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apikey, 'language': _language});

    return await getResultados(url);
  }

  Future<List<Pelicula>> getPeliculasPopulares() async {
    if (_cargando) return [];
    _cargando = true;
    _popularesPage++;
    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularesPage.toString()
    });

    final response = await getResultados(url);

    _populares.addAll(response);
    popularesSink(_populares);

    _cargando = false;

    return response;
  }
}
