import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:toktik/config/helpers/human_formats.dart';
import 'package:toktik/domain/entities/video_post.dart';

class VideoButtons extends StatelessWidget {
  final VideoPost video;
  final int likeCount;
  final VoidCallback? onCommentsPressed;
  final VoidCallback onLikePressed;
  final VoidCallback onMutePressed;
  final bool isLiked;
  final bool isMuted;
  final bool canGoPrevious;
  final bool canGoNext;
  final VoidCallback onPreviousPressed;
  final VoidCallback onNextPressed;

  const VideoButtons({
    super.key,
    required this.video,
    required this.likeCount,
    required this.onLikePressed,
    required this.onMutePressed,
    required this.isLiked,
    required this.isMuted,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.onPreviousPressed,
    required this.onNextPressed,
    this.onCommentsPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Botón discreto de anterior
        if (canGoPrevious) ...[
          _NavigationButton(
            icon: Icons.keyboard_arrow_up_rounded,
            tooltip: 'Video anterior',
            onPressed: onPreviousPressed,
          ),
          const SizedBox(height: 6),
        ],

        // Avatar de creador con badge
        _CreatorAvatar(primaryColor: primaryColor),
        const SizedBox(height: 14),

        // Botón de Like interactivo
        _LikeButton(
          likeCount: likeCount,
          isLiked: isLiked,
          onPressed: onLikePressed,
        ),
        const SizedBox(height: 14),

        // Vistas (si no es youtube)
        if (video.youtubeVideoId == null) ...[
          _MetricButton(
            value: video.views,
            iconData: Icons.remove_red_eye_rounded,
            label: 'Vistas',
          ),
          const SizedBox(height: 14),
        ],

        // Comentarios
        _MetricButton(
          value: video.comments,
          iconData: Icons.mode_comment_rounded,
          label: 'Comentar',
          onPressed: onCommentsPressed,
        ),
        const SizedBox(height: 14),

        // Botón de Mute / Unmute
        _MuteButton(
          isMuted: isMuted,
          onPressed: onMutePressed,
        ),
        const SizedBox(height: 14),

        // Siguiente video
        if (canGoNext) ...[
          _NavigationButton(
            icon: Icons.keyboard_arrow_down_rounded,
            tooltip: 'Siguiente video',
            onPressed: onNextPressed,
          ),
          const SizedBox(height: 8),
        ],

        // Disco de vinilo giratorio
        _SpinningDisc(primaryColor: primaryColor),
      ],
    );
  }
}

class _CreatorAvatar extends StatelessWidget {
  final Color primaryColor;

  const _CreatorAvatar({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 56,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              gradient: LinearGradient(
                colors: [
                  primaryColor,
                  primaryColor.withValues(alpha: 0.7),
                  Colors.deepPurpleAccent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LikeButton extends StatelessWidget {
  final int likeCount;
  final bool isLiked;
  final VoidCallback onPressed;

  const _LikeButton({
    required this.likeCount,
    required this.isLiked,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: Column(
        children: [
          GestureDetector(
            onTap: onPressed,
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isLiked
                        ? Colors.redAccent.withValues(alpha: 0.22)
                        : Colors.black.withValues(alpha: 0.38),
                    border: Border.all(
                      color: isLiked
                          ? Colors.redAccent.withValues(alpha: 0.6)
                          : Colors.white.withValues(alpha: 0.15),
                      width: 1,
                    ),
                    boxShadow: isLiked
                        ? [
                            BoxShadow(
                              color: Colors.redAccent.withValues(alpha: 0.45),
                              blurRadius: 12,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: isLiked
                        ? ZoomIn(
                            duration: const Duration(milliseconds: 320),
                            child: const Icon(
                              Icons.favorite_rounded,
                              color: Colors.redAccent,
                              size: 27,
                            ),
                          )
                        : const Icon(
                            Icons.favorite_outline_rounded,
                            color: Colors.white,
                            size: 27,
                          ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            HumanFormats.humanReadbleNumber(likeCount.toDouble()),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              shadows: [
                Shadow(blurRadius: 6, color: Colors.black87),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricButton extends StatelessWidget {
  final int value;
  final IconData iconData;
  final String label;
  final VoidCallback? onPressed;

  const _MetricButton({
    required this.value,
    required this.iconData,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: Column(
        children: [
          GestureDetector(
            onTap: onPressed,
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.38),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      iconData,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            HumanFormats.humanReadbleNumber(value.toDouble()),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              shadows: [
                Shadow(blurRadius: 6, color: Colors.black87),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MuteButton extends StatelessWidget {
  final bool isMuted;
  final VoidCallback onPressed;

  const _MuteButton({
    required this.isMuted,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isMuted
                  ? Colors.black.withValues(alpha: 0.42)
                  : Theme.of(context).colorScheme.primary.withValues(alpha: 0.35),
              border: Border.all(
                color: isMuted
                    ? Colors.white.withValues(alpha: 0.15)
                    : Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
                width: 1,
              ),
            ),
            child: Center(
              child: Icon(
                isMuted
                    ? Icons.volume_off_rounded
                    : Icons.volume_up_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _NavigationButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.28),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 0.8,
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}

class _SpinningDisc extends StatelessWidget {
  final Color primaryColor;

  const _SpinningDisc({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return SpinPerfect(
      infinite: true,
      duration: const Duration(seconds: 6),
      child: Container(
        width: 46,
        height: 46,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            colors: [
              Color(0xFF1E1E24),
              Color(0xFF121214),
              Color(0xFF282830),
              Color(0xFF0F0F12),
            ],
            stops: [0.0, 0.45, 0.75, 1.0],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: primaryColor,
          ),
          child: const Center(
            child: Icon(
              Icons.music_note_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
