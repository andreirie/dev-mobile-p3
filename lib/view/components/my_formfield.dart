import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InfoCardSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const InfoCardSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            Divider(color: Colors.grey[300]),
            ...children,
          ],
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final void Function(String) onChanged;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool updateAppBar;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.updateAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 10.0,
        ),
      ),
      onChanged: (text) {
        onChanged(text);
      },
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
    );
  }
}

class DateTextFormField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final VoidCallback onTap;

  const DateTextFormField({
    super.key,
    required this.labelText,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      style: const TextStyle(fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 10.0,
        ),
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.brown),
      ),
      onTap: onTap,
    );
  }
}

class CustomDropdownFormField extends StatelessWidget {
  final String labelText;
  final List<String> options;
  final String? currentValue;
  final void Function(String?) onChanged;

  const CustomDropdownFormField({
    super.key,
    required this.labelText,
    required this.options,
    required this.currentValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    String? valueToUse = options.contains(currentValue) ? currentValue : null;

    List<DropdownMenuItem<String>> dropdownItems = options.map((String option) {
      return DropdownMenuItem<String>(value: option, child: Text(option));
    }).toList();

    dropdownItems.insert(
      0,
      const DropdownMenuItem<String>(value: null, child: Text("-")),
    );

    valueToUse = currentValue == null || !options.contains(currentValue)
        ? null
        : currentValue;

    return DropdownButtonFormField<String>(
      value: valueToUse,
      dropdownColor: Colors.brown[50],
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 10.0,
        ),
      ),
      hint: const Text("Selecione"),
      items: dropdownItems,
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Obrigatório!';
        }
        return null;
      },
    );
  }
}
