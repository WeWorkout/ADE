
import 'package:ade/alert_dialog_service/alert_dialog_service.dart';
import 'package:flutter/material.dart';

class AlertDialogHeader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Material(
      type: MaterialType.transparency,
      child: SizedBox(
        height: screenHeight * 0.075,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _dismissButton(context),
            SizedBox(width: screenWidth*0.025)
          ],
        ),
      ),
    );
  }

  Widget _dismissButton(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return IconButton(
      color: Colors.white,
      onPressed: () async{await AlertDialogService.closeAlertDialog();},
      icon: Icon(
        Icons.cancel,
        size: screenHeight * 0.05,
      ),
    );
  }
}