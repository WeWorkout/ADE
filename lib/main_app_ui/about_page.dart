import 'package:ade/main_app_ui/widgets/devs/abhinav_card.dart';
import 'package:ade/main_app_ui/widgets/devs/purushottam_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.greenAccent,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.greenAccent,
          elevation: 0,
          leading: InkWell(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back_ios, size: screenWidth*0.06,)
          ),
          title: const Text("About ADE App", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 25)),
        ),
        body: Column(
          children: [
            SizedBox(height: screenHeight*0.07,),
            _aboutSection(context),
            SizedBox(height: screenHeight*0.05,),
            const Divider(thickness: 1,),
            _developersSection(context),
          ],
        )
    );
  }

  Widget _aboutSection(BuildContext context){
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.red,
      height: screenHeight*0.5,
      width: screenWidth*0.8,
    );
  }

  Widget _developersSection(BuildContext context){
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(height: screenHeight*0.02,),
        Text("Contact the developers", style: TextStyle(fontSize: screenWidth*0.04, fontStyle: FontStyle.italic, decoration: TextDecoration.underline),),
        SizedBox(height: screenHeight*0.03,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: (){
                _showDevCardDialog(context,"Purushottam");
              },
              child: Column(
                children: [
                  SizedBox(
                      height: screenHeight*0.13,
                      width: screenWidth*0.25,
                      child: const CircleAvatar(backgroundImage: AssetImage("assets/dps/PurushottamChotu.png"),)
                  ),
                  Text("Purushottam", style: TextStyle(fontSize: screenWidth*0.035),)
                ],
              ),
            ),
            SizedBox(width: screenWidth*0.07,),
            InkWell(
              onTap: (){
                _showDevCardDialog(context, "Abhinav");
              },
              child: Column(
                children: [
                  SizedBox(
                      height: screenHeight*0.13,
                      width: screenWidth*0.25,
                      child: const CircleAvatar(backgroundImage: AssetImage("assets/dps/AbhinavDP.png"), backgroundColor: Colors.grey,)
                  ),
                  Text("Abhinav", style: TextStyle(fontSize: screenWidth*0.035),)
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  _showDevCardDialog(BuildContext context, String dev){
    switch(dev){
      case "Purushottam":
        return showDialog(
            context: context,
            builder: (context){
              return SimpleDialog(
                  backgroundColor: Colors.transparent,
                  children: [
                    const PurushottamCard()
              ]
              );
            });
      case "Abhinav":
        return showDialog(
            context: context,
            builder: (context){
              return SimpleDialog(
                  backgroundColor: Colors.transparent,
                  children: [
                    const AbhinavCard()
                  ]
              );
            });
      default: debugPrint("Pehchaan Kaun!: $dev");
        return;
    }
  }

}