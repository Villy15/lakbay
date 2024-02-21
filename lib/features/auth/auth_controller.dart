import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lakbay/core/util/utils.dart';
import 'package:lakbay/features/auth/auth_repository.dart';
import 'package:lakbay/features/cooperatives/my_coop/managers/join_coop_code.dart';
import 'package:lakbay/models/user_model.dart';

final userProvider = StateNotifierProvider<UserModelNotifier, UserModel?>(
  (ref) => UserModelNotifier(),
);

class UserModelNotifier extends StateNotifier<UserModel?> {
  UserModelNotifier() : super(null);

  void setUser(UserModel user) {
    state = user;
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  );
});

final authStateChangeProvider = StreamProvider<User?>((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        _ref = ref,
        super(false); // false for loading

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signInWithGoogle(BuildContext context) async {
    state = true; // true for loading
    final user = await _authRepository.signInWithGoogle();
    state = false; // false for loading
    user.fold((l) => showSnackBar(context, l.message),
        (userModel) => _ref.read(userProvider.notifier).setUser(userModel));
  }

  // signInWithEmailAndPassword
  void signInWithEmailAndPassword({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    state = true; // true for loading
    final user = await _authRepository.signIn(
      email: email,
      password: password,
    );
    state = false; // false for loading
    user.fold((l) => showSnackBar(context, l.message),
        (userModel) => _ref.read(userProvider.notifier).setUser(userModel));
  }

  void register({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    state = true; // true for loading
    final user = await _authRepository.register(
      email: email,
      password: password,
    );
    state = false; // false for loading
    user.fold((l) => showSnackBar(context, l.message),
        (userModel) => _ref.read(userProvider.notifier).setUser(userModel));
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  // logout
  void logout() async {
    _authRepository.signOut();
  }

  // void register a list of members
  void registerMembers(List<MemberData> members) async {
    state = true; // true for loading

    for (var member in members) {
      _authRepository.registerMembers(
        email: member.email,
        password: member.password,
        firstName: member.firstName,
        lastName: member.lastName,
      );
    }

    state = false; // false for loading
  }
}
