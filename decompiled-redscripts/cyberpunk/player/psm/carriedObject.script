
public abstract class CarriedObjectTransition extends DefaultTransition {

  protected final func CanEquipFirearm(owner: ref<GameObject>, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    let playerData: ref<EquipmentSystemPlayerData>;
    let weaponID: ItemID;
    let itemType: gamedataItemType = gamedataItemType.Invalid;
    let equipmentSystem: ref<EquipmentSystem> = GameInstance.GetScriptableSystemsContainer(owner.GetGame()).Get(n"EquipmentSystem") as EquipmentSystem;
    if !IsDefined(equipmentSystem) {
      return false;
    };
    if this.IsInEmptyHandsState(stateContext) {
      return false;
    };
    playerData = equipmentSystem.GetPlayerData(owner);
    weaponID = playerData.GetLastUsedOrFirstAvailableOneHandedRangedWeapon();
    if ItemID.IsValid(weaponID) {
      itemType = RPGManager.GetItemType(weaponID);
      if Equals(itemType, gamedataItemType.Wea_Handgun) || Equals(itemType, gamedataItemType.Wea_Revolver) {
        return true;
      };
    };
    return false;
  }

  protected final func IsPlayerCombatAllowed(const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    if StatusEffectSystem.ObjectHasStatusEffectWithTag(scriptInterface.executionOwner, n"NoCombat") {
      return false;
    };
    if this.IsInTier2Locomotion(scriptInterface) {
      return false;
    };
    return true;
  }

  protected final func SetFastModeParameter(stateContext: ref<StateContext>, fastMode: Bool) -> Void {
    stateContext.SetPermanentBoolParameter(n"carriedObjectFastMode", fastMode, true);
  }

  protected final const func GetFastModeParameter(stateContext: ref<StateContext>) -> Bool {
    let fastModeResult: StateResultBool = stateContext.GetPermanentBoolParameter(n"carriedObjectFastMode");
    if fastModeResult.valid {
      return fastModeResult.value;
    };
    return false;
  }

  protected final func SetIsFriendlyCarryParameter(stateContext: ref<StateContext>, isFriendlyCarry: Bool) -> Void {
    stateContext.SetPermanentBoolParameter(n"carriedObjectIsFriendlyCarry", isFriendlyCarry, true);
  }

  protected final const func GetIsFriendlyCarryParameter(stateContext: ref<StateContext>) -> Bool {
    let isFriendlyCarryResult: StateResultBool = stateContext.GetPermanentBoolParameter(n"carriedObjectIsFriendlyCarry");
    if isFriendlyCarryResult.valid {
      return isFriendlyCarryResult.value;
    };
    return false;
  }

  public final static func HasRightHandWeaponActiveInSlot(owner: ref<GameObject>) -> Bool {
    let weaponItem: ItemID;
    if IsDefined(owner) {
      weaponItem = GameInstance.GetTransactionSystem(owner.GetGame()).GetActiveItemInSlot(owner, t"AttachmentSlots.WeaponRight");
      if ItemID.IsValid(weaponItem) {
        return true;
      };
    };
    return false;
  }
}

public abstract class CarriedObjectDecisions extends CarriedObjectTransition {

  public final const func ToRelease(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    return !scriptInterface.owner.IsAttached();
  }

  public final const func ToForceDropBody(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    let player: ref<PlayerPuppet>;
    let shouldDropBody: StateResultBool = stateContext.GetTemporaryBoolParameter(n"bodyCarryInteractionForceDrop");
    if shouldDropBody.valid {
      return shouldDropBody.value;
    };
    player = DefaultTransition.GetPlayerPuppet(scriptInterface);
    if player.IsDead() {
      return true;
    };
    if scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Vitals) == 1 || scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Vitals) == 2 {
      return true;
    };
    if scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Fall) == 3 {
      return true;
    };
    if (StatusEffectSystem.ObjectHasStatusEffectOfType(scriptInterface.executionOwner, gamedataStatusEffectType.Knockdown) || StatusEffectSystem.ObjectHasStatusEffectOfType(scriptInterface.executionOwner, gamedataStatusEffectType.VehicleKnockdown)) && !StatusEffectSystem.ObjectHasStatusEffectWithTag(scriptInterface.executionOwner, n"BodyCarryingNoDrop") {
      return true;
    };
    if !scriptInterface.HasStatFlag(gamedataStatType.CanShootWhileCarryingBody) && !this.IsInUpperBodyState(stateContext, n"forceEmptyHands") && scriptInterface.GetActionValue(n"RangedAttack") > 0.00 {
      return this.IsPlayerAllowedToDropBody(stateContext, scriptInterface);
    };
    if this.IsInHighLevelState(stateContext, n"swimming") {
      return true;
    };
    if this.IsForceBodyDropRequested(stateContext, scriptInterface) {
      return true;
    };
    return false;
  }

  protected final const func IsPlayerAllowedToDropBody(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    if StatusEffectSystem.ObjectHasStatusEffectWithTag(scriptInterface.executionOwner, n"BodyCarryingNoDrop") && !this.IsBodyDropForced(stateContext, scriptInterface) {
      return false;
    };
    if this.IsInInputContextState(stateContext, n"interactionContext") || this.IsInInputContextState(stateContext, n"uiRadialContext") {
      return false;
    };
    return true;
  }

  protected final const func IsBodyDropForced(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    if StatusEffectSystem.ObjectHasStatusEffectWithTag(scriptInterface.executionOwner, n"BodyCarryingForceDrop") {
      return true;
    };
    return false;
  }

  private final const func IsForceBodyDropRequested(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    let isForceDropBody: StateResultBool = stateContext.GetTemporaryBoolParameter(n"forceDropBody");
    if isForceDropBody.valid && isForceDropBody.value {
      return true;
    };
    return false;
  }
}

public abstract class CarriedObjectEvents extends CarriedObjectTransition {

  public let m_animFeature: ref<AnimFeature_Mounting>;

  public let m_animCarryFeature: ref<AnimFeature_Carry>;

  public let m_leftHandFeature: ref<AnimFeature_LeftHandAnimation>;

  public let m_AnimWrapperWeightSetterStrong: ref<AnimWrapperWeightSetter>;

  public let m_AnimWrapperWeightSetterFriendly: ref<AnimWrapperWeightSetter>;

  @default(CarriedObjectEvents, CarriedObject.Style)
  public let m_styleName: CName;

  @default(CarriedObjectEvents, CarriedObject.ForcedStyle)
  public let m_forceStyleName: CName;

  public let m_isFriendlyCarry: Bool;

  public let m_forcedCarryStyle: gamePSMBodyCarryingStyle;

  protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let mountEvent: ref<MountingRequest>;
    let slotId: MountingSlotId;
    let mountingInfo: MountingInfo = scriptInterface.GetMountingFacility().GetMountingInfoSingleWithObjects(scriptInterface.owner);
    let isNPCMounted: Bool = EntityID.IsDefined(mountingInfo.childId);
    if !isNPCMounted && !this.IsBodyDisposalOngoing(stateContext, scriptInterface) {
      mountEvent = new MountingRequest();
      slotId.id = n"leftShoulder";
      mountingInfo.childId = scriptInterface.ownerEntityID;
      mountingInfo.parentId = scriptInterface.executionOwnerEntityID;
      mountingInfo.slotId = slotId;
      mountEvent.lowLevelMountingInfo = mountingInfo;
      scriptInterface.GetMountingFacility().Mount(mountEvent);
      (scriptInterface.owner as NPCPuppet).MountingStartDisableComponents();
    };
    this.m_animFeature = new AnimFeature_Mounting();
    this.m_animFeature.mountingState = 2;
    this.UpdateCarryStylePickUpAndDropParams(stateContext, scriptInterface, false);
    this.m_forcedCarryStyle = gamePSMBodyCarryingStyle.Any;
    this.CalculateForcedCarryStyleAndIsFriendlyCarry(stateContext, scriptInterface);
    if IsDefined(scriptInterface.owner as gamePuppet) {
      this.UpdateCarryStylePickUpAndDropParams(stateContext, scriptInterface, this.m_isFriendlyCarry);
    };
    scriptInterface.SetAnimationParameterFeature(n"Mounting", this.m_animFeature, scriptInterface.executionOwner);
    scriptInterface.SetAnimationParameterFeature(n"Mounting", this.m_animFeature);
    (scriptInterface.owner as NPCPuppet).MountingStartDisableComponents();
  }

  protected func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void;

  protected func OnForcedExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.CleanUpCarryStateMachine(ECarryState.None, stateContext, scriptInterface);
  }

  protected final func IsBodyDisposalOngoing(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    return scriptInterface.localBlackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.CarryingDisposal);
  }

  protected final func UpdateCarryStylePickUpAndDropParams(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, isFriendly: Bool) -> Void {
    if Equals(this.GetStyle(stateContext), gamePSMBodyCarryingStyle.WoundedSoldier) {
      this.ApplyWoundedSoldierCarryGameplayRestrictions(stateContext, scriptInterface);
    } else {
      if isFriendly {
        this.UpdateGameplayRestrictions(stateContext, scriptInterface);
        stateContext.SetConditionBoolParameter(n"CarriedObjectPlayPickUp", false, true);
        this.SetBodyCarryFriendlyCameraContext(stateContext, scriptInterface, true);
        this.ApplyFriendlyCarryGameplayRestrictions(stateContext, scriptInterface);
      } else {
        this.UpdateGameplayRestrictions(stateContext, scriptInterface);
        stateContext.SetConditionBoolParameter(n"CarriedObjectPlayPickUp", true, true);
      };
    };
  }

  protected final func SetAnimFeature_Carry(state: ECarryState, instant: Bool, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, opt setExecutionOwnerOnly: Bool) -> Void {
    let isMultiplayer: Bool;
    let lockLeftHand: Bool;
    this.m_animCarryFeature = new AnimFeature_Carry();
    this.m_animCarryFeature.state = EnumInt(state);
    this.m_animCarryFeature.pickupAnimation = this.GetPickupAnimationParameter(stateContext);
    this.m_animCarryFeature.fastMode = this.GetFastModeParameter(stateContext);
    this.m_animCarryFeature.useBothHands = false;
    this.m_animCarryFeature.instant = instant;
    this.m_animCarryFeature.isCarryActive = true;
    this.m_animCarryFeature.isFriendlyCarry = this.m_isFriendlyCarry;
    this.m_animCarryFeature.wasThrown = this.GetWasThrownParameter(stateContext);
    if Equals(this.GetStyle(stateContext), gamePSMBodyCarryingStyle.WoundedSoldier) {
      this.m_animCarryFeature.useBothHands = false;
    } else {
      if NotEquals(state, ECarryState.None) && NotEquals(state, ECarryState.Release) {
        if Equals(this.GetStyle(stateContext), gamePSMBodyCarryingStyle.Strong) && Equals(state, ECarryState.Carry) {
          isMultiplayer = GameInstance.GetRuntimeInfo(scriptInterface.executionOwner.GetGame()).IsMultiplayer();
          if isMultiplayer {
            this.m_animCarryFeature.useBothHands = !CarriedObjectTransition.HasRightHandWeaponActiveInSlot(scriptInterface.executionOwner);
          } else {
            if !isMultiplayer && scriptInterface.HasStatFlag(gamedataStatType.CanShootWhileCarryingBody) {
              this.m_animCarryFeature.useBothHands = !this.CanEquipFirearm(scriptInterface.executionOwner, stateContext, scriptInterface);
            } else {
              this.m_animCarryFeature.useBothHands = true;
            };
          };
        } else {
          this.m_animCarryFeature.useBothHands = true;
        };
      };
    };
    scriptInterface.SetAnimationParameterFeature(n"Carry", this.m_animCarryFeature, scriptInterface.executionOwner);
    if !setExecutionOwnerOnly {
      scriptInterface.SetAnimationParameterFeature(n"Carry", this.m_animCarryFeature, scriptInterface.owner);
    };
    lockLeftHand = !this.m_animCarryFeature.useBothHands;
    this.SetAnimFeature_LeftHandAnimation(scriptInterface, lockLeftHand);
  }

  protected final func SetBodyPickUpCameraContext(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, value: Bool, opt skipCameraContextUpdate: Bool) -> Void {
    this.SetCameraContext(stateContext, scriptInterface, n"setBodyPickUpContext", value, skipCameraContextUpdate);
  }

  protected final func SetBodyCarryCameraContext(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, value: Bool, opt skipCameraContextUpdate: Bool) -> Void {
    this.SetCameraContext(stateContext, scriptInterface, n"setBodyCarryContext", value, skipCameraContextUpdate);
  }

  protected final func SetBodyCarryFriendlyCameraContext(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, value: Bool, opt skipCameraContextUpdate: Bool) -> Void {
    this.SetCameraContext(stateContext, scriptInterface, n"setBodyCarryFriendlyContext", value, skipCameraContextUpdate);
  }

  protected final func SetBodyCarryWoundedSoldierCameraContext(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, value: Bool, opt skipCameraContextUpdate: Bool) -> Void {
    this.SetCameraContext(stateContext, scriptInterface, n"setBodyCarryWoundedSoldierContext", value, skipCameraContextUpdate);
    if !value {
      StatusEffectHelper.RemoveStatusEffect(scriptInterface.executionOwner, t"GameplayRestriction.BodyCarryingWoundedSoldier");
      GameInstance.GetAudioSystem(scriptInterface.executionOwner.GetGame()).RemoveTriggerEffect(n"BlackWall_Somi_Ability");
    };
  }

  protected final func SetCameraContext(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, varName: CName, value: Bool, skipCameraContextUpdate: Bool) -> Void {
    let oldValue: Bool;
    if skipCameraContextUpdate {
      stateContext.SetPermanentBoolParameter(varName, value, true);
    } else {
      oldValue = stateContext.GetBoolParameter(varName, true);
      stateContext.SetPermanentBoolParameter(varName, value, true);
      if NotEquals(oldValue, value) {
        this.UpdateCameraParams(stateContext, scriptInterface);
      };
    };
  }

  protected final func SetStyle(style: gamePSMBodyCarryingStyle, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    stateContext.SetPermanentIntParameter(this.m_styleName, EnumInt(style), true);
    this.EnableAnimSet(Equals(style, gamePSMBodyCarryingStyle.Strong), n"carry_strong", scriptInterface);
    this.EnableAnimSet(Equals(style, gamePSMBodyCarryingStyle.Friendly), n"carry_friendly", scriptInterface);
    this.EnableAnimSet(Equals(style, gamePSMBodyCarryingStyle.WoundedSoldier), n"carry_woundedSoldier", scriptInterface);
  }

  protected final func SetForcedStyle(style: gamePSMBodyCarryingStyle, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    stateContext.SetPermanentIntParameter(this.m_forceStyleName, EnumInt(style), true);
    this.SetStyle(style, stateContext, scriptInterface);
  }

  protected final func ClearForcedStyle(stateContext: ref<StateContext>) -> Void {
    stateContext.RemovePermanentIntParameter(this.m_forceStyleName);
  }

  protected final func ClearStyleParameters(stateContext: ref<StateContext>) -> Void {
    stateContext.RemovePermanentIntParameter(this.m_forceStyleName);
    stateContext.RemovePermanentIntParameter(this.m_styleName);
  }

  protected final func SetAnimFeature_LeftHandAnimation(scriptInterface: ref<StateGameScriptInterface>, lockLeftHand: Bool) -> Void {
    this.m_leftHandFeature = new AnimFeature_LeftHandAnimation();
    this.m_leftHandFeature.lockLeftHandAnimation = lockLeftHand;
    scriptInterface.SetAnimationParameterFeature(n"LeftHandAnimation", this.m_leftHandFeature, scriptInterface.executionOwner);
  }

  protected final const func GetStyle(const stateContext: ref<StateContext>) -> gamePSMBodyCarryingStyle {
    return IntEnum<gamePSMBodyCarryingStyle>(stateContext.GetIntParameter(this.m_styleName, true));
  }

  private final func EnableAnimSet(enable: Bool, animSet: CName, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let ev: ref<AnimWrapperWeightSetter> = new AnimWrapperWeightSetter();
    ev.key = animSet;
    ev.value = enable ? 1.00 : 0.00;
    scriptInterface.owner.QueueEvent(ev);
    scriptInterface.executionOwner.QueueEvent(ev);
  }

  protected final func SetObjectInvulnerable(object: ref<GameObject>, enable: Bool) -> Void {
    if enable && !StatusEffectSystem.ObjectHasStatusEffect(object, t"BaseStatusEffect.Invulnerable") {
      StatusEffectHelper.ApplyStatusEffect(object, t"BaseStatusEffect.Invulnerable");
    } else {
      StatusEffectHelper.RemoveStatusEffect(object, t"BaseStatusEffect.Invulnerable");
    };
  }

  protected final func CleanUpCarryStateMachine(state: ECarryState, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let broadcaster: ref<StimBroadcasterComponent>;
    let mountEventData: ref<MountEventData>;
    let mountingInfo: MountingInfo;
    let setAnimFeatureOnExecutionOwnerOnly: Bool;
    let setPositionEvent: ref<SetBodyPositionEvent>;
    let player: ref<GameObject> = scriptInterface.executionOwner;
    let isSceneDropAnimation: StateResultBool = stateContext.GetTemporaryBoolParameter(n"bodyCarrySceneDropAnimation");
    let unmountingRequest: ref<UnmountingRequest> = new UnmountingRequest();
    mountingInfo.childId = scriptInterface.ownerEntityID;
    mountingInfo.parentId = scriptInterface.executionOwnerEntityID;
    unmountingRequest.lowLevelMountingInfo = mountingInfo;
    if isSceneDropAnimation.valid && isSceneDropAnimation.value {
      mountEventData = new MountEventData();
      mountEventData.removePitchRollRotationOnDismount = false;
      unmountingRequest.mountData = mountEventData;
    };
    scriptInterface.GetMountingFacility().Unmount(unmountingRequest);
    setAnimFeatureOnExecutionOwnerOnly = StatusEffectSystem.ObjectHasStatusEffect(scriptInterface.owner, t"BaseStatusEffect.ThrownNPC");
    this.SetAnimFeature_Carry(state, false, stateContext, scriptInterface, setAnimFeatureOnExecutionOwnerOnly);
    GameInstance.GetDelaySystem(player.GetGame()).DelayEvent(player, new ClearAnimFeatureCarryEvent(), 0.30, true);
    stateContext.RemovePermanentBoolParameter(n"checkCanShootWhileCarryingBodyStatFlag");
    stateContext.SetPermanentCNameParameter(n"ETakedownActionType", n"None", true);
    this.SetAnimFeature_LeftHandAnimation(scriptInterface, false);
    this.ResetMountingAnimFeature(stateContext, scriptInterface);
    if !StatusEffectSystem.ObjectHasStatusEffectOfType(scriptInterface.executionOwner, gamedataStatusEffectType.VehicleKnockdown) {
      stateContext.SetPermanentBoolParameter(n"forcedTemporaryUnequip", false, true);
    };
    this.SetBlackboardBoolVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.Carrying, false);
    GetPlayer(scriptInterface.owner.GetGame()).QueueEvent(new DropBodyBreathingEvent());
    (scriptInterface.owner as NPCPuppet).MountingEndEnableComponents();
    (scriptInterface.owner as NPCPuppet).SetDisableRagdoll(false);
    this.RemoveGameplayRestrictions(stateContext, scriptInterface);
    this.SetBodyPickUpCameraContext(stateContext, scriptInterface, false, true);
    this.SetBodyCarryCameraContext(stateContext, scriptInterface, false, true);
    this.SetBodyCarryFriendlyCameraContext(stateContext, scriptInterface, false, true);
    this.SetBodyCarryWoundedSoldierCameraContext(stateContext, scriptInterface, false, true);
    this.UpdateCameraParams(stateContext, scriptInterface);
    this.SetObjectInvulnerable(scriptInterface.owner, false);
    broadcaster = player.GetStimBroadcasterComponent();
    if IsDefined(broadcaster) {
      broadcaster.RemoveActiveStimuliByName(player, gamedataStimType.CarryBody);
    };
    (scriptInterface.owner as NPCPuppet).GetVisibleObjectComponent().Toggle(true);
    setPositionEvent = new SetBodyPositionEvent();
    setPositionEvent.bodyPosition = scriptInterface.owner.GetWorldPosition();
    scriptInterface.owner.QueueEvent(setPositionEvent);
    this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.BodyCarrying, 0);
    this.SetBlackboardBoolVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.CanThrowCarriedNPC, false);
    this.ClearStyleParameters(stateContext);
  }

  protected final func ResetMountingAnimFeature(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.m_animFeature = new AnimFeature_Mounting();
    this.m_animFeature.mountingState = 0;
    scriptInterface.SetAnimationParameterFeature(n"Mounting", this.m_animFeature, scriptInterface.executionOwner);
    scriptInterface.SetAnimationParameterFeature(n"Mounting", this.m_animFeature);
  }

  protected final func ApplyInitGameplayRestrictions(scriptInterface: ref<StateGameScriptInterface>) -> Void {
    StatusEffectHelper.ApplyStatusEffect(scriptInterface.executionOwner, t"GameplayRestriction.NoJump");
    StatusEffectHelper.ApplyStatusEffect(scriptInterface.executionOwner, t"GameplayRestriction.BodyCarryingActionRestriction");
  }

  protected final func EvaluateAutomaticLootPickupFromMountedPuppet(scriptInterface: ref<StateGameScriptInterface>) -> Void {
    if (scriptInterface.owner as NPCPuppet).HasQuestItems() && !RPGManager.IsInventoryEmpty(scriptInterface.owner) {
      scriptInterface.GetTransactionSystem().TransferAllItems(scriptInterface.owner as NPCPuppet, scriptInterface.executionOwner);
    };
  }

  protected final func ApplyFriendlyCarryGameplayRestrictions(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    StatusEffectHelper.ApplyStatusEffect(scriptInterface.executionOwner, t"GameplayRestriction.BodyCarryingFriendly");
  }

  protected final func ApplyWoundedSoldierCarryGameplayRestrictions(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    StatusEffectHelper.ApplyStatusEffect(scriptInterface.executionOwner, t"GameplayRestriction.BodyCarryingWoundedSoldier");
  }

  protected final func UpdateGameplayRestrictions(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    if scriptInterface.HasStatFlag(gamedataStatType.CanSprintWhileCarryingBody) && !this.m_isFriendlyCarry {
      StatusEffectHelper.ApplyStatusEffect(scriptInterface.executionOwner, t"GameplayRestriction.BodyCarryingCanSprint");
    } else {
      if PlayerDevelopmentSystem.GetData(scriptInterface.executionOwner).IsNewPerkBoughtAnyLevel(gamedataNewPerkType.Body_Master_Perk_5) {
        if StatusEffectSystem.ObjectHasStatusEffectWithTag(scriptInterface.executionOwner, n"BodyCarryingGeneric") {
          StatusEffectHelper.RemoveStatusEffect(scriptInterface.executionOwner, t"GameplayRestriction.BodyCarryingGeneric");
          this.SetBlackboardBoolVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.CanThrowCarriedNPC, true);
        };
        StatusEffectHelper.ApplyStatusEffect(scriptInterface.executionOwner, t"GameplayRestriction.BodyCarryingBodyMasterPerk5");
      } else {
        if StatusEffectSystem.ObjectHasStatusEffectWithTag(scriptInterface.executionOwner, n"BodyCarryingBodyMasterPerk5") {
          StatusEffectHelper.RemoveStatusEffect(scriptInterface.executionOwner, t"GameplayRestriction.BodyCarryingBodyMasterPerk5");
          this.SetBlackboardBoolVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.CanThrowCarriedNPC, false);
        };
        StatusEffectHelper.ApplyStatusEffect(scriptInterface.executionOwner, t"GameplayRestriction.BodyCarryingGeneric");
      };
    };
  }

  protected final func RemoveGameplayRestrictions(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    StatusEffectHelper.RemoveStatusEffect(scriptInterface.executionOwner, t"GameplayRestriction.BodyCarryingFriendly");
    StatusEffectHelper.RemoveStatusEffect(scriptInterface.executionOwner, t"GameplayRestriction.BodyCarryingNoDrop");
    StatusEffectHelper.RemoveStatusEffect(scriptInterface.executionOwner, t"GameplayRestriction.BodyCarryingGeneric");
    StatusEffectHelper.RemoveStatusEffect(scriptInterface.executionOwner, t"GameplayRestriction.BodyCarryingBodyMasterPerk5");
    StatusEffectHelper.RemoveStatusEffect(scriptInterface.executionOwner, t"GameplayRestriction.BodyCarryingCanSprint");
    StatusEffectHelper.RemoveStatusEffect(scriptInterface.executionOwner, t"GameplayRestriction.BodyCarryingActionRestriction");
    StatusEffectHelper.RemoveStatusEffect(scriptInterface.executionOwner, t"GameplayRestriction.NoJump");
    if Equals(this.GetStyle(stateContext), gamePSMBodyCarryingStyle.WoundedSoldier) {
      StatusEffectHelper.RemoveStatusEffect(scriptInterface.executionOwner, t"GameplayRestriction.BodyCarryingWoundedSoldier");
    };
  }

  protected final func DisableAndResetRagdoll(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    scriptInterface.owner.QueueEvent(CreateDisableRagdollEvent(n"DisableAndResetRagdollScriptFunc"));
    (scriptInterface.owner as NPCPuppet).SetDisableRagdoll(true);
  }

  protected final func EvaluateWeaponUnequipping(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    if DefaultTransition.IsHeavyWeaponEquipped(scriptInterface) {
      this.SendEquipmentSystemWeaponManipulationRequest(scriptInterface, EquipmentManipulationAction.UnequipWeapon);
    } else {
      stateContext.SetPermanentBoolParameter(n"forcedTemporaryUnequip", true, true);
    };
  }

  protected final func EnableRagdoll(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    (scriptInterface.owner as NPCPuppet).SetDisableRagdoll(false, true);
    scriptInterface.owner.QueueEvent(CreateForceRagdollNoPowerPoseEvent(n"CarriedObject"));
  }

  protected final func EnableRagdollUncontrolledMovement(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let evt: ref<UncontrolledMovementStartEvent>;
    (scriptInterface.owner as NPCPuppet).SetDisableRagdoll(false, true);
    evt = new UncontrolledMovementStartEvent();
    evt.ragdollNoGroundThreshold = -1.00;
    evt.ragdollOnCollision = true;
    evt.calculateEarlyPositionGroundHeight = true;
    evt.DebugSetSourceName(n"CarriedObjectUncontrolledMovement");
    scriptInterface.owner.QueueEvent(evt);
  }

  protected final func SetPickupAnimationParameter(stateContext: ref<StateContext>, pickupAnimation: Int32) -> Void {
    stateContext.SetPermanentIntParameter(n"carriedObjectPickupAnimation", pickupAnimation, true);
  }

  protected final const func GetPickupAnimationParameter(stateContext: ref<StateContext>) -> Int32 {
    let pickupAnimationResult: StateResultInt = stateContext.GetPermanentIntParameter(n"carriedObjectPickupAnimation");
    if pickupAnimationResult.valid {
      return pickupAnimationResult.value;
    };
    return 0;
  }

  protected final func SetWasThrownParameter(stateContext: ref<StateContext>, wasThrown: Bool) -> Void {
    stateContext.SetPermanentBoolParameter(n"carriedObjectWasThrown", wasThrown, true);
  }

  protected final const func GetWasThrownParameter(stateContext: ref<StateContext>) -> Bool {
    let wasThrownResult: StateResultBool = stateContext.GetPermanentBoolParameter(n"carriedObjectWasThrown");
    if wasThrownResult.valid {
      return wasThrownResult.value;
    };
    return false;
  }

  protected final func CalculateForcedCarryStyleAndIsFriendlyCarry(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let attitude: EAIAttitude;
    let workspotSystem: ref<WorkspotGameSystem>;
    this.m_isFriendlyCarry = false;
    let puppet: ref<gamePuppet> = scriptInterface.owner as gamePuppet;
    if IsDefined(puppet) {
      workspotSystem = scriptInterface.GetWorkspotSystem();
      if IsDefined(workspotSystem) && !this.IsBodyDisposalOngoing(stateContext, scriptInterface) {
        workspotSystem.StopNpcInWorkspot(puppet);
      };
      this.m_forcedCarryStyle = IntEnum<gamePSMBodyCarryingStyle>(puppet.GetBlackboard().GetInt(GetAllBlackboardDefs().Puppet.ForcedCarryStyle));
      attitude = GameObject.GetAttitudeBetween(scriptInterface.owner, scriptInterface.executionOwner);
      if Equals(this.m_forcedCarryStyle, gamePSMBodyCarryingStyle.Friendly) || Equals(attitude, EAIAttitude.AIA_Friendly) && Equals(this.m_forcedCarryStyle, gamePSMBodyCarryingStyle.Any) {
        this.m_isFriendlyCarry = true;
      };
    };
    this.SetIsFriendlyCarryParameter(stateContext, this.m_isFriendlyCarry);
  }
}

public class CanTransitionToThrowDecisions extends CarriedObjectDecisions {

  protected let m_throwNPCActionReleasedName: CName;

  private let m_throwNPCActionReleasedTime: Float;

  private let m_canThrow: Bool;

  private let m_canThrowInitialized: Bool;

  protected final func OnAttach(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Void {
    scriptInterface.executionOwner.RegisterInputListener(this, n"ThrowNPC");
    scriptInterface.executionOwner.RegisterInputListener(this, n"ThrowNPCAlt");
  }

  protected final func OnDetach(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Void {
    scriptInterface.executionOwner.UnregisterInputListener(this);
  }

  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    if ListenerAction.IsButtonJustReleased(action) {
      this.m_throwNPCActionReleasedName = ListenerAction.GetName(action);
      this.m_throwNPCActionReleasedTime = EngineTime.ToFloat(GameInstance.GetSimTime(GetGameInstance()));
    };
  }

  protected final func ValidThrowNPCActionReleased(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    let ignoreThrowNPCAction: Bool;
    let playerObject: ref<GameObject>;
    if Equals(this.m_throwNPCActionReleasedName, n"None") {
      return false;
    };
    if this.m_throwNPCActionReleasedTime + 0.50 < EngineTime.ToFloat(GameInstance.GetSimTime(scriptInterface.owner.GetGame())) {
      ignoreThrowNPCAction = true;
    } else {
      if Equals(this.m_throwNPCActionReleasedName, n"ThrowNPCAlt") {
        if !StatusEffectSystem.ObjectHasStatusEffect(scriptInterface.owner, t"BaseStatusEffect.ThrownNPC") && !StatusEffectSystem.ObjectHasStatusEffect(scriptInterface.executionOwner, t"BaseStatusEffect.BerserkPlayerBuff") && !StatusEffectSystem.ObjectHasStatusEffect(scriptInterface.executionOwner, t"BaseStatusEffect.AdvancedBerserkPlayerBuff") {
          playerObject = scriptInterface.executionOwner;
          if IsDefined(GameInstance.GetTransactionSystem(playerObject.GetGame()).GetItemInSlot(playerObject, t"AttachmentSlots.WeaponRight")) {
            ignoreThrowNPCAction = true;
          } else {
            if scriptInterface.HasStatFlag(gamedataStatType.CanShootWhileCarryingBody) {
              ignoreThrowNPCAction = this.CanEquipFirearm(playerObject, stateContext, scriptInterface);
            };
          };
        };
      };
    };
    if ignoreThrowNPCAction {
      this.m_throwNPCActionReleasedName = n"None";
      return false;
    };
    return true;
  }

  protected final func UpdateCanThrow(const canThrow: Bool, const scriptInterface: ref<StateGameScriptInterface>) -> Void {
    if this.m_canThrowInitialized && Equals(this.m_canThrow, canThrow) {
      return;
    };
    this.SetBlackboardBoolVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.CanThrowCarriedNPC, canThrow);
    this.m_canThrow = canThrow;
    this.m_canThrowInitialized = true;
  }
}

public class PickUpDecisions extends CanTransitionToThrowDecisions {

  public final const func ToCarry(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    let toCarryStateDuration: Float;
    if this.ShouldThrow(scriptInterface) {
      return false;
    };
    if this.GetFastModeParameter(stateContext) {
      toCarryStateDuration = this.GetStaticFloatParameterDefault("toCarryStateDurationFastMode", 1.00);
    } else {
      toCarryStateDuration = this.GetStaticFloatParameterDefault("toCarryStateDuration", 1.00);
    };
    return !stateContext.GetConditionBool(n"CarriedObjectPlayPickUp") || this.GetInStateTime() > toCarryStateDuration;
  }

  public final func ToAim(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    if !this.ShouldThrow(scriptInterface) {
      return false;
    };
    if this.ValidThrowNPCActionReleased(stateContext, scriptInterface) || !this.IsPlayerCombatAllowed(scriptInterface) {
      return false;
    };
    if this.GetInStateTime() < this.GetStaticFloatParameterDefault("toAimStateDuration", 1.00) {
      return false;
    };
    return true;
  }

  public final func ToThrow(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    if !this.ShouldThrow(scriptInterface) {
      return false;
    };
    if !this.ValidThrowNPCActionReleased(stateContext, scriptInterface) && this.IsPlayerCombatAllowed(scriptInterface) {
      return false;
    };
    if this.GetInStateTime() < this.GetStaticFloatParameterDefault("toThrowStateDuration", 1.00) {
      return false;
    };
    return true;
  }

  private final const func ShouldThrow(const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    if !StatusEffectSystem.ObjectHasStatusEffect(scriptInterface.owner, t"BaseStatusEffect.ThrownNPC") {
      return false;
    };
    return true;
  }
}

public class PickUpEvents extends CarriedObjectEvents {

  public const let m_stateMachineInstanceData: StateMachineInstanceData;

  public let m_noCameraControlApplied: Bool;

  public let m_noMovementApplied: Bool;

  protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let broadcaster: ref<StimBroadcasterComponent>;
    let canUseFireArms: Bool;
    let fastMode: Bool;
    let setPositionEvent: ref<SetBodyPositionEvent>;
    let carriedObjectData: ref<CarriedObjectData> = this.m_stateMachineInstanceData.initData as CarriedObjectData;
    let body: EntityID = scriptInterface.ownerEntityID;
    super.OnEnter(stateContext, scriptInterface);
    this.SetBlackboardBoolVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.Carrying, true);
    if StatusEffectSystem.ObjectHasStatusEffect(scriptInterface.owner, t"BaseStatusEffect.ThrownNPC") {
      this.SetPickupAnimationParameter(stateContext, 5);
      this.m_noCameraControlApplied = StatusEffectHelper.ApplyStatusEffect(scriptInterface.executionOwner, t"GameplayRestriction.NoCameraControl");
      this.m_noMovementApplied = StatusEffectHelper.ApplyStatusEffect(scriptInterface.executionOwner, t"GameplayRestriction.NoMovement");
    } else {
      switch this.GetTakedownAction(stateContext) {
        case ETakedownActionType.Takedown:
          this.SetPickupAnimationParameter(stateContext, 1);
          break;
        case ETakedownActionType.TakedownNonLethal:
          this.SetPickupAnimationParameter(stateContext, 2);
          break;
        case ETakedownActionType.AerialTakedown:
          this.SetPickupAnimationParameter(stateContext, 3);
          break;
        default:
          this.SetPickupAnimationParameter(stateContext, 0);
          if PlayerDevelopmentSystem.GetData(scriptInterface.executionOwner).IsNewPerkBoughtAnyLevel(gamedataNewPerkType.Body_Master_Perk_5) {
            fastMode = true;
          };
      };
    };
    if this.IsPickUpFromVehicleTrunk(scriptInterface) {
      this.SetPickupAnimationParameter(stateContext, 4);
      fastMode = false;
    };
    if this.m_isFriendlyCarry {
      fastMode = false;
    };
    this.SetFastModeParameter(stateContext, fastMode);
    this.SetWasThrownParameter(stateContext, false);
    this.SetAnimFeature_Carry(ECarryState.Pickup, carriedObjectData.instant, stateContext, scriptInterface);
    canUseFireArms = scriptInterface.HasStatFlag(gamedataStatType.CanShootWhileCarryingBody);
    if GameInstance.GetRuntimeInfo(scriptInterface.executionOwner.GetGame()).IsMultiplayer() {
      canUseFireArms = true;
    };
    this.ClearForcedStyle(stateContext);
    if NotEquals(this.m_forcedCarryStyle, gamePSMBodyCarryingStyle.Any) {
      this.SetForcedStyle(this.m_forcedCarryStyle, stateContext, scriptInterface);
    } else {
      if this.m_isFriendlyCarry {
        this.SetStyle(gamePSMBodyCarryingStyle.Friendly, stateContext, scriptInterface);
      } else {
        if canUseFireArms {
          this.SetStyle(gamePSMBodyCarryingStyle.Strong, stateContext, scriptInterface);
        } else {
          this.SetStyle(gamePSMBodyCarryingStyle.Default, stateContext, scriptInterface);
        };
      };
    };
    if NotEquals(this.GetStyle(stateContext), gamePSMBodyCarryingStyle.Friendly) {
      this.SetBodyPickUpCameraContext(stateContext, scriptInterface, true);
    };
    this.DisableAndResetRagdoll(stateContext, scriptInterface);
    this.EvaluateWeaponUnequipping(stateContext, scriptInterface);
    GetPlayer(scriptInterface.owner.GetGame()).QueueEvent(new PickUpBodyBreathingEvent());
    broadcaster = scriptInterface.executionOwner.GetStimBroadcasterComponent();
    if IsDefined(broadcaster) {
      broadcaster.AddActiveStimuli(scriptInterface.executionOwner, gamedataStimType.CarryBody, -1.00);
    };
    (scriptInterface.owner as NPCPuppet).GetVisibleObjectComponent().Toggle(false);
    setPositionEvent = new SetBodyPositionEvent();
    setPositionEvent.bodyPosition = scriptInterface.owner.GetWorldPosition();
    setPositionEvent.pickedUp = true;
    setPositionEvent.bodyPositionID = body;
    scriptInterface.owner.QueueEvent(setPositionEvent);
    this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.BodyCarrying, 1);
    this.ApplyInitGameplayRestrictions(scriptInterface);
    ScriptedPuppet.EvaluateApplyingStatusEffectsFromMountedObjectToPlayer(scriptInterface.owner, scriptInterface.executionOwner);
    this.EvaluateAutomaticLootPickupFromMountedPuppet(scriptInterface);
    this.SetObjectInvulnerable(scriptInterface.owner, true);
    this.SetObjectInvulnerable(scriptInterface.executionOwner, true);
  }

  protected final func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    if this.m_noCameraControlApplied && this.GetInStateTime() > this.GetStaticFloatParameterDefault("toAimNoCameraControlTime", 1.00) {
      this.RestoreCameraControl(stateContext, scriptInterface);
    };
    if this.m_noMovementApplied && this.GetInStateTime() > this.GetStaticFloatParameterDefault("toAimNoMovementTime", 1.00) {
      StatusEffectHelper.RemoveStatusEffect(scriptInterface.executionOwner, t"GameplayRestriction.NoMovement");
      StatusEffectHelper.RemoveStatusEffect(scriptInterface.executionOwner, t"GameplayRestriction.NoJump");
      this.m_noMovementApplied = false;
    };
  }

  protected func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.OnExitCommon(stateContext, scriptInterface);
    super.OnExit(stateContext, scriptInterface);
  }

  protected func OnForcedExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.OnExitCommon(stateContext, scriptInterface);
    super.OnForcedExit(stateContext, scriptInterface);
  }

  private final func OnExitCommon(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.SetObjectInvulnerable(scriptInterface.executionOwner, false);
    if this.m_noCameraControlApplied {
      this.RestoreCameraControl(stateContext, scriptInterface);
    };
    if this.m_noMovementApplied {
      StatusEffectHelper.RemoveStatusEffect(scriptInterface.executionOwner, t"GameplayRestriction.NoMovement");
      this.m_noMovementApplied = false;
    };
  }

  private final func RestoreCameraControl(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    StatusEffectHelper.RemoveStatusEffect(scriptInterface.executionOwner, t"GameplayRestriction.NoCameraControl");
    this.m_noCameraControlApplied = false;
    this.SetBodyPickUpCameraContext(stateContext, scriptInterface, false);
    this.SetBodyCarryCameraContext(stateContext, scriptInterface, true);
    this.SetBlackboardBoolVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.CanThrowCarriedNPC, true);
  }

  private final func IsPickUpFromVehicleTrunk(scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    if StatusEffectSystem.ObjectHasStatusEffect(scriptInterface.owner, t"BaseStatusEffect.VehicleTrunkBodyPickup") {
      StatusEffectHelper.RemoveStatusEffect(scriptInterface.owner, t"BaseStatusEffect.VehicleTrunkBodyPickup");
      return true;
    };
    return false;
  }
}

public class CarryDecisions extends CanTransitionToThrowDecisions {

  protected final const func ToDrop(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    if !this.IsDoorInteractionActive(scriptInterface) {
      if !scriptInterface.executionOwner.PlayerLastUsedKBM() {
        if scriptInterface.IsActionJustHeld(n"DropCarriedObject") {
          return this.IsPlayerAllowedToDropBody(stateContext, scriptInterface);
        };
      } else {
        if scriptInterface.IsActionJustReleased(n"DropCarriedObject") {
          return this.IsPlayerAllowedToDropBody(stateContext, scriptInterface);
        };
      };
    };
    if this.IsBodyDropForced(stateContext, scriptInterface) {
      return true;
    };
    return false;
  }

  protected final const func ToDispose(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    return scriptInterface.localBlackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.CarryingDisposal);
  }

  protected final func ToThrow(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    let canThrow: Bool;
    let statsSystem: ref<StatsSystem>;
    let player: ref<PlayerPuppet> = DefaultTransition.GetPlayerPuppet(scriptInterface);
    if !IsDefined(player) {
      return false;
    };
    statsSystem = GameInstance.GetStatsSystem(player.GetGame());
    canThrow = true;
    if !PlayerDevelopmentSystem.GetData(player).IsNewPerkBoughtAnyLevel(gamedataNewPerkType.Body_Master_Perk_5) {
      canThrow = false;
    } else {
      if player.IsAimingAtFriendly() {
        canThrow = false;
      } else {
        if !this.IsPlayerCombatAllowed(scriptInterface) {
          canThrow = false;
        } else {
          if this.GetIsFriendlyCarryParameter(stateContext) {
            canThrow = false;
          } else {
            if statsSystem.GetStatValue(Cast<StatsObjectID>(scriptInterface.ownerEntityID), gamedataStatType.NPCThrowImmunity) > 0.00 {
              canThrow = false;
            };
          };
        };
      };
    };
    this.UpdateCanThrow(canThrow, scriptInterface);
    if !canThrow {
      return false;
    };
    if !this.ValidThrowNPCActionReleased(stateContext, scriptInterface) {
      return false;
    };
    this.m_throwNPCActionReleasedName = n"None";
    return true;
  }
}

public class CarryEvents extends CarriedObjectEvents {

  public let m_knockdownImmunityModifier: ref<gameStatModifierData>;

  protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    super.OnEnter(stateContext, scriptInterface);
    this.SetBodyPickUpCameraContext(stateContext, scriptInterface, false);
    if GameInstance.GetRuntimeInfo(scriptInterface.executionOwner.GetGame()).IsMultiplayer() || this.CanEquipFirearm(scriptInterface.executionOwner, stateContext, scriptInterface) && Equals(this.GetStyle(stateContext), gamePSMBodyCarryingStyle.Strong) {
      stateContext.SetPermanentBoolParameter(n"forcedTemporaryUnequip", false, true);
    };
    if Equals(this.GetStyle(stateContext), gamePSMBodyCarryingStyle.WoundedSoldier) {
      this.SetBodyCarryWoundedSoldierCameraContext(stateContext, scriptInterface, true);
    } else {
      if !this.m_isFriendlyCarry {
        this.SetBodyCarryCameraContext(stateContext, scriptInterface, true);
        StatusEffectHelper.RemoveStatusEffect(scriptInterface.executionOwner, t"GameplayRestriction.NoJump");
      };
    };
    if this.m_isFriendlyCarry {
      this.AddKnockdownModifier(scriptInterface);
    };
    this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.BodyCarrying, 2);
    this.SetAnimFeature_Carry(ECarryState.Carry, false, stateContext, scriptInterface);
    if PlayerDevelopmentSystem.GetData(scriptInterface.executionOwner).IsNewPerkBoughtAnyLevel(gamedataNewPerkType.Body_Master_Perk_5) {
      this.SetBlackboardBoolVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.CanThrowCarriedNPC, true);
    };
  }

  protected final func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let linearVelocity: Vector4 = DefaultTransition.GetLinearVelocity(scriptInterface);
    this.SyncJump(stateContext, scriptInterface);
    this.m_animFeature.parentSpeed = Vector4.Length(linearVelocity);
    this.m_animFeature.parentHorizontalSpeed = Vector4.Length(new Vector4(linearVelocity.X, linearVelocity.Y, 0.00, 0.00));
    scriptInterface.SetAnimationParameterFeature(n"Mounting", this.m_animFeature);
    this.RefreshCarryState(stateContext, scriptInterface);
  }

  protected func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.OnExitCommon(stateContext, scriptInterface);
    super.OnExit(stateContext, scriptInterface);
  }

  protected func OnForcedExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.OnExitCommon(stateContext, scriptInterface);
    super.OnForcedExit(stateContext, scriptInterface);
  }

  private final func OnExitCommon(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.RemoveKnockdownModifier(scriptInterface);
  }

  private final func RefreshCarryState(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    if !this.m_isFriendlyCarry && scriptInterface.HasStatFlag(gamedataStatType.CanShootWhileCarryingBody) && !stateContext.GetBoolParameter(n"checkCanShootWhileCarryingBodyStatFlag", true) {
      if Equals(this.GetStyle(stateContext), gamePSMBodyCarryingStyle.WoundedSoldier) {
        stateContext.SetPermanentBoolParameter(n"forcedTemporaryUnequip", false, true);
        this.SetAnimFeature_Carry(ECarryState.Carry, false, stateContext, scriptInterface);
      } else {
        this.UpdateGameplayRestrictions(stateContext, scriptInterface);
        if this.CanEquipFirearm(scriptInterface.executionOwner, stateContext, scriptInterface) {
          if NotEquals(this.GetStyle(stateContext), gamePSMBodyCarryingStyle.Strong) {
            this.SetStyle(gamePSMBodyCarryingStyle.Strong, stateContext, scriptInterface);
          };
          stateContext.SetPermanentBoolParameter(n"forcedTemporaryUnequip", false, true);
          this.SendEquipmentSystemWeaponManipulationRequest(scriptInterface, EquipmentManipulationAction.RequestLastUsedOrFirstAvailableOneHandedRangedWeapon);
          this.SetAnimFeature_Carry(ECarryState.Carry, false, stateContext, scriptInterface);
          stateContext.SetPermanentBoolParameter(n"checkCanShootWhileCarryingBodyStatFlag", true, true);
        };
      };
    };
  }

  private final func SyncJump(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    if this.IsInLocomotionState(stateContext, n"jump") && !stateContext.GetBoolParameter(n"playerJumped", true) {
      stateContext.SetPermanentBoolParameter(n"playerJumped", true, true);
      this.UpdatePuppetCarryState(ECarryState.Jump, stateContext, scriptInterface);
    } else {
      if scriptInterface.IsOnGround() && stateContext.GetBoolParameter(n"playerJumped", true) {
        this.UpdatePuppetCarryState(ECarryState.Carry, stateContext, scriptInterface);
        stateContext.RemovePermanentBoolParameter(n"playerJumped");
      };
    };
  }

  private final func UpdatePuppetCarryState(state: ECarryState, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.m_animCarryFeature = new AnimFeature_Carry();
    this.m_animCarryFeature.state = EnumInt(state);
    this.m_animCarryFeature.pickupAnimation = this.GetPickupAnimationParameter(stateContext);
    this.m_animCarryFeature.fastMode = this.GetFastModeParameter(stateContext);
    this.m_animCarryFeature.isCarryActive = true;
    this.m_animCarryFeature.isFriendlyCarry = this.m_isFriendlyCarry;
    this.m_animCarryFeature.wasThrown = this.GetWasThrownParameter(stateContext);
    scriptInterface.SetAnimationParameterFeature(n"Carry", this.m_animCarryFeature, scriptInterface.owner);
  }

  private final func AddKnockdownModifier(scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let statSys: ref<StatsSystem> = scriptInterface.GetStatsSystem();
    this.m_knockdownImmunityModifier = RPGManager.CreateStatModifier(gamedataStatType.KnockdownImmunity, gameStatModifierType.Additive, 1.00);
    statSys.AddModifier(Cast<StatsObjectID>(scriptInterface.executionOwnerEntityID), this.m_knockdownImmunityModifier);
  }

  private final func RemoveKnockdownModifier(scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let statSys: ref<StatsSystem> = scriptInterface.GetStatsSystem();
    if IsDefined(this.m_knockdownImmunityModifier) {
      statSys.RemoveModifier(Cast<StatsObjectID>(scriptInterface.executionOwnerEntityID), this.m_knockdownImmunityModifier);
      this.m_knockdownImmunityModifier = null;
    };
  }
}

public class DropDecisions extends CarriedObjectDecisions {

  public final const func ExitCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    return this.GetInStateTime() > this.GetStaticFloatParameterDefault("stateDuration", 1.50);
  }
}

public class DropEvents extends CarriedObjectEvents {

  public let m_ragdollReenabled: Bool;

  protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    super.OnEnter(stateContext, scriptInterface);
    this.m_ragdollReenabled = false;
    stateContext.SetPermanentBoolParameter(n"forcedTemporaryUnequip", true, true);
    this.SetAnimFeature_Carry(ECarryState.Drop, false, stateContext, scriptInterface);
    this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.BodyCarrying, 4);
    scriptInterface.owner.QueueEvent(new RagdollRequestCollectAnimPoseEvent());
    this.EnableRagdollUncontrolledMovement(stateContext, scriptInterface);
  }

  protected final func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    if !this.m_ragdollReenabled {
      if this.GetInStateTime() > this.GetStaticFloatParameterDefault("ragdollActivateTime", 1.00) {
        this.EnableRagdoll(stateContext, scriptInterface);
        this.m_ragdollReenabled = true;
      } else {
        if this.IsInLocomotionState(stateContext, n"crouch") && this.GetInStateTime() > this.GetStaticFloatParameterDefault("ragdollActivateTimeCrouch", 1.00) {
          this.EnableRagdoll(stateContext, scriptInterface);
          this.m_ragdollReenabled = true;
        };
      };
    };
  }

  protected func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    if !this.m_ragdollReenabled {
      this.EnableRagdoll(stateContext, scriptInterface);
      this.m_ragdollReenabled = true;
    };
  }
}

public class DisposeDecisions extends CarriedObjectDecisions {

  public final const func ExitCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    return true;
  }
}

public class DisposeEvents extends CarriedObjectEvents {

  protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.BodyCarrying, 3);
    super.OnEnter(stateContext, scriptInterface);
  }

  protected func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    (scriptInterface.owner as NPCPuppet).GetVisibleObjectComponent().Toggle(false);
  }
}

public class ForceDropBodyEvents extends CarriedObjectEvents {

  protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let isSceneDropAnimation: StateResultBool;
    StatusEffectHelper.RemoveStatusEffect(scriptInterface.owner, t"BaseStatusEffect.ThrownNPC");
    this.CalculateForcedCarryStyleAndIsFriendlyCarry(stateContext, scriptInterface);
    isSceneDropAnimation = stateContext.GetTemporaryBoolParameter(n"bodyCarrySceneDropAnimation");
    if !isSceneDropAnimation.valid || isSceneDropAnimation.valid && !isSceneDropAnimation.value {
      this.EnableRagdoll(stateContext, scriptInterface);
    };
    this.CleanUpCarryStateMachine(ECarryState.Release, stateContext, scriptInterface);
  }
}

public class AimDecisions extends CanTransitionToThrowDecisions {

  protected final func ToThrow(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    let player: ref<PlayerPuppet> = DefaultTransition.GetPlayerPuppet(scriptInterface);
    if !IsDefined(player) {
      return false;
    };
    if player.IsAimingAtFriendly() {
      this.UpdateCanThrow(false, scriptInterface);
      return false;
    };
    this.UpdateCanThrow(true, scriptInterface);
    if !this.ValidThrowNPCActionReleased(stateContext, scriptInterface) && this.IsPlayerCombatAllowed(scriptInterface) {
      return false;
    };
    return true;
  }
}

public class AimEvents extends CarriedObjectEvents {

  protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    super.OnEnter(stateContext, scriptInterface);
    this.SetAnimFeature_Carry(ECarryState.Aim, false, stateContext, scriptInterface);
    this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.BodyCarrying, 5);
  }

  protected final func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.UpdateGameplayRestrictions(stateContext, scriptInterface);
  }
}

public class ThrowDecisions extends CarriedObjectDecisions {

  public final const func ExitCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    return this.GetInStateTime() > this.GetStaticFloatParameterDefault("stateDuration", 1.50);
  }
}

public class ThrowEvents extends CarriedObjectEvents {

  protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let thrownNPC: ref<NPCPuppet> = scriptInterface.owner as NPCPuppet;
    super.OnEnter(stateContext, scriptInterface);
    if !thrownNPC.IsDead() {
      thrownNPC.Kill(scriptInterface.executionOwner, true, true);
      StatusEffectHelper.ApplyStatusEffect(thrownNPC, t"BaseStatusEffect.ForceKillFromRagdoll");
    };
    this.SetWasThrownParameter(stateContext, true);
    if !StatusEffectSystem.ObjectHasStatusEffect(thrownNPC, t"BaseStatusEffect.ThrownNPC") {
      StatusEffectHelper.ApplyStatusEffect(thrownNPC, t"BaseStatusEffect.ThrownNPC");
    };
    this.SetAnimFeature_Carry(ECarryState.Throw, false, stateContext, scriptInterface);
    this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.BodyCarrying, 6);
    this.EnableRagdollUncontrolledMovement(stateContext, scriptInterface);
    scriptInterface.owner.QueueEvent(new RagdollRequestCollectAnimPoseEvent());
  }

  protected func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let cameraEulerAngles: EulerAngles;
    let maxAutoTargetAngle: Float;
    let minAutoTargetAngle: Float;
    let nearbyCrowdNPCs: array<wref<Entity>>;
    let player: ref<PlayerPuppet>;
    let ragdollImpulse: Float;
    let ragdollImpulseScale: Float;
    let ragdollMaxImpulsePitch: Float;
    let ragdollMinImpulsePitch: Float;
    let targetLateralSpeed: Float;
    let targetObject: ref<GameObject>;
    let targetSearchFilter: TargetSearchFilter;
    let targetSearchQuery: TargetSearchQuery;
    let throwAdjustmentAngleXY: Float;
    let thrownNPC: ref<NPCPuppet> = scriptInterface.owner as NPCPuppet;
    let cameraWorldTransform: Transform = scriptInterface.GetCameraWorldTransform();
    let throwDirectionForward: Vector4 = Transform.GetForward(cameraWorldTransform);
    let throwDirectionRight: Vector4 = Transform.GetRight(cameraWorldTransform);
    if this.IsPlayerCombatAllowed(scriptInterface) {
      player = DefaultTransition.GetPlayerPuppet(scriptInterface);
      if !IsDefined(player) || NotEquals(player.GetAimAssistLevel(), EAimAssistLevel.Off) {
        minAutoTargetAngle = this.GetStaticFloatParameterDefault("minAutoTargetAngle", 10.00);
        targetSearchFilter = TSF_And(TSF_All(IntEnum<TSFMV>(2562)), TSF_Not(TSFMV.Obj_Player));
        targetSearchQuery.searchFilter = targetSearchFilter;
        targetObject = DefaultTransition.GetTargetObject(scriptInterface, targetSearchQuery, -1.00, false, minAutoTargetAngle);
        if !IsDefined(targetObject) {
          targetSearchFilter = TSF_And(TSF_All(IntEnum<TSFMV>(2114)), TSF_Not(TSFMV.Obj_Player));
          targetSearchQuery.searchFilter = targetSearchFilter;
          targetObject = DefaultTransition.GetTargetObject(scriptInterface, targetSearchQuery, -1.00, false, minAutoTargetAngle);
        };
        if IsDefined(targetObject) {
          targetLateralSpeed = AbsF(Vector4.Dot((targetObject as gamePuppet).GetVelocity(), player.GetWorldRight()));
          if targetLateralSpeed <= this.GetStaticFloatParameterDefault("maxAutoTargetLateralSpeed", 1.00) {
            throwAdjustmentAngleXY = Vector4.GetAngleDegAroundAxis(throwDirectionForward, targetObject.GetWorldPosition() - scriptInterface.executionOwner.GetWorldPosition(), DefaultTransition.GetUpVector());
            maxAutoTargetAngle = this.GetStaticFloatParameterDefault("maxAutoTargetAngle", 3.00);
            if AbsF(throwAdjustmentAngleXY) > maxAutoTargetAngle {
              throwAdjustmentAngleXY = throwAdjustmentAngleXY * ClampF((minAutoTargetAngle - AbsF(throwAdjustmentAngleXY)) / (minAutoTargetAngle - maxAutoTargetAngle), 0.00, 1.00);
            };
            throwDirectionForward = Vector4.RotByAngleXY(throwDirectionForward, -throwAdjustmentAngleXY);
            throwDirectionRight = Vector4.RotByAngleXY(throwDirectionRight, -throwAdjustmentAngleXY);
          };
        };
      };
      cameraEulerAngles = Transform.ToEulerAngles(cameraWorldTransform);
      ragdollMaxImpulsePitch = this.GetStaticFloatParameterDefault("ragdollMaxImpulsePitch", 90.00);
      ragdollMinImpulsePitch = this.GetStaticFloatParameterDefault("ragdollMinImpulsePitch", 90.00);
      ragdollImpulseScale = ClampF(cameraEulerAngles.Pitch, ragdollMaxImpulsePitch, ragdollMinImpulsePitch);
      ragdollImpulseScale = (ragdollImpulseScale - ragdollMaxImpulsePitch) / (ragdollMinImpulsePitch - ragdollMaxImpulsePitch);
      ragdollImpulse = LerpF(ragdollImpulseScale, this.GetStaticFloatParameterDefault("ragdollMaxImpulse", 100.00), this.GetStaticFloatParameterDefault("ragdollMinImpulse", 100.00));
    } else {
      ragdollImpulse = 30.00;
      StatusEffectHelper.RemoveStatusEffect(thrownNPC, t"BaseStatusEffect.ThrownNPC");
    };
    thrownNPC.SetDisableRagdoll(false, true);
    thrownNPC.QueueEvent(CreateForceRagdollNoPowerPoseEvent(n"CarriedObect_Throw"));
    GameInstance.GetDelaySystem(thrownNPC.GetGame()).DelayEvent(thrownNPC, CreateRagdollApplyImpulseEvent(thrownNPC.GetWorldPosition(), throwDirectionForward * ragdollImpulse, 10000.00), 0.10, false);
    nearbyCrowdNPCs = this.ComputeNearbyCrowdNPCs(player, thrownNPC, throwDirectionForward, throwDirectionRight);
    thrownNPC.OnNPCThrown(nearbyCrowdNPCs);
  }

  private final func ComputeNearbyCrowdNPCs(player: ref<PlayerPuppet>, thrownNPC: ref<NPCPuppet>, throwDirectionForward: Vector4, throwDirectionRight: Vector4) -> [wref<Entity>] {
    let trafficEntities: array<wref<Entity>>;
    let trafficEntitiesQueryBoxPoints: array<Vector4>;
    let c_nearbyCrowdNPCQueryBoxDepth: Float = 25.00;
    let c_nearbyCrowdNPCQueryBoxWidth: Float = 4.00;
    let c_nearbyCrowdNPCQueryBoxBottom: Float = -0.25;
    let c_nearbyCrowdNPCQueryBoxTop: Float = 2.00;
    let c_nearbyCrowdNPCMaxDistance: Float = 2.00;
    ArrayPush(trafficEntitiesQueryBoxPoints, player.GetWorldPosition() + new Vector4(0.00, 0.00, c_nearbyCrowdNPCQueryBoxBottom, 0.00));
    ArrayPush(trafficEntitiesQueryBoxPoints, player.GetWorldPosition() + throwDirectionForward * c_nearbyCrowdNPCQueryBoxDepth + new Vector4(0.00, 0.00, c_nearbyCrowdNPCQueryBoxTop, 0.00));
    ArrayPush(trafficEntitiesQueryBoxPoints, player.GetWorldPosition() + throwDirectionRight * c_nearbyCrowdNPCQueryBoxWidth * 0.50);
    ArrayPush(trafficEntitiesQueryBoxPoints, player.GetWorldPosition() - throwDirectionRight * c_nearbyCrowdNPCQueryBoxWidth * 0.50);
    GameInstance.GetTrafficSystem(player.GetGame()).FindEntitiesNearPlane(thrownNPC, trafficEntitiesQueryBoxPoints, player.GetWorldPosition(), throwDirectionRight, c_nearbyCrowdNPCMaxDistance, 25u, trafficEntities);
    return trafficEntities;
  }
}

public class ReleaseEvents extends CarriedObjectEvents {

  protected func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.CalculateForcedCarryStyleAndIsFriendlyCarry(stateContext, scriptInterface);
    this.CleanUpCarryStateMachine(ECarryState.Release, stateContext, scriptInterface);
  }
}
