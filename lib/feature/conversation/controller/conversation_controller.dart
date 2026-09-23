import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:getdash/feature/conversation/model/channel_model.dart';
import 'package:getdash/feature/conversation/model/conversation_model.dart';


class ConversationController extends GetxController implements GetxService{
  ConversationController();


  FilePickerResult? _otherFile;
  FilePickerResult? get otherFile => _otherFile;


  File? _file;
  File? get file=> _file;

  final bool _paginationLoading = true;
  bool get paginationLoading => _paginationLoading;

  int? _messagePageSize;
  final int _messageOffset = 1;
  int? get messagePageSize => _messagePageSize;
  int? get messageOffset => _messageOffset;

  int? _pageSize;
  final int _offset = 1;
  final bool _isLoading = false;
  bool? get isLoading => _isLoading;
  final String _name='';
  String get name => _name;
  final String _image='';
  String get image => _image;


  List<ChannelData>? _channelList;
  List<ChannelData>? get channelList => _channelList;
  List<ConversationData>? _conversationList;
  List<ConversationData>? get conversationList => _conversationList;
  final ScrollController scrollController = ScrollController();
  final ScrollController messageScrollController = ScrollController();
  int? get pageSize => _pageSize;
  int? get offset => _offset;

  var conversationController = TextEditingController();
  final GlobalKey<FormState> conversationKey  = GlobalKey<FormState>();
  String _channelId = '';
  String get channelId => _channelId;
  String _userTypeImage ='';
  String get  userTypeImage => _userTypeImage;

  void setChannelId(String channelId){
    _channelId = channelId;
    update();
  }


  @override
  void onInit(){
    super.onInit();
    conversationController.text = '';
  }


  void pickOtherFile(bool isRemove) async {
    if(isRemove){
      _otherFile=null;
    }else{
      _otherFile = (await FilePicker.platform.pickFiles())!;
      if (_otherFile != null) {
        _file = File(_otherFile!.files.single.path!);
      }
    }
    update();
  }

  void removeFile() async {
    _otherFile=null;
    update();
  }



  Future<void> getConversation() async{

    _conversationList = [
      ConversationData(id: '1',message: "Yeah, Of course we are preparing the slide to present today.",isRightMessage:false),
      ConversationData(id: '2',message: "Hi Mariah, How was the holidays, need to deliver the presentation to clients",isRightMessage: true),
      ConversationData(id: '3',message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",isRightMessage:true),
      ConversationData(id: '4',message: "Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",isRightMessage: false),
      ConversationData(id: '5',message: "Yeah, Of course we are preparing the slide to present today.",isRightMessage:false),
      ConversationData(id: '6',message: "Hi Mariah, How was the holidays, need to deliver the presentation to clients",isRightMessage: true),
      ConversationData(id: '7',message: "Yeah, Of course we are preparing the slide to present today.",isRightMessage:false),
      ConversationData(id: '8',message: "Hi Mariah, How was the holidays, need to deliver the presentation to clients",isRightMessage: true),
      ConversationData(id: '9',message: "Yeah, Of course we are preparing the slide to present today.",isRightMessage:false),
      ConversationData(id: '10',message: "Hi Mariah, How was the holidays, need to deliver the presentation to clients",isRightMessage: true),
    ];

    _channelList = [
      ChannelData(id: '1',createdAt: '20 March 2022'),
      ChannelData(id: '2',createdAt: '20 March 2022'),
      ChannelData(id: '3',createdAt: '20 March 2022'),
      ChannelData(id: '4',createdAt: '20 March 2022'),
      ChannelData(id: '5',createdAt: '20 March 2022'),
      ChannelData(id: '6',createdAt: '20 March 2022'),
      ChannelData(id: '7',createdAt: '20 March 2022'),
      ChannelData(id: '8',createdAt: '20 March 2022'),
      ChannelData(id: '9',createdAt: '20 March 2022'),
      ChannelData(id: '10',createdAt: '20 March 2022'),
      ChannelData(id: '11',createdAt: '20 March 2022'),
      ChannelData(id: '12',createdAt: '20 March 2022'),
    ];
    update();
  }


  void setUserImageType(String userType){
    _userTypeImage = userType;
    update();
  }
}