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

  static const supportedCodes = ['es', 'en', 'de', 'zh', 'ar'];

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
    },

    // ------------------------------------------------------------ 中文
    'zh': {
      'home': '首页',
      'popular': '热门',
      'favorites': '收藏',
      'nowPlaying': '正在热映',
      'upcoming': '即将上映',
      'upcomingSub': '本月',
      'topRated': '评分最高',
      'topRatedSub': '历史榜单',
      'previous': '上一部',
      'next': '下一部',
      'releaseDate': '上映日期：',
      'ageRating': '年龄分级：',
      'recommendations': '推荐',
      'videos': '视频',
      'similarError': '无法加载相似电影',
      'videosError': '无法加载视频',
      'searchMovies': '搜索电影',
      'noFavTitle': '哎呀！',
      'noFavBody': '你还没有收藏的电影',
      'startSearching': '开始搜索',
      'pleaseWait': '请稍候',
      'loading': '加载中...',
      'loading1': '正在整理最新上映与首映片单...',
      'loading2': '正在准备爆米花与冷饮...',
      'loading3': '正在校准全景音效与数字放映机...',
      'loading4': '正在挑选影厅最佳观影座位...',
      'loading5': '影厅灯光渐暗，请保持安静...',
      'loading6': '请入座，精彩电影马上开场...',
      'menu': '菜单',
      'language': '语言',
      'chooseLanguage': '选择应用和电影的语言',
    },

    // ------------------------------------------------------------ العربية
    'ar': {
      'home': 'الرئيسية',
      'popular': 'الشائعة',
      'favorites': 'المفضلة',
      'nowPlaying': 'في دور العرض',
      'upcoming': 'قريبًا',
      'upcomingSub': 'هذا الشهر',
      'topRated': 'الأعلى تقييمًا',
      'topRatedSub': 'على مر العصور',
      'previous': 'السابق',
      'next': 'التالي',
      'releaseDate': 'تاريخ الإصدار:',
      'ageRating': 'التصنيف العمري:',
      'recommendations': 'توصيات',
      'videos': 'مقاطع الفيديو',
      'similarError': 'تعذّر تحميل الأفلام المشابهة',
      'videosError': 'تعذّر تحميل مقاطع الفيديو',
      'searchMovies': 'ابحث عن فيلم',
      'noFavTitle': 'يا للأسف!!',
      'noFavBody': 'ليس لديك أفلام مفضلة',
      'startSearching': 'ابدأ البحث',
      'pleaseWait': 'يرجى الانتظار',
      'loading': 'جارٍ التحميل...',
      'loading1': 'جارٍ تجهيز شباك التذاكر وأحدث العروض...',
      'loading2': 'جارٍ تحضير الفشار والمشروبات المنعشة...',
      'loading3': 'جارٍ ضبط الصوت المحيطي وجهاز العرض...',
      'loading4': 'جارٍ حجز أفضل مقاعد الصالة...',
      'loading5': 'أضواء القاعة تنطفئ، هدوء من فضلكم!...',
      'loading6': 'تفضل بالجلوس، العرض على وشك البدء...',
      'menu': 'القائمة',
      'language': 'اللغة',
      'chooseLanguage': 'اختر لغة التطبيق والأفلام',
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
