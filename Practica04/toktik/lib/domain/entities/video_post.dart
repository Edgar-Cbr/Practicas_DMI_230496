enum VideoSource { local, youtube, giphy, dailymotion }

class VideoPost {
  final String id;
  final String caption;
  final String videoUrl;
  final int likes;
  final int views;
  final int comments;
  final String? youtubeVideoId;
  final String? giphyUrl;
  final String? dailymotionVideoId;
  final VideoSource source;

  VideoPost({
    String? id,
    required this.caption,
    required this.videoUrl,
    this.likes = 0,
    this.views = 0,
    this.comments = 0,
    this.youtubeVideoId,
    this.giphyUrl,
    this.dailymotionVideoId,
    this.source = VideoSource.local,
  }) : id = id ?? videoUrl;
}