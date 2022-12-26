import 'package:auto_forward_sms/core/constant/color_constant.dart';
import 'package:auto_forward_sms/core/constant/text_style_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

customTextField(
    {required String hintText,
    required String labelText,
    String? suffixIcon,
    FormFieldValidator? validator,
    bool obscure = false,
    double? maxWidth,
    List<TextInputFormatter>? inputFormatters,
    TextInputType? keyboardType,
    Widget? countryPrefix,
    required TextEditingController controller}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(labelText),
      const SizedBox(height: 9),
      Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: ColorConstant.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
              spreadRadius: 1)
        ], color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: TextFormField(
          inputFormatters: inputFormatters,
          obscureText: obscure ? true : false,
          validator: validator,
          keyboardType: keyboardType ?? TextInputType.text,
          style: TextStyleConstant.skipStyle
              .merge(TextStyle(color: ColorConstant.black22)),
          showCursor: true,
          controller: controller,
          cursorColor: ColorConstant.orange,
          textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(
            prefixIconConstraints:
                BoxConstraints(maxWidth: maxWidth ?? 43, maxHeight: 42),
            suffixIconConstraints:
                const BoxConstraints(maxWidth: 45, maxHeight: 45),
            prefixIcon: countryPrefix == null
                ?
                /*      ? Container(
                    margin: const EdgeInsets.only(left: 15, right: 10),
                    child: Image.asset(prefixIcon))
                :*/
                const SizedBox(width: 15)
                : countryPrefix,
            suffixIcon: suffixIcon != null
                ? Container(
                    margin: const EdgeInsets.only(right: 15, left: 10),
                    child: Image.asset(suffixIcon))
                : const SizedBox(),
            hintText: hintText,
            hintStyle: TextStyleConstant.descStyle,
            border: InputBorder.none,
          ),
        ),
      ),
    ],
  );
}
