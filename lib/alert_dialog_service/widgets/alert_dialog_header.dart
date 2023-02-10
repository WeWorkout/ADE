
import 'package:ade/alert_dialog_service/alert_dialog_service.dart';
import 'package:ade/main_app_ui/utils/fonts.dart';
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
            SizedBox(width: screenWidth*0.025),
            Padding( padding: EdgeInsets.all(screenWidth*0.01), child: Image(image: const AssetImage("assets/icons/ia_logo.png"), width: screenHeight * 0.05,)),
            const Spacer(),
            _title(),
            const Spacer(),
            _dismissButton(context),
            SizedBox(width: screenWidth*0.025)
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Text("Notify me by...", style: Fonts.header3(color: Colors.white));
  }

  Widget _dismissButton(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return IconButton(
      color: Colors.white,
      onPressed: () async{await AlertDialogService.closeAlertDialog();},
      icon: Icon(
        Icons.close,
        size: screenHeight * 0.04,
      ),
    );
  }
}