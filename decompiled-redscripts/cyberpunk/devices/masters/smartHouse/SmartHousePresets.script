
public abstract class SmartHousePreset extends IScriptable {

  protected let timetable: SPresetTimetableEntry;

  public func GetPresetName() -> CName {
    return n"WRONG PRESET";
  }

  public func GetIconName() -> CName {
    return n"NO ICON";
  }

  public final func GetTimeTable() -> SPresetTimetableEntry {
    return this.timetable;
  }

  public func ExecutePresetActions(const devices: script_ref<[ref<DeviceComponentPS>]>) -> Void {
    let i: Int32 = 0;
    while i < ArraySize(Deref(devices)) {
      if IsDefined(Deref(devices)[i] as SimpleSwitchControllerPS) {
        this.QueueSwitchActions(Deref(devices)[i] as SimpleSwitchControllerPS);
      } else {
        if IsDefined(Deref(devices)[i] as RadioControllerPS) {
          this.QueueRadioActions(Deref(devices)[i] as RadioControllerPS);
        } else {
          if IsDefined(Deref(devices)[i] as TVControllerPS) {
            this.QueueTVActions(Deref(devices)[i] as TVControllerPS);
          } else {
            if IsDefined(Deref(devices)[i] as WindowBlindersControllerPS) {
              this.QueueWindowBlinderActions(Deref(devices)[i] as WindowBlindersControllerPS);
            } else {
              if IsDefined(Deref(devices)[i] as DoorControllerPS) {
                this.QueueDoorActions(Deref(devices)[i] as DoorControllerPS);
              };
            };
          };
        };
      };
      i += 1;
    };
  }

  protected func QueueSwitchActions(device: ref<SimpleSwitchControllerPS>) -> Void;

  protected func QueueRadioActions(device: ref<RadioControllerPS>) -> Void;

  protected func QueueTVActions(device: ref<TVControllerPS>) -> Void;

  protected func QueueWindowBlinderActions(device: ref<WindowBlindersControllerPS>) -> Void;

  protected func QueueDoorActions(device: ref<DoorControllerPS>) -> Void;
}

public class MorningPreset extends SmartHousePreset {

  public func GetPresetName() -> CName {
    return n"LocKey#6427";
  }

  public func GetIconName() -> CName {
    return n"morningPreset";
  }

  protected func QueueSwitchActions(device: ref<SimpleSwitchControllerPS>) -> Void {
    if device.IsLightSwitch() && device.IsON() {
      device.ExecutePSAction(device.ActionToggleON(), device);
    };
  }

  protected func QueueRadioActions(device: ref<RadioControllerPS>) -> Void {
    if device.IsOFF() {
      device.ExecutePSAction(device.ActionToggleON(), device);
    };
  }

  protected func QueueTVActions(device: ref<TVControllerPS>) -> Void {
    if device.IsON() {
      device.ExecutePSAction(device.ActionToggleON(), device);
    };
  }

  protected func QueueWindowBlinderActions(device: ref<WindowBlindersControllerPS>) -> Void {
    if !device.IsOpen() {
      device.ExecutePSAction(device.ActionToggleOpen(), device);
    };
  }

  protected func QueueDoorActions(device: ref<DoorControllerPS>) -> Void {
    if device.IsShutter() {
      if !device.IsOpen() {
        device.ExecutePSAction(device.ActionToggleOpen(), device);
      };
    } else {
      if device.IsLocked() {
        device.ExecutePSAction(device.ActionToggleLock(), device);
      };
    };
  }
}

public class EveningPreset extends SmartHousePreset {

  public func GetPresetName() -> CName {
    return n"LocKey#6428";
  }

  protected func QueueSwitchActions(device: ref<SimpleSwitchControllerPS>) -> Void {
    if device.IsLightSwitch() && device.IsOFF() {
      device.ExecutePSAction(device.ActionToggleON(), device);
    };
  }

  protected func QueueRadioActions(device: ref<RadioControllerPS>) -> Void {
    if device.IsON() {
      device.ExecutePSAction(device.ActionToggleON(), device);
    };
  }

  protected func QueueTVActions(device: ref<TVControllerPS>) -> Void {
    if device.IsOFF() {
      device.ExecutePSAction(device.ActionToggleON(), device);
    };
  }

  protected func QueueWindowBlinderActions(device: ref<WindowBlindersControllerPS>) -> Void {
    if !device.IsTilted() {
      device.ExecutePSAction(device.ActionToggleTiltBlinders(), device);
    };
  }

  protected func QueueDoorActions(device: ref<DoorControllerPS>) -> Void {
    if device.IsShutter() {
      if !device.IsOpen() {
        device.ExecutePSAction(device.ActionToggleOpen(), device);
      };
    } else {
      if device.IsLocked() {
        device.ExecutePSAction(device.ActionToggleLock(), device);
      };
    };
  }
}

public class NightPreset extends SmartHousePreset {

  public func GetPresetName() -> CName {
    return n"LocKey#6429";
  }

  public func GetIconName() -> CName {
    return n"nightPreset";
  }

  protected func QueueSwitchActions(device: ref<SimpleSwitchControllerPS>) -> Void {
    if device.IsLightSwitch() && device.IsON() {
      device.ExecutePSAction(device.ActionToggleON(), device);
    };
  }

  protected func QueueRadioActions(device: ref<RadioControllerPS>) -> Void {
    if device.IsON() {
      device.ExecutePSAction(device.ActionToggleON(), device);
    };
  }

  protected func QueueTVActions(device: ref<TVControllerPS>) -> Void {
    if device.IsON() {
      device.ExecutePSAction(device.ActionToggleON(), device);
    };
  }

  protected func QueueWindowBlinderActions(device: ref<WindowBlindersControllerPS>) -> Void {
    if device.IsTilted() {
      device.ExecutePSAction(device.ActionToggleTiltBlinders(), device);
    } else {
      if device.IsOpen() {
        device.ExecutePSAction(device.ActionToggleOpen(), device);
      };
    };
  }

  protected func QueueDoorActions(device: ref<DoorControllerPS>) -> Void {
    if device.IsShutter() {
      if device.IsOpen() {
        device.ExecutePSAction(device.ActionToggleOpen(), device);
      };
    } else {
      if !device.IsLocked() {
        device.ExecutePSAction(device.ActionToggleLock(), device);
      };
    };
  }
}
