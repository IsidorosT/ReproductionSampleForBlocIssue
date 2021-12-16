import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'setting.dart';

class TestBloc extends Bloc<SettingsEvent, SettingsState> {
  TestBloc()
      : super(
          // initial state
          SettingsState(
            settings: List.generate(
              8,
              (index) => index < 4
                  ? Setting(
                      groupName: 'Sales',
                      settingName: index.toString(),
                      enabled: true,
                      visible: true,
                      videoEnabled: true,
                      appSharing: true,
                    )
                  : Setting(
                      groupName: 'Support',
                      settingName: index.toString(),
                      enabled: false,
                      visible: true,
                      videoEnabled: true,
                      appSharing: false,
                    ),
            ),
          ),
        ) {
    on<SettingsEvent>(_onSettingsEvent);
  }

  void _onSettingsEvent(SettingsEvent event, Emitter<SettingsState> emit) {
    final filteredSettings = state.settings
        .where(
          (setting) => setting.groupName == event.groupName,
        )
        .toList();
    print("Selected Group:" + event.groupName);
    emit(state.copyWith(filteredSettings: filteredSettings));
  }
}

class SettingsEvent extends Equatable {
  const SettingsEvent({
    required this.enabled,
    required this.groupName,
  });

  final bool enabled;
  final String groupName;

  @override
  List<Object?> get props => [enabled, groupName];
}

class SettingsState extends Equatable {
  const SettingsState._({
    required this.settings,
    required this.filteredSettings,
  });

  const SettingsState({
    required this.settings,
  }) : filteredSettings = settings;

  final List<Setting> settings;
  final List<Setting> filteredSettings;

  @override
  List<Object?> get props => [settings, filteredSettings];

  SettingsState copyWith({
    List<Setting>? filteredSettings,
  }) {
    return SettingsState._(
      settings: settings,
      filteredSettings: filteredSettings ?? this.filteredSettings,
    );
  }
}
