import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/core/helper/route_helper.dart';
import 'package:getdash/feature/conversation/controller/conversation_controller.dart';
import 'package:getdash/feature/conversation/model/channel_model.dart';
import 'package:getdash/feature/conversation/widgets/channel_item.dart';

class ChannelList extends GetView<ConversationController> {
  final List<ChannelData>? channelList;

  const ChannelList({super.key, required this.channelList});
  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        itemCount: controller.channelList!.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
          return InkWell(
            onTap: (){
              if(ResponsiveHelper.isMobile(context)){
                Get.toNamed(RouteHelper.getConversationScreenMobile());
              }
            },
            child: ChannelItem(
              channelupdatedAt: '10 January',
              isRead: 1,
              index: index,
            ),
          );
        }
    );
  }
}
