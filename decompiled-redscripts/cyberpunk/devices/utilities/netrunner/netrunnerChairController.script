
public class NetrunnerChairController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<NetrunnerChairControllerPS> {
    return this.GetBasePS() as NetrunnerChairControllerPS;
  }
}

public class NetrunnerChairControllerPS extends ScriptableDeviceComponentPS {

  @default(NetrunnerChairControllerPS, 1.0f)
  protected edit let m_killDelay: Float;

  @default(NetrunnerChairControllerPS, false)
  protected let m_wasOverloaded: Bool;

  protected const func CanCreateAnyQuickHackActions() -> Bool {
    return true;
  }

  protected func GetQuickHackActions(out actions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    let currentAction: ref<ScriptableDeviceAction> = this.ActionOverloadDevice();
    currentAction.SetObjectActionID(t"DeviceAction.OverloadClassHack");
    currentAction.SetInactiveWithReason(!this.m_wasOverloaded && this.IsSomeoneUsingNPCWorkspot(), "LocKey#7011");
    ArrayPush(actions, currentAction);
    this.FinalizeGetQuickHackActions(actions, context);
  }

  protected func ActionOverloadDevice() -> ref<OverloadDevice> {
    let action: ref<OverloadDevice> = super.ActionOverloadDevice();
    action.SetKillDelay(this.m_killDelay);
    return action;
  }

  protected func OnOverloadDevice(evt: ref<OverloadDevice>) -> EntityNotificationType {
    let npc: ref<GameObject> = GameInstance.GetWorkspotSystem(this.GetGameInstance()).GetDeviceUser(PersistentID.ExtractEntityID(this.GetID()));
    if IsDefined(npc) {
      StatusEffectHelper.ApplyStatusEffect(npc, t"WorkspotStatus.Death", this.m_killDelay);
    };
    this.m_wasOverloaded = true;
    return super.OnOverloadDevice(evt);
  }
}
