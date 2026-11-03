
public class VirtualSystemPS extends MasterControllerPS {

  private let m_owner: wref<MasterControllerPS>;

  protected let m_slaves: [ref<DeviceComponentPS>];

  private let m_slavesCached: Bool;

  public final const func IsPartOfSystem(targetID: PersistentID) -> Bool {
    let i: Int32 = 0;
    while i < ArraySize(this.m_slaves) {
      if Equals(targetID, this.m_slaves[i].GetID()) {
        return true;
      };
      i += 1;
    };
    return false;
  }

  public final const func IsPartOfSystem(target: ref<DeviceComponentPS>) -> Bool {
    let i: Int32 = 0;
    while i < ArraySize(this.m_slaves) {
      if target == this.m_slaves[i] {
        return true;
      };
      i += 1;
    };
    return false;
  }

  public func GetDeviceWidget(const context: script_ref<GetActionsContext>) -> SDeviceWidgetPackage {
    let customData: ref<TerminalSystemCustomData>;
    let widgetData: SDeviceWidgetPackage = super.GetDeviceWidget(context);
    if widgetData.isValid {
      customData = new TerminalSystemCustomData();
      customData.connectedDevices = ArraySize(this.m_slaves);
      widgetData.customData = customData;
    };
    return widgetData;
  }

  public final func GetDeviceWidget(const context: script_ref<GetActionsContext>, data: script_ref<[SDeviceWidgetPackage]>) -> Void {
    ArrayPush(Deref(data), this.GetDeviceWidget(context));
  }

  public const func GetDeviceStatus() -> String {
    if this.IsON() {
      return "LocKey#51459";
    };
    return "LocKey#51460";
  }

  protected func GetInkWidgetTweakDBID(const context: script_ref<GetActionsContext>) -> TweakDBID {
    return t"DevicesUIDefinitions.DynamicSystemLayoutWidget";
  }

  protected func ActionThumbnailUI() -> ref<ThumbnailUI> {
    let action: ref<ThumbnailUI> = super.ActionThumbnailUI();
    action.CreateThumbnailWidgetPackage(t"DevicesUIDefinitions.SystemDeviceThumnbnailWidget", "LocKey#42210");
    return action;
  }

  public final func Initialize(const slaves: script_ref<[ref<DeviceComponentPS>]>, owner: ref<MasterControllerPS>) -> Void {
    let i: Int32 = 0;
    while i < ArraySize(Deref(slaves)) {
      ArrayPush(this.m_slaves, Deref(slaves)[i]);
      i += 1;
    };
    this.m_slavesCached = true;
    this.m_owner = owner;
  }

  public func GetActions(out outActions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    ArrayPush(outActions, this.ActionToggleON());
    return true;
  }

  public func OnToggleON(evt: ref<ToggleON>) -> EntityNotificationType {
    let actionToSend: ref<ScriptableDeviceAction>;
    super.OnToggleON(evt);
    if this.IsON() {
      actionToSend = this.ActionSetDeviceON();
    } else {
      actionToSend = this.ActionSetDeviceOFF();
    };
    this.SendActionToAllSlaves(actionToSend);
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected const func SendActionToAllSlaves(action: ref<ScriptableDeviceAction>) -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_slaves) {
      this.ExecutePSAction(action, this.m_slaves[i]);
      i += 1;
    };
  }
}

public class SurveillanceSystemUIPS extends VirtualSystemPS {

  public func GetActions(out outActions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    super.GetActions(outActions, context);
    ArrayPush(outActions, this.ActionToggleTakeOverControl());
    return true;
  }

  protected func OnToggleTakeOverControl(evt: ref<ToggleTakeOverControl>) -> EntityNotificationType {
    let i: Int32 = 0;
    while i < ArraySize(this.m_slaves) {
      if (this.m_slaves[i] as ScriptableDeviceComponentPS).CanPlayerTakeOverControl() {
        this.QueuePSEvent(this.m_slaves[i], evt);
        return EntityNotificationType.DoNotNotifyEntity;
      };
      i += 1;
    };
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected func GetBackgroundTextureTweakDBID() -> TweakDBID {
    return t"DeviceIcons.CameraDeviceBackground";
  }

  protected func GetDeviceIconTweakDBID() -> TweakDBID {
    return t"DeviceIcons.CameraDeviceIcon";
  }
}

public class DoorSystemUIPS extends VirtualSystemPS {

  private persistent let m_isOpen: Bool;

  public func GetActions(out outActions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    ArrayPush(outActions, this.ActionToggleOpen());
    return true;
  }

  public final func ActionToggleOpen() -> ref<ToggleOpen> {
    let action: ref<ToggleOpen> = new ToggleOpen();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.SetProperties(this.m_isOpen);
    action.AddDeviceName(this.GetDeviceName());
    action.CreateInteraction();
    action.CreateActionWidgetPackage();
    return action;
  }

  protected final func OnToggleOpen(evt: ref<ToggleOpen>) -> EntityNotificationType {
    this.SendActionToAllSlaves(evt);
    return EntityNotificationType.DoNotNotifyEntity;
  }
}

public class MediaSystemUIPS extends VirtualSystemPS {

  public func GetActions(out outActions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    return true;
  }
}

public class CustomSystemUIPS extends VirtualSystemPS {

  public final func Initialize(const slaves: script_ref<[ref<DeviceComponentPS>]>, owner: ref<MasterControllerPS>, systemName: CName, const actions: script_ref<[CName]>) -> Void {
    this.Initialize(slaves, owner);
  }
}
