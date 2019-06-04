import 'dart:async';
import 'package:rxdart/rxdart.dart';

class SignupBloc extends Object with Validators implements BaseBloc {
  final _emailController = BehaviorSubject<String>();
  final _passwordController1 = BehaviorSubject<String>();
  final _passwordController2 = BehaviorSubject<String>();

  Function(String) get emailChanged => _emailController.sink.add;
  Function(String) get passwordChanged => _passwordController1.sink.add;
  Function(String) get passwordChanged2 => _passwordController2.sink.add;
  

  Stream<String> get email => _emailController.stream.transform(emailValidator);

  Stream<String> get password =>
      _passwordController1.stream.transform(passwordValidator);

  Stream<String> get confirmPassword =>
      _passwordController2.stream.transform(passwordValidator2);

  Stream<bool> get submitCheck => Observable.combineLatest3(
      email, password, confirmPassword, (e, p, c) => 0 == (p.compareTo(c)));

  submit() {
    print("xyx");
  }

  @override
  void dispose() {
    _emailController?.close();
    _passwordController1?.close();
    _passwordController2?.close();
  }
}

abstract class BaseBloc {
  void dispose();
}

mixin Validators {
  var emailValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains("@")) {
      sink.add(email);
    } else {
      sink.addError("Email is badly formatted");
    }
  });

  var passwordValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 8) {
      sink.add(password);
    } else {
      sink.addError("Password length should be 8 chars minimum ");
    }
  });
  
  var passwordValidator2 = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 8) {
      sink.add(password);
    } else {
      sink.addError("Password should match");
    }
  });
}
