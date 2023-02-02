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
          leading: Icon(Icons.arrow_back_ios, size: screenWidth*0.06,),
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
        Text("Contact the developers", style: TextStyle(fontSize: screenWidth*0.04),),
        SizedBox(height: screenHeight*0.03,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eleven_mp, size: screenWidth*0.2,),
            SizedBox(width: screenWidth*0.04,),
            Icon(Icons.eleven_mp, size: screenWidth*0.2)
          ],
        ),
      ],
    );
  }

}