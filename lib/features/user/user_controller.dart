import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_controller.dart';
import 'package:lakbay/features/common/providers/bottom_nav_provider.dart';
import 'package:lakbay/features/user/user_repository.dart';
import 'package:lakbay/models/user_model.dart';

// Cooperative controller provider
final usersControllerProvider =
    StateNotifierProvider<UsersController, bool>((ref) {
  final usersRepository = ref.watch(userRepositoryProvider);
  return UsersController(usersRepository: usersRepository, ref: ref);
});

// getUser provider
final getUserProvider = StreamProvider.family<UserModel, String>((ref, uid) {
  final usersController = ref.watch(usersControllerProvider.notifier);
  return usersController.getUser(uid);
});

// getAllUserExceptCurrentUser provider
final getAllUsersExceptCurrentUserProvider =
    StreamProvider.family<List<UserModel>, String>((ref, uid) {
  final usersController = ref.watch(usersControllerProvider.notifier);
  return usersController.getAllUsersExceptCurrentUser(uid);
});

class UsersController extends StateNotifier<bool> {
  final UserRepository _userRepository;
  final Ref _ref;

  UsersController({required UserRepository usersRepository, required Ref ref})
      : _userRepository = usersRepository,
        _ref = ref,
        super(false);

  // Read all users
  Stream<List<UserModel>> getAllUsers() {
    return _userRepository.readUsers();
  }

  // Read all users except current user
  Stream<List<UserModel>> getAllUsersExceptCurrentUser(String uid) {
    return _userRepository.readUsersExceptCurrentUser(uid);
  }

  // Read a user
  Stream<UserModel> getUser(String uid) {
    return _userRepository.readUser(uid);
  }

  // Edit user after register COOP
  void editUserAfterRegisterCoop(String uid, UserModel user) async {
    await _userRepository.editUser(uid, user);
    _ref.read(userProvider.notifier).setUser(user);
  }

  // Edit user after joining COOP
  void editUserAfterJoinCoop(String uid, UserModel user) async {
    await _userRepository.editUser(uid, user);
    _ref.read(userProvider.notifier).setUser(user);
  }

  void editUserAfterJoinCoopCoopsJoined(String uid, UserModel user) async {
    await _userRepository.editUser(uid, user);
    // _ref.read(userProvider.notifier).setUser(user);
  }

  // Edit user isCoopView
  void editUserIsCoopView(
      BuildContext context, String uid, UserModel user) async {
    // debugPrint("editUserIsCoopView: $uid, $isCoopView");
    state = true;
    final result = await _userRepository.editUser(uid, user);
    state = false;

    // if isCoopView false show message as Switch to Cooperative View
    // if isCoopView true show message as Switch to User View

    result.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        context.pop();

        if (user.isCoopView ?? false) {
          context.go('/today');
        } else {
          context.go('/trips');
        }

        _ref.read(userProvider.notifier).setUser(user);
        _ref.read(bottomNavBarProvider.notifier).setPosition(0);

        showSnackBar(
            context,
            user.isCoopView!
                ? 'Switched to Cooperative View'
                : 'Switched to Customer View');
      },
    );
  }

  void editProfile(BuildContext context, String uid, UserModel user) {
    state = true;
    _userRepository.editUser(uid, user).then((result) {
      state = false;
      result.fold(
        (l) => showSnackBar(context, l.message),
        (r) {
          context.pop();
          _ref.read(userProvider.notifier).setUser(user);
          showSnackBar(context, 'Profile Updated');
        },
      );
    });
  }

  void editProfileFromJoiningCoop(
      BuildContext context, String uid, UserModel user) {
    state = true;
    _userRepository.editUser(uid, user).then((result) {
      state = false;
      result.fold(
        (l) => showSnackBar(context, l.message),
        (r) {
          _ref.read(userProvider.notifier).setUser(user);
        },
      );
    });
  }
}
