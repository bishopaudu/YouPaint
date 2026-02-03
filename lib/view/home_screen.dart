import 'package:flutter/material.dart';
import 'package:youpaint/utils/app_colors.dart';
import 'drawing_screen.dart';
import 'gallery_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App Logo/Title
                const Spacer(),
                Hero(
                  tag: 'app_logo',
                  child: Icon(
                    Icons.brush_rounded,
                    size: 100,
                    color: AppColors.textLight.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'YouPaint',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.textLight,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Create beautiful drawings',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.textLight.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),

                // New Drawing Button
                _buildActionButton(
                  context,
                  icon: Icons.add_circle_outline_rounded,
                  label: 'New Drawing',
                  gradient: AppColors.accentGradient,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DrawingScreen()),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // My Gallery Button
                _buildActionButton(
                  context,
                  icon: Icons.photo_library_rounded,
                  label: 'My Gallery',
                  gradient: AppColors.coolGradient,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GalleryScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: AppColors.textLight),
            const SizedBox(width: 16),
            Text(
              label,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.textLight,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
