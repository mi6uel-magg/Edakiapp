import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class EdakiFirebaseUser {
  EdakiFirebaseUser(this.user);
  User? user;
  bool get loggedIn => user != null;
}

EdakiFirebaseUser? currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
Stream<EdakiFirebaseUser> edakiFirebaseUserStream() => FirebaseAuth.instance
        .authStateChanges()
        .debounce((user) => user == null && !loggedIn
            ? TimerStream(true, const Duration(seconds: 1))
            : Stream.value(user))
        .map<EdakiFirebaseUser>(
      (user) {
        currentUser = EdakiFirebaseUser(user);
        return currentUser!;
      },
    );
