import 'package:flutter/material.dart';

/// A simple Navigation Bar for Email Pages.
/// The widget itself is very high level and knows nothing of the mailbox it is used in or Email state.
///
/// Displays a navigation bar like this  ex. << < 1 / 20 > >>
class EmailPageNavigation extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final bool isLoading;
  final void Function() onPrevious;
  final void Function() onNext;
  final void Function() onFirst;
  final void Function() onLast;

  const EmailPageNavigation({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.isLoading,
    required this.onPrevious,
    required this.onNext,
    required this.onFirst,
    required this.onLast,
  });

  @override
  Widget build(BuildContext context) {
    final isFirstPage = currentPage <= 1;
    final isLastPage = currentPage >= totalPages;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // navigate to first page
        IconButton(
          icon: const Icon(Icons.keyboard_double_arrow_left),
          onPressed: isLoading || isFirstPage ? null : onFirst,
        ),

        // navivgate to Previous page
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: isLoading || isFirstPage ? null : onFirst,
        ),

        // Display Page count
        Padding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 15),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  '$currentPage / $totalPages',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
        ),

        // navigate to next Page
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_right),
          onPressed: isLoading || isLastPage ? null : onNext,
        ),

        // navigate to the last Page
        IconButton(
          icon: const Icon(Icons.keyboard_double_arrow_right),
          onPressed: isLoading || isLastPage ? null : onLast,
        ),
      ],
    );
  }
}
