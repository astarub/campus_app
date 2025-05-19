import 'package:flutter/material.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isSearching;
  final VoidCallback onStopSearch;
  final ValueChanged<String> onSearchChanged;
  final TextEditingController searchController;
  final VoidCallback onStartSearch;

  const SearchAppBar({
    super.key,
    required this.isSearching,
    required this.onStartSearch,
    required this.onStopSearch,
    required this.onSearchChanged,
    required this.searchController,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: widget.isSearching
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: widget.onStopSearch,
            )
          : null,
      title: widget.isSearching
          ? TextField(
              controller: widget.searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search emails...',
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    widget.searchController.clear();
                    widget.onSearchChanged('');
                  },
                ),
              ),
              onChanged: widget.onSearchChanged,
            )
          : const Text('RubMail'),
      actions: [
        if (!widget.isSearching) ...[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: widget.onStartSearch, // Triggers search mode
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
        ],
      ],
    );
  }
}
