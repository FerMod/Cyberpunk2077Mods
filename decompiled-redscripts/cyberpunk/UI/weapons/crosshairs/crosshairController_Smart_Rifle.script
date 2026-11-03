
public class CrosshairGameController_Smart_Rifl extends gameuiCrosshairBaseGameController {

  protected edit let m_txtAccuracy: inkTextRef;

  protected edit let m_txtTargetsCount: inkTextRef;

  protected edit let m_txtFluffStatus: inkTextRef;

  protected edit let m_leftPart: inkImageRef;

  protected edit let m_rightPart: inkImageRef;

  protected edit let m_leftPartExtra: inkImageRef;

  protected edit let m_rightPartExtra: inkImageRef;

  @default(CrosshairGameController_Smart_Rifl, .8)
  private let offsetLeftRight: Float;

  @default(CrosshairGameController_Smart_Rifl, 1.2)
  private let offsetLeftRightExtra: Float;

  @default(CrosshairGameController_Smart_Rifl, 40.0)
  private let latchVertical: Float;

  protected edit let m_topPart: inkImageRef;

  protected edit let m_bottomPart: inkImageRef;

  protected edit let m_horiPart: inkWidgetRef;

  protected edit let m_vertPart: inkWidgetRef;

  @default(CrosshairGameController_Smart_Rifl, bucket)
  protected edit let m_targetWidgetLibraryName: CName;

  @default(CrosshairGameController_Smart_Rifl, 10)
  protected edit let m_targetsPullSize: Int32;

  protected edit let m_targetColorChange: inkWidgetRef;

  protected edit let m_targetingFrame: inkWidgetRef;

  protected edit let m_reticleFrame: inkWidgetRef;

  protected edit let m_bufferFrame: inkWidgetRef;

  protected edit let m_targetHolder: inkCompoundRef;

  protected edit let m_lockHolder: inkCompoundRef;

  protected edit let m_reloadIndicator: inkCompoundRef;

  protected edit let m_reloadIndicatorInv: inkCompoundRef;

  protected edit let m_smartLinkDot: inkCompoundRef;

  protected edit let m_smartLinkFrame: inkCompoundRef;

  protected edit let m_smartLinkFluff: inkCompoundRef;

  protected edit let m_smartLinkFirmwareOnline: inkCompoundRef;

  protected edit let m_smartLinkFirmwareOffline: inkCompoundRef;

  private let m_hasSmartLink: Bool;

  private let m_weaponBlackboard: wref<IBlackboard>;

  private let m_weaponParamsListenerId: ref<CallbackHandle>;

  private let m_smartData: ref<smartGunUIParameters>;

  private let m_targetsPool: [wref<inkWidget>];

  private let m_targets: [wref<inkWidget>];

  private let m_isBlocked: Bool;

  private let m_isAimDownSights: Bool;

  private let m_bufferedSpread: Vector2;

  private let m_reloadAnimationProxy: ref<inkAnimProxy>;

  public let m_prevTargetedEntityIDs: [EntityID];

  public let m_currTargetedEntityIDs: [EntityID];

  public let m_numLockedTargets: Int32;

  private let m_playerDevelopmentData: wref<PlayerDevelopmentData>;

  protected cb func OnInitialize() -> Bool {
    super.OnInitialize();
    this.SetupLayout();
  }

  protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
    super.OnPlayerAttach(playerPuppet);
    this.m_playerDevelopmentData = PlayerDevelopmentSystem.GetData(playerPuppet);
  }

  protected cb func OnPreIntro() -> Bool {
    this.m_weaponBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_ActiveWeaponData);
    this.m_weaponParamsListenerId = this.m_weaponBlackboard.RegisterDelayedListenerVariant(GetAllBlackboardDefs().UI_ActiveWeaponData.SmartGunParams, this, n"OnSmartGunParams");
    super.OnPreIntro();
  }

  protected cb func OnPreOutro() -> Bool {
    this.m_weaponBlackboard.UnregisterDelayedListener(GetAllBlackboardDefs().UI_ActiveWeaponData.SmartGunParams, this.m_weaponParamsListenerId);
    super.OnPreOutro();
  }

  private final func SetupLayout() -> Void {
    let newTarget: wref<inkWidget>;
    let i: Int32 = 0;
    while i < this.m_targetsPullSize {
      newTarget = this.SpawnFromLocal(inkWidgetRef.Get(this.m_targetHolder), this.m_targetWidgetLibraryName);
      newTarget.SetVisible(false);
      ArrayPush(this.m_targetsPool, newTarget);
      i += 1;
    };
    inkWidgetRef.SetVisible(this.m_reloadIndicator, false);
    inkWidgetRef.SetVisible(this.m_reloadIndicatorInv, true);
  }

  protected cb func OnSmartGunParams(argParams: Variant) -> Bool {
    let bufferValue: Vector2;
    let reticleSize: Vector2;
    let smartData: ref<smartGunUIParameters>;
    let targetableRegionSize: Vector2;
    let shouldIgnoreUI: Bool = GameInstance.GetStatsSystem(this.GetGame()).GetStatBoolValue(Cast<StatsObjectID>(this.GetWeaponItemObject().GetEntityID()), gamedataStatType.ShouldIgnoreSmartUI);
    if !shouldIgnoreUI {
      smartData = FromVariant<ref<smartGunUIParameters>>(argParams);
      targetableRegionSize = smartData.sight.targetableRegionSize;
      reticleSize = smartData.sight.reticleSize;
      this.CheckIfRectangleNeedsToBeResized(targetableRegionSize, reticleSize);
      inkWidgetRef.SetSize(this.m_targetingFrame, targetableRegionSize);
      inkWidgetRef.SetSize(this.m_reticleFrame, reticleSize);
      bufferValue.Y = (targetableRegionSize.Y - reticleSize.Y) / 2.00;
      inkWidgetRef.SetSize(this.m_bufferFrame, 100.00, bufferValue.Y);
      this.m_hasSmartLink = smartData.hasRequiredCyberware;
      inkWidgetRef.SetVisible(this.m_smartLinkDot, false);
      inkWidgetRef.SetVisible(this.m_smartLinkFrame, true);
      inkWidgetRef.SetVisible(this.m_smartLinkFluff, true);
      inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOffline, !this.m_hasSmartLink);
      inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOnline, this.m_hasSmartLink);
      this.ProcessParams(smartData);
    } else {
      inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOffline, true);
      inkWidgetRef.SetVisible(this.m_smartLinkFirmwareOnline, false);
      this.ReturnAllTargetsToPool();
    };
  }

  public final func CheckIfRectangleNeedsToBeResized(out targetableRegionSize: Vector2, out reticleSize: Vector2) -> Void {
    let smartGunTargetingRectangleSizeIncrease: Float = GameInstance.GetStatsSystem(this.GetGame()).GetStatValue(Cast<StatsObjectID>(this.m_playerPuppet.GetEntityID()), gamedataStatType.SmartGunTargetingRectangleSizeIncrease);
    if smartGunTargetingRectangleSizeIncrease > 0.00 {
      targetableRegionSize.X *= 1.00 + smartGunTargetingRectangleSizeIncrease / 100.00;
      targetableRegionSize.Y *= 1.00 + smartGunTargetingRectangleSizeIncrease / 100.00;
      reticleSize.X *= 1.00 + smartGunTargetingRectangleSizeIncrease / 100.00;
      reticleSize.Y *= 1.00 + smartGunTargetingRectangleSizeIncrease / 100.00;
    };
  }

  public final func ProcessParams(smartData: ref<smartGunUIParameters>) -> Void {
    let count: Int32;
    let i: Int32;
    let newTargets: array<wref<inkWidget>>;
    let targetData: smartGunUITargetParameters;
    this.m_smartData = smartData;
    this.m_numLockedTargets = 0;
    this.m_prevTargetedEntityIDs = this.m_currTargetedEntityIDs;
    ArrayClear(this.m_currTargetedEntityIDs);
    count = ArraySize(this.m_smartData.targets);
    i = 0;
    while i < count {
      targetData = this.m_smartData.targets[i];
      if !this.LookupCurrentTargets(targetData, newTargets) {
        this.AllocateNewTarget(targetData, newTargets);
      };
      i += 1;
    };
    this.m_smartData = null;
    this.ReturnAllTargetsToPool();
    if Cast<Bool>(ArraySize(newTargets)) {
      this.m_targets = newTargets;
    };
  }

  public final func LookupCurrentTargets(const data: script_ref<smartGunUITargetParameters>, newTargets: script_ref<[wref<inkWidget>]>) -> Bool {
    let currController: wref<Crosshair_Smart_Rifl_Bucket>;
    let currWidget: wref<inkWidget>;
    let count: Int32 = ArraySize(this.m_targets);
    let i: Int32 = 0;
    while i < count {
      currWidget = this.m_targets[i];
      currController = currWidget.GetController() as Crosshair_Smart_Rifl_Bucket;
      if currController.MatchData(data) {
        ArrayErase(this.m_targets, i);
        ArrayPush(Deref(newTargets), currWidget);
        this.ProcessData(data, currWidget, currController);
        return true;
      };
      i += 1;
    };
    return false;
  }

  public func HandleDeadEye() -> Void {
    let animOptions: inkAnimOptions;
    let count: Int32;
    let currController: wref<Crosshair_Smart_Rifl_Bucket>;
    let currWidget: wref<inkWidget>;
    let i: Int32;
    let newHasDeadEye: Bool = StatusEffectSystem.ObjectHasStatusEffectWithTag(this.m_playerPuppet, n"DeadeyeSE");
    if Equals(this.m_hasDeadEye, newHasDeadEye) {
      return;
    };
    this.m_hasDeadEye = newHasDeadEye;
    if this.m_hasSmartLink {
      count = ArraySize(this.m_targets);
      i = 0;
      while i < count {
        currWidget = this.m_targets[i];
        currController = currWidget.GetController() as Crosshair_Smart_Rifl_Bucket;
        currController.HandleDeadEyeInTargetBrackets(this.m_hasDeadEye);
        i += 1;
      };
    } else {
      if !this.m_hasDeadEye {
        animOptions.customTimeDilation = 2.00;
        animOptions.applyCustomTimeDilation = true;
        animOptions.playReversed = true;
        this.m_deadEyeAnimProxy = this.PlayLibraryAnimation(n"deadeye_anim", animOptions);
        if IsDefined(this.m_deadEyeAnimProxy) && this.m_deadEyeAnimProxy.IsValid() && this.m_deadEyeAnimProxy.IsPlaying() {
          this.m_deadEyeAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnDeadEyeAnimFinished");
        } else {
          inkWidgetRef.SetVisible(this.m_deadEyeWidget, false);
        };
      } else {
        animOptions.customTimeDilation = 1.50;
        animOptions.applyCustomTimeDilation = true;
        animOptions.playReversed = false;
        inkWidgetRef.SetVisible(this.m_deadEyeWidget, true);
        this.m_deadEyeAnimProxy = this.PlayLibraryAnimation(n"deadeye_anim", animOptions);
      };
    };
  }

  protected cb func OnDeadEyeAnimFinished(anim: ref<inkAnimProxy>) -> Bool {
    inkWidgetRef.SetVisible(this.m_deadEyeWidget, false);
  }

  public final func AllocateNewTarget(const data: script_ref<smartGunUITargetParameters>, newTargets: script_ref<[wref<inkWidget>]>) -> Void {
    let currWidget: wref<inkWidget> = ArrayPop(this.m_targetsPool);
    let currController: wref<Crosshair_Smart_Rifl_Bucket> = currWidget.GetController() as Crosshair_Smart_Rifl_Bucket;
    ArrayPush(Deref(newTargets), currWidget);
    this.ProcessData(data, currWidget, currController);
  }

  public final func ProcessData(const data: script_ref<smartGunUITargetParameters>, currWidget: wref<inkWidget>, currController: wref<Crosshair_Smart_Rifl_Bucket>) -> Void {
    currWidget.SetVisible(true);
    currWidget.SetMargin(new inkMargin(Deref(data).pos.X * 0.50, Deref(data).pos.Y * 0.50, 0.00, 0.00));
    if Equals(Deref(data).state, gamesmartGunTargetState.Locked) || Equals(Deref(data).state, gamesmartGunTargetState.Unlocking) {
      currWidget.Reparent(inkWidgetRef.Get(this.m_lockHolder) as inkCompoundWidget);
    } else {
      currWidget.Reparent(inkWidgetRef.Get(this.m_targetHolder) as inkCompoundWidget);
    };
    currController.SetData(data, this.m_smartData, this.m_playerPuppet, this.m_hasDeadEye);
    if Equals(Deref(data).state, gamesmartGunTargetState.Locked) && !ArrayContains(this.m_currTargetedEntityIDs, Deref(data).entityID) {
      ArrayPush(this.m_currTargetedEntityIDs, Deref(data).entityID);
      if !ArrayContains(this.m_prevTargetedEntityIDs, Deref(data).entityID) {
        this.m_numLockedTargets = this.m_numLockedTargets + 1;
      };
    };
  }

  public final func ReturnAllTargetsToPool() -> Void {
    let currController: wref<Crosshair_Smart_Rifl_Bucket>;
    let currWidget: wref<inkWidget>;
    let count: Int32 = ArraySize(this.m_targets);
    let i: Int32 = 0;
    while i < count {
      currWidget = this.m_targets[i];
      currController = currWidget.GetController() as Crosshair_Smart_Rifl_Bucket;
      currWidget.SetVisible(false);
      currController.ResetData(this.m_playerPuppet);
      ArrayPush(this.m_targetsPool, currWidget);
      i += 1;
    };
    ArrayClear(this.m_targets);
  }

  protected func ApplyCrosshairGUIState(state: CName, aimedAtEntity: ref<Entity>) -> Void {
    inkWidgetRef.SetState(this.m_targetColorChange, state);
  }

  public func GetIntroAnimation(firstEquip: Bool) -> ref<inkAnimProxy> {
    let anim: ref<inkAnimDef> = new inkAnimDef();
    let alphaInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    alphaInterpolator.SetStartTransparency(0.00);
    alphaInterpolator.SetEndTransparency(1.00);
    alphaInterpolator.SetDuration(0.25);
    alphaInterpolator.SetType(inkanimInterpolationType.Linear);
    alphaInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    anim.AddInterpolator(alphaInterpolator);
    return this.m_rootWidget.PlayAnimation(anim);
  }

  public func GetOutroAnimation() -> ref<inkAnimProxy> {
    let anim: ref<inkAnimDef> = new inkAnimDef();
    let alphaInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    alphaInterpolator.SetStartTransparency(1.00);
    alphaInterpolator.SetEndTransparency(0.00);
    alphaInterpolator.SetDuration(0.25);
    alphaInterpolator.SetType(inkanimInterpolationType.Linear);
    alphaInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    anim.AddInterpolator(alphaInterpolator);
    return this.m_rootWidget.PlayAnimation(anim);
  }

  protected func OnCrosshairStateChange(oldState: gamePSMCrosshairStates, newState: gamePSMCrosshairStates) -> Void {
    let playbackOptions: inkAnimOptions;
    super.OnCrosshairStateChange(oldState, newState);
    if Equals(newState, gamePSMCrosshairStates.Reload) {
      playbackOptions.loopInfinite = true;
      playbackOptions.loopType = inkanimLoopType.Cycle;
      this.m_reloadAnimationProxy = this.PlayLibraryAnimation(n"reloading", playbackOptions);
      inkWidgetRef.SetVisible(this.m_reloadIndicator, true);
      inkWidgetRef.SetVisible(this.m_reloadIndicatorInv, false);
    } else {
      if IsDefined(this.m_reloadAnimationProxy) {
        inkWidgetRef.SetVisible(this.m_reloadIndicator, false);
        inkWidgetRef.SetVisible(this.m_reloadIndicatorInv, true);
        this.m_reloadAnimationProxy.Stop();
        this.m_reloadAnimationProxy = null;
      };
    };
  }

  protected cb func OnBulletSpreadChanged(spread: Vector2) -> Bool {
    super.OnBulletSpreadChanged(spread);
    this.m_bufferedSpread = spread;
    inkWidgetRef.SetMargin(this.m_leftPart, new inkMargin(-spread.X * this.offsetLeftRight, 0.00, 0.00, 0.00));
    inkWidgetRef.SetMargin(this.m_rightPart, new inkMargin(spread.X * this.offsetLeftRight, 0.00, 0.00, 0.00));
    inkWidgetRef.SetMargin(this.m_leftPartExtra, new inkMargin(-spread.X / 2.00, 0.00, 0.00, 0.00));
    inkWidgetRef.SetMargin(this.m_rightPartExtra, new inkMargin(spread.X / 2.00, 0.00, 0.00, 0.00));
    inkWidgetRef.SetSize(this.m_vertPart, 3.00, spread.Y * 2.00 + this.latchVertical);
    inkWidgetRef.SetSize(this.m_horiPart, spread.X, 3.00);
    inkWidgetRef.SetMargin(this.m_topPart, new inkMargin(0.00, -spread.Y, 0.00, 0.00));
    inkWidgetRef.SetMargin(this.m_bottomPart, new inkMargin(0.00, spread.Y, 0.00, 0.00));
  }

  protected func OnState_HipFire() -> Void {
    super.OnState_HipFire();
    this.m_isAimDownSights = false;
    this.m_isBlocked = false;
  }

  protected func OnState_Aim() -> Void {
    this.m_isAimDownSights = true;
    this.m_isBlocked = false;
  }

  protected func OnState_Reload() -> Void {
    super.OnState_Reload();
    this.m_isBlocked = true;
  }

  protected func OnState_Sprint() -> Void {
    super.OnState_Sprint();
    this.m_isBlocked = true;
  }

  protected func OnState_GrenadeCharging() -> Void {
    super.OnState_GrenadeCharging();
    this.m_isBlocked = true;
  }

  protected func OnState_Scanning() -> Void {
    super.OnState_Scanning();
    this.m_isBlocked = true;
  }

  protected func OnState_Safe() -> Void {
    super.OnState_Safe();
    this.m_isBlocked = true;
  }
}

public class DelayedSmartGunUISoundClue extends DelayCallback {

  private let m_puppet: wref<GameObject>;

  private let m_audioEventName: CName;

  public final static func Create(puppet: ref<GameObject>, audioEventName: CName) -> ref<DelayedSmartGunUISoundClue> {
    let callback: ref<DelayedSmartGunUISoundClue> = new DelayedSmartGunUISoundClue();
    callback.m_puppet = puppet;
    callback.m_audioEventName = audioEventName;
    return callback;
  }

  public func Call() -> Void {
    GameObject.PlaySound(this.m_puppet, this.m_audioEventName);
  }
}

public class Crosshair_Smart_Rifl_Bucket extends inkLogicController {

  @default(Crosshair_Smart_Rifl_Bucket, 1.0f)
  public edit let m_lockingAnimationLength: Float;

  @default(Crosshair_Smart_Rifl_Bucket, 1.0f)
  public edit let m_unlockingAnimationLength: Float;

  public edit let m_deadEyeWidget: inkWidgetRef;

  public let m_data: smartGunUITargetParameters;

  public let m_lockingAnimationProxy: ref<inkAnimProxy>;

  public let m_unlockingAnimationProxy: ref<inkAnimProxy>;

  public let m_activeCallbacks: [DelayID];

  public let m_hasDeadEye: Bool;

  public let m_deadEyeAnimProxy: ref<inkAnimProxy>;

  protected cb func OnInitialize() -> Bool;

  public final func MatchData(const data: script_ref<smartGunUITargetParameters>) -> Bool {
    return this.m_data.entityID == Deref(data).entityID && Equals(this.m_data.attachedBoneName, Deref(data).attachedBoneName);
  }

  public final func ResetData(playerPuppet: ref<GameObject>) -> Void {
    if IsDefined(this.m_lockingAnimationProxy) {
      this.m_lockingAnimationProxy.GotoStartAndStop();
      this.m_lockingAnimationProxy = null;
      this.ClearCallbacks(GameInstance.GetDelaySystem(playerPuppet.GetGame()));
    };
    if IsDefined(this.m_unlockingAnimationProxy) {
      this.m_unlockingAnimationProxy.GotoStartAndStop();
      this.m_unlockingAnimationProxy = null;
    };
    this.m_data.entityID = EMPTY_ENTITY_ID();
    this.m_data.attachedBoneName = n"None";
  }

  public final func SetData(const data: script_ref<smartGunUITargetParameters>, params: ref<smartGunUIParameters>, playerPuppet: ref<GameObject>, newHasDeadEye: Bool) -> Void {
    let playbackOptions: inkAnimOptions;
    switch Deref(data).state {
      case gamesmartGunTargetState.Targetable:
      case gamesmartGunTargetState.Visible:
        break;
      case gamesmartGunTargetState.Locking:
        if IsDefined(this.m_unlockingAnimationProxy) {
          this.m_unlockingAnimationProxy.Stop();
          this.m_unlockingAnimationProxy = null;
        };
        if !IsDefined(this.m_lockingAnimationProxy) {
          this.HandleDeadEyeInTargetBrackets(newHasDeadEye);
          this.StartLocking(data, params, playerPuppet, true);
        };
        break;
      case gamesmartGunTargetState.Locked:
        if IsDefined(this.m_unlockingAnimationProxy) {
          this.m_unlockingAnimationProxy.GotoStartAndStop();
          this.m_unlockingAnimationProxy = null;
        } else {
          if IsDefined(this.m_lockingAnimationProxy) {
            this.m_unlockingAnimationProxy.GotoEndAndStop();
            this.m_unlockingAnimationProxy = null;
          } else {
            this.m_lockingAnimationProxy = this.PlayLibraryAnimation(n"locking", playbackOptions);
            this.m_lockingAnimationProxy.GotoEndAndStop();
            this.m_lockingAnimationProxy = null;
          };
        };
        break;
      case gamesmartGunTargetState.Unlocking:
        if IsDefined(this.m_lockingAnimationProxy) {
          this.m_lockingAnimationProxy.Stop();
          this.m_lockingAnimationProxy = null;
        };
        if !IsDefined(this.m_unlockingAnimationProxy) {
          playbackOptions.playReversed = true;
          playbackOptions.applyCustomTimeDilation = true;
          playbackOptions.customTimeDilation = params.timeToUnlock < 0.30 ? this.m_unlockingAnimationLength : this.m_unlockingAnimationLength / params.timeToUnlock;
          this.m_unlockingAnimationProxy = this.PlayLibraryAnimation(n"locking", playbackOptions);
        } else {
          if this.m_data.timeUnlocking > Deref(data).timeUnlocking {
            this.m_unlockingAnimationProxy.Stop();
            playbackOptions.playReversed = true;
            playbackOptions.applyCustomTimeDilation = true;
            playbackOptions.customTimeDilation = params.timeToUnlock < 0.30 ? this.m_unlockingAnimationLength : this.m_unlockingAnimationLength / params.timeToUnlock;
            this.m_unlockingAnimationProxy = this.PlayLibraryAnimation(n"locking", playbackOptions);
          };
        };
    };
    this.m_data = Deref(data);
  }

  private final func StartLocking(const data: script_ref<smartGunUITargetParameters>, params: ref<smartGunUIParameters>, playerPuppet: ref<GameObject>, scheduleSFX: Bool) -> Void {
    let delayedSoundClue: ref<DelayedSmartGunUISoundClue>;
    let i: Int32;
    let playbackOptions: inkAnimOptions;
    let customTimeDilation: Float = params.timeToLock < 0.30 ? this.m_lockingAnimationLength : this.m_lockingAnimationLength / params.timeToLock;
    customTimeDilation *= 0.74;
    playbackOptions.applyCustomTimeDilation = true;
    playbackOptions.customTimeDilation = customTimeDilation;
    this.m_lockingAnimationProxy = this.PlayLibraryAnimation(n"locking", playbackOptions);
    if scheduleSFX {
      ArrayClear(this.m_activeCallbacks);
      i = 0;
      while i < ArraySize(params.smartAudioEvents) {
        delayedSoundClue = DelayedSmartGunUISoundClue.Create(playerPuppet, params.smartAudioEvents[i]);
        ArrayPush(this.m_activeCallbacks, GameInstance.GetDelaySystem(playerPuppet.GetGame()).DelayCallback(delayedSoundClue, params.smartAudioEventsDelays[i] * params.timeToLock, true));
        i += 1;
      };
    };
  }

  private final func ClearCallbacks(delaySystem: ref<DelaySystem>) -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_activeCallbacks) {
      delaySystem.CancelCallback(this.m_activeCallbacks[i]);
      i += 1;
    };
    ArrayClear(this.m_activeCallbacks);
  }

  public final func HandleDeadEyeInTargetBrackets(newHasDeadEye: Bool) -> Void {
    let animOptions: inkAnimOptions;
    if Equals(this.m_hasDeadEye, newHasDeadEye) {
      return;
    };
    this.m_hasDeadEye = newHasDeadEye;
    if this.m_deadEyeAnimProxy.IsPlaying() {
      this.m_deadEyeAnimProxy.Stop();
    };
    if !this.m_hasDeadEye {
      animOptions.customTimeDilation = 2.00;
      animOptions.applyCustomTimeDilation = true;
      animOptions.playReversed = true;
      this.m_deadEyeAnimProxy = this.PlayLibraryAnimation(n"intro_deadeye", animOptions);
      if IsDefined(this.m_deadEyeAnimProxy) && this.m_deadEyeAnimProxy.IsValid() && this.m_deadEyeAnimProxy.IsPlaying() {
        this.m_deadEyeAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnDeadEyeAnimFinished");
      } else {
        inkWidgetRef.SetVisible(this.m_deadEyeWidget, false);
      };
    } else {
      animOptions.customTimeDilation = 1.50;
      animOptions.applyCustomTimeDilation = true;
      animOptions.playReversed = false;
      inkWidgetRef.SetVisible(this.m_deadEyeWidget, true);
      this.m_deadEyeAnimProxy = this.PlayLibraryAnimation(n"intro_deadeye", animOptions);
    };
  }

  protected cb func OnDeadEyeAnimFinished(anim: ref<inkAnimProxy>) -> Bool {
    inkWidgetRef.SetVisible(this.m_deadEyeWidget, false);
  }
}
