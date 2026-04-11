import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../products/domain/product.dart';
import '../../../products/data/category_repository.dart';

class ProductFormDialog extends ConsumerStatefulWidget {
  final Product? product;
  final Function(Product) onSave;

  const ProductFormDialog({super.key, this.product, required this.onSave});

  @override
  ConsumerState<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends ConsumerState<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _priceController;
  late final TextEditingController _costController;
  late String _selectedCategory;
  late bool _isAvailable;

  // Image
  String _imageData = ''; // base64 or URL
  Uint8List? _imageBytes; // for preview
  final ImagePicker _picker = ImagePicker();

  bool get isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.product?.title ?? '');
    _priceController = TextEditingController(
        text: widget.product?.price.toStringAsFixed(2) ?? '');
    _costController = TextEditingController(
        text: widget.product?.cost.toStringAsFixed(2) ?? '');
    _isAvailable = widget.product?.isAvailable ?? true;

    // Resolve category: use customCategory if set, otherwise map from enum
    if (widget.product != null) {
      if (widget.product!.customCategory.isNotEmpty) {
        _selectedCategory = widget.product!.customCategory;
      } else {
        _selectedCategory = _enumToLabel(widget.product!.category);
      }
    } else {
      _selectedCategory = 'Ice Cream';
    }

    // Load existing image
    final existingImage = widget.product?.imageUrl ?? '';
    if (existingImage.isNotEmpty) {
      _imageData = existingImage;
      if (existingImage.startsWith('data:') ||
          existingImage.length > 200) {
        // It's base64 data
        try {
          final raw = existingImage.contains(',')
              ? existingImage.split(',').last
              : existingImage;
          _imageBytes = base64Decode(raw);
        } catch (_) {}
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _costController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (image == null) return;

      final bytes = await image.readAsBytes();
      final base64String = base64Encode(bytes);

      setState(() {
        _imageBytes = bytes;
        _imageData = 'data:image/jpeg;base64,$base64String';
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Could not pick image: $e'),
              behavior: SnackBarBehavior.floating),
        );
      }
    }
  }

  void _removeImage() {
    setState(() {
      _imageBytes = null;
      _imageData = '';
    });
  }

  ProductCategory _labelToEnum(String label) {
    switch (label.toLowerCase()) {
      case 'ice cream':
        return ProductCategory.iceCream;
      case 'vessel':
        return ProductCategory.vessel;
      case 'topping':
        return ProductCategory.topping;
      case 'drink':
        return ProductCategory.drink;
      default:
        return ProductCategory.other;
    }
  }

  String _enumToLabel(ProductCategory c) {
    switch (c) {
      case ProductCategory.iceCream:
        return 'Ice Cream';
      case ProductCategory.vessel:
        return 'Vessel';
      case ProductCategory.topping:
        return 'Topping';
      case ProductCategory.drink:
        return 'Drink';
      case ProductCategory.other:
        return 'Other';
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: widget.product?.id ?? const Uuid().v4(),
        title: _titleController.text.trim(),
        price: double.parse(_priceController.text),
        cost: double.parse(_costController.text),
        category: _labelToEnum(_selectedCategory),
        customCategory: _selectedCategory,
        imageUrl: _imageData,
        isAvailable: _isAvailable,
      );
      widget.onSave(product);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoryRepositoryProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Ensure the selected category is in the list
    if (!categories.contains(_selectedCategory) && categories.isNotEmpty) {
      // Keep it if it's a valid category from an existing product
      // Otherwise default to first
      if (!isEditing) {
        _selectedCategory = categories.first;
      }
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: colorScheme.surface,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Header ──
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isEditing
                              ? Icons.edit_rounded
                              : Icons.add_business_rounded,
                          color: colorScheme.onPrimaryContainer,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEditing ? 'Edit Product' : 'New Product',
                              style: textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              isEditing
                                  ? 'Update product details'
                                  : 'Add a new item to your catalog',
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Image Picker Area ──
                  _buildImageSection(colorScheme),
                  const SizedBox(height: 20),

                  // ── Product Name ──
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Product Name',
                      hintText: 'e.g. Vanilla Bean',
                      prefixIcon: const Icon(Icons.label_outline_rounded),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            BorderSide(color: colorScheme.primary, width: 2),
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),

                  // ── Price & Cost ──
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _priceController,
                          decoration: InputDecoration(
                            labelText: 'Sell Price',
                            prefixIcon: const Icon(Icons.payments_outlined),
                            filled: true,
                            fillColor: colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.4),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color: colorScheme.primary, width: 2),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            if (double.tryParse(v) == null) {
                              return 'Invalid';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _costController,
                          decoration: InputDecoration(
                            labelText: 'Cost',
                            prefixIcon:
                                const Icon(Icons.account_balance_wallet_outlined),
                            filled: true,
                            fillColor: colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.4),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                  color: colorScheme.primary, width: 2),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            if (double.tryParse(v) == null) {
                              return 'Invalid';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Category Chips ──
                  Text('Category',
                      style: textTheme.labelLarge
                          ?.copyWith(color: Colors.grey.shade700)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: categories.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (_) =>
                            setState(() => _selectedCategory = cat),
                        selectedColor: colorScheme.primaryContainer,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSurface,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        checkmarkColor: colorScheme.onPrimaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected
                                ? colorScheme.primary.withValues(alpha: 0.3)
                                : Colors.grey.shade300,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // ── Availability Toggle ──
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SwitchListTile(
                      title: const Text('Available for Sale',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: Text(
                        _isAvailable
                            ? 'Visible on POS screen'
                            : 'Hidden from POS screen',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                      value: _isAvailable,
                      onChanged: (v) => setState(() => _isAvailable = v),
                      activeThumbColor: colorScheme.primary,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Actions ──
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: FilledButton.icon(
                          onPressed: _submit,
                          icon: Icon(isEditing
                              ? Icons.check_rounded
                              : Icons.add_rounded),
                          label: Text(isEditing ? 'Update' : 'Create'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        children: [
          // Image Preview / Placeholder
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
            child: SizedBox(
              height: 140,
              width: double.infinity,
              child: _imageBytes != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.memory(
                          _imageBytes!,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton.filled(
                            onPressed: _removeImage,
                            icon: const Icon(Icons.close_rounded, size: 18),
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  Colors.black.withValues(alpha: 0.5),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(32, 32),
                              padding: const EdgeInsets.all(4),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      color: colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_outlined,
                              size: 40,
                              color: Colors.grey.shade400),
                          const SizedBox(height: 4),
                          Text('No image attached',
                              style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 13)),
                        ],
                      ),
                    ),
            ),
          ),
          // Pick Button
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo_library_outlined, size: 18),
                label: Text(
                    _imageBytes != null ? 'Change Image' : 'Pick Image'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
