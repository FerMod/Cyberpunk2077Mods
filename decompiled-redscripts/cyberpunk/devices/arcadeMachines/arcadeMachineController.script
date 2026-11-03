
public class ArcadeMachineController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<ArcadeMachineControllerPS> {
    return this.GetBasePS() as ArcadeMachineControllerPS;
  }
}

public class ArcadeMachineControllerPS extends ScriptableDeviceComponentPS {

  protected const let m_gameVideosPaths: [ResRef];

  @default(ArcadeMachineControllerPS, true)
  public let DEBUG_enableArcadeMinigames: Bool;

  @default(ArcadeMachineControllerPS, ArcadeMinigame.INVALID)
  private let m_minigame: ArcadeMinigame;

  private let m_combatStateListener: ref<CallbackHandle>;

  protected cb func OnInstantiated() -> Bool {
    super.OnInstantiated();
    if !IsStringValid(this.m_deviceName) {
      this.m_deviceName = "LocKey#1635";
    };
  }

  protected final func IsPlayable() -> Bool {
    return this.IsON() && (Equals(this.m_minigame, ArcadeMinigame.RoachRace) || Equals(this.m_minigame, ArcadeMinigame.Shooter));
  }

  protected const func ShouldExposePersonalLinkAction() -> Bool {
    if !super.ShouldExposePersonalLinkAction() {
      return false;
    };
    return !this.IsPlayerInteractingWithDevice();
  }

  protected final const func IsPlayerInteractingWithDevice() -> Bool {
    let playerStateMachineBlackboard: ref<IBlackboard> = GameInstance.GetBlackboardSystem(this.GetGameInstance()).GetLocalInstanced(this.GetPlayerEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    return playerStateMachineBlackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.IsInteractingWithDevice);
  }

  public func GetActions(out actions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    if !super.GetActions(actions, context) {
      return false;
    };
    if !this.DEBUG_enableArcadeMinigames || !this.IsPlayable() || this.IsGlitching() || this.IsPlayerInteractingWithDevice() || (this.GetPlayerMainObject() as PlayerPuppet).IsInCombat() {
      return false;
    };
    ArrayPush(actions, this.ActionBeginArcadeMinigame(context.processInitiatorObject));
    this.SetActionIllegality(actions, this.m_illegalActions.regularActions);
    return true;
  }

  protected final func ActionBeginArcadeMinigame(executor: ref<GameObject>) -> ref<BeginArcadeMinigameUI> {
    let action: ref<BeginArcadeMinigameUI> = new BeginArcadeMinigameUI();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.SetProperties();
    action.SetExecutor(executor);
    action.AddDeviceName(this.m_deviceName);
    action.CreateInteraction();
    return action;
  }

  protected final func OnBeginArcadeMinigameUI(evt: ref<BeginArcadeMinigameUI>) -> EntityNotificationType {
    let menuEvent: ref<inkMenuInstance_SpawnEvent>;
    let userData: ref<ArcadeMinigameUserData>;
    if evt.IsCompleted() {
      this.UseNotifier(evt);
      if (this.GetPlayerMainObject() as PlayerPuppet).IsInCombat() {
        return EntityNotificationType.SendThisEventToEntity;
      };
      userData = new ArcadeMinigameUserData();
      userData.m_minigame = this.m_minigame;
      menuEvent = new inkMenuInstance_SpawnEvent();
      menuEvent.Init(n"OnArcadeMinigameBegin", userData);
      GameInstance.GetUISystem(this.GetGameInstance()).QueueEvent(menuEvent);
      return EntityNotificationType.DoNotNotifyEntity;
    };
    this.ExecutePSActionWithDelay(evt, this);
    this.UseNotifier(evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected const func CanCreateAnyQuickHackActions() -> Bool {
    return true;
  }

  protected func GetQuickHackActions(out outActions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    let currentAction: ref<ScriptableDeviceAction> = this.ActionGlitchScreen(t"DeviceAction.GlitchScreenSuicide", t"QuickHack.SuicideHackBase");
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    ArrayPush(outActions, currentAction);
    currentAction = this.ActionGlitchScreen(t"DeviceAction.GlitchScreenBlind", t"QuickHack.BlindHack");
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    ArrayPush(outActions, currentAction);
    currentAction = this.ActionGlitchScreen(t"DeviceAction.GlitchScreenGrenade", t"QuickHack.GrenadeHackBase");
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    ArrayPush(outActions, currentAction);
    if !GlitchScreen.IsDefaultConditionMet(this, context) {
      ScriptableDeviceComponentPS.SetActionsInactiveAll(outActions, "LocKey#7003");
    };
    currentAction = this.ActionQuickHackDistraction();
    currentAction.SetObjectActionID(t"DeviceAction.MalfunctionClassHack");
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    currentAction.SetInactiveWithReason(ScriptableDeviceAction.IsDefaultConditionMet(this, context), "LocKey#7003");
    ArrayPush(outActions, currentAction);
    if this.IsGlitching() || this.IsDistracting() {
      ScriptableDeviceComponentPS.SetActionsInactiveAll(outActions, "LocKey#7004");
    };
    this.FinalizeGetQuickHackActions(outActions, context);
  }

  public func GetQuestActions(out outActions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    super.GetQuestActions(outActions, context);
  }

  public final const func GetGameVideoPath() -> ResRef {
    let path: ResRef;
    let randValue: Int32;
    if ArraySize(this.m_gameVideosPaths) <= 0 {
      return path;
    };
    if ArraySize(this.m_gameVideosPaths) > 1 {
      randValue = RandRange(0, ArraySize(this.m_gameVideosPaths));
      path = this.m_gameVideosPaths[randValue];
    } else {
      path = this.m_gameVideosPaths[0];
    };
    return path;
  }

  public final func SetArcadeMinigame(minigame: ArcadeMinigame) -> Void {
    this.m_minigame = minigame;
  }

  public const func GetBlackboardDef() -> ref<ArcadeMachineBlackboardDef> {
    return GetAllBlackboardDefs().ArcadeMachineBlackBoard;
  }

  protected func GetDeviceIconTweakDBID() -> TweakDBID {
    return t"DeviceIcons.ScreenDeviceIcon";
  }

  protected func GetBackgroundTextureTweakDBID() -> TweakDBID {
    return t"DeviceIcons.ScreenDeviceBackground";
  }
}

public class BeginArcadeMinigameUI extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"BeginArcadeMinigameUI";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(this.actionName, true, n"LocKey#81258", n"LocKey#81258");
  }

  public func GetTweakDBChoiceRecord() -> String {
    return "BeginArcadeMinigameUI";
  }
}
