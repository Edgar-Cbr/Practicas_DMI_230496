import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/widgets.dart';

/// Textos de la app en cada idioma.
///
/// Se usa así dentro de cualquier widget:
/// ```dart
/// final t = AppStrings.of(context);
/// Text(t.nowPlaying)
/// ```
/// Como depende de `Localizations`, los widgets se reconstruyen solos
/// cuando cambia el idioma de la app.
class AppStrings {

  final String languageCode;

  const AppStrings(this.languageCode);

  static AppStrings of(BuildContext context) =>
      Localizations.of<AppStrings>(context, AppStrings)!;

  static const LocalizationsDelegate<AppStrings> delegate = _AppStringsDelegate();

  static const supportedCodes = ['es', 'en', 'de', 'fr', 'ja'];

  String _t(String key) =>
      _values[languageCode]?[key] ?? _values['es']![key] ?? key;

  // ---- Navegación
  String get home => _t('home');
  String get popular => _t('popular');
  String get favorites => _t('favorites');

  // ---- Inicio
  String get nowPlaying => _t('nowPlaying');
  String get upcoming => _t('upcoming');
  String get upcomingSub => _t('upcomingSub');
  String get topRated => _t('topRated');
  String get topRatedSub => _t('topRatedSub');
  String get previous => _t('previous');
  String get next => _t('next');

  // ---- Detalle
  String get releaseDate => _t('releaseDate');
  String get ageRating => _t('ageRating');
  String get recommendations => _t('recommendations');
  String get videos => _t('videos');
  String get similarError => _t('similarError');
  String get videosError => _t('videosError');

  // ---- Búsqueda y favoritos
  String get searchMovies => _t('searchMovies');
  String get noFavTitle => _t('noFavTitle');
  String get noFavBody => _t('noFavBody');
  String get startSearching => _t('startSearching');

  // ---- Carga
  String get pleaseWait => _t('pleaseWait');
  String get loading => _t('loading');
  List<String> get loadingMessages =>
      [for (var i = 1; i <= 6; i++) _t('loading$i')];

  // ---- Menú lateral
  String get menu => _t('menu');
  String get language => _t('language');
  String get chooseLanguage => _t('chooseLanguage');

  // ---- Configuración, películas y series
  String get settings => _t('settings');
  String get content => _t('content');
  String get chooseContent => _t('chooseContent');
  String get movies => _t('movies');
  String get series => _t('series');
  String get seriesOnAir => _t('seriesOnAir');
  String get airingToday => _t('airingToday');
  String get airingTodaySub => _t('airingTodaySub');
  String get searchSeries => _t('searchSeries');
  String get noFavSeriesBody => _t('noFavSeriesBody');

  static const Map<String, Map<String, String>> _values = {

    // ------------------------------------------------------------ Español
    'es': {
      'home': 'Inicio',
      'popular': 'Populares',
      'favorites': 'Favoritos',
      'nowPlaying': 'En cines',
      'upcoming': 'Próximamente',
      'upcomingSub': 'En este mes',
      'topRated': 'Mejor calificadas',
      'topRatedSub': 'Desde siempre',
      'previous': 'Anterior',
      'next': 'Siguiente',
      'releaseDate': 'Estreno:',
      'ageRating': 'Clasificación:',
      'recommendations': 'Recomendaciones',
      'videos': 'Videos',
      'similarError': 'No se pudo cargar películas similares',
      'videosError': 'No se pudieron cargar los videos',
      'searchMovies': 'Buscar películas',
      'noFavTitle': 'Ohhh no!!',
      'noFavBody': 'No tienes películas favoritas',
      'startSearching': 'Empieza a buscar',
      'pleaseWait': 'Espere por favor',
      'loading': 'Cargando...',
      'loading1': 'Alistando la cartelera y estrenos...',
      'loading2': 'Preparando las palomitas y refrescos...',
      'loading3': 'Calibrando el sonido envolvente y proyector...',
      'loading4': 'Buscando los mejores asientos de la sala...',
      'loading5': 'Apagando las luces, ¡silencio en la sala!...',
      'loading6': 'Acomódate, la función está por comenzar...',
      'menu': 'Menú',
      'language': 'Idioma',
      'chooseLanguage': 'Elige el idioma de la app y de las películas',
      'settings': 'Configuración',
      'content': 'Contenido',
      'chooseContent': 'Elige qué quieres ver',
      'movies': 'Películas',
      'series': 'Series',
      'seriesOnAir': 'En emisión',
      'airingToday': 'Se emiten hoy',
      'airingTodaySub': 'Episodios nuevos',
      'searchSeries': 'Buscar series',
      'noFavSeriesBody': 'No tienes series favoritas',
    },

    // ------------------------------------------------------------ English
    'en': {
      'home': 'Home',
      'popular': 'Popular',
      'favorites': 'Favorites',
      'nowPlaying': 'In theaters',
      'upcoming': 'Coming soon',
      'upcomingSub': 'This month',
      'topRated': 'Top rated',
      'topRatedSub': 'All time',
      'previous': 'Previous',
      'next': 'Next',
      'releaseDate': 'Release date:',
      'ageRating': 'Age rating:',
      'recommendations': 'Recommendations',
      'videos': 'Videos',
      'similarError': 'Could not load similar movies',
      'videosError': 'Could not load the videos',
      'searchMovies': 'Search movies',
      'noFavTitle': 'Oh no!!',
      'noFavBody': "You don't have any favorite movies",
      'startSearching': 'Start searching',
      'pleaseWait': 'Please wait',
      'loading': 'Loading...',
      'loading1': 'Preparing the premiere billboard...',
      'loading2': 'Getting the popcorn and drinks ready...',
      'loading3': 'Calibrating surround sound & projector...',
      'loading4': 'Finding the best seats in the house...',
      'loading5': 'Dimming the lights, quiet please!...',
      'loading6': 'Take your seat, the show is about to start...',
      'menu': 'Menu',
      'language': 'Language',
      'chooseLanguage': 'Choose the language of the app and the movies',
      'settings': 'Settings',
      'content': 'Content',
      'chooseContent': 'Choose what you want to watch',
      'movies': 'Movies',
      'series': 'Series',
      'seriesOnAir': 'On the air',
      'airingToday': 'Airing today',
      'airingTodaySub': 'New episodes',
      'searchSeries': 'Search series',
      'noFavSeriesBody': "You don't have any favorite series",
    },

    // ------------------------------------------------------------ Deutsch
    'de': {
      'home': 'Start',
      'popular': 'Beliebt',
      'favorites': 'Favoriten',
      'nowPlaying': 'Im Kino',
      'upcoming': 'Demnächst',
      'upcomingSub': 'In diesem Monat',
      'topRated': 'Bestbewertet',
      'topRatedSub': 'Aller Zeiten',
      'previous': 'Zurück',
      'next': 'Weiter',
      'releaseDate': 'Erscheinungsdatum:',
      'ageRating': 'Altersfreigabe:',
      'recommendations': 'Empfehlungen',
      'videos': 'Videos',
      'similarError': 'Ähnliche Filme konnten nicht geladen werden',
      'videosError': 'Videos konnten nicht geladen werden',
      'searchMovies': 'Filme suchen',
      'noFavTitle': 'Oh nein!!',
      'noFavBody': 'Du hast noch keine Lieblingsfilme',
      'startSearching': 'Jetzt suchen',
      'pleaseWait': 'Bitte warten',
      'loading': 'Wird geladen...',
      'loading1': 'Kinoprogramm und Premieren werden vorbereitet...',
      'loading2': 'Popcorn und Getränke bereitstellen...',
      'loading3': 'Surround-Sound und Projektor einstellen...',
      'loading4': 'Die besten Plätze im Saal auswählen...',
      'loading5': 'Lichter werden gedimmt, Ruhe bitte!...',
      'loading6': 'Zurücklehnen, die Vorstellung beginnt gleich...',
      'menu': 'Menü',
      'language': 'Sprache',
      'chooseLanguage': 'Wähle die Sprache der App und der Filme',
      'settings': 'Einstellungen',
      'content': 'Inhalt',
      'chooseContent': 'Wähle, was du sehen möchtest',
      'movies': 'Filme',
      'series': 'Serien',
      'seriesOnAir': 'Läuft aktuell',
      'airingToday': 'Heute im TV',
      'airingTodaySub': 'Neue Folgen',
      'searchSeries': 'Serien suchen',
      'noFavSeriesBody': 'Du hast noch keine Lieblingsserien',
    },

    // ------------------------------------------------------------ Français
    'fr': {
      'home': 'Accueil',
      'popular': 'Populaires',
      'favorites': 'Favoris',
      'nowPlaying': 'Au cinéma',
      'upcoming': 'Prochainement',
      'upcomingSub': 'Ce mois-ci',
      'topRated': 'Mieux notés',
      'topRatedSub': 'De tous les temps',
      'previous': 'Précédent',
      'next': 'Suivant',
      'releaseDate': 'Date de sortie :',
      'ageRating': 'Classification :',
      'recommendations': 'Recommandations',
      'videos': 'Vidéos',
      'similarError': 'Impossible de charger des films similaires',
      'videosError': 'Impossible de charger les vidéos',
      'searchMovies': 'Rechercher des films',
      'noFavTitle': 'Oh non !',
      'noFavBody': "Vous n'avez pas de films favoris",
      'startSearching': 'Commencer la recherche',
      'pleaseWait': 'Veuillez patienter',
      'loading': 'Chargement...',
      'loading1': "Préparation de l'affiche et des nouveautés...",
      'loading2': 'Préparation du pop-corn et des boissons...',
      'loading3': 'Calibrage du son surround et du projecteur...',
      'loading4': 'Recherche des meilleures places de la salle...',
      'loading5': 'Les lumières s\'éteignent, silence dans la salle !...',
      'loading6': 'Installez-vous, la séance va commencer...',
      'menu': 'Menu',
      'language': 'Langue',
      'chooseLanguage': "Choisissez la langue de l'application et des films",
      'settings': 'Paramètres',
      'content': 'Contenu',
      'chooseContent': 'Choisissez ce que vous souhaitez regarder',
      'movies': 'Films',
      'series': 'Séries',
      'seriesOnAir': 'En diffusion',
      'airingToday': "Diffusées aujourd'hui",
      'airingTodaySub': 'Nouveaux épisodes',
      'searchSeries': 'Rechercher des séries',
      'noFavSeriesBody': "Vous n'avez pas de séries favorites",
    },

    // ------------------------------------------------------------ 日本語
    'ja': {
      'home': 'ホーム',
      'popular': '人気作品',
      'favorites': 'お気に入り',
      'nowPlaying': '劇場公開中',
      'upcoming': 'もうすぐ公開',
      'upcomingSub': '今月公開',
      'topRated': '高評価作品',
      'topRatedSub': '歴代の名作',
      'previous': '前へ',
      'next': '次へ',
      'releaseDate': '公開日：',
      'ageRating': 'レーティング：',
      'recommendations': 'おすすめ作品',
      'videos': '予告編・映像',
      'similarError': '関連作品を読み込めませんでした',
      'videosError': '動画を読み込めませんでした',
      'searchMovies': '映画を検索',
      'noFavTitle': 'おやっ！？',
      'noFavBody': 'お気に入りの映画がまだありません',
      'startSearching': '作品を検索する',
      'pleaseWait': '少々お待ちください',
      'loading': '読み込み中...',
      'loading1': '上映スケジュールと最新作を準備中...',
      'loading2': 'ポップコーンとドリンクをご用意しています...',
      'loading3': 'サラウンド音響と映写機を調整中...',
      'loading4': '劇場のベストシートを確保しています...',
      'loading5': 'まもなく場内が暗くなります。お静かに！...',
      'loading6': 'どうぞご着席ください。まもなく上映開始です...',
      'menu': 'メニュー',
      'language': '言語',
      'chooseLanguage': 'アプリおよび映画の言語を選択',
      'settings': '設定',
      'content': 'コンテンツ',
      'chooseContent': '視聴したい作品を選択',
      'movies': '映画',
      'series': 'ドラマ・アニメ',
      'seriesOnAir': '現在放送中',
      'airingToday': '本日放送',
      'airingTodaySub': '最新エピソード',
      'searchSeries': 'シリーズを検索',
      'noFavSeriesBody': 'お気に入りのシリーズがまだありません',
    },
  };
}

class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppStrings.supportedCodes.contains(locale.languageCode);

  @override
  Future<AppStrings> load(Locale locale) =>
      SynchronousFuture<AppStrings>(AppStrings(locale.languageCode));

  @override
  bool shouldReload(_AppStringsDelegate old) => false;
}
