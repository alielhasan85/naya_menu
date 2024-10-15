//in this page we will upload the design paramter of the venue like logo (upload image and save url in firestore), text color, font style,
//it is part of

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naya_menu/client_app/venue_management/cl_color.dart';
import 'package:naya_menu/client_app/venue_management/cl_image_picker_card.dart';
import 'package:naya_menu/service/firebase/firebase_storage_service.dart';
import 'package:naya_menu/client_app/notifier.dart';
import 'package:naya_menu/service/firebase/firestore_venue.dart';
import 'package:naya_menu/theme/app_theme.dart';
import 'package:image_cropper/image_cropper.dart';

class DesignTab extends ConsumerWidget {
  const DesignTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venue = ref.watch(venueProvider);
    final Map<String, dynamic> designAndDisplay = venue?.designAndDisplay ?? {};

    final String? logoUrl = designAndDisplay['logoUrl'];
    final String? backgroundUrl = designAndDisplay['backgroundUrl'];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customize your brand look',
              style: AppTheme.display1
                  .copyWith(fontSize: 24, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your brand\'s colors to personalize your product. Choose text, background, and highlight colors to match your identity!',
              style: AppTheme.body2
                  .copyWith(fontSize: 12, color: AppTheme.lightText),
            ),
            const SizedBox(height: 16),
            const ColorPaletteWidget(), // Color palette widget
            const SizedBox(height: 40),
            // Logo Upload Section
            ImageUploadCard(
              title: 'Upload Venue Logo',
              subtitle: 'Image should be less than 15 MB',
              imageUrl: logoUrl,
              imageKey: 'logoUrl',
              aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
              imageName: 'VenueLogo',
            ),
            const SizedBox(height: 40),
            // Background Image Upload Section
            ImageUploadCard(
              title: 'Upload Background Image',
              subtitle: 'Image should be less than 15 MB',
              imageUrl: backgroundUrl,
              imageKey: 'backgroundUrl',
              aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
              imageName: 'BackgroundImage',
            ),
          ],
        ),
      ),
    );
  }
}
