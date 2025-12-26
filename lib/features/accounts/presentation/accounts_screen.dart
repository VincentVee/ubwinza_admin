import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubwinza_admin_dashboard/globalVars/global_vars.dart';

// --- NEW IMPORTS (You must ensure these paths are correct) ---
// NOTE: Make sure your AccountsViewModel stream returns AccountModel objects.
import 'package:ubwinza_admin_dashboard/core/models/account_model.dart';
// --- END NEW IMPORTS ---

import '../../../view/widgets/my_appbar.dart';
import 'accounts_details_screen.dart';
import 'accounts_view_model.dart';

class AccountsScreen extends StatelessWidget {
  final String role; // user | seller | rider
  final bool verified; // true -> verified list, false -> blocked list

  const AccountsScreen({
    super.key,
    required this.role,
    required this.verified,
  });

  String get titlePart => verified ? 'VERIFIED' : 'BLOCKED';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AccountsViewModel(role: role, verified: verified),
      child: Scaffold(
        backgroundColor: screenBackgroundColor,
        appBar: MyAppbar(
          titleMsg: 'ALL $titlePart ${role.toUpperCase()} ACCOUNTS',
          showBackButton: true,
        ),
        body: const _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    // We use context.read() because we only need to access the VM, not rebuild on its change.
    final vm = context.read<AccountsViewModel>();

    // StreamBuilder must be typed to your list of AccountModel
    return StreamBuilder<List<AccountModel>>(
      stream: vm.stream as Stream<List<AccountModel>>, // Casting the stream result
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<AccountModel> items = snapshot.data!;
        if (items.isEmpty) {
          return const Center(
            child: Text(
              'No accounts',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (_, i) {
            final a = items[i];
            final makeVerified =
            !vm.verified; // on blocked list -> Verify; on verified list -> Block

            return Card(
              color: primaryColor,
              child: ListTile(
                // ----------------------------------------------------
                // THE NAVIGATION LOGIC
                // ----------------------------------------------------
                onTap: () {
                  // The item 'a' (AccountModel object) is passed to the details screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AccountDetailsScreen(account: a),
                    ),
                  );
                },
                // ----------------------------------------------------

                title: Text(
                  a.name.isEmpty ? a.email : a.name,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Status: ${a.status}',
                  style: const TextStyle(color: Colors.white60),
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    makeVerified ? Colors.green : Colors.deepOrange,
                  ),
                  onPressed: () async {
                    await vm.toggle(a.id, makeVerified: makeVerified);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${makeVerified ? 'Verified' : 'Blocked'} '
                                '${a.name.isEmpty ? a.email : a.name}',
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(makeVerified ? 'Verify' : 'Block'),
                ),
              ),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemCount: items.length,
        );
      },
    );
  }
}