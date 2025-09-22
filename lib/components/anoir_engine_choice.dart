import 'package:anoirexpress/controllers/CommandController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../style/colors.dart';
import '../style/style.dart';
import '../translations.dart';

class AnoirEngineChoice extends StatefulWidget {
  String engineType;
  int price;
  bool? canChoose;
   AnoirEngineChoice({required this.engineType,required this.price,this.canChoose=true});

  @override
  State<AnoirEngineChoice> createState() => _AnoirEngineChoiceState();
}

class _AnoirEngineChoiceState extends State<AnoirEngineChoice> {

  CommandController commandeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommandController>(
      builder: (commandController) {
        return Container(
          // color: Colors.white,
          height: 60,
          margin: EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset('assets/svg/engines/ic_${widget.engineType.toLowerCase()}.svg',height: widget.engineType == 'BUS' ? 42 : null,),
              Spacer(flex: 1,),
              Text(
                AppTranslations.of(context)!.text(widget.engineType.toLowerCase()),
                style: TextStyle(
                    fontFamily: AppStyle.secondaryFont,
                    fontSize: AppStyle.size16,
                    color: AppColors.black1Color,
                    fontWeight: FontWeight.w400,
                    height: 1.5),
              ),
              Spacer(flex: 3,),
              Text(
                '${widget.price} FCFA',
                style: TextStyle(
                    fontFamily: AppStyle.primaryFont,
                    fontSize: AppStyle.size14,
                    color: AppColors.primaryRedColor,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(width: widget.canChoose! ? 10 : 0,),
              !widget.canChoose! ? SizedBox() : SvgPicture.asset(commandController.engineChoice == widget.engineType ? 'assets/svg/ic_radio_checked.svg' : 'assets/svg/ic_radio_unchecked.svg')
            ],
          ),
        );
      }
    );
  }
}
