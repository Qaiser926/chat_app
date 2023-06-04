
import 'package:flutter/material.dart';

class FormateTimeUtil{

static String getFormateTime(BuildContext context, String time){

  final date=DateTime.fromMillisecondsSinceEpoch(int.parse(time));

  return TimeOfDay.fromDateTime(date).format(context);
}

static String getSentTimeFormate(BuildContext context, String time){

  final sent=DateTime.fromMillisecondsSinceEpoch(int.parse(time));
  final now=DateTime.now();
  if(now.day == sent.day && now.month==sent.month && now.year==sent.year){
    return TimeOfDay.fromDateTime(sent).format(context);
  }else{
    return "${sent.month}:${getMonthName(sent)}";
  }

  // return ;
}
 static String getMonthName(DateTime time){
  switch (time.month) {
    case 1:
      return "Jan";
      case 2:
      return "Fab";
      case 3:
      return "Mar";
      case 4:
      return "Apr";
      case 5:
      return "May";
      case 6:
      return "Jun";
      case 7:
      return "Jul";
      case 8:
      return "Aug";
      case 9:
      return "Sep";
      case 10:
      return "Oct";
      case 11:
      return "Nov";
      case 12:
      return "Dec";

   
  }
  return "NA";
 }
}