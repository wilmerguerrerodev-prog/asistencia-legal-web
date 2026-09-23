import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getdash/core/helper/responsive_helper.dart';
import 'package:getdash/feature/conversation/model/conversation_model.dart';
import 'package:getdash/utils/dimensions.dart';
import 'package:getdash/utils/gaps.dart';
import 'package:getdash/utils/images.dart';

class ConversationBubble extends StatefulWidget {
  final ConversationData conversationData;
  final bool isRightMessage;
  final String oppositeName;

  const ConversationBubble(
      {super.key,
      required this.conversationData,
      required this.isRightMessage,
      required this.oppositeName});

  @override
  State<ConversationBubble> createState() => _ConversationBubbleState();
}

class _ConversationBubbleState extends State<ConversationBubble> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (ResponsiveHelper.isMobile(Get.context)) {
      IsolateNameServer.removePortNameMapping('downloader_send_port');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: widget.isRightMessage
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: widget.isRightMessage
              ? const EdgeInsets.fromLTRB(20, 5, 5, 5)
              : const EdgeInsets.fromLTRB(5, 5, 20, 5),
          child: Column(
            crossAxisAlignment: widget.isRightMessage
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              //Name
              widget.conversationData.user != null
                  ? Row(
                      mainAxisAlignment: widget.isRightMessage
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Text(widget.isRightMessage
                            ? 'Mr Name'
                            : widget.oppositeName),
                      ],
                    )
                  : const SizedBox(),
              Gaps.verticalGapOf(Dimensions.fontSizeExtraSmall),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: widget.isRightMessage
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  //Avater for Right
                  widget.isRightMessage
                      ? const SizedBox()
                      : Column(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                    Images.profileImageTwo,
                                    height: 30, width: 30, )),
                          ],
                        ),
                  const SizedBox(
                    width: Dimensions.paddingSizeSmall,
                  ),
                  //Message body
                  Flexible(
                    child: Column(
                      crossAxisAlignment: widget.isRightMessage
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.conversationData.message != null)
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).hoverColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(
                                    widget.conversationData.message != null
                                        ? Dimensions.paddingSizeDefault
                                        : 0),
                                child:
                                    Text(widget.conversationData.message ?? ''),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  widget.isRightMessage
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                             Images.profileImageOne,
                              height: 30, width: 30, ))
                      : const SizedBox(),
                ],
              ),
              Gaps.verticalGapOf(Dimensions.paddingSizeExtraSmall),
            ],
          ),
        ),
        Padding(
            padding: widget.isRightMessage
                ? const EdgeInsets.fromLTRB(5, 5, 50, 5)
                : const EdgeInsets.fromLTRB(50, 5, 5, 5),
            child: const Text('21 January 2023',
                style: TextStyle(fontSize: 8.0),
                textDirection: TextDirection.ltr)),
      ],
    );
  }
}
