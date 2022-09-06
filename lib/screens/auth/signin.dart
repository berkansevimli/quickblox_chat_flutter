import 'package:flutter/material.dart';
import 'package:quickblox_chat_flutter/quickblox/services.dart';
import 'package:quickblox_chat_flutter/quickblox/setup.dart';
import 'package:quickblox_chat_flutter/screens/auth/signup.dart';
import 'package:quickblox_chat_flutter/size_config.dart';

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
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
          child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Spacer(),
                  TextButton(
                      child: Text("Signup"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => RegisterScreen()));
                      })
                ],
              ),
              TextButton(
                  child: Text("Login"),
                  onPressed: (() async {
                    _formKey.currentState!.save();
                    if (_formKey.currentState!.validate()) {
                      bool isSucces = await QuickbloxServices.login(
                          _scaffoldKey, context, username!, password!);
                      if (isSucces) {}
                    }
                  })),
            ],
          ),
        ),
      )),
    );
  }
}
