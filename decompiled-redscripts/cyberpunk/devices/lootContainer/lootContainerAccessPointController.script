
public class LootContainerAccessPointController extends AccessPointController {

  public const func GetPS() -> ref<LootContainerAccessPointControllerPS> {
    return this.GetBasePS() as LootContainerAccessPointControllerPS;
  }
}

public class LootContainerAccessPointControllerPS extends AccessPointControllerPS {

  protected let m_objRef: NodeRef;

  public func FinalizeNetrunnerDive(state: HackingMinigameState) -> Void {
    super.FinalizeNetrunnerDive(state);
    if Equals(state, HackingMinigameState.Succeeded) {
      this.SendActionToEntity();
      this.SendActionToOtherAPDevices();
    };
  }

  private final func SendActionToOtherAPDevices() -> Void {
    let i: Int32;
    let parents: array<ref<DeviceComponentPS>>;
    let action: ref<ScriptableDeviceAction> = this.ActionSetDeviceUnpowered();
    this.SendActionToAllSlaves(action);
    GameInstance.GetDeviceSystem(this.GetGameInstance()).GetParents(this.GetMyEntityID(), parents);
    i = 0;
    while i < ArraySize(parents) {
      this.ExecutePSAction(action, parents[i]);
      i += 1;
    };
  }

  private final func SendActionToEntity() -> Void {
    let evt: ref<ToggleContainerLockEvent>;
    let entityId: EntityID = Cast<EntityID>(ResolveNodeRefWithEntityID(this.m_objRef, this.GetMyEntityID()));
    if EntityID.IsDefined(entityId) {
      evt = new ToggleContainerLockEvent();
      evt.isLocked = false;
      GameInstance.GetPersistencySystem(this.GetGameInstance()).QueueEntityEvent(entityId, evt);
    };
  }
}
