import 'package:flutter/material.dart';
import 'package:quickblox_chat_flutter/quickblox/services.dart';
import 'package:quickblox_chat_flutter/quickblox/setup.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? username;
  String? password;
  String? fullname;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Register"),
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
                onSaved: (newValue) => fullname = newValue,
                decoration: InputDecoration(hintText: "Full Name"),
                validator: (value) {
                  if (value!.isEmpty) return "Enter Full Name";
                  return null;
                },
              ),
              SizedBox(
                height: 16,
              ),
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
                      child: Text("Login"),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              ),
              TextButton(
                  child: Text("Register"),
                  onPressed: () async {
                    _formKey.currentState!.save();
                    if (_formKey.currentState!.validate()) {
                      await QuickbloxServices.createUser(_scaffoldKey, context,
                          username!, password!, fullname!);
                    }
                  }),
            ],
          ),
        ),
      )),
    );
  }
}
