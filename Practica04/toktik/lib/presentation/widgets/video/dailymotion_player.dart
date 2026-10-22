import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:toktik/presentation/widgets/shared/expandable_caption.dart';
import 'package:toktik/presentation/widgets/video/video_background.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class DailymotionPlayer extends StatefulWidget {
  final String videoId;
  final String caption;
  final String description;
  final bool isActive;
  final bool isMuted;
  final VoidCallback? onDoubleTap;
  final ValueChanged<PointerSignalEvent>? onPointerSignal;
  final ValueChanged<PointerDownEvent>? onPointerDown;

  const DailymotionPlayer({
    super.key,
    required this.videoId,
    required this.caption,
    required this.description,
    required this.isActive,
    required this.isMuted,
    this.onDoubleTap,
    this.onPointerSignal,
    this.onPointerDown,
  });

  @override
  State<DailymotionPlayer> createState() => _DailymotionPlayerState();
}

class _DailymotionPlayerState extends State<DailymotionPlayer> {
  late final WebViewController _controller;
  bool _loading = false;
  String? _error;
  bool _showHeartAnimation = false;
  Offset _heartPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    _configureController();
    if (widget.isActive) _loadVideo();
  }

  void _configureController() {
    if (kIsWeb) return;
    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
          onWebResourceError: (error) {
            if (!mounted || error.isForMainFrame == false) return;
            setState(() {
              _loading = false;
              _error = 'No se pudo cargar el video (${error.description}).';
            });
          },
        ),
      );
    final platform = _controller.platform;
    if (platform is AndroidWebViewController) {
      platform.setMediaPlaybackRequiresUserGesture(false);
    }
  }

  @override
  void didUpdateWidget(covariant DailymotionPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoId != widget.videoId ||
        oldWidget.isActive != widget.isActive ||
        oldWidget.isMuted != widget.isMuted) {
      if (widget.isActive) {
        _loadVideo();
      } else {
        _controller.loadRequest(Uri.parse('about:blank'));
      }
    }
  }

  void _loadVideo() {
    _error = null;
    _loading = !kIsWeb;
    final url = Uri.https(
      'www.dailymotion.com',
      '/embed/video/${widget.videoId}',
      {
        'autoplay': 'true',
        'mute': widget.isMuted ? 'true' : 'false',
        'loop': 'true',
        'queue-enable': 'false',
        'sharing-enable': 'false',
        'ui-logo': 'false',
        'ui-start-screen-info': 'false',
      },
    );
    _controller.loadRequest(url);
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
  Widget build(BuildContext context) {
    if (!widget.isActive) {
      return const ColoredBox(color: Colors.black);
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Colors.black),
        IgnorePointer(child: WebViewWidget(controller: _controller)),
        const VideoBackground(),
        Positioned.fill(
          child: PointerInterceptor(
            child: Listener(
              behavior: HitTestBehavior.translucent,
              onPointerSignal: widget.onPointerSignal,
              onPointerDown: widget.onPointerDown,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onDoubleTapDown: _handleDoubleTap,
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
        if (_loading)
          const IgnorePointer(
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
        if (_error != null)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ),
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
        Positioned(
          bottom: 30,
          left: 16,
          child: PointerInterceptor(
            child: ExpandableCaption(
              title: widget.caption,
              description: widget.description,
              author: '@dailymotion_feed',
            ),
          ),
        ),
      ],
    );
  }
}
