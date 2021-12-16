import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repro1/app_bloc_observer.dart';
import 'package:repro1/test_bloc.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

import 'globals.dart';
import 'setting.dart';

void main() {
  Globals.selectedGroupName = "Sales";
  BlocOverrides.runZoned(
    () => runApp(const MyApp()),
    blocObserver: AppBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => TestBloc()
          ..add(
            const SettingsEvent(enabled: true, groupName: 'Sales'),
          ),
        child: MaterialApp(
          title: 'CallCabinet',
          home: const TestWidget(),
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFFF5F5F5),
          ),
        ));
  }
}

class TestWidget extends StatelessWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FloatingActionButton.extended(
                  label: const Text('Sales'),
                  onPressed: () {
                    Globals.selectedGroupName = "Sales";
                    context.read<TestBloc>().add(
                          const SettingsEvent(
                            enabled: false,
                            groupName: 'Sales',
                          ),
                        );
                  },
                ),
                FloatingActionButton.extended(
                  label: const Text('Support'),
                  onPressed: () {
                    Globals.selectedGroupName = "Support";
                    context.read<TestBloc>().add(
                          const SettingsEvent(
                            enabled: false,
                            groupName: 'Support',
                          ),
                        );
                  },
                ),
              ],
            ),
            Expanded(
              child: BlocBuilder<TestBloc, SettingsState>(
                builder: (_, state) {
                  return GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    addAutomaticKeepAlives: false,
                    padding: const EdgeInsets.all(20),
                    //crossAxisCount: 2,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 4.5,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 135,
                    ),
                    itemCount: state.filteredSettings.length,
                    itemBuilder: (_, index) {
                      final setting = state.filteredSettings[index];
                      return Visibility(
                        visible: setting.visible,
                        child: SettingCard(setting: setting),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingCard extends StatefulWidget {
  const SettingCard({
    Key? key,
    required this.setting,
  }) : super(key: key);

  final Setting setting;

  @override
  State<SettingCard> createState() => _SettingCardState();
}

class _SettingCardState extends State<SettingCard> {
  late AdvancedSwitchController _switchController;

  @override
  void initState() {
    super.initState();
    _switchController = AdvancedSwitchController(widget.setting.enabled);
  }

  @override
  void didUpdateWidget(covariant SettingCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.setting.enabled != widget.setting.enabled) {
      _switchController.value = widget.setting.enabled;
    }
  }

  @override
  void dispose() {
    _switchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white54,
        border: Border.all(width: 0.5, color: Colors.grey),
        // color: Colors.grey,
        borderRadius: const BorderRadius.all(
            Radius.circular(5.0) //         <--- border radius here
            ),
      ),
      height: 130,
      width: 180,
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 5, top: 5),
            child: Text("A Setting",
                style: TextStyle(fontSize: 16, color: Colors.orange),
                textAlign: TextAlign.left),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 5, top: 5),
            child: Text("This Setting",
                style: TextStyle(fontSize: 13, color: Colors.black),
                textAlign: TextAlign.left),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                child: AdvancedSwitch(
                  controller: _switchController,
                  activeColor: Colors.lightBlue,
                  inactiveColor: Colors.blueGrey,
                  activeChild: const Text('ON'),
                  inactiveChild: const Text('OFF'),
                  // activeImage: AssetImage('assets/images/ccON.png'),
                  //inactiveImage: AssetImage('assets/images/ccOFF.png'),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  width: 80.0,
                  height: 32.0,
                  enabled: true,
                  disabledOpacity: 0.5,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.info,
                  size: 18,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyCheckBox(setting: widget.setting),
            ),
          ),
        ],
      ),
    );
  }
}

class MyCheckBox extends StatefulWidget {
  const MyCheckBox({Key? key, required this.setting}) : super(key: key);

  final Setting setting;

  @override
  _MyCheckBoxState createState() => _MyCheckBoxState();
}

class _MyCheckBoxState extends State<MyCheckBox> {
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // [Monday] checkbox
        Visibility(
          visible: widget.setting.videoEnabled,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox(
                side: const BorderSide(color: Color(0xff585858)),
                checkColor: Colors.orange,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: widget.setting.appSharing,
                onChanged: (bool? value) {
                  // todo: add event to bloc
                },
              ),
              const Text(
                "App Sharing",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
