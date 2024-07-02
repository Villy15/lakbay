import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lakbay/core/constants/constants.dart';
import 'package:lakbay/core/constants/firebase_constants.dart';
import 'package:lakbay/core/failure.dart';
import 'package:lakbay/core/providers/firebase_providers.dart';
import 'package:lakbay/core/typdef.dart';
import 'package:lakbay/models/coop_model.dart';
import 'package:lakbay/models/user_model.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(
    firestore: ref.read(firestoreProvider),
    auth: ref.read(authProvider),
    googleSignIn: ref.read(googleSignInProvider),
  );
});

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _firestore = firestore,
        _auth = auth,
        _googleSignIn = googleSignIn;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChange => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Remove the s96-c from the photo url to obtain higher resolu pic
      String? photoUrl = userCredential.user?.photoURL;
      if (photoUrl != null) {
        photoUrl = photoUrl.replaceAll('=s96-c', '');
      }

      UserModel userModel;

      // Check if user already exists
      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          uid: userCredential.user?.uid ?? "",
          name: userCredential.user?.displayName ?? "User Name",
          profilePic: photoUrl ?? Constants.profilePic,
          isAuthenticated: true,
          email: userCredential.user?.email ?? "",
          createdAt: DateTime.now(),
        );

        await _users.doc(userCredential.user!.uid).set(userModel.toJson());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }

      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Sign in with email and password
  // Sign in with email and password
  Future<Either<Failure, UserModel>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      UserModel userModel = await getUserData(userCredential.user!.uid).first;

      return right(userModel);
    } on FirebaseException catch (e) {
      if (e.code == 'wrong-password') {
        return left(Failure('The password is incorrect.'));
      } else {
        return left(Failure(e.message!));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Register user with email and password
  FutureEither<UserModel> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String gender,
    required DateTime birthDate,
    required String nationality,
    required String civilStatus,
    required String religion,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      UserModel userModel = UserModel(
        uid: userCredential.user?.uid ?? "",
        name: userCredential.user?.displayName ?? '$firstName $lastName',
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        birthDate: birthDate,
        age: DateTime.now().difference(birthDate).inDays ~/ 365,
        nationality: nationality,
        religion: religion,
        civilStatus: civilStatus,
        profilePic: '',
        isAuthenticated: true,
        email: email,
        createdAt: DateTime.now(),
      );

      await _users.doc(userCredential.user!.uid).set(userModel.toJson());

      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Register with email and password and add additional user data
  FutureEither<UserModel> registerMembers({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required FirebaseApp tempApp,
    required CooperativeModel coop,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instanceFor(app: tempApp)
              .createUserWithEmailAndPassword(email: email, password: password);

      // UserCredential userCredential = await _auth
      //     .createUserWithEmailAndPassword(email: email, password: password);

      UserModel userModel = UserModel(
          uid: userCredential.user?.uid ?? "",
          isCoopView: false,
          name: '$firstName $lastName',
          firstName: firstName,
          lastName: lastName,
          email: email,
          profilePic: '',
          isAuthenticated: true,
          currentCoop: coop.uid,
          cooperativesJoined: [
            CooperativesJoined(
              cooperativeId: coop.uid!,
              role: 'Member',
              cooperativeName: coop.name,
            )
          ]);

      await _users.doc(userCredential.user!.uid).set(userModel.toJson());

      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map((event) {
      return UserModel.fromJson(event.data() as Map<String, dynamic>);
    });
  }

  // logout
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
