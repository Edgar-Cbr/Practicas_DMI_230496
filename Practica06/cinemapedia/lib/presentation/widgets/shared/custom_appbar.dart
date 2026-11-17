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
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0xCC10121E),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
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

                  //* Logo oficial vectorizado
                  const CinemapediaLogo(size: 26),
                  const SizedBox(width: 8),

                  //* Título con estilo de marca cinemática
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

                  //* Botón de búsqueda con efecto botón de cristal
                  Material(
                    color: colors.primary.withValues(alpha: 0.15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: colors.primary.withValues(alpha: 0.3),
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
                        final isSeries = ref.read(catalogTypeProvider) == CatalogType.series;

                        showSearch<Movie?>(
                          query: searchQuery,
                          context: context,
                          delegate: SearchMovieDelegate(
                            searchLabel: isSeries ? t.searchSeries : t.searchMovies,
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
