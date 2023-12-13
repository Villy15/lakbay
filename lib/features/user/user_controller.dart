import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/user/user_repository.dart';
import 'package:lakbay/models/user_model.dart';

// Cooperative controller provider
final usersControllerProvider =
    StateNotifierProvider<UsersController, bool>((ref) {
  final usersRepository = ref.watch(userRepositoryProvider);
  return UsersController(usersRepository: usersRepository, ref: ref);
});

class UsersController extends StateNotifier<bool> {
  final UserRepository _userRepository;
  // final Ref _ref;

  UsersController({required UserRepository usersRepository, required Ref ref})
      : _userRepository = usersRepository,
        // _ref = ref,
        super(false);

  // Read all users
  Stream<List<UserModel>> getAllUsers() {
    return _userRepository.readUsers();
  }

  // Read a user
  Stream<UserModel> getUser(String uid) {
    return _userRepository.readUser(uid);
  }

  // Edit user after register COOP
  void editUserAfterRegisterCoop(String uid, UserModel user) async {
    await _userRepository.editUser(uid, user);
  }

  // Edit user after joining COOP
  void editUserAfterJoinCoop(String uid, UserModel user) async {
    await _userRepository.editUser(uid, user);
  }

  // Edit user isCoopView
  void editUserIsCoopView(
      BuildContext context, String uid, bool isCoopView) async {
    // debugPrint("editUserIsCoopView: $uid, $isCoopView");
    state = true;
    final result = await _userRepository.editUserIsCoopView(uid, isCoopView);
    state = false;

    // if isCoopView false show message as Switch to Cooperative View
    // if isCoopView true show message as Switch to User View

    result.fold(
      (l) => showSnackBar(context, l.message),
      (r) => showSnackBar(
          context,
          isCoopView
              ? 'Switched to Cooperative View'
              : 'Switched to Customer View'),
    );
  }
}
