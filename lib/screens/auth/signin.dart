import 'package:flutter/material.dart';
import 'package:quickblox_chat_flutter/quickblox/services.dart';
import 'package:quickblox_chat_flutter/quickblox/setup.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? username;
  String? password;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initQuickBlox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
          child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              onSaved: (newValue) => username = newValue,
              decoration: InputDecoration(hintText: "Username"),
              validator: (value) {
                if (value!.isEmpty) return "Enter Username";
                return null;
              },
            ),
            SizedBox(
              height: 16,
            ),
            TextFormField(
              obscureText: true,
              onSaved: (newValue) => password = newValue,
              decoration: InputDecoration(hintText: "Password"),
              validator: (value) {
                if (value!.isEmpty) return "Enter Password";
                return null;
              },
            ),
            MaterialButton(
                child: Text("Login"),
                onPressed: (() async {
                  _formKey.currentState!.save();
                  if (_formKey.currentState!.validate()) {
                    bool isSucces = await QuickbloxServices.login(
                        _scaffoldKey, username!, password!);
                    if (isSucces) {}
                  }
                }))
          ],
        ),
      )),
    );
  }
}