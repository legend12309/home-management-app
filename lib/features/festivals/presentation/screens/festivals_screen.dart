import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/festival_model.dart';
import '../cubit/festival_cubit.dart';
import '../cubit/festival_state.dart';

class FestivalsScreen extends StatelessWidget {
  const FestivalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.festivals),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddFestivalDialog(context),
          ),
        ],
      ),
      body: BlocBuilder<FestivalCubit, FestivalState>(
        builder: (context, state) {
          if (state is FestivalLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FestivalError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(state.message, style: const TextStyle(color: AppColors.error)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _refreshFestivals(context),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is FestivalLoaded) {
            final allFestivals = [...state.upcomingFestivals, ...state.familyFestivals]
              ..sort((a, b) => a.date.compareTo(b.date));

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Quick Stats
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Icon(Icons.event, size: 32, color: AppColors.primary),
                              const SizedBox(height: 8),
                              Text(
                                '${state.familyFestivals.length}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text('This Month'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.upcoming,
                                size: 32,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${state.upcomingFestivals.length}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text('Upcoming'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Upcoming Festivals
                Text(
                  'Upcoming Festivals',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                if (allFestivals.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: const [
                          Icon(Icons.celebration, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No upcoming festivals',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...allFestivals.map((festival) => _buildFestivalCard(context, festival)),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildFestivalCard(BuildContext context, Festival festival) {
    final daysUntil = festival.date.difference(DateTime.now()).inDays;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.accent.withOpacity(0.1),
          child: const Icon(Icons.celebration, color: AppColors.accent),
        ),
        title: Text(
          festival.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_formatDate(festival.date)),
            if (daysUntil >= 0) Text('in $daysUntil days', style: const TextStyle(fontSize: 12)),
            Text(festival.description, style: const TextStyle(fontSize: 12)),
          ],
        ),
        trailing: festival.familyId != null
            ? IconButton(
                icon: const Icon(Icons.delete, color: AppColors.error),
                onPressed: () => _deleteFestival(context, festival.id!),
              )
            : const Icon(Icons.chevron_right),
        onTap: () {
          _showFestivalDetails(context, festival);
        },
      ),
    );
  }

  void _showFestivalDetails(BuildContext context, Festival festival) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(festival.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${_formatDate(festival.date)}'),
            const SizedBox(height: 8),
            Text('Type: ${festival.type}'),
            const SizedBox(height: 8),
            Text('Region: ${festival.region}'),
            const SizedBox(height: 8),
            Text(festival.description),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAddFestivalDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final regionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Custom Festival'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Festival Name',
                  prefixIcon: Icon(Icons.celebration),
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
                controller: regionController,
                decoration: const InputDecoration(
                  labelText: 'Region',
                  prefixIcon: Icon(Icons.location_on),
                ),
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
                  descriptionController.text.isNotEmpty) {
                _addFestival(
                  context,
                  nameController.text,
                  descriptionController.text,
                  regionController.text,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addFestival(
    BuildContext context,
    String name,
    String description,
    String region,
  ) {
    // Get from auth context
    context.read<FestivalCubit>().addFamilyFestival(
          name: name,
          date: DateTime.now().add(const Duration(days: 30)),
          description: description,
          region: region,
          familyId: 'current_family',
        );
  }

  void _deleteFestival(BuildContext context, String festivalId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Festival?'),
        content: const Text('Are you sure you want to delete this festival?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<FestivalCubit>().deleteFamilyFestival(festivalId);
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

  void _refreshFestivals(BuildContext context) {
    // Refresh festivals - will be implemented with auth context
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
