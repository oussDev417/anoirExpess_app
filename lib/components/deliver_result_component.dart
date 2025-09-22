import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/course.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import '../style/colors.dart';
import '../style/style.dart';
import '../translations.dart';

class DeliverResultComponent extends StatefulWidget {
  Course course;
  DeliverResultComponent({required this.course});

  @override
  State<DeliverResultComponent> createState() => _DeliverResultComponentState();
}

class _DeliverResultComponentState extends State<DeliverResultComponent> {
  UserService userService = UserService();
  User? deliver;
  getDeliver() async {
    User? u = await userService.getUserById(widget.course.deliverId!);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        deliver = u;
      });
    });
  }

  @override
  void initState() {
    if(widget.course.deliverId != null){
      getDeliver();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return      Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8)),
              border: Border(
                  left: BorderSide(color: AppColors.grey4Color),
                  top: BorderSide(color: AppColors.grey4Color),
                  right: BorderSide(color: AppColors.grey4Color))),
          child: ListTile(
            horizontalTitleGap: 15,
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/png/img_profile.png'),
              radius: 20,
            ),
            title: deliver == null ? Container(height : 30,width:30,child: CupertinoActivityIndicator()) : Text(
               deliver!.firstname + ' ' + deliver!.lastname,
              style: TextStyle(
                  fontFamily: AppStyle.secondaryFont,
                  fontSize: AppStyle.size16,
                  fontWeight: FontWeight.w400),
            ),
            trailing: deliver == null ? SizedBox() : IconButton(
              icon: SvgPicture.asset('assets/svg/ic_call.svg'),
              onPressed: () {
                try{
                  if(deliver != null){
                    launchUrl(Uri.parse('tel://${deliver!.phone}'));
                  }
                }
                catch(e){

                }
              },
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
              border: Border(
                  top: BorderSide(color: AppColors.grey4Color),
                  left: BorderSide(color: AppColors.grey4Color),
                  bottom: BorderSide(color: AppColors.grey4Color),
                  right: BorderSide(color: AppColors.grey4Color))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment : CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SvgPicture.asset('assets/svg/ic_map_pin.svg'),
                      ...List.generate(
                          7,
                              (index) => Container(
                            height: 5,
                            width: 1,
                            color: AppColors.grey5Color,
                            margin: EdgeInsets.only(bottom: 5),
                          ))
                    ],
                  ),
                  SizedBox(width: 8,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppTranslations.of(context)!
                              .text('lieuDeDepart'),
                          style: TextStyle(
                              fontFamily: AppStyle.secondaryFont,
                              fontSize: AppStyle.size14,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            widget.course.departure,
                            style: TextStyle(
                                fontFamily: AppStyle.secondaryFont,
                                fontSize: AppStyle.size14,
                                color: AppColors.grey6Color,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment : CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: SvgPicture.asset('assets/svg/ic_map_marker.svg'),
                      ),
                    ],
                  ),
                  SizedBox(width: 8,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppTranslations.of(context)!
                              .text('lieuDarrivee'),
                          style: TextStyle(
                              fontFamily: AppStyle.secondaryFont,
                              fontSize: AppStyle.size14,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            widget.course.destination,
                            style: TextStyle(
                                fontFamily: AppStyle.secondaryFont,
                                fontSize: AppStyle.size14,
                                color: AppColors.grey6Color,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
