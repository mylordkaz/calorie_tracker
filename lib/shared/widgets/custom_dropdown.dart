import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? labelText;
  final String? hintText;
  final String? Function(T?)? validator;
  final bool enabled;

  const CustomDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.labelText,
    this.hintText,
    this.validator,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44, // Same height as text fields
      child: FormField<T>(
        validator: validator,
        builder: (FormFieldState<T> field) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: enabled ? Colors.white : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: field.hasError ? Colors.red : Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<T>(
                      value: value,
                      isExpanded: true,
                      hint: hintText != null
                          ? Text(
                              hintText!,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                            )
                          : null,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      elevation: 8,
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      menuMaxHeight: 300,
                      items: items.map((DropdownItem<T> item) {
                        return DropdownMenuItem<T>(
                          value: item.value,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              item.text,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: enabled ? onChanged : null,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 0,
                      ),
                    ),
                  ),
                ),
              ),
              if (field.hasError) ...[
                SizedBox(height: 2),
                Text(
                  field.errorText!,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class DropdownItem<T> {
  final T value;
  final String text;

  const DropdownItem({required this.value, required this.text});
}
