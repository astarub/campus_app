import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

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

// A full-screen image gallery widget that allows users to view and zoom images
// Ein Vollbild-Bildergalerie-Widget, das es Benutzern ermöglicht, Bilder anzuzeigen und zu zoomen
class _FullScreenImageState extends State<FullScreenImage> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '${_currentIndex + 1}/${widget.imageUrls.length}',
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: PhotoViewGallery.builder(
        pageController: _pageController,
        itemCount: widget.imageUrls.length,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(widget.imageUrls[index]),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 4,
            initialScale: PhotoViewComputedScale.contained,
            heroAttributes: PhotoViewHeroAttributes(tag: widget.imageUrls[index]),
            tightMode: false,
            gestureDetectorBehavior: HitTestBehavior.opaque,
            controller: PhotoViewController()..outputStateStream.listen((state) {}),
            scaleStateCycle: (state) {
              return state == PhotoViewScaleState.zoomedIn ? PhotoViewScaleState.initial : PhotoViewScaleState.zoomedIn;
            },
          );
        },
        // Show loading indicator while images are being downloaded
        // Zeige Ladeindikator während Bilder heruntergeladen werden
        loadingBuilder: (context, event) => Center(
          child: SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
            ),
          ),
        ),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
