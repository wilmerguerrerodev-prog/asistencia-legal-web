import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/styles.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final String? title;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final bool? isPassword;
  final bool? isShowBorder;
  final bool? isAutoFocus;
  final Function(String)? onSubmit;
  final bool? isEnabled;
  final int? maxLines;
  final bool? isShowSuffixIcon;
  final TextCapitalization? capitalization;
  final Function(String text)? onChanged;
  final String? countryDialCode;
  final Widget? suffixIcon;
  final Function(CountryCode countryCode)? onCountryChanged;
  final Widget? prefixIcon;
  final double? borderRadius;
  final Color? fillColor;
  final String? Function(String? )? onValidate;
  final String? Function(String? )? onSaved;

  const  CustomTextField(
      {super.key, this.hintText = '',
        this.controller,
        this.focusNode,
        this.nextFocus,
        this.isEnabled = true,
        this.inputType = TextInputType.text,
        this.inputAction = TextInputAction.next,
        this.maxLines = 1,
        this.isShowSuffixIcon = false,
        this.onSubmit,
        this.capitalization = TextCapitalization.none,
        this.isPassword = false,
        this.isShowBorder = false,
        this.isAutoFocus = false,
        this.countryDialCode,
        this.onCountryChanged,
        this.suffixIcon,
        this.onChanged,
        this.onValidate,
        this.onSaved,
        this.prefixIcon,
        this.borderRadius = Dimensions.radiusSmall,
        this.fillColor,
        this.title,
      });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06),),
          borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeExtraSmall))
      ),
      child: TextFormField(
        maxLines: widget.maxLines,
        controller: widget.controller,
        onSaved: widget.onSaved,
        focusNode: widget.focusNode,
        style: ubuntuRegular.copyWith(fontSize:Dimensions.fontSizeDefault,color: widget.isEnabled==false?Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.6):Theme.of(context).textTheme.bodyLarge!.color),
        textInputAction: widget.inputAction,
        keyboardType: widget.inputType,
        cursorColor: Theme.of(context).hintColor,
        textCapitalization: widget.capitalization!,
        enabled: widget.isEnabled,
        autofocus: widget.isAutoFocus!,
        autofillHints: widget.inputType == TextInputType.name ? [AutofillHints.name]
            : widget.inputType == TextInputType.emailAddress ? [AutofillHints.email]
            : widget.inputType == TextInputType.phone ? [AutofillHints.telephoneNumber]
            : widget.inputType == TextInputType.streetAddress ? [AutofillHints.fullStreetAddress]
            : widget.inputType == TextInputType.url ? [AutofillHints.url]
            : widget.inputType == TextInputType.visiblePassword ? [AutofillHints.password] : null,
        obscureText: widget.isPassword! ? _obscureText : false,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius!),
            borderSide: const BorderSide(style: BorderStyle.none, width: 0),
          ),
          isDense: true,
          filled: true,
          fillColor: widget.fillColor?? Theme.of(context).cardColor,
          contentPadding: const EdgeInsets.all( Dimensions.paddingSizeLarge,),
          hintText: widget.hintText,
          hintStyle: ubuntuRegular.copyWith(
            fontSize: Dimensions.fontSizeLarge,
            color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5),
          ),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.isPassword! ?
          IconButton(
            splashRadius: 20,
            icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Theme.of(context).hintColor.withOpacity(0.3)),
            onPressed: _toggle,
          ) : widget.suffixIcon,
        ),
        onFieldSubmitted: (text) => widget.nextFocus != null ?
        FocusScope.of(context).requestFocus(widget.nextFocus) :
        widget.onSubmit != null ? widget.onSubmit!(text) : null,
        onChanged: widget.onChanged,
        validator: widget.onValidate,
      ),
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}