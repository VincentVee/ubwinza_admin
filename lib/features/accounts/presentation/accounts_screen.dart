import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view/widgets/my_appbar.dart';
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
        backgroundColor: Colors.black,
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
    final vm = context.read<AccountsViewModel>();

    return StreamBuilder(
      stream: vm.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = snapshot.data!;
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
              color: const Color(0xFF141414),
              child: ListTile(
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
