
public abstract class LeftHandCyberwareHelper extends IScriptable {

  public final static func ProjectileLauncherHasCharge(const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    let charges: Int32 = (scriptInterface.executionOwner as PlayerPuppet).GetProjectileLauncherCharges();
    return charges > 0;
  }

  public final static func IsProjectileLauncherEquipped(const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    let weapon: wref<WeaponObject> = scriptInterface.GetTransactionSystem().GetItemInSlot(scriptInterface.executionOwner, t"AttachmentSlots.WeaponLeft") as WeaponObject;
    if IsDefined(weapon) && WeaponObject.IsOfType(weapon.GetItemID(), gamedataItemType.Cyb_Launcher) {
      return true;
    };
    return false;
  }
}

public abstract class LeftHandCyberwareTransition extends DefaultTransition {

  public let m_leftCWFeature: ref<AnimFeature_LeftHandCyberware>;

  public let m_overchargeStatFlag: ref<gameStatModifierData>;

  protected final func CreateAndSendAnimFeatureData(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.m_leftCWFeature = new AnimFeature_LeftHandCyberware();
    this.m_leftCWFeature.actionDuration = stateContext.GetFloatParameter(n"actionDuration", true);
    this.m_leftCWFeature.state = stateContext.GetIntParameter(n"state", true);
    this.m_leftCWFeature.isQuickAction = stateContext.GetBoolParameter(n"isQuickAction", true);
    this.m_leftCWFeature.isChargeAction = stateContext.GetBoolParameter(n"isChargeAction", true);
    this.m_leftCWFeature.isLoopAction = stateContext.GetBoolParameter(n"isLoopAction", true);
    this.m_leftCWFeature.isCatchAction = stateContext.GetBoolParameter(n"isCatchAction", true);
    this.m_leftCWFeature.isSafeAction = stateContext.GetBoolParameter(n"isSafeAction", true);
    this.m_leftCWFeature.chargeNormalized = 0.00;
    this.m_leftCWFeature.hasCWPerk = false;
    scriptInterface.SetAnimationParameterFeature(n"LeftHandCyberware", this.m_leftCWFeature, scriptInterface.executionOwner);
  }

  protected final func UpdateAndSendChargeAnimData(chargeAmount: Float, hasCWPerk: Bool, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.m_leftCWFeature.chargeNormalized = chargeAmount;
    this.m_leftCWFeature.hasCWPerk = hasCWPerk;
    scriptInterface.SetAnimationParameterFeature(n"LeftHandCyberware", this.m_leftCWFeature, scriptInterface.executionOwner);
  }

  protected final func SetLeftHandItemTypeAndState(scriptInterface: ref<StateGameScriptInterface>, type: Int32, state: Int32) -> Void {
    let itemHandling: ref<AnimFeature_EquipUnequipItem> = new AnimFeature_EquipUnequipItem();
    itemHandling.itemType = type;
    itemHandling.itemState = state;
    scriptInterface.SetAnimationParameterFeature(n"leftHandItemHandling", itemHandling, scriptInterface.executionOwner);
  }

  protected final func LockLeftHandAnimation(scriptInterface: ref<StateGameScriptInterface>, newState: Bool) -> Void {
    let animFeature: ref<AnimFeature_LeftHandAnimation> = new AnimFeature_LeftHandAnimation();
    animFeature.lockLeftHandAnimation = newState;
    scriptInterface.SetAnimationParameterFeature(n"LeftHandAnimation", animFeature, scriptInterface.executionOwner);
  }

  protected final func SetAnimEquipState(scriptInterface: ref<StateGameScriptInterface>, newState: Bool) -> Void {
    let animFeature: ref<AnimFeature_LeftHandItem> = new AnimFeature_LeftHandItem();
    animFeature.itemInLeftHand = newState;
    scriptInterface.SetAnimationParameterFeature(n"LeftHandItem", animFeature, scriptInterface.executionOwner);
  }

  protected final const func GetProjectileTemplateNameFromWeaponDefinition(weaponTweak: TweakDBID) -> CName {
    return TweakDBInterface.GetCName(weaponTweak + t".projectileTemplateName", n"None");
  }

  protected final const func GetEquipDuration(const scriptInterface: ref<StateGameScriptInterface>) -> Float {
    return scriptInterface.GetStatsSystem().GetStatValue(Cast<StatsObjectID>(this.GetLeftHandWeaponObject(scriptInterface).GetEntityID()), gamedataStatType.EquipDuration);
  }

  protected final const func GetUnequipDuration(const scriptInterface: ref<StateGameScriptInterface>) -> Float {
    return scriptInterface.GetStatsSystem().GetStatValue(Cast<StatsObjectID>(this.GetLeftHandWeaponObject(scriptInterface).GetEntityID()), gamedataStatType.UnequipDuration);
  }

  protected final const func LeftHandCyberwareHasTag(const scriptInterface: ref<StateGameScriptInterface>, tag: CName) -> Bool {
    let leftHandObject: wref<WeaponObject> = this.GetLeftHandWeaponObject(scriptInterface);
    if IsDefined(leftHandObject) {
      if scriptInterface.GetTransactionSystem().HasTag(scriptInterface.executionOwner, tag, leftHandObject.GetItemID()) {
        return true;
      };
    };
    return false;
  }

  protected final const func QuickwheelHasTag(const scriptInterface: ref<StateGameScriptInterface>, tag: CName) -> Bool {
    let itemID: ItemID = EquipmentSystem.GetData(scriptInterface.executionOwner).GetActiveItem(gamedataEquipmentArea.QuickWheel);
    return scriptInterface.GetTransactionSystem().HasTag(scriptInterface.owner, tag, itemID);
  }

  protected final const func GetLeftHandWeaponObject(const scriptInterface: ref<StateGameScriptInterface>) -> wref<WeaponObject> {
    let leftHandWpnObject: wref<WeaponObject> = scriptInterface.GetTransactionSystem().GetItemInSlot(scriptInterface.executionOwner, t"AttachmentSlots.WeaponLeft") as WeaponObject;
    return leftHandWpnObject;
  }

  protected final const func WeaponIsCharged(const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    let weaponObject: wref<WeaponObject> = this.GetLeftHandWeaponObject(scriptInterface);
    return weaponObject.IsCharged();
  }

  public final func AttachAndPreviewProjectile(scriptInterface: ref<StateGameScriptInterface>, active: Bool) -> Void {
    let installedProjectile: ItemID;
    let previewEvent: ref<gameprojectileProjectilePreviewEvent>;
    let round: ref<ItemObject>;
    this.GetCurrentlyInstalledProjectile(scriptInterface, installedProjectile);
    if !IsDefined(round) {
      return;
    };
    previewEvent = new gameprojectileProjectilePreviewEvent();
    previewEvent.previewActive = active;
    round.QueueEvent(previewEvent);
  }

  public final func DetachProjectile(scriptInterface: ref<StateGameScriptInterface>, opt angleOffset: Float) -> Void {
    let installedProjectile: ItemID;
    let projectileTemplateName: CName;
    let leftHandItemObj: ref<ItemObject> = scriptInterface.GetTransactionSystem().GetItemInSlot(scriptInterface.executionOwner, RPGManager.GetAttachmentSlotID("WeaponLeft"));
    if !IsDefined(leftHandItemObj) {
      return;
    };
    this.GetCurrentlyInstalledProjectile(scriptInterface, installedProjectile);
    projectileTemplateName = TweakDBInterface.GetCName(ItemID.GetTDBID(installedProjectile) + t".projectileTemplateName", n"None");
    if angleOffset != 0.00 {
      ProjectileLaunchHelper.SpawnArmsLauncherProjectileWithRotation(scriptInterface.executionOwner, projectileTemplateName, leftHandItemObj, angleOffset);
    } else {
      ProjectileLaunchHelper.SpawnProjectileFromScreenCenter(scriptInterface.executionOwner, projectileTemplateName, n"None", leftHandItemObj);
    };
    GameInstance.GetTelemetrySystem(scriptInterface.executionOwner.GetGame()).LogActiveCyberwareUsed(scriptInterface.executionOwner, leftHandItemObj.GetItemID());
  }

  protected final func DrainLeftHandWeaponCharge(scriptInterface: ref<StateGameScriptInterface>, chargeValue: Float) -> Void {
    GameInstance.GetStatPoolsSystem((scriptInterface.executionOwner as PlayerPuppet).GetGame()).RequestChangingStatPoolValue(Cast<StatsObjectID>(scriptInterface.executionOwner.GetEntityID()), gamedataStatPoolType.ProjectileLauncherCharges, -chargeValue, null, false, false);
    this.ChangeStatPoolValue(scriptInterface, this.GetLeftHandWeaponObject(scriptInterface).GetEntityID(), gamedataStatPoolType.WeaponCharge, -100.00, true);
  }

  protected final func SetLeftHandWeaponCharged(scriptInterface: ref<StateGameScriptInterface>, charged: Bool) -> Void {
    this.GetLeftHandWeaponObject(scriptInterface).SetCharged(charged);
  }

  protected final func GetWeaponChargeCost(scriptInterface: ref<StateGameScriptInterface>) -> Float {
    let chargeCost: Float = Cast<Float>((scriptInterface.executionOwner as PlayerPuppet).GetProjectileLauncherShootCost());
    return chargeCost;
  }

  protected final func TurnOnOvercharge(scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let playerID: EntityID = scriptInterface.executionOwner.GetEntityID();
    let stats: ref<StatsSystem> = scriptInterface.GetStatsSystem();
    if !IsDefined(this.m_overchargeStatFlag) && stats.GetStatValue(Cast<StatsObjectID>(playerID), gamedataStatType.CanOverchargeWeapon) == 0.00 {
      this.m_overchargeStatFlag = RPGManager.CreateStatModifier(gamedataStatType.CanOverchargeWeapon, gameStatModifierType.Additive, 1.00);
      stats.AddModifier(Cast<StatsObjectID>(playerID), this.m_overchargeStatFlag);
    };
  }

  protected final func TurnOFFOvercharge(scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let playerID: EntityID = scriptInterface.executionOwner.GetEntityID();
    let stats: ref<StatsSystem> = scriptInterface.GetStatsSystem();
    if IsDefined(this.m_overchargeStatFlag) && stats.GetStatValue(Cast<StatsObjectID>(playerID), gamedataStatType.CanOverchargeWeapon) > 0.00 {
      stats.RemoveModifier(Cast<StatsObjectID>(playerID), this.m_overchargeStatFlag);
      this.m_overchargeStatFlag = null;
    };
  }

  protected final func HasMeleewarePerkStatFlag(scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    return RPGManager.HasStatFlag(scriptInterface.executionOwner, gamedataStatType.CanUseNewMeleewareAttackSpyTree);
  }

  public final func GetCurrentlyInstalledProjectile(scriptInterface: ref<StateGameScriptInterface>, out installedProjectile: ItemID) -> Bool {
    let i: Int32;
    let partSlots: SPartSlots;
    let projectileLauncherRound: array<SPartSlots> = ItemModificationSystem.GetAllSlots(scriptInterface.executionOwner, this.GetLeftHandWeaponObject(scriptInterface).GetItemID());
    if ArraySize(projectileLauncherRound) == 0 {
      return false;
    };
    i = 0;
    while i < ArraySize(projectileLauncherRound) {
      partSlots = projectileLauncherRound[i];
      if Equals(partSlots.status, ESlotState.Taken) && partSlots.slotID == t"AttachmentSlots.ProjectileLauncherRound" {
        installedProjectile = partSlots.installedPart;
      };
      i += 1;
    };
    return false;
  }

  protected final const func GetMaxChargeThreshold(const scriptInterface: ref<StateGameScriptInterface>) -> Float {
    let weapon: wref<WeaponObject> = this.GetLeftHandWeaponObject(scriptInterface);
    if scriptInterface.HasStatFlag(gamedataStatType.CanOverchargeWeapon) {
      return WeaponObject.GetOverchargeThreshold(weapon);
    };
    if scriptInterface.HasStatFlag(gamedataStatType.CanFullyChargeWeapon) {
      return WeaponObject.GetFullyChargedThreshold(weapon);
    };
    return WeaponObject.GetBaseMaxChargeThreshold(weapon);
  }

  protected final func PlayEffect(effectName: CName, scriptInterface: ref<StateGameScriptInterface>, opt eventTag: CName) -> Void {
    let spawnEffectEvent: ref<entSpawnEffectEvent>;
    let weapon: wref<WeaponObject> = this.GetLeftHandWeaponObject(scriptInterface);
    if IsDefined(weapon) {
      spawnEffectEvent = new entSpawnEffectEvent();
      spawnEffectEvent.effectName = effectName;
      spawnEffectEvent.effectInstanceName = eventTag;
      weapon.QueueEventToChildItems(spawnEffectEvent);
    };
  }

  protected final func StopEffect(effectName: CName, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let killEffectEvent: ref<entKillEffectEvent>;
    let weapon: wref<WeaponObject> = this.GetLeftHandWeaponObject(scriptInterface);
    if IsDefined(weapon) {
      killEffectEvent = new entKillEffectEvent();
      killEffectEvent.effectName = effectName;
      weapon.QueueEventToChildItems(killEffectEvent);
    };
  }

  protected final func SetAnimFeatureState(stateContext: ref<StateContext>, value: Int32) -> Void {
    stateContext.SetPermanentIntParameter(n"state", value, true);
  }

  protected final func SetActionDuration(stateContext: ref<StateContext>, value: Float) -> Void {
    stateContext.SetPermanentFloatParameter(n"actionDuration", value, true);
  }

  protected final func SetIsQuickAction(stateContext: ref<StateContext>, value: Bool) -> Void {
    stateContext.SetPermanentBoolParameter(n"isQuickAction", value, true);
  }

  protected final func SetIsCharging(stateContext: ref<StateContext>, value: Bool) -> Void {
    stateContext.SetPermanentBoolParameter(n"isChargeAction", value, true);
  }

  protected final func SetIsLooping(stateContext: ref<StateContext>, value: Bool) -> Void {
    stateContext.SetPermanentBoolParameter(n"isLoopAction", value, true);
  }

  protected final func SetIsCatching(stateContext: ref<StateContext>, value: Bool) -> Void {
    stateContext.SetPermanentBoolParameter(n"isCatchAction", value, true);
  }

  protected final func SetIsSafeAction(stateContext: ref<StateContext>, value: Bool) -> Void {
    stateContext.SetPermanentBoolParameter(n"isSafeAction", value, true);
  }

  protected final func SetIsProjectileCaught(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, value: Bool) -> Void {
    this.SetBlackboardBoolVariable(scriptInterface, GetAllBlackboardDefs().LeftHandCyberware.ProjectileCaught, value);
  }

  protected final func ResetAnimFeatureParameters(stateContext: ref<StateContext>) -> Void {
    stateContext.SetPermanentFloatParameter(n"actionDuration", -1.00, true);
    stateContext.SetPermanentIntParameter(n"state", 0, true);
    stateContext.SetPermanentBoolParameter(n"isQuickAction", false, true);
    stateContext.SetPermanentBoolParameter(n"isChargeAction", false, true);
    stateContext.SetPermanentBoolParameter(n"isLoopAction", false, true);
    stateContext.SetPermanentBoolParameter(n"isCatchAction", false, true);
    stateContext.SetPermanentBoolParameter(n"isSafeAction", false, true);
  }

  protected final const func GetMaxActiveTime(const scriptInterface: ref<StateGameScriptInterface>) -> Float {
    let equipmentSystem: ref<EquipmentSystem> = GameInstance.GetScriptableSystemsContainer(scriptInterface.owner.GetGame()).Get(n"EquipmentSystem") as EquipmentSystem;
    return CyberwareUtility.GetMaxActiveTimeFromTweak(ItemID.GetTDBID(equipmentSystem.GetPlayerData(scriptInterface.executionOwner).GetActiveItem(gamedataEquipmentArea.QuickWheel)));
  }

  protected final const func ShouldInstantlyUnequipCyberware(const scriptInterface: ref<StateGameScriptInterface>, const stateContext: ref<StateContext>) -> Bool {
    return !this.IsUsingCyberwareAllowed(stateContext, scriptInterface);
  }

  protected final const func IsUsingCyberwareAllowed(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    let vehicleState: CName;
    if this.IsNoCombatActionsForced(scriptInterface) {
      return false;
    };
    if this.IsUsingFirearmsForced(scriptInterface) {
      return false;
    };
    if this.IsUsingFistsForced(scriptInterface) {
      return false;
    };
    if this.IsUsingMeleeForced(scriptInterface) {
      return false;
    };
    if this.IsInLocomotionState(stateContext, n"superheroFall") {
      return false;
    };
    if this.IsInLocomotionState(stateContext, n"vault") {
      return false;
    };
    if this.IsInLocomotionState(stateContext, n"climb") {
      return false;
    };
    if this.IsInLadderState(stateContext) {
      return false;
    };
    if stateContext.IsStateMachineActive(n"Vehicle") {
      vehicleState = stateContext.GetStateMachineCurrentState(n"Vehicle");
      if NotEquals(vehicleState, n"exit") && NotEquals(vehicleState, n"coolExiting") && NotEquals(vehicleState, n"slideExiting") {
        return false;
      };
    };
    if stateContext.IsStateMachineActive(n"CarriedObject") {
      return false;
    };
    if stateContext.IsStateMachineActive(n"LocomotionSwimming") {
      return false;
    };
    if stateContext.IsStateMachineActive(n"LocomotionTakedown") {
      return false;
    };
    if this.IsInLocomotionState(stateContext, n"vehicleKnockdown") {
      return false;
    };
    if this.IsInLocomotionState(stateContext, n"hardLand") || this.IsInLocomotionState(stateContext, n"veryHardLand") {
      return false;
    };
    return true;
  }

  protected final func AimSnap(scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let targetingSystem: ref<TargetingSystem> = scriptInterface.GetTargetingSystem();
    if IsDefined(targetingSystem) {
      targetingSystem.OnAimStartBegin(scriptInterface.executionOwner);
      targetingSystem.OnAimStartEnd(scriptInterface.executionOwner);
      targetingSystem.AimSnap(scriptInterface.executionOwner);
    };
  }

  protected final func EndAiming(scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let targetingSystem: ref<TargetingSystem> = scriptInterface.GetTargetingSystem();
    if IsDefined(targetingSystem) {
      targetingSystem.OnAimStop(scriptInterface.executionOwner);
    };
  }

  protected final const func HasProjectileLauncherWithStatFlag(scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    if this.LeftHandCyberwareHasTag(scriptInterface, n"ProjectileLauncher") && RPGManager.HasStatFlag(scriptInterface.executionOwner, gamedataStatType.CanUseNewMeleewareAttackSpyTree) {
      return true;
    };
    return false;
  }
}

public abstract class LeftHandCyberwareEventsTransition extends LeftHandCyberwareTransition {

  public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.LockLeftHandAnimation(scriptInterface, true);
    this.CreateAndSendAnimFeatureData(stateContext, scriptInterface);
  }

  public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.CreateAndSendAnimFeatureData(stateContext, scriptInterface);
  }

  public func OnForcedExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.CleanUpLeftHandCyberwareState(stateContext, scriptInterface);
    this.CreateAndSendAnimFeatureData(stateContext, scriptInterface);
  }

  protected func CleanUpLeftHandCyberwareState(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.AttachAndPreviewProjectile(scriptInterface, false);
    this.SetLeftHandItemTypeAndState(scriptInterface, 0, 0);
    this.LockLeftHandAnimation(scriptInterface, false);
    this.SetIsCharging(stateContext, false);
    stateContext.RemovePermanentBoolParameter(n"forceTempUnequipWeapon");
    this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.LeftHandCyberware, 0);
    this.SetAnimEquipState(scriptInterface, false);
    this.SendEquipmentSystemWeaponManipulationRequest(scriptInterface, EquipmentManipulationAction.UnequipLeftHandCyberware, gameEquipAnimationType.Instant);
    this.ResetAnimFeatureParameters(stateContext);
  }
}

public class LeftHandCyberwareSafeDecisions extends LeftHandCyberwareTransition {

  protected final const func EnterCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    if this.IsSafeStateForced(stateContext, scriptInterface) {
      return true;
    };
    if (scriptInterface.executionOwner as PlayerPuppet).IsAimingAtFriendly() {
      return true;
    };
    if this.IsInVisionModeActiveState(stateContext, scriptInterface) && this.GetInStateTime() > 0.10 {
      return true;
    };
    if StatusEffectSystem.ObjectHasStatusEffectOfType(scriptInterface.executionOwner, gamedataStatusEffectType.Stunned) {
      return true;
    };
    return false;
  }

  protected final const func ToLeftHandCyberwareUnequip(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    if this.GetInStateTime() >= this.GetStaticFloatParameterDefault("stateDuration", 2.00) {
      return true;
    };
    return this.ShouldInstantlyUnequipCyberware(scriptInterface, stateContext);
  }
}

public class LeftHandCyberwareSafeEvents extends LeftHandCyberwareEventsTransition {

  public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    scriptInterface.PushAnimationEvent(n"LeftHandCyberwareReady");
    this.SetAnimFeatureState(stateContext, 1);
    this.SetIsSafeAction(stateContext, true);
    this.LockLeftHandAnimation(scriptInterface, true);
    this.SetActionDuration(stateContext, this.GetStaticFloatParameterDefault("stateDuration", 2.00));
    this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.LeftHandCyberware, 1);
    super.OnEnter(stateContext, scriptInterface);
  }

  public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.SetIsSafeAction(stateContext, false);
    super.OnExit(stateContext, scriptInterface);
  }
}

public class LeftHandCyberwareEquipDecisions extends LeftHandCyberwareTransition {

  protected final const func ToLeftHandCyberwareCharge(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    if scriptInterface.IsActionHeld(n"UseCombatGadget") && this.LeftHandCyberwareHasTag(scriptInterface, n"ChargeAction") {
      return true;
    };
    return false;
  }

  protected final const func ToLeftHandCyberwareUnequip(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    return this.ShouldInstantlyUnequipCyberware(scriptInterface, stateContext);
  }
}

public class LeftHandCyberwareEquipEvents extends LeftHandCyberwareEventsTransition {

  public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let evt: ref<LeftHandCyberwareEquippedEvent>;
    let dpadAction: ref<DPADActionPerformed> = new DPADActionPerformed();
    dpadAction.ownerID = scriptInterface.executionOwnerEntityID;
    dpadAction.action = EHotkey.RB;
    dpadAction.state = EUIActionState.STARTED;
    dpadAction.stateInt = EnumInt(dpadAction.state);
    dpadAction.successful = true;
    scriptInterface.GetUISystem().QueueEvent(dpadAction);
    evt = new LeftHandCyberwareEquippedEvent();
    scriptInterface.owner.QueueEvent(evt);
    this.ResetAnimFeatureParameters(stateContext);
    this.SetLeftHandItemTypeAndState(scriptInterface, 2, 2);
    this.ForceDisableVisionMode(stateContext);
    stateContext.SetTemporaryBoolParameter(n"InterruptAiming", true, true);
    if this.IsRightHandInEquippedState(stateContext) {
      stateContext.SetPermanentBoolParameter(n"forceTempUnequipWeapon", true, true);
    };
    this.SetAnimFeatureState(stateContext, 1);
    this.SetAnimEquipState(scriptInterface, true);
    this.LockLeftHandAnimation(scriptInterface, true);
    this.SetActionDuration(stateContext, this.GetEquipDuration(scriptInterface));
    this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.LeftHandCyberware, 4);
    super.OnEnter(stateContext, scriptInterface);
  }

  public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    scriptInterface.PushAnimationEvent(n"LeftHandCyberwareReady");
    super.OnExit(stateContext, scriptInterface);
  }
}

public class LeftHandCyberwareChargeDecisions extends LeftHandCyberwareTransition {

  protected final const func ToLeftHandCyberwareChargeAction(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    if scriptInterface.IsActionJustReleased(n"UseCombatGadget") || scriptInterface.IsActionJustPressed(n"RangedAttack") {
      return !(scriptInterface.executionOwner as PlayerPuppet).IsAimingAtFriendly() && !(this.HasProjectileLauncherWithStatFlag(scriptInterface) && this.WeaponIsCharged(scriptInterface));
    };
    return false;
  }

  protected final func ToLeftHandCyberwareChargeRepeatAction(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    if scriptInterface.IsActionJustReleased(n"UseCombatGadget") || scriptInterface.IsActionJustPressed(n"RangedAttack") {
      return !(scriptInterface.executionOwner as PlayerPuppet).IsAimingAtFriendly() && this.HasProjectileLauncherWithStatFlag(scriptInterface) && this.WeaponIsCharged(scriptInterface);
    };
    return false;
  }

  protected final const func ToLeftHandCyberwareWaitForUnequip(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    if scriptInterface.IsActionJustReleased(n"UseCombatGadget") || scriptInterface.IsActionJustPressed(n"RangedAttack") && (scriptInterface.executionOwner as PlayerPuppet).IsAimingAtFriendly() {
      return true;
    };
    if this.GetInStateTime() >= this.GetStaticFloatParameterDefault("stateDuration", 1.00) && (this.GetCancelChargeButtonInput(scriptInterface) || scriptInterface.IsActionJustPressed(n"SwitchItem")) {
      return true;
    };
    if scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Vision) == 1 {
      return true;
    };
    if StatusEffectSystem.ObjectHasStatusEffectOfType(scriptInterface.executionOwner, gamedataStatusEffectType.Knockdown) {
      return true;
    };
    return false;
  }

  protected final const func ToLeftHandCyberwareUnequip(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    return this.ShouldInstantlyUnequipCyberware(scriptInterface, stateContext);
  }
}

public class LeftHandCyberwareChargeEvents extends LeftHandCyberwareEventsTransition {

  private let m_chargeModeAim: ref<AnimFeature_AimPlayer>;

  private let m_leftHandObject: wref<WeaponObject>;

  private let m_aimInTimeRemaining: Float;

  protected final func UpdateChargeModeCameraAimAnimFeature(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    if !IsDefined(this.m_chargeModeAim) {
      this.m_chargeModeAim = new AnimFeature_AimPlayer();
    };
    this.m_chargeModeAim.SetAimState(animAimState.Aimed);
    this.m_chargeModeAim.SetZoomState(animAimState.Aimed);
    this.m_chargeModeAim.SetAimInTime(scriptInterface.GetStatsSystem().GetStatValue(Cast<StatsObjectID>(this.m_leftHandObject.GetEntityID()), gamedataStatType.AimInTime));
    this.m_chargeModeAim.SetAimOutTime(scriptInterface.GetStatsSystem().GetStatValue(Cast<StatsObjectID>(this.m_leftHandObject.GetEntityID()), gamedataStatType.AimOutTime));
    scriptInterface.SetAnimationParameterFeature(n"AnimFeature_AimPlayer", this.m_chargeModeAim);
    scriptInterface.SetAnimationParameterFeature(n"AnimFeature_AimPlayer", this.m_chargeModeAim, this.m_leftHandObject);
  }

  protected final func ResetChargeModeCameraAimAnimFeature(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.m_chargeModeAim.SetAimState(animAimState.Unaimed);
    this.m_chargeModeAim.SetZoomState(animAimState.Unaimed);
    scriptInterface.SetAnimationParameterFeature(n"AnimFeature_AimPlayer", this.m_chargeModeAim);
    scriptInterface.SetAnimationParameterFeature(n"AnimFeature_AimPlayer", this.m_chargeModeAim, this.m_leftHandObject);
  }

  protected final func GetChargeValuePerSec(scriptInterface: ref<StateGameScriptInterface>) -> Float {
    let chargeDuration: Float;
    let weapon: ref<WeaponObject>;
    let statsSystem: ref<StatsSystem> = scriptInterface.GetStatsSystem();
    if !IsDefined(statsSystem) {
      return -1.00;
    };
    weapon = this.GetLeftHandWeaponObject(scriptInterface);
    if !IsDefined(weapon) {
      return -1.00;
    };
    chargeDuration = statsSystem.GetStatValue(Cast<StatsObjectID>(weapon.GetEntityID()), gamedataStatType.ChargeTime);
    if chargeDuration <= 0.00 {
      return -1.00;
    };
    return 100.00 / chargeDuration;
  }

  protected final func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let chargeNormalized: Float;
    let hasCWPerk: Bool = this.HasMeleewarePerkStatFlag(scriptInterface);
    let maxCharge: Float = this.GetMaxChargeThreshold(scriptInterface);
    let currentCharge: Float = scriptInterface.GetStatPoolsSystem().GetStatPoolValue(Cast<StatsObjectID>(this.GetLeftHandWeaponObject(scriptInterface).GetEntityID()), gamedataStatPoolType.WeaponCharge);
    if maxCharge > 0.00 {
      chargeNormalized = ClampF(currentCharge / maxCharge, 0.00, 1.00);
    };
    this.UpdateAndSendChargeAnimData(chargeNormalized, hasCWPerk, stateContext, scriptInterface);
    if !this.WeaponIsCharged(scriptInterface) && chargeNormalized >= 1.00 {
      DefaultTransition.PlayRumble(scriptInterface, "heavy_pulse");
      this.PlayEffect(n"charged", scriptInterface);
      this.GetLeftHandWeaponObject(scriptInterface).SetCharged(true);
      if hasCWPerk {
        GameObjectEffectHelper.StartEffectEvent(scriptInterface.executionOwner, n"RelicTree_Meleeware_PowerUp", true);
        GameObjectEffectHelper.StartEffectEvent(this.GetLeftHandWeaponObject(scriptInterface), n"RelicTree_Meleeware_ChargeIndicator_Launcher", true);
        GameObject.PlaySoundEvent(this.GetLeftHandWeaponObject(scriptInterface), n"w_cyb_launcher_spy_perk_charged");
      };
    };
    if this.m_aimInTimeRemaining > 0.00 {
      this.m_aimInTimeRemaining -= timeDelta;
      this.SetBlackboardFloatVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.AimInTimeRemaining, this.m_aimInTimeRemaining);
    };
    this.UpdateChargeModeCameraAimAnimFeature(stateContext, scriptInterface);
  }

  public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let chargeValuePerSec: Float;
    let maxCharge: Float;
    let chargeEvt: ref<ChargeStartedEvent> = new ChargeStartedEvent();
    scriptInterface.owner.QueueEvent(chargeEvt);
    this.m_leftHandObject = scriptInterface.GetTransactionSystem().GetItemInSlot(scriptInterface.executionOwner, t"AttachmentSlots.WeaponLeft") as WeaponObject;
    this.SetZoomStateAnimFeature(scriptInterface, true);
    this.SetActionDuration(stateContext, this.GetStaticFloatParameterDefault("stateDuration", 1.00));
    this.AimSnap(scriptInterface);
    this.m_aimInTimeRemaining = 0.50;
    this.SetBlackboardFloatVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.AimInTimeRemaining, this.m_aimInTimeRemaining);
    this.SetBlackboardFloatVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.AimInTime, this.m_aimInTimeRemaining);
    this.SetIsCharging(stateContext, true);
    if this.LeftHandCyberwareHasTag(scriptInterface, n"ProjectileLauncher") {
      if this.HasMeleewarePerkStatFlag(scriptInterface) {
        this.TurnOnOvercharge(scriptInterface);
      };
      maxCharge = this.GetMaxChargeThreshold(scriptInterface);
      this.m_leftHandObject.SetMaxChargeThreshold(maxCharge);
      chargeValuePerSec = this.GetChargeValuePerSec(scriptInterface);
      this.StartPool(scriptInterface.GetStatPoolsSystem(), this.GetLeftHandWeaponObject(scriptInterface).GetEntityID(), gamedataStatPoolType.WeaponCharge, 0.00, maxCharge, chargeValuePerSec);
      this.PlayEffect(n"charging", scriptInterface);
    };
    this.SetAnimFeatureState(stateContext, 2);
    this.AttachAndPreviewProjectile(scriptInterface, true);
    this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.LeftHandCyberware, 5);
    stateContext.SetTemporaryBoolParameter(n"InterruptSprint", true, true);
    super.OnEnter(stateContext, scriptInterface);
  }

  public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let chargeEvt: ref<ChargeEndedEvent> = new ChargeEndedEvent();
    scriptInterface.owner.QueueEvent(chargeEvt);
    this.StopPool(scriptInterface.GetStatPoolsSystem(), this.GetLeftHandWeaponObject(scriptInterface).GetEntityID(), gamedataStatPoolType.WeaponCharge, false);
    this.StopEffect(n"charging", scriptInterface);
    this.StopEffect(n"charged", scriptInterface);
    GameObjectEffectHelper.BreakEffectLoopEvent(scriptInterface.executionOwner, n"RelicTree_Meleeware_PowerUp");
    GameObjectEffectHelper.BreakEffectLoopEvent(scriptInterface.executionOwner, n"RelicTree_Meleeware_ChargeIndicator_Launcher");
    this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.LeftHandCyberware, 5);
    this.ResetChargeModeCameraAimAnimFeature(stateContext, scriptInterface);
    this.SetZoomStateAnimFeature(scriptInterface, false);
    this.AttachAndPreviewProjectile(scriptInterface, false);
    this.EndAiming(scriptInterface);
    this.OnExitCommon(stateContext, scriptInterface);
    super.OnExit(stateContext, scriptInterface);
  }

  public func OnForcedExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.ResetChargeModeCameraAimAnimFeature(stateContext, scriptInterface);
    this.SetZoomStateAnimFeature(scriptInterface, false);
    this.AttachAndPreviewProjectile(scriptInterface, false);
    this.EndAiming(scriptInterface);
    this.StopPool(scriptInterface.GetStatPoolsSystem(), this.GetLeftHandWeaponObject(scriptInterface).GetEntityID(), gamedataStatPoolType.WeaponCharge, false);
    this.StopEffect(n"charging", scriptInterface);
    this.StopEffect(n"charged", scriptInterface);
    GameObjectEffectHelper.BreakEffectLoopEvent(scriptInterface.executionOwner, n"RelicTree_Meleeware_PowerUp");
    GameObjectEffectHelper.BreakEffectLoopEvent(scriptInterface.executionOwner, n"RelicTree_Meleeware_ChargeIndicator_Launcher");
    this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.LeftHandCyberware, 5);
    this.OnExitCommon(stateContext, scriptInterface);
    super.OnForcedExit(stateContext, scriptInterface);
  }

  public final func OnExitCommon(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.TurnOFFOvercharge(scriptInterface);
  }
}

public class LeftHandCyberwareLoopDecisions extends LeftHandCyberwareTransition {

  protected final const func EnterCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    if scriptInterface.GetActionValue(n"UseCombatGadget") == 0.00 && this.LeftHandCyberwareHasTag(scriptInterface, n"LoopAction") {
      return true;
    };
    return false;
  }

  protected final const func ToLeftHandCyberwareWaitForUnequip(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    if scriptInterface.IsActionJustPressed(n"UseCombatGadget") {
      return true;
    };
    if stateContext.GetBoolParameter(n"InterruptLeftHandAction") {
      return true;
    };
    if this.GetMaxActiveTime(scriptInterface) > 0.00 && this.GetInStateTime() > this.GetMaxActiveTime(scriptInterface) {
      return true;
    };
    return false;
  }

  protected final const func ToLeftHandCyberwareUnequip(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    return this.ShouldInstantlyUnequipCyberware(scriptInterface, stateContext);
  }
}

public class LeftHandCyberwareLoopEvents extends LeftHandCyberwareEventsTransition {

  public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let evt: ref<LoopStartedEvent> = new LoopStartedEvent();
    scriptInterface.owner.QueueEvent(evt);
    this.SetActionDuration(stateContext, this.GetStaticFloatParameterDefault("stateDuration", 1.00));
    this.SetAnimFeatureState(stateContext, 2);
    this.SetIsLooping(stateContext, true);
    scriptInterface.PushAnimationEvent(n"LeftHandCyberwareLoopAction");
    this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.LeftHandCyberware, 6);
    super.OnEnter(stateContext, scriptInterface);
  }

  public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let evt: ref<LoopEndedEvent> = new LoopEndedEvent();
    scriptInterface.owner.QueueEvent(evt);
    this.SetIsLooping(stateContext, false);
    scriptInterface.PushAnimationEvent(n"LeftHandCyberwareLoopActionEnd");
    super.OnExit(stateContext, scriptInterface);
  }
}

public abstract class LeftHandCyberwareActionAbstractDecisions extends LeftHandCyberwareTransition {

  protected const func ToLeftHandCyberwareWaitForUnequip(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    if stateContext.GetBoolParameter(n"InterruptLeftHandAction") {
      return true;
    };
    if this.GetInStateTime() >= this.GetStaticFloatParameterDefault("stateDuration", 1.00) {
      return true;
    };
    return false;
  }
}

public abstract class LeftHandCyberwareActionAbstractEvents extends LeftHandCyberwareEventsTransition {

  @default(LeftHandCyberwareActionAbstractEvents, false)
  public let m_projectileReleased: Bool;

  protected func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    if this.GetInStateTime() >= this.GetStaticFloatParameterDefault("projectileDetachDelay", 0.00) && !this.m_projectileReleased {
      this.DetachProjectile(scriptInterface);
      this.m_projectileReleased = true;
    };
  }

  public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let dpadAction: ref<DPADActionPerformed> = new DPADActionPerformed();
    dpadAction.ownerID = scriptInterface.executionOwnerEntityID;
    dpadAction.action = EHotkey.RB;
    dpadAction.state = EUIActionState.COMPLETED;
    dpadAction.stateInt = EnumInt(dpadAction.state);
    dpadAction.successful = true;
    scriptInterface.GetUISystem().QueueEvent(dpadAction);
    this.m_projectileReleased = false;
    this.SetActionDuration(stateContext, this.GetStaticFloatParameterDefault("stateDuration", 1.00));
    super.OnEnter(stateContext, scriptInterface);
  }

  public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    super.OnExit(stateContext, scriptInterface);
  }

  protected final func ConsumeStamina(scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let staminaCostMods: array<wref<StatModifier_Record>>;
    let staminaCost: Float = 0.00;
    let weapon: wref<WeaponObject> = this.GetLeftHandWeaponObject(scriptInterface);
    let attackRecord: wref<Attack_Record> = weapon.GetCurrentAttack().GetRecord();
    attackRecord.StaminaCost(staminaCostMods);
    staminaCost = RPGManager.CalculateStatModifiers(staminaCostMods, scriptInterface.GetGame(), scriptInterface.owner, Cast<StatsObjectID>(scriptInterface.ownerEntityID));
    if staminaCost > 0.00 && !StatusEffectSystem.ObjectHasStatusEffectWithTag(scriptInterface.executionOwner, n"FocusedCoolPerkSE") {
      PlayerStaminaHelpers.ModifyStamina(scriptInterface.executionOwner as PlayerPuppet, -staminaCost);
    };
  }
}

public class LeftHandCyberwareQuickActionDecisions extends LeftHandCyberwareActionAbstractDecisions {

  protected final const func EnterCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    if scriptInterface.GetActionValue(n"UseCombatGadget") == 0.00 && this.LeftHandCyberwareHasTag(scriptInterface, n"QuickAction") {
      return true;
    };
    return false;
  }

  protected final const func ToLeftHandCyberwareUnequip(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    if stateContext.GetBoolParameter(n"InterruptLeftHandAction") {
      return true;
    };
    if this.GetInStateTime() >= this.GetEquipDuration(scriptInterface) {
      return true;
    };
    return this.ShouldInstantlyUnequipCyberware(scriptInterface, stateContext);
  }
}

public class LeftHandCyberwareQuickActionEvents extends LeftHandCyberwareActionAbstractEvents {

  public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let evt: ref<QuickActionEvent> = new QuickActionEvent();
    this.SetActionDuration(stateContext, this.GetEquipDuration(scriptInterface));
    this.AttachAndPreviewProjectile(scriptInterface, true);
    this.AimSnap(scriptInterface);
    this.SetIsQuickAction(stateContext, true);
    this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.LeftHandCyberware, 8);
    this.ConsumeStamina(scriptInterface);
    scriptInterface.owner.QueueEvent(evt);
    DefaultTransition.PlayRumble(scriptInterface, "light_fast");
    super.OnEnter(stateContext, scriptInterface);
  }

  public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.DrainLeftHandWeaponCharge(scriptInterface, this.GetWeaponChargeCost(scriptInterface));
    this.EndAiming(scriptInterface);
    this.AttachAndPreviewProjectile(scriptInterface, false);
    this.SetIsQuickAction(stateContext, false);
    super.OnExit(stateContext, scriptInterface);
  }

  public func OnForcedExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.DrainLeftHandWeaponCharge(scriptInterface, this.GetWeaponChargeCost(scriptInterface));
    this.EndAiming(scriptInterface);
    super.OnForcedExit(stateContext, scriptInterface);
  }
}

public class LeftHandCyberwareChargeActionDecisions extends LeftHandCyberwareActionAbstractDecisions {

  protected final const func ToLeftHandCyberwareUnequip(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    if stateContext.GetBoolParameter(n"InterruptLeftHandAction") {
      return true;
    };
    if this.GetInStateTime() >= this.GetStaticFloatParameterDefault("stateDuration", 0.30) {
      return true;
    };
    return this.ShouldInstantlyUnequipCyberware(scriptInterface, stateContext);
  }
}

public class LeftHandCyberwareChargeActionEvents extends LeftHandCyberwareActionAbstractEvents {

  public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.LeftHandCyberware, 9);
    this.ConsumeStamina(scriptInterface);
    scriptInterface.PushAnimationEvent(n"LeftHandCyberwareChargeAction");
    DefaultTransition.PlayRumble(scriptInterface, "heavy_pulse");
    super.OnEnter(stateContext, scriptInterface);
  }

  public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.DrainLeftHandWeaponCharge(scriptInterface, this.GetWeaponChargeCost(scriptInterface));
    super.OnExit(stateContext, scriptInterface);
  }
}

public class LeftHandCyberwareChargeRepeatActionDecisions extends LeftHandCyberwareActionAbstractDecisions {

  protected const func ToLeftHandCyberwareWaitForUnequip(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    let projectilesReleased: StateResultInt = stateContext.GetPermanentIntParameter(n"projectilesReleased");
    let m_maxProjectiles: Int32 = this.GetStaticIntParameterDefault("maxProjectiles", 3);
    if this.ShouldInstantlyUnequipCyberware(scriptInterface, stateContext) {
      return true;
    };
    if stateContext.GetBoolParameter(n"InterruptLeftHandAction") {
      return true;
    };
    return projectilesReleased.valid && projectilesReleased.value >= m_maxProjectiles;
  }

  protected final const func ToLeftHandCyberwareChargeRepeatAction(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    let projectilesReleased: StateResultInt = stateContext.GetPermanentIntParameter(n"projectilesReleased");
    let m_maxProjectiles: Int32 = this.GetStaticIntParameterDefault("maxProjectiles", 3);
    if this.GetInStateTime() >= this.GetStaticFloatParameterDefault("stateDuration", 0.30) {
      return projectilesReleased.valid && projectilesReleased.value < m_maxProjectiles;
    };
    return false;
  }
}

public class LeftHandCyberwareChargeRepeatActionEvents extends LeftHandCyberwareActionAbstractEvents {

  public let m_maxSpread: Float;

  public let m_maxProjectiles: Int32;

  protected func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let spread: Float;
    let projectilesReleased: StateResultInt = stateContext.GetPermanentIntParameter(n"projectilesReleased");
    let delay: Float = this.GetStaticFloatParameterDefault("projectileDetachDelay", 0.00);
    if projectilesReleased.valid && this.GetInStateTime() >= delay && !this.m_projectileReleased && projectilesReleased.value < this.m_maxProjectiles {
      spread = this.m_maxSpread - (Cast<Float>(projectilesReleased.value) * this.m_maxSpread) / Cast<Float>(this.m_maxProjectiles - 1) * 2.00;
      this.DetachProjectile(scriptInterface, spread);
      this.m_projectileReleased = true;
      stateContext.SetPermanentIntParameter(n"projectilesReleased", projectilesReleased.value + 1, true);
    };
  }

  public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let projectilesReleased: StateResultInt = stateContext.GetPermanentIntParameter(n"projectilesReleased");
    let evt: ref<QuickActionEvent> = new QuickActionEvent();
    this.m_maxSpread = (this.GetStaticFloatParameterDefault("maxSpread", 45.00) * 3.14) / 360.00;
    this.m_maxProjectiles = this.GetStaticIntParameterDefault("maxProjectiles", 5);
    this.SetActionDuration(stateContext, this.GetEquipDuration(scriptInterface));
    this.AttachAndPreviewProjectile(scriptInterface, true);
    this.AimSnap(scriptInterface);
    this.SetIsQuickAction(stateContext, true);
    this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.LeftHandCyberware, 9);
    scriptInterface.owner.QueueEvent(evt);
    DefaultTransition.PlayRumble(scriptInterface, "light_fast");
    GameObjectEffectHelper.StartEffectEvent(this.GetLeftHandWeaponObject(scriptInterface), n"RelicTree_Meleeware_Attack_Launcher", true);
    if !projectilesReleased.valid {
      stateContext.SetPermanentIntParameter(n"projectilesReleased", 0, true);
    };
    scriptInterface.PushAnimationEvent(n"LeftHandCyberwareChargeRepeatAction");
    this.m_projectileReleased = false;
    if !Cast<Bool>(projectilesReleased.value) {
      this.DrainLeftHandWeaponCharge(scriptInterface, this.GetWeaponChargeCost(scriptInterface));
    };
    super.OnEnter(stateContext, scriptInterface);
  }

  public final func OnEnterFromLeftHandCyberwareCharge(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.StopEffect(n"charging", scriptInterface);
    this.StopEffect(n"charged", scriptInterface);
    this.OnEnter(stateContext, scriptInterface);
  }

  public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let projectilesReleased: StateResultInt = stateContext.GetPermanentIntParameter(n"projectilesReleased");
    this.EndAiming(scriptInterface);
    this.AttachAndPreviewProjectile(scriptInterface, false);
    this.SetIsQuickAction(stateContext, false);
    if Cast<Bool>(projectilesReleased.value) && projectilesReleased.value >= this.m_maxProjectiles {
      stateContext.SetPermanentIntParameter(n"projectilesReleased", 0, true);
      this.SetLeftHandWeaponCharged(scriptInterface, false);
    };
    GameObjectEffectHelper.BreakEffectLoopEvent(this.GetLeftHandWeaponObject(scriptInterface), n"RelicTree_Meleeware_ChargeIndicator_Launcher");
    super.OnExit(stateContext, scriptInterface);
  }

  public func OnForcedExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.EndAiming(scriptInterface);
    GameObjectEffectHelper.BreakEffectLoopEvent(this.GetLeftHandWeaponObject(scriptInterface), n"RelicTree_Meleeware_ChargeIndicator_Launcher");
    this.SetLeftHandWeaponCharged(scriptInterface, false);
    super.OnForcedExit(stateContext, scriptInterface);
  }
}

public class LeftHandCyberwareCatchActionEvents extends LeftHandCyberwareActionAbstractEvents {

  public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.LeftHandCyberware, 10);
    scriptInterface.PushAnimationEvent(n"LeftHandCyberwareCatchAction");
    super.OnEnter(stateContext, scriptInterface);
  }
}

public class LeftHandCyberwareCatchDecisions extends LeftHandCyberwareTransition {

  protected final const func EnterCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    if stateContext.GetBoolParameter(n"CatchMonodisc", true) {
      return true;
    };
    return false;
  }

  protected final const func ToLeftHandCyberwareWaitForUnequip(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    if stateContext.GetBoolParameter(n"InterruptLeftHandAction") {
      return true;
    };
    if this.GetInStateTime() >= this.GetStaticFloatParameterDefault("stateDuration", 1.20) {
      return true;
    };
    return false;
  }

  protected final const func ToLeftHandCyberwareCatchAction(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    return stateContext.GetConditionBool(n"LeftHandCyberwareCatchButtonPressed") && !stateContext.GetConditionBool(n"LeftHandCyberwareCatchWindowMissed");
  }
}

public class LeftHandCyberwareCatchEvents extends LeftHandCyberwareEventsTransition {

  public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    stateContext.SetConditionBoolParameter(n"LeftHandCyberwareCatchButtonPressed", false, true);
    stateContext.SetConditionBoolParameter(n"LeftHandCyberwareCatchWindowMissed", false, true);
    this.SetIsCatching(stateContext, true);
    this.SetAnimFeatureState(stateContext, 3);
    this.LockLeftHandAnimation(scriptInterface, true);
    scriptInterface.PushAnimationEvent(n"LeftHandCyberwareReady");
    stateContext.SetPermanentBoolParameter(n"CatchMonodisc", false, true);
    stateContext.SetTemporaryBoolParameter(n"DisableWeaponUI", true, true);
    this.SetIsProjectileCaught(stateContext, scriptInterface, true);
    this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.LeftHandCyberware, 7);
    super.OnEnter(stateContext, scriptInterface);
  }

  public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.SetIsCatching(stateContext, false);
    this.SetIsProjectileCaught(stateContext, scriptInterface, false);
    super.OnExit(stateContext, scriptInterface);
  }

  protected final func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let inStateTime: Float = this.GetInStateTime();
    let throwWindowStart: Float = this.GetStaticFloatParameterDefault("throwWindowStart", 0.35);
    let throwWindowEnd: Float = this.GetStaticFloatParameterDefault("throwWindowEnd", -1.00);
    if scriptInterface.IsActionJustPressed(n"UseCombatGadget") {
      if !stateContext.GetConditionBool(n"LeftHandCyberwareCatchButtonPressed") || !this.GetStaticBoolParameterDefault("preventButtonSpamming", false) {
        stateContext.SetConditionBoolParameter(n"LeftHandCyberwareCatchButtonPressed", true, true);
      };
    };
    if throwWindowStart >= 0.00 && inStateTime < throwWindowStart {
      if stateContext.GetConditionBool(n"LeftHandCyberwareCatchButtonPressed") {
        stateContext.SetConditionBoolParameter(n"LeftHandCyberwareCatchWindowMissed", true, true);
      };
    };
    if throwWindowEnd >= 0.00 && inStateTime > throwWindowEnd {
      if stateContext.GetConditionBool(n"LeftHandCyberwareCatchButtonPressed") {
        stateContext.SetConditionBoolParameter(n"LeftHandCyberwareCatchWindowMissed", true, true);
      };
    };
  }
}

public class LeftHandCyberwareWaitForUnequipDecisions extends LeftHandCyberwareTransition {

  protected final const func ToLeftHandCyberwareUnequip(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    if this.GetInStateTime() >= this.GetUnequipDuration(scriptInterface) {
      return true;
    };
    return this.ShouldInstantlyUnequipCyberware(scriptInterface, stateContext);
  }
}

public class LeftHandCyberwareWaitForUnequipEvents extends LeftHandCyberwareEventsTransition {

  public final func OnEnterFromLeftHandCyberwareCharge(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let dpadAction: ref<DPADActionPerformed> = new DPADActionPerformed();
    dpadAction.ownerID = scriptInterface.executionOwnerEntityID;
    dpadAction.action = EHotkey.RB;
    dpadAction.state = EUIActionState.ABORTED;
    dpadAction.stateInt = EnumInt(dpadAction.state);
    dpadAction.successful = false;
    scriptInterface.GetUISystem().QueueEvent(dpadAction);
    this.OnEnter(stateContext, scriptInterface);
  }

  public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.SetActionDuration(stateContext, this.GetUnequipDuration(scriptInterface));
    this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.LeftHandCyberware, 11);
    scriptInterface.PushAnimationEvent(n"LeftHandCyberwareWaitForUnequip");
    super.OnEnter(stateContext, scriptInterface);
  }

  public func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    super.OnExit(stateContext, scriptInterface);
  }

  public func OnForcedExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    super.OnForcedExit(stateContext, scriptInterface);
  }
}

public class LeftHandCyberwareUnequipEvents extends LeftHandCyberwareEventsTransition {

  public func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let evt: ref<LeftHandCyberwareUnequippedEvent> = new LeftHandCyberwareUnequippedEvent();
    scriptInterface.owner.QueueEvent(evt);
    this.CleanUpLeftHandCyberwareState(stateContext, scriptInterface);
    this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.LeftHandCyberware, 12);
  }
}
