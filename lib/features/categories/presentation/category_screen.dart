import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view/widgets/my_appbar.dart';
import 'category_view_model.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoryViewModel(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar:  MyAppbar(titleMsg: 'Upload Category', showBackButton: true),
        body: const _CategoryBody(),
      ),
    );
  }
}

class _CategoryBody extends StatefulWidget {
  const _CategoryBody();
  @override
  State<_CategoryBody> createState() => _CategoryBodyState();
}

class _CategoryBodyState extends State<_CategoryBody> {
  final nameCtrl = TextEditingController();
  Uint8List? imageBytes;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CategoryViewModel>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            SizedBox(
              width: 320,
              child: TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Category name',
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.image,
                  withData: true,
                );
                if (result != null && result.files.single.bytes != null) {
                  setState(() => imageBytes = result.files.single.bytes);
                }
              },
              icon: const Icon(Icons.image),
              label: const Text('Pick image (optional)'),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: vm.busy
                  ? null
                  : () async {
                await vm.create(nameCtrl.text, imageBytes: imageBytes);
                if (!mounted) return;
                if (vm.error == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Category saved')),
                  );
                  nameCtrl.clear();
                  setState(() => imageBytes = null);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(vm.error!)),
                  );
                }
              },
              icon: const Icon(Icons.save),
              label: Text(vm.busy ? 'Saving…' : 'Save'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            ),
          ]),
          const SizedBox(height: 16),
          if (imageBytes != null)
            SizedBox(height: 120, child: Image.memory(imageBytes!, fit: BoxFit.cover)),
          const SizedBox(height: 16),
          const Expanded(child: _CategoryList()),
        ],
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<CategoryViewModel>();

    return StreamBuilder(
      stream: vm.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final items = snapshot.data!;
        if (items.isEmpty) {
          return const Center(
            child: Text('No categories yet', style: TextStyle(color: Colors.white70)),
          );
        }

        return ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(color: Colors.white12),
          itemBuilder: (context, i) {
            final c = items[i];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              leading: SizedBox(
                width: 56,
                height: 56,
                child: c.imageUrl != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(c.imageUrl!, fit: BoxFit.cover),
                )
                    : const Icon(Icons.category, color: Colors.white70),
              ),
              title: Text(c.name, style: const TextStyle(color: Colors.white)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: c.active,
                    onChanged: (v) async {
                      await vm.toggleActive(c.id, v);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('\"${c.name}\" ${v ? 'enabled' : 'disabled'}')),
                        );
                      }
                    },
                  ),
                  IconButton(
                    tooltip: 'Delete',
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete category?'),
                          content: Text('This will remove \"${c.name}\". Continue?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
                          ],
                        ),
                      );
                      if (ok == true) {
                        await vm.remove(c.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Deleted \"${c.name}\"')),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
