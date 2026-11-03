
public class ConveyorController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<ConveyorControllerPS> {
    return this.GetBasePS() as ConveyorControllerPS;
  }

  private final func OnGameAttach() -> Void {
    this.RestoreDeviceState();
  }

  private final func RestoreDeviceState() -> Void {
    if this.GetPS().IsON() {
      this.StartConveyor();
    } else {
      this.StopConveyor();
    };
  }

  protected cb func OnSetDeviceON(evt: ref<SetDeviceON>) -> Bool {
    this.StartConveyor();
  }

  protected cb func OnSetDeviceOFF(evt: ref<SetDeviceOFF>) -> Bool {
    this.StopConveyor();
  }

  protected cb func OnToggleON(evt: ref<ToggleON>) -> Bool {
    let value: Bool = FromVariant<Bool>(evt.prop.first);
    if !value {
      this.StartConveyor();
    } else {
      this.StopConveyor();
    };
  }

  private final func StartConveyor() -> Void {
    let evt: ref<gameConveyorControlEvent> = new gameConveyorControlEvent();
    evt.enable = true;
    this.GetEntity().QueueEvent(evt);
  }

  private final func StopConveyor() -> Void {
    let evt: ref<gameConveyorControlEvent> = new gameConveyorControlEvent();
    evt.enable = false;
    this.GetEntity().QueueEvent(evt);
  }
}

public class ConveyorControllerPS extends ScriptableDeviceComponentPS {

  public func GetActions(out actions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    super.GetActions(actions, context);
    if !this.IsUserAuthorized(context.processInitiatorObject.GetEntityID()) {
      return false;
    };
    if ToggleON.IsDefaultConditionMet(this, context) {
      ArrayPush(actions, this.ActionToggleON());
    };
    this.SetActionIllegality(actions, this.m_illegalActions.regularActions);
    return true;
  }

  protected func OnSetDeviceON(evt: ref<SetDeviceON>) -> EntityNotificationType {
    if this.IsUnpowered() || this.IsDisabled() {
      return this.SendActionFailedEvent(evt, evt.GetRequesterID(), "Unpowered or Disabled");
    };
    this.SetDeviceState(EDeviceStatus.ON);
    if !IsFinal() {
    };
    this.UseNotifier(evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected func OnSetDeviceOFF(evt: ref<SetDeviceOFF>) -> EntityNotificationType {
    if this.IsUnpowered() || this.IsDisabled() {
      return this.SendActionFailedEvent(evt, evt.GetRequesterID(), "Unpowered or Disabled");
    };
    this.SetDeviceState(EDeviceStatus.OFF);
    if !IsFinal() {
    };
    this.UseNotifier(evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  public func OnToggleON(evt: ref<ToggleON>) -> EntityNotificationType {
    let value: Bool;
    let notifier: ref<ActionNotifier> = new ActionNotifier();
    notifier.SetNone();
    value = FromVariant<Bool>(evt.prop.first);
    if !value {
      this.SetDeviceState(EDeviceStatus.ON);
    } else {
      this.SetDeviceState(EDeviceStatus.OFF);
    };
    if !IsFinal() {
    };
    this.Notify(notifier, evt);
    return EntityNotificationType.SendThisEventToEntity;
  }
}
