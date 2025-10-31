import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/chore_model.dart';
import '../cubit/chore_cubit.dart';
import '../cubit/chore_state.dart';

class ChoresScreen extends StatelessWidget {
  const ChoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.chores),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Pending'),
              Tab(text: 'In Progress'),
              Tab(text: 'Completed'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddChoreDialog(context),
            ),
          ],
        ),
        body: BlocBuilder<ChoreCubit, ChoreState>(
          builder: (context, state) {
            if (state is ChoreLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ChoreError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: AppColors.error),
                    const SizedBox(height: 16),
                    Text(state.message, style: const TextStyle(color: AppColors.error)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _refreshChores(context),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is ChoreLoaded) {
              return TabBarView(
                children: [
                  _buildChoresList(context, state.chores, null),
                  _buildChoresList(context, state.chores, 'pending'),
                  _buildChoresList(context, state.chores, 'in_progress'),
                  _buildChoresList(context, state.chores, 'completed'),
                ],
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildChoresList(BuildContext context, List<Chore> chores, String? status) {
    final filteredChores = status == null
        ? chores
        : chores.where((chore) => chore.status == status).toList();

    if (filteredChores.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check_circle_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No chores yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Tap + to add your first chore',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredChores.length,
      itemBuilder: (context, index) {
        return _buildChoreCard(context, filteredChores[index]);
      },
    );
  }

  Widget _buildChoreCard(BuildContext context, Chore chore) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (chore.status == 'pending') {
      statusColor = AppColors.chorePending;
      statusText = 'Pending';
      statusIcon = Icons.pending;
    } else if (chore.status == 'in_progress') {
      statusColor = AppColors.choreInProgress;
      statusText = 'In Progress';
      statusIcon = Icons.in_progress;
    } else {
      statusColor = AppColors.choreCompleted;
      statusText = 'Completed';
      statusIcon = Icons.check_circle;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.1),
          child: Icon(statusIcon, color: statusColor),
        ),
        title: Text(chore.title),
        subtitle: Text('Assigned to: ${chore.assignedTo}'),
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
                () => _showEditChoreDialog(context, chore),
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
                () => _deleteChore(context, chore.id!),
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
          _showChoreOptions(context, chore);
        },
      ),
    );
  }

  void _showChoreOptions(BuildContext context, Chore chore) {
    final statuses = ['pending', 'in_progress', 'completed'];
    final statusLabels = ['Pending', 'In Progress', 'Completed'];

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(chore.title),
              subtitle: Text(chore.description),
            ),
            const Divider(),
            ...List.generate(3, (index) {
              if (statuses[index] == chore.status) return const SizedBox();
              return ListTile(
                leading: Icon(
                  _getStatusIcon(statuses[index]),
                  color: _getStatusColor(statuses[index]),
                ),
                title: Text(statusLabels[index]),
                onTap: () {
                  context.read<ChoreCubit>().updateChoreStatus(
                    chore.id!,
                    statuses[index],
                  );
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showAddChoreDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final assignedController = TextEditingController();
    String selectedStatus = 'pending';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Chore'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    prefixIcon: Icon(Icons.cleaning_services),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: assignedController,
                  decoration: const InputDecoration(
                    labelText: 'Assigned To',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                  ),
                  items: const [
                    DropdownMenuItem(value: 'pending', child: Text('Pending')),
                    DropdownMenuItem(
                      value: 'in_progress',
                      child: Text('In Progress'),
                    ),
                    DropdownMenuItem(
                      value: 'completed',
                      child: Text('Completed'),
                    ),
                  ],
                  onChanged: (value) =>
                      setDialogState(() => selectedStatus = value ?? 'pending'),
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
                if (titleController.text.isNotEmpty) {
                  _addChore(
                    context,
                    titleController.text,
                    descriptionController.text,
                    assignedController.text,
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

  void _showEditChoreDialog(BuildContext context, Chore chore) {
    final titleController = TextEditingController(text: chore.title);
    final descriptionController = TextEditingController(text: chore.description);
    final assignedController = TextEditingController(text: chore.assignedTo);
    String selectedStatus = chore.status;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Chore'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    prefixIcon: Icon(Icons.cleaning_services),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: assignedController,
                  decoration: const InputDecoration(
                    labelText: 'Assigned To',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                  ),
                  items: const [
                    DropdownMenuItem(value: 'pending', child: Text('Pending')),
                    DropdownMenuItem(
                      value: 'in_progress',
                      child: Text('In Progress'),
                    ),
                    DropdownMenuItem(
                      value: 'completed',
                      child: Text('Completed'),
                    ),
                  ],
                  onChanged: (value) =>
                      setDialogState(() => selectedStatus = value ?? 'pending'),
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
                if (titleController.text.isNotEmpty) {
                  context.read<ChoreCubit>().updateChore(
                    chore.copyWith(
                      title: titleController.text,
                      description: descriptionController.text,
                      assignedTo: assignedController.text,
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

  void _deleteChore(BuildContext context, String choreId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Chore?'),
        content: const Text('Are you sure you want to delete this chore?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ChoreCubit>().deleteChore(choreId);
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

  void _addChore(
    BuildContext context,
    String title,
    String description,
    String assignedTo,
    String status,
  ) {
    // Get from auth context
    context.read<ChoreCubit>().addChore(
          title: title,
          description: description,
          assignedTo: assignedTo,
          assignedBy: 'current_user',
          familyId: 'current_family',
          status: status,
        );
  }

  void _refreshChores(BuildContext context) {
    // Refresh chores - will be implemented with auth context
  }

  IconData _getStatusIcon(String status) {
    if (status == 'pending') return Icons.pending;
    if (status == 'in_progress') return Icons.in_progress;
    return Icons.check_circle;
  }

  Color _getStatusColor(String status) {
    if (status == 'pending') return AppColors.chorePending;
    if (status == 'in_progress') return AppColors.choreInProgress;
    return AppColors.choreCompleted;
  }
}
