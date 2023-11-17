import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  // On tap
  final void Function()? onTap;
  const CustomSearchBar({
    super.key,
    required this.hintText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      surfaceTintColor: MaterialStateProperty.all<Color>(
        Theme.of(context).colorScheme.background),
      hintText: hintText,
      onTap: onTap,
      onChanged: (value) {},
      elevation: const MaterialStatePropertyAll<double>(2.5),
      padding: const MaterialStatePropertyAll<EdgeInsets>(
        EdgeInsets.symmetric(horizontal: 16.0)),
      leading: const Icon(Icons.search),
    );
  }
}