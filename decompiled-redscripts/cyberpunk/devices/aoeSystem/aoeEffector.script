
public class AOEEffector extends ActivatedDeviceTransfromAnim {

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as AOEEffectorController;
  }

  protected cb func OnGameAttached() -> Bool {
    super.OnGameAttached();
    if Equals(this.GetDeviceState(), EDeviceStatus.ON) {
      this.StartEffects();
    } else {
      this.BreakEffects();
    };
  }

  protected const func GetController() -> ref<AOEEffectorController> {
    return this.m_controller as AOEEffectorController;
  }

  public const func GetDevicePS() -> ref<AOEEffectorControllerPS> {
    return this.GetController().GetPS();
  }

  protected func PushPersistentData() -> Void {
    super.PushPersistentData();
  }

  protected cb func OnToggleAOEEffect(evt: ref<ToggleAOEEffect>) -> Bool {
    if Equals(this.GetDeviceState(), EDeviceStatus.ON) {
      this.StartEffects();
    } else {
      this.BreakEffects();
    };
    this.SetGameplayRoleToNone();
  }

  protected final func StartEffects() -> Void {
    let effects: array<CName> = this.GetDevicePS().GetEffectsToPlay();
    let i: Int32 = 0;
    while i < ArraySize(effects) {
      GameObject.StartReplicatedEffectEvent(this, effects[i]);
      i += 1;
    };
  }

  protected final func BreakEffects() -> Void {
    let effects: array<CName> = this.GetDevicePS().GetEffectsToPlay();
    let i: Int32 = 0;
    while i < ArraySize(effects) {
      GameObject.BreakReplicatedEffectLoopEvent(this, effects[i]);
      i += 1;
    };
  }

  public const func DeterminGameplayRole() -> EGameplayRole {
    return EGameplayRole.SpreadGas;
  }

  public const func IsGameplayRelevant() -> Bool {
    return true;
  }
}
