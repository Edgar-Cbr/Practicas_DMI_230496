import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';
import 'package:toktik/presentation/providers/discover_provider.dart';
import 'package:toktik/presentation/providers/likes_provider.dart';
import 'package:toktik/presentation/providers/theme_provider.dart';
import 'package:toktik/presentation/widgets/shared/theme_splash.dart';
import 'package:toktik/presentation/widgets/shared/video_scrollable_view.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  Future<void> _selectSection(
    BuildContext context,
    VideoFeedSection section,
  ) async {
    final likes = context.read<LikesProvider>();
    await context.read<DiscoverProvider>().loadSection(
      section,
      favorites: likes.favorites,
    );
  }

  /// Cambia el tema envuelto en la splash screen de la temática de destino.
  Future<void> _applyThemeWithSplash(
    BuildContext context, {
    required SeasonalTheme target,
    required Future<void> Function() apply,
  }) async {
    try {
      await showThemeSplash(context, target: target, apply: apply);
    } catch (error) {
      if (!context.mounted) return;
      _showError(context, error);
    }
  }

  Future<void> _showThemeSettings(
    BuildContext context,
    ThemeProvider themes,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: const Color(0xFF14141A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => ListenableBuilder(
        listenable: themes,
        builder: (_, _) => SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 6, 18, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      themes.theme.displayText('Personalización Visual'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontFamily: themes.theme.displayFontFamily,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: themes.theme.primaryColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: themes.theme.primaryColor.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        '${themes.theme.icon} ${themes.theme.label}',
                        style: TextStyle(
                          color: themes.theme.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Tarjeta de Tema Automático
                InkWell(
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    await _applyThemeWithSplash(
                      context,
                      target: SeasonalTheme.forDate(DateTime.now()),
                      apply: themes.useAutomaticTheme,
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: themes.isAutomatic
                          ? themes.theme.primaryColor.withValues(alpha: 0.15)
                          : Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: themes.isAutomatic
                            ? themes.theme.primaryColor
                            : Colors.white12,
                        width: themes.isAutomatic ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: themes.theme.primaryColor.withValues(alpha: 0.2),
                          ),
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            color: themes.theme.primaryColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Automático por Temporada',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Adapta el tema y sonidos a la fecha del año',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (themes.isAutomatic)
                          Icon(
                            Icons.check_circle_rounded,
                            color: themes.theme.primaryColor,
                            size: 22,
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                const Text(
                  'Elige un Tema Manual',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),

                // Grid de temas
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.55,
                  children: [
                    for (final season in SeasonalTheme.values)
                      InkWell(
                        onTap: () async {
                          Navigator.pop(sheetContext);
                          await _applyThemeWithSplash(
                            context,
                            target: season,
                            apply: () => themes.selectTheme(season),
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                season.primaryColor.withValues(alpha: 0.28),
                                season.secondaryColor.withValues(alpha: 0.12),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: themes.theme == season && !themes.isAutomatic
                                  ? season.primaryColor
                                  : Colors.white12,
                              width: themes.theme == season && !themes.isAutomatic
                                  ? 2
                                  : 1,
                            ),
                            boxShadow: themes.theme == season && !themes.isAutomatic
                                ? [
                                    BoxShadow(
                                      color: season.primaryColor.withValues(alpha: 0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    season.icon,
                                    style: const TextStyle(fontSize: 26),
                                  ),
                                  const Spacer(),
                                  if (themes.theme == season && !themes.isAutomatic)
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: season.primaryColor,
                                      size: 20,
                                    ),
                                ],
                              ),
                              Text(
                                season.label,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: season.displayFontFamily,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 18),

                // Sonido de temporada switch
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    secondary: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: themes.theme.primaryColor.withValues(alpha: 0.2),
                      ),
                      child: Icon(
                        Icons.music_note_rounded,
                        color: themes.theme.primaryColor,
                        size: 20,
                      ),
                    ),
                    title: const Text(
                      'Efectos sonoros de temporada',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: const Text(
                      'Reproduce sonidos festivos al cambiar tema',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                    value: themes.soundEnabled,
                    activeTrackColor: themes.theme.primaryColor.withValues(alpha: 0.5),
                    activeThumbColor: themes.theme.primaryColor,
                    onChanged: (enabled) async {
                      try {
                        await themes.setSoundEnabled(enabled);
                      } catch (error) {
                        if (sheetContext.mounted) _showError(context, error);
                      }
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

  void _showError(BuildContext context, Object error) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No se pudo guardar la configuración: $error')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final discoverProvider = context.watch<DiscoverProvider>();
    final likesProvider = context.watch<LikesProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final message =
        discoverProvider.statusMessage ??
        themeProvider.errorMessage ??
        likesProvider.errorMessage;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (discoverProvider.videos.isNotEmpty)
            VideoScrollableView(
              key: ValueKey(discoverProvider.section),
              videos: discoverProvider.videos,
              loadComments: discoverProvider.getComments,
              scrollDirection: Axis.vertical,
            )
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: discoverProvider.initialLoading
                    ? SizedBox(
                        width: 38,
                        height: 38,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: themeProvider.theme.primaryColor,
                        ),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            discoverProvider.section == VideoFeedSection.favorites
                                ? Icons.favorite_border_rounded
                                : Icons.videocam_off_rounded,
                            size: 48,
                            color: Colors.white54,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            discoverProvider.section == VideoFeedSection.favorites
                                ? 'Aún no tienes favoritos.\nToca dos veces o el corazón para guardar.'
                                : discoverProvider.statusMessage ??
                                    'No hay videos disponibles.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

          // Barra Superior Estilo TikTok / Reels
          SafeArea(
            child: PointerInterceptor(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        // Tabs de navegación
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              children: [
                                _SectionTab(
                                  label: 'Discover',
                                  selected:
                                      discoverProvider.section ==
                                      VideoFeedSection.discover,
                                  onPressed: () => _selectSection(
                                    context,
                                    VideoFeedSection.discover,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                _SectionTab(
                                  label: 'For You',
                                  selected:
                                      discoverProvider.section ==
                                      VideoFeedSection.forYou,
                                  onPressed: () => _selectSection(
                                    context,
                                    VideoFeedSection.forYou,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                _SectionTab(
                                  label: 'Favorites',
                                  selected:
                                      discoverProvider.section ==
                                      VideoFeedSection.favorites,
                                  onPressed: () => _selectSection(
                                    context,
                                    VideoFeedSection.favorites,
                                  ),
                                  count: likesProvider.favorites.length,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Botón de Selector de Temas Glassmorphism
                        ClipOval(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withValues(alpha: 0.38),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.18),
                                  width: 1,
                                ),
                              ),
                              child: IconButton(
                                tooltip: 'Elegir tema de temporada',
                                padding: EdgeInsets.zero,
                                onPressed: () =>
                                    _showThemeSettings(context, themeProvider),
                                icon: Text(
                                  themeProvider.theme.icon,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Badge de depuración sutil
                    if (kDebugMode && !discoverProvider.initialLoading)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Text(
                            'Locales: ${discoverProvider.localVideoCount} · '
                            'YouTube: ${discoverProvider.youtubeVideoCount} · '
                            'Giphy: ${discoverProvider.giphyVideoCount} · '
                            'Dailymotion: ${discoverProvider.dailymotionVideoCount}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                    // Notificación / Error flotante
                    if (message != null && discoverProvider.videos.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Material(
                          color: Colors.black.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            child: Text(
                              message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Indicador de carga inicial
          if (discoverProvider.initialLoading &&
              discoverProvider.videos.isNotEmpty)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                minHeight: 2,
                color: themeProvider.theme.primaryColor,
              ),
            ),

          // Indicador de carga infinita al deslizar
          if (discoverProvider.loadingMoreDiscover)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: LinearProgressIndicator(
                minHeight: 2,
                color: themeProvider.theme.primaryColor,
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionTab extends StatelessWidget {
  const _SectionTab({
    required this.label,
    required this.selected,
    required this.onPressed,
    this.count,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final season = context.watch<ThemeProvider>().theme;
    final primaryColor = season.primaryColor;

    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? primaryColor.withValues(alpha: 0.88)
              : Colors.black.withValues(alpha: 0.38),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? Colors.white.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.12),
            width: 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              season.displayText(label),
              style: TextStyle(
                color: selected ? Colors.white : Colors.white70,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 13,
                fontFamily: season.displayFontFamily,
                letterSpacing: 0.3,
              ),
            ),
            if (count != null && count! > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withValues(alpha: 0.3)
                      : primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
