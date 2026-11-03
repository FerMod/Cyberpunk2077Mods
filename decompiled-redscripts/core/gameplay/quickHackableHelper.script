
public class QuickHackableHelper extends IScriptable {

  public final static func TranslateActionsIntoQuickSlotCommands(const actions: [ref<DeviceAction>], commands: script_ref<[ref<QuickhackData>]>, gameObject: ref<GameObject>, scriptableComponentPS: ref<ScriptableDeviceComponentPS>) -> Void {
    let DEBUG_playerActionNames: array<CName>;
    let DEBUG_playerTweaks: array<TweakDBID>;
    let DEBUG_targetTweaks: array<TweakDBID>;
    let actionCompletionEffects: array<wref<ObjectActionEffect_Record>>;
    let actionMatchDeck: Bool;
    let actionRecord: ref<ObjectAction_Record>;
    let actionStartEffects: array<wref<ObjectActionEffect_Record>>;
    let choice: InteractionChoice;
    let emptyChoice: InteractionChoice;
    let i: Int32;
    let i1: Int32;
    let isQueuePerkBought: Bool;
    let newCommand: ref<QuickhackData>;
    let sAction: ref<ScriptableDeviceAction>;
    let statModifiers: array<wref<StatModifier_Record>>;
    let playerRef: ref<PlayerPuppet> = GetPlayer(gameObject.GetGame());
    let iceLVL: Float = QuickHackableHelper.GetICELevel(gameObject);
    let actionOwnerName: CName = StringToName(gameObject.GetDisplayName());
    let playerQHacksList: array<PlayerQuickhackData> = RPGManager.GetPlayerQuickHackListWithQuality(playerRef);
    if !IsFinal() {
      i = 0;
      while i < ArraySize(playerQHacksList) {
        actionRecord = playerQHacksList[i].actionRecord;
        ArrayPush(DEBUG_playerTweaks, playerQHacksList[i].actionRecord.GetID());
        if NotEquals(actionRecord.ObjectActionType().Type(), gamedataObjectActionType.DeviceQuickHack) && NotEquals(actionRecord.ObjectActionType().Type(), gamedataObjectActionType.VehicleQuickHack) {
        } else {
          ArrayPush(DEBUG_playerActionNames, actionRecord.ActionName());
        };
        i += 1;
      };
      i = 0;
      while i < ArraySize(actions) {
        ArrayPush(DEBUG_targetTweaks, (actions[i] as ScriptableDeviceAction).GetObjectActionRecord().GetID());
        i += 1;
      };
    };
    i = 0;
    while i < ArraySize(DEBUG_playerTweaks) {
      i += 1;
    };
    i = 0;
    while i < ArraySize(DEBUG_playerActionNames) {
      i += 1;
    };
    i = 0;
    while i < ArraySize(DEBUG_targetTweaks) {
      i += 1;
    };
    if ArraySize(playerQHacksList) == 0 {
      newCommand = new QuickhackData();
      newCommand.m_title = "LocKey#42171";
      newCommand.m_isLocked = true;
      newCommand.m_actionState = EActionInactivityReson.Invalid;
      newCommand.m_actionOwnerName = StringToName(gameObject.GetDisplayName());
      newCommand.m_description = "LocKey#42172";
      newCommand.m_noQuickhackData = true;
      ArrayPush(Deref(commands), newCommand);
    } else {
      i = 0;
      while i < ArraySize(playerQHacksList) {
        newCommand = new QuickhackData();
        sAction = null;
        ArrayClear(actionStartEffects);
        actionRecord = playerQHacksList[i].actionRecord;
        if NotEquals(actionRecord.ObjectActionType().Type(), gamedataObjectActionType.DeviceQuickHack) && NotEquals(actionRecord.ObjectActionType().Type(), gamedataObjectActionType.VehicleQuickHack) {
        } else {
          actionMatchDeck = false;
          i1 = 0;
          while i1 < ArraySize(actions) {
            sAction = actions[i1] as ScriptableDeviceAction;
            if Equals(actionRecord.ActionName(), sAction.GetObjectActionRecord().ActionName()) {
              actionMatchDeck = true;
              if actionRecord.Priority() >= sAction.GetObjectActionRecord().Priority() {
                sAction.SetObjectActionID(playerQHacksList[i].actionRecord.GetID());
              } else {
                actionRecord = sAction.GetObjectActionRecord();
              };
              newCommand.m_uploadTime = sAction.GetActivationTime();
              if IsDefined(gameObject as Device) {
                newCommand.m_duration = scriptableComponentPS.GetDistractionDuration(sAction);
              } else {
                newCommand.m_duration = sAction.GetDurationValue();
              };
              break;
            };
            i1 += 1;
          };
          newCommand.m_itemID = playerQHacksList[i].itemID;
          newCommand.m_actionOwnerName = actionOwnerName;
          newCommand.m_title = LocKeyToString(actionRecord.ObjectActionUI().Caption());
          newCommand.m_description = LocKeyToString(actionRecord.ObjectActionUI().Description());
          newCommand.m_icon = actionRecord.ObjectActionUI().CaptionIcon().TexturePartID().GetID();
          newCommand.m_iconCategory = actionRecord.GameplayCategory().IconName();
          newCommand.m_type = actionRecord.ObjectActionType().Type();
          newCommand.m_actionOwner = gameObject.GetEntityID();
          newCommand.m_isInstant = false;
          newCommand.m_ICELevel = iceLVL;
          newCommand.m_ICELevelVisible = false;
          newCommand.m_vulnerabilities = scriptableComponentPS.GetActiveQuickHackVulnerabilities();
          newCommand.m_actionState = EActionInactivityReson.Locked;
          newCommand.m_quality = playerQHacksList[i].quality;
          newCommand.m_costRaw = BaseScriptableAction.GetBaseCostStatic(playerRef, actionRecord);
          newCommand.m_category = actionRecord.HackCategory();
          ArrayClear(actionCompletionEffects);
          actionRecord.CompletionEffects(actionCompletionEffects);
          newCommand.m_actionCompletionEffects = actionCompletionEffects;
          actionRecord.StartEffects(actionStartEffects);
          i1 = 0;
          while i1 < ArraySize(actionStartEffects) {
            if Equals(actionStartEffects[i1].StatusEffect().StatusEffectType().Type(), gamedataStatusEffectType.PlayerCooldown) {
              actionStartEffects[i1].StatusEffect().Duration().StatModifiers(statModifiers);
              newCommand.m_cooldown = RPGManager.CalculateStatModifiers(statModifiers, gameObject.GetGame(), playerRef, Cast<StatsObjectID>(playerRef.GetEntityID()), Cast<StatsObjectID>(playerRef.GetEntityID()));
              newCommand.m_cooldownTweak = actionStartEffects[i1].StatusEffect().GetID();
              ArrayClear(statModifiers);
            };
            if newCommand.m_cooldown != 0.00 {
              break;
            };
            i1 += 1;
          };
          if actionMatchDeck {
            if !IsDefined(gameObject as GenericDevice) {
              choice = emptyChoice;
              choice = sAction.GetInteractionChoice();
              if TDBID.IsValid(choice.choiceMetaData.tweakDBID) {
                newCommand.m_titleAlternative = LocKeyToString(TweakDBInterface.GetInteractionBaseRecord(choice.choiceMetaData.tweakDBID).Caption());
              };
            };
            newCommand.m_cost = sAction.GetCost();
            newCommand.m_awarenessCost = sAction.GetAwarenessCost(gameObject.GetGame());
            newCommand.m_willReveal = QuickHackableHelper.WillHackRevealPlayer(playerRef, GameObject.GetTDBID(gameObject), sAction, newCommand.m_itemID);
            newCommand.m_showRevealInfo = QuickHackableHelper.ShouldShowRevealInfo(playerRef, newCommand.m_awarenessCost);
            if sAction.IsInactive() {
              newCommand.m_isLocked = true;
              newCommand.m_inactiveReason = sAction.GetInactiveReason();
              if gameObject.HasActiveQuickHackUpload() {
                newCommand.m_action = sAction;
              };
            } else {
              if StatusEffectSystem.ObjectHasStatusEffect(playerRef, newCommand.m_cooldownTweak) {
                newCommand.m_isLocked = true;
                newCommand.m_inactiveReason = "LocKey#7019";
              };
              if !sAction.CanPayCost(null, true) {
                newCommand.m_actionState = EActionInactivityReson.OutOfMemory;
                newCommand.m_isLocked = true;
                newCommand.m_inactiveReason = "LocKey#27398";
              };
              if GameInstance.GetStatPoolsSystem(gameObject.GetGame()).HasActiveStatPool(Cast<StatsObjectID>(gameObject.GetEntityID()), gamedataStatPoolType.QuickHackUpload) {
                isQueuePerkBought = PlayerDevelopmentSystem.GetData(playerRef).IsNewPerkBought(gamedataNewPerkType.Intelligence_Left_Milestone_2) == 2;
                if !isQueuePerkBought {
                  newCommand.m_isLocked = true;
                  newCommand.m_inactiveReason = "LocKey#27398";
                };
              };
              if !sAction.IsInactive() || gameObject.HasActiveQuickHackUpload() {
                newCommand.m_action = sAction;
              };
            };
          } else {
            newCommand.m_isLocked = true;
            newCommand.m_inactiveReason = "LocKey#10943";
          };
          newCommand.m_actionMatchesTarget = actionMatchDeck;
          if !newCommand.m_isLocked {
            newCommand.m_actionState = EActionInactivityReson.Ready;
          };
          ArrayPush(Deref(commands), newCommand);
        };
        i += 1;
      };
    };
    i = 0;
    while i < ArraySize(Deref(commands)) {
      if Deref(commands)[i].m_isLocked && IsDefined(Deref(commands)[i].m_action) {
        (Deref(commands)[i].m_action as ScriptableDeviceAction).SetInactiveWithReason(false, Deref(commands)[i].m_inactiveReason);
      };
      i += 1;
    };
    QuickhackModule.SortCommandPriority(commands, gameObject.GetGame());
  }

  public final static func GetICELevel(gameObject: ref<GameObject>) -> Float {
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(gameObject.GetGame());
    let playerLevel: Float = statsSystem.GetStatValue(Cast<StatsObjectID>(GetPlayer(gameObject.GetGame()).GetEntityID()), gamedataStatType.Level);
    let targetLevel: Float = statsSystem.GetStatValue(Cast<StatsObjectID>(gameObject.GetEntityID()), gamedataStatType.PowerLevel);
    let resistance: Float = statsSystem.GetStatValue(Cast<StatsObjectID>(gameObject.GetEntityID()), gamedataStatType.HackingResistance);
    return resistance + 0.50 * (targetLevel - playerLevel);
  }

  public final static func CanActivateOverclockedState(player: ref<GameObject>) -> Bool {
    let gameInstance: GameInstance;
    let isReplacer: Bool;
    if !IsDefined(player) {
      return false;
    };
    gameInstance = player.GetGame();
    isReplacer = GameInstance.GetBlackboardSystem(gameInstance).Get(GetAllBlackboardDefs().UI_PlayerStats).GetBool(GetAllBlackboardDefs().UI_PlayerStats.isReplacer);
    return !isReplacer && GameInstance.GetStatsSystem(gameInstance).GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.HasCyberdeck) > 0.00 && GameInstance.GetStatsSystem(gameInstance).GetStatBoolValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.CanUseOverclock) && PlayerDevelopmentSystem.GetData(player).IsNewPerkBought(gamedataNewPerkType.Intelligence_Central_Milestone_3) == 3;
  }

  public final static func TryToCycleOverclockedState(player: ref<GameObject>) -> Bool {
    let isOverclockActivated: Bool;
    let isOverclockOnCooldown: Bool;
    if !QuickHackableHelper.CanActivateOverclockedState(player) {
      return false;
    };
    isOverclockActivated = QuickHackableHelper.IsOverclockedStateActive(player);
    isOverclockOnCooldown = !GameInstance.GetStatPoolsSystem(player.GetGame()).HasStatPoolValueReachedMax(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatPoolType.CyberdeckOverclock);
    if isOverclockActivated || isOverclockOnCooldown {
      GameObject.PlaySound(player, n"ui_gmpl_perk_overclock_deactivate");
      if isOverclockActivated {
        GameInstance.GetStatPoolsSystem(player.GetGame()).RequestSettingStatPoolMinValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatPoolType.CyberdeckOverclock, player);
        GameInstance.GetDelaySystem(player.GetGame()).DelayEventNextFrame(player, new RefreshQuickhackMenuEvent());
      };
      StatusEffectHelper.RemoveStatusEffect(player, t"BaseStatusEffect.Intelligence_Central_Milestone_3_Overclock_Buff");
      GameInstance.GetRazerChromaEffectsSystem(player.GetGame()).StopAnimation(n"Overclock");
    } else {
      StatusEffectHelper.ApplyStatusEffect(player, t"BaseStatusEffect.Intelligence_Central_Milestone_3_Overclock_Buff");
      GameInstance.GetDelaySystem(player.GetGame()).DelayEventNextFrame(player, new RefreshQuickhackMenuEvent());
      GameInstance.GetRazerChromaEffectsSystem(player.GetGame()).PlayAnimation(n"Overclock", true);
      return true;
    };
    return false;
  }

  public final static func IsOverclockedStateActive(player: ref<GameObject>) -> Bool {
    if !IsDefined(player) {
      return false;
    };
    return StatusEffectSystem.ObjectHasStatusEffect(player, t"BaseStatusEffect.Intelligence_Central_Milestone_3_Overclock_Buff");
  }

  public final static func GetOverclockedStateTweakDBID() -> TweakDBID {
    return t"BaseStatusEffect.Intelligence_Central_Milestone_3_Overclock_Buff";
  }

  public final static func CanPayWithHealthInOverclockedState(player: ref<GameObject>, memoryCost: Int32, out healthReduction: Float) -> Bool {
    let statPoolsSystem: ref<StatPoolsSystem> = GameInstance.GetStatPoolsSystem(player.GetGame());
    let currentHealth: Float = statPoolsSystem.GetStatPoolValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatPoolType.Health, false);
    let currentMemory: Float = statPoolsSystem.GetStatPoolValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatPoolType.Memory, false);
    let overclockedStateHealthCost: Float = GameInstance.GetStatsSystem(player.GetGame()).GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.OverclockedStateHealthCost);
    if currentMemory >= Cast<Float>(memoryCost) {
      healthReduction = 0.00;
      return false;
    };
    healthReduction = overclockedStateHealthCost * (Cast<Float>(memoryCost) - currentMemory);
    return currentHealth - healthReduction > 0.00;
  }

  public final static func PayWithHealthInOverclockedState(player: ref<GameObject>, memoryCost: Int32) -> Bool {
    let currentMemory: Float;
    let healthReduction: Float;
    let statPoolsSystem: ref<StatPoolsSystem> = GameInstance.GetStatPoolsSystem(player.GetGame());
    if QuickHackableHelper.CanPayWithHealthInOverclockedState(player, memoryCost, healthReduction) {
      GameObject.PlaySoundEvent(player, n"ui_focus_mode_quickhack_perk_overclock");
      statPoolsSystem.RequestChangingStatPoolValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatPoolType.Health, -healthReduction, player, false, false);
      currentMemory = statPoolsSystem.GetStatPoolValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatPoolType.Memory, false);
      if currentMemory > 0.00 {
        statPoolsSystem.RequestChangingStatPoolValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatPoolType.Memory, -currentMemory, player, false, false);
      };
      return true;
    };
    return false;
  }

  public final static func WillHackRevealPlayer(playerRef: ref<PlayerPuppet>, targetRecordId: TweakDBID, action: ref<ScriptableDeviceAction>, opt programItemID: ItemID) -> Bool {
    let i: Int32;
    let isUntraceableHack: Bool;
    let itemRecord: ref<Item_Record>;
    let playerQHackData: PlayerQuickhackData;
    let playerQHacksList: array<PlayerQuickhackData>;
    let npcWillCounterHack: Bool = NPCManager.HasTag(targetRecordId, n"WillCounterHack");
    let isForcedQHUploadAwarenessBumps: Bool = StatusEffectSystem.ObjectHasStatusEffect(playerRef, t"BaseStatusEffect.ForcedQHUploadAwarenessBumps");
    if programItemID == ItemID.None() {
      playerQHacksList = RPGManager.GetPlayerQuickHackListWithQuality(playerRef);
      i = 0;
      while i < ArraySize(playerQHacksList) {
        playerQHackData = playerQHacksList[i];
        if Equals(playerQHackData.actionRecord.ActionName(), action.GetObjectActionRecord().ActionName()) {
          programItemID = playerQHackData.itemID;
          break;
        };
        i += 1;
      };
    };
    if programItemID != ItemID.None() {
      itemRecord = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(programItemID));
      isUntraceableHack = itemRecord.OnAttachContains(TweakDBInterface.GetGameplayLogicPackageRecord(t"EquipmentGLP.UntraceableHack"));
    } else {
      isUntraceableHack = action.GetAwarenessCost(playerRef.GetGame()) == 0.00;
    };
    return !isUntraceableHack && !playerRef.IsBeingRevealed() && !isForcedQHUploadAwarenessBumps && (!playerRef.IsInCombat() || npcWillCounterHack);
  }

  public final static func ShouldShowRevealInfo(playerRef: ref<PlayerPuppet>, awarenessCost: Float) -> Bool {
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(playerRef.GetGame());
    let isForcedQHUploadAwarenessBumps: Bool = StatusEffectSystem.ObjectHasStatusEffect(playerRef, t"BaseStatusEffect.ForcedQHUploadAwarenessBumps");
    let ignoreAwarenessBumpingAbility: Bool = statsSystem.GetStatBoolValue(Cast<StatsObjectID>(playerRef.GetEntityID()), gamedataStatType.IgnoreAwarenessCostWhenOverclocked);
    return awarenessCost != 0.00 && !ignoreAwarenessBumpingAbility && (playerRef.IsBeingRevealed() || isForcedQHUploadAwarenessBumps);
  }

  public final static func ShouldShowRevealInfoWithTarget(playerRef: ref<PlayerPuppet>, target: ref<ScriptedPuppet>, awarenessCost: Float) -> Bool {
    let ignoreAwarenessBumpingSonicShock: Bool = StatusEffectSystem.ObjectHasStatusEffectWithTag(target, n"CommsNoiseJam");
    return QuickHackableHelper.ShouldShowRevealInfo(playerRef, awarenessCost) && !ignoreAwarenessBumpingSonicShock || awarenessCost < 0.00;
  }
}

public class OnMonowireQuickhackContagiousTargetStatusAppliedCallback extends DelayCallback {

  public let m_ContagiousTarget: wref<ScriptedPuppet>;

  public final static func Create(targetScriptedPuppet: ref<ScriptedPuppet>) -> ref<OnMonowireQuickhackContagiousTargetStatusAppliedCallback> {
    let created: ref<OnMonowireQuickhackContagiousTargetStatusAppliedCallback> = new OnMonowireQuickhackContagiousTargetStatusAppliedCallback();
    created.m_ContagiousTarget = targetScriptedPuppet;
    return created;
  }

  public func Call() -> Void {
    if this.m_ContagiousTarget == null {
      return;
    };
    StatusEffectHelper.ApplyStatusEffect(this.m_ContagiousTarget, t"BaseStatusEffect.MonoWireQuickhackContagiousHittableTarget");
  }
}

public class OnMonowireWindowToSpreadQuickhackCallback extends DelayCallback {

  public let m_MonoWireApplyQuickhackEffector: ref<MonoWireQuickHackApplyEffector>;

  public let m_PlayerPuppet: wref<PlayerPuppet>;

  public final static func Create(effector: ref<MonoWireQuickHackApplyEffector>, playerPuppet: ref<PlayerPuppet>) -> ref<OnMonowireWindowToSpreadQuickhackCallback> {
    let created: ref<OnMonowireWindowToSpreadQuickhackCallback> = new OnMonowireWindowToSpreadQuickhackCallback();
    created.m_MonoWireApplyQuickhackEffector = effector;
    created.m_PlayerPuppet = playerPuppet;
    return created;
  }

  public func Call() -> Void {
    let hasTargetWithContagiousEffect: Bool;
    let i: Int32;
    let spreadableQuickhackData: ref<QuickhackData>;
    let blackboardSystem: ref<BlackboardSystem> = GameInstance.GetBlackboardSystem(this.m_PlayerPuppet.GetGame());
    let blackboard: ref<IBlackboard> = blackboardSystem.GetLocalInstanced(this.m_PlayerPuppet.GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    let spreadableQuickhackActionID: TweakDBID = FromVariant<TweakDBID>(blackboard.GetVariant(GetAllBlackboardDefs().PlayerStateMachine.MeleeSpreadableQuickhackActionID));
    let targetsToSpread: array<ref<MonowireSpreadableNPC>> = this.m_MonoWireApplyQuickhackEffector.m_targetsToSpreadQuickhack;
    if spreadableQuickhackActionID == TDBID.None() || ArraySize(targetsToSpread) == 0 {
      this.m_MonoWireApplyQuickhackEffector.ClearSpreadAttack();
      return;
    };
    i = 0;
    while i < ArraySize(targetsToSpread) {
      if StatusEffectSystem.ObjectHasStatusEffect(targetsToSpread[i].m_NPCPuppet, t"BaseStatusEffect.MonoWireQuickhackContagiousHittableTarget") {
        hasTargetWithContagiousEffect = true;
        break;
      };
      i += 1;
    };
    if !hasTargetWithContagiousEffect {
      return;
    };
    blackboard.SetInt(GetAllBlackboardDefs().PlayerStateMachine.AmountOfCostFreeActions, ArraySize(targetsToSpread) - 1);
    i = 0;
    while i < ArraySize(targetsToSpread) {
      if StatusEffectSystem.ObjectHasStatusEffect(targetsToSpread[i].m_NPCPuppet, t"BaseStatusEffect.MonoWireQuickhackContagiousHittableTarget") {
      } else {
        spreadableQuickhackData = RPGManager.CreateSimpleQuickhackData(this.m_PlayerPuppet, targetsToSpread[i].m_NPCPuppet, TweakDBInterface.GetObjectActionRecord(spreadableQuickhackActionID));
        if StatusEffectSystem.ObjectHasStatusEffect(targetsToSpread[i].m_NPCPuppet, t"BaseStatusEffect.MonoWireQuickhackContagiousHittableTarget") {
        } else {
          StatusEffectHelper.ApplyStatusEffectForTimeWindow(targetsToSpread[i].m_NPCPuppet, t"BaseStatusEffect.MonoWireQuickhackApliedBySpread", this.m_PlayerPuppet.GetEntityID(), spreadableQuickhackData.m_uploadTime, spreadableQuickhackData.m_duration);
          this.m_MonoWireApplyQuickhackEffector.SpawnFXs(targetsToSpread[i].m_HitEvent, targetsToSpread[i].m_NPCPuppet, false);
          this.m_MonoWireApplyQuickhackEffector.TriggerSpecialQuickHackAttack(this.m_PlayerPuppet, spreadableQuickhackData, 0.10);
        };
      };
      i += 1;
    };
    this.m_MonoWireApplyQuickhackEffector.ClearSpreadAttack();
  }
}
