import 'package:flutter/material.dart';
import 'package:toktik/config/helpers/human_formats.dart';
import 'package:toktik/infrastructure/services/youtube_data_api.dart';

class VideoCommentsSheet extends StatefulWidget {
  final Future<List<YoutubeComment>> Function() loadComments;

  const VideoCommentsSheet({super.key, required this.loadComments});

  @override
  State<VideoCommentsSheet> createState() => _VideoCommentsSheetState();
}

class _VideoCommentsSheetState extends State<VideoCommentsSheet> {
  late Future<List<YoutubeComment>> _comments;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _comments = widget.loadComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Color _avatarColor(String author) {
    final colors = [
      Colors.deepOrangeAccent,
      Colors.teal,
      Colors.pinkAccent,
      Colors.indigoAccent,
      Colors.amber.shade800,
      Colors.purpleAccent,
      Colors.cyan,
    ];
    return colors[author.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.72,
      decoration: const BoxDecoration(
        color: Color(0xFF16161C),
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 6),
            width: 42,
            height: 4.5,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          // Header de comentarios
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Row(
              children: [
                const Text(
                  'Comentarios',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  color: Colors.white70,
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Cerrar',
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white12),

          // Lista de comentarios
          Expanded(
            child: FutureBuilder<List<YoutubeComment>>(
              future: _comments,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            color: Colors.white54,
                            size: 36,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'No se pudieron cargar los comentarios\n${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: primaryColor,
                      ),
                    ),
                  );
                }

                final comments = snapshot.data ?? const <YoutubeComment>[];
                if (comments.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: Colors.white38,
                          size: 46,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Sé el primero en comentar',
                          style: TextStyle(color: Colors.white60, fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount: comments.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    final initial = comment.author.isNotEmpty
                        ? comment.author[0].toUpperCase()
                        : '?';
                    final color = _avatarColor(comment.author);

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar circular
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [color, color.withValues(alpha: 0.65)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              initial,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Autor y texto
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment.author,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                comment.text,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Like del comentario
                        Padding(
                          padding: const EdgeInsets.only(left: 8, top: 4),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.favorite_border_rounded,
                                size: 16,
                                color: Colors.white60,
                              ),
                              if (comment.likes > 0) ...[
                                const SizedBox(height: 2),
                                Text(
                                  HumanFormats.humanReadbleNumber(
                                    comment.likes.toDouble(),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          // Input dock inferior estilizado
          Container(
            padding: EdgeInsets.fromLTRB(
              16,
              10,
              16,
              12 + MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF1A1A22),
              border: Border(top: BorderSide(color: Colors.white10)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: TextField(
                        controller: _commentController,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        decoration: const InputDecoration(
                          hintText: 'Añade un comentario...',
                          hintStyle: TextStyle(
                            color: Colors.white38,
                            fontSize: 13,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.arrow_upward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        if (_commentController.text.trim().isNotEmpty) {
                          _commentController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Comentario enviado'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
