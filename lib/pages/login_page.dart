import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gdsc_app/support/pallete.dart';
import 'package:http/http.dart' as http;
import 'homepage.dart';
import 'package:gdsc_app/support/login_payload.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _usernameFilled = true, _passwordFilled = true, _isLoading = false;

  final url = Uri.parse('http://192.168.137.1:5000/validate');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            const Image(image: AssetImage('assets/account_circle.png')),
            const SizedBox(
              height: 150,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  hintText: "Enter username",
                  errorText: _usernameFilled ? null : "Please fill this field",
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Palette.purplePallete)),
                ),
                onChanged: (value) {
                  _usernameFilled = true;
                  setState(() {});
                },
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Enter Password",
                  errorText: _passwordFilled ? null : "Please fill this field",
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Palette.purplePallete)),
                ),
                onChanged: (value) {
                  _passwordFilled = true;
                  setState(() {});
                },
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            FilledButton.icon(
              label: const Text("Submit"),
              icon: _isLoading
                  ? Container(
                      width: 24,
                      height: 24,
                      padding: const EdgeInsets.all(2.0),
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : const Icon(Icons.done),
              onPressed: () async {
                //print("Here!!!");
                if (usernameController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  _isLoading = true;
                  setState(() {});
                  var isSuccess =
                      createPost(usernameController, passwordController, url);
                  isSuccess.then((value) => {
                        if (value == "Success")
                          {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()))
                          }
                        else
                          {
                            _isLoading = false,
                            setState(() {}),
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(value)))
                          },
                        // print("Here")
                      });
                } else {
                  if (usernameController.text.isEmpty) {
                    _usernameFilled = false;
                    setState(() {});
                  }

                  if (usernameController.text.isEmpty) {
                    _usernameFilled = false;
                    setState(() {});
                  }
                }
              },
              style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20, horizontal: 125)),
            ),
            const SizedBox(
              height: 10,
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.person_add_alt),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
              style: OutlinedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                      vertical: 20, horizontal: 125)),
              label: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String> createPost(usernameController, passwordController, url) async {
  try {
    var payload = LoginPayload(
        username: usernameController.text, password: passwordController.text);
    //print(payload.toJson());
    var res = await http.post(url, body: payload.toJson());
    //print(res.body);
    if (res.statusCode >= 200 && res.statusCode <= 299) {
      return "Success";
    } else if (res.statusCode >= 300 && res.statusCode <= 399) {
      return "Redirection Error";
    } else if (res.statusCode >= 400 && res.statusCode <= 499) {
      return "Server not found";
    } else if (res.statusCode >= 500 && res.statusCode <= 599) {
      return "Internal server error";
    } else {
      return "Unknown error";
    }
  } on Exception catch (e) {
    return e.toString();
  }
  //Map<String, dynamic> resMap = jsonDecode(res.body);
  // print(resMap);
  //return resMap["success"];
}
