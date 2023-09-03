import 'package:atividade03/src/ui/widgets/pagination_buttons.dart';
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../blocs/movies_bloc.dart';

class MovieList extends StatelessWidget {
  @override
  Widget build(context) {
    moviesBloc.fetchAllMovies();
    return Scaffold(
        appBar: AppBar(
            title: Row(
          children: [
            const Expanded(child: Text('Popular Movies')),
            StreamBuilder(
                stream: moviesBloc.page,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text('Page ${snapshot.data}');
                  } else if (snapshot.hasError) {
                    return const Text('Error');
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
          ],
        )),
        body: SingleChildScrollView(
          child: Column(
            children: [
              PaginationButton(),
              StreamBuilder(
                stream: moviesBloc.allMovies,
                builder: (context, AsyncSnapshot<ItemModel> snapshot) {
                  if (snapshot.hasData) {
                    return buildList(context, snapshot);
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ));
  }

  Widget buildList(context, AsyncSnapshot<ItemModel> snapshot) {
    return Container(
      width: double.infinity,
      child: Wrap(
          alignment: WrapAlignment.spaceAround,
          children: (List.generate(
              snapshot.data?.results.length ?? 0,
              (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: movieCard(snapshot.data?.results[index] as Result),
                  )))),
    );
  }
}

Color getNoteColor(double note) {
  if (note < 0) {
    note = 0;
  } else if (note > 10) {
    note = 10;
  }

  final double ratio = note / 10.0;

  final int red = (225 * (1 - ratio)).toInt();
  final int green = (225 * ratio).toInt();

  return Color.fromARGB(255, red, green, 100);
}

Widget movieCard(Result data) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8.0),
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border:
              Border.all(color: const Color.fromARGB(50, 0, 0, 0), width: 2)),
      constraints: const BoxConstraints(
        maxWidth: 300,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              'https://image.tmdb.org/t/p/w185${data.poster_path}',
              fit: BoxFit.fitWidth,
              width: 600,
            ),
          ),
          Positioned(
            width: 36,
            height: 36,
            top: 8,
            left: 8,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                    color: const Color.fromARGB(255, 200, 200, 200), width: 1),
                color: getNoteColor(data.vote_average),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Center(
                  child: Text('${data.vote_average}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
