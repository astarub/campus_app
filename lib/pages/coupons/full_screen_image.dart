import 'package:flutter/material.dart';

class FullScreenImage extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullScreenImage({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set black background for the gallery view
      backgroundColor: Colors.black,

      // App bar with transparent background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // Title showing current image index (e.g., "2/5")
        title: Text(
          '${_currentIndex + 1}/${widget.imageUrls.length}',
          style: const TextStyle(color: Colors.white),
        ),
        // Back button in the app bar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // Main content area with PageView
      body: PageView.builder(
        // Controller for managing page transitions
        controller: _pageController,
        // Total number of images
        itemCount: widget.imageUrls.length,
        // Callback when page changes
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index; // Update current index
          });
        },
        // Builder for each page item
        itemBuilder: (context, index) {
          return InteractiveViewer(
            // Zoom configuration
            minScale: 0.5,
            maxScale: 4,
            child: Center(
              child: AspectRatio(
                // Maintain consistent aspect ratio for all images
                aspectRatio: 18 / 12,
                child: Image.network(
                  // Image URL from the list
                  widget.imageUrls[index],
                  // How the image should fill the space
                  fit: BoxFit.cover,
                  // Loading state builder
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    // Show progress indicator while loading
                    return Center(
                      child: CircularProgressIndicator(
                        // Calculate progress percentage if total bytes are known
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null, // Indeterminate if total bytes unknown
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, size: 50),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
