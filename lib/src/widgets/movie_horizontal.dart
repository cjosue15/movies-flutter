import 'package:flutter/material.dart';
import 'package:movies/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function siguientePagina;
  final _scrollController = ScrollController();

  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 500) {
        siguientePagina();
      }
    });

    // return Container(
    //     height: _screenSize.height * 0.2,
    //     child: PageView(
    //       pageSnapping: false,
    //       controller: _pageController,
    //       children: _tarjetas(context),
    //     ));
    return Container(
        height: _screenSize.height * 0.2,
        child: ListView.builder(
            itemCount: this.peliculas == null ? 0 : this.peliculas.length,
            controller: _scrollController,
            // shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext contex, int index) =>
                _createCard(this.peliculas[index], index, context)));
  }

  Widget _createCard(Pelicula pelicula, int index, BuildContext context) {
    final card = Container(
      width: 100.0,
      margin: EdgeInsets.only(left: 20.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/img/no-image.jpg'),
                image: NetworkImage(this.peliculas[index].getPosterImg()),
                fit: BoxFit.cover,
                width: double.infinity,
                height: 160.0,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            this.peliculas[index].title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );

    return GestureDetector(
        child: card,
        onTap: () {
          Navigator.pushNamed(context, 'detalle', arguments: pelicula);
        });
  }

  // List<Widget> _tarjetas(BuildContext context) {
  //   return this.peliculas.map((pelicula) {
  //     return Container(
  //       margin: EdgeInsets.only(right: 15.0),
  //       child: Column(
  //         children: <Widget>[
  //           Expanded(
  //             child: ClipRRect(
  //               borderRadius: BorderRadius.circular(10.0),
  //               child: FadeInImage(
  //                 placeholder: AssetImage('assets/img/no-image.jpg'),
  //                 image: NetworkImage(pelicula.getPosterImg()),
  //                 fit: BoxFit.cover,
  //                 height: 160.0,
  //               ),
  //             ),
  //           ),
  //           SizedBox(height: 10.0),
  //           Text(
  //             pelicula.title,
  //             overflow: TextOverflow.ellipsis,
  //             style: Theme.of(context).textTheme.caption,
  //           )
  //         ],
  //       ),
  //     );
  //   }).toList();
  // }
}
