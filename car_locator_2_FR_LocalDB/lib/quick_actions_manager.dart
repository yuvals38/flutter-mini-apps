import 'package:car_locator_2/appstate/app_state.dart';
import 'package:flutter/material.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:io';

 

class QuickActionsManager extends StatefulWidget {
   final QuickActions quickActions = QuickActions();
   final Widget child;

  QuickActionsManager({Key key, this.child}) : super(key: key);

  _QuickActionsManagerState createState() => _QuickActionsManagerState();
}

class _QuickActionsManagerState extends State<QuickActionsManager> {
  final QuickActions quickActions = QuickActions();

    @override
      void initState() {
      super.initState();
      _setupQuickActions();
      _handleQuickActions();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

 

  void _setupQuickActions() {
      quickActions.setShortcutItems(<ShortcutItem>[

        ShortcutItem(
            type: 'action_park', 
            localizedTitle: 'Park',
            icon: Platform.isAndroid ? 'quick_box' : 'QuickBox'),

        ShortcutItem(
            type: 'action_main',
            localizedTitle: 'Main',
            icon: Platform.isAndroid ? 'quick_heart' : 'QuickHeart')
      ]);
    }

 
    void _handleQuickActions() {
    quickActions.initialize((shortcutType) {

      if (shortcutType == 'action_park') {
        AppState autoadd = new AppState(true);
       
        autoadd.addGeoPointAuto();

        Future.delayed(Duration(seconds: 2), () {
        Navigator.push(
           context, MaterialPageRoute(builder: (context) => Login()));
        });

            Future.delayed(Duration(seconds: 11), () {
                  exit(0);
                    });

      } else if(shortcutType == 'action_main') {
        print('Show the park dialog!');
      }
    });
  }
}




class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Home - using appstate')));
  }

}




ProgressDialog pr;
double percentage = 0.0;
class Login extends StatelessWidget {
  const Login({Key key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Download);
    pr.style(message: 'Parking...');

    //Optional
    pr.style(
          message: 'Parking...',
          borderRadius: 10.0,
          backgroundColor: Colors.white,
          progressWidget: CircularProgressIndicator(),
          elevation: 10.0,
          insetAnimCurve: Curves.easeInOut,
          progress: 0.0,
          maxProgress: 100.0,
          progressTextStyle: TextStyle(
              color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
          messageTextStyle: TextStyle(
              color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
        );


      Future.delayed(Duration(seconds: 2), () {
       pr.show();

       Future.delayed(Duration(seconds: 2)).then((onvalue) {
                percentage = percentage + 30.0;
                print(percentage);

                pr.update(
                  progress: percentage,
                  message: "Please wait...",
                  progressWidget: Container(
                      padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
                  maxProgress: 100.0,
                  progressTextStyle: TextStyle(
                      color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
                  messageTextStyle: TextStyle(
                      color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
                );

                Future.delayed(Duration(seconds: 2)).then((value) {
                  percentage = percentage + 30.0;
                  pr.update(
                      progress: percentage, message: "Few more seconds...");
                  print(percentage);
                  Future.delayed(Duration(seconds: 2)).then((value) {
                    percentage = percentage + 30.0;
                    pr.update(progress: percentage, message: "Almost done...");
                    print(percentage);
                    Future.delayed(Duration(seconds: 2)).then((value) {
                      pr.hide();
                      percentage = 0.0;
                    });
                  });
                });
              });
      });

      
   return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/mapc.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: null /* add child content here */,
      ),
    );
  } 

}