
public class ElectricBox extends InteractiveMasterDevice {

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as ElectricBoxController;
  }

  protected cb func OnGameAttached() -> Bool {
    super.OnGameAttached();
    this.UpdateAnimState();
  }

  private const func GetController() -> ref<ElectricBoxController> {
    return this.m_controller as ElectricBoxController;
  }

  public const func GetDevicePS() -> ref<ElectricBoxControllerPS> {
    return this.GetController().GetPS();
  }

  public const func DeterminGameplayRole() -> EGameplayRole {
    return EGameplayRole.ControlOtherDevice;
  }

  protected cb func OnActionOverride(evt: ref<ActionOverride>) -> Bool {
    let delay: ref<DelayEvent>;
    let playerPuppet: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerControlledGameObject() as PlayerPuppet;
    this.EnterWorkspot(playerPuppet, false, n"disassembleWorkspot");
    this.SetGameplayRoleToNone();
    this.SetQuestFact();
    this.m_interaction.Toggle(false);
    this.SendDataToUIBlackboard(playerPuppet);
    this.UpdateDeviceState();
    delay = new DelayEvent();
    GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(this, delay, 3.40);
  }

  protected final func SendDataToUIBlackboard(player: ref<PlayerPuppet>) -> Void {
    this.GetPSMBlackboard(player).SetBool(GetAllBlackboardDefs().PlayerStateMachine.IsInteractingWithDevice, true);
    this.GetBlackboard().SetBool(GetAllBlackboardDefs().ElectricBoxBlackBoard.isOverriden, true);
    this.GetBlackboard().FireCallbacks();
  }

  private final func GetPSMBlackboard(player: ref<PlayerPuppet>) -> ref<IBlackboard> {
    return GameInstance.GetBlackboardSystem(this.GetGame()).GetLocalInstanced(player.GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
  }

  protected cb func OnDelayEvent(evt: ref<DelayEvent>) -> Bool {
    this.GetDevicePS().WorkspotFinished();
  }

  protected final func SetQuestFact() -> Void {
    let properties: ComputerQuickHackData = this.GetDevicePS().GetQuestSetup();
    if IsNameValid(properties.factName) {
      if Equals(properties.operationType, EMathOperationType.Set) {
        SetFactValue(this.GetGame(), properties.factName, properties.factValue);
      } else {
        AddFact(this.GetGame(), properties.factName, properties.factValue);
      };
    };
  }

  protected func EnterWorkspot(activator: ref<GameObject>, opt freeCamera: Bool, opt componentName: CName, opt deviceData: CName) -> Void {
    let workspotSystem: ref<WorkspotGameSystem> = GameInstance.GetWorkspotSystem(activator.GetGame());
    workspotSystem.PlayInDeviceSimple(this, activator, freeCamera, componentName, n"deviceWorkspot", n"None", 0.50, WorkspotSlidingBehaviour.PlayAtResourcePosition);
  }

  private final func UpdateAnimState() -> Void {
    let animFeature: ref<AnimFeature_SimpleDevice> = new AnimFeature_SimpleDevice();
    animFeature.isOpen = this.GetDevicePS().IsOverriden();
    AnimationControllerComponent.ApplyFeature(this, n"DeviceMaintenancePanel", animFeature);
  }
}
