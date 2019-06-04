
import 'package:firebase_articles/page/signup.dart';
import 'package:firebase_articles/services/auth.dart';
import 'package:firebase_articles/util/bloc/login_bloc.dart';
import 'package:firebase_articles/util/connection/nw_sense.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController, passwordController;
  final loginBloc = LoginBloc();

  bool isProgressVisible = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rich = TextSpan(children: [
      TextSpan(text: 'Login \n', style: Theme.of(context).textTheme.title),
      TextSpan(
          text: 'First you need to login',
          style: Theme.of(context)
              .textTheme
              .subtitle
              .copyWith(color: Colors.black54))
    ]);
    return NetworkSensitive(
          child: Scaffold(
          body: Container(
        child: _buildBody(context, rich),
        padding: EdgeInsets.all(30.0),
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size(double.infinity, 20.0),
        child: SizedBox(
          height: 10,
          child: Visibility(visible: isProgressVisible ,child: LinearProgressIndicator()),
        ),
      ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, TextSpan rich) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(top: 10),
          child: CircleAvatar(
            child: Icon(
              Icons.lock_outline,
              size: 40.0,
            ),
            radius: 40.0,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text.rich(rich),
        StreamBuilder<String>(
            stream: loginBloc.email,
            builder: (context, snapshot) {
              return TextField(
                controller: emailController,
                onChanged: loginBloc.emailChanged,
                decoration: InputDecoration(
                    hintText: 'enter your email',
                    labelText: 'Email',
                    errorText: snapshot.error),
              );
            }),
        SizedBox(
          height: 10,
        ),
        StreamBuilder<String>(
            stream: loginBloc.password,
            builder: (context, snapshot) {
              return TextField(
                controller: passwordController,
                onChanged: loginBloc.passwordChanged,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: 'enter your password',
                    labelText: 'Password',
                    errorText: snapshot.error),
              );
            }),
        SizedBox(
          height: 10,
        ),
        StreamBuilder<bool>(
            stream: loginBloc.submitCheck,
            builder: (context, snapshot) {
              return RaisedButton(
                color: Colors.blue,
                onPressed: snapshot.hasData ? () => signInUser(context) : null,
                textColor: Colors.white,
                child: Text("Login"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              );
            }),
        FlatButton(
          child: Text("Dont have an account?"),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignupPage())),
        )
      ],
    );
    
  }

  signInUser(BuildContext c) async {
    changeProgress();
    String email = emailController.text;
    String password = passwordController.text;
    Auth auth = Auth.fromContext(context: c);
    await auth.signInUser(email, password);
  }

  changeProgress(){
    setState(() {
     this.isProgressVisible = !isProgressVisible; 
    });
  }
}
