import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_clone/core/providers.dart';
import 'package:twitter_clone/core/type_defs.dart';

import '../constants/appwrite_constants.dart';
import '../core/failure.dart';
import '../models/tweet_model.dart';

final tweetAPIProvider = Provider((ref) {
  return TweetAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider),
  );
});

abstract class ITweetAPI {
  FutureEither<Document> shareTweet(Tweet tweet);
  Future<List<Document>> getTweets();
  Stream<RealtimeMessage> getLatestTweet();
  // Check differences beetweet FutureEither and Future
  FutureEither<Document> likeTweet(Tweet tweet);
  FutureEither<Document> updateReshareCount(Tweet tweet);
  Future<List<Document>> getRepliesToTweet(Tweet tweet);
  Future<Document> getTweetById(String id);
}

class TweetAPI implements ITweetAPI {
  final Databases _db;
  final Realtime _realtime;
  TweetAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  FutureEither<Document> shareTweet(Tweet tweet) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.DATABASE_ID,
        collectionId: AppwriteConstants.tweetsCollection,
        documentId: ID.unique(),
        data: tweet.toMap(),
      );
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Some unexpected error occurred', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<Document>> getTweets() async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.DATABASE_ID,
        collectionId: AppwriteConstants.tweetsCollection,
        queries: [
          Query.orderDesc('tweetedAt'),
        ]);

    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestTweet() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.DATABASE_ID}.collections.${AppwriteConstants.tweetsCollection}.documents'
    ]).stream;
  }

  @override
  FutureEither<Document> likeTweet(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.DATABASE_ID,
        collectionId: AppwriteConstants.tweetsCollection,
        documentId: tweet.id,
        data: {
          'likes': tweet.likes,
        },
      );
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Some unexpected error occurred', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<Document> updateReshareCount(Tweet tweet) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.DATABASE_ID,
        collectionId: AppwriteConstants.tweetsCollection,
        documentId: tweet.id,
        data: {
          'reshareCount': tweet.reshareCount,
        },
      );
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Some unexpected error occurred', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<Document>> getRepliesToTweet(Tweet tweet) async {
    final document = await _db.listDocuments(
        databaseId: AppwriteConstants.DATABASE_ID,
        collectionId: AppwriteConstants.tweetsCollection,
        queries: [Query.equal('repliedTo', tweet.id)]);
    return document.documents;
  }

  @override
  Future<Document> getTweetById(String id) async {
    final document = _db.getDocument(
      databaseId: AppwriteConstants.DATABASE_ID,
      collectionId: AppwriteConstants.tweetsCollection,
      documentId: id,
    );
    return document;
  }
}
