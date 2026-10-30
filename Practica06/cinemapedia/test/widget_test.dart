import 'package:flutter_test/flutter_test.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

void main() {
  test('Movie entity can be instantiated properly', () {
    final movie = Movie(
      adult: false,
      backdropPath: '/backdrop.jpg',
      genreIds: ['28', '12'],
      id: 12345,
      originalLanguage: 'en',
      originalTitle: 'Original Title',
      overview: 'Movie overview',
      popularity: 123.45,
      posterPath: '/poster.jpg',
      releaseDate: DateTime.now(),
      title: 'Movie Title',
      video: false,
      voteAverage: 8.5,
      voteCount: 1500,
    );

    expect(movie.title, 'Movie Title');
    expect(movie.id, 12345);
    expect(movie.adult, false);
  });
}
