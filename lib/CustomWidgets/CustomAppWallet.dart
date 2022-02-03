import 'package:flutter/material.dart';
import 'package:total_load_up/screens/bottom_nav.dart';

class CustomAppWallet extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.red[600],
      elevation: 0.0,
      leading: IconButton(
          icon: const Icon(Icons.menu), iconSize: 28.0, onPressed: () {}),
      title: Text("Airtel Money"),
      centerTitle: true,
      actions: [
        IconButton(
            icon: const Icon(Icons.exit_to_app),
            iconSize: 28.0,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BottomNavBar()));
            }),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
