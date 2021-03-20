import 'package:flutter/material.dart';
import 'package:movies/src/providers/peliculas_providers.dart';
import 'package:movies/src/widgets/card_swiper_widget.dart';
import 'package:movies/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPeliculasPopulares();

    return Scaffold(
        appBar: AppBar(
          title: Text('Peliculas en cines'),
          centerTitle: false,
          backgroundColor: Colors.indigoAccent,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: () {})
          ],
        ),
        body: Container(
            padding: EdgeInsets.only(top: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[_swiperTarjetas(), _footer(context)],
            )));
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: peliculasProvider.getEnCines(),
      // initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        final _screenSize = MediaQuery.of(context).size;
        if (snapshot.hasData) {
          return CardSwiper(peliculas: snapshot.data);
        } else {
          return Container(
              height: _screenSize.height * 0.5,
              child: Center(child: CircularProgressIndicator()));
        }
      },
    );

    // return CardSwiper(peliculas: peliculas);
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(left: 20.0),
                child: Text('Populares',
                    style: Theme.of(context).textTheme.subtitle1)),
            SizedBox(height: 20.0),
            StreamBuilder(
              stream: peliculasProvider.popularesStream,
              // initialData: [],
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return snapshot.hasData
                    ? MovieHorizontal(
                        peliculas: snapshot.data,
                        siguientePagina:
                            peliculasProvider.getPeliculasPopulares,
                      )
                    : Center(child: CircularProgressIndicator());
              },
            ),
            // FutureBuilder(
            //   future: peliculasProvider.getPeliculasPopulares(),
            //   // initialData: InitialData,
            //   builder: (BuildContext context, AsyncSnapshot snapshot) {
            //     print(snapshot.data);
            //     return snapshot.hasData
            //         ? MovieHorizontal(peliculas: snapshot.data)
            //         : Center(child: CircularProgressIndicator());
            //   },
            // ),
          ]),
    );
  }
}
