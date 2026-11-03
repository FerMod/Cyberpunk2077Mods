
public class MainframeController extends BaseAnimatedDeviceController {

  public const func GetPS() -> ref<MainframeControllerPS> {
    return this.GetBasePS() as MainframeControllerPS;
  }
}

public class MainframeControllerPS extends BaseAnimatedDeviceControllerPS {

  protected let m_factName: ComputerQuickHackData;

  protected func OnActivateDevice(evt: ref<ActivateDevice>) -> EntityNotificationType {
    super.OnActivateDevice(evt);
    this.ExecutePSActionWithDelay(this.ActionSetQuestFact(), this, 20.00);
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected final func ActionSetQuestFact() -> ref<FactQuickHack> {
    let action: ref<FactQuickHack> = new FactQuickHack();
    action.SetUp(this);
    action.AddDeviceName(this.m_deviceName);
    action.SetProperties(this.m_factName);
    return action;
  }

  public final func OnSetQuestFact(evt: ref<FactQuickHack>) -> EntityNotificationType {
    this.UseNotifier(evt);
    return EntityNotificationType.SendThisEventToEntity;
  }
}
