import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:toktik/presentation/widgets/shared/expandable_caption.dart';
import 'package:toktik/presentation/widgets/video/video_background.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubeFullscreenPlayer extends StatefulWidget {
  final String videoId;
  final String caption;
  final String description;
  final bool isActive;
  final bool isMuted;
  final Axis scrollDirection;
  final VoidCallback? onDoubleTap;
  final ValueChanged<PointerSignalEvent> onPointerSignal;
  final ValueChanged<PointerDownEvent> onPointerDown;

  /// Se llama al deslizar hacia arriba (siguiente video).
  final VoidCallback? onSwipeNext;

  /// Se llama al deslizar hacia abajo (video anterior).
  final VoidCallback? onSwipePrevious;

  /// Widget (normalmente un Positioned con los botones de likes/comentarios)
  /// que se dibuja ENCIMA del video, dentro del reproductor.
  final Widget? overlay;

  const YoutubeFullscreenPlayer({
    super.key,
    required this.videoId,
    required this.caption,
    this.description = '',
    required this.isActive,
    required this.isMuted,
    this.scrollDirection = Axis.vertical,
    this.onDoubleTap,
    required this.onPointerSignal,
    required this.onPointerDown,
    this.onSwipeNext,
    this.onSwipePrevious,
    this.overlay,
  });

  @override
  State<YoutubeFullscreenPlayer> createState() =>
      _YoutubeFullscreenPlayerState();
}

class _YoutubeFullscreenPlayerState extends State<YoutubeFullscreenPlayer> {
  YoutubePlayerController? _controller;
  bool _showHeartAnimation = false;
  Offset _heartPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    if (widget.isActive) _createController();
  }

  @override
  void didUpdateWidget(covariant YoutubeFullscreenPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoId != widget.videoId) {
      _closeController();
      if (widget.isActive) _createController();
    } else if (oldWidget.isActive != widget.isActive) {
      if (widget.isActive) {
        _createController();
        _controller?.playVideo();
      } else {
        _controller?.pauseVideo();
      }
    }
    if (oldWidget.isMuted != widget.isMuted) {
      if (widget.isMuted) {
        _controller?.mute();
      } else {
        _controller?.unMute();
      }
    }
  }

  void _createController() {
    if (_controller != null) return;
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: true,
      params: YoutubePlayerParams(
        mute: widget.isMuted,
        loop: true,
        showControls: false,
        showFullscreenButton: false,
        showVideoAnnotations: false,
        enableCaption: false,
        strictRelatedVideos: true,
      ),
    );
  }

  void _closeController() {
    final controller = _controller;
    _controller = null;
    controller?.close();
  }

  void _togglePlayback() {
    final controller = _controller;
    if (controller == null) return;
    if (controller.value.playerState == PlayerState.playing ||
        controller.value.playerState == PlayerState.buffering) {
      controller.pauseVideo();
    } else {
      controller.playVideo();
    }
  }

  void _handleDoubleTap(TapDownDetails details) {
    HapticFeedback.lightImpact();
    setState(() {
      _heartPosition = details.localPosition;
      _showHeartAnimation = true;
    });

    widget.onDoubleTap?.call();

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() => _showHeartAnimation = false);
      }
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity < -150) {
      widget.onSwipeNext?.call();
    } else if (velocity > 150) {
      widget.onSwipePrevious?.call();
    }
  }

  @override
  void dispose() {
    _closeController();
    super.dispose();
  }

  Widget _buildControls(YoutubePlayerController controller) {
    return Material(
      type: MaterialType.transparency,
      child: PointerInterceptor(
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerSignal: widget.onPointerSignal,
          onPointerDown: widget.onPointerDown,
          child: Stack(
            fit: StackFit.expand,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _togglePlayback,
                onDoubleTapDown: _handleDoubleTap,
                onHorizontalDragEnd: widget.scrollDirection == Axis.horizontal
                    ? _handleDragEnd
                    : null,
                child: const SizedBox.expand(),
              ),

              // Sombra cinematográfica
              const VideoBackground(),

              // Mensaje de error o botón de reproducir
              YoutubeValueBuilder(
                controller: controller,
                buildWhen: (previous, current) =>
                    previous.playerState != current.playerState ||
                    previous.hasError != current.hasError,
                builder: (context, value) {
                  if (value.hasError) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.all(24),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.block_rounded,
                              color: Colors.redAccent,
                              size: 38,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'El autor restringió la reproducción fuera de YouTube.\nDesliza para ver el siguiente.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (value.playerState == PlayerState.playing ||
                      value.playerState == PlayerState.buffering) {
                    return const SizedBox.shrink();
                  }
                  return Center(
                    child: FadeIn(
                      duration: const Duration(milliseconds: 200),
                      child: ClipOval(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withValues(alpha: 0.45),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25),
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Animación de corazón gigante en doble tap (TikTok style)
              if (_showHeartAnimation)
                Positioned(
                  left: _heartPosition.dx - 45,
                  top: _heartPosition.dy - 45,
                  child: IgnorePointer(
                    child: ZoomIn(
                      duration: const Duration(milliseconds: 400),
                      child: FadeOut(
                        delay: const Duration(milliseconds: 450),
                        duration: const Duration(milliseconds: 400),
                        child: Transform.rotate(
                          angle: -0.15,
                          child: Icon(
                            Icons.favorite_rounded,
                            size: 90,
                            color: Colors.redAccent.withValues(alpha: 0.95),
                            shadows: const [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 16,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // Subtítulo expandible y autor
              Positioned(
                bottom: 30,
                left: 16,
                child: ExpandableCaption(
                  title: widget.caption,
                  description: widget.description,
                  author: '@youtube_toktik',
                ),
              ),

              if (widget.overlay != null) widget.overlay!,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null) {
      return ColoredBox(
        color: Colors.black,
        child: Center(
          child: Image.network(
            'https://i.ytimg.com/vi/${widget.videoId}/hqdefault.jpg',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.smart_display, color: Colors.white, size: 72),
          ),
        ),
      );
    }

    return YoutubePlayer(
      controller: controller,
      aspectRatio: 9 / 16,
      enableFullScreenOnVerticalDrag: false,
      autoFullScreen: false,
      controlsBuilder: (context, isFullscreen) => _buildControls(controller),
    );
  }
}
