
import 'package:flutter/material.dart';
import 'package:getdash/utils/dimensions.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> items = ['Awade Harren','Profile','Sign Out'];
  final String? selectedItem = 'Awade Harren';


  CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 80,
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          Container(
              height: 10,
              width: 10,
              margin: const EdgeInsets.only(left: 20,top: 10,bottom: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey),borderRadius: BorderRadius.circular(4)),
              child: IconButton(onPressed: (){}, icon: const Icon(Icons.menu,size: 20),color: Colors.black)),
          Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), shape: BoxShape.circle),
            child: IconButton(onPressed: (){}, icon: const Icon(Icons.language,size: 18),color: Colors.black),
          ),
          const SizedBox(width: 10),
          Container(
              height: 33,
              width: 33,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400),shape: BoxShape.circle),
              child: IconButton(onPressed: (){}, icon: const Icon(Icons.messenger_outline,size: 16),color: Colors.black)),
          const SizedBox(width: 10),
          Container(
              height: 33,
              width: 35,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400),shape: BoxShape.circle),
              child: IconButton(onPressed: (){}, icon: const Icon(Icons.notifications_none_outlined,size: 18),color: Colors.black)),
          const SizedBox(width: 10),
          Container(
              height: 33,
              width: 33,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400),shape: BoxShape.circle),
              child: IconButton(icon: Image.asset('assets/images/flag_uk.png'), onPressed: () {})),
          const SizedBox(width: 30),
          Container(
              height: 33,
              width: 33,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400),shape: BoxShape.circle),
              child: IconButton(icon: Image.asset('assets/images/profile_image.jpg'), iconSize: 10, onPressed: () {})),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                  underline: const SizedBox(),
                  items: items.map((item) => DropdownMenuItem<String>(value: item, child: Text(item,style: const TextStyle(fontSize: 14)))).toList(),
                  onChanged: (item) => {
                    //value will be updated with getX
                  },
                  value: selectedItem),
            ],
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size(Dimensions.webMaxWidth, 80);
}
