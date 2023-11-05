import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum StackedCardCarouselType { cardsStack, fadeOutStack }

enum CardAlignment { start, center }

/// A widget that creates a vertical or horizontal carousel with stacked cards.
class StackedCardCarousel extends StatefulWidget {
  /// The items that should be scrolled through
  final List<Widget> items;

  /// The preferred animation behaviour
  final StackedCardCarouselType type;

  /// Initial vertical top offset for cards
  final double initialOffset;

  /// Space between the different cards
  final double spaceBetweenItems;

  /// If true, scales up space and position linear according to the
  /// text scale factor.
  final bool applyTextScaleFactor;

  final PageController? pageController;

  /// Callback that is executed whenever the selected card changes
  final Function(int pageIndex)? onPageChanged;

  /// Wether to display the carousel vertical or horizontal
  final Axis scrollDirection;

  /// `CardAlignment.start` locks the start of the stack,
  /// `CardAlignment.center` keeps the top card in the center.
  /// Only applies to StackedCardCarouselType.cardsStack.
  final CardAlignment cardAlignment;

  const StackedCardCarousel({
    Key? key,
    required this.items,
    this.type = StackedCardCarouselType.cardsStack,
    this.initialOffset = 40.0,
    this.spaceBetweenItems = 400,
    this.applyTextScaleFactor = true,
    this.pageController,
    this.onPageChanged,
    this.scrollDirection = Axis.vertical,
    this.cardAlignment = CardAlignment.start,
  }) : super(key: key);

  @override
  State<StackedCardCarousel> createState() => _StackedCardCarouselState();
}

class _StackedCardCarouselState extends State<StackedCardCarousel> {
  late final PageController pageController;
  double pageValue = 0;

  Widget stackedCards(BuildContext context) {
    double textScaleFactor = 1;
    final bool vertical = widget.scrollDirection == Axis.vertical;

    if (widget.applyTextScaleFactor) {
      final double mediaQueryFactor = MediaQuery.of(context).textScaleFactor;
      if (mediaQueryFactor > 1.0) {
        textScaleFactor = mediaQueryFactor;
      }
    }

    final List<Widget> positionedCards = widget.items.asMap().entries.map(
      (MapEntry<int, Widget> item) {
        double position = -widget.initialOffset;

        if (pageValue < item.key) {
          position += (pageValue - item.key) * widget.spaceBetweenItems * textScaleFactor;
        }

        switch (widget.type) {
          case StackedCardCarouselType.fadeOutStack:
            double opacity = 1;
            double scale = 1;
            if (item.key - pageValue < 0) {
              final double factor = 1 + (item.key - pageValue);
              opacity = factor < 0.0 ? 0.0 : pow(factor, 1.5).toDouble();
              scale = factor < 0.0 ? 0.0 : pow(factor, 0.1).toDouble();
            }
            return Positioned(
              top: vertical ? -position : null,
              left: vertical ? null : -position,
              child: Align(
                alignment: vertical ? Alignment.topCenter : Alignment.centerLeft,
                child: Wrap(
                  children: <Widget>[
                    Transform.scale(
                      scale: scale,
                      child: Opacity(
                        opacity: opacity,
                        child: item.value,
                      ),
                    ),
                  ],
                ),
              ),
            );
          case StackedCardCarouselType.cardsStack:
            double scale = 1;
            if (item.key < pageValue) {
              final double factor = 1 + (item.key - pageValue);
              scale = 0.95 + (factor * 0.1 / 2);
            }
            double shift = 20.0 * item.key;
            if (widget.cardAlignment == CardAlignment.center) {
              // Shift back cards based on depth
              shift = 20.0 * (item.key - pageValue);
            }
            return Positioned(
              top: vertical ? -position + shift : null,
              left: vertical ? null : -position + shift,
              child: Align(
                alignment: vertical ? Alignment.topCenter : Alignment.centerLeft,
                child: Wrap(
                  children: <Widget>[
                    Transform.scale(
                      scale: scale,
                      child: item.value,
                    ),
                  ],
                ),
              ),
            );
        }
      },
    ).toList();

    return Stack(alignment: Alignment.center, fit: StackFit.passthrough, children: positionedCards);
  }

  @override
  void initState() {
    super.initState();

    pageController = widget.pageController ?? PageController();
    pageController.addListener(() {
      if (mounted) setState(() => pageValue = pageController.page!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClickThroughStack(
      children: <Widget>[
        stackedCards(context),
        PageView.builder(
          scrollDirection: widget.scrollDirection,
          controller: pageController,
          itemCount: widget.items.length,
          onPageChanged: widget.onPageChanged,
          itemBuilder: (BuildContext context, int index) {
            return Container();
          },
        ),
      ],
    );
  }
}

/// To allow all gestures detections to go through
/// https://stackoverflow.com/questions/57466767/how-to-make-a-gesturedetector-capture-taps-inside-a-stack
class ClickThroughStack extends Stack {
  const ClickThroughStack({Key? key, required List<Widget> children}) : super(key: key, children: children);

  @override
  ClickThroughRenderStack createRenderObject(BuildContext context) {
    return ClickThroughRenderStack(
      alignment: alignment,
      textDirection: textDirection ?? Directionality.of(context),
      fit: fit,
    );
  }
}

class ClickThroughRenderStack extends RenderStack {
  ClickThroughRenderStack({
    required AlignmentGeometry alignment,
    TextDirection? textDirection,
    required StackFit fit,
  }) : super(
          alignment: alignment,
          textDirection: textDirection,
          fit: fit,
        );

  @override
  bool hitTestChildren(BoxHitTestResult result, {Offset? position}) {
    bool stackHit = false;

    final List<RenderBox> children = getChildrenAsList();

    for (final RenderBox child in children) {
      final StackParentData childParentData = child.parentData as StackParentData;

      final bool childHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position!,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - childParentData.offset, 'Assertion for stacked card carousel failed.');
          return child.hitTest(result, position: transformed);
        },
      );

      if (childHit) {
        stackHit = true;
      }
    }

    return stackHit;
  }
}
