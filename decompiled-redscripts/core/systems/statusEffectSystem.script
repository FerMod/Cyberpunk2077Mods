
public class StatusEffectHelper extends IScriptable {

  public final static func ApplyStatusEffect(target: wref<GameObject>, statusEffectID: TweakDBID, opt delay: Float) -> Bool {
    let applyStatusEffectEvent: ref<ApplyNewStatusEffectEvent>;
    if delay <= 0.00 {
      return GameInstance.GetStatusEffectSystem(target.GetGame()).ApplyStatusEffect(target.GetEntityID(), statusEffectID);
    };
    applyStatusEffectEvent = new ApplyNewStatusEffectEvent();
    applyStatusEffectEvent.effectID = statusEffectID;
    GameInstance.GetDelaySystem(target.GetGame()).DelayEvent(target, applyStatusEffectEvent, delay, true);
    return true;
  }

  public final static func ApplyStatusEffect(target: wref<GameObject>, statusEffectID: TweakDBID, instigatorEntityID: EntityID) -> Bool {
    return GameInstance.GetStatusEffectSystem(target.GetGame()).ApplyStatusEffect(target.GetEntityID(), statusEffectID, GameObject.GetTDBID(GameInstance.FindEntityByID(target.GetGame(), instigatorEntityID) as GameObject), instigatorEntityID);
  }

  public final static func ApplyStatusEffect(target: wref<GameObject>, statusEffectID: TweakDBID, instigatorEntityID: EntityID, proxyEntityID: EntityID) -> Bool {
    return GameInstance.GetStatusEffectSystem(target.GetGame()).ApplyStatusEffect(target.GetEntityID(), statusEffectID, GameObject.GetTDBID(GameInstance.FindEntityByID(target.GetGame(), instigatorEntityID) as GameObject), instigatorEntityID, 1u, new Vector4(0.00, 0.00, 0.00, 0.00), true, proxyEntityID);
  }

  public final static func ApplyStatusEffect(target: wref<GameObject>, statusEffectID: TweakDBID, instigatorID: TweakDBID) -> Bool {
    return GameInstance.GetStatusEffectSystem(target.GetGame()).ApplyStatusEffect(target.GetEntityID(), statusEffectID, instigatorID);
  }

  public final static func ApplyStatusEffectOnSelf(gameInstance: GameInstance, statusEffectID: TweakDBID, entityID: EntityID) -> Bool {
    return GameInstance.GetStatusEffectSystem(gameInstance).ApplyStatusEffect(entityID, statusEffectID, GameObject.GetTDBID(GameInstance.FindEntityByID(gameInstance, entityID) as GameObject), entityID);
  }

  public final static func ApplyStatusEffectForTimeWindow(target: wref<GameObject>, statusEffectID: TweakDBID, instigatorEntityID: EntityID, delay: Float, duration: Float) -> Void {
    let applyStatusEffectEvent: ref<ApplyNewStatusEffectEvent>;
    let removeStatusEffectEvent: ref<RemoveStatusEffectEvent> = new RemoveStatusEffectEvent();
    removeStatusEffectEvent.effectID = statusEffectID;
    removeStatusEffectEvent.removeCount = 1u;
    GameInstance.GetDelaySystem(target.GetGame()).DelayEvent(target, removeStatusEffectEvent, duration + delay, true);
    if delay > 0.00 {
      applyStatusEffectEvent = new ApplyNewStatusEffectEvent();
      applyStatusEffectEvent.effectID = statusEffectID;
      applyStatusEffectEvent.instigatorID = GameObject.GetTDBID(GameInstance.FindEntityByID(target.GetGame(), instigatorEntityID) as GameObject);
      GameInstance.GetDelaySystem(target.GetGame()).DelayEvent(target, applyStatusEffectEvent, delay, true);
    } else {
      StatusEffectHelper.ApplyStatusEffect(target, statusEffectID, instigatorEntityID);
    };
  }

  public final static func RemoveStatusEffect(target: wref<GameObject>, statusEffectID: TweakDBID, opt removeCount: Uint32) -> Bool {
    return GameInstance.GetStatusEffectSystem(target.GetGame()).RemoveStatusEffect(target.GetEntityID(), statusEffectID, removeCount);
  }

  public final static func RemoveStatusEffect(target: wref<GameObject>, statusEffect: ref<StatusEffect>, opt removeCount: Uint32) -> Bool {
    return GameInstance.GetStatusEffectSystem(target.GetGame()).RemoveStatusEffect(target.GetEntityID(), statusEffect.GetRecord().GetID(), removeCount);
  }

  public final static func RemoveStatusEffectsByInstigatorID(target: wref<GameObject>, instigatorID: TweakDBID) -> Void {
    let appliedEffects: array<ref<StatusEffect>>;
    let i: Int32;
    GameInstance.GetStatusEffectSystem(target.GetGame()).GetAppliedEffects(target.GetEntityID(), appliedEffects);
    i = 0;
    while i < ArraySize(appliedEffects) {
      if appliedEffects[i].GetInstigatorStaticDataID() == instigatorID {
        StatusEffectHelper.RemoveStatusEffect(target, appliedEffects[i].GetRecord().GetID());
      };
      i += 1;
    };
  }

  public final static func RemoveAllStatusEffects(target: wref<GameObject>) -> Void {
    let appliedEffects: array<ref<StatusEffect>>;
    let i: Int32;
    GameInstance.GetStatusEffectSystem(target.GetGame()).GetAppliedEffects(target.GetEntityID(), appliedEffects);
    i = 0;
    while i < ArraySize(appliedEffects) {
      StatusEffectHelper.RemoveStatusEffect(target, appliedEffects[i].GetRecord().GetID());
      i += 1;
    };
  }

  public final static func RemoveAllStatusEffectsByType(gameInstance: GameInstance, target: EntityID, type: gamedataStatusEffectType) -> Void {
    let appliedEffects: array<ref<StatusEffect>>;
    let effectType: gamedataStatusEffectType;
    let i: Int32;
    let effectSystem: ref<StatusEffectSystem> = GameInstance.GetStatusEffectSystem(gameInstance);
    effectSystem.GetAppliedEffects(target, appliedEffects);
    i = 0;
    while i < ArraySize(appliedEffects) {
      effectType = appliedEffects[i].GetRecord().StatusEffectType().Type();
      if Equals(effectType, type) {
        effectSystem.RemoveStatusEffect(target, appliedEffects[i].GetRecord().GetID());
      };
      i += 1;
    };
  }

  public final static func RemoveAllStatusEffectsByType(target: wref<GameObject>, type: gamedataStatusEffectType) -> Void {
    StatusEffectHelper.RemoveAllStatusEffectsByType(target.GetGame(), target.GetEntityID(), type);
  }

  public final static func RemoveStatusEffectsWithTag(target: wref<GameObject>, gameplayTag: CName, opt delay: Float) -> Void {
    let appliedEffects: array<ref<StatusEffect>>;
    let gameplayTags: array<CName>;
    let i: Int32;
    let removeStatusEffectEvent: ref<RemoveStatusEffectEvent>;
    let effectSystem: ref<StatusEffectSystem> = GameInstance.GetStatusEffectSystem(target.GetGame());
    effectSystem.GetAppliedEffects(target.GetEntityID(), appliedEffects);
    i = 0;
    while i < ArraySize(appliedEffects) {
      gameplayTags = appliedEffects[i].GetRecord().GameplayTags();
      if ArrayContains(gameplayTags, gameplayTag) {
        if delay <= 0.00 {
          effectSystem.RemoveStatusEffect(target.GetEntityID(), appliedEffects[i].GetRecord().GetID());
        } else {
          removeStatusEffectEvent = new RemoveStatusEffectEvent();
          removeStatusEffectEvent.effectID = appliedEffects[i].GetRecord().GetID();
          GameInstance.GetDelaySystem(target.GetGame()).DelayEvent(target, removeStatusEffectEvent, delay, true);
        };
      };
      i += 1;
    };
  }

  public final static func RemoveStatusEffectsWithTag(gameInstance: GameInstance, target: EntityID, gameplayTag: CName) -> Void {
    let appliedEffects: array<ref<StatusEffect>>;
    let gameplayTags: array<CName>;
    let i: Int32;
    let effectSystem: ref<StatusEffectSystem> = GameInstance.GetStatusEffectSystem(gameInstance);
    effectSystem.GetAppliedEffects(target, appliedEffects);
    i = 0;
    while i < ArraySize(appliedEffects) {
      gameplayTags = appliedEffects[i].GetRecord().GameplayTags();
      if ArrayContains(gameplayTags, gameplayTag) {
        effectSystem.RemoveStatusEffect(target, appliedEffects[i].GetRecord().GetID());
      };
      i += 1;
    };
  }

  public final static func RemoveAllStatusEffectsWithTagBeside(target: wref<GameObject>, gameplayTag: CName, beside: TweakDBID) -> Void {
    let appliedEffects: array<ref<StatusEffect>>;
    let gameplayTags: array<CName>;
    let i: Int32;
    let effectSystem: ref<StatusEffectSystem> = GameInstance.GetStatusEffectSystem(target.GetGame());
    effectSystem.GetAppliedEffects(target.GetEntityID(), appliedEffects);
    i = 0;
    while i < ArraySize(appliedEffects) {
      if appliedEffects[i].GetRecord().GetID() == beside {
      } else {
        gameplayTags = appliedEffects[i].GetRecord().GameplayTags();
        if ArrayContains(gameplayTags, gameplayTag) {
          effectSystem.RemoveStatusEffect(target.GetEntityID(), appliedEffects[i].GetRecord().GetID());
        };
      };
      i += 1;
    };
  }

  public final static func GetStatusEffectWithTag(target: wref<GameObject>, gameplayTag: CName) -> ref<StatusEffect> {
    let appliedStatusEffects: array<ref<StatusEffect>>;
    let gameplayTags: array<CName>;
    let i: Int32;
    GameInstance.GetStatusEffectSystem(target.GetGame()).GetAppliedEffects(target.GetEntityID(), appliedStatusEffects);
    i = 0;
    while i < ArraySize(appliedStatusEffects) {
      gameplayTags = appliedStatusEffects[i].GetRecord().GameplayTags();
      if ArrayContains(gameplayTags, gameplayTag) {
        return appliedStatusEffects[i];
      };
      return null;
    };
    i += 1;
    goto 113;
  }

  public final static func HasStatusEffectWithTagConst(target: wref<GameObject>, gameplayTag: CName) -> Bool {
    let appliedStatusEffects: array<ref<StatusEffect>>;
    let gameplayTags: array<CName>;
    let i: Int32;
    GameInstance.GetStatusEffectSystem(target.GetGame()).GetAppliedEffects(target.GetEntityID(), appliedStatusEffects);
    i = 0;
    while i < ArraySize(appliedStatusEffects) {
      gameplayTags = appliedStatusEffects[i].GetRecord().GameplayTags();
      if ArrayContains(gameplayTags, gameplayTag) {
        return true;
      };
      i += 1;
    };
    return false;
  }

  public final static func HasTag(record: wref<StatusEffect_Record>, tag: CName) -> Bool {
    let gameplayTags: array<CName> = record.GameplayTags();
    return ArrayContains(gameplayTags, tag);
  }

  public final static func GetAppliedEffects(target: wref<GameObject>) -> [ref<StatusEffect>] {
    let effects: array<ref<StatusEffect>>;
    GameInstance.GetStatusEffectSystem(target.GetGame()).GetAppliedEffects(target.GetEntityID(), effects);
    return effects;
  }

  public final static func GetAppliedEffectsWithTag(target: wref<GameObject>, tag: CName, statusEffects: script_ref<[ref<StatusEffect>]>, opt instigatorID: EntityID) -> Bool {
    let appliedStatusEffects: array<ref<StatusEffect>>;
    let gameplayTags: array<CName>;
    let i: Int32;
    if !IsDefined(target) || !IsNameValid(tag) {
      return false;
    };
    ArrayClear(Deref(statusEffects));
    GameInstance.GetStatusEffectSystem(target.GetGame()).GetAppliedEffects(target.GetEntityID(), appliedStatusEffects);
    i = 0;
    while i < ArraySize(appliedStatusEffects) {
      gameplayTags = appliedStatusEffects[i].GetRecord().GameplayTags();
      if ArrayContains(gameplayTags, tag) {
        if !EntityID.IsDefined(instigatorID) || appliedStatusEffects[i].GetInstigatorEntityID() == instigatorID {
          ArrayPush(Deref(statusEffects), appliedStatusEffects[i]);
        };
      };
      i += 1;
    };
    return ArraySize(Deref(statusEffects)) > 0;
  }

  public final static func HasStatusEffectFromInstigator(target: wref<GameObject>, statusEffectID: TweakDBID, instigator: EntityID) -> Bool {
    let statusEffect: ref<StatusEffect> = StatusEffectHelper.GetStatusEffectByID(target, statusEffectID);
    if !IsDefined(statusEffect) {
      return false;
    };
    if statusEffect.GetInstigatorEntityID() == instigator {
      return true;
    };
    return false;
  }

  public final static func HasStatusEffectAttack(statusEffect: ref<StatusEffect_Record>, out statusEffectAttack: ref<Attack_Record>) -> Bool {
    let attackTDBID: TweakDBID;
    let effector: ref<Effector_Record>;
    let effectorCount: Int32;
    let j: Int32;
    let nextAttackTDBID: TweakDBID;
    let package: ref<GameplayLogicPackage_Record>;
    let packageCount: Int32 = statusEffect.GetPackagesCount();
    let i: Int32 = 0;
    while i < packageCount {
      package = statusEffect.GetPackagesItem(i);
      effectorCount = package.GetEffectorsCount();
      j = 0;
      while j < effectorCount {
        effector = package.GetEffectorsItem(j);
        nextAttackTDBID = TweakDBInterface.GetContinuousAttackEffectorRecord(effector.GetID()).AttackRecord().GetID();
        if TDBID.IsValid(nextAttackTDBID) {
          attackTDBID = nextAttackTDBID;
          if TDBID.IsValid(attackTDBID) {
            statusEffectAttack = TweakDBInterface.GetAttackRecord(attackTDBID);
            return true;
          };
        };
        j += 1;
      };
      i += 1;
    };
    return false;
  }

  public final static func GetTopPriorityEffect(target: wref<GameObject>) -> ref<StatusEffect> {
    let appliedEffects: array<ref<StatusEffect>>;
    let currentPriority: Float;
    let i: Int32;
    let statusEffectAIData: ref<StatusEffectAIData_Record>;
    let topPriority: Float;
    let topPriorityEffect: ref<StatusEffect>;
    let entityID: EntityID = target.GetEntityID();
    GameInstance.GetStatusEffectSystem(target.GetGame()).GetAppliedEffects(entityID, appliedEffects);
    topPriorityEffect = null;
    topPriority = -9999999.00;
    i = 0;
    while i < ArraySize(appliedEffects) {
      statusEffectAIData = appliedEffects[i].GetRecord().AIData();
      if statusEffectAIData == null {
        currentPriority = 0.00;
      } else {
        currentPriority = statusEffectAIData.Priority();
      };
      if currentPriority > topPriority || currentPriority == topPriority && appliedEffects[i].GetLastApplicationSimTimestamp() > topPriorityEffect.GetLastApplicationSimTimestamp() {
        topPriority = currentPriority;
        topPriorityEffect = appliedEffects[i];
      };
      i += 1;
    };
    return topPriorityEffect;
  }

  public final static func GetTopPriorityEffect(target: wref<GameObject>, statusEffectType: gamedataStatusEffectType, opt discardStatusEffect: Bool) -> ref<StatusEffect> {
    let appliedEffects: array<ref<StatusEffect>>;
    let currentPriority: Float;
    let i: Int32;
    let topPriority: Float;
    let topPriorityEffect: ref<StatusEffect>;
    GameInstance.GetStatusEffectSystem(target.GetGame()).GetAppliedEffects(target.GetEntityID(), appliedEffects);
    topPriorityEffect = null;
    topPriority = -9999999.00;
    if !discardStatusEffect {
      i = 0;
      while i < ArraySize(appliedEffects) {
        if Equals(appliedEffects[i].GetRecord().StatusEffectType().Type(), statusEffectType) {
          currentPriority = appliedEffects[i].GetRecord().AIData().Priority();
          if currentPriority >= topPriority {
            topPriority = currentPriority;
            topPriorityEffect = appliedEffects[i];
          };
        };
        i += 1;
      };
    } else {
      i = 0;
      while i < ArraySize(appliedEffects) {
        if NotEquals(appliedEffects[i].GetRecord().StatusEffectType().Type(), statusEffectType) {
          if IsDefined(appliedEffects[i].GetRecord().AIData()) {
            currentPriority = appliedEffects[i].GetRecord().AIData().Priority();
            if currentPriority >= topPriority {
              topPriority = currentPriority;
              topPriorityEffect = appliedEffects[i];
            };
          };
        };
        i += 1;
      };
    };
    return topPriorityEffect;
  }

  public final static func GetStatusEffectByID(target: wref<GameObject>, statusEffectID: TweakDBID) -> ref<StatusEffect> {
    let appliedEffects: array<ref<StatusEffect>>;
    let i: Int32;
    GameInstance.GetStatusEffectSystem(target.GetGame()).GetAppliedEffects(target.GetEntityID(), appliedEffects);
    i = 0;
    while i < ArraySize(appliedEffects) {
      if appliedEffects[i].GetRecord().GetID() == statusEffectID {
        return appliedEffects[i];
      };
      i += 1;
    };
    return null;
  }

  public final static func CheckStatusEffectBehaviorPrereqs(target: wref<GameObject>, statusEffectRecord: wref<StatusEffect_Record>) -> Bool {
    let count: Int32;
    let i: Int32;
    let record: ref<IPrereq_Record>;
    if IsDefined(statusEffectRecord) && IsDefined(statusEffectRecord.AIData()) {
      count = statusEffectRecord.AIData().GetActivationPrereqsCount();
    };
    if count == 0 {
      return true;
    };
    i = 0;
    while i < count {
      record = statusEffectRecord.AIData().GetActivationPrereqsItem(i);
      if !IPrereq.CreatePrereq(record.GetID()).IsFulfilled(target.GetGame(), target) {
        return false;
      };
      i += 1;
    };
    return true;
  }

  public final static func PopulateStatusEffectAnimData(owner: ref<GameObject>, statusEffectRecord: wref<StatusEffect_Record>, state: EKnockdownStates, hitDirection: Vector4, out animData: ref<AnimFeature_StatusEffect>) -> Void {
    let playerData: wref<StatusEffectPlayerData_Record>;
    if Vector4.IsZero(hitDirection) {
      animData.direction = 0;
    } else {
      animData.direction = GameObject.GetLocalAngleForDirectionInInt(hitDirection, owner);
    };
    if Equals(statusEffectRecord.StatusEffectType().Type(), gamedataStatusEffectType.Stunned) {
      animData.stunned = true;
      animData.knockdown = false;
      animData.state = 0;
      return;
    };
    animData.knockdown = true;
    animData.stunned = false;
    playerData = statusEffectRecord.PlayerData();
    animData.state = EnumInt(state);
    switch state {
      case EKnockdownStates.Start:
        animData.duration = playerData.StartupAnimDuration();
        break;
      case EKnockdownStates.FallLoop:
        animData.duration = -1.00;
        break;
      case EKnockdownStates.Land:
        animData.duration = playerData.LandAnimDuration();
        break;
      case EKnockdownStates.Recovery:
        animData.duration = playerData.RecoveryAnimDuration();
        break;
      case EKnockdownStates.AirRecovery:
        animData.duration = playerData.AirRecoveryAnimDuration();
        break;
      default:
    };
    animData.variation = EnumInt(playerData.StatusEffectVariation().Type());
  }

  public final static func GetStateStartTimeKey() -> CName {
    return n"SatusEffectStateStartTime";
  }

  public final static func GetForceKnockdownKey() -> CName {
    return n"StatusEffect_ForceKnockdown";
  }

  public final static func GetForcedKnockdownImpulseKey() -> CName {
    return n"StatusEffect_ForceKnockdownImpulse";
  }

  public final static func GetAppliedStatusEffectKey() -> CName {
    return n"StatusEffect";
  }

  public final static func GetCanExitKnockdownKey() -> CName {
    return n"StatusEffect_CanExitKnockdown";
  }

  public final static func TriggerSecondaryKnockdownKey() -> CName {
    return n"StatusEffect_TriggerSecondaryKnockdown";
  }
}

public class PlayerGameplayRestrictions extends IScriptable {

  public final static func RemoveAllGameplayRestrictions(target: wref<GameObject>) -> Void {
    StatusEffectHelper.RemoveStatusEffectsWithTag(target, n"GameplayRestriction");
  }

  public final static func OnGameplayRestrictionAdded(player: wref<PlayerPuppet>, record: ref<StatusEffect_Record>, const gameplayTags: script_ref<[CName]>) -> Void {
    let restrictionName: CName;
    if !IsDefined(player) {
      return;
    };
    if ArrayContains(Deref(gameplayTags), n"InfiniteAmmo") {
      GameInstance.GetInventoryManager(player.GetGame()).AddEquipmentStateFlag(gameEEquipmentManagerState.InfiniteAmmo);
    };
    if ArrayContains(Deref(gameplayTags), n"Fists") {
      PlayerGameplayRestrictions.RequestFists(player);
    };
    if ArrayContains(Deref(gameplayTags), n"Melee") {
      PlayerGameplayRestrictions.RequestMeleeWeapon(player);
    };
    if ArrayContains(Deref(gameplayTags), n"NoArmsCW") {
      PlayerGameplayRestrictions.RequestFists(player);
    };
    if ArrayContains(Deref(gameplayTags), n"BlockAllHubMenu") {
      PlayerGameplayRestrictions.SendBlockMenuRequest(player, true, EMenuType.Hub);
    };
    if ArrayContains(Deref(gameplayTags), n"BlockAllMenu") {
      PlayerGameplayRestrictions.SendBlockMenuRequest(player, true, EMenuType.All);
    };
    if ArrayContains(Deref(gameplayTags), n"BlockFastTravel") {
      restrictionName = TweakDBInterface.GetCName(record.GetID() + t".restrictionName", n"MISSING - NEEDS TO BE FIXED");
      PlayerGameplayRestrictions.ChangeFastTravelSystemState(false, restrictionName, player, record.GetID());
    };
    if ArrayContains(Deref(gameplayTags), n"PhoneCall") {
      StatusEffectHelper.ApplyStatusEffect(player, t"GameplayRestriction.PhoneCallDeviceActionRestrictions");
      PlayerGameplayRestrictions.PushForceRefreshInputHintsEventToPSM(player);
    };
    if ArrayContains(Deref(gameplayTags), n"NoCombat") {
      PlayerGameplayRestrictions.PushForceRefreshInputHintsEventToPSM(player);
    };
    if ArrayContains(Deref(gameplayTags), n"VehicleFPP") || ArrayContains(Deref(gameplayTags), n"VehicleScene") || ArrayContains(Deref(gameplayTags), n"VehicleCombat") || ArrayContains(Deref(gameplayTags), n"VehicleBlockRadioInput") {
      PlayerGameplayRestrictions.PushForceRefreshInputHintsEventToPSM(player);
    };
    if ArrayContains(Deref(gameplayTags), n"NoEncumbrance") {
      player.EvaluateEncumbrance();
    };
  }

  public final static func OnGameplayRestrictionRemoved(player: wref<PlayerPuppet>, evt: ref<RemoveStatusEffect>, const gameplayTags: script_ref<[CName]>) -> Void {
    let restrictionName: CName;
    if !IsDefined(player) {
      return;
    };
    if ArrayContains(Deref(gameplayTags), n"InfiniteAmmo") && !StatusEffectSystem.ObjectHasStatusEffectWithTag(player, n"InfiniteAmmo") {
      GameInstance.GetInventoryManager(player.GetGame()).RemoveEquipmentStateFlag(gameEEquipmentManagerState.InfiniteAmmo);
    };
    if ArrayContains(Deref(gameplayTags), n"BlockAllHubMenu") && !StatusEffectSystem.ObjectHasStatusEffectWithTag(player, n"BlockAllHubMenu") && !player.IsJohnnyReplacer() {
      PlayerGameplayRestrictions.SendBlockMenuRequest(player, false, EMenuType.Hub);
    };
    if ArrayContains(Deref(gameplayTags), n"BlockAllMenu") {
      PlayerGameplayRestrictions.SendBlockMenuRequest(player, false, EMenuType.All);
    };
    if ArrayContains(Deref(gameplayTags), n"BlockFastTravel") {
      restrictionName = TweakDBInterface.GetCName(evt.staticData.GetID() + t".restrictionName", n"MISSING - NEEDS TO BE FIXED");
      PlayerGameplayRestrictions.ChangeFastTravelSystemState(true, restrictionName, player, evt.staticData.GetID());
    };
    if ArrayContains(Deref(gameplayTags), n"PhoneCall") && !StatusEffectSystem.ObjectHasStatusEffectWithTag(player, n"PhoneCall") {
      StatusEffectHelper.RemoveStatusEffect(player, t"GameplayRestriction.PhoneCallDeviceActionRestrictions");
      PlayerGameplayRestrictions.PushForceRefreshInputHintsEventToPSM(player);
    };
    if ArrayContains(Deref(gameplayTags), n"NoCombat") {
      PlayerGameplayRestrictions.PushForceRefreshInputHintsEventToPSM(player);
    };
    if ArrayContains(Deref(gameplayTags), n"VehicleFPP") || ArrayContains(Deref(gameplayTags), n"VehicleScene") || ArrayContains(Deref(gameplayTags), n"VehicleCombatBlockExit") || ArrayContains(Deref(gameplayTags), n"VehicleBlockRadioInput") {
      PlayerGameplayRestrictions.PushForceRefreshInputHintsEventToPSM(player);
    };
    if ArrayContains(Deref(gameplayTags), n"NoEncumbrance") && !StatusEffectSystem.ObjectHasStatusEffectWithTag(player, n"NoEncumbrance") {
      player.EvaluateEncumbrance();
    };
  }

  public final static func PushForceRefreshInputHintsEventToPSM(requester: ref<GameObject>) -> Void {
    let psmForceRefreshInputHintsEvent: ref<PSMPostponedParameterBool> = new PSMPostponedParameterBool();
    psmForceRefreshInputHintsEvent.id = n"ForceRefreshInputHints";
    psmForceRefreshInputHintsEvent.value = true;
    requester.QueueEvent(psmForceRefreshInputHintsEvent);
  }

  public final static func GetMenuEventName(blockMenu: Bool, menuType: EMenuType) -> CName {
    switch menuType {
      case EMenuType.Hub:
        return blockMenu ? n"OnBlockHub" : n"OnUnlockHub";
      case EMenuType.Pause:
        return blockMenu ? n"OnBlockPause" : n"OnUnlockPause";
      case EMenuType.All:
        return blockMenu ? n"OnBlockAll" : n"OnUnlockAll";
      default:
        return n"None";
    };
  }

  public final static func SendBlockMenuRequest(player: wref<PlayerPuppet>, blockMenu: Bool, menuType: EMenuType) -> Void {
    let menuEvent: ref<inkMenuInstance_SpawnAddressedEvent> = new inkMenuInstance_SpawnAddressedEvent();
    if IsDefined(player) {
      menuEvent.Init(n"MenuScenario_Idle", PlayerGameplayRestrictions.GetMenuEventName(blockMenu, menuType));
      GameInstance.GetUISystem(player.GetGame()).QueueEvent(menuEvent);
    };
  }

  public final static func RequestFists(player: wref<PlayerPuppet>, opt animType: gameEquipAnimationType) -> Void {
    let eqs: ref<EquipmentSystem>;
    let request: ref<EquipmentSystemWeaponManipulationRequest>;
    if !IsDefined(player) {
      return;
    };
    eqs = GameInstance.GetScriptableSystemsContainer(player.GetGame()).Get(n"EquipmentSystem") as EquipmentSystem;
    if !IsDefined(eqs) {
      return;
    };
    request = new EquipmentSystemWeaponManipulationRequest();
    request.owner = player;
    request.requestType = EquipmentManipulationAction.RequestFists;
    request.equipAnimType = animType;
    eqs.QueueRequest(request);
  }

  public final static func RequestMeleeWeapon(player: wref<PlayerPuppet>, opt animType: gameEquipAnimationType) -> Void {
    let eqs: ref<EquipmentSystem>;
    let request: ref<EquipmentSystemWeaponManipulationRequest>;
    if !IsDefined(player) {
      return;
    };
    eqs = GameInstance.GetScriptableSystemsContainer(player.GetGame()).Get(n"EquipmentSystem") as EquipmentSystem;
    if !IsDefined(eqs) {
      return;
    };
    request = new EquipmentSystemWeaponManipulationRequest();
    request.owner = player;
    request.requestType = EquipmentManipulationAction.RequestLastUsedOrFirstAvailableMeleeWeapon;
    request.equipAnimType = animType;
    eqs.QueueRequest(request);
  }

  public final static func RequestLastUsedWeapon(player: wref<PlayerPuppet>, opt animType: gameEquipAnimationType) -> Void {
    let eqs: ref<EquipmentSystem>;
    let request: ref<EquipmentSystemWeaponManipulationRequest>;
    if !IsDefined(player) {
      return;
    };
    eqs = GameInstance.GetScriptableSystemsContainer(player.GetGame()).Get(n"EquipmentSystem") as EquipmentSystem;
    if !IsDefined(eqs) {
      return;
    };
    request = new EquipmentSystemWeaponManipulationRequest();
    request.owner = player;
    request.requestType = EquipmentManipulationAction.RequestLastUsedWeapon;
    request.equipAnimType = animType;
    eqs.QueueRequest(request);
  }

  private final static func ChangeFastTravelSystemState(enable: Bool, reason: CName, player: wref<PlayerPuppet>, statusEffectID: TweakDBID) -> Void {
    let request: ref<EnableFastTravelRequest> = new EnableFastTravelRequest();
    request.isEnabled = enable;
    request.reason = reason;
    request.linkedStatusEffectID = statusEffectID;
    let ftSystem: ref<FastTravelSystem> = GameInstance.GetScriptableSystemsContainer(player.GetGame()).Get(n"FastTravelSystem") as FastTravelSystem;
    ftSystem.QueueRequest(request);
  }

  public final static func IsHotkeyRestricted(game: GameInstance, hotkey: EHotkey) -> Bool {
    let tags: array<CName>;
    if PlayerGameplayRestrictions.AcquireHotkeyRestrictionTags(hotkey, tags) {
      return StatusEffectSystem.ObjectHasStatusEffectWithTags(GameInstance.GetPlayerSystem(game).GetLocalPlayerControlledGameObject(), tags);
    };
    return true;
  }

  public final static func AcquireHotkeyRestrictionTags(hotkey: EHotkey, hotkeyTags: script_ref<[CName]>) -> Bool {
    let i: Int32;
    let restrictionTags: array<CName>;
    let recordKey: String = "DPadUIData." + EnumValueToString("EHotkey", EnumInt(hotkey));
    let record: ref<DPadUIData_Record> = TweakDBInterface.GetDPadUIDataRecord(TDBID.Create(recordKey));
    if !IsDefined(record) {
      return false;
    };
    restrictionTags = record.RestrictionTags();
    i = 0;
    while i < ArraySize(restrictionTags) {
      ArrayPush(Deref(hotkeyTags), restrictionTags[i]);
      i += 1;
    };
    return true;
  }
}
