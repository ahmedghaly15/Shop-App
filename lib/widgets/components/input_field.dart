import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hint;
  final bool? obsecure;
  final Widget? icon;
  final TextEditingController controller;
  final String? Function(String?)? validating;
  final TextInputType keyboardType;
  final Function(String?)? saving;
  final void Function(String)? onSubmit;

  const InputField({
    Key? key,
    required this.hint,
    required this.controller,
    this.obsecure,
    this.icon,
    required this.validating,
    required this.keyboardType,
    this.onSubmit,
    this.saving,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Colors.black45,
            ),
        suffixIcon: icon,
        suffixIconColor: Theme.of(context).primaryColor,
        contentPadding: const EdgeInsets.all(10),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 0,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      cursorColor: Colors.grey[700],
      style: Theme.of(context).textTheme.bodyMedium,
      obscureText: obsecure!,
      keyboardType: keyboardType,
      validator: validating,
      onFieldSubmitted: onSubmit,
      onSaved: saving,
    );
  }
}
