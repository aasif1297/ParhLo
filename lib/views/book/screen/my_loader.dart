import 'package:flutter/material.dart';

class MyLoader extends StatefulWidget {
  @override
  _MyLoaderState createState() => _MyLoaderState();
}

class _MyLoaderState extends State<MyLoader> with TickerProviderStateMixin {
    AnimationController motionController;
   Animation motionAnimation;
   double size = 20;
   void initState() {
     super.initState();
 
     motionController = AnimationController(
       duration: Duration(seconds: 1),
       vsync: this,
       lowerBound: 0.5,
     );
 
     motionAnimation = CurvedAnimation(
       parent: motionController,
       curve: Curves.ease,
     );
 
     motionController.forward();
     motionController.addStatusListener((status) {
       setState(() {
         if (status == AnimationStatus.completed) {
           motionController.reverse();
         } else if (status == AnimationStatus.dismissed) {
           motionController.forward();
         }
       });
     });
 
     motionController.addListener(() {
       setState(() {
         size = motionController.value * 100;
       });
     });
     // motionController.repeat();
   }
 
   @override
   void dispose() {
     motionController.dispose();
     super.dispose();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.only(top: 300, left: 8, right: 8),
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                child: Stack(children: <Widget>[
                  Center(
                    child: new Container(
                      child: Image.asset('assets/images/book.png'),
                      height: size,
                    ),
                  ),
                ]),
                height: 100,
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
