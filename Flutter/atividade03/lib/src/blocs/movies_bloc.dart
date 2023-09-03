import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';

class _MoviesBloc {
  final _repository = Repository();
  final _moviesFetcher = PublishSubject<ItemModel>();
  final _page = BehaviorSubject<int>.seeded(1);

  Stream<ItemModel> get allMovies => _moviesFetcher.stream;
  Stream<int> get page => _page.stream;

  fetchAllMovies() async {
    ItemModel itemModel = await _repository.fetchAllMovies(_page.value);
    _moviesFetcher.sink.add(itemModel);
  }

  setPage(int update) {
    if (_page.value == 1 && update < 0) {
      _page.sink.add(_page.value);
    } else {
      _page.sink.add(_page.value + update);
    }
  }

  dispose() {
    _moviesFetcher.close();
  }
}

final moviesBloc = _MoviesBloc();
