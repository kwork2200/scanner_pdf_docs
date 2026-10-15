import 'package:flutter/material.dart';
import 'package:scanner_pdf_docs/utils/functions.dart';
import 'package:scanner_pdf_docs/widgets/components/ads/interstitial_ad_manager.dart';

/// Wrapper widget that shows interstitial ads on back navigation
/// Handles both AppBar back button and system back button
/// 
/// Usage:
/// ```dart
/// AdOnBackWrapper(
///   child: YourScreen(),
/// )
/// ```
class AdOnBackWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? onBack;

  const AdOnBackWrapper({
    super.key,
    required this.child,
    this.onBack,
  });

  @override
  State<AdOnBackWrapper> createState() => _AdOnBackWrapperState();
}

class _AdOnBackWrapperState extends State<AdOnBackWrapper> {
  /// Handle back navigation with ad
  Future<bool> _handleBackNavigation() async {
    try {
      debugPrint('🔙 Back navigation triggered, showing ad...');
      
      final context = this.context;
      if (!context.mounted) return true;

      // Show ad on back using the manager's showAdOnBack method
      final shouldShowThirdParty = await InterstitialAdManager.instance.showAdOnBack();
      
      // If third-party ad should be shown
      if (shouldShowThirdParty && context.mounted) {
        debugPrint('🎯 Showing third-party ad on back navigation');
        await showManagedInterstitialAd(context, alwaysShow: true);
      }
      
      // Call custom onBack callback if provided
      widget.onBack?.call();
      
      debugPrint('✅ Back navigation ad flow completed');
      return true; // Allow navigation
    } catch (e) {
      debugPrint('❌ Error in back navigation ad: $e');
      return true; // Allow navigation even on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent immediate pop
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        
        // Show ad and then pop
        await _handleBackNavigation();
        
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: widget.child,
    );
  }
}

/// Helper function to show ad and then navigate back
/// Use this for custom back button onTap handlers
/// 
/// Example:
/// ```dart
/// leading: InkWell(
///   onTap: () => handleBackWithAd(context),
///   child: Icon(Icons.arrow_back),
/// )
/// ```
Future<void> handleBackWithAd(BuildContext context) async {
  try {
    debugPrint('🔙 Custom back button pressed, showing ad...');
    
    if (!context.mounted) return;

    // Show ad on back
    final shouldShowThirdParty = await InterstitialAdManager.instance.showAdOnBack();
    
    // If third-party ad should be shown
    if (shouldShowThirdParty && context.mounted) {
      debugPrint('🎯 Showing third-party ad on custom back');
      await showManagedInterstitialAd(context, alwaysShow: true);
    }
    
    // Navigate back after ad
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    
    debugPrint('✅ Custom back navigation completed');
  } catch (e) {
    debugPrint('❌ Error in custom back with ad: $e');
    // Navigate back even on error
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

/// Extension to easily wrap screens with ad-on-back functionality
extension AdOnBackExtension on Widget {
  /// Wraps this widget with AdOnBackWrapper
  Widget withAdOnBack({VoidCallback? onBack}) {
    return AdOnBackWrapper(
      onBack: onBack,
      child: this,
    );
  }
}
