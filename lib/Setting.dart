class Setting {
  late String GroupName = "";
  late String SettingName = "";
  late bool Enabled = false;
  late bool Visible = false;
  late bool AppSharing = false;
  late bool Video = false;
  late bool VideoEnabled = false;
  late bool AllowStopCancel = false;
  late bool AllowPauseResume = false;
  late bool RecordingActionsEnabled = false;

  Setting(String groupName, String settingName, bool enabled, bool visible, bool appSharing,bool video, bool videoEnabled, bool allowStopCancel,bool allowpauseresume, bool recordingactionenabled){
    GroupName = groupName;
    SettingName = settingName;
    Enabled = enabled;
    Visible = visible;
    AppSharing = appSharing;
    Video = video;
    VideoEnabled = videoEnabled;
    AllowStopCancel = allowStopCancel;
    AllowPauseResume = allowpauseresume;
    RecordingActionsEnabled = recordingactionenabled;
  }
}