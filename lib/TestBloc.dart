import 'dart:async';

import 'Setting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TestBloc extends Bloc<SettingsEvent, SettingsState> {
  late List<Setting> Settings = new List.empty(growable: true);
  TestBloc(SettingsState initialState) : super(initialState);

  Stream<SettingsState> mapEventToState(SettingsEvent event) async*
  {
    if(event.Enabled){
        for(int i = 0;i<25;i++){
          if(i<13)
            Settings.add(new Setting("Sales",i.toString(),true,true,true,true,true,true,true,true));
          else
            Settings.add(new Setting("Support",i.toString(),false,true,false,false,true,false,false,true));
        }

    }
    List<Setting> ActiveSettings = new List.empty(growable: true);
    for(int i = 0;i<Settings.length;i++){
      if(Settings[i].GroupName == event.GroupName){
        ActiveSettings.add(Settings[i]);
      }
    }
    SettingsState newState = new SettingsState();
    newState.Settings = ActiveSettings;
    yield newState;
  }
}

class SettingsEvent{
  late bool Enabled;
  late String GroupName;
}

class SettingsState{
  late List<Setting> Settings;
}