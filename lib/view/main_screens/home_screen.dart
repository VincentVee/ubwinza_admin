import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ubwinza_admin_dashboard/features/auth/login_screen.dart';

import '../../features/controllers/dashboard_controller.dart';
import '../../features/accounts/presentation/accounts_screen.dart';
import '../../features/categories/presentation/category_screen.dart';
import '../../features/banners/presentation/banner_screen_final.dart';
import '../../features/fares/presentation/fare_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = DashboardController();

  String selectedPage = "dashboard";
  bool? selectedStatus;

  @override
  void initState() {
    super.initState();
    controller.loadStats();
  }

@override
Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      
      bool isDesktop = constraints.maxWidth > 1100;
      bool isTablet = constraints.maxWidth <= 1100 && constraints.maxWidth > 700;
      bool isMobile = constraints.maxWidth <= 700;

      return Scaffold(
        backgroundColor: const Color(0xFF1A1A27),

        // -------------------------------
        // SHOW DRAWER ONLY ON TABLET/MOBILE
        // -------------------------------
        drawer: !isDesktop 
            ? Drawer(
                backgroundColor: const Color(0xFF1A1643),
                child: _LeftNavBar(
                  isCollapsed: false,
                  onSelect: _onSelectPage,
                  onLogout: _logout,
                ),
              )
            : null,

        // -------------------------------
        // APPBAR ONLY WHEN NOT DESKTOP
        // -------------------------------
        appBar: !isDesktop
            ? AppBar(
                backgroundColor: const Color(0xFF1A1A27),
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.white),
                title: const Text(
                  "Ubwinza Admin Dashboard",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : null,

        body: Row(
          children: [
            // DESKTOP LEFT MENU
            if (isDesktop)
              _LeftNavBar(
                isCollapsed: false,
                onSelect: _onSelectPage,
                onLogout: _logout,
              ),

            // MAIN CONTENT
            Expanded(
              child: Container(
                color: const Color(0xFF151521),
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, _) {
                    if (controller.loading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.deepOrange),
                      );
                    }
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _getPage(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

 

  void _onSelectPage(String page, bool? status) {
    setState(() {
      selectedPage = page;
      selectedStatus = status;
    });
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  // ---------------------------- PAGE ROUTER --------------------------------

  Widget _getPage() {
    switch (selectedPage) {
      case "dashboard":
        return _dashboard();

      case "users":
        return AccountsScreen(
          role: "users",
          verified: selectedStatus!,
          key: ValueKey("users_${selectedStatus.toString()}"),
        );

      case "sellers":
        return AccountsScreen(
          role: "sellers",
          verified: selectedStatus!,
          key: ValueKey("sellers_${selectedStatus.toString()}"),
        );

      case "riders":
        return AccountsScreen(
          role: "riders",
          verified: selectedStatus!,
          key: ValueKey("riders_${selectedStatus.toString()}"),
        );

      case "fares":
        return const FareScreen();

      case "categories":
        return const CategoryScreen();

      case "banners":
        return const BannerScreen();

      default:
        return const SizedBox();
    }
  }

  // ------------------------------ DASHBOARD ------------------------------

  Widget _dashboard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 700;

        return SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 12 : 20),
          child: Column(
            children: [
              _dashboardStats(isMobile),
              const SizedBox(height: 20),
              _analyticsChart(isMobile),
            ],
          ),
        );
      },
    );
  }

  Widget _dashboardStats(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 22),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1643),  // CARD COLOR
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.people, color: Colors.white, size: isMobile ? 32 : 40),
          SizedBox(width: isMobile ? 14 : 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.totalUsers.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 22 : 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text("Total Users", style: TextStyle(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _analyticsChart(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 22),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1643), // CARD COLOR
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "User Analytics",
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 16 : 18,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(height: isMobile ? 200 : 260, child: _barChart()),
        ],
      ),
    );
  }

  Widget _barChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,

        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, _) {
              switch (value.toInt()) {
                case 0:
                  return const Text("Users", style: TextStyle(color: Colors.white70));
                case 1:
                  return const Text("Sellers", style: TextStyle(color: Colors.white70));
                case 2:
                  return const Text("Riders", style: TextStyle(color: Colors.white70));
              }
              return const SizedBox();
            }),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),

        barGroups: [
          BarChartGroupData(x: 0, barRods: [
            BarChartRodData(toY: controller.totalUsers.toDouble(), width: 24, color: Colors.white),
          ]),
          BarChartGroupData(x: 1, barRods: [
            BarChartRodData(toY: controller.totalSellers.toDouble(), width: 24, color: Colors.white),
          ]),
          BarChartGroupData(x: 2, barRods: [
            BarChartRodData(toY: controller.totalRiders.toDouble(), width: 24, color: Colors.white),
          ]),
        ],
      ),
    );
  }
}

//
// -------------------------- LEFT SIDEBAR --------------------------
//

class _LeftNavBar extends StatefulWidget {
  final Function(String page, bool? verified) onSelect;
  final VoidCallback onLogout;
  final bool isCollapsed;

  const _LeftNavBar({
    super.key,
    required this.onSelect,
    required this.onLogout,
    required this.isCollapsed,
  });

  @override
  State<_LeftNavBar> createState() => _LeftNavBarState();
}

class _LeftNavBarState extends State<_LeftNavBar> {
  bool usersExpanded = false;
  bool sellersExpanded = false;
  bool ridersExpanded = false;

  String activeParent = "dashboard";
  String activeChild = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.isCollapsed ? 70 : 240,
      color: const Color(0xFF1A1643), // NEW SIDEBAR COLOR
      child: ListView(
        children: [
          const SizedBox(height: 30),

          if (!widget.isCollapsed)
            const Center(
              child: Text(
                "UBWINZA ADMIN",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

          const SizedBox(height: 20),
          const Divider(color: Colors.white24),

          _mainItem(Icons.dashboard, "Dashboard", "dashboard"),

          _expandableMenu(
            title: "Users",
            icon: Icons.people,
            expanded: usersExpanded,
            children: [
              _childItem("Approved", "users", true),
              _childItem("Blocked", "users", false),
            ],
            onTap: () => setState(() => usersExpanded = !usersExpanded),
          ),

          _expandableMenu(
            title: "Sellers",
            icon: Icons.store,
            expanded: sellersExpanded,
            children: [
              _childItem("Approved", "sellers", true),
              _childItem("Blocked", "sellers", false),
            ],
            onTap: () => setState(() => sellersExpanded = !sellersExpanded),
          ),

          _expandableMenu(
            title: "Riders",
            icon: Icons.motorcycle,
            expanded: ridersExpanded,
            children: [
              _childItem("Approved", "riders", true),
              _childItem("Blocked", "riders", false),
            ],
            onTap: () => setState(() => ridersExpanded = !ridersExpanded),
          ),

          _mainItem(Icons.monetization_on, "Fares", "fares"),
          _mainItem(Icons.category, "Categories", "categories"),
          _mainItem(Icons.image, "Banners", "banners"),

          const Divider(color: Colors.white24),

          _logoutItem(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ---------------------- MAIN ITEM ----------------------

  Widget _mainItem(IconData icon, String title, String page) {
    bool isActive = activeParent == page;

    return Container(
      color: isActive ? Colors.black12 : Colors.transparent,
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: widget.isCollapsed
            ? null
            : Text(title, style: const TextStyle(color: Colors.white)),
        onTap: () {
          setState(() {
            activeParent = page;
            activeChild = "";
          });

          widget.onSelect(page, null);
        },
      ),
    );
  }

  // ---------------------- LOGOUT ----------------------

  Widget _logoutItem() {
    return Container(
      color: activeParent == "logout" ? Colors.black26 : Colors.transparent,
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.white),
        title: widget.isCollapsed
            ? null
            : const Text("Logout", style: TextStyle(color: Colors.white)),
        onTap: widget.onLogout,
      ),
    );
  }

  // ---------------------- EXPANDABLE MENUS ----------------------

  Widget _expandableMenu({
    required String title,
    required IconData icon,
    required bool expanded,
    required VoidCallback onTap,
    required List<Widget> children,
  }) {
    bool isActive = activeParent == title.toLowerCase();

    return Column(
      children: [
        Container(
          color: isActive ? Colors.black26 : Colors.transparent,
          child: ListTile(
            leading: Icon(icon, color: Colors.white),
            title: widget.isCollapsed
                ? null
                : Text(title, style: const TextStyle(color: Colors.white)),
            trailing: widget.isCollapsed
                ? null
                : Icon(expanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white),
            onTap: onTap,
          ),
        ),

        if (expanded && !widget.isCollapsed)
          Container(
            padding: const EdgeInsets.only(left: 40),
            child: Column(children: children),
          ),
      ],
    );
  }

  // ---------------------- CHILD ITEMS ----------------------

  Widget _childItem(String title, String role, bool status) {
    bool isActive =
        activeParent == role && activeChild == title.toLowerCase();

    return Container(
      color: isActive ? Colors.black26 : Colors.transparent,
      child: ListTile(
        title: widget.isCollapsed
            ? null
            : Text(title, style: const TextStyle(color: Colors.white)),
        onTap: () {
          setState(() {
            activeParent = role;
            activeChild = title.toLowerCase();
          });

          widget.onSelect(role, status);
        },
      ),
    );
  }
}
