import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/features/tweet/controller/tweet_controller.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_card.dart';

import '../../../common/error_page.dart';
import '../../../common/loading_page.dart';
import '../../../constants/appwrite_constants.dart';
import '../../../models/tweet_model.dart';

class TwitterReplayScreen extends ConsumerWidget {
  static route(Tweet tweet) => MaterialPageRoute(
        builder: (context) => TwitterReplayScreen(
          tweet: tweet,
        ),
      );

  final Tweet tweet;
  const TwitterReplayScreen({super.key, required this.tweet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweet'),
      ),
      body: Column(
        children: [
          TweetCard(tweet: tweet),
          ref.watch(getRepliesToTweetsProvider(tweet)).when(
                data: (tweets) {
                  return ref.watch(getLatestTweetProvider).when(
                        data: (data) {
                          final latestTweet = Tweet.fromMap(data.payload);
                          bool isTweetAlreadyPresent = false;
                          for (final tweetModel in tweets) {
                            if (tweetModel.id == latestTweet.id) {
                              isTweetAlreadyPresent = true;
                              break;
                            }
                          }
                          if (!isTweetAlreadyPresent &&
                              latestTweet.repliedTo == tweet.id) {
                            if (data.events.contains(
                              'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.create',
                            )) {
                              tweets.insert(0, Tweet.fromMap(data.payload));
                            } else if (data.events.contains(
                              'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.update',
                            )) {
                              // get id of tweet
                              final startingPoint =
                                  data.events[0].lastIndexOf('documents.');
                              final endingPoint =
                                  data.events[0].lastIndexOf('.update');
                              final tweetId = data.events[0]
                                  .substring(startingPoint + 10, endingPoint);
                              var tweet = tweets
                                  .where((element) => element.id == tweetId)
                                  .first;
                              tweet = tweets
                                  .where((element) => element.id == tweetId)
                                  .first;
                              final tweetIndex = tweets.indexOf(tweet);
                              tweets.removeWhere(
                                  (element) => element.id == tweetId);
                              tweet = Tweet.fromMap(data.payload);
                              tweets.insert(tweetIndex, tweet);
                            }
                          }

                          return Expanded(
                            child: ListView.builder(
                              itemCount: tweets.length,
                              itemBuilder: (BuildContext context, int index) {
                                final tweet = tweets[index];
                                return TweetCard(tweet: tweet);
                              },
                            ),
                          );
                        },
                        error: (error, stackTrace) => ErrorText(
                          error: error.toString(),
                        ),
                        loading: () {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: tweets.length,
                              itemBuilder: (BuildContext context, int index) {
                                final tweet = tweets[index];
                                return TweetCard(tweet: tweet);
                              },
                            ),
                          );
                        },
                      );
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const Loader(),
              )
        ],
      ),
      bottomNavigationBar: TextField(
        onSubmitted: (value) {
          ref.read(tweetControllerProvider.notifier).shareTweet(
            images: [],
            text: value,
            context: context,
            repliedTo: tweet.id,
          );
        },
        decoration: const InputDecoration(
          hintText: 'Tweet your reply',
        ),
      ),
    );
  }
}
