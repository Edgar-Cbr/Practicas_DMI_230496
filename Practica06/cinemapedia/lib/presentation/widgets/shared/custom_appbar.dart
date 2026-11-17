import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cinemapedia/config/i18n/app_strings.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/shared/cinemapedia_logo.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final t = AppStrings.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xDD0E111C),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: colors.primary.withValues(alpha: 0.35),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                //* Botón para abrir el menú lateral (Drawer)
                Builder(
                  builder: (scaffoldContext) {
                    return Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: IconButton(
                        icon: const Icon(Icons.menu_rounded, color: Colors.white),
                        tooltip: t.menu,
                        onPressed: () {
                          Scaffold.of(scaffoldContext).openDrawer();
                        },
                      ),
                    );
                  },
                ),

                const SizedBox(width: 4),

                //* Nuevo Logo oficial vectorizado
                const CinemapediaLogo(size: 28),
                const SizedBox(width: 8),

                //* Título con estilo de marca cinemática dorada
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'CINEMA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      TextSpan(
                        text: 'PEDIA',
                        style: TextStyle(
                          color: colors.primary,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                //* Botón de búsqueda con efecto botón de cristal dorado
                Material(
                  color: colors.primary.withValues(alpha: 0.18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: colors.primary.withValues(alpha: 0.45),
                      width: 1,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: IconButton(
                    icon: Icon(
                      Icons.search_rounded,
                      color: colors.primary,
                      size: 22,
                    ),
                    tooltip: ref.watch(catalogTypeProvider) == CatalogType.series
                        ? t.searchSeries
                        : t.searchMovies,
                    onPressed: () {
                      final searchedMovies = ref.read(searchedMoviesProvider);
                      final searchQuery = ref.read(searchQueryProvider);
                      final isSeries =
                          ref.read(catalogTypeProvider) == CatalogType.series;

                      showSearch<Movie?>(
                        query: searchQuery,
                        context: context,
                        delegate: SearchMovieDelegate(
                          searchLabel:
                              isSeries ? t.searchSeries : t.searchMovies,
                          initialMovies: searchedMovies,
                          searchMovies: ref
                              .read(searchedMoviesProvider.notifier)
                              .searchMoviesByQuery,
                        ),
                      ).then((movie) {
                        if (movie == null || !context.mounted) return;
                        context.push('/home/0/movie/${movie.id}');
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
