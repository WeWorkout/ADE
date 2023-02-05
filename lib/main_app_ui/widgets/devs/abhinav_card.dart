import 'package:ade/main_app_ui/utils/links.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AbhinavCard extends StatelessWidget{
  const AbhinavCard({Key? key}) : super(key: key);

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
            Center(child: Text("Abhinav", style:  TextStyle(fontSize:screenWidth*0.06,fontStyle: FontStyle.italic),)),
            const Divider(thickness: 2.0,),
            SizedBox(height: screenHeight*0.02,),
            Align(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width:1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)
                ),
                height: screenHeight*0.3,
                width: screenWidth*0.7,
                child: const Image(image: AssetImage("assets/dps/AbhinavDP.png"),),
              ),
            ),
            SizedBox(height: screenHeight*0.05,),
            Row(
              children: [
                SizedBox(width: screenWidth*0.15,),
                InkWell(
                  onTap: (){_launchUrl(Links.abhinavLinkedinLink);},
                  child: SizedBox(
                      height: screenHeight*0.1,
                      width: screenWidth*0.1,
                      child: const Image(image: AssetImage("assets/icons/linkedinIcon.png"))
                  ),
                ),
                SizedBox(width: screenWidth*0.1,),
                InkWell(
                  onTap: (){_launchUrl(Links.abhinavInstagramLink);},
                  child: SizedBox(
                      height: screenHeight*0.13,
                      width: screenWidth*0.13,
                      child: const Image(image: AssetImage("assets/icons/instagramIcon.png"))
                  ),
                ),
                SizedBox(width: screenWidth*0.1,),
                InkWell(
                  onTap: (){_launchUrl(Links.abhinavResumeLink);},
                  child: SizedBox(
                      height: screenHeight*0.1,
                      width: screenWidth*0.1,
                      child: const Image(image: AssetImage("assets/icons/resumeIcon.png"),)
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight*0.02,),
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