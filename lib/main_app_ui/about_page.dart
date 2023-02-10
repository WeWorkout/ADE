import 'package:ade/main_app_ui/utils/fonts.dart';
import 'package:ade/main_app_ui/widgets/devs/abhinav_card.dart';
import 'package:ade/main_app_ui/widgets/devs/purushottam_card.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0,
          leading: InkWell(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back_ios, size: screenWidth*0.06, color: Colors.white,)
          ),
          title: Padding( padding: EdgeInsets.all(screenWidth*0.05), child: const Image(image: AssetImage("assets/icons/logoText.png"), color: Colors.white,)),
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

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      color: Colors.black,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: screenWidth * 0.8,
        height: screenHeight * 0.45,
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.02),
            _logo(context),
            const Spacer(),
            _content(context),
            const Spacer(),
            _sourceCodeLink(context),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
        height: screenHeight * 0.1,
        child: Center(child: Text("Unplug from the MATRIX!", style: Fonts.header2(color: Colors.white, underLine: true, isItalic: true),)));
  }

  Widget _sourceCodeLink(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () => _openGithubSourceCodeLink(),
      child: Column(
        children: [
          SizedBox(
              height: screenHeight*0.07,
              width: screenWidth*0.5,
              child: const Image(image: AssetImage("assets/icons/githubIcon.png"))
          ),
          Text("Source Code link", style: TextStyle(fontSize: screenWidth*0.03, decoration: TextDecoration.underline),)
        ],
      ),
    );
  }

  Widget _logo(BuildContext context){
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      child: SizedBox(
          height: screenHeight*0.15,
          width: screenWidth*0.6,
          child: const Image(image: AssetImage("assets/icons/logoWithText.png"),)
      ),
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
              return const SimpleDialog(
                  backgroundColor: Colors.transparent,
                  children: [
                    PurushottamCard()
              ]
              );
            });
      case "Abhinav":
        return showDialog(
            context: context,
            builder: (context){
              return const SimpleDialog(
                  backgroundColor: Colors.transparent,
                  children: [
                    AbhinavCard()
                  ]
              );
            });
      default: debugPrint("Pehchaan Kaun!: $dev");
        return;
    }
  }

  _openGithubSourceCodeLink() async{
    String url = "https://github.com/WeWorkout/ADE/tree/master";
    try{
      if (await canLaunchUrl(Uri.parse(url))){
        await launchUrl(Uri.parse(url));
      }

      else {
        throw "Could not launch $url";
      }
    }
    catch(e){
      debugPrint("Error while launching URL: $e");
    }
  }

}