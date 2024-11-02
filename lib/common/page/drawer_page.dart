import 'package:flutter/material.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width / 5 * 3,
      child: Column(
        children: [
          const SizedBox(
            height: 64,
          ),
          Container(
            width: MediaQuery.sizeOf(context).width / 3,
            height: MediaQuery.sizeOf(context).width / 3,
            decoration: BoxDecoration(
              color: Colors.deepOrange.shade200,
              borderRadius: BorderRadius.circular(128),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            "선생님이름",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 16,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("설정"),
            onTap: () {
              print("설정");
            },
          )
        ],
      ),
    );
  }
}
