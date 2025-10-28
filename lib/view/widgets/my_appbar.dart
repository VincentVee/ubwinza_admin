
import 'package:flutter/material.dart';
import 'package:ubwinza_admin_dashboard/view/main_screens/home_screen.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  String titleMsg;
  bool showBackButton;
  PreferredSizeWidget? bottom;

  MyAppbar({super.key, required this.titleMsg, required this.showBackButton, this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepOrange,
              Colors.purple
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )
        ),
      ),
      leading: showBackButton == true ?
      IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: ()
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        },
      ): Container(),
      title: Center(
        child: Text(
          titleMsg,
          style: TextStyle(
            fontSize: 20,
            letterSpacing: 3,
            color: Colors.white
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => bottom == null ? Size(57, AppBar().preferredSize.height): Size(57, 80 +AppBar().preferredSize.height);
}
