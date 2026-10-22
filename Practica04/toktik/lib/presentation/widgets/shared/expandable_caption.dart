import 'dart:ui';
import 'package:flutter/material.dart';

class ExpandableCaption extends StatefulWidget {
  final String title;
  final String description;
  final String? author;
  final String? audioName;

  const ExpandableCaption({
    super.key,
    required this.title,
    this.description = '',
    this.author,
    this.audioName,
  });

  @override
  State<ExpandableCaption> createState() => _ExpandableCaptionState();
}

class _ExpandableCaptionState extends State<ExpandableCaption> {
  static const _collapsedDescriptionLines = 2;
  static const _maxExpandedHeightFactor = 0.42;
  bool _expanded = false;

  @override
  void didUpdateWidget(covariant ExpandableCaption oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.title != widget.title ||
        oldWidget.description != widget.description) {
      _expanded = false;
    }
  }

  bool _descriptionOverflows(
    String description,
    TextStyle style,
    double width,
  ) {
    if (description.length > 140) return true;
    final painter = TextPainter(
      text: TextSpan(text: description, style: style),
      textDirection: Directionality.of(context),
      maxLines: _collapsedDescriptionLines,
    )..layout(maxWidth: width);
    return painter.didExceedMaxLines;
  }

  /// Separa y resalta hashtags o menciones en la descripción
  Widget _buildRichDescription(String text, TextStyle baseStyle) {
    final words = text.split(' ');
    final spans = <TextSpan>[];

    for (var i = 0; i < words.length; i++) {
      final word = words[i];
      final isTag = word.startsWith('#') || word.startsWith('@');
      spans.add(
        TextSpan(
          text: i == 0 ? word : ' $word',
          style: isTag
              ? baseStyle.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                )
              : baseStyle,
        ),
      );
    }

    return RichText(
      maxLines: _expanded ? null : _collapsedDescriptionLines,
      overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
      text: TextSpan(children: spans),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final primaryColor = theme.colorScheme.primary;

    final authorName = widget.author ?? '@toktik_creator';
    final audioTitle = widget.audioName ?? 'Sonido original - TokTik Music';

    final authorStyle = textTheme.titleMedium?.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.3,
      shadows: const [
        Shadow(blurRadius: 10, color: Colors.black87, offset: Offset(0, 1)),
      ],
    );

    final titleStyle = textTheme.bodyLarge?.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      height: 1.25,
      shadows: const [
        Shadow(blurRadius: 8, color: Colors.black87, offset: Offset(0, 1)),
      ],
    );

    final bodyStyle = textTheme.bodyMedium?.copyWith(
      color: Colors.white.withValues(alpha: 0.92),
      fontSize: 13,
      height: 1.35,
      shadows: const [
        Shadow(blurRadius: 6, color: Colors.black87, offset: Offset(0, 1)),
      ],
    );

    final hintStyle = textTheme.bodySmall?.copyWith(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
    );

    final description = widget.description.trim();
    final hasDescription = description.isNotEmpty;

    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : size.width * 0.68;

        final canExpand =
            description.length > 140 ||
            (hasDescription &&
                _descriptionOverflows(description, bodyStyle!, contentWidth));

        return SizedBox(
          width: contentWidth,
          child: AnimatedSize(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeInOutCubic,
            alignment: Alignment.bottomLeft,
            child: _expanded && canExpand
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: size.height * _maxExpandedHeightFactor,
                        ),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header del autor
                            Row(
                              children: [
                                Text(authorName, style: authorStyle),
                                const SizedBox(width: 5),
                                Icon(
                                  Icons.verified,
                                  color: primaryColor,
                                  size: 16,
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(widget.title, style: titleStyle),
                            if (hasDescription) ...[
                              const SizedBox(height: 8),
                              Flexible(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: _buildRichDescription(
                                    description,
                                    bodyStyle!,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),
                            // Botón "Ver menos"
                            InkWell(
                              onTap: () => setState(() => _expanded = false),
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 2,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.keyboard_arrow_up,
                                      size: 18,
                                      color: primaryColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text('Ver menos', style: hintStyle),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Autor con checkmark
                      Row(
                        children: [
                          Text(authorName, style: authorStyle),
                          const SizedBox(width: 5),
                          Icon(
                            Icons.verified,
                            color: primaryColor,
                            size: 16,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: titleStyle,
                      ),
                      if (hasDescription) ...[
                        const SizedBox(height: 4),
                        _buildRichDescription(description, bodyStyle!),
                      ],
                      if (canExpand)
                        GestureDetector(
                          onTap: () => setState(() => _expanded = true),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('... más', style: hintStyle),
                                const SizedBox(width: 2),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16,
                                  color: Colors.white70,
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      // Audio Ticker
                      Row(
                        children: [
                          const Icon(
                            Icons.music_note,
                            size: 15,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              audioTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                shadows: [
                                  Shadow(
                                    blurRadius: 4,
                                    color: Colors.black87,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
