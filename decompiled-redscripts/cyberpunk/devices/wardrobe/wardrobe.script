
public class Wardrobe extends InteractiveDevice {

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as WardrobeController;
  }

  protected cb func OnGameAttached() -> Bool {
    super.OnGameAttached();
  }

  protected func RestoreDeviceState() -> Void {
    super.RestoreDeviceState();
  }

  protected func ResolveGameplayState() -> Void {
    super.ResolveGameplayState();
  }

  protected cb func OnInteractionActivated(evt: ref<InteractionActivationEvent>) -> Bool {
    let actorUpdateData: ref<HUDActorUpdateData>;
    super.OnInteractionActivated(evt);
    if Equals(evt.eventType, gameinteractionsEInteractionEventType.EIET_activate) {
      if Equals(evt.layerData.tag, n"LogicArea") {
        actorUpdateData = new HUDActorUpdateData();
        actorUpdateData.updateIsInIconForcedVisibilityRange = true;
        actorUpdateData.isInIconForcedVisibilityRangeValue = true;
        this.RequestHUDRefresh(actorUpdateData);
      };
    } else {
      if Equals(evt.layerData.tag, n"LogicArea") {
        actorUpdateData = new HUDActorUpdateData();
        actorUpdateData.updateIsInIconForcedVisibilityRange = true;
        actorUpdateData.isInIconForcedVisibilityRangeValue = false;
        this.RequestHUDRefresh(actorUpdateData);
      };
    };
  }

  private const func GetController() -> ref<WardrobeController> {
    return this.m_controller as WardrobeController;
  }

  public const func GetDevicePS() -> ref<WardrobeControllerPS> {
    return this.GetController().GetPS();
  }

  public const func IsWardrobe() -> Bool {
    return true;
  }

  public const func DeterminGameplayRoleMappinVisuaState(const data: script_ref<SDeviceMappinData>) -> EMappinVisualState {
    return EMappinVisualState.Default;
  }

  public const func DeterminGameplayRole() -> EGameplayRole {
    if this.GetDevicePS().HasInteraction() {
      return EGameplayRole.Wardrobe;
    };
    return EGameplayRole.None;
  }
}

public class WardrobeController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<WardrobeControllerPS> {
    return this.GetBasePS() as WardrobeControllerPS;
  }
}
