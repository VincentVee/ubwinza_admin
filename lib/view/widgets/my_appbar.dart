// lib/view/widgets/my_appbar.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ubwinza_admin_dashboard/features/auth/login_screen.dart';
import 'package:ubwinza_admin_dashboard/globalVars/global_vars.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String titleMsg;
  final bool showBackButton;
  final PreferredSizeWidget? bottom;

  const MyAppbar({
    super.key,
    required this.titleMsg,
    required this.showBackButton,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBackButton,
      backgroundColor: appbarColor,
      elevation: 4,

      title: Text(
        titleMsg,
        style: const TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 1.5),
      ),

      actions: [
        PopupMenuButton(

          icon: const Icon(Icons.person, color: Colors.white),
          color: primaryColor,
          itemBuilder: (_) => [
            const PopupMenuItem(
              child: Text("Profile", style: TextStyle(color: Colors.white)),
            ),
            PopupMenuItem(
              child: const Text("Logout", style: TextStyle(color: Colors.white)),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Future.delayed(
                  Duration.zero,
                  () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (_) => false,
                  ),
                );
              },
            ),
          ],
        )
      ],
    );
  }

  @override
  Size get preferredSize =>
      bottom == null
          ? const Size.fromHeight(kToolbarHeight)
          : Size.fromHeight(kToolbarHeight + 60);
}
