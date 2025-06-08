import 'package:flutter/material.dart';

class CategoryFilterDropdown extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  const CategoryFilterDropdown({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: 'Filter by Category',
          border: OutlineInputBorder(),
        ),
        value: selectedCategory,
        hint: const Text('Select Category'),
        isExpanded: true,
        items: categories.map((String category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(category),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
