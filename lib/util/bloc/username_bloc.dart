import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class UsernameBloc implements AbstractBase {
  final _nameController = BehaviorSubject<String>();

  Function(String) get nameChanged => _nameController.sink.add;

  Stream<String> get username =>
      _nameController.stream.transform(usernameValidator);

  var usernameValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (username, sink) async {
    if (username.isEmpty) {
      sink.addError("username should not be null");
    } else if (username.length <= 4) {
      sink.addError("Username should be 4 characters");
    } else {
      await Firestore.instance
          .collection("users")
          .where("username", isEqualTo: username)
          .getDocuments()
          .then((querySnapshot) {
        int len = querySnapshot.documents.length;
        len != 0
            ? sink.addError("Username exist , try different name")
            : sink.add(username);
      });
    }
  });

  // Future isUserNameExist(String name) async {

  // }
  @override
  void dispose() {
    _nameController.close();
  }
}

abstract class AbstractBase {
  void dispose();
}
