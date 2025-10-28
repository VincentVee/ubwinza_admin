import 'package:flutter/material.dart';
import 'package:ubwinza_admin_dashboard/view/widgets/my_appbar.dart';

class BannerScreen extends StatefulWidget {
  const BannerScreen({super.key});

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: MyAppbar(titleMsg: "Upload Banners", showBackButton: true),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Form(

              key: formKey,
              child: Column(
                children: [
                  const Divider(
                    color: Colors.purple,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            //display image
                            Container(
                              height: 140,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                border: Border.all(
                                  color: Colors.grey.shade500
                                ),
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: Center(),
                            ),


                            const SizedBox(height: 10,),

                            //pick image
                            ElevatedButton(
                                onPressed: (){},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purple
                                ),
                                child: const Text(
                                  "Pick Image",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                )
                            ),

                          ],
                        ),
                      ),

                      const SizedBox(width: 40,),

                      //Save image
                      ElevatedButton(
                          onPressed: (){},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple
                          ),
                          child: const Text(
                            "Save",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          )
                      ),


                    ],

                  ),

                  Divider(color: Colors.purple,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
