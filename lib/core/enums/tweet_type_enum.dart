enum TweetType {
  text('text'),
  image('image');

  final String type;
  const TweetType(this.type);
}

// 'text'.toEnum()
// TweetType.text
extension ConvertTweet on String {
  TweetType toTweetTypeEnum() {
    switch (this) {
      case 'text':
        return TweetType.text;
      case 'image':
        return TweetType.image;
      default:
        return TweetType.text;
    }
  }
}
