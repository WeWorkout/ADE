import 'package:ade/main_app_ui/utils/links.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PurushottamCard extends StatelessWidget{
  const PurushottamCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Card(
      color: Colors.blueGrey.shade200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 10,
      child: SizedBox(
        height: screenHeight*0.6,
        width: screenWidth*0.8,
        child: ListView(
          children:  [
            SizedBox(height: screenHeight*0.02,),
            Center(child: Text("Purushottam", style: TextStyle(fontSize:screenWidth*0.06,fontStyle: FontStyle.italic),)),
            const Divider(thickness: 2.0,),
            SizedBox(height: screenHeight*0.02,),
            SizedBox(
              height: screenHeight*0.5,
              width: screenWidth*0.8,
              child: Row(
                children: [
                  SizedBox(
                    width: screenWidth*0.4,
                    height: screenHeight*0.5,
                    child: FittedBox(
                      child: SizedBox(
                        height: screenHeight*0.25,
                        width: screenWidth*0.2,
                        child: const Image(image: AssetImage("assets/dps/PurushottamDP.png"),),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth*0.1,),
                  Align(
                    child: SizedBox(
                      height: screenHeight*0.5,
                      width: screenWidth*0.2,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: (){_launchUrl(Links.purushottamInstagramLink);},
                            child: SizedBox(
                                height: screenHeight*0.13,
                                width: screenWidth*0.13,
                                child: const Image(image: AssetImage("assets/icons/instagramIcon.png"),)
                            ),
                          ),
                          SizedBox(height: screenHeight*0.02,),
                          InkWell(
                            onTap: (){_launchUrl(Links.purushottamLinkedinLink);},
                            child: SizedBox(
                                height: screenHeight*0.1,
                                width: screenWidth*0.1,
                                child: const Image(image: AssetImage("assets/icons/linkedinIcon.png"),)
                            ),
                          ),
                          SizedBox(height: screenHeight*0.03,),
                          InkWell(
                            onTap: (){_launchUrl(Links.purushottamResumeLink);},
                            child: SizedBox(
                                height: screenHeight*0.1,
                                width: screenWidth*0.1,
                                child: const Image(image: AssetImage("assets/icons/resumeIcon.png"),)
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _launchUrl(String url) async{
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