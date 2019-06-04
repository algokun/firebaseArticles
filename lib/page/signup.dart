import 'package:firebase_articles/services/auth.dart';
import 'package:firebase_articles/util/bloc/signup_bloc.dart';
import 'package:firebase_articles/util/connection/nw_sense.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  SignupBloc bloc = SignupBloc();
  TextEditingController emailController, passwordController;

  bool isProgressVisible = false;
  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rich = TextSpan(children: [
      TextSpan(text: 'Signup \n', style: Theme.of(context).textTheme.title),
      TextSpan(
          text: 'Create your free account!\n',
          style: Theme.of(context)
              .textTheme
              .subhead
              .copyWith(color: Colors.black54))
    ]);
    return NetworkSensitive(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.blue,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(30.0),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 10),
                child: CircleAvatar(
                  child: Icon(
                    Icons.person_add,
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
                  stream: bloc.email,
                  builder: (context, snapshot) {
                    return TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: 'enter your email',
                          labelText: 'Email',
                          errorText: snapshot.error),
                      onChanged: bloc.emailChanged,
                    );
                  }),
              SizedBox(
                height: 10,
              ),
              StreamBuilder<String>(
                  stream: bloc.password,
                  builder: (context, snapshot) {
                    return TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'choose a strong password',
                          labelText: 'Choose Password',
                          errorText: snapshot.error),
                      onChanged: bloc.passwordChanged,
                    );
                  }),
              SizedBox(
                height: 10,
              ),
              StreamBuilder<String>(
                  stream: bloc.confirmPassword,
                  builder: (context, snapshot) {
                    return TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'confirm your password',
                          labelText: 'Confirm Password',
                          errorText: snapshot.error),
                      onChanged: bloc.passwordChanged2,
                    );
                  }),
              SizedBox(
                height: 10,
              ),
              StreamBuilder<bool>(
                  stream: bloc.submitCheck,
                  builder: (context, snapshot) {
                    return RaisedButton(
                      color: Colors.blue,
                      onPressed:
                          snapshot.hasData ? () => createUser(context) : null,
                      textColor: Colors.white,
                      child: Text("Signup"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    );
                  }),
            ],
          ),
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

  createUser(BuildContext c) async {
    changeProgress();
    String email = emailController.text;
    String password = passwordController.text;
    Auth auth = Auth.fromContext(context: c);
    await auth.createUser(email, password);
  }

  changeProgress(){
    setState(() {
     this.isProgressVisible = !isProgressVisible; 
    });
  }
}
