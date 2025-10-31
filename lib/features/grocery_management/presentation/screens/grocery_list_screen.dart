import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/grocery_model.dart';
import '../cubit/grocery_cubit.dart';
import '../cubit/grocery_state.dart';

class GroceryListScreen extends StatelessWidget {
  const GroceryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.groceryList),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddGroceryDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<GroceryCubit, GroceryState>(
        builder: (context, state) {
          if (state is GroceryLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GroceryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(color: AppColors.error),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _refreshGroceries(context),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is GroceryLoaded) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Pantry Status Overview
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pantry Status',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatusChip(
                              'In Stock',
                              AppColors.groceryInStock,
                              state.stats['in_stock'] ?? 0,
                            ),
                            _buildStatusChip(
                              'Low Stock',
                              AppColors.groceryLow,
                              state.stats['low'] ?? 0,
                            ),
                            _buildStatusChip(
                              'Out of Stock',
                              AppColors.groceryOutOfStock,
                              state.stats['out_of_stock'] ?? 0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Grocery Items List
                if (state.items.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: const [
                          Icon(Icons.shopping_basket_outlined,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No grocery items yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tap + to add your first item',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...state.items.map((item) => _buildGroceryItemCard(
                        context,
                        item,
                      )),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color, int count) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, size: 16, color: color),
              const SizedBox(width: 8),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildGroceryItemCard(BuildContext context, GroceryItem item) {
    Color statusColor;
    String statusText;

    if (item.status == 'in_stock') {
      statusColor = AppColors.groceryInStock;
      statusText = 'In Stock';
    } else if (item.status == 'low') {
      statusColor = AppColors.groceryLow;
      statusText = 'Low';
    } else {
      statusColor = AppColors.groceryOutOfStock;
      statusText = 'Out of Stock';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.1),
          child: Icon(Icons.shopping_basket, color: statusColor),
        ),
        title: Text(item.itemName),
        subtitle: Text('${item.quantity} ${item.unit}'),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
              onTap: () => Future.delayed(
                Duration.zero,
                () => _showEditGroceryDialog(context, item),
              ),
            ),
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(Icons.delete, size: 20, color: AppColors.error),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: AppColors.error)),
                ],
              ),
              onTap: () => Future.delayed(
                Duration.zero,
                () => _deleteGroceryItem(context, item.id!),
              ),
            ),
          ],
          child: Chip(
            label: Text(
              statusText,
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
            backgroundColor: statusColor,
          ),
        ),
        onTap: () {
          // Show item details
        },
      ),
    );
  }

  void _showAddGroceryDialog(BuildContext context) {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    final unitController = TextEditingController(text: 'kg');
    String selectedStatus = 'in_stock';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Grocery Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    prefixIcon: Icon(Icons.shopping_basket),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: unitController,
                        decoration: const InputDecoration(
                          labelText: 'Unit',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'in_stock',
                      child: Text('In Stock'),
                    ),
                    DropdownMenuItem(value: 'low', child: Text('Low')),
                    DropdownMenuItem(
                      value: 'out_of_stock',
                      child: Text('Out of Stock'),
                    ),
                  ],
                  onChanged: (value) => setDialogState(() {
                    selectedStatus = value ?? 'in_stock';
                  }),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    quantityController.text.isNotEmpty) {
                  _addGroceryItem(
                    context,
                    nameController.text,
                    int.parse(quantityController.text),
                    unitController.text,
                    selectedStatus,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditGroceryDialog(BuildContext context, GroceryItem item) {
    final nameController = TextEditingController(text: item.itemName);
    final quantityController = TextEditingController(text: item.quantity.toString());
    final unitController = TextEditingController(text: item.unit);
    String selectedStatus = item.status;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Grocery Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    prefixIcon: Icon(Icons.shopping_basket),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: unitController,
                        decoration: const InputDecoration(
                          labelText: 'Unit',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'in_stock',
                      child: Text('In Stock'),
                    ),
                    DropdownMenuItem(value: 'low', child: Text('Low')),
                    DropdownMenuItem(
                      value: 'out_of_stock',
                      child: Text('Out of Stock'),
                    ),
                  ],
                  onChanged: (value) => setDialogState(() {
                    selectedStatus = value ?? 'in_stock';
                  }),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    quantityController.text.isNotEmpty) {
                  context.read<GroceryCubit>().updateGroceryItem(
                    item.copyWith(
                      itemName: nameController.text,
                      quantity: int.parse(quantityController.text),
                      unit: unitController.text,
                      status: selectedStatus,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _addGroceryItem(
    BuildContext context,
    String name,
    int quantity,
    String unit,
    String status,
  ) {
    // Get current user info from auth
    final authState = context.read<GroceryCubit>().runtimeType;
    // This will be properly implemented with auth context
    
    // For now, use dummy data
    context.read<GroceryCubit>().addGroceryItem(
          itemName: name,
          quantity: quantity,
          unit: unit,
          status: status,
          addedBy: 'current_user',
          familyId: 'current_family',
        );
  }

  void _deleteGroceryItem(BuildContext context, String itemId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item?'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<GroceryCubit>().deleteGroceryItem(itemId);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _refreshGroceries(BuildContext context) {
    // Refresh groceries - will be implemented with auth context
  }
}
