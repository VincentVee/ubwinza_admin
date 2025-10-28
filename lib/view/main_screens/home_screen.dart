import 'package:flutter/material.dart';
import 'package:ubwinza_admin_dashboard/features/fares/presentation/fare_screen.dart';

import '../../features/accounts/presentation/accounts_screen.dart';
import '../../features/banners/presentation/banner_screen_final.dart';
import '../../features/categories/presentation/category_screen.dart';
import '../widgets/my_appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  void _go(BuildContext c, Widget page) {
    Navigator.of(c).push(MaterialPageRoute(builder: (_) => page));
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
      backgroundColor: Colors.black,
      appBar:  MyAppbar(titleMsg: 'Ubwinza Admin Web Panel', showBackButton: false),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
          Expanded(
          child: Row(children: [
            Expanded(child: _tile(
            color: Colors.deepOrange,
            icon: Icons.image,
            text: 'UPLOAD BANNER',
            onPressed: () => _go(context, const BannerScreen()),
          )),
      const SizedBox(width: 12),
      Expanded(child: _tile(
        color: Colors.purple,
        icon: Icons.category,
        text: 'UPLOAD CATEGORY',
        onPressed: () => _go(context, const CategoryScreen()),
      )),
      ]),
       ),
              const SizedBox(height: 12),
              Expanded(
                child: Row(children: [
                  Expanded(child: _tile(
                    color: Colors.green,
                    icon: Icons.verified,
                    text: 'ALL VERIFIED USERS ACCOUNTS',
                    onPressed: () => _go(context, const AccountsScreen(role: 'users', verified: true)),
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: _tile(
                    color: Colors.deepOrange,
                    icon: Icons.block,
                    text: 'ALL BLOCKED USER ACCOUNTS',
                    onPressed: () => _go(context, const AccountsScreen(role: 'users', verified: false)),
                  )),
                ]),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Row(children: [
                  Expanded(child: _tile(
                    color: Colors.purple,
                    icon: Icons.verified,
                    text: 'ALL VERIFIED SELLERS ACCOUNTS',
                    onPressed: () => _go(context, const AccountsScreen(role: 'sellers', verified: true)),
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: _tile(
                    color: Colors.green,
                    icon: Icons.block,
                    text: 'ALL BLOCKED SELLERS ACCOUNTS',
                    onPressed: () => _go(context, const AccountsScreen(role: 'sellers', verified: false)),
                  )),
                ]),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Row(children: [
                  Expanded(child: _tile(
                    color: Colors.deepOrange,
                    icon: Icons.verified,
                    text: 'ALL VERIFIED RIDERS ACCOUNTS',
                    onPressed: () => _go(context, const AccountsScreen(role: 'riders', verified: true)),
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: _tile(
                    color: Colors.purple,
                    icon: Icons.block,
                    text: 'ALL BLOCKED RIDERS ACCOUNTS',
                    onPressed: () => _go(context, const AccountsScreen(role: 'riders', verified: false)),
                  )),
                ]),
              ),

              const SizedBox(height: 12),
              Expanded(
                child: Row(children: [
                  Expanded(child: _tile(
                    color: Colors.deepOrange,
                    icon: Icons.verified,
                    text: 'Manage Fares',
                    onPressed: () => _go(context, const FareScreen()),
                  )),
                  // const SizedBox(width: 12),
                  // Expanded(child: _tile(
                  //   color: Colors.purple,
                  //   icon: Icons.block,
                  //   text: 'ALL BLOCKED RIDERS ACCOUNTS',
                  //   onPressed: () => _go(context, const AccountsScreen(role: 'riders', verified: false)),
                  // )),
                ]),
              ),
            ],
          ),
      ),
  );
}

Widget _tile({
  required Color color,
  required IconData icon,
  required String text,
  required VoidCallback onPressed,
}) {
  return ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    onPressed: onPressed,
    icon: Icon(icon, color: Colors.white, size: 24),
    label: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 1.5,
      ),
    ),
  );
 }
}