import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/models/user_model.dart';

final exploreControllerProvider = StateNotifierProvider((ref) {
  return ExplorerController(
    userAPI: ref.watch(userAPIProvider),
  );
});

final searchUserProvider = FutureProvider.family((ref, String name) async {
  final explorerController = ref.watch(exploreControllerProvider.notifier);
  return explorerController.searchUser(name);
});

class ExplorerController extends StateNotifier<bool> {
  final UserAPI _userAPI;
  ExplorerController({required UserAPI userAPI})
      : _userAPI = userAPI,
        super(false);

  Future<List<UserModel>> searchUser(String name) async {
    final users = await _userAPI.searchUserByName(name);
    return users.map((e) => UserModel.fromMap(e.data)).toList();
  }
}
