import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repro1/TestBloc.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

import 'Globals.dart';
import 'Setting.dart';

void main() {
  SettingsState init = new SettingsState();
  init.Settings = new List.empty(growable:  true);
  TestBloc Test= new TestBloc(init);
  Globals.SelectedGroupName = "Sales";
  runApp(MyApp(Test));
}

class MyApp extends StatelessWidget {

  late TestBloc Test;
  MyApp(TestBloc test) {
    Test = test;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:(_) => Test,
      child:
        MaterialApp(
          title: 'CallCabinet',
          home: TestWidget(Test),
          theme: new ThemeData(scaffoldBackgroundColor: const Color(0xFFF5F5F5)),
        )
    );
  }

}

class TestWidget extends StatelessWidget {

  late TestBloc Test;

  TestWidget(TestBloc test){

    Test = test;

    SettingsEvent newEvent = new SettingsEvent();
    newEvent.Enabled = true;
    newEvent.GroupName = "Sales";
    Test.add(newEvent);


  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestBloc, SettingsState>(builder: (_, settingsState) {
      return Scaffold(
          backgroundColor: Color(0xFFF5F5F5),
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
          Row(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FloatingActionButton.extended(
                  label: const Text('Sales'),
                  onPressed: (){
                    Globals.SelectedGroupName = "Sales";
                    SettingsEvent newEvent = new SettingsEvent();
                    newEvent.Enabled = false;
                    newEvent.GroupName = "Sales";
                    Test.add(newEvent);}),


              FloatingActionButton.extended(

                  label: const Text('Support'),
                  onPressed: (){
                    Globals.SelectedGroupName = "Support";
                    SettingsEvent newEvent = new SettingsEvent();
                    newEvent.Enabled = false;
                    newEvent.GroupName = "Support";
                    Test.add(newEvent);
                  })
            ],
          ),
          Expanded(
            child:GridView.builder(
              shrinkWrap: true,
              primary: false,
              addAutomaticKeepAlives: false,
              padding: const EdgeInsets.all(20),
              //crossAxisCount: 2,

              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 4.5,
                crossAxisSpacing: 15,
                mainAxisSpacing: 10,
                mainAxisExtent: 135,
              ),
              itemCount: settingsState.Settings.length,
              itemBuilder: (ctx, index) {
                return Visibility(
                visible: settingsState.Settings[index].Visible,
                child: SettingCard(settingsState.Settings[index])
                );
              }

            )
        )
     ]
      )
      );
    });
  }
}


class SettingCard extends StatelessWidget {
  AdvancedSwitchController SwitchController = AdvancedSwitchController();
  late Setting SettingA;
  SettingCard(Setting setting){
    SettingA = setting;

    SwitchController.value = SettingA.Enabled;

  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white54,
        border:
        Border.all(width: 0.5, color: Colors.grey),
        // color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(
            5.0) //         <--- border radius here
        ),),
      height: 130,
      width: 180,
      padding: const EdgeInsets.all(4),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:8.0,bottom: 5,top:5),
            child: Text("A Setting",
                style: TextStyle(fontSize: 16, color: Colors.orange),
                textAlign: TextAlign.left),
          ),
          Padding(
            padding: const EdgeInsets.only(left:8.0,bottom: 5,top:5),
            child: Text("This Setting",
                style: TextStyle(fontSize: 13, color: Colors.black),
                textAlign: TextAlign.left),
          ),
          Row(
            children: [

              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5,top: 5,bottom: 5),
                  child: AdvancedSwitch(
                    controller: SwitchController,
                    activeColor: Colors.lightBlue,
                    inactiveColor: Colors.blueGrey,
                    activeChild: Text('ON'),
                    inactiveChild: Text('OFF'),
                    // activeImage: AssetImage('assets/images/ccON.png'),
                    //inactiveImage: AssetImage('assets/images/ccOFF.png'),
                    borderRadius: BorderRadius.all(const Radius.circular(5)),
                    width: 80.0,
                    height: 32.0,
                    enabled: true,
                    disabledOpacity: 0.5,
                  ),
                ),

              ),
              IconButton(onPressed: (){},
                icon: Icon(Icons.info,size: 18,color: Colors.orange,), ),
            ],
          ),Expanded(
            child:
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyCheckBox(SettingA),
            ),



          ),

        ],
      ),
    );
  }
}
class MyCheckBox extends StatefulWidget {

  late Setting SettingA;



  MyCheckBox(Setting setting){
    SettingA= setting;

  }
  @override
  _MyCheckBoxState createState() => _MyCheckBoxState(SettingA);
}
class _MyCheckBoxState extends State<MyCheckBox> {
  late Setting SettingA;

  late bool AppSharing;
  late bool Video;
  late bool AllowStopCancel;
  late bool AllowPauseResume;
  _MyCheckBoxState(Setting setting){
    SettingA= setting;

    AppSharing = SettingA.AppSharing;
    Video = SettingA.Video;
    AllowStopCancel = SettingA.AllowStopCancel;
    AllowPauseResume = SettingA.AllowPauseResume;
  }
  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.white30;
      }
      return Colors.white;
    }
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // [Monday] checkbox
        Visibility(
          visible: SettingA.VideoEnabled,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                Checkbox(
                  // splashRadius: 2,
                  side:  BorderSide(color: Color(0xff585858)),
                  checkColor: Colors.orange,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: AppSharing,
                  onChanged: (bool? value) {
                    setState(() {

                    });
                  },
                ),

                Text("App Sharing",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                Padding(
                  padding: const EdgeInsets.only(left: 10,right: 8),
                  child: Container(
                    height: 18,
                    width: 18,

                    child: Checkbox(
                      // splashRadius: 2,
                      side:  BorderSide(color: Color(0xff585858)),
                      checkColor: Colors.orange,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: Video,
                      onChanged: (bool? value) {
                        setState(() {

                        });
                      },
                    ),
                  ),
                ), Text("Video",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
              ],
            ),
          ),
        ),
        // [Tuesday] checkbox
        Visibility(
          visible: SettingA.RecordingActionsEnabled,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15,right: 5),
                  child: Container(
                    height: 18,
                    width: 18,

                    child: Checkbox(
                      side:  BorderSide(color: Color(0xff585858)),
                      // splashRadius: 2,
                      checkColor: Colors.orange,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: AllowStopCancel,
                      onChanged: (bool? value) {
                        setState(() {

                        });
                      },
                    ),
                  ),
                ),
                Text("Stop/Cancel",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                Padding(
                  padding: const EdgeInsets.only(left: 5,right: 0),
                  child: Container(


                    child: Checkbox(
                      side:  BorderSide(color: Color(0xff585858)),
                      // splashRadius: 2,
                      checkColor: Colors.orange,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: AllowPauseResume,
                      onChanged: (bool? value) {
                        setState(() {

                        });
                      },
                    ),
                  ),
                ),
                Text("Pause/Resume",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),

              ],
            ),
          ),
        ),


      ],
    );
  }
}

