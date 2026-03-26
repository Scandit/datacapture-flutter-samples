/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'package:flutter/material.dart';
import 'features/highlights/highlights_screen.dart';
import 'features/info_annotations/info_annotations_screen.dart';
import 'features/popovers/popovers_screen.dart';
import 'features/status_icons/status_icons_screen.dart';

enum BarcodeArFeature {
  highlights,
  infoAnnotations,
  popovers,
  statusIcons,
}

extension BarcodeArFeatureExtension on BarcodeArFeature {
  String get title {
    switch (this) {
      case BarcodeArFeature.highlights:
        return 'Highlights';
      case BarcodeArFeature.infoAnnotations:
        return 'Info Annotations';
      case BarcodeArFeature.popovers:
        return 'Popovers';
      case BarcodeArFeature.statusIcons:
        return 'Status icons';
    }
  }

  String get description {
    switch (this) {
      case BarcodeArFeature.highlights:
        return 'Visualize scanned codes';
      case BarcodeArFeature.infoAnnotations:
        return 'Show additional information';
      case BarcodeArFeature.popovers:
        return 'Take action on scanned codes';
      case BarcodeArFeature.statusIcons:
        return 'Provide short information';
    }
  }

  IconData get icon {
    switch (this) {
      case BarcodeArFeature.highlights:
        return Icons.qr_code_scanner;
      case BarcodeArFeature.infoAnnotations:
        return Icons.info_outline;
      case BarcodeArFeature.popovers:
        return Icons.markunread_mailbox_outlined;
      case BarcodeArFeature.statusIcons:
        return Icons.priority_high;
    }
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                _buildHeader(context),
                const SizedBox(height: 48),
                _buildFeaturesSection(context),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = 16.0 * 2; // Left and right padding
    final availableWidth = screenWidth - padding;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SCANDIT',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
            color: Color(0xFF077F8A),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: availableWidth,
          child: const Text('MatrixScan AR',
              softWrap: false,
              overflow: TextOverflow.clip,
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  color: Color(0xFF077F8A),
                  letterSpacing: 0.5)),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = 16.0 * 2; // Left and right padding
    final spacing = 16.0;
    final availableWidth = screenWidth - padding;
    final cardWidth = (availableWidth - spacing) / 2; // 2 cards per row

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Try These Features:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF16191C),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: BarcodeArFeature.values.map((feature) => _buildFeatureCard(context, feature, cardWidth)).toList(),
        ),
      ],
    );
  }

  Widget _buildFeatureCard(BuildContext context, BarcodeArFeature feature, double cardWidth) {
    return GestureDetector(
      onTap: () {
        Widget screen;
        switch (feature) {
          case BarcodeArFeature.highlights:
            screen = const HighlightsScreen();
            break;
          case BarcodeArFeature.infoAnnotations:
            screen = const InfoAnnotationsScreen();
            break;
          case BarcodeArFeature.popovers:
            screen = const PopoversScreen();
            break;
          case BarcodeArFeature.statusIcons:
            screen = const StatusIconsScreen();
            break;
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        width: cardWidth,
        height: cardWidth,
        decoration: BoxDecoration(
          color: const Color(0xFF16191C),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                feature.icon,
                size: 24,
                color: const Color(0xFF16191C),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.375,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feature.description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
