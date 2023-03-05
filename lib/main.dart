import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gdsc_app/homepage.dart';
import 'package:gdsc_app/login_payload.dart';
import 'package:http/http.dart' as http;

import 'pallete.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Palette.purplePallete),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _usernameFilled = true, _passwordFilled = true;

  final url = Uri.parse('http://192.168.137.1:5000/validate');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: Palette.purplePallete[2],
        foregroundColor: Palette.purplePallete[1],
        elevation: 0,
      ),
      drawer: const Drawer(),
      body: SingleChildScrollView(
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
                    errorText:
                        _usernameFilled ? null : "Please fill this field",
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
                    errorText:
                        _passwordFilled ? null : "Please fill this field",
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
              FilledButton(
                onPressed: () async {
                  //print("Here!!!");
                  if (usernameController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty) {
                    var isSuccess =
                        createPost(usernameController, passwordController, url);
                    isSuccess.then((value) => {
                          if (value)
                            {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const HomePage()))
                            }
                          else
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Invalid Credentials!!!")))
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
                        vertical: 20, horizontal: 140)),
                child: const Text('Submit'),
              ),
              const SizedBox(
                height: 10,
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const HomePage()));
                },
                style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 150)),
                child: const Text('Exit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

TextField createTextField(text, hint, inputController, isFilled) {
  return TextField(
    controller: inputController,
    decoration: InputDecoration(
      labelText: text,
      hintText: hint,
      errorText: isFilled ? null : "Please fill this field",
      border: const OutlineInputBorder(),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Palette.purplePallete)),
    ),
    onChanged: (value) {
      isFilled = true;
    },
  );
}

Future<bool> createPost(usernameController, passwordController, url) async {
  var payload = LoginPayload(
      username: usernameController.text, password: passwordController.text);
  //print(payload.toJson());
  var res = await http.post(url, body: payload.toJson());
  //print(res.body);

  Map<String, dynamic> resMap = jsonDecode(res.body);
  // print(resMap);
  return resMap["success"];
}
