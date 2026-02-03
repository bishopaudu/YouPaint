import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/saved_drawing_model.dart';
import '../viewmodel/gallery_viewmodel.dart';
import '../utils/app_colors.dart';
import '../services/share_service.dart';
import 'drawing_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ShareService _shareService = ShareService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GalleryViewmodel>().loadDrawings();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              _buildAppBar(context),

              // Search Bar
              _buildSearchBar(context),

              // Gallery Grid
              Expanded(
                child: Consumer<GalleryViewmodel>(
                  builder: (context, viewmodel, child) {
                    if (viewmodel.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.textLight,
                        ),
                      );
                    }

                    if (!viewmodel.hasDrawings) {
                      return _buildEmptyState(context);
                    }

                    if (viewmodel.drawings.isEmpty &&
                        viewmodel.searchQuery.isNotEmpty) {
                      return _buildNoResultsState(context);
                    }

                    return RefreshIndicator(
                      onRefresh: () => viewmodel.refreshDrawings(),
                      color: AppColors.primaryPurple,
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                        itemCount: viewmodel.drawings.length,
                        itemBuilder: (context, index) {
                          return _buildGalleryItem(
                            context,
                            viewmodel.drawings[index],
                            viewmodel,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DrawingScreen()),
          );
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Drawing'),
        backgroundColor: AppColors.accentPink,
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.textLight,
          ),
          const SizedBox(width: 8),
          Text(
            'My Gallery',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.textLight.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: AppColors.textLight),
          decoration: InputDecoration(
            hintText: 'Search drawings...',
            hintStyle: TextStyle(color: AppColors.textLight.withOpacity(0.6)),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.textLight,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.clear_rounded,
                      color: AppColors.textLight,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      context.read<GalleryViewmodel>().clearSearch();
                      setState(() {});
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          onChanged: (value) {
            context.read<GalleryViewmodel>().searchDrawings(value);
            setState(() {});
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 100,
            color: AppColors.textLight.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'No drawings yet',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(color: AppColors.textLight),
          ),
          const SizedBox(height: 12),
          Text(
            'Create your first masterpiece!',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textLight.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 100,
            color: AppColors.textLight.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'No results found',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(color: AppColors.textLight),
          ),
          const SizedBox(height: 12),
          Text(
            'Try a different search term',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textLight.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryItem(
    BuildContext context,
    SavedDrawingModel drawing,
    GalleryViewmodel viewmodel,
  ) {
    final dateFormat = DateFormat('MMM d, y');

    return GestureDetector(
      onTap: () {
        // TODO: Open drawing in DrawingScreen
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => DrawingScreen(savedDrawing: drawing),
        //   ),
        // );
      },
      onLongPress: () {
        _showDrawingOptions(context, drawing, viewmodel);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.textLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thumbnail
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.file(
                  File(drawing.thumbnailPath),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.backgroundLight,
                      child: const Icon(
                        Icons.broken_image_rounded,
                        size: 48,
                        color: AppColors.textSecondary,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Title and Date
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    drawing.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateFormat.format(drawing.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDrawingOptions(
    BuildContext context,
    SavedDrawingModel drawing,
    GalleryViewmodel viewmodel,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.edit_rounded,
                  color: AppColors.primaryPurple,
                ),
                title: const Text('Open'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Open drawing
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.share_rounded,
                  color: AppColors.accentGreen,
                ),
                title: const Text('Share'),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    await _shareService.shareImage(
                      imageFile: File(drawing.filePath),
                      title: drawing.title,
                    );
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to share: $e')),
                      );
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete_rounded,
                  color: AppColors.accentOrange,
                ),
                title: const Text('Delete'),
                onTap: () async {
                  Navigator.pop(context);
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Drawing'),
                      content: const Text(
                        'Are you sure you want to delete this drawing?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true && drawing.id != null) {
                    try {
                      await viewmodel.deleteDrawing(drawing.id!);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Drawing deleted')),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to delete: $e')),
                        );
                      }
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
