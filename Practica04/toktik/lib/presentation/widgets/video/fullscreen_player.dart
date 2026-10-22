import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:toktik/presentation/widgets/shared/expandable_caption.dart';
import 'package:toktik/presentation/widgets/video/video_background.dart';
import 'package:video_player/video_player.dart';

class FullScreenPlayer extends StatefulWidget {
  final String videoUrl;
  final String caption;
  final String description;
  final bool isActive;
  final bool isMuted;
  final VoidCallback? onDoubleTap;
  final ValueChanged<PointerSignalEvent>? onPointerSignal;
  final ValueChanged<PointerDownEvent>? onPointerDown;

  const FullScreenPlayer({
    super.key,
    required this.videoUrl,
    required this.caption,
    this.description = '',
    required this.isActive,
    required this.isMuted,
    this.onDoubleTap,
    this.onPointerSignal,
    this.onPointerDown,
  });

  @override
  State<FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer> {
  late VideoPlayerController controller;
  late Future<void> _initialization;
  bool? _isPlaying = false;
  bool _showHeartAnimation = false;
  Offset _heartPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    controller = widget.videoUrl.startsWith('http')
        ? VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
        : VideoPlayerController.asset(widget.videoUrl);
    controller.addListener(_updatePlaybackState);
    _initialization = _initializePlayer();
  }

  void _updatePlaybackState() {
    if (!mounted || _isPlaying == controller.value.isPlaying) return;
    setState(() => _isPlaying = controller.value.isPlaying);
  }

  Future<void> _initializePlayer() async {
    try {
      await controller.initialize().timeout(const Duration(seconds: 12));
    } catch (e) {
      if (mounted) rethrow;
    }
    if (!mounted) return;

    await controller.setVolume(widget.isMuted ? 0 : 1);
    await controller.setLooping(true);
    if (widget.isActive) {
      await controller.play();
    }
  }

  void _togglePlayback() {
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
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

  @override
  void didUpdateWidget(covariant FullScreenPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      controller.removeListener(_updatePlaybackState);
      controller.dispose();
      _initController();
      if (mounted) setState(() {});
      return;
    }
    if (oldWidget.isMuted != widget.isMuted &&
        controller.value.isInitialized) {
      controller.setVolume(widget.isMuted ? 0 : 1);
    }
    if (oldWidget.isActive != widget.isActive &&
        controller.value.isInitialized) {
      if (widget.isActive) {
        controller.play();
      } else {
        controller.pause();
      }
    }
  }

  @override
  void dispose() {
    controller.removeListener(_updatePlaybackState);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Colors.redAccent,
                    size: 42,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No se pudo reproducir el video',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _initController();
                      });
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: primaryColor,
              ),
            ),
          );
        }

        return PointerInterceptor(
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerSignal: widget.onPointerSignal,
            onPointerDown: widget.onPointerDown,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _togglePlayback,
              onDoubleTapDown: _handleDoubleTap,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Video centrado
                  Center(
                    child: AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(controller),
                    ),
                  ),

                  // Gradiente cinematográfico superior e inferior
                  const VideoBackground(),

                  // Icono elegante de pausa en el centro cuando no se está reproduciendo
                  if (_isPlaying != true)
                    Center(
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
                    ),
                  ),

                  // Barra de progreso estilizada en el fondo
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _VideoProgressBar(
                      controller: controller,
                      primaryColor: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _VideoProgressBar extends StatelessWidget {
  final VideoPlayerController controller;
  final Color primaryColor;

  const _VideoProgressBar({
    required this.controller,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        if (!value.isInitialized) return const SizedBox.shrink();
        final duration = value.duration.inMilliseconds;
        final position = value.position.inMilliseconds;
        final progress = duration > 0 ? (position / duration).clamp(0.0, 1.0) : 0.0;

        return SizedBox(
          height: 2.5,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                color: Colors.white.withValues(alpha: 0.18),
              ),
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.6),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
