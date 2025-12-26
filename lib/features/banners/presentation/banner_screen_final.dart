import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubwinza_admin_dashboard/globalVars/global_vars.dart';
import 'package:ubwinza_admin_dashboard/view/widgets/my_appbar.dart';
import 'banner_view_model.dart';

class BannerScreen extends StatelessWidget {
  const BannerScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BannerViewModel(),
      child: Scaffold(
        backgroundColor: screenBackgroundColor,
        appBar:  MyAppbar(titleMsg: 'Upload Banners', showBackButton: true),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _UploaderBar(),
              const SizedBox(height: 16),
              const Expanded(child: _BannerList()),
            ],
          ),
        ),
      ),
    );
  }
}

class _UploaderBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BannerViewModel>();
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: vm.busy
              ? null
              : () async {
            final result = await FilePicker.platform.pickFiles(
              type: FileType.image,
              withData: true,
            );
            if (result != null && result.files.single.bytes != null) {
              final Uint8List bytes = result.files.single.bytes!;
              await context.read<BannerViewModel>().createFromBytes(bytes);
            }
          },
          icon: const Icon(Icons.image),
          label: Text(vm.busy ? 'Uploading…' : 'Pick Image'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
        ),
        const SizedBox(width: 12),
        if (vm.error != null)
          Text(vm.error!, style: const TextStyle(color: Colors.redAccent)),
      ],
    );
  }
}

class _BannerList extends StatelessWidget {
  const _BannerList({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<BannerViewModel>();

    return StreamBuilder(
      stream: vm.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return const Center(
            child: Text(
              'No banners yet',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 16 / 10,
          ),
          itemCount: items.length,
          itemBuilder: (context, i) {
            final b = items[i];
            return Card(
              color: const Color(0xFF141414),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        b.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Switch(
                          value: b.active,
                          onChanged: (v) => vm.toggleActive(b.id, v),
                        ),
                        const Spacer(),
                        IconButton(
                          tooltip: 'Delete',
                          onPressed: () => vm.remove(b.id),
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
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

