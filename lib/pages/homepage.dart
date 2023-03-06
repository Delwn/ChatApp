import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          const Text('Homepage'),
          FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("Sucess!!!")));
              },
              child: const Text("Pop"))
        ],
      ),
    ));
  }
}
