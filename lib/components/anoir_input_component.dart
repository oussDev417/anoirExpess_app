import 'package:anoirexpress/translations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../helpers/helpers.dart';
import '../style/colors.dart';

class AnoirInputComponent extends StatefulWidget {
  String? label;
  bool? isPassword;
  bool? isDescription;
  bool? isPhone;
  bool? isEmail;
  bool? isNumber;
  bool? isReadOnly;
  bool? isRequired;

  TextEditingController? controller;
  AnoirInputComponent({this.label = '',this.isPassword = false,
    this.isRequired =true,
    this.isDescription=false, this.isPhone = false,
    this.isEmail = false,
    this.isNumber = false,
    this.controller,this.isReadOnly=false});

  @override
  State<AnoirInputComponent> createState() => _AnoirInputComponentState();
}

class _AnoirInputComponentState extends State<AnoirInputComponent> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.isReadOnly!,
      textAlignVertical: TextAlignVertical.center,
        maxLines: widget.isDescription! ? 5 : 1,
        cursorColor: AppColors.primaryBlueColor,
        controller: widget.controller,
      keyboardType: widget.isPhone! ? TextInputType.phone : widget.isEmail! ? TextInputType.emailAddress : widget.isNumber! ? TextInputType.number : null,
      validator: (value){
        if(!widget.isRequired!){
          return null;
        }
        else{
          if(value!.trim().isEmpty){
            return AppTranslations.of(context)!.text('champsRequis');
          }
          else if(widget.isPhone!) {
            String phone = value!.trim();
            // Supprime le +229 pour vérifier les 8 chiffres
            if(phone.startsWith('+229')) {
              phone = phone.substring(4);
            }
            if(phone.length != 8 || !RegExp(r'^[0-9]+$').hasMatch(phone)) {
              return AppTranslations.of(context)!.text('champInvalide');
            }
          }

          else if(widget.isEmail! && !Helpers.isValidEmail(value.trim())){
            return AppTranslations.of(context)!.text('champInvalide');
          }
          else return null;
        }
      },
      textInputAction: TextInputAction.done,
      obscureText: widget.isPassword! ? !showPassword : false,
        decoration: InputDecoration(
          suffixIcon: widget.isPassword! ? GestureDetector(onTap : (){
            setState(() {
              showPassword = !showPassword;
            });
          },child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset(showPassword ? 'assets/svg/ic_eye_slash.svg' : 'assets/svg/ic_eye.svg',),
          )) : null,
          filled: true,
          label: widget.isDescription! ? null : Text(AppTranslations.of(context)!.text(widget.label ?? '')),
            hintText: widget.isDescription! ? AppTranslations.of(context)!.text('ajouterPlusDePrecisions') : null,
            hintStyle: TextStyle(color: AppColors.grey1Color),
            floatingLabelStyle: TextStyle(color: AppColors.grey1Color,),
          contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 8),
          fillColor: AppColors.grey2Color,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8)
         ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primaryBlueColor),
              borderRadius: BorderRadius.circular(8)
          )
        ),
    );
  }
}
