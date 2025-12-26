import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubwinza_admin_dashboard/core/models/fare_model.dart';
import 'package:ubwinza_admin_dashboard/globalVars/global_vars.dart';
import 'package:ubwinza_admin_dashboard/view/widgets/my_appbar.dart';
import 'fare_view_model.dart';

class FareScreen extends StatelessWidget {
  const FareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FareViewModel(),
      child: Scaffold(
        backgroundColor: screenBackgroundColor,
        appBar: MyAppbar(titleMsg: 'Manage Fares', showBackButton: true),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AddFareForm(),
              SizedBox(height: 16),
              Expanded(child: _FareList()),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddFareForm extends StatefulWidget {
  const _AddFareForm({super.key});

  @override
  State<_AddFareForm> createState() => _AddFareFormState();
}

class _AddFareFormState extends State<_AddFareForm> {
  final _formKey = GlobalKey<FormState>();
  final _rideTypeController = TextEditingController();
  final _priceController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _rideTypeController.dispose();
    _priceController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final vm = context.read<FareViewModel>();
      vm.createFare(
        rideType: _rideTypeController.text.trim(),
        pricePerKilometer: double.parse(_priceController.text.trim()),
      ).then((_) {
        if (vm.error == null) {
          _rideTypeController.clear();
          _priceController.clear();
          _focusNode.requestFocus();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FareViewModel>();

    return Form(
      key: _formKey,
      child: Card(
        color: primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Fare',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _rideTypeController,
                      focusNode: _focusNode,
                      decoration: const InputDecoration(
                        labelText: 'Ride Type',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.black,
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter ride type';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price per Kilometer',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.black,
                        labelStyle: TextStyle(color: Colors.white70),
                      ),
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter price';
                        }
                        final price = double.tryParse(value);
                        if (price == null || price <= 0) {
                          return 'Please enter valid price';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: vm.busy ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                    child: Text(
                      vm.busy ? 'Adding...' : 'Add Fare',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              if (vm.error != null) ...[
                const SizedBox(height: 8),
                Text(
                  vm.error!,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FareList extends StatelessWidget {
  const _FareList({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<FareViewModel>();

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
              'No fares yet',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final fare = items[index];
            return _FareListItem(fare: fare);
          },
        );
      },
    );
  }
}

class _FareListItem extends StatefulWidget {
  final FareModel fare;

  const _FareListItem({super.key, required this.fare});

  @override
  State<_FareListItem> createState() => _FareListItemState();
}

class _FareListItemState extends State<_FareListItem> {
  final _editPriceController = TextEditingController();
  bool _editing = false;

  @override
  void dispose() {
    _editPriceController.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      _editing = true;
      _editPriceController.text = widget.fare.pricePerKilometer.toString();
    });
  }

  void _savePrice() {
    final newPrice = double.tryParse(_editPriceController.text.trim());
    if (newPrice != null && newPrice > 0) {
      context.read<FareViewModel>().updatePrice(widget.fare.id, newPrice);
    }
    setState(() {
      _editing = false;
    });
  }

  void _cancelEditing() {
    setState(() {
      _editing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final fare = widget.fare;

    return Card(
      color: primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fare.rideType,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Created: ${_formatDate(fare.createdAt)}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            if (_editing) ...[
              SizedBox(
                width: 120,
                child: TextFormField(
                  controller: _editPriceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.black,
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _savePrice,
                icon: const Icon(Icons.check, color: Colors.green),
              ),
              IconButton(
                onPressed: _cancelEditing,
                icon: const Icon(Icons.close, color: Colors.red),
              ),
            ] else ...[
              Text(
                '${fare.pricePerKilometer.toStringAsFixed(2)}/km',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _startEditing,
                icon: const Icon(Icons.edit, color: Colors.blue),
                tooltip: 'Edit Price',
              ),
              IconButton(
                onPressed: () => context.read<FareViewModel>().remove(fare.id),
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                tooltip: 'Delete',
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}