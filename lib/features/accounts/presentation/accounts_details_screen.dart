import 'package:flutter/material.dart';
// Make sure this path points to your created AccountModel file
import 'package:ubwinza_admin_dashboard/core/models/account_model.dart';
import 'package:ubwinza_admin_dashboard/globalVars/global_vars.dart';

class AccountDetailsScreen extends StatelessWidget {
  // Accepts the AccountModel object passed from the list screen
  final AccountModel account;

  const AccountDetailsScreen({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final isApproved = account.isApproved;

    return Scaffold(
      backgroundColor: screenBackgroundColor,
      appBar: AppBar(
        title: Text("${account.role.toUpperCase()} Details", style: const TextStyle(color: Colors.white)),
        backgroundColor: appbarColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Container(
            width: 800,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10),
                ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image
                Center(
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey.shade800,
                    // --- USES THE CORRECTED 'imageUrl' PROPERTY ---
                    backgroundImage: account.imageUrl != null
                        ? NetworkImage(account.imageUrl!)
                        : null,
                    // ----------------------------------------------
                    child: account.imageUrl == null
                        ? const Icon(Icons.person, size: 70, color: Colors.white70)
                        : null,
                  ),
                ),
                const SizedBox(height: 30),

                // Details Rows
                _detailRow("ID", account.id),
                _detailRow("Name", account.name),
                _detailRow("Email", account.email),
                _detailRow("Role", account.role.toUpperCase()),
                _detailRow(
                  "Status",
                  account.status.toUpperCase(),
                  valueColor: isApproved ? Colors.greenAccent : Colors.redAccent,
                ),

                // Add more detail rows here as needed...
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for displaying rows of data
  Widget _detailRow(String label, String value, {Color valueColor = Colors.white70}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label:",
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(color: valueColor, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}