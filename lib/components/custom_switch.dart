import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customSwitch(bool val, Function onChangedMethod,context){
  return Transform.scale(
    scale: 0.6,
    child: CupertinoSwitch(
        inactiveTrackColor: Theme.of(context).textTheme.bodySmall!.color!.withValues(alpha: .5),
        activeTrackColor: Theme.of(context).primaryColor,value: val,
        onChanged: (newValue){
          onChangedMethod(newValue);
        }),
  );
}
