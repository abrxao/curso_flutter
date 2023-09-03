import 'package:atividade03/src/blocs/movies_bloc.dart';
import 'package:flutter/material.dart';

class PaginationButton extends StatelessWidget {
  const PaginationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: moviesBloc.page,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    onPressed: () {
                      moviesBloc.setPage(-1);
                      moviesBloc.fetchAllMovies();
                    },
                    child: const Text('Anterior')),
                const SizedBox(
                  width: 8,
                ),
                OutlinedButton(
                    onPressed: () {
                      moviesBloc.setPage(1);
                      moviesBloc.fetchAllMovies();
                    },
                    child: const Text('Próximo')),
              ],
            ),
          );
        });
  }
}
