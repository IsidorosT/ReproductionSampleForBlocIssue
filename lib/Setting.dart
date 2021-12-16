import 'package:equatable/equatable.dart';

class Setting extends Equatable {
  const Setting({
    this.groupName = '',
    this.settingName = '',
    this.enabled = false,
    this.visible = false,
    this.videoEnabled = false,
    this.appSharing = false,
  });

  final String groupName;
  final String settingName;
  final bool enabled;
  final bool visible;
  final bool videoEnabled;
  final bool appSharing;

  @override
  List<Object?> get props => [
        groupName,
        settingName,
        enabled,
        visible,
        videoEnabled,
        appSharing,
      ];

  Setting copyWith({
    String? groupName,
    String? settingName,
    bool? enabled,
    bool? visible,
    bool? videoEnabled,
    bool? appSharing,
  }) {
    return Setting(
      groupName: groupName ?? this.groupName,
      settingName: settingName ?? this.settingName,
      enabled: enabled ?? this.enabled,
      visible: visible ?? this.visible,
      videoEnabled: videoEnabled ?? this.videoEnabled,
      appSharing: appSharing ?? this.appSharing,
    );
  }
}
