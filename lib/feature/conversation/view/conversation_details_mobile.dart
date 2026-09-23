import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/components/web_menu_bar.dart';
import 'package:getdash/core/helper/date_converter.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/conversation/controller/conversation_controller.dart';
import 'package:getdash/feature/conversation/model/conversation_model.dart';
import 'package:getdash/feature/conversation/widgets/chatting_shimmer.dart';
import 'package:getdash/feature/conversation/widgets/message_widget.dart';
import 'package:getdash/feature/menu/menu_screen.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/images.dart';
import 'package:getdash/utils/styles.dart';

class ConversationScreenMobile extends StatefulWidget {
  final String channelID;
  final String name;
  final String image;
  final String date;
  final String bookingID;

  const ConversationScreenMobile({super.key,  required this.name, required this.image, required this.channelID,required this.date,required this.bookingID});

  @override
  State<ConversationScreenMobile> createState() => _ConversationScreenMobileState();
}

class _ConversationScreenMobileState extends State<ConversationScreenMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ResponsiveHelper.isMobile(context) ? const MenuDrawer():null,
      body: SafeArea(
        child: Row(
          children: [
            if (ResponsiveHelper.isDesktop(context))
              const MenuDrawer(),

            Expanded(
              child: Column(
                children: [
                  const WebMenuBar(),
                  Expanded(
                    flex: 5,
                    child: GetBuilder<ConversationController>(
                        initState: (state) {
                          Get.find<ConversationController>().getConversation();
                        },
                        builder: (conversationController) {
                          if(conversationController.conversationList != null){
                            List<ConversationData>? conversationList = conversationController.conversationList!.reversed.toList();
                            return Padding(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                              child: Container(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: CustomScrollView(
                                        controller: conversationController.messageScrollController,
                                        slivers: [
                                          SliverToBoxAdapter(child: Center(child: Column(
                                            children: <Widget>[
                                              const SizedBox(height: Dimensions.paddingSizeSmall,),
                                              Text(DateConverter.dateTimeStringToDateTime(DateTime.now().toString()),
                                                style: ubuntuMedium.copyWith(
                                                    fontSize: Dimensions.fontSizeSmall,
                                                    color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.5)),),
                                            ],
                                          )),),
                                          conversationList.isNotEmpty ?
                                          SliverList(
                                            delegate: SliverChildBuilderDelegate((BuildContext context, int index){
                                              return  ConversationBubble(
                                                conversationData:conversationList.elementAt(index),
                                                oppositeName: widget.name,
                                                isRightMessage: conversationList.elementAt(index).isRightMessage!,);
                                            },
                                              childCount:  conversationList.length,
                                            ),
                                          ):

                                          const SliverToBoxAdapter(child: SizedBox()),

                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 90,
                                          width: Get.width,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context,index){
                                              return  Stack(children: [
                                                Padding(padding: const EdgeInsets.only(left: 8),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: SizedBox(
                                                        height: 60,
                                                        width: 60,
                                                        child:Image.asset(
                                                          Images.googleImage,
                                                          fit: BoxFit.contain,
                                                        )
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 0,
                                                  child: InkWell(
                                                    child: const Icon(Icons.cancel_outlined, color: Colors.red),
                                                    onTap: () {
                                                    },
                                                  ),
                                                )
                                              ],
                                              );
                                            },
                                            itemCount: 2,
                                          ),
                                        ),
                                        conversationController.otherFile != null ?
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Stack(
                                            alignment: Alignment.centerRight,
                                            children: [
                                              Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 25),
                                                  child: Center(child: Text(conversationController.otherFile!.names.elementAt(0).toString()))),
                                              InkWell(
                                                child: const Icon(Icons.cancel_outlined, color: Colors.red),
                                                onTap: () {
                                                  conversationController.pickOtherFile(true);
                                                },
                                              )
                                            ],
                                          ),
                                        ) : const SizedBox(),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: Dimensions.paddingSizeSmall,
                                              right: Dimensions.paddingSizeSmall,
                                              bottom: Dimensions.paddingSizeSmall),
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey.withOpacity(0.5)),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 2.0,
                                                  spreadRadius: 0.0,
                                                  offset:
                                                  Offset(2.0, 2.0), // shadow direction: bottom right
                                                )
                                              ],
                                              color: Theme.of(context).cardColor,
                                              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusExtraLarge))),
                                          child: Form(
                                            key: conversationController.conversationKey,
                                            child: Row(children: [
                                              const SizedBox(width: Dimensions.paddingSizeDefault),
                                              Expanded(
                                                child: TextField(
                                                  controller: conversationController.conversationController,
                                                  textCapitalization: TextCapitalization.sentences,
                                                  cursorColor: Theme.of(context).hintColor,
                                                  style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color:Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.8)),
                                                  keyboardType: TextInputType.multiline,
                                                  maxLines: null,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: "write_here".tr,
                                                    hintStyle: ubuntuRegular.copyWith(color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.8), fontSize: 16),),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                                    child: InkWell(
                                                      child: Image.asset(
                                                        Images.image,
                                                        width: 20.0,
                                                        height: 20.0,
                                                        color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.6),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    child: Image.asset(
                                                      Images.file,
                                                      width: 20.0,
                                                      height: 20.0,
                                                      color: Theme.of(context).textTheme.bodySmall!.color!.withOpacity(.6),
                                                    ),
                                                    onTap: () => conversationController.pickOtherFile(false),
                                                  ),
                                                  conversationController.isLoading! ?
                                                  Container(padding: const EdgeInsets.symmetric(horizontal: 10),
                                                      height: 20, width: 40,
                                                      child: const Center(child: CircularProgressIndicator())) :
                                                  InkWell(
                                                    onTap: (){

                                                    },
                                                    child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                                                        child:Image.asset(Images.sendMessage, width: 25, height: 25, color: Colors.lightBlueAccent)
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }else{
                            return const ChattingShimmer();
                          }
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
