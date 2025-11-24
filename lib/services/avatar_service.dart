import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Service to handle avatar image selection and management
class AvatarService {
  static final ImagePicker _picker = ImagePicker();

  /// Show bottom sheet to choose between camera or gallery
  static Future<String?> showAvatarPickerSheet(BuildContext context) async {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1a1f3a).withOpacity(0.95),
              const Color(0xFF0f1425).withOpacity(0.95),
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose Avatar Photo',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select a photo from your gallery or take a new one',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 24),
                _buildOptionButton(
                  context: context,
                  icon: Icons.camera_alt_rounded,
                  title: 'Take Photo',
                  subtitle: 'Use camera to take a new photo',
                  onTap: () async {
                    final imagePath = await pickImageFromCamera();
                    if (context.mounted) {
                      Navigator.pop(context, imagePath);
                    }
                  },
                ),
                const SizedBox(height: 12),
                _buildOptionButton(
                  context: context,
                  icon: Icons.photo_library_rounded,
                  title: 'Choose from Gallery',
                  subtitle: 'Select an existing photo',
                  onTap: () async {
                    final imagePath = await pickImageFromGallery();
                    if (context.mounted) {
                      Navigator.pop(context, imagePath);
                    }
                  },
                ),
                const SizedBox(height: 12),
                _buildOptionButton(
                  context: context,
                  icon: Icons.delete_outline_rounded,
                  title: 'Remove Photo',
                  subtitle: 'Use default avatar',
                  isDestructive: true,
                  onTap: () {
                    Navigator.pop(context, ''); // Empty string to remove avatar
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildOptionButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.05),
              Colors.white.withOpacity(0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: isDestructive
                    ? LinearGradient(
                        colors: [
                          Colors.red.withOpacity(0.2),
                          Colors.red.withOpacity(0.1),
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          const Color(0xFF667EEA).withOpacity(0.2),
                          const Color(0xFF764BA2).withOpacity(0.2),
                        ],
                      ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red : const Color(0xFF667EEA),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDestructive ? Colors.red : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }

  /// Pick image from camera with permission handling
  static Future<String?> pickImageFromCamera() async {
    try {
      // image_picker handles permissions automatically on iOS
      // Just try to pick the image
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        return await _saveImagePermanently(image);
      }
    } catch (e) {
      debugPrint('Error picking image from camera: $e');
    }
    return null;
  }

  /// Pick image from gallery with permission handling
  static Future<String?> pickImageFromGallery() async {
    try {
      // image_picker handles permissions automatically on iOS
      // Just try to pick the image
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        return await _saveImagePermanently(image);
      }
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
    }
    return null;
  }

  /// Save the picked image to app's documents directory permanently
  static Future<String?> _saveImagePermanently(XFile image) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String avatarsDir = path.join(appDir.path, 'avatars');
      
      // Create avatars directory if it doesn't exist
      await Directory(avatarsDir).create(recursive: true);
      
      // Generate unique filename
      final String fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}${path.extension(image.path)}';
      final String savedPath = path.join(avatarsDir, fileName);
      
      // Copy the file to permanent location
      await File(image.path).copy(savedPath);
      
      debugPrint('✅ Avatar saved to: $savedPath');
      debugPrint('📁 File exists: ${await File(savedPath).exists()}');
      
      return savedPath;
    } catch (e) {
      debugPrint('❌ Error saving image: $e');
      return null;
    }
  }

  /// Delete old avatar file if it exists
  static Future<void> deleteOldAvatar(String? oldAvatarPath) async {
    if (oldAvatarPath != null && oldAvatarPath.isNotEmpty) {
      try {
        final file = File(oldAvatarPath);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        debugPrint('Error deleting old avatar: $e');
      }
    }
  }
}
