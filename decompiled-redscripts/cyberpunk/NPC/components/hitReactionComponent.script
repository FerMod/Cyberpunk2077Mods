
public class HitReactionBehaviorData extends IScriptable {

  public let m_hitReactionType: animHitReactionType;

  public let m_hitReactionActivationTimeStamp: Float;

  public let m_hitReactionDuration: Float;

  public final const func GetHitReactionDeactivationTimeStamp() -> Float {
    return this.m_hitReactionActivationTimeStamp + this.m_hitReactionDuration;
  }
}

public class NPCHealthListener extends ScriptStatPoolsListener {

  public let npc: wref<NPCPuppet>;

  public func OnStatPoolValueChanged(oldValue: Float, newValue: Float, percToPoints: Float) -> Void {
    this.npc.GetHitReactionComponent().UpdateOwnerHealthData(newValue);
  }
}

public class NPCHitReactionComponentStatsListener extends ScriptStatsListener {

  public let npc: wref<NPCPuppet>;

  public func OnStatChanged(ownerID: StatsObjectID, statType: gamedataStatType, diff: Float, total: Float) -> Void {
    switch statType {
      case gamedataStatType.HasExtendedHitReactionImmunity:
        this.npc.GetHitReactionComponent().UpdateOwnerExtendedHitReactionImmunityData(total);
        break;
      case gamedataStatType.HasMeleeHitReactionAndTakedownResistance:
        this.npc.GetHitReactionComponent().UpdateOwnerMeleeHitReactionResistanceData(total);
        break;
      case gamedataStatType.KnockdownDamageThresholdImpulse:
        this.npc.GetHitReactionComponent().UpdateOwnerKnockdownDamageThresholdImpulseData(total);
        break;
      case gamedataStatType.ImpactDamageThresholdInCover:
        this.npc.GetHitReactionComponent().UpdateOwnerImpactDamageThresholdInCoverData(total);
        break;
      case gamedataStatType.StaggerDamageThresholdInCover:
        this.npc.GetHitReactionComponent().UpdateOwnerStaggerDamageThresholdInCoverData(total);
        break;
      case gamedataStatType.KnockdownDamageThresholdInCover:
        this.npc.GetHitReactionComponent().UpdateOwnerKnockdownDamageThresholdInCoverData(total);
        break;
      case gamedataStatType.ImpactDamageThreshold:
        this.npc.GetHitReactionComponent().UpdateOwnerImpactDamageThresholdData(total);
        break;
      case gamedataStatType.StaggerDamageThreshold:
        this.npc.GetHitReactionComponent().UpdateOwnerStaggerDamageThresholdData(total);
        break;
      case gamedataStatType.KnockdownDamageThreshold:
        this.npc.GetHitReactionComponent().UpdateOwnerKnockdownDamageThresholdData(total);
        break;
      case gamedataStatType.KnockdownImmunity:
        this.npc.GetHitReactionComponent().UpdateOwnerKnockdownImmunityData(total);
        break;
      case gamedataStatType.CanDropWeapon:
        this.npc.GetHitReactionComponent().UpdateOwnerCanDropWeaponData(total);
        break;
      case gamedataStatType.IsInvulnerable:
        this.npc.GetHitReactionComponent().UpdateOwnerIsInvulnerableData(total);
        break;
      case gamedataStatType.CanBlock:
        this.npc.GetHitReactionComponent().UpdateOwnerCanBlockData(total);
        break;
      case gamedataStatType.HasKerenzikov:
        this.npc.GetHitReactionComponent().UpdateOwnerHasKerenzikovData(total);
        break;
      default:
        return;
    };
  }
}

public class HitReactionComponent extends AIMandatoryComponents {

  protected let m_ownerNPC: wref<NPCPuppet>;

  protected let m_ownerPuppet: wref<ScriptedPuppet>;

  protected let m_ownerWeapon: wref<WeaponObject>;

  protected let m_ownerID: EntityID;

  protected let m_statsSystem: ref<StatsSystem>;

  protected let m_ownerIsMassive: Bool;

  @default(HitReactionComponent, 0.2)
  protected let m_impactDamageDuration: Float;

  @default(HitReactionComponent, 0.4)
  protected let m_staggerDamageDuration: Float;

  @default(HitReactionComponent, 0.25)
  protected let m_impactDamageDurationMelee: Float;

  @default(HitReactionComponent, 1.5)
  protected let m_staggerDamageDurationMelee: Float;

  @default(HitReactionComponent, 2.5)
  protected let m_knockdownDamageDuration: Float;

  protected let m_defeatedMinDuration: Float;

  protected let m_previousHitTime: Float;

  protected let m_reactionType: animHitReactionType;

  protected let m_animHitReaction: ref<AnimFeature_HitReactionsData>;

  protected let m_lastAnimHitReaction: ref<AnimFeature_HitReactionsData>;

  protected let m_hitReactionAction: ref<ActionHitReactionScriptProxy>;

  protected let m_previousAnimHitReactionArray: [ScriptHitData];

  protected let m_lastHitReactionPlayed: EAILastHitReactionPlayed;

  protected let m_hitShapeData: HitShapeData;

  protected let m_animVariation: Int32;

  protected let m_specificHitTimeout: Float;

  protected let m_quickMeleeCooldown: Float;

  protected let m_dismembermentBodyPartDamageThreshold: [Float];

  protected let m_woundedBodyPartDamageThreshold: [Float];

  protected let m_defeatedBodyPartDamageThreshold: [Float];

  protected let m_defeatedDamageThreshold: Float;

  protected let m_impactDamageThreshold: Float;

  protected let m_staggerDamageThreshold: Float;

  protected let m_knockdownDamageThreshold: Float;

  protected let m_knockdownImpulseThreshold: Float;

  protected let m_immuneToKnockDown: Bool;

  @default(HitReactionComponent, 2.f)
  protected let m_hitComboReset: Float;

  @default(HitReactionComponent, 0.5f)
  protected let m_physicalImpulseReset: Float;

  @default(HitReactionComponent, 5.f)
  protected let m_guardBreakImpulseReset: Float;

  protected let m_cumulatedDamages: Float;

  protected let m_bodyPartWoundCumulatedDamages: [Float];

  protected let m_bodyPartDismemberCumulatedDamages: [Float];

  protected let m_attackerWeaponKnockdownImpulse: Float;

  protected let m_attackerWeaponKnockdownImpulseForEvade: Float;

  protected let m_attackerWeaponKnockdownImpulseForEvadeCumulation: Float;

  protected let m_ownerWeaponKnockdownImpulseForEvade: Float;

  protected let m_cumulatedPhysicalImpulse: Float;

  protected let m_cumulatedGuardBreakImpulse: Float;

  protected let m_cumulatedEvadeBreakImpulse: Float;

  protected let m_ragdollImpulse: Float;

  @default(HitReactionComponent, 5.f)
  protected let m_ragdollInfluenceRadius: Float;

  protected let m_hitIntensity: EAIHitIntensity;

  @default(HitReactionComponent, -1.f)
  protected let m_previousMeleeHitTimeStamp: Float;

  @default(HitReactionComponent, -1.f)
  protected let m_previousRangedHitTimeStamp: Float;

  @default(HitReactionComponent, -1.f)
  protected let m_previousBlockTimeStamp: Float;

  @default(HitReactionComponent, -1.f)
  protected let m_previousParryTimeStamp: Float;

  protected let m_previousDodgeTimeStamp: Float;

  protected let m_previousRagdollTimeStamp: Float;

  @default(HitReactionComponent, -1.f)
  protected let m_previousHackStaggerTimeStamp: Float;

  @default(HitReactionComponent, -1.f)
  protected let m_previousHackImpactTimeStamp: Float;

  protected let m_blockCount: Int32;

  protected let m_parryCount: Int32;

  protected let m_dodgeCount: Int32;

  public let m_hitCount: Uint32;

  protected let m_defeatedHasBeenPlayed: Bool;

  protected let m_defeatedRegisteredTime: Float;

  protected let m_deathHasBeenPlayed: Bool;

  protected let m_deathRegisteredTime: Float;

  protected let m_extendedDeathRegisteredTime: Float;

  protected let m_extendedDeathDelayRegisteredTime: Float;

  protected let m_extendedHitReactionRegisteredTime: Float;

  protected let m_extendedHitReactionDelayRegisteredTime: Float;

  protected let m_scatteredGuts: Bool;

  @default(HitReactionComponent, 0.25f)
  protected const let m_cumulativeDamageUpdateInterval: Float;

  @default(HitReactionComponent, false)
  protected let m_cumulativeDamageUpdateRequested: Bool;

  protected let m_currentStimId: Uint32;

  protected let m_attackData: ref<AttackData>;

  protected let m_attackDirectionToInt: Int32;

  protected let m_hitPosition: Vector4;

  protected let m_hitDirection: Vector4;

  protected let m_hitDirectionToInt: Int32;

  protected let m_overridenHitDirection: Bool;

  protected let m_lastHitReactionBehaviorData: ref<HitReactionBehaviorData>;

  protected let m_lastStimName: CName;

  protected let m_deathStimName: CName;

  protected let m_meleeHitCount: Int32;

  protected let m_strongMeleeHitCount: Int32;

  protected let m_meleeBaseMaxHitChain: Int32;

  protected let m_rangedBaseMaxHitChain: Int32;

  @default(HitReactionComponent, 2)
  protected let m_maxHitChainForMelee: Int32;

  @default(HitReactionComponent, 2)
  protected let m_maxHitChainForRanged: Int32;

  protected let m_isAlive: Bool;

  protected let m_frameDamageHealthFactor: Float;

  protected let m_hitCountData: [Float; 100];

  @default(HitReactionComponent, 100)
  protected let m_hitCountArrayEnd: Int32;

  protected let m_hitCountArrayCurrent: Int32;

  protected let m_allowDefeatedOnCompanion: Bool;

  protected let m_baseCumulativeDamagesDecreaser: Float;

  protected let m_blockCountInterval: Float;

  protected let m_dodgeCountInterval: Float;

  protected let m_globalHitTimer: Float;

  protected let m_hasMantisBladesinRecord: Bool;

  private let m_indicatorEnabledBlackboardId: ref<CallbackHandle>;

  private let m_hitIndicatorEnabled: Bool;

  private let m_hasBeenWounded: Bool;

  private let m_inWorkspot: Bool;

  private let m_inCover: Bool;

  private let m_healthListener: ref<NPCHealthListener>;

  private let m_hitReactionComponentStatsListener: ref<NPCHitReactionComponentStatsListener>;

  private let m_currentHealth: Float;

  private let m_totalHealth: Float;

  private let m_totalStamina: Float;

  private let m_currentCanDropWeapon: Float;

  private let m_currentExtendedHitReactionImmunity: Float;

  private let m_currentIsInvulnerable: Float;

  private let m_currentDefeatedDamageThreshold: Float;

  private let m_currentImpactDamageThreshold: Float;

  private let m_currentImpactDamageThresholdInCover: Float;

  private let m_currentKnockdownDamageThreshold: Float;

  private let m_currentKnockdownDamageThresholdImpulse: Float;

  private let m_currentKnockdownDamageThresholdInCover: Float;

  private let m_currentKnockdownImmunity: Float;

  private let m_currentMeleeHitReactionResistance: Float;

  private let m_currentStaggerDamageThreshold: Float;

  private let m_currentStaggerDamageThresholdInCover: Float;

  private let m_currentCanBlock: Float;

  private let m_currentHasKerenzikov: Float;

  private let m_dismemberExecuteHealthRange: Vector2;

  private let m_dismemberExecuteDistanceRange: Vector2;

  @default(HitReactionComponent, false)
  private let m_executeDismembered: Bool;

  @default(HitReactionComponent, false)
  private let m_attackIsValidBodyPerk: Bool;

  @default(HitReactionComponent, false)
  private let m_invalidForExecuteDismember: Bool;

  private let m_hitReactionData: ref<AnimFeature_HitReactionsData>;

  protected final func UpdateDBParams(data: ref<ScriptTaskData>) -> Void {
    this.GetDBParameters();
  }

  protected final func GetDBParameters() -> Void {
    let primaryItemInRecord: ref<NPCEquipmentItem_Record>;
    let primaryWeaponID: ItemID;
    let ownerID: StatsObjectID = Cast<StatsObjectID>(this.GetOwner().GetEntityID());
    this.m_totalHealth = this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.Health);
    this.m_totalStamina = this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.Stamina);
    this.UpdateOwnerHealthData(GameInstance.GetStatPoolsSystem(this.m_ownerNPC.GetGame()).GetStatPoolValue(ownerID, gamedataStatPoolType.Health));
    this.m_impactDamageDuration = this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.HitTimerAfterImpact);
    this.m_staggerDamageDuration = this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.HitTimerAfterStagger);
    this.m_knockdownDamageDuration = this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.HitTimerAfterKnockdown);
    this.m_impactDamageDurationMelee = this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.HitTimerAfterImpactMelee);
    this.m_staggerDamageDurationMelee = this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.HitTimerAfterStaggerMelee);
    this.m_defeatedMinDuration = this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.HitTimerAfterDefeated);
    this.m_hitComboReset = TweakDBInterface.GetFloat(t"GlobalStats.ReactionHitChainReset.value", 10.00);
    this.m_frameDamageHealthFactor = this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.HitReactionDamageHealthFactor);
    this.m_woundedBodyPartDamageThreshold[0] = this.m_totalHealth * this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.WoundHeadDamageThreshold) * 0.01;
    this.m_woundedBodyPartDamageThreshold[1] = this.m_totalHealth;
    this.m_woundedBodyPartDamageThreshold[2] = this.m_totalHealth * this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.WoundLArmDamageThreshold) * 0.01;
    this.m_woundedBodyPartDamageThreshold[3] = this.m_totalHealth * this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.WoundLArmDamageThreshold) * 0.01;
    this.m_woundedBodyPartDamageThreshold[4] = this.m_totalHealth;
    this.m_woundedBodyPartDamageThreshold[5] = this.m_totalHealth * this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.WoundRArmDamageThreshold) * 0.01;
    this.m_woundedBodyPartDamageThreshold[6] = this.m_totalHealth * this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.WoundRArmDamageThreshold) * 0.01;
    this.m_woundedBodyPartDamageThreshold[7] = this.m_totalHealth;
    this.m_woundedBodyPartDamageThreshold[8] = this.m_totalHealth * this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.WoundLLegDamageThreshold) * 0.01;
    this.m_woundedBodyPartDamageThreshold[9] = this.m_totalHealth * this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.WoundRLegDamageThreshold) * 0.01;
    this.m_dismembermentBodyPartDamageThreshold[0] = this.m_totalHealth * this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.DismHeadDamageThreshold) * 0.01;
    this.m_dismembermentBodyPartDamageThreshold[1] = this.m_totalHealth;
    this.m_dismembermentBodyPartDamageThreshold[2] = this.m_totalHealth * this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.DismLArmDamageThreshold) * 0.01;
    this.m_dismembermentBodyPartDamageThreshold[3] = this.m_totalHealth * this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.DismLArmDamageThreshold) * 0.01;
    this.m_dismembermentBodyPartDamageThreshold[4] = this.m_totalHealth;
    this.m_dismembermentBodyPartDamageThreshold[5] = this.m_totalHealth * this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.DismRArmDamageThreshold) * 0.01;
    this.m_dismembermentBodyPartDamageThreshold[6] = this.m_totalHealth * this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.DismRArmDamageThreshold) * 0.01;
    this.m_dismembermentBodyPartDamageThreshold[7] = this.m_totalHealth;
    this.m_dismembermentBodyPartDamageThreshold[8] = this.m_totalHealth * this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.DismLLegDamageThreshold) * 0.01;
    this.m_dismembermentBodyPartDamageThreshold[9] = this.m_totalHealth * this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.DismRLegDamageThreshold) * 0.01;
    this.m_defeatedBodyPartDamageThreshold[0] = this.m_totalHealth * this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.DefeatedHeadDamageThreshold) * 0.01;
    this.m_defeatedBodyPartDamageThreshold[1] = this.m_totalHealth * this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.DefeatedLArmDamageThreshold) * 0.01;
    this.m_defeatedBodyPartDamageThreshold[2] = this.m_totalHealth * this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.DefeatedLArmDamageThreshold) * 0.01;
    this.m_defeatedBodyPartDamageThreshold[3] = this.m_totalHealth * this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.DefeatedLArmDamageThreshold) * 0.01;
    this.m_defeatedBodyPartDamageThreshold[4] = this.m_totalHealth * this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.DefeatedRArmDamageThreshold) * 0.01;
    this.m_defeatedBodyPartDamageThreshold[5] = this.m_totalHealth * this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.DefeatedRArmDamageThreshold) * 0.01;
    this.m_defeatedBodyPartDamageThreshold[6] = this.m_totalHealth * this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.DefeatedRArmDamageThreshold) * 0.01;
    this.m_defeatedBodyPartDamageThreshold[7] = this.m_totalHealth * this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.DefeatedLArmDamageThreshold) * 0.01;
    this.m_defeatedBodyPartDamageThreshold[8] = this.m_totalHealth * this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.DefeatedLLegDamageThreshold) * 0.01;
    this.m_defeatedBodyPartDamageThreshold[9] = this.m_totalHealth * this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.DefeatedRLegDamageThreshold) * 0.01;
    this.m_guardBreakImpulseReset = AITweakParams.GetFloatFromTweak(t"AIGeneralSettings", "blockResetCooldown");
    this.m_dismemberExecuteHealthRange.X = AITweakParams.GetFloatFromTweak(t"AIGeneralSettings", "DismemberingExecute.missingHealthStart");
    this.m_dismemberExecuteHealthRange.Y = AITweakParams.GetFloatFromTweak(t"AIGeneralSettings", "DismemberingExecute.missingHealthEnd");
    this.m_dismemberExecuteDistanceRange.X = AITweakParams.GetFloatFromTweak(t"AIGeneralSettings", "DismemberingExecute.distanceCloseRange");
    this.m_dismemberExecuteDistanceRange.Y = AITweakParams.GetFloatFromTweak(t"AIGeneralSettings", "DismemberingExecute.distanceFarRange");
    if AIActionHelper.CheckAbility(this.m_ownerNPC, TweakDBInterface.GetGameplayAbilityRecord(t"Ability.IsTier1Archetype")) {
      this.m_meleeBaseMaxHitChain = AITweakParams.GetIntFromTweak(t"AIGeneralSettings", "hitChainBeforeDodgeForMeleeTier1");
      this.m_rangedBaseMaxHitChain = AITweakParams.GetIntFromTweak(t"AIGeneralSettings", "hitChainBeforeDodgeForRangedTier1");
    } else {
      if AIActionHelper.CheckAbility(this.m_ownerNPC, TweakDBInterface.GetGameplayAbilityRecord(t"Ability.IsTier2Archetype")) {
        this.m_meleeBaseMaxHitChain = AITweakParams.GetIntFromTweak(t"AIGeneralSettings", "hitChainBeforeDodgeForMeleeTier2");
        this.m_rangedBaseMaxHitChain = AITweakParams.GetIntFromTweak(t"AIGeneralSettings", "hitChainBeforeDodgeForRangedTier2");
        this.m_guardBreakImpulseReset += AITweakParams.GetFloatFromTweak(t"AIGeneralSettings", "tier2BlockCooldownModifier");
      } else {
        if AIActionHelper.CheckAbility(this.m_ownerNPC, TweakDBInterface.GetGameplayAbilityRecord(t"Ability.IsTier3Archetype")) {
          this.m_meleeBaseMaxHitChain = AITweakParams.GetIntFromTweak(t"AIGeneralSettings", "hitChainBeforeDodgeForMeleeTier3");
          this.m_rangedBaseMaxHitChain = AITweakParams.GetIntFromTweak(t"AIGeneralSettings", "hitChainBeforeDodgeForRangedTier3");
          this.m_guardBreakImpulseReset += AITweakParams.GetFloatFromTweak(t"AIGeneralSettings", "tier3BlockCooldownModifier");
        };
      };
    };
    if this.m_ownerNPC.IsBoss() || Equals(this.m_ownerNPC.GetNPCRarity(), gamedataNPCRarity.MaxTac) {
      this.m_guardBreakImpulseReset += AITweakParams.GetFloatFromTweak(t"AIGeneralSettings", "bossBlockCooldownModifier");
    };
    this.m_allowDefeatedOnCompanion = AITweakParams.GetBoolFromTweak(t"AIGeneralSettings.followers", "allowDefeated");
    this.m_currentDefeatedDamageThreshold = AITweakParams.GetFloatFromTweak(t"AIGeneralSettings.followers", "defeatedDamageThreshold");
    this.m_baseCumulativeDamagesDecreaser = TweakDBInterface.GetFloat(t"GlobalStats.CumulativeDmgDecreaser.value", 2.00);
    this.m_blockCountInterval = TweakDBInterface.GetFloat(t"GlobalStats.BlockCountInterval.value", 2.00);
    this.m_dodgeCountInterval = TweakDBInterface.GetFloat(t"GlobalStats.DodgeCountInterval.value", 1.50);
    this.m_globalHitTimer = TweakDBInterface.GetFloat(t"GlobalStats.GlobalHitTimer.value", 1.00);
    primaryItemInRecord = TweakDBInterface.GetCharacterRecord(this.m_ownerNPC.GetRecordID()).PrimaryEquipment().GetEquipmentItemsItem(0) as NPCEquipmentItem_Record;
    AIActionTransactionSystem.GetItemID(this.GetOwner() as ScriptedPuppet, primaryItemInRecord.Item(), primaryItemInRecord.OnBodySlot().GetID(), primaryWeaponID);
    this.m_ownerWeaponKnockdownImpulseForEvade = this.m_statsSystem.GetStatValue(Cast<StatsObjectID>(this.m_ownerWeapon.GetEntityID()), gamedataStatType.BaseKnockdownImpulse);
    this.m_hasMantisBladesinRecord = Equals(TweakDBInterface.GetWeaponItemRecord(ItemID.GetTDBID(primaryWeaponID)).ItemType().Type(), gamedataItemType.Cyb_MantisBlades);
    this.m_healthListener = new NPCHealthListener();
    this.m_healthListener.npc = this.GetOwner() as NPCPuppet;
    GameInstance.GetStatPoolsSystem(this.GetOwner().GetGame()).RequestRegisteringListener(ownerID, gamedataStatPoolType.Health, this.m_healthListener);
    this.m_hitReactionComponentStatsListener = new NPCHitReactionComponentStatsListener();
    this.m_hitReactionComponentStatsListener.npc = this.GetOwner() as NPCPuppet;
    this.m_statsSystem.RegisterListener(ownerID, this.m_hitReactionComponentStatsListener);
    this.UpdateOwnerExtendedHitReactionImmunityData(this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.HasExtendedHitReactionImmunity));
    this.UpdateOwnerMeleeHitReactionResistanceData(this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.HasMeleeHitReactionAndTakedownResistance));
    this.UpdateOwnerKnockdownDamageThresholdImpulseData(this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.KnockdownDamageThresholdImpulse));
    this.UpdateOwnerImpactDamageThresholdInCoverData(this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.ImpactDamageThresholdInCover));
    this.UpdateOwnerStaggerDamageThresholdInCoverData(this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.StaggerDamageThresholdInCover));
    this.UpdateOwnerKnockdownDamageThresholdInCoverData(this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.KnockdownDamageThresholdInCover));
    this.UpdateOwnerImpactDamageThresholdData(this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.ImpactDamageThreshold));
    this.UpdateOwnerStaggerDamageThresholdData(this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.StaggerDamageThreshold));
    this.UpdateOwnerKnockdownDamageThresholdData(this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.KnockdownDamageThreshold));
    this.UpdateOwnerKnockdownImmunityData(this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.KnockdownImmunity));
    this.UpdateOwnerCanDropWeaponData(this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.CanDropWeapon));
    this.UpdateOwnerIsInvulnerableData(this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.IsInvulnerable));
    this.UpdateOwnerCanBlockData(this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.CanBlock));
    this.UpdateOwnerHasKerenzikovData(this.m_statsSystem.GetStatValue(ownerID, gamedataStatType.HasKerenzikov));
  }

  public final const func GetMeleeMaxHitChain() -> Int32 {
    return this.m_maxHitChainForMelee;
  }

  public final const func GetRangedMaxHitChain() -> Int32 {
    return this.m_maxHitChainForRanged;
  }

  public final const func GetDeathHasBeenPlayed() -> Bool {
    return this.m_deathHasBeenPlayed;
  }

  public final const func GetDefeatedHasBeenPlayed() -> Bool {
    return this.m_defeatedHasBeenPlayed;
  }

  public final const func IsExecutedByDismemberment() -> Bool {
    return this.m_executeDismembered;
  }

  public final const func GetHitCountInCombo() -> Int32 {
    return this.m_meleeHitCount;
  }

  public final const func GetStrongHitCountInCombo() -> Int32 {
    return this.m_strongMeleeHitCount;
  }

  public final const func GetLastStimName() -> CName {
    return this.m_lastStimName;
  }

  public final const func GetDeathStimName() -> CName {
    return this.m_deathStimName;
  }

  public final const func GetHitReactionType() -> Int32 {
    return this.m_animHitReaction.hitType;
  }

  public final const func GetAttackTag() -> CName {
    let attackTag: CName;
    let attackRecord: ref<Attack_GameEffect_Record> = this.m_attackData.GetAttackDefinition().GetRecord() as Attack_GameEffect_Record;
    if IsDefined(attackRecord) {
      attackTag = attackRecord.AttackTag();
    };
    return attackTag;
  }

  public final const func GetAttackType() -> gamedataAttackType {
    return this.m_attackData.GetAttackType();
  }

  public final const func GetSubAttackSubType() -> gamedataAttackSubtype {
    let attackSubTypeRecord: ref<AttackSubtype_Record>;
    let attackRecord: ref<Attack_Melee_Record> = this.m_attackData.GetAttackDefinition().GetRecord() as Attack_Melee_Record;
    if IsDefined(attackRecord) {
      attackSubTypeRecord = attackRecord.AttackSubtype();
      if IsDefined(attackSubTypeRecord) {
        return attackSubTypeRecord.Type();
      };
    };
    return gamedataAttackSubtype.Invalid;
  }

  public final const func GetHitReactionData() -> ref<AnimFeature_HitReactionsData> {
    return this.m_animHitReaction;
  }

  public final const func GetLastHitReactionData() -> ref<AnimFeature_HitReactionsData> {
    return this.m_lastAnimHitReaction;
  }

  public final const func GetBlockCount() -> Int32 {
    if EngineTime.ToFloat(this.GetSimTime()) > this.m_previousBlockTimeStamp + this.m_blockCountInterval {
      return 0;
    };
    return this.m_blockCount;
  }

  public final const func GetParryCount() -> Int32 {
    if EngineTime.ToFloat(this.GetSimTime()) > this.m_previousParryTimeStamp + this.m_blockCountInterval {
      return 0;
    };
    return this.m_parryCount;
  }

  public final const func GetDodgeCount() -> Int32 {
    if EngineTime.ToFloat(this.GetSimTime()) > this.m_previousDodgeTimeStamp + this.m_dodgeCountInterval {
      return 0;
    };
    return this.m_dodgeCount;
  }

  public final const func GetCumulatedDamage() -> Float {
    return this.m_cumulatedDamages;
  }

  public final const func GetLastHitReactionBehaviorData() -> ref<HitReactionBehaviorData> {
    return this.m_lastHitReactionBehaviorData;
  }

  public final const func GetHitReactionProxyAction() -> ref<ActionHitReactionScriptProxy> {
    return this.m_hitReactionAction;
  }

  public final const func GetLastStimID() -> Uint32 {
    return this.m_currentStimId;
  }

  public final const func GetHitSource() -> wref<GameObject> {
    return this.m_attackData.GetSource();
  }

  public final const func GetHitInstigator() -> wref<GameObject> {
    return this.m_attackData.GetInstigator();
  }

  public final const func GetHitPosition() -> Vector4 {
    return this.m_hitPosition;
  }

  public final const func GetHitDirection() -> Vector4 {
    return this.m_hitDirection;
  }

  public final const func GetAttackDirection() -> Int32 {
    return this.m_attackDirectionToInt;
  }

  public final const func GetCanBlock() -> Bool {
    return this.m_currentCanBlock > 0.00;
  }

  public final const func GetHasKerenzikov() -> Bool {
    return this.m_currentHasKerenzikov > 0.00;
  }

  public final const func GetShouldEvade() -> Bool {
    let result: Bool;
    let attackWeaponType: gamedataItemType = ScriptedPuppet.GetWeaponRight(this.m_attackData.GetSource()).GetWeaponRecord().ItemType().Type();
    if this.m_attackerWeaponKnockdownImpulseForEvade > this.m_ownerWeaponKnockdownImpulseForEvade || Equals(this.m_ownerWeapon.GetWeaponRecord().ItemType().Type(), gamedataItemType.Wea_Fists) && NotEquals(attackWeaponType, gamedataItemType.Wea_Fists) && NotEquals(attackWeaponType, gamedataItemType.Cyb_StrongArms) {
      result = true;
    };
    if this.m_cumulatedGuardBreakImpulse >= this.m_totalStamina {
      result = true;
    };
    return result;
  }

  public final func GetOverridenHitDirection() -> Vector4 {
    let hitPosition: Vector4;
    let ownerPosition: Vector4;
    if this.m_overridenHitDirection {
      hitPosition = this.GetHitPosition();
      ownerPosition = this.m_ownerNPC.GetWorldPosition();
      ownerPosition.Z = hitPosition.Z;
      return Vector4.Normalize(ownerPosition - hitPosition);
    };
    return this.GetHitDirection();
  }

  public final const func GetHitDirectionToInt() -> Int32 {
    return this.m_hitDirectionToInt;
  }

  public final const func GetRagdollImpulse() -> Float {
    return this.m_ragdollImpulse;
  }

  public final func IsInKnockdown() -> Bool {
    if StatusEffectSystem.ObjectHasStatusEffectOfType(this.GetOwner(), gamedataStatusEffectType.Knockdown) {
      return true;
    };
    if this.m_specificHitTimeout > this.GetCurrentTime() && Equals(this.m_lastHitReactionPlayed, EAILastHitReactionPlayed.Knockdown) {
      return true;
    };
    return false;
  }

  public final func GetHitAnimationInProgress() -> Bool {
    return this.m_specificHitTimeout > this.GetCurrentTime();
  }

  public final func UpdateOwnerHealthData(Value: Float) -> Void {
    this.m_currentHealth = Value;
  }

  public final func UpdateOwnerCanDropWeaponData(Value: Float) -> Void {
    this.m_currentCanDropWeapon = Value;
  }

  public final func UpdateOwnerExtendedHitReactionImmunityData(Value: Float) -> Void {
    this.m_currentExtendedHitReactionImmunity = Value;
  }

  public final func UpdateOwnerIsInvulnerableData(Value: Float) -> Void {
    this.m_currentIsInvulnerable = Value;
  }

  public final func UpdateOwnerImpactDamageThresholdData(Value: Float) -> Void {
    this.m_currentImpactDamageThreshold = Value;
  }

  public final func UpdateOwnerImpactDamageThresholdInCoverData(Value: Float) -> Void {
    this.m_currentImpactDamageThresholdInCover = Value;
  }

  public final func UpdateOwnerKnockdownDamageThresholdData(Value: Float) -> Void {
    this.m_currentKnockdownDamageThreshold = Value;
  }

  public final func UpdateOwnerKnockdownDamageThresholdImpulseData(Value: Float) -> Void {
    this.m_currentKnockdownDamageThresholdImpulse = Value;
  }

  public final func UpdateOwnerKnockdownDamageThresholdInCoverData(Value: Float) -> Void {
    this.m_currentKnockdownDamageThresholdInCover = Value;
  }

  public final func UpdateOwnerKnockdownImmunityData(Value: Float) -> Void {
    this.m_currentKnockdownImmunity = Value;
  }

  public final func UpdateOwnerMeleeHitReactionResistanceData(Value: Float) -> Void {
    this.m_currentMeleeHitReactionResistance = Value;
  }

  public final func UpdateOwnerStaggerDamageThresholdData(Value: Float) -> Void {
    this.m_currentStaggerDamageThreshold = Value;
  }

  public final func UpdateOwnerStaggerDamageThresholdInCoverData(Value: Float) -> Void {
    this.m_currentStaggerDamageThresholdInCover = Value;
  }

  public final func UpdateOwnerCanBlockData(Value: Float) -> Void {
    this.m_currentCanBlock = Value;
  }

  public final func UpdateOwnerHasKerenzikovData(Value: Float) -> Void {
    this.m_currentHasKerenzikov = Value;
  }

  public final func UpdateDeathHasBeenPlayed() -> Void {
    this.m_deathHasBeenPlayed = true;
  }

  public final func UpdateLastStimID() -> Uint32 {
    this.m_currentStimId += 1u;
    return this.m_currentStimId;
  }

  public final func ResetHitCount() -> Void {
    this.m_meleeHitCount = 0;
    this.m_strongMeleeHitCount = 0;
  }

  public final func SetLastStimName(laststimName: CName) -> Void {
    this.m_lastStimName = laststimName;
  }

  public final func SetDeathStimName(laststimName: CName) -> Void {
    this.m_deathStimName = laststimName;
  }

  public final func UpdateBlockCount() -> Void {
    this.m_blockCount += 1;
    if this.GetCurrentTime() > this.m_previousBlockTimeStamp + this.m_blockCountInterval {
      this.m_blockCount = 1;
    };
    this.m_previousBlockTimeStamp = this.GetCurrentTime();
  }

  public final func UpdateParryCount() -> Void {
    this.m_parryCount += 1;
    if this.GetCurrentTime() > this.m_previousParryTimeStamp + this.m_blockCountInterval {
      this.m_parryCount = 1;
    };
    this.m_previousParryTimeStamp = this.GetCurrentTime();
  }

  public final func UpdateDodgeCount() -> Void {
    this.m_dodgeCount += 1;
    if this.GetCurrentTime() > this.m_previousDodgeTimeStamp + this.m_dodgeCountInterval {
      this.m_dodgeCount = 1;
    };
    this.m_previousDodgeTimeStamp = this.GetCurrentTime();
  }

  private final func GetHealthPecentageNormalized() -> Float {
    return this.GetOwnerCurrentHealth() * 0.01;
  }

  private final func GetFrameDamage() -> Float {
    let factor: Float = 1.00;
    let frameDamage: Float = this.m_ownerNPC.GetTotalFrameDamage();
    if this.m_frameDamageHealthFactor > 0.00 {
      factor = 1.00 + (1.00 - this.GetHealthPecentageNormalized()) * this.m_frameDamageHealthFactor;
    };
    return frameDamage * factor;
  }

  private final func GetPhysicalImpulse(attackData: ref<AttackData>, hitPosition: Vector4, out frameImpulse: Float) -> Float {
    let attackSpeed: Float;
    let attackWeaponID: StatsObjectID;
    let finalImpulse: Float;
    let highSpeedHit: Bool;
    let inAir: Bool;
    let maxValue: Float;
    let projectilesNum: Float;
    if IsDefined(attackData.GetWeapon()) {
      attackWeaponID = Cast<StatsObjectID>(attackData.GetWeapon().GetEntityID());
    };
    if this.m_previousHitTime + this.m_physicalImpulseReset < this.GetCurrentTime() {
      this.m_cumulatedPhysicalImpulse = 0.00;
    };
    if this.m_previousHitTime + this.m_guardBreakImpulseReset < this.GetCurrentTime() {
      this.m_cumulatedGuardBreakImpulse = 0.00;
      this.m_cumulatedEvadeBreakImpulse = 0.00;
    };
    this.m_attackerWeaponKnockdownImpulseForEvade = this.m_statsSystem.GetStatValue(attackWeaponID, gamedataStatType.BaseKnockdownImpulse);
    attackSpeed = this.m_statsSystem.GetStatValue(attackWeaponID, gamedataStatType.AttackSpeed);
    if attackSpeed == 0.00 {
      attackSpeed = 1.00;
    };
    this.m_attackerWeaponKnockdownImpulseForEvadeCumulation = this.m_statsSystem.GetStatValue(attackWeaponID, gamedataStatType.EvadeImpulse);
    this.m_attackerWeaponKnockdownImpulseForEvadeCumulation *= 1.00 / attackSpeed;
    this.m_attackerWeaponKnockdownImpulse = this.m_statsSystem.GetStatValue(attackWeaponID, gamedataStatType.KnockdownImpulse);
    frameImpulse = this.m_attackerWeaponKnockdownImpulse;
    inAir = this.m_ownerNPC.GetPuppetStateBlackboard().GetBool(GetAllBlackboardDefs().PuppetState.InAirAnimation);
    highSpeedHit = this.m_attackData.HasFlag(hitFlag.HighSpeedMelee);
    if highSpeedHit || inAir || AttackData.IsStrongMelee(this.m_attackData.GetAttackType()) || AttackData.IsReflect(this.m_attackData.GetAttackType()) {
      if highSpeedHit {
        frameImpulse *= 2.67;
        maxValue = frameImpulse;
        this.m_ragdollImpulse = maxValue;
      } else {
        if AttackData.IsQuickMelee(this.m_attackData.GetAttackType()) {
          frameImpulse *= 0.50;
          maxValue = frameImpulse;
          this.m_ragdollImpulse = maxValue;
        } else {
          if AttackData.IsMelee(this.m_attackData.GetAttackType()) {
            this.m_attackerWeaponKnockdownImpulseForEvadeCumulation *= 1.67;
            this.m_ragdollImpulse = frameImpulse;
            frameImpulse *= 1.67;
            maxValue = frameImpulse;
          } else {
            frameImpulse *= 1.67;
            maxValue = frameImpulse;
            this.m_ragdollImpulse = maxValue;
          };
        };
      };
    } else {
      maxValue = 1.50 * frameImpulse;
      this.m_ragdollImpulse = frameImpulse;
    };
    if AttackData.IsRangedOrDirect(attackData.GetAttackType()) {
      frameImpulse *= DamageSystem.GetEffectiveRangeModifierForWeapon(attackData, hitPosition, this.m_statsSystem);
      projectilesNum = this.m_statsSystem.GetStatValue(attackWeaponID, gamedataStatType.ProjectilesPerShot);
      projectilesNum = ClampF(projectilesNum, 1.00, 5.00);
      frameImpulse /= projectilesNum;
    };
    if frameImpulse + this.m_cumulatedPhysicalImpulse > maxValue {
      finalImpulse = maxValue - this.m_cumulatedPhysicalImpulse;
    } else {
      finalImpulse = frameImpulse;
    };
    return finalImpulse > 0.00 ? finalImpulse : 0.00;
  }

  private final func GetFrameWoundsDamage() -> Float {
    return this.m_ownerNPC.GetTotalFrameWoundsDamage();
  }

  private final func GetFrameDismembermentDamage() -> Float {
    return this.m_ownerNPC.GetTotalFrameDismembermentDamage();
  }

  private final func GetOwnerHPPercentage() -> Float {
    return GameInstance.GetStatPoolsSystem(this.m_ownerNPC.GetGame()).GetStatPoolValue(Cast<StatsObjectID>(this.m_ownerID), gamedataStatPoolType.Health);
  }

  protected final func GetHitShapeUserData() -> ref<HitShapeUserDataBase> {
    return this.m_hitShapeData.userData as HitShapeUserDataBase;
  }

  private final func ResetFrameDamage() -> Void {
    let evt: ref<ResetFrameDamage> = new ResetFrameDamage();
    this.GetOwner().QueueEvent(evt);
  }

  protected final func GetCurrentTime() -> Float {
    return EngineTime.ToFloat(this.GetSimTime());
  }

  private final func IsOwnerFacingInstigator() -> Bool {
    let toTarget: Vector4 = this.m_attackData.GetInstigator().GetWorldPosition() - this.GetOwner().GetWorldPosition();
    let angle: Float = Vector4.GetAngleBetween(toTarget, this.GetOwner().GetWorldForward());
    return angle < 80.00;
  }

  private final func NotifyAboutWoundedInstigated(instigator: wref<GameObject>, const bodyPart: EHitReactionZone) -> Void {
    let evt: ref<WoundedInstigated>;
    if !IsDefined(instigator) {
      return;
    };
    evt = new WoundedInstigated();
    evt.bodyPart = bodyPart;
    instigator.QueueEvent(evt);
  }

  private final func NotifyAboutDismembermentInstigated(instigator: wref<GameObject>, const bodyPart: EHitReactionZone, const targetPosition: Vector4) -> Void {
    let evt: ref<DismembermentInstigated>;
    if !IsDefined(instigator) {
      return;
    };
    evt = new DismembermentInstigated();
    evt.targetPosition = targetPosition;
    evt.attackPosition = this.m_attackData.GetAttackPosition();
    evt.bodyPart = bodyPart;
    evt.attackType = this.m_attackData.GetAttackType();
    evt.attackSubtype = this.m_attackData.GetAttackSubtype();
    evt.weaponRecord = this.m_attackData.GetWeapon().GetWeaponRecord();
    evt.attackIsExplosion = AttackData.IsExplosion(evt.attackType) || this.m_attackData.HasFlag(hitFlag.Explosion);
    evt.target = this.m_ownerNPC;
    evt.targetIsDead = this.m_deathHasBeenPlayed;
    evt.timeSinceDeath = this.m_deathHasBeenPlayed ? this.GetCurrentTime() - this.m_deathRegisteredTime : 0.00;
    evt.targetIsDefeated = this.m_defeatedHasBeenPlayed;
    evt.timeSinceDefeat = this.m_defeatedHasBeenPlayed ? this.GetCurrentTime() - this.m_defeatedRegisteredTime : 0.00;
    instigator.QueueEvent(evt);
  }

  private final func GetOwnerTotalHealth() -> Float {
    return this.m_totalHealth;
  }

  private final func GetOwnerCurrentHealth() -> Float {
    return this.m_currentHealth;
  }

  private final func GetIsOwnerImmuneToExtendedHitReaction() -> Float {
    return this.m_currentExtendedHitReactionImmunity;
  }

  private final func GetIsOwnerResistantToMeleeHitReaction() -> Bool {
    return this.m_currentMeleeHitReactionResistance >= 1.00;
  }

  public func OnGameAttach() -> Void {
    let damageInfoBB: ref<IBlackboard>;
    let enumSize: Int32;
    this.m_animHitReaction = new AnimFeature_HitReactionsData();
    this.m_lastAnimHitReaction = new AnimFeature_HitReactionsData();
    this.m_hitReactionAction = new ActionHitReactionScriptProxy();
    this.m_hitReactionAction.Bind(this.GetOwner());
    this.m_ownerNPC = this.GetOwner() as NPCPuppet;
    this.m_ownerPuppet = this.GetOwner() as ScriptedPuppet;
    this.m_ownerID = this.GetOwner().GetEntityID();
    this.m_statsSystem = GameInstance.GetStatsSystem(this.m_ownerPuppet.GetGame());
    this.m_ownerWeapon = GameObject.GetActiveWeapon(this.m_ownerNPC);
    enumSize = Cast<Int32>(EnumGetMax(n"EHitReactionZone")) + 1;
    ArrayResize(this.m_bodyPartWoundCumulatedDamages, enumSize);
    ArrayResize(this.m_bodyPartDismemberCumulatedDamages, enumSize);
    ArrayResize(this.m_woundedBodyPartDamageThreshold, enumSize);
    ArrayResize(this.m_dismembermentBodyPartDamageThreshold, enumSize);
    ArrayResize(this.m_defeatedBodyPartDamageThreshold, enumSize);
    damageInfoBB = GameInstance.GetBlackboardSystem(this.GetOwner().GetGame()).Get(GetAllBlackboardDefs().UI_DamageInfo);
    this.m_indicatorEnabledBlackboardId = damageInfoBB.RegisterListenerBool(GetAllBlackboardDefs().UI_DamageInfo.HitIndicatorEnabled, this, n"OnHitIndicatorEnabledChanged");
    this.m_hitIndicatorEnabled = damageInfoBB.GetBool(GetAllBlackboardDefs().UI_DamageInfo.HitIndicatorEnabled);
    GameInstance.GetDelaySystem(this.GetOwner().GetGame()).QueueTask(this, null, n"UpdateDBParams", gameScriptTaskExecutionStage.Any);
    this.OnGameAttached();
  }

  public func OnGameAttached() -> Void;

  private final func OnGameDetach() -> Void {
    this.m_hitReactionAction = null;
    let damageInfoBB: ref<IBlackboard> = GameInstance.GetBlackboardSystem(this.GetOwner().GetGame()).Get(GetAllBlackboardDefs().UI_DamageInfo);
    if IsDefined(this.m_indicatorEnabledBlackboardId) {
      damageInfoBB.UnregisterListenerBool(GetAllBlackboardDefs().UI_DamageInfo.HitIndicatorEnabled, this.m_indicatorEnabledBlackboardId);
    };
    GameInstance.GetStatPoolsSystem(this.GetOwner().GetGame()).RequestUnregisteringListener(Cast<StatsObjectID>(this.GetOwner().GetEntityID()), gamedataStatPoolType.Health, this.m_healthListener);
    this.m_statsSystem.UnregisterListener(Cast<StatsObjectID>(this.GetOwner().GetEntityID()), this.m_hitReactionComponentStatsListener);
  }

  protected cb func OnItemAddedToSlot(evt: ref<ItemAddedToSlot>) -> Bool {
    let weaponID: EntityID;
    if IsDefined(TweakDBInterface.GetItemRecord(ItemID.GetTDBID(evt.GetItemID())) as WeaponItem_Record) {
      weaponID = GameObject.GetActiveWeapon(this.m_ownerNPC).GetEntityID();
      this.m_ownerWeaponKnockdownImpulseForEvade = this.m_statsSystem.GetStatValue(Cast<StatsObjectID>(weaponID), gamedataStatType.BaseKnockdownImpulse);
    };
    this.m_ownerWeapon = GameObject.GetActiveWeapon(this.m_ownerNPC);
  }

  protected cb func OnDefeated(evt: ref<DefeatedEvent>) -> Bool {
    if !this.m_invalidForExecuteDismember && this.m_attackIsValidBodyPerk && !this.m_executeDismembered {
      this.IncrementBodyPerkDismembermentChance(this.m_attackData.GetInstigator());
    };
  }

  protected cb func OnDeath(evt: ref<gameDeathEvent>) -> Bool {
    if !this.m_invalidForExecuteDismember && this.m_attackIsValidBodyPerk && !this.m_executeDismembered {
      this.IncrementBodyPerkDismembermentChance(this.m_attackData.GetInstigator());
    };
    if this.m_isAlive {
      this.m_reactionType = animHitReactionType.Death;
      this.m_isAlive = false;
      this.SendDataToAIBehavior(this.m_reactionType);
    };
  }

  protected cb func OnHitIndicatorEnabledChanged(value: Bool) -> Bool {
    this.m_hitIndicatorEnabled = value;
  }

  protected cb func OnResurrect(evt: ref<ResurrectEvent>) -> Bool {
    let i: Int32 = 0;
    while i < ArraySize(this.m_bodyPartDismemberCumulatedDamages) {
      this.m_bodyPartDismemberCumulatedDamages[i] = 0.00;
      i += 1;
    };
    this.m_cumulatedDamages = 0.00;
    this.m_defeatedHasBeenPlayed = false;
    this.m_defeatedRegisteredTime = 0.00;
  }

  protected cb func OnHitReactionCumulativeDamageUpdate(evt: ref<HitReactionCumulativeDamageUpdate>) -> Bool {
    this.m_cumulativeDamageUpdateRequested = false;
    let deltaTime: Float = this.GetCurrentTime() - evt.m_prevUpdateTime;
    if this.UpdateCumulatedDamages(deltaTime) {
      this.RequestCumulativeDamageUpdate();
    };
  }

  private final func RequestCumulativeDamageUpdate() -> Void {
    let evt: ref<HitReactionCumulativeDamageUpdate>;
    if this.m_cumulativeDamageUpdateRequested {
      return;
    };
    evt = new HitReactionCumulativeDamageUpdate();
    evt.m_prevUpdateTime = this.GetCurrentTime();
    GameInstance.GetDelaySystem(this.GetOwner().GetGame()).DelayEvent(this.GetOwner(), evt, this.m_cumulativeDamageUpdateInterval);
    this.m_cumulativeDamageUpdateRequested = true;
  }

  protected cb func OnHitReactionStopMotionExtraction(evt: ref<HitReactionStopMotionExtraction>) -> Bool {
    if IsDefined(this.m_hitReactionAction) {
      this.m_hitReactionAction.Stop();
    };
  }

  protected cb func OnRequestHitReaction(evt: ref<HitReactionRequest>) -> Bool {
    this.EvaluateHit(evt.hitEvent);
  }

  protected cb func OnForcedHitReaction(forcedHitReaction: ref<ForcedHitReactionEvent>) -> Bool {
    if forcedHitReaction.hitIntensity != -1 {
      this.m_animHitReaction.hitIntensity = forcedHitReaction.hitIntensity;
    };
    if forcedHitReaction.hitSource != -1 {
      this.SetHitReactionSource(IntEnum<EAIHitSource>(forcedHitReaction.hitSource));
    };
    if forcedHitReaction.hitBodyPart != -1 {
      this.m_animHitReaction.hitBodyPart = forcedHitReaction.hitBodyPart;
    };
    if forcedHitReaction.hitNpcMovementSpeed != -1 {
      this.m_animHitReaction.npcMovementSpeed = forcedHitReaction.hitNpcMovementSpeed;
    };
    if forcedHitReaction.hitDirection != -1 {
      this.m_animHitReaction.hitDirection = forcedHitReaction.hitDirection;
    };
    if forcedHitReaction.hitNpcMovementDirection != -1 {
      this.m_animHitReaction.npcMovementDirection = forcedHitReaction.hitNpcMovementDirection;
    };
    if forcedHitReaction.hitType != -1 {
      this.SetHitReactionType(IntEnum<animHitReactionType>(forcedHitReaction.hitType));
      this.SendDataToAIBehavior(IntEnum<animHitReactionType>(forcedHitReaction.hitType));
    } else {
      this.SetHitReactionType(animHitReactionType.Pain);
      this.SendDataToAIBehavior(animHitReactionType.Stagger);
    };
  }

  protected cb func OnForcedDeathEvent(forcedDeath: ref<ForcedDeathEvent>) -> Bool {
    if forcedDeath.hitIntensity != -1 {
      this.m_animHitReaction.hitIntensity = forcedDeath.hitIntensity;
    };
    if forcedDeath.hitSource != -1 {
      this.SetHitReactionSource(IntEnum<EAIHitSource>(forcedDeath.hitSource));
    };
    if forcedDeath.hitBodyPart != -1 {
      this.m_animHitReaction.hitBodyPart = forcedDeath.hitBodyPart;
    };
    if forcedDeath.hitNpcMovementSpeed != -1 {
      this.m_animHitReaction.npcMovementSpeed = forcedDeath.hitNpcMovementSpeed;
    };
    if forcedDeath.hitDirection != -1 {
      this.m_animHitReaction.hitDirection = forcedDeath.hitDirection;
    };
    if forcedDeath.hitNpcMovementDirection != -1 {
      this.m_animHitReaction.npcMovementDirection = forcedDeath.hitNpcMovementDirection;
    };
    this.SetHitReactionType(animHitReactionType.Death);
    this.m_ownerPuppet.Kill();
    if forcedDeath.forceRagdoll && ScriptedPuppet.CanRagdoll(this.m_ownerPuppet) {
      this.SendDataToAIBehavior(animHitReactionType.Ragdoll);
    } else {
      this.SendDataToAIBehavior(animHitReactionType.Death);
    };
    this.m_isAlive = false;
  }

  protected cb func OnSetLastHitReactionBehaviorData(evt: ref<LastHitDataEvent>) -> Bool {
    this.m_lastHitReactionBehaviorData = evt.hitReactionBehaviorData;
  }

  protected cb func OnSetNewHitReactionBehaviorData(evt: ref<NewHitDataEvent>) -> Bool {
    this.m_animHitReaction.hitDirection = evt.hitDirection;
    this.m_animHitReaction.hitIntensity = evt.hitIntensity;
    this.SetHitReactionType(IntEnum<animHitReactionType>(evt.hitType));
    this.m_animHitReaction.hitBodyPart = evt.hitBodyPart;
    this.m_animHitReaction.npcMovementSpeed = evt.hitNpcMovementSpeed;
    this.m_animHitReaction.npcMovementDirection = evt.hitNpcMovementDirection;
    this.m_animHitReaction.stance = evt.stance;
    this.m_animHitReaction.animVariation = evt.animVariation;
    this.SetHitReactionSource(IntEnum<EAIHitSource>(evt.hitSource));
  }

  private final func IsSoundCriticalHit(hitEvent: ref<gameHitEvent>) -> Bool {
    return hitEvent.attackData.HasFlag(hitFlag.Headshot) || hitEvent.attackData.HasFlag(hitFlag.WeakspotHit);
  }

  private final func GetKillSoundName(hitEvent: ref<gameHitEvent>) -> CName {
    let isSoundCritical: Bool = this.IsSoundCriticalHit(hitEvent);
    if Equals(this.GetHitShapeUserData().GetShapeType(), EHitShapeType.Cyberware) {
      return isSoundCritical ? n"w_feedback_hit_cyber_head_kill" : n"w_feedback_hit_cyber_body_kill";
    };
    return isSoundCritical ? n"w_feedback_kill_npc_head" : n"w_feedback_kill_npc";
  }

  private final func GetHitSoundName(hitEvent: ref<gameHitEvent>) -> CName {
    let isSoundCritical: Bool = this.IsSoundCriticalHit(hitEvent);
    if Equals(this.GetHitShapeUserData().GetShapeType(), EHitShapeType.Metal) {
      return isSoundCritical ? n"w_feedback_hit_armor_weakpoint" : n"w_feedback_hit_armor";
    };
    if Equals(this.GetHitShapeUserData().GetShapeType(), EHitShapeType.Cyberware) {
      return isSoundCritical ? n"w_feedback_hit_cyber_head" : n"w_feedback_hit_cyber_body";
    };
    return isSoundCritical ? n"w_feedback_hit_npc_crit" : n"w_feedback_hit_npc";
  }

  public func EvaluateHit(newHitEvent: ref<gameHitEvent>) -> Void {
    let broadcaster: ref<StimBroadcasterComponent>;
    let currentCoverId: Uint64;
    let defeatedOverride: Bool;
    let guardBreakImpulse: Float;
    let hitFeedbackSound: CName;
    let hitReactionZone: EHitReactionZone;
    let isBulletAttack: Bool;
    let parentObject: wref<GameObject>;
    let wasNPCAliveBeforeProcessingHit: Bool;
    let statsDataSystem: ref<StatsDataSystem> = GameInstance.GetStatsDataSystem((this.GetEntity() as GameObject).GetGame());
    let difficulty: gameDifficulty = statsDataSystem.GetDifficulty();
    if !IsDefined(this.m_ownerNPC) {
      return;
    };
    this.m_attackIsValidBodyPerk = false;
    this.IncrementHitCountData();
    this.CacheVars(newHitEvent);
    if !this.GetBodyPart(newHitEvent) {
      return;
    };
    hitReactionZone = this.ProcessHitReactionZone(HitShapeUserDataBase.GetHitReactionZone(this.GetHitShapeUserData()));
    if !this.m_deathHasBeenPlayed {
      currentCoverId = AICoverHelper.GetCurrentCover(this.m_ownerNPC);
      this.m_inCover = currentCoverId > 0u;
      this.m_inWorkspot = GameInstance.GetWorkspotSystem(this.GetOwner().GetGame()).IsActorInWorkspot(this.GetOwner());
      defeatedOverride = this.ProcessDefeated(this.m_ownerNPC);
    };
    if this.m_deathRegisteredTime == 0.00 && (this.m_defeatedHasBeenPlayed || this.m_ownerNPC.IsAboutToBeDefeated()) {
      this.m_deathRegisteredTime = this.GetCurrentTime();
      this.m_extendedDeathDelayRegisteredTime = EngineTime.ToFloat(this.GetEngineTime());
    };
    isBulletAttack = AttackData.IsRangedOrDirect(newHitEvent.attackData.GetAttackType());
    if isBulletAttack {
      hitFeedbackSound = this.GetHitSoundName(newHitEvent);
      if defeatedOverride {
        hitFeedbackSound = this.GetKillSoundName(newHitEvent);
      } else {
        if this.m_isAlive && this.m_ownerNPC.IsAboutToBeDefeated() && !ScriptedPuppet.IsDefeated(this.m_ownerNPC) {
          hitFeedbackSound = n"w_feedback_defeat_npc";
        } else {
          if ScriptedPuppet.IsDefeated(this.m_ownerNPC) {
            hitFeedbackSound = this.GetKillSoundName(newHitEvent);
          };
        };
      };
    };
    if ScriptedPuppet.IsBeingGrappled(this.m_ownerNPC) {
      this.m_reactionType = animHitReactionType.Twitch;
      this.m_hitDirectionToInt = GameObject.GetAttackAngleInInt(newHitEvent, this.m_animHitReaction.hitSource);
      if IsDefined(newHitEvent) {
        this.StoreHitData(this.m_hitDirectionToInt, this.m_hitIntensity, this.m_reactionType, hitReactionZone, this.m_animVariation);
      };
      this.SendTwitchDataToAnimationGraph();
      if IsDefined(newHitEvent) {
        parentObject = ScriptedPuppet.GetGrappleParent(newHitEvent.target);
        if parentObject.IsPlayer() {
          this.SendTwitchDataToPlayerAnimationGraph(parentObject);
        };
      };
      GameObject.PlayVoiceOver(this.m_ownerNPC, n"hit_grapple", n"Scripts:Grapple");
      return;
    };
    if VehicleComponent.IsMountedToVehicle(this.m_ownerNPC.GetGame(), this.m_ownerID) && (NotEquals(this.m_ownerNPC.GetNPCType(), gamedataNPCType.Drone) || this.m_isAlive) {
      this.m_reactionType = animHitReactionType.Twitch;
      this.m_hitDirectionToInt = GameObject.GetAttackAngleInInt(newHitEvent, this.m_animHitReaction.hitSource);
      if IsDefined(newHitEvent) {
        this.StoreHitData(this.m_hitDirectionToInt, this.m_hitIntensity, this.m_reactionType, hitReactionZone, this.m_animVariation);
      };
      this.SendTwitchDataToAnimationGraph();
      return;
    };
    if !IsDefined(newHitEvent) {
      if !this.m_isAlive {
        if this.m_ownerNPC.ShouldSkipDeathAnimation() {
          this.SetHitReactionType(animHitReactionType.None);
        } else {
          this.m_animHitReaction.hitDirection = 0;
          this.m_animHitReaction.hitIntensity = 1;
          this.SetHitReactionType(animHitReactionType.Death);
          this.m_animHitReaction.hitBodyPart = 4;
          this.m_animHitReaction.npcMovementSpeed = 0;
          this.m_animHitReaction.npcMovementDirection = 0;
        };
        this.m_hitReactionAction.Stop();
        this.m_hitReactionAction.Setup(this.m_animHitReaction);
        this.m_hitReactionAction.Launch();
        AnimationControllerComponent.ApplyFeatureToReplicate(this.GetOwner(), n"hit", this.m_animHitReaction);
      } else {
        return;
      };
    };
    this.m_hitPosition = newHitEvent.hitPosition;
    this.m_hitDirection = newHitEvent.hitDirection;
    if this.m_deathHasBeenPlayed {
      if isBulletAttack && this.GetIsOwnerImmuneToExtendedHitReaction() == 0.00 && !defeatedOverride && EnumInt(this.m_hitIntensity) <= 1 && this.m_animVariation < 13 {
        this.SetCumulatedDamagesForDeadNPC();
        this.m_previousHitTime = this.GetCurrentTime();
        if this.m_deathRegisteredTime + 0.50 >= this.GetCurrentTime() || this.m_extendedDeathRegisteredTime + 0.50 >= this.GetCurrentTime() {
          this.m_extendedDeathRegisteredTime = this.GetCurrentTime();
          if this.m_extendedDeathDelayRegisteredTime + 0.15 <= EngineTime.ToFloat(this.GetEngineTime()) {
            this.m_extendedDeathDelayRegisteredTime = EngineTime.ToFloat(this.GetEngineTime());
            this.m_reactionType = animHitReactionType.Death;
            this.ProcessExtendedDeathAnimData(newHitEvent);
            this.m_hitDirectionToInt = GameObject.GetAttackAngleInInt(newHitEvent, this.m_animHitReaction.hitSource);
            this.StoreHitData(this.m_hitDirectionToInt, this.m_hitIntensity, this.m_reactionType, hitReactionZone, this.m_animVariation);
            this.SendDataToAIBehavior(this.m_reactionType);
          };
        } else {
          if ScriptedPuppet.CanRagdoll(this.m_ownerNPC) {
            if this.m_deathRegisteredTime + 1.00 <= this.GetCurrentTime() && this.m_extendedDeathRegisteredTime + 1.00 <= this.GetCurrentTime() {
              if this.m_previousRagdollTimeStamp != this.GetCurrentTime() {
                this.m_ownerNPC.QueueEvent(CreateForceRagdollEvent(n"Dead_RecivedHit"));
                if this.m_ownerNPC.IsRagdolling() {
                  GameInstance.GetDelaySystem(this.m_ownerNPC.GetGame()).DelayEvent(this.m_ownerNPC, CreateRagdollApplyImpulseEvent(this.GetHitPosition(), this.GetHitDirection() * this.m_ragdollImpulse * 0.25, this.m_ragdollInfluenceRadius), 0.10, false);
                } else {
                  GameInstance.GetDelaySystem(this.m_ownerNPC.GetGame()).DelayEvent(this.m_ownerNPC, CreateRagdollApplyImpulseEvent(this.GetHitPosition(), this.GetHitDirection() * this.m_ragdollImpulse, this.m_ragdollInfluenceRadius), 0.10, false);
                };
                this.m_previousRagdollTimeStamp = this.GetCurrentTime();
              };
            };
          };
          this.SetCumulatedDamagesForDeadNPC();
          this.ProcessWoundsAndDismemberment();
        };
      } else {
        if ScriptedPuppet.CanRagdoll(this.m_ownerNPC) {
          if this.m_deathRegisteredTime + 1.00 <= this.GetCurrentTime() {
            if this.m_previousRagdollTimeStamp != this.GetCurrentTime() {
              this.m_ownerNPC.QueueEvent(CreateForceRagdollEvent(n"Dead_RecivedHit1"));
              if this.m_ownerNPC.IsRagdolling() {
                GameInstance.GetDelaySystem(this.m_ownerNPC.GetGame()).DelayEvent(this.m_ownerNPC, CreateRagdollApplyImpulseEvent(this.GetHitPosition(), this.GetHitDirection() * this.m_ragdollImpulse * 0.25, this.m_ragdollInfluenceRadius), 0.10, false);
              } else {
                GameInstance.GetDelaySystem(this.m_ownerNPC.GetGame()).DelayEvent(this.m_ownerNPC, CreateRagdollApplyImpulseEvent(this.GetHitPosition(), this.GetHitDirection() * this.m_ragdollImpulse, this.m_ragdollInfluenceRadius), 0.10, false);
              };
              this.m_previousRagdollTimeStamp = this.GetCurrentTime();
            };
          };
        };
        this.SetCumulatedDamagesForDeadNPC();
        this.ProcessWoundsAndDismemberment();
      };
    } else {
      if isBulletAttack {
        if this.m_isAlive && this.m_previousRangedHitTimeStamp != this.GetCurrentTime() && !this.GetHitTimerAvailability() {
          return;
        };
      };
      if this.m_isAlive {
        this.SetCumulatedDamages(newHitEvent.target, guardBreakImpulse);
      } else {
        this.SetCumulatedDamagesForDeadNPC();
        if this.m_deathHasBeenPlayed && ScriptedPuppet.CanRagdoll(this.m_ownerNPC) {
          if this.m_previousRagdollTimeStamp != this.GetCurrentTime() {
            this.m_ownerNPC.QueueEvent(CreateForceRagdollEvent(n"dead_RecivedHit2"));
            GameInstance.GetDelaySystem(this.m_ownerNPC.GetGame()).DelayEvent(this.m_ownerNPC, CreateRagdollApplyImpulseEvent(this.GetHitPosition(), this.GetHitDirection() * this.m_ragdollImpulse, this.m_ragdollInfluenceRadius), 0.10, false);
            this.m_previousRagdollTimeStamp = this.GetCurrentTime();
          };
        };
      };
      this.SetHitSource(this.m_attackData.GetAttackType());
      this.SetStance();
      this.SetHitReactionThresholds();
      this.GetHitIntensity(defeatedOverride);
      this.SetHitReactionImmunities();
      if !defeatedOverride {
        this.m_reactionType = this.GetReactionType(guardBreakImpulse, newHitEvent);
      };
      this.ProcessWoundsAndDismemberment();
      this.ProcessSpecialFX(newHitEvent);
      if this.GetCurrentTime() <= this.m_previousHitTime + 0.09 && Equals(this.m_reactionType, animHitReactionType.Twitch) {
        return;
      };
      this.m_hitDirectionToInt = GameObject.GetAttackAngleInInt(newHitEvent, this.m_animHitReaction.hitSource);
      this.SetAnimVariation(this.m_hitDirectionToInt, hitReactionZone);
      this.StoreHitData(this.m_hitDirectionToInt, this.m_hitIntensity, this.m_reactionType, hitReactionZone, this.m_animVariation);
      this.m_previousHitTime = this.GetCurrentTime();
      if this.m_ownerNPC.IsPlayerCompanion() && this.m_allowDefeatedOnCompanion && (this.GetHealthPecentageNormalized() < 0.10 || (this.m_attackData.GetInstigator() as ScriptedPuppet).IsBoss() || Equals((this.m_attackData.GetInstigator() as ScriptedPuppet).GetNPCRarity(), gamedataNPCRarity.MaxTac)) {
        if this.GetHitCountInCombo() >= 2 || this.m_defeatedDamageThreshold > 0.00 && this.m_cumulatedDamages >= this.m_defeatedDamageThreshold {
          if Equals(difficulty, gameDifficulty.Story) {
            StatusEffectHelper.ApplyStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.FollowerDefeatedStory");
          } else {
            if Equals(difficulty, gameDifficulty.Easy) {
              StatusEffectHelper.ApplyStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.FollowerDefeatedEasy");
            } else {
              if Equals(difficulty, gameDifficulty.Hard) {
                StatusEffectHelper.ApplyStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.FollowerDefeatedHard");
              } else {
                if Equals(difficulty, gameDifficulty.VeryHard) {
                  StatusEffectHelper.ApplyStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.FollowerDefeatedVeryHard");
                };
              };
            };
          };
          this.m_reactionType = animHitReactionType.None;
        };
      };
      if ScriptedPuppet.CanRagdoll(this.m_ownerNPC) && Equals(this.m_ownerNPC.GetHighLevelStateFromBlackboard(), gamedataNPCHighLevelState.Unconscious) || this.m_ownerNPC.IsRagdolling() {
        if this.m_previousRagdollTimeStamp != this.GetCurrentTime() {
          this.m_ownerNPC.QueueEvent(CreateForceRagdollEvent(n"Unconscious_RecivedHit"));
          GameInstance.GetDelaySystem(this.m_ownerNPC.GetGame()).DelayEvent(this.m_ownerNPC, CreateRagdollApplyImpulseEvent(this.GetHitPosition(), this.GetHitDirection() * 10.00, 5.00), 0.10, false);
          this.m_previousRagdollTimeStamp = this.GetCurrentTime();
        };
      } else {
        if this.m_animHitReaction.hitType == 1 && this.m_ownerNPC.IsAboutToBeDefeated() {
          if StatusEffectSystem.ObjectHasStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.PreventQHStaggerAnimation") {
            StatusEffectHelper.RemoveStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.PreventQHStaggerAnimation");
          };
          if this.m_ownerPuppet.GetPuppetStateBlackboard().GetBool(GetAllBlackboardDefs().AIAction.ownerInTumble) && this.m_previousRagdollTimeStamp != this.GetCurrentTime() {
            this.m_ownerNPC.QueueEvent(CreateForceRagdollEvent(n"Defeated_WhileInTumble"));
            GameInstance.GetDelaySystem(this.m_ownerNPC.GetGame()).DelayEvent(this.m_ownerNPC, CreateRagdollApplyImpulseEvent(this.GetHitPosition(), this.GetHitDirection() * this.m_ragdollImpulse, this.m_ragdollInfluenceRadius), 0.10, false);
            this.m_previousRagdollTimeStamp = this.GetCurrentTime();
          };
          return;
        };
        if Equals(this.m_reactionType, animHitReactionType.Death) && !this.m_isAlive && Equals(this.m_ownerNPC.GetNPCType(), gamedataNPCType.Drone) {
          this.SendDataToAIBehavior(this.m_reactionType);
        } else {
          if this.m_animHitReaction.hitType == 1 || this.m_ownerPuppet.GetMovePolicesComponent().IsOnOffMeshLink() || this.m_inWorkspot && !this.m_inCover && !this.CheckBrainMeltDeath() {
            this.SendTwitchDataToAnimationGraph();
            if NotEquals(this.m_attackData.GetHitType(), gameuiHitType.Miss) {
              broadcaster = this.m_attackData.GetSource().GetStimBroadcasterComponent();
              if IsDefined(broadcaster) {
                broadcaster.SendDrirectStimuliToTarget(this.GetOwner(), gamedataStimType.CombatHit, this.GetOwner());
              };
            };
          } else {
            this.SendDataToAIBehavior(this.m_reactionType);
          };
        };
      };
    };
    if isBulletAttack {
      wasNPCAliveBeforeProcessingHit = this.m_isAlive;
      if !this.m_isAlive && wasNPCAliveBeforeProcessingHit {
        hitFeedbackSound = this.GetKillSoundName(newHitEvent);
      };
      if newHitEvent.attackData.GetInstigator().IsPlayer() && !newHitEvent.attackData.HasFlag(hitFlag.DealNoDamage) && this.m_hitIndicatorEnabled {
        GameInstance.GetAudioSystem(newHitEvent.attackData.GetInstigator().GetGame()).PlayImpact(hitFeedbackSound, newHitEvent.hitPosition, newHitEvent.attackData.GetInstigator());
      };
    };
    if this.m_isAlive {
      this.UpdateCoverDamage(this.m_ownerNPC, currentCoverId);
    };
    this.m_hitCount += 1u;
  }

  public func UpdateCoverDamage(npc: ref<NPCPuppet>, coverId: Uint64) -> Void {
    let context: ScriptExecutionContext;
    if coverId > 0u {
      if AIHumanComponent.GetScriptContext(npc, context) {
        AICoverHelper.NotifyGotDamageInCover(npc, coverId, ScriptExecutionContext.GetAITime(context), AICoverHelper.GetCoverNPCCurrentlyExposed(npc));
      };
    };
  }

  protected final func CacheVars(hitEvent: ref<gameHitEvent>) -> Void {
    this.m_isAlive = ScriptedPuppet.IsAlive(this.GetOwner());
    this.m_ownerIsMassive = this.m_ownerNPC.IsMassive();
    this.m_attackData = hitEvent.attackData;
    this.m_overridenHitDirection = false;
    this.m_inWorkspot = false;
    this.m_inCover = false;
    this.m_attackDirectionToInt = -1;
  }

  protected final func IncrementHitCountData() -> Void {
    this.m_hitCountData[this.m_hitCountArrayCurrent] = this.GetCurrentTime();
    this.m_hitCountArrayCurrent += 1;
    if this.m_hitCountArrayCurrent > this.m_hitCountArrayEnd {
      this.m_hitCountArrayCurrent = 0;
    };
  }

  public final const func GetHitCountData(index: Int32) -> Float {
    let modifiedIndex: Int32;
    if this.m_hitCountArrayCurrent - index < 0 {
      modifiedIndex = this.m_hitCountArrayEnd + this.m_hitCountArrayCurrent - index;
    } else {
      modifiedIndex = this.m_hitCountArrayCurrent - index;
    };
    return this.m_hitCountData[modifiedIndex];
  }

  public final const func GetHitCountDataArrayCurrent() -> Int32 {
    return this.m_hitCountArrayCurrent;
  }

  public final const func GetHitCountDataArrayEnd() -> Int32 {
    return this.m_hitCountArrayEnd;
  }

  protected final func SetHitReactionType(hitType: animHitReactionType) -> Void {
    this.m_animHitReaction.hitType = EnumInt(hitType);
    this.m_ownerPuppet.NotifyHitReactionTypeChanged(this.m_animHitReaction.hitType);
  }

  protected final func SetHitReactionSource(hitSource: EAIHitSource) -> Void {
    this.m_animHitReaction.hitSource = EnumInt(hitSource);
    this.m_ownerPuppet.NotifyHitReactionSourceChanged(this.m_animHitReaction.hitSource);
  }

  protected final func SetStance() -> Void {
    if AIActionHelper.IsCurrentlyCrouching(this.m_ownerPuppet) {
      this.m_animHitReaction.stance = 1;
    } else {
      this.m_animHitReaction.stance = 0;
    };
  }

  protected final func SetHitReactionThresholds() -> Void {
    let currentCoverId: Uint64;
    this.m_knockdownImpulseThreshold = this.m_currentKnockdownDamageThresholdImpulse;
    if this.m_ownerNPC.IsAboutToDie() {
      this.m_knockdownImpulseThreshold *= 0.60;
    };
    if this.m_ownerNPC.IsPlayerCompanion() {
      if StatusEffectSystem.ObjectHasStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.PanamRestoreDefaultHealth") {
        this.m_defeatedDamageThreshold = this.GetOwnerTotalHealth() * this.m_currentDefeatedDamageThreshold * 0.01 * 0.04;
      } else {
        this.m_defeatedDamageThreshold = this.GetOwnerTotalHealth() * this.m_currentDefeatedDamageThreshold * 0.01;
      };
    };
    currentCoverId = AICoverHelper.GetCurrentCoverId(this.m_ownerPuppet);
    if currentCoverId > 0u && GameInstance.GetCoverManager(this.m_ownerPuppet.GetGame()).IsCoverRegular(currentCoverId) {
      this.m_impactDamageThreshold = this.GetOwnerTotalHealth() * this.m_currentImpactDamageThresholdInCover * 0.01;
      this.m_staggerDamageThreshold = this.GetOwnerTotalHealth() * this.m_currentStaggerDamageThresholdInCover * 0.01;
      this.m_knockdownDamageThreshold = this.GetOwnerTotalHealth() * this.m_currentKnockdownDamageThresholdInCover * 0.01;
      return;
    };
    this.m_impactDamageThreshold = this.GetOwnerTotalHealth() * this.m_currentImpactDamageThreshold * 0.01;
    this.m_staggerDamageThreshold = this.GetOwnerTotalHealth() * this.m_currentStaggerDamageThreshold * 0.01;
    this.m_knockdownDamageThreshold = this.GetOwnerTotalHealth() * this.m_currentKnockdownDamageThreshold * 0.01;
  }

  protected final func SetHitReactionImmunities() -> Void {
    if this.m_currentKnockdownImmunity > 0.00 || ScriptedPuppet.IsOnOffMeshLink(this.m_ownerNPC) {
      this.m_immuneToKnockDown = true;
    } else {
      if Equals(GameObject.GetAttitudeTowards(this.GetOwner(), GameInstance.GetPlayerSystem(this.GetOwner().GetGame()).GetLocalPlayerControlledGameObject()), EAIAttitude.AIA_Friendly) || Equals(this.m_ownerNPC.GetNPCType(), gamedataNPCType.Cerberus) {
        this.m_immuneToKnockDown = true;
      };
    };
  }

  protected final func GetHitTimerAvailability() -> Bool {
    let currentTime: Float = this.GetCurrentTime();
    let hitReactionMinDuration: Float = this.m_globalHitTimer;
    if currentTime != this.m_previousHitTime && currentTime < this.m_previousHitTime + hitReactionMinDuration {
      return false;
    };
    if currentTime <= this.m_previousHitTime + 0.09 {
      return false;
    };
    return true;
  }

  protected func SetCumulatedDamages(target: wref<GameObject>, out guardBreakImpulse: Float) -> Void {
    let bodyPartDismemberCumulatedDamages: Float;
    let bodyPartWoundCumulatedDamages: Float;
    let hitReactionZoneIndex: Int32;
    if this.m_previousHitTime + this.m_hitComboReset < this.GetCurrentTime() && NotEquals(this.m_lastHitReactionPlayed, EAILastHitReactionPlayed.Knockdown) {
      if this.m_meleeBaseMaxHitChain > -1 {
        this.m_maxHitChainForMelee = RandRange(this.m_meleeBaseMaxHitChain, this.m_meleeBaseMaxHitChain + 1);
      };
      if this.m_maxHitChainForRanged > -1 {
        this.m_maxHitChainForRanged = RandRange(this.m_rangedBaseMaxHitChain, this.m_rangedBaseMaxHitChain + 1);
      };
      this.m_meleeHitCount = 0;
      this.m_strongMeleeHitCount = 0;
      this.m_cumulatedDamages = 0.00;
      this.m_lastHitReactionPlayed = EAILastHitReactionPlayed.Twitch;
    };
    this.m_cumulatedPhysicalImpulse += this.GetPhysicalImpulse(this.m_attackData, this.m_hitPosition, guardBreakImpulse);
    this.m_cumulatedDamages += this.GetFrameDamage();
    if HitShapeUserDataBase.IsHitReactionZoneLeftArm(this.GetHitShapeUserData()) {
      bodyPartWoundCumulatedDamages = this.m_bodyPartWoundCumulatedDamages[2] + this.GetFrameWoundsDamage();
      this.m_bodyPartWoundCumulatedDamages[2] = bodyPartWoundCumulatedDamages;
      this.m_bodyPartWoundCumulatedDamages[3] = bodyPartWoundCumulatedDamages;
      bodyPartDismemberCumulatedDamages = this.m_bodyPartDismemberCumulatedDamages[2] + this.GetFrameDismembermentDamage();
      this.m_bodyPartDismemberCumulatedDamages[2] = bodyPartDismemberCumulatedDamages;
      this.m_bodyPartDismemberCumulatedDamages[3] = bodyPartDismemberCumulatedDamages;
    } else {
      if HitShapeUserDataBase.IsHitReactionZoneRightArm(this.GetHitShapeUserData()) {
        bodyPartWoundCumulatedDamages = this.m_bodyPartWoundCumulatedDamages[5] + this.GetFrameWoundsDamage();
        this.m_bodyPartWoundCumulatedDamages[5] = bodyPartWoundCumulatedDamages;
        this.m_bodyPartWoundCumulatedDamages[6] = bodyPartWoundCumulatedDamages;
        bodyPartDismemberCumulatedDamages = this.m_bodyPartDismemberCumulatedDamages[5] + this.GetFrameDismembermentDamage();
        this.m_bodyPartDismemberCumulatedDamages[5] = bodyPartDismemberCumulatedDamages;
        this.m_bodyPartDismemberCumulatedDamages[6] = bodyPartDismemberCumulatedDamages;
      } else {
        hitReactionZoneIndex = EnumInt(HitShapeUserDataBase.GetHitReactionZone(this.GetHitShapeUserData()));
        bodyPartWoundCumulatedDamages = this.m_bodyPartWoundCumulatedDamages[hitReactionZoneIndex] + this.GetFrameWoundsDamage();
        this.m_bodyPartWoundCumulatedDamages[hitReactionZoneIndex] = bodyPartWoundCumulatedDamages;
        bodyPartDismemberCumulatedDamages = this.m_bodyPartDismemberCumulatedDamages[hitReactionZoneIndex] + this.GetFrameDismembermentDamage();
        this.m_bodyPartDismemberCumulatedDamages[hitReactionZoneIndex] = bodyPartDismemberCumulatedDamages;
      };
    };
    this.ResetFrameDamage();
    this.RequestCumulativeDamageUpdate();
  }

  protected final func SetCumulatedDamagesForDeadNPC() -> Void {
    let bodyPartDismemberCumulatedDamages: Float;
    let bodyPartWoundCumulatedDamages: Float;
    let guardBreakImpulse: Float;
    let hitReactionZoneIndex: Int32;
    this.m_cumulatedPhysicalImpulse += this.GetPhysicalImpulse(this.m_attackData, this.m_hitPosition, guardBreakImpulse);
    this.m_cumulatedDamages += this.GetFrameDamage();
    if HitShapeUserDataBase.IsHitReactionZoneLeftArm(this.GetHitShapeUserData()) {
      bodyPartWoundCumulatedDamages = this.m_bodyPartWoundCumulatedDamages[2] + this.GetFrameWoundsDamage();
      this.m_bodyPartWoundCumulatedDamages[2] = bodyPartWoundCumulatedDamages;
      this.m_bodyPartWoundCumulatedDamages[3] = bodyPartWoundCumulatedDamages;
      bodyPartDismemberCumulatedDamages = this.m_bodyPartDismemberCumulatedDamages[2] + this.GetFrameDismembermentDamage();
      this.m_bodyPartDismemberCumulatedDamages[2] = bodyPartDismemberCumulatedDamages;
      this.m_bodyPartDismemberCumulatedDamages[3] = bodyPartDismemberCumulatedDamages;
    } else {
      if HitShapeUserDataBase.IsHitReactionZoneRightArm(this.GetHitShapeUserData()) {
        bodyPartWoundCumulatedDamages = this.m_bodyPartWoundCumulatedDamages[5] + this.GetFrameWoundsDamage();
        this.m_bodyPartWoundCumulatedDamages[5] = bodyPartWoundCumulatedDamages;
        this.m_bodyPartWoundCumulatedDamages[6] = bodyPartWoundCumulatedDamages;
        bodyPartDismemberCumulatedDamages = this.m_bodyPartDismemberCumulatedDamages[5] + this.GetFrameDismembermentDamage();
        this.m_bodyPartDismemberCumulatedDamages[5] = bodyPartDismemberCumulatedDamages;
        this.m_bodyPartDismemberCumulatedDamages[6] = bodyPartDismemberCumulatedDamages;
      } else {
        hitReactionZoneIndex = EnumInt(HitShapeUserDataBase.GetHitReactionZone(this.GetHitShapeUserData()));
        bodyPartWoundCumulatedDamages = this.m_bodyPartWoundCumulatedDamages[hitReactionZoneIndex] + this.GetFrameWoundsDamage();
        this.m_bodyPartWoundCumulatedDamages[hitReactionZoneIndex] = bodyPartWoundCumulatedDamages;
        bodyPartDismemberCumulatedDamages = this.m_bodyPartDismemberCumulatedDamages[hitReactionZoneIndex] + this.GetFrameDismembermentDamage();
        this.m_bodyPartDismemberCumulatedDamages[hitReactionZoneIndex] = bodyPartDismemberCumulatedDamages;
      };
    };
    this.ResetFrameDamage();
    this.RequestCumulativeDamageUpdate();
  }

  private final func UpdateCumulatedDamages(deltaTime: Float) -> Bool {
    let requiresUpdate: Bool;
    let valueToDecrese: Float;
    let cumulativeDamagesDecreaser: Float = this.GetOwnerTotalHealth() * this.m_baseCumulativeDamagesDecreaser * 0.01;
    if this.m_previousHitTime + this.m_hitComboReset > this.GetCurrentTime() {
      return false;
    };
    valueToDecrese = cumulativeDamagesDecreaser * deltaTime;
    if this.m_cumulatedDamages > 0.00 {
      this.m_cumulatedDamages -= valueToDecrese;
      this.m_cumulatedDamages = MaxF(this.m_cumulatedDamages, 0.00);
      if this.m_cumulatedDamages > 0.00 {
        requiresUpdate = true;
      };
    };
    return requiresUpdate;
  }

  protected final func GetBodyPart(hitEvent: ref<gameHitEvent>) -> Bool {
    let empty: HitShapeData;
    this.m_hitShapeData = empty;
    if ArraySize(hitEvent.hitRepresentationResult.hitShapes) > 0 {
      this.m_hitShapeData = hitEvent.hitRepresentationResult.hitShapes[0];
    };
    return NotEquals(this.m_hitShapeData, empty);
  }

  protected final func CheckInstantDismembermentOnDeath() -> Bool {
    if NotEquals(this.m_reactionType, animHitReactionType.Death) && NotEquals(this.m_reactionType, animHitReactionType.Pain) && NotEquals(this.m_reactionType, animHitReactionType.Ragdoll) && this.m_isAlive {
      return false;
    };
    if this.m_attackData.DoesAttackWeaponHaveTag(n"ForceDismember") {
      return true;
    };
    if AttackData.IsDismembermentCause(this.m_attackData.GetAttackType()) {
      return true;
    };
    if this.m_executeDismembered {
      return true;
    };
    return false;
  }

  protected final func GetDismembermentWoundType() -> gameDismWoundType {
    let weapon: ref<WeaponObject> = ScriptedPuppet.GetWeaponRight(this.m_attackData.GetSource());
    let weaponType: gamedataItemType = weapon.GetWeaponRecord().ItemType().Type();
    if Equals(weaponType, gamedataItemType.Cyb_NanoWires) || Equals(weaponType, gamedataItemType.Cyb_MantisBlades) || Equals(weaponType, gamedataItemType.Wea_Katana) || Equals(weaponType, gamedataItemType.Wea_ShortBlade) || Equals(weaponType, gamedataItemType.Wea_LongBlade) || Equals(weaponType, gamedataItemType.Wea_Axe) || Equals(weaponType, gamedataItemType.Wea_Chainsword) || Equals(weaponType, gamedataItemType.Wea_Machete) || Equals(weaponType, gamedataItemType.Wea_Sword) {
      return gameDismWoundType.CLEAN;
    };
    if weapon.IsMelee() {
      return gameDismWoundType.HOLE;
    };
    if (Equals(HitShapeUserDataBase.GetDismembermentBodyPart(this.GetHitShapeUserData()), gameDismBodyPart.BODY) || HitShapeUserDataBase.IsHitReactionZoneHead(this.GetHitShapeUserData()) && this.m_bodyPartDismemberCumulatedDamages[EnumInt(HitShapeUserDataBase.GetHitReactionZone(this.GetHitShapeUserData()))] < this.GetOwnerTotalHealth() * 2.00) && !this.m_ownerPuppet.IsAndroid() {
      return gameDismWoundType.HOLE;
    };
    return gameDismWoundType.COARSE;
  }

  protected final func ProcessHitReactionZone(bodyPart: EHitReactionZone) -> EHitReactionZone {
    if this.m_attackData.GetInstigator().IsPlayer() {
      return bodyPart;
    };
    if !AttackData.IsMelee(this.GetAttackType()) {
      return bodyPart;
    };
    if Equals(bodyPart, EHitReactionZone.ChestLeft) || Equals(bodyPart, EHitReactionZone.ChestRight) || Equals(bodyPart, EHitReactionZone.Abdomen) {
      bodyPart = EHitReactionZone.Head;
    };
    return bodyPart;
  }

  protected final func ProcessDefeated(npc: ref<NPCPuppet>) -> Bool {
    if !npc.IsAboutToBeDefeated() && !StatusEffectSystem.ObjectHasStatusEffectWithTag(npc, n"Defeated") && !npc.IsAboutToDie() {
      return false;
    };
    if !this.CanDieCondition() {
      return false;
    };
    if this.DefeatedRemoveConditions(npc) {
      this.GetOwner().Record1DamageInHistory(this.m_attackData.GetInstigator());
      npc.Kill(this.m_attackData.GetInstigator());
      this.m_reactionType = animHitReactionType.Death;
      this.m_isAlive = false;
      return true;
    };
    AnimationControllerComponent.PushEventToReplicate(this.GetOwner(), n"e3_2019_boss_defeated_face");
    return false;
  }

  public final func UpdateDefeated() -> Void {
    if !this.m_defeatedHasBeenPlayed {
      this.m_defeatedHasBeenPlayed = true;
      this.m_defeatedRegisteredTime = this.GetCurrentTime();
      this.m_specificHitTimeout = this.m_defeatedRegisteredTime + this.m_defeatedMinDuration;
    };
  }

  protected final func DefeatedRemoveConditions(npc: ref<NPCPuppet>) -> Bool {
    if npc.IsAboutToDie() {
      return true;
    };
    if ScriptedPuppet.IsOnOffMeshLink(npc) {
      return true;
    };
    if this.m_attackData.HasFlag(hitFlag.QuickHack) {
      if this.CheckBrainMeltDeath() {
        return true;
      };
    };
    if this.m_inWorkspot && !this.m_inCover {
      return true;
    };
    if VehicleComponent.IsMountedToVehicle(this.GetOwner().GetGame(), npc) {
      return true;
    };
    if this.m_specificHitTimeout > this.GetCurrentTime() && Equals(this.m_lastHitReactionPlayed, EAILastHitReactionPlayed.Knockdown) {
      return true;
    };
    if this.m_attackData.HasFlag(hitFlag.VehicleDamage) {
      return true;
    };
    if AttackData.IsExplosion(this.m_attackData.GetAttackType()) {
      return true;
    };
    if this.m_defeatedBodyPartDamageThreshold[EnumInt(HitShapeUserDataBase.GetHitReactionZone(this.GetHitShapeUserData()))] < 0.00 {
      return true;
    };
    if (this.m_attackData.DoesAttackWeaponHaveTag(n"ForceDismember") || this.m_attackData.DoesAttackWeaponHaveTag(n"HeavyWeapon") || this.GetFrameDamage() > this.m_defeatedBodyPartDamageThreshold[EnumInt(HitShapeUserDataBase.GetHitReactionZone(this.GetHitShapeUserData()))] || this.CheckInstantDismembermentOnDeath()) && (!HitShapeUserDataBase.IsHitReactionZoneLimb(this.GetHitShapeUserData()) || this.m_attackData.DoesAttackWeaponHaveTag(n"HeavyWeapon")) && !this.m_defeatedHasBeenPlayed {
      return true;
    };
    if this.GetCurrentTime() > this.m_specificHitTimeout && this.m_defeatedHasBeenPlayed {
      return true;
    };
    this.UpdateDefeated();
    return false;
  }

  private final func CheckBrainMeltDeath() -> Bool {
    let attackRecord: ref<Attack_GameEffect_Record> = this.m_attackData.GetAttackDefinition().GetRecord() as Attack_GameEffect_Record;
    let hitFlags: array<String> = attackRecord.HitFlags();
    if ArrayContains(hitFlags, "BrainMeltSkipDefeated") {
      return true;
    };
    return false;
  }

  protected final func ProcessDropWeaponOnHit(owner: ref<GameObject>, hitBodyPart: EHitReactionZone, hitReaction: animHitReactionType) -> Void {
    let itemInSlotID: ItemID;
    let slotID: TweakDBID;
    if this.m_currentCanDropWeapon == 0.00 {
      return;
    };
    if Equals(hitReaction, animHitReactionType.Impact) || Equals(hitReaction, animHitReactionType.Twitch) {
      return;
    };
    switch hitBodyPart {
      case EHitReactionZone.HandRight:
        slotID = t"AttachmentSlots.WeaponRight";
        break;
      case EHitReactionZone.HandLeft:
        slotID = t"AttachmentSlots.WeaponLeft";
        break;
      default:
        return;
    };
    if TDBID.IsValid(slotID) {
      itemInSlotID = GameInstance.GetTransactionSystem(owner.GetGame()).GetItemInSlot(owner, slotID).GetItemData().GetID();
      if NotEquals(RPGManager.GetItemType(itemInSlotID), gamedataItemType.Wea_Fists) {
        ScriptedPuppet.DropWeaponFromSlot(owner, slotID);
      };
    };
  }

  protected final func ProcessExtendedDeathAnimData(hitEvent: ref<gameHitEvent>) -> Void {
    if HitShapeUserDataBase.IsHitReactionZoneRightLeg(this.GetHitShapeUserData()) || HitShapeUserDataBase.IsHitReactionZoneLeftLeg(this.GetHitShapeUserData()) {
      DismembermentComponent.RequestDismemberment(this.GetOwner(), HitShapeUserDataBase.GetDismembermentBodyPart(this.GetHitShapeUserData()), gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter);
      this.m_hitIntensity = EAIHitIntensity.Heavy;
      this.NotifyAboutDismembermentInstigated(this.m_attackData.GetInstigator(), HitShapeUserDataBase.GetHitReactionZone(this.GetHitShapeUserData()), this.m_ownerNPC.GetWorldPosition());
    } else {
      if this.m_bodyPartDismemberCumulatedDamages[EnumInt(HitShapeUserDataBase.GetHitReactionZone(this.GetHitShapeUserData()))] >= this.GetOwnerTotalHealth() * 0.30 {
        DismembermentComponent.RequestDismemberment(this.GetOwner(), HitShapeUserDataBase.GetDismembermentBodyPart(this.GetHitShapeUserData()), gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter);
        this.NotifyAboutDismembermentInstigated(this.m_attackData.GetInstigator(), HitShapeUserDataBase.GetHitReactionZone(this.GetHitShapeUserData()), this.m_ownerNPC.GetWorldPosition());
      };
      this.m_hitIntensity = EAIHitIntensity.Light;
    };
    if this.m_animVariation <= 12 {
      this.m_animVariation += 1;
    } else {
      this.m_animVariation = 13;
    };
  }

  protected final func ProcessExtendedHitReactionAnimData(hitEvent: ref<gameHitEvent>) -> Void {
    if HitShapeUserDataBase.IsHitReactionZoneRightLeg(this.GetHitShapeUserData()) || HitShapeUserDataBase.IsHitReactionZoneLeftLeg(this.GetHitShapeUserData()) {
      this.m_reactionType = animHitReactionType.Stagger;
      this.m_extendedHitReactionDelayRegisteredTime = this.GetCurrentTime() + 1.80;
      this.m_lastHitReactionPlayed = EAILastHitReactionPlayed.Stagger;
    } else {
      this.m_reactionType = animHitReactionType.Impact;
      this.m_hitIntensity = EAIHitIntensity.Light;
      this.m_lastHitReactionPlayed = EAILastHitReactionPlayed.Impact;
    };
    if this.m_animVariation < 4 {
      this.m_animVariation += 1;
    } else {
      this.m_animVariation = 0;
    };
  }

  protected final func ProcessSpecialFX(hitevent: ref<gameHitEvent>) -> Void {
    let position: WorldPosition;
    let transform: WorldTransform;
    let effect: FxResource = this.m_ownerNPC.GetFxResourceByKey(n"special_finishers_impact");
    if FxResource.IsValid(effect) && hitevent.attackData.GetInstigator().GetIsInFastFinisher() {
      this.GetBodyPart(hitevent);
      WorldPosition.SetVector4(position, this.m_hitShapeData.result.hitPositionEnter);
      WorldTransform.SetWorldPosition(transform, position);
      GameInstance.GetFxSystem(this.m_ownerNPC.GetGame()).SpawnEffect(effect, transform);
    };
  }

  protected final func ProcessWoundsAndDismemberment() -> Void {
    let broadcaster: ref<StimBroadcasterComponent>;
    let dismembermentCheck: Bool;
    let healthMissingAfterAttack: Float;
    let hitReactionZone: EHitReactionZone;
    let stopScanningEvent: ref<AIEvent>;
    let woundType: gameDismWoundType;
    let woundedBaseConditions: Bool;
    if !this.CanDieCondition() {
      return;
    };
    if this.m_attackData.HasFlag(hitFlag.FragmentationSplinter) {
      this.ProcessFragmentationSplinterReaction(this.m_hitShapeData.result.hitPositionEnter);
      return;
    };
    if AttackData.IsExplosion(this.m_attackData.GetAttackType()) {
      this.ProcessExplosionDismembement();
      return;
    };
    if this.m_ownerNPC.GetMovePolicesComponent().IsOnOffMeshLink() {
      return;
    };
    if Equals(GameInstance.GetCoverManager(this.m_ownerNPC.GetGame()).GetCoverActionType(this.m_ownerNPC), AIUninterruptibleActionType.EnteringCover) {
      return;
    };
    if Equals(this.m_attackData.GetAttackType(), gamedataAttackType.QuickMelee) {
      return;
    };
    woundType = this.GetDismembermentWoundType();
    if NotEquals(woundType, gameDismWoundType.CLEAN) && !HitShapeUserDataBase.IsHitReactionZoneHead(this.GetHitShapeUserData()) && AttackData.IsMelee(this.m_attackData.GetAttackType()) {
      return;
    };
    hitReactionZone = HitShapeUserDataBase.GetHitReactionZone(this.GetHitShapeUserData());
    healthMissingAfterAttack = GameInstance.GetStatPoolsSystem(this.m_ownerNPC.GetGame()).GetStatPoolValue(Cast<StatsObjectID>(this.m_ownerNPC.GetEntityID()), gamedataStatPoolType.Health, false) - this.m_ownerNPC.GetTotalFrameDamage();
    healthMissingAfterAttack = 1.00 - ClampF(healthMissingAfterAttack / this.m_statsSystem.GetStatValue(Cast<StatsObjectID>(this.m_ownerNPC.GetEntityID()), gamedataStatType.Health), 0.00, 1.00);
    this.m_attackIsValidBodyPerk = this.IsValidBodyPerkDismemberAttack(healthMissingAfterAttack);
    if this.m_attackIsValidBodyPerk {
      if this.TryTriggerBodyPerkDismembement(healthMissingAfterAttack) {
        this.ProcessBodyPerkDismembement();
        return;
      };
    };
    if HitShapeUserDataBase.IsHitReactionZoneHead(this.GetHitShapeUserData()) || HitShapeUserDataBase.IsHitReactionZoneTorso(this.GetHitShapeUserData()) {
      dismembermentCheck = this.DismembermentConditions();
      woundedBaseConditions = this.WoundedBaseConditions();
      if this.WoundedCyberConditions(dismembermentCheck, woundedBaseConditions) {
        DismembermentComponent.RequestDismemberment(this.GetOwner(), HitShapeUserDataBase.GetDismembermentBodyPart(this.GetHitShapeUserData()), woundType, this.m_hitShapeData.result.hitPositionEnter);
        this.NotifyAboutDismembermentInstigated(this.m_attackData.GetInstigator(), hitReactionZone, this.m_ownerNPC.GetWorldPosition());
        this.m_bodyPartWoundCumulatedDamages[EnumInt(hitReactionZone)] = 0.00;
        this.m_reactionType = animHitReactionType.Stagger;
        StatusEffectHelper.ApplyStatusEffect(this.GetOwner(), t"BaseStatusEffect.AndroidHeadRemovedBlind");
        stopScanningEvent = new AIEvent();
        stopScanningEvent.name = n"StopScanning";
        this.GetOwner().QueueEvent(stopScanningEvent);
      } else {
        if dismembermentCheck {
          if Equals(HitShapeUserDataBase.GetDismembermentBodyPart(this.GetHitShapeUserData()), gameDismBodyPart.BODY) && !this.m_scatteredGuts {
            DismembermentComponent.RequestDismemberment(this.GetOwner(), HitShapeUserDataBase.GetDismembermentBodyPart(this.GetHitShapeUserData()), woundType, this.m_hitShapeData.result.hitPositionEnter, false, "base\\characters\\common\\dismemberment\\man_big\\cut_parts\\gore\\ragdolls_hole_abdomen.dismdebris", 0.75);
            DismembermentComponent.RequestGutsFromLastHit(this.GetOwner(), "base\\characters\\common\\dismemberment\\man_big\\cut_parts\\gore\\ragdolls_explosion.dismdebris", 0.75);
            this.m_scatteredGuts = true;
          } else {
            DismembermentComponent.RequestDismemberment(this.GetOwner(), HitShapeUserDataBase.GetDismembermentBodyPart(this.GetHitShapeUserData()), woundType, this.m_hitShapeData.result.hitPositionEnter);
          };
          this.NotifyAboutDismembermentInstigated(this.m_attackData.GetInstigator(), hitReactionZone, this.m_ownerNPC.GetWorldPosition());
          if this.m_isAlive {
            this.m_ownerPuppet.Kill(this.m_attackData.GetInstigator());
            this.m_reactionType = animHitReactionType.Death;
            this.m_isAlive = false;
            if NotEquals(this.m_hitIntensity, EAIHitIntensity.Heavy) {
              this.m_hitIntensity = EAIHitIntensity.Medium;
            };
          };
        };
      };
    } else {
      dismembermentCheck = this.DismembermentConditions();
      woundedBaseConditions = this.WoundedBaseConditions();
      if this.WoundedFleshConditions(dismembermentCheck, woundedBaseConditions) {
        broadcaster = this.GetOwner().GetStimBroadcasterComponent();
        if IsDefined(broadcaster) {
          broadcaster.TriggerSingleBroadcast(this.GetOwner(), gamedataStimType.Attention);
        };
        this.m_bodyPartWoundCumulatedDamages[EnumInt(hitReactionZone)] = 0.00;
        StatusEffectHelper.ApplyStatusEffect(this.GetOwner(), TDBID.Create("BaseStatusEffect.Crippled" + EnumValueToString("EHitReactionZone", Cast<Int64>(EnumInt(hitReactionZone)))));
        this.m_specificHitTimeout = this.GetCurrentTime() + this.m_staggerDamageDuration;
        this.NotifyAboutWoundedInstigated(this.m_attackData.GetInstigator(), hitReactionZone);
        GameObject.PlayVoiceOver(this.m_ownerPuppet, EnumValueToName(n"EBarkList", Cast<Int64>(EnumInt(this.ReactionZoneEnumToBarkListEnum(hitReactionZone)))), n"Scripts:ProcessWoundsAndDismemberment");
        this.m_reactionType = animHitReactionType.Pain;
        this.m_hasBeenWounded = true;
      } else {
        if this.WoundedCyberConditions(dismembermentCheck, woundedBaseConditions) {
          DismembermentComponent.RequestDismemberment(this.GetOwner(), HitShapeUserDataBase.GetDismembermentBodyPart(this.GetHitShapeUserData()), woundType, this.m_hitShapeData.result.hitPositionEnter);
          this.NotifyAboutDismembermentInstigated(this.m_attackData.GetInstigator(), hitReactionZone, this.m_ownerNPC.GetWorldPosition());
          this.m_bodyPartWoundCumulatedDamages[EnumInt(hitReactionZone)] = 0.00;
          StatusEffectHelper.ApplyStatusEffect(this.GetOwner(), TDBID.Create("BaseStatusEffect.Dismembered" + EnumValueToString("EHitReactionZone", Cast<Int64>(EnumInt(hitReactionZone)))));
          this.m_specificHitTimeout = this.GetCurrentTime() + this.m_staggerDamageDuration;
          GameObject.PlayVoiceOver(this.m_ownerPuppet, EnumValueToName(n"EBarkList", Cast<Int64>(EnumInt(this.ReactionZoneEnumToBarkListEnum(hitReactionZone)))), n"Scripts:ProcessWoundsAndDismemberment");
          this.m_reactionType = animHitReactionType.Pain;
          this.m_hasBeenWounded = true;
        } else {
          if dismembermentCheck {
            DismembermentComponent.RequestDismemberment(this.GetOwner(), HitShapeUserDataBase.GetDismembermentBodyPart(this.GetHitShapeUserData()), woundType, this.m_hitShapeData.result.hitPositionEnter);
            this.NotifyAboutDismembermentInstigated(this.m_attackData.GetInstigator(), hitReactionZone, this.m_ownerNPC.GetWorldPosition());
            if this.m_isAlive {
              this.m_ownerPuppet.Kill(this.m_attackData.GetInstigator());
              this.m_reactionType = animHitReactionType.Death;
              this.m_isAlive = false;
              if NotEquals(this.m_hitIntensity, EAIHitIntensity.Heavy) {
                this.m_hitIntensity = EAIHitIntensity.Medium;
              };
            };
          };
        };
      };
    };
  }

  protected final func ReactionZoneEnumToBarkListEnum(reactionZone: EHitReactionZone) -> EBarkList {
    switch reactionZone {
      case EHitReactionZone.Head:
        return EBarkList.vo_enemy_reaction_crippled_arm;
      case EHitReactionZone.ChestLeft:
        return EBarkList.vo_enemy_reaction_crippled_arm;
      case EHitReactionZone.ArmLeft:
        return EBarkList.vo_enemy_reaction_crippled_arm;
      case EHitReactionZone.HandLeft:
        return EBarkList.vo_enemy_reaction_crippled_arm;
      case EHitReactionZone.ChestRight:
        return EBarkList.vo_enemy_reaction_crippled_arm;
      case EHitReactionZone.ArmRight:
        return EBarkList.vo_enemy_reaction_crippled_arm;
      case EHitReactionZone.HandRight:
        return EBarkList.vo_enemy_reaction_crippled_arm;
      case EHitReactionZone.Abdomen:
        return EBarkList.vo_enemy_reaction_crippled_arm;
      case EHitReactionZone.LegLeft:
        return EBarkList.vo_enemy_reaction_crippled_leg;
      case EHitReactionZone.LegRight:
        return EBarkList.vo_enemy_reaction_crippled_leg;
      default:
        return EBarkList.vo_enemy_reaction_crippled_arm;
    };
  }

  protected final func ReactionZoneEnumToBodyPartID(reactionZone: EHitReactionZone) -> Int32 {
    switch reactionZone {
      case EHitReactionZone.Head:
        return 1;
      case EHitReactionZone.ChestLeft:
        return 2;
      case EHitReactionZone.ArmLeft:
        return 2;
      case EHitReactionZone.HandLeft:
        return 2;
      case EHitReactionZone.ChestRight:
        return 3;
      case EHitReactionZone.ArmRight:
        return 3;
      case EHitReactionZone.HandRight:
        return 3;
      case EHitReactionZone.Abdomen:
        return 4;
      case EHitReactionZone.LegLeft:
        return 5;
      case EHitReactionZone.LegRight:
        return 6;
      default:
        return 0;
    };
  }

  protected final func WoundedBaseConditions() -> Bool {
    let reactionZoneIndex: Int32;
    if !this.m_isAlive {
      return false;
    };
    if this.m_ownerIsMassive {
      return false;
    };
    if this.m_inWorkspot {
      return false;
    };
    if this.m_inCover {
      return false;
    };
    if Equals(this.m_reactionType, animHitReactionType.Death) {
      return false;
    };
    if Equals(this.m_reactionType, animHitReactionType.Pain) {
      return false;
    };
    if Equals(this.m_reactionType, animHitReactionType.Ragdoll) {
      return false;
    };
    if ScriptedPuppet.IsDefeated(this.GetOwner()) {
      return false;
    };
    if this.m_ownerNPC.IsAboutToBeDefeated() {
      return false;
    };
    if AttackData.IsLightMelee(this.m_attackData.GetAttackType()) {
      return false;
    };
    if AttackData.IsStrongMelee(this.m_attackData.GetAttackType()) {
      return false;
    };
    if this.CheckInstantDismembermentOnDeath() {
      return true;
    };
    if this.m_knockdownImpulseThreshold > 0.00 && this.m_cumulatedPhysicalImpulse >= this.m_knockdownImpulseThreshold && this.m_knockdownDamageThreshold > 0.00 && this.m_cumulatedDamages >= this.m_knockdownDamageThreshold && !this.CheckInstantDismembermentOnDeath() {
      return false;
    };
    reactionZoneIndex = EnumInt(HitShapeUserDataBase.GetHitReactionZone(this.GetHitShapeUserData()));
    if this.m_woundedBodyPartDamageThreshold[reactionZoneIndex] <= 0.00 {
      return false;
    };
    if this.m_bodyPartWoundCumulatedDamages[reactionZoneIndex] < this.m_woundedBodyPartDamageThreshold[reactionZoneIndex] {
      return false;
    };
    return true;
  }

  protected final func WoundedFleshConditions(dismembermentCheck: Bool, woundedBaseConditions: Bool) -> Bool {
    if dismembermentCheck {
      return false;
    };
    if !woundedBaseConditions {
      return false;
    };
    if this.m_hasBeenWounded {
      return false;
    };
    if StatusEffectSystem.ObjectHasStatusEffectOfType(this.GetOwner(), gamedataStatusEffectType.Wounded) {
      return false;
    };
    if this.m_ownerPuppet.IsMechanical() {
      return false;
    };
    if NotEquals(this.GetHitShapeUserData().GetShapeType(), EHitShapeType.Flesh) {
      return false;
    };
    if this.m_ownerWeapon.IsMelee() {
      return false;
    };
    return true;
  }

  protected final func WoundedCyberConditions(dismembermentCheck: Bool, woundedBaseConditions: Bool) -> Bool {
    if dismembermentCheck {
      return false;
    };
    if !woundedBaseConditions {
      return false;
    };
    if this.m_hasMantisBladesinRecord {
      return false;
    };
    if NotEquals(this.GetHitShapeUserData().GetShapeType(), EHitShapeType.Metal) && NotEquals(this.GetHitShapeUserData().GetShapeType(), EHitShapeType.Cyberware) {
      return false;
    };
    if Equals(ScriptedPuppet.GetWeaponRight(this.m_attackData.GetSource()).GetWeaponRecord().ItemType().Type(), gamedataItemType.Cyb_MantisBlades) {
      return false;
    };
    if StatusEffectSystem.ObjectHasStatusEffectOfType(this.GetOwner(), gamedataStatusEffectType.Wounded) && !HitShapeUserDataBase.IsHitReactionZoneHead(this.GetHitShapeUserData()) {
      return false;
    };
    return true;
  }

  protected final func CanDieCondition(opt doNotCheckAttackData: Bool) -> Bool {
    if IsDefined(this.m_attackData) && !doNotCheckAttackData {
      if this.m_ownerNPC.IsDefeatMechanicActive() && this.m_attackData.HasFlag(hitFlag.Nonlethal) {
        return false;
      };
      if StatusEffectSystem.ObjectHasStatusEffect(this.m_attackData.GetInstigator(), t"GameplayRestriction.FistFight") {
        return false;
      };
    };
    if (this.m_ownerNPC.IsBoss() || Equals(this.m_ownerNPC.GetNPCRarity(), gamedataNPCRarity.MaxTac)) && !ScriptedPuppet.IsDefeated(this.GetOwner()) {
      return false;
    };
    if StatusEffectSystem.ObjectHasStatusEffect(this.m_ownerNPC, t"GameplayRestriction.FistFight") {
      return false;
    };
    if GameInstance.GetGodModeSystem(this.GetOwner().GetGame()).HasGodMode(this.m_ownerID, gameGodModeType.Immortal) {
      return false;
    };
    if GameInstance.GetGodModeSystem(this.GetOwner().GetGame()).HasGodMode(this.m_ownerID, gameGodModeType.Invulnerable) {
      return false;
    };
    if this.m_currentIsInvulnerable > 0.00 {
      return false;
    };
    return true;
  }

  protected final func DismembermentConditions() -> Bool {
    let bodyPartDamageThreshold: Float;
    let reactionZoneIndex: Int32 = EnumInt(HitShapeUserDataBase.GetHitReactionZone(this.GetHitShapeUserData()));
    if HitShapeUserDataBase.IsHitReactionZoneTorso(this.GetHitShapeUserData()) && AttackData.IsMelee(this.m_attackData.GetAttackType()) {
      return false;
    };
    if this.m_attackData.HasFlag(hitFlag.ForceDismember) {
      return true;
    };
    if this.m_isAlive && !this.m_ownerNPC.IsAboutToDie() && !this.m_ownerNPC.IsAboutToBeDefeated() && !ScriptedPuppet.IsDefeated(this.GetOwner()) {
      return false;
    };
    if this.CheckInstantDismembermentOnDeath() {
      return true;
    };
    bodyPartDamageThreshold = this.m_dismembermentBodyPartDamageThreshold[reactionZoneIndex];
    if bodyPartDamageThreshold <= 0.00 {
      return false;
    };
    if this.m_attackData.GetInstigator().IsPlayer() && PlayerDevelopmentSystem.GetData(this.m_attackData.GetInstigator()).IsNewPerkBought(gamedataNewPerkType.Reflexes_Master_Perk_5) > 0 {
      if StatusEffectSystem.ObjectHasStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.Reflexes_Master_Perk_5_Bleeding") {
        bodyPartDamageThreshold = bodyPartDamageThreshold * 0.75;
      };
    };
    if this.m_bodyPartDismemberCumulatedDamages[reactionZoneIndex] >= bodyPartDamageThreshold {
      return true;
    };
    return false;
  }

  protected final func ProcessFragmentationSplinterReaction(hitPosition: Vector4) -> Void {
    let broadcaster: ref<StimBroadcasterComponent>;
    let currentHPPerc: Float = this.GetHealthPecentageNormalized();
    if currentHPPerc > 30.00 {
      return;
    };
    if RandF() > 0.40 {
      if this.m_ownerNPC.WasJustKilledOrDefeated() {
        this.SendDismembermentCriticalEvent(gameDismWoundType.COARSE, gameDismBodyPart.LEFT_LEG, this.m_attackData.GetSource().GetWorldPosition(), RandRangeF(50.00, 75.00), this.m_hitShapeData.result.hitPositionEnter);
      } else {
        StatusEffectHelper.ApplyStatusEffect(this.GetOwner(), t"BaseStatusEffect.CrippledLegLeft");
        this.m_specificHitTimeout = this.GetCurrentTime() + this.m_staggerDamageDuration;
      };
    } else {
      if RandF() > 0.40 {
        if this.m_ownerNPC.WasJustKilledOrDefeated() {
          this.SendDismembermentCriticalEvent(gameDismWoundType.COARSE, gameDismBodyPart.RIGHT_LEG, this.m_attackData.GetSource().GetWorldPosition(), RandRangeF(50.00, 75.00), this.m_hitShapeData.result.hitPositionEnter);
        } else {
          StatusEffectHelper.ApplyStatusEffect(this.GetOwner(), t"BaseStatusEffect.CrippledLegRight");
          this.m_specificHitTimeout = this.GetCurrentTime() + this.m_staggerDamageDuration;
        };
      };
    };
    GameObject.PlayVoiceOver(this.m_ownerPuppet, EnumValueToName(n"EBarkList", Cast<Int64>(EnumInt(this.ReactionZoneEnumToBarkListEnum(HitShapeUserDataBase.GetHitReactionZone(this.GetHitShapeUserData()))))), n"Scripts:ProcessFragmentationSplinterReaction");
    broadcaster = this.GetOwner().GetStimBroadcasterComponent();
    if IsDefined(broadcaster) {
      broadcaster.TriggerSingleBroadcast(this.GetOwner(), gamedataStimType.Scream);
    };
  }

  protected final func IsValidBodyPerkDismemberAttack(healthMissing: Float) -> Bool {
    let weaponType: gamedataItemType;
    let chanceByHealth: Float = 0.00;
    if this.m_executeDismembered || this.m_invalidForExecuteDismember {
      return false;
    };
    if healthMissing < this.m_dismemberExecuteHealthRange.X {
      return false;
    };
    if this.m_ownerNPC.IsBoss() || Equals(this.m_ownerNPC.GetNPCRarity(), gamedataNPCRarity.MaxTac) {
      return false;
    };
    if !IsDefined(this.m_attackData) || NotEquals(this.m_attackData.GetAttackType(), gamedataAttackType.Ranged) || this.m_attackData.HasFlag(hitFlag.Explosion) {
      return false;
    };
    if !this.m_attackData.GetInstigator().IsPlayer() {
      return false;
    };
    if PlayerDevelopmentSystem.GetData(this.m_attackData.GetInstigator()).IsNewPerkBought(gamedataNewPerkType.Body_Left_Milestone_3) < 3 {
      return false;
    };
    if !IsDefined(this.m_attackData.GetWeapon()) {
      return false;
    };
    weaponType = RPGManager.GetItemType(this.m_attackData.GetWeapon().GetItemID());
    if NotEquals(weaponType, gamedataItemType.Wea_Shotgun) && NotEquals(weaponType, gamedataItemType.Wea_ShotgunDual) && NotEquals(weaponType, gamedataItemType.Wea_LightMachineGun) && NotEquals(weaponType, gamedataItemType.Wea_HeavyMachineGun) {
      return false;
    };
    chanceByHealth = this.m_statsSystem.GetStatValue(Cast<StatsObjectID>(this.m_attackData.GetInstigator().GetEntityID()), gamedataStatType.ExecuteDismemberByHealthChance);
    if chanceByHealth <= 0.00 {
      return false;
    };
    return true;
  }

  protected final func TryTriggerBodyPerkDismembement(remainingHealth: Float) -> Bool {
    let attackDistance: Float;
    let executeChance: Float = 0.00;
    let chanceByHealth: Float = 0.00;
    let chanceByProximity: Float = 0.00;
    chanceByHealth = this.m_statsSystem.GetStatValue(Cast<StatsObjectID>(this.m_attackData.GetInstigator().GetEntityID()), gamedataStatType.ExecuteDismemberByHealthChance);
    executeChance += ProportionalClampF(this.m_dismemberExecuteHealthRange.X, this.m_dismemberExecuteHealthRange.Y, remainingHealth, 0.00, chanceByHealth);
    chanceByProximity = this.m_statsSystem.GetStatValue(Cast<StatsObjectID>(this.m_attackData.GetInstigator().GetEntityID()), gamedataStatType.ExecuteDismemberProximityChance);
    if chanceByProximity > 0.00 {
      attackDistance = Vector4.Distance(this.m_ownerPuppet.GetWorldPosition(), this.m_attackData.GetInstigator().GetWorldPosition());
      executeChance += ProportionalClampF(this.m_dismemberExecuteDistanceRange.X, this.m_dismemberExecuteDistanceRange.Y, attackDistance, chanceByProximity, 0.00);
    };
    if executeChance <= 0.00 {
      return false;
    };
    return this.m_attackData.GetRandRoll() < executeChance;
  }

  protected final func IncrementBodyPerkDismembermentChance(player: wref<GameObject>) -> Void {
    if !IsDefined(player) || !player.IsPlayer() {
      return;
    };
    GameInstance.GetStatusEffectSystem(player.GetGame()).ApplyStatusEffect(player.GetEntityID(), t"BaseStatusEffect.Body_DismemberExecuteChance_Stack");
    this.m_invalidForExecuteDismember = true;
  }

  protected final func ClearBodyPerkDismembermentChance(player: wref<GameObject>) -> Void {
    if !IsDefined(player) || !player.IsPlayer() {
      return;
    };
    GameInstance.GetStatusEffectSystem(player.GetGame()).RemoveStatusEffect(player.GetEntityID(), t"BaseStatusEffect.Body_DismemberExecuteChance_Stack");
  }

  protected final func ProcessBodyPerkDismembement() -> Void {
    let adjustedHitDirection: Vector4;
    let attackWeaponID: StatsObjectID;
    let secondaryDismemberChance: Float = 0.80;
    let secondaryProjectileBonus: Float = 0.20;
    let highProjectileWeapon: Bool = false;
    let impulseFactor: Float = 1.00;
    let isLegHit: Bool = false;
    if IsDefined(this.m_attackData.GetWeapon()) {
      attackWeaponID = Cast<StatsObjectID>(this.m_attackData.GetWeapon().GetEntityID());
      highProjectileWeapon = this.m_statsSystem.GetStatValue(attackWeaponID, gamedataStatType.ProjectilesPerShot) > 3.00;
      if highProjectileWeapon {
        secondaryDismemberChance += secondaryProjectileBonus;
      };
    };
    if HitShapeUserDataBase.IsHitReactionZoneHead(this.GetHitShapeUserData()) {
      DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.HEAD, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter, true);
    } else {
      if HitShapeUserDataBase.IsHitReactionZoneTorso(this.GetHitShapeUserData()) {
        DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.BODY, gameDismWoundType.HOLE, this.m_hitShapeData.result.hitPositionEnter, true);
      } else {
        isLegHit = HitShapeUserDataBase.IsHitReactionZoneLeg(this.GetHitShapeUserData());
        DismembermentComponent.RequestDismemberment(this.GetOwner(), HitShapeUserDataBase.GetDismembermentBodyPart(this.GetHitShapeUserData()), gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter);
      };
    };
    if !isLegHit && (highProjectileWeapon || RandF() < secondaryDismemberChance) {
      DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.HEAD, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter, true);
    };
    if highProjectileWeapon || RandF() < secondaryDismemberChance {
      DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.BODY, gameDismWoundType.HOLE, this.m_hitShapeData.result.hitPositionEnter, true);
    };
    if RandF() < secondaryDismemberChance {
      DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.RIGHT_ARM, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter, true);
    };
    if RandF() < secondaryDismemberChance {
      DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.LEFT_ARM, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter, true);
    };
    if RandF() < secondaryDismemberChance {
      DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.RIGHT_LEG, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter, true);
    };
    if RandF() < secondaryDismemberChance {
      DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.LEFT_LEG, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter, true);
    };
    this.NotifyAboutDismembermentInstigated(this.m_attackData.GetInstigator(), HitShapeUserDataBase.GetHitReactionZone(this.GetHitShapeUserData()), this.m_ownerNPC.GetWorldPosition());
    this.GetOwner().Record1DamageInHistory(this.m_attackData.GetInstigator());
    adjustedHitDirection = this.GetOverridenHitDirection();
    impulseFactor = ProportionalClampF(0.00, 0.50, AbsF(adjustedHitDirection.Z), 1.50, 0.80);
    this.m_cumulatedPhysicalImpulse = this.m_knockdownImpulseThreshold + 10.00;
    this.m_ragdollImpulse = this.m_cumulatedPhysicalImpulse * impulseFactor;
    this.m_executeDismembered = true;
    GameObject.PlaySoundEvent(this.m_attackData.GetInstigator(), n"w_gun_perk_gratuitous_violence");
    if adjustedHitDirection.Z > 0.00 && adjustedHitDirection.Z < 0.25 {
      GameInstance.GetDelaySystem(this.m_ownerNPC.GetGame()).DelayEvent(this.m_ownerNPC, CreateRagdollApplyImpulseEvent(this.GetHitPosition(), new Vector4(0.00, 0.00, 1.00, 0.00) * this.m_ragdollImpulse * RandRangeF(0.10, 0.33), 1.00), 0.10, false);
    };
    GameInstance.GetDelaySystem(this.m_ownerNPC.GetGame()).DelayEvent(this.m_ownerNPC, CreateRagdollApplyImpulseEvent(this.GetHitPosition(), adjustedHitDirection * this.m_ragdollImpulse * 0.10, 1.00), 0.10, false);
    this.m_ownerPuppet.Kill(this.m_attackData.GetInstigator());
    this.m_reactionType = animHitReactionType.Ragdoll;
    this.m_isAlive = false;
    this.ClearBodyPerkDismembermentChance(this.m_attackData.GetInstigator());
  }

  public final func ProcessOnePunchAttackHitImpact(target: ref<ScriptedPuppet>, instigator: ref<GameObject>) -> Void {
    let evt: ref<PlayOnePunchVFX>;
    let impulseFactor: Float;
    let ragdollDirection: Vector4;
    let upwardsVector: Float;
    this.m_ownerNPC = target as NPCPuppet;
    let vfxDelay: Float = TDB.GetFloat(t"Items.StrongArms.vfxDelay");
    this.GetOwner().Record1DamageInHistory(this.m_attackData.GetInstigator());
    impulseFactor = TDB.GetFloat(t"Items.StrongArms.impulseOfOnePunch");
    upwardsVector = TDB.GetFloat(t"Items.StrongArms.upwardsVectorStrength");
    this.m_cumulatedPhysicalImpulse = this.m_knockdownImpulseThreshold + 10.00;
    this.m_ragdollImpulse = this.m_cumulatedPhysicalImpulse * impulseFactor;
    this.m_reactionType = animHitReactionType.Ragdoll;
    this.m_isAlive = false;
    GameInstance.GetDelaySystem(this.m_ownerNPC.GetGame()).DelayEvent(this.m_ownerNPC, CreateForceRagdollEvent(n"NPC killed with Gorilla Arms"), 0.01, false);
    ragdollDirection = (this.GetOverridenHitDirection() * 0.10 + new Vector4(0.00, 0.00, upwardsVector, 0.00) * 0.05) * this.m_ragdollImpulse;
    GameInstance.GetDelaySystem(this.m_ownerNPC.GetGame()).DelayEvent(this.m_ownerNPC, CreateRagdollApplyImpulseEvent(this.GetHitPosition(), ragdollDirection, 1.00), 0.10, false);
    evt = new PlayOnePunchVFX();
    evt.target = this.m_ownerNPC;
    evt.instigator = instigator;
    GameInstance.GetDelaySystem(this.m_ownerNPC.GetGame()).DelayEvent(this.m_ownerNPC, evt, vfxDelay, true);
  }

  protected final static func GetMantisBladesInstantDismembermentSpyBuffStatusEffectID() -> TweakDBID {
    return t"BaseStatusEffect.MantisBladesInstantDismembermentSpyBuff";
  }

  public final func ProcessGrandFinaleHitImpact(target: ref<ScriptedPuppet>, instigator: ref<GameObject>) -> Void {
    let evt: ref<PlayGrandFinaleVFX>;
    StatusEffectHelper.ApplyStatusEffect(target, t"BaseStatusEffect.MantisBladesInstantDismembermentSpyBuff", 0.40);
    evt = new PlayGrandFinaleVFX();
    evt.target = target;
    GameInstance.GetDelaySystem(target.GetGame()).DelayEvent(target, evt, 0.20, true);
  }

  protected cb func OnPlayOnePunchVFX(evt: ref<PlayOnePunchVFX>) -> Bool {
    GameObjectEffectHelper.StartEffectEvent(evt.target, n"blood_mouth_punch_strong");
    GameObjectEffectHelper.StartEffectEvent(evt.target, n"blood_nose_punch_strong");
    GameObjectEffectHelper.StartEffectEvent(evt.target, n"blood_headshot");
    GameObjectEffectHelper.StartEffectEvent(evt.target, n"finisher_katana_01_head");
    GameObjectEffectHelper.StartEffectEvent(evt.target, n"finisher_katana_01");
  }

  protected cb func OnPlayGrandFinaleVFX(evt: ref<PlayGrandFinaleVFX>) -> Bool {
    GameObjectEffectHelper.StartEffectEvent(evt.target, n"finisher_katana_01");
    GameObjectEffectHelper.StartEffectEvent(evt.target, n"finisher_katana_02");
    GameObjectEffectHelper.StartEffectEvent(evt.target, n"takedown_aerial_front_blood_ground");
  }

  protected final func ProcessExplosionDismembement() -> Void {
    let explosionCentrum: Vector4;
    let randomPreset: Int32;
    let strengthMin: Float = 50.00;
    let strengthMax: Float = 75.00;
    if Equals(this.m_reactionType, animHitReactionType.Death) || Equals(this.m_reactionType, animHitReactionType.Pain) || Equals(this.m_reactionType, animHitReactionType.Ragdoll) {
      explosionCentrum = this.m_attackData.GetSource().GetWorldPosition();
      if Vector4.Distance(this.m_ownerPuppet.GetWorldPosition(), explosionCentrum) <= 1.70 && !this.m_isAlive {
        randomPreset = RandRange(1, 9);
        switch randomPreset {
          case 1:
            this.SendDismembermentCriticalEvent(gameDismWoundType.COARSE, gameDismBodyPart.BODY, explosionCentrum, RandRangeF(strengthMin, strengthMax), this.m_hitShapeData.result.hitPositionEnter);
            break;
          case 2:
            this.SendDismembermentCriticalEvent(gameDismWoundType.COARSE, gameDismBodyPart.BODY, explosionCentrum, RandRangeF(strengthMin, strengthMax), this.m_hitShapeData.result.hitPositionEnter);
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.LEFT_ARM, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter, true);
            break;
          case 3:
            this.SendDismembermentCriticalEvent(gameDismWoundType.COARSE, gameDismBodyPart.BODY, explosionCentrum, RandRangeF(strengthMin, strengthMax), this.m_hitShapeData.result.hitPositionEnter);
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.RIGHT_ARM, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter, true);
            break;
          case 4:
            this.SendDismembermentCriticalEvent(gameDismWoundType.COARSE, gameDismBodyPart.BODY, explosionCentrum, RandRangeF(strengthMin, strengthMax), this.m_hitShapeData.result.hitPositionEnter);
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.LEFT_ARM, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter);
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.RIGHT_ARM, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter, true);
            break;
          case 5:
            this.SendDismembermentCriticalEvent(gameDismWoundType.COARSE, gameDismBodyPart.BODY, explosionCentrum, RandRangeF(strengthMin, strengthMax), this.m_hitShapeData.result.hitPositionEnter);
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.LEFT_ARM, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter, true);
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.RIGHT_ARM, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter);
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.HEAD, gameDismWoundType.HOLE, this.m_hitShapeData.result.hitPositionEnter);
            break;
          case 6:
            this.SendDismembermentCriticalEvent(gameDismWoundType.COARSE, gameDismBodyPart.BODY, explosionCentrum, RandRangeF(strengthMin, strengthMax), this.m_hitShapeData.result.hitPositionEnter);
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.LEFT_ARM, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter, true);
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.RIGHT_ARM, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter, true);
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.HEAD, gameDismWoundType.HOLE, this.m_hitShapeData.result.hitPositionEnter);
            break;
          case 7:
            this.SendDismembermentCriticalEvent(gameDismWoundType.COARSE, gameDismBodyPart.BODY, explosionCentrum, RandRangeF(strengthMin, strengthMax), this.m_hitShapeData.result.hitPositionEnter);
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.LEFT_ARM, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter, true);
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.RIGHT_ARM, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter, true);
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.HEAD, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter);
            break;
          case 8:
            this.SendDismembermentCriticalEvent(gameDismWoundType.COARSE, gameDismBodyPart.BODY, explosionCentrum, RandRangeF(strengthMin, strengthMax), this.m_hitShapeData.result.hitPositionEnter);
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.LEFT_ARM, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter);
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.RIGHT_ARM, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter);
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.HEAD, gameDismWoundType.HOLE, this.m_hitShapeData.result.hitPositionEnter);
            break;
          default:
            return;
        };
      } else {
        randomPreset = RandRange(1, 7);
        switch randomPreset {
          case 1:
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.HEAD, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter);
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.BODY, gameDismWoundType.HOLE, this.m_hitShapeData.result.hitPositionEnter);
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.LEFT_ARM, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter);
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.RIGHT_ARM, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter);
            break;
          case 2:
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.HEAD, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter);
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.BODY, gameDismWoundType.HOLE, this.m_hitShapeData.result.hitPositionEnter);
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.LEFT_ARM, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter);
            break;
          case 3:
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.HEAD, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter);
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.BODY, gameDismWoundType.HOLE, this.m_hitShapeData.result.hitPositionEnter);
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.RIGHT_ARM, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter);
            break;
          case 4:
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.LEFT_LEG, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter);
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.LEFT_ARM, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter);
            break;
          case 5:
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.HEAD, gameDismWoundType.HOLE, this.m_hitShapeData.result.hitPositionEnter);
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.RIGHT_LEG, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter);
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.RIGHT_ARM, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter);
            break;
          case 6:
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.LEFT_LEG, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter);
            DismembermentComponent.RequestDismemberment(this.GetOwner(), gameDismBodyPart.RIGHT_LEG, gameDismWoundType.COARSE, this.m_hitShapeData.result.hitPositionEnter);
            break;
          default:
            return;
        };
      };
      this.NotifyAboutDismembermentInstigated(this.m_attackData.GetInstigator(), HitShapeUserDataBase.GetHitReactionZone(this.GetHitShapeUserData()), this.m_ownerNPC.GetWorldPosition());
    };
  }

  protected final func SendDismembermentCriticalEvent(dismembermentType: gameDismWoundType, bodyPart: gameDismBodyPart, explosionEpicentrum: Vector4, strength: Float, hitPosition: Vector4) -> Void {
    let evt: ref<RequestDismembermentEvent> = new RequestDismembermentEvent();
    let evtExplosion: ref<DismembermentExplosionEvent> = new DismembermentExplosionEvent();
    evtExplosion.m_epicentrum = explosionEpicentrum;
    evtExplosion.m_strength = strength;
    evt.hitPosition = hitPosition;
    evt.dismembermentType = dismembermentType;
    evt.bodyPart = bodyPart;
    evt.isCritical = true;
    this.m_ownerPuppet.QueueEvent(evtExplosion);
    this.m_ownerPuppet.QueueEvent(evt);
  }

  protected final func GetHitIntensity(defeatedOverride: Bool) -> Void {
    if this.IsStrongExplosion(this.m_attackData) {
      this.m_hitIntensity = EAIHitIntensity.Explosion;
      this.m_animVariation = RandRange(0, 3);
    } else {
      if !this.m_ownerIsMassive && this.m_cumulatedPhysicalImpulse >= this.m_knockdownImpulseThreshold && (this.m_cumulatedDamages >= this.m_knockdownDamageThreshold || !this.m_isAlive) && this.m_knockdownDamageThreshold > 0.00 && this.m_knockdownImpulseThreshold > 0.00 {
        if this.m_specificHitTimeout > this.GetCurrentTime() && Equals(this.m_lastHitReactionPlayed, EAILastHitReactionPlayed.Knockdown) {
          this.m_hitIntensity = EAIHitIntensity.Medium;
          return;
        };
        this.m_hitIntensity = EAIHitIntensity.Heavy;
        if !defeatedOverride && this.CanDieCondition() && this.m_ownerNPC.IsAboutToBeDefeated() {
          this.GetOwner().Record1DamageInHistory(this.m_attackData.GetInstigator());
          this.m_ownerPuppet.Kill(this.m_attackData.GetInstigator());
          this.m_reactionType = animHitReactionType.Death;
          this.m_isAlive = false;
        };
      } else {
        this.m_hitIntensity = EAIHitIntensity.Medium;
      };
    };
  }

  private final func IsPowerDifferenceBelow(powerDifferential: gameEPowerDifferential) -> Bool {
    return EnumInt(RPGManager.CalculatePowerDifferential(this.GetOwner())) <= EnumInt(powerDifferential);
  }

  protected final func GetReactionType(guardBreakImpulse: Float, newHitEvent: ref<gameHitEvent>) -> animHitReactionType {
    let attackSubType: gamedataAttackSubtype;
    let attackWeaponType: gamedataItemType;
    let currentTimeStamp: Float;
    let hitReactionMax: Int32;
    let hitReactionMin: Int32;
    let meleeHitReactionResist: Bool;
    let meleePlayerExhausted: Bool;
    let powerDifferenceTooHigh: Bool;
    let shouldEvade: Bool;
    let weaponRecord: ref<WeaponItem_Record>;
    if !this.m_isAlive {
      return animHitReactionType.Death;
    };
    if this.m_ownerIsMassive || StatusEffectSystem.ObjectHasStatusEffectWithTag(this.GetOwner(), n"DismemberedLeg") {
      return animHitReactionType.Twitch;
    };
    if !this.m_ownerNPC.IsBoss() && NotEquals(this.m_ownerNPC.GetNPCRarity(), gamedataNPCRarity.MaxTac) {
      powerDifferenceTooHigh = EnumInt(RPGManager.CalculatePowerDifferential(this.GetOwner())) <= -6;
    };
    hitReactionMin = this.m_attackData.GetHitReactionSeverityMin();
    hitReactionMax = this.m_attackData.GetHitReactionSeverityMax();
    if newHitEvent.attackData.HasFlag(hitFlag.ForceKnockdown) {
      if hitReactionMin > -1 && hitReactionMin < 4 {
        hitReactionMin = 3;
      };
      if hitReactionMax > -1 && hitReactionMax < 4 {
        hitReactionMax = 3;
      };
    };
    weaponRecord = ScriptedPuppet.GetWeaponRight(this.m_attackData.GetSource()).GetWeaponRecord();
    if weaponRecord.ForcedMinHitReaction() > hitReactionMin {
      hitReactionMin = weaponRecord.ForcedMinHitReaction();
    };
    if this.m_attackData.GetInstigator().IsPlayer() && Equals(GameObject.GetAttitudeTowards(this.m_ownerNPC, this.m_attackData.GetInstigator()), EAIAttitude.AIA_Friendly) || Equals(this.m_ownerNPC.GetNPCType(), gamedataNPCType.Cerberus) {
      hitReactionMax = 0;
    };
    currentTimeStamp = this.GetCurrentTime();
    attackSubType = this.GetSubAttackSubType();
    if Equals(attackSubType, gamedataAttackSubtype.ThrowAttack) && Equals(this.m_attackData.GetAttackType(), gamedataAttackType.Thrown) && hitReactionMax == 2 && StatusEffectSystem.ObjectHasStatusEffectWithTag(this.GetOwner(), n"NoInterrupt") {
      hitReactionMax = 0;
    };
    if Equals(attackSubType, gamedataAttackSubtype.ComboAttack) && StatusEffectSystem.ObjectHasStatusEffectWithTag(this.GetOwner(), n"InterruptableWithKnives") && Equals(weaponRecord.ItemType().Type(), gamedataItemType.Wea_Knife) {
      hitReactionMin = 1;
    };
    if this.m_attackData.HasFlag(hitFlag.QuickHack) && Equals(this.m_attackData.GetAttackType(), gamedataAttackType.Hack) && hitReactionMax == 2 {
      this.RecalculateHitReactionValsForHacks(currentTimeStamp, hitReactionMin, hitReactionMax);
    };
    if AttackData.IsMelee(this.m_attackData.GetAttackType()) {
      this.m_previousMeleeHitTimeStamp = currentTimeStamp;
      if this.GetIsOwnerResistantToMeleeHitReaction() && NotEquals(attackSubType, gamedataAttackSubtype.DeflectAttack) {
        meleeHitReactionResist = true;
      };
      if this.m_attackData.GetInstigator().IsPlayer() {
        meleePlayerExhausted = StatusEffectSystem.ObjectHasStatusEffect(this.m_attackData.GetInstigator(), t"BaseStatusEffect.PlayerExhausted");
      };
      if Equals(attackSubType, gamedataAttackSubtype.DeflectAttack) && PlayerDevelopmentSystem.GetData(this.m_attackData.GetInstigator()).IsNewPerkBoughtAnyLevel(gamedataNewPerkType.Reflexes_Right_Perk_2_2) {
        if hitReactionMin < 2 {
          hitReactionMin = 2;
        };
        hitReactionMax = 3;
      };
    } else {
      this.m_previousRangedHitTimeStamp = currentTimeStamp;
    };
    if AttackData.IsLightMelee(this.m_attackData.GetAttackType()) {
      NPCPuppet.SendNPCHitDataTrackingRequest(this.m_ownerNPC, ENPCTelemetryData.HitByLightAttack, 1);
    } else {
      if AttackData.IsStrongMelee(this.m_attackData.GetAttackType()) || Equals(attackSubType, gamedataAttackSubtype.FinalAttack) {
        NPCPuppet.SendNPCHitDataTrackingRequest(this.m_ownerNPC, ENPCTelemetryData.HitByStrongAttack, 1);
      };
    };
    if Equals(attackSubType, gamedataAttackSubtype.BlockAttack) {
      NPCPuppet.SendNPCHitDataTrackingRequest(this.m_ownerNPC, ENPCTelemetryData.HitByBlockAttack, 1);
    };
    if Equals(attackSubType, gamedataAttackSubtype.FinalAttack) {
      NPCPuppet.SendNPCHitDataTrackingRequest(this.m_ownerNPC, ENPCTelemetryData.HitByFinalComboAttack, 1);
    };
    if !meleeHitReactionResist && !this.m_immuneToKnockDown && !powerDifferenceTooHigh && !meleePlayerExhausted && (this.IsStrongExplosion(this.m_attackData) || this.m_attackData.HasFlag(hitFlag.HighSpeedMelee) || this.m_knockdownDamageThreshold > 0.00 && this.m_knockdownImpulseThreshold > 0.00 && (hitReactionMax >= 3 || hitReactionMax == -1) && (hitReactionMin >= 3 || this.m_cumulatedPhysicalImpulse >= this.m_knockdownImpulseThreshold && this.m_cumulatedDamages >= this.m_knockdownDamageThreshold)) {
      if this.m_specificHitTimeout > currentTimeStamp && Equals(this.m_lastHitReactionPlayed, EAILastHitReactionPlayed.Knockdown) {
        return animHitReactionType.Twitch;
      };
      this.m_lastHitReactionPlayed = EAILastHitReactionPlayed.Knockdown;
      this.m_specificHitTimeout = currentTimeStamp + this.m_knockdownDamageDuration;
      return animHitReactionType.Knockdown;
    };
    if this.m_attackData.WasDeflected() {
      attackWeaponType = ScriptedPuppet.GetWeaponRight(this.m_attackData.GetSource()).GetWeaponRecord().ItemType().Type();
      if Equals(attackWeaponType, gamedataItemType.Cyb_StrongArms) {
        GameObject.StartReplicatedEffectEvent(this.GetOwner(), n"strong_arms_block");
      };
      if this.GetHasKerenzikov() && !this.GetCanBlock() {
        shouldEvade = true;
      };
      if meleePlayerExhausted || !this.CanAttackGuardBreak(attackWeaponType, guardBreakImpulse) || shouldEvade {
        this.m_previousMeleeHitTimeStamp = 0.00;
        NPCPuppet.SendNPCHitDataTrackingRequest(this.m_ownerNPC, ENPCTelemetryData.DeflectedAttack, 1);
        return animHitReactionType.Parry;
      };
      this.m_animVariation = 1;
      NPCPuppet.SendNPCHitDataTrackingRequest(this.m_ownerNPC, ENPCTelemetryData.WasGuardBreaked, 1);
      return animHitReactionType.GuardBreak;
    };
    if !meleeHitReactionResist && this.m_attackData.WasBlocked() {
      attackWeaponType = ScriptedPuppet.GetWeaponRight(this.m_attackData.GetSource()).GetWeaponRecord().ItemType().Type();
      if Equals(attackWeaponType, gamedataItemType.Cyb_StrongArms) {
        GameObject.StartReplicatedEffectEvent(this.GetOwner(), n"strong_arms_block");
      };
      if this.GetHasKerenzikov() && !this.GetCanBlock() {
        shouldEvade = true;
      };
      if meleePlayerExhausted || !this.CanAttackGuardBreak(attackWeaponType, guardBreakImpulse) || shouldEvade {
        NPCPuppet.SendNPCHitDataTrackingRequest(this.m_ownerNPC, ENPCTelemetryData.BlockedAttack, 1);
        return animHitReactionType.Block;
      };
      this.m_animVariation = 0;
      NPCPuppet.SendNPCHitDataTrackingRequest(this.m_ownerNPC, ENPCTelemetryData.WasGuardBreaked, 1);
      return animHitReactionType.GuardBreak;
    };
    if AttackData.IsQuickMelee(this.m_attackData.GetAttackType()) {
      this.m_quickMeleeCooldown = currentTimeStamp + PlayerPuppet.GetQuickMeleeCooldown();
      if meleeHitReactionResist {
        return animHitReactionType.Twitch;
      };
      if !powerDifferenceTooHigh && this.m_quickMeleeCooldown <= currentTimeStamp && RPGManager.HasStatFlag(this.m_attackData.GetInstigator(), gamedataStatType.CanQuickMeleeStagger) && hitReactionMax >= 2 {
        this.m_lastHitReactionPlayed = EAILastHitReactionPlayed.Stagger;
        this.m_specificHitTimeout = currentTimeStamp + this.m_staggerDamageDuration;
        this.m_previousRangedHitTimeStamp = currentTimeStamp;
        return animHitReactionType.Stagger;
      };
      if hitReactionMax < 2 && hitReactionMin >= 1 {
        return animHitReactionType.Impact;
      };
      return animHitReactionType.Twitch;
    };
    if newHitEvent.attackData.HasFlag(hitFlag.StunApplied) {
      this.m_lastHitReactionPlayed = EAILastHitReactionPlayed.None;
      this.m_specificHitTimeout = currentTimeStamp + this.m_staggerDamageDurationMelee;
      return animHitReactionType.None;
    };
    if !meleeHitReactionResist && !powerDifferenceTooHigh && !meleePlayerExhausted && this.m_staggerDamageThreshold > 0.00 && (hitReactionMax >= 2 || hitReactionMax == -1) && (hitReactionMin >= 2 || this.m_cumulatedDamages >= this.m_staggerDamageThreshold) {
      if this.m_specificHitTimeout > currentTimeStamp && (Equals(this.m_lastHitReactionPlayed, EAILastHitReactionPlayed.Stagger) || Equals(this.m_lastHitReactionPlayed, EAILastHitReactionPlayed.Knockdown) || AIActionHelper.IsCurrentlyCrouching(this.m_ownerPuppet)) {
        return animHitReactionType.Twitch;
      };
      this.m_lastHitReactionPlayed = EAILastHitReactionPlayed.Stagger;
      this.m_specificHitTimeout = currentTimeStamp + this.m_staggerDamageDurationMelee;
      return animHitReactionType.Stagger;
    };
    if !meleeHitReactionResist && this.m_impactDamageThreshold > 0.00 && (hitReactionMax >= 1 || hitReactionMax == -1) && (hitReactionMin >= 1 || this.m_cumulatedDamages >= this.m_impactDamageThreshold) || Equals(this.m_ownerNPC.GetNPCType(), gamedataNPCType.Drone) && this.m_attackData.HasFlag(hitFlag.SuccessfulAttack) && (Equals(this.m_attackData.GetAttackType(), gamedataAttackType.Hack) || Equals(this.m_attackData.GetAttackType(), gamedataAttackType.Explosion) && !VehicleComponent.IsMountedToVehicle(this.m_ownerNPC.GetGame(), this.m_ownerID)) {
      if this.m_specificHitTimeout > currentTimeStamp {
        return animHitReactionType.Twitch;
      };
      this.m_lastHitReactionPlayed = EAILastHitReactionPlayed.Impact;
      this.m_specificHitTimeout = currentTimeStamp + this.m_impactDamageDurationMelee;
      return animHitReactionType.Impact;
    };
    return animHitReactionType.Twitch;
  }

  private final func CanAttackGuardBreak(weaponType: gamedataItemType, guardBreakImpulse: Float) -> Bool {
    this.m_cumulatedGuardBreakImpulse += guardBreakImpulse;
    this.m_cumulatedEvadeBreakImpulse += 100.00 / this.m_attackerWeaponKnockdownImpulseForEvadeCumulation;
    if Equals(this.GetSubAttackSubType(), gamedataAttackSubtype.DeflectAttack) {
      return true;
    };
    if this.m_attackerWeaponKnockdownImpulseForEvade > this.m_ownerWeaponKnockdownImpulseForEvade || Equals(this.m_ownerWeapon.GetWeaponRecord().ItemType().Type(), gamedataItemType.Wea_Fists) && NotEquals(weaponType, gamedataItemType.Wea_Fists) && NotEquals(weaponType, gamedataItemType.Cyb_StrongArms) {
      if this.GetHasKerenzikov() {
        if this.m_cumulatedEvadeBreakImpulse >= this.m_totalStamina / 2.00 {
          this.m_cumulatedGuardBreakImpulse = 0.00;
          this.m_cumulatedEvadeBreakImpulse = 0.00;
          this.StartGuardBreakCooldown();
          return true;
        };
        return false;
      };
      this.m_cumulatedGuardBreakImpulse = 0.00;
      this.m_cumulatedEvadeBreakImpulse = 0.00;
      this.StartGuardBreakCooldown();
      return true;
    };
    if !this.GetCanBlock() && this.GetHasKerenzikov() {
      if this.m_cumulatedEvadeBreakImpulse >= this.m_totalStamina / 2.00 {
        this.m_cumulatedGuardBreakImpulse = 0.00;
        this.m_cumulatedEvadeBreakImpulse = 0.00;
        this.StartGuardBreakCooldown();
        return true;
      };
      return false;
    };
    if this.m_cumulatedGuardBreakImpulse >= this.m_totalStamina {
      if this.GetHasKerenzikov() {
        if this.m_cumulatedEvadeBreakImpulse >= this.m_totalStamina / 2.00 {
          this.m_cumulatedGuardBreakImpulse = 0.00;
          this.m_cumulatedEvadeBreakImpulse = 0.00;
          this.StartGuardBreakCooldown();
          return true;
        };
        return false;
      };
      this.m_cumulatedGuardBreakImpulse = 0.00;
      this.m_cumulatedEvadeBreakImpulse = 0.00;
      this.StartGuardBreakCooldown();
      return true;
    };
    return false;
  }

  private final func StartGuardBreakCooldown() -> Void {
    let cdRequest: RegisterNewCooldownRequest;
    let cs: ref<ICooldownSystem> = CSH.GetCooldownSystem(this.m_ownerNPC);
    cdRequest.cooldownName = n"GuardBreak";
    cdRequest.duration = this.m_guardBreakImpulseReset;
    cdRequest.owner = this.m_ownerNPC;
    cs.Register(cdRequest);
    cdRequest.cooldownName = n"DodgeCooldown";
    cs.Register(cdRequest);
    cdRequest.cooldownName = n"DodgeHitCooldown";
    cs.Register(cdRequest);
  }

  private final func IsStrongExplosion(attackData: ref<AttackData>) -> Bool {
    let explosionCentrum: Vector4;
    let explosionImpulse: Float;
    if AttackData.IsExplosion(attackData.GetAttackType()) && !attackData.HasFlag(hitFlag.WeakExplosion) {
      explosionCentrum = this.m_attackData.GetSource().GetWorldPosition();
      explosionImpulse = this.m_cumulatedPhysicalImpulse * 3.00 / Vector4.Distance(this.m_ownerPuppet.GetWorldPosition(), explosionCentrum);
      if Vector4.Distance(this.m_ownerPuppet.GetWorldPosition(), explosionCentrum) <= 3.00 {
        return true;
      };
      if explosionImpulse >= this.m_knockdownImpulseThreshold {
        return true;
      };
    };
    return false;
  }

  private final func SendDataToAIBehavior(reactionPlayed: animHitReactionType) -> Void {
    let canRagdoll: Bool;
    let hitAIEvent: ref<StimuliEvent> = new StimuliEvent();
    if (Equals(reactionPlayed, animHitReactionType.Death) || this.m_ownerNPC.IsAboutToBeDefeated()) && this.m_ownerPuppet.GetPuppetStateBlackboard().GetBool(GetAllBlackboardDefs().AIAction.ownerInTumble) {
      hitAIEvent.name = n"ForcedRagdoll";
    } else {
      switch reactionPlayed {
        case animHitReactionType.Impact:
          hitAIEvent.name = n"Impact";
          if StatusEffectSystem.ObjectHasStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.SpecialCloaked_Hard") {
            StatusEffectHelper.RemoveStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.SpecialCloaked_Hard");
          };
          if StatusEffectSystem.ObjectHasStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.SpecialCloaked_VeryHard") {
            StatusEffectHelper.RemoveStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.SpecialCloaked_VeryHard");
          };
          if StatusEffectSystem.ObjectHasStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.Cloaked") {
            StatusEffectHelper.RemoveStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.Cloaked");
          };
          break;
        case animHitReactionType.Pain:
          hitAIEvent.name = n"Pain";
          break;
        case animHitReactionType.Stagger:
          if this.m_previousRagdollTimeStamp != this.GetCurrentTime() && this.m_ownerNPC.GetPuppetStateBlackboard().GetBool(GetAllBlackboardDefs().PuppetState.InAirAnimation) && (ScriptedPuppet.CanRagdoll(this.m_ownerNPC) || this.m_ownerNPC.IsRagdolling()) {
            this.m_ownerNPC.QueueEvent(CreateForceRagdollEvent(n"InAir_RecivedHit"));
            GameInstance.GetDelaySystem(this.m_ownerNPC.GetGame()).DelayEvent(this.m_ownerNPC, CreateRagdollApplyImpulseEvent(this.GetHitPosition(), this.GetOverridenHitDirection() * this.m_ragdollImpulse, 5.00), 0.10, false);
            this.m_previousRagdollTimeStamp = this.GetCurrentTime();
          };
          hitAIEvent.name = n"Stagger";
          if StatusEffectSystem.ObjectHasStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.SpecialCloaked_Hard") {
            StatusEffectHelper.RemoveStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.SpecialCloaked_Hard");
          };
          if StatusEffectSystem.ObjectHasStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.SpecialCloaked_VeryHard") {
            StatusEffectHelper.RemoveStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.SpecialCloaked_VeryHard");
          };
          if StatusEffectSystem.ObjectHasStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.Cloaked") {
            StatusEffectHelper.RemoveStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.Cloaked");
          };
          break;
        case animHitReactionType.Knockdown:
          if this.m_previousRagdollTimeStamp != this.GetCurrentTime() && ScriptedPuppet.CanRagdoll(this.m_ownerNPC) || this.m_ownerNPC.IsRagdolling() {
            if this.m_ownerNPC.GetPuppetStateBlackboard().GetBool(GetAllBlackboardDefs().PuppetState.InAirAnimation) {
              this.m_ownerNPC.QueueEvent(CreateForceRagdollEvent(n"InAir_RecivedHit"));
              GameInstance.GetDelaySystem(this.m_ownerNPC.GetGame()).DelayEvent(this.m_ownerNPC, CreateRagdollApplyImpulseEvent(this.GetHitPosition(), this.GetOverridenHitDirection() * this.m_ragdollImpulse, 5.00), 0.10, false);
              this.m_previousRagdollTimeStamp = this.GetCurrentTime();
            } else {
              if this.m_ragdollImpulse > 1.50 * this.m_knockdownImpulseThreshold {
                this.m_ownerNPC.SetIndividualTimeDilation(n"VeryStrongHit", this.m_ragdollImpulse / this.m_knockdownImpulseThreshold, 0.50, n"None", n"None");
                GameInstance.GetDelaySystem(this.m_ownerNPC.GetGame()).DelayEvent(this.m_ownerNPC, CreateForceRagdollEvent(n"VeryStrongHit"), 0.10, false);
                GameInstance.GetDelaySystem(this.m_ownerNPC.GetGame()).DelayEvent(this.m_ownerNPC, CreateRagdollApplyImpulseEvent(this.GetHitPosition(), this.GetOverridenHitDirection() * this.m_ragdollImpulse, 5.00), 0.20, false);
              };
            };
          };
          hitAIEvent.name = n"Knockdown";
          if StatusEffectSystem.ObjectHasStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.SpecialCloaked_Hard") {
            StatusEffectHelper.RemoveStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.SpecialCloaked_Hard");
          };
          if StatusEffectSystem.ObjectHasStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.SpecialCloaked_VeryHard") {
            StatusEffectHelper.RemoveStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.SpecialCloaked_VeryHard");
          };
          if StatusEffectSystem.ObjectHasStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.Cloaked") {
            StatusEffectHelper.RemoveStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.Cloaked");
          };
          break;
        case animHitReactionType.Block:
          hitAIEvent.name = n"Block";
          break;
        case animHitReactionType.GuardBreak:
          hitAIEvent.name = n"GuardBreak";
          break;
        case animHitReactionType.Parry:
          hitAIEvent.name = n"Parry";
          break;
        case animHitReactionType.Death:
          canRagdoll = ScriptedPuppet.CanRagdoll(this.m_ownerPuppet);
          if this.m_ownerNPC.ShouldSkipDeathAnimation() {
            if canRagdoll {
              hitAIEvent.name = n"ForcedRagdoll";
            };
            break;
          };
          if !canRagdoll {
            hitAIEvent.name = n"Death";
          } else {
            if StatusEffectSystem.ObjectHasStatusEffectOfType(this.GetOwner(), gamedataStatusEffectType.Knockdown) || this.m_ownerNPC.GetPuppetStateBlackboard().GetBool(GetAllBlackboardDefs().PuppetState.InAirAnimation) {
              hitAIEvent.name = n"ForcedRagdoll";
            } else {
              if this.m_ownerPuppet.GetPuppetStateBlackboard().GetBool(GetAllBlackboardDefs().PuppetState.ForceRagdollOnDeath) {
                if this.GetIsOwnerImmuneToExtendedHitReaction() == 0.00 && EnumInt(this.m_hitIntensity) <= 1 && this.m_animVariation < 13 && (this.m_deathRegisteredTime + 0.50 >= this.GetCurrentTime() || this.m_extendedDeathRegisteredTime + 0.50 >= this.GetCurrentTime()) {
                  hitAIEvent.name = n"Death";
                } else {
                  hitAIEvent.name = n"ForcedRagdoll";
                };
              } else {
                hitAIEvent.name = n"Death";
              };
            };
          };
          break;
        default:
          return;
      };
    };
    hitAIEvent.id += 1u;
    this.m_currentStimId = hitAIEvent.id;
    this.m_lastStimName = hitAIEvent.name;
    if Equals(reactionPlayed, animHitReactionType.Death) || Equals(reactionPlayed, animHitReactionType.Ragdoll) {
      this.m_deathStimName = hitAIEvent.name;
    };
    this.GetOwner().QueueEvent(hitAIEvent);
  }

  private final func RecalculateHitReactionValsForHacks(currentTimeStamp: Float, out hitReactionMin: Int32, out hitReactionMax: Int32) -> Void {
    let preventQhStaggerDurationVal: Float = TDB.GetFloat(t"BaseStats.PreventQuickhackStaggerDuration.staggerValue");
    let preventQhImpactDurationVal: Float = TDB.GetFloat(t"BaseStats.PreventQuickhackStaggerDuration.impactValue");
    if preventQhStaggerDurationVal > 0.00 && currentTimeStamp - this.m_previousHackStaggerTimeStamp <= preventQhStaggerDurationVal {
      if !StatusEffectSystem.ObjectHasStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.PreventQHStaggerAnimation") {
        StatusEffectHelper.ApplyStatusEffect(this.m_ownerNPC, t"BaseStatusEffect.PreventQHStaggerAnimation");
      };
      hitReactionMax = 1;
      if preventQhImpactDurationVal > 0.00 && currentTimeStamp - this.m_previousHackImpactTimeStamp <= preventQhImpactDurationVal {
        hitReactionMax = 0;
      } else {
        this.m_previousHackImpactTimeStamp = currentTimeStamp;
      };
    } else {
      this.m_previousHackStaggerTimeStamp = currentTimeStamp;
    };
    hitReactionMin = Min(hitReactionMin, hitReactionMax);
  }

  protected final func SendMechDataToAIBehavior(reactionPlayed: animHitReactionType) -> Void {
    let hitAIEvent: ref<StimuliEvent> = new StimuliEvent();
    switch reactionPlayed {
      case animHitReactionType.Impact:
        hitAIEvent.name = n"Impact";
        break;
      case animHitReactionType.Stagger:
        hitAIEvent.name = n"Stagger";
        break;
      case animHitReactionType.Death:
        hitAIEvent.name = n"Death";
        break;
      default:
        return;
    };
    hitAIEvent.id += 1u;
    this.m_currentStimId = hitAIEvent.id;
    this.m_lastStimName = hitAIEvent.name;
    if Equals(reactionPlayed, animHitReactionType.Death) || Equals(reactionPlayed, animHitReactionType.Ragdoll) {
      this.m_deathStimName = hitAIEvent.name;
    };
    this.GetOwner().QueueEvent(hitAIEvent);
  }

  protected final func SetHitSource(attackType: gamedataAttackType) -> Void {
    if Equals(attackType, gamedataAttackType.Direct) || Equals(attackType, gamedataAttackType.Ranged) || Equals(attackType, gamedataAttackType.Explosion) || Equals(attackType, gamedataAttackType.Hack) {
      this.SetHitReactionSource(EAIHitSource.Ranged);
    } else {
      if Equals(attackType, gamedataAttackType.WhipAttack) || Equals(attackType, gamedataAttackType.ChargedWhipAttack) {
        this.SetHitReactionSource(EAIHitSource.MeleeSharp);
      } else {
        if Equals(attackType, gamedataAttackType.Melee) || Equals(attackType, gamedataAttackType.StrongMelee) {
          this.SetHitReactionSource(EAIHitSource.MeleeBlunt);
        } else {
          if Equals(attackType, gamedataAttackType.QuickMelee) {
            if RPGManager.HasStatFlag(this.m_attackData.GetInstigator(), gamedataStatType.CanQuickMeleeStagger) && this.m_quickMeleeCooldown <= this.GetCurrentTime() {
              this.SetHitReactionSource(EAIHitSource.QuickMelee);
            } else {
              this.SetHitReactionSource(EAIHitSource.MeleeBlunt);
            };
          };
        };
      };
    };
  }

  private final func SetAnimVariation(out hitDirection: Int32, out hitReactionZone: EHitReactionZone) -> Void {
    let attackDirection: gamedataMeleeAttackDirection;
    let currentBodyPart: Int32;
    let excludedVariation: Int32;
    let i: Int32;
    if Equals(this.m_reactionType, animHitReactionType.GuardBreak) {
      if AttackData.IsMelee(this.m_attackData.GetAttackType()) {
        attackDirection = (this.m_attackData.GetAttackDefinition().GetRecord() as Attack_Melee_Record).AttackDirection().Direction().Type();
        switch attackDirection {
          case gamedataMeleeAttackDirection.LeftToRight:
            this.m_reactionType = animHitReactionType.Stagger;
            this.m_overridenHitDirection = true;
            switch hitDirection {
              case 1:
                hitDirection = 4;
                break;
              case 2:
                hitDirection = 1;
                break;
              case 3:
                hitDirection = 2;
                break;
              case 4:
                hitDirection = 3;
                break;
              default:
                hitDirection = 3;
                return;
            };
            break;
          case gamedataMeleeAttackDirection.RightToLeft:
            this.m_reactionType = animHitReactionType.Stagger;
            this.m_overridenHitDirection = true;
            switch hitDirection {
              case 1:
                hitDirection = 2;
                break;
              case 2:
                hitDirection = 3;
                break;
              case 3:
                hitDirection = 4;
                break;
              case 4:
                hitDirection = 1;
                break;
              default:
                hitDirection = 1;
                return;
            };
            break;
          default:
            return;
        };
      };
    } else {
      if NotEquals(this.m_reactionType, animHitReactionType.Parry) {
        if AttackData.IsMelee(this.m_attackData.GetAttackType()) && NotEquals(this.m_reactionType, animHitReactionType.Twitch) {
          if NotEquals(this.m_reactionType, animHitReactionType.Death) {
            excludedVariation = -1;
            currentBodyPart = this.ReactionZoneEnumToBodyPartID(HitShapeUserDataBase.GetHitReactionZone(this.GetHitShapeUserData()));
            attackDirection = (this.m_attackData.GetAttackDefinition().GetRecord() as Attack_Melee_Record).AttackDirection().Direction().Type();
            i = 0;
            while i < ArraySize(this.m_previousAnimHitReactionArray) {
              if this.m_previousAnimHitReactionArray[i].hitBodyPart == currentBodyPart && this.m_previousAnimHitReactionArray[i].attackDirection == EnumInt(attackDirection) {
                excludedVariation = this.m_previousAnimHitReactionArray[i].animVariation;
              };
              i += 1;
            };
            switch attackDirection {
              case gamedataMeleeAttackDirection.Center:
                this.m_animVariation = 0 + RandDifferent(excludedVariation, 3);
                break;
              case gamedataMeleeAttackDirection.DownToUp:
                this.m_animVariation = 3 + RandDifferent(excludedVariation - 3, 3);
                if Equals(hitReactionZone, EHitReactionZone.LegLeft) || Equals(hitReactionZone, EHitReactionZone.LegRight) {
                  hitReactionZone = EHitReactionZone.Head;
                };
                break;
              case gamedataMeleeAttackDirection.LeftDownToRightUp:
                this.m_animVariation = 6 + RandDifferent(excludedVariation - 6, 3);
                this.m_overridenHitDirection = true;
                switch hitDirection {
                  case 1:
                    hitDirection = 4;
                    break;
                  case 2:
                    hitDirection = 1;
                    break;
                  case 3:
                    hitDirection = 2;
                    break;
                  case 4:
                    hitDirection = 3;
                    break;
                  default:
                    hitDirection = 3;
                };
                if Equals(hitReactionZone, EHitReactionZone.Abdomen) {
                  switch hitDirection {
                    case 1:
                      hitReactionZone = EHitReactionZone.ChestLeft;
                      break;
                    case 2:
                      hitReactionZone = EHitReactionZone.ChestLeft;
                      break;
                    case 3:
                      hitReactionZone = EHitReactionZone.ChestRight;
                      break;
                    case 4:
                      hitReactionZone = EHitReactionZone.ChestRight;
                      break;
                    default:
                  };
                };
                break;
              case gamedataMeleeAttackDirection.LeftToRight:
                this.m_animVariation = 9 + RandDifferent(excludedVariation - 9, 3);
                this.m_overridenHitDirection = true;
                switch hitDirection {
                  case 1:
                    hitDirection = 4;
                    break;
                  case 2:
                    hitDirection = 1;
                    break;
                  case 3:
                    hitDirection = 2;
                    break;
                  case 4:
                    hitDirection = 3;
                    break;
                  default:
                    hitDirection = 3;
                };
                if Equals(hitReactionZone, EHitReactionZone.Abdomen) {
                  switch hitDirection {
                    case 1:
                      hitDirection = 4;
                      break;
                    case 2:
                      hitDirection = 1;
                      break;
                    case 3:
                      hitDirection = 2;
                      break;
                    case 4:
                      hitDirection = 3;
                      break;
                    default:
                      hitDirection = 3;
                  };
                };
                if Equals(hitReactionZone, EHitReactionZone.Abdomen) {
                  switch hitDirection {
                    case 1:
                      hitReactionZone = EHitReactionZone.ChestLeft;
                      break;
                    case 2:
                      hitReactionZone = EHitReactionZone.ChestLeft;
                      break;
                    case 3:
                      hitReactionZone = EHitReactionZone.ChestRight;
                      break;
                    case 4:
                      hitReactionZone = EHitReactionZone.ChestRight;
                      break;
                    default:
                  };
                };
                break;
              case gamedataMeleeAttackDirection.LeftUpToRightDown:
                this.m_animVariation = 12 + RandDifferent(excludedVariation - 12, 3);
                this.m_overridenHitDirection = true;
                switch hitDirection {
                  case 1:
                    hitDirection = 4;
                    break;
                  case 2:
                    hitDirection = 1;
                    break;
                  case 3:
                    hitDirection = 2;
                    break;
                  case 4:
                    hitDirection = 3;
                    break;
                  default:
                    hitDirection = 3;
                };
                if Equals(this.m_reactionType, animHitReactionType.Knockdown) {
                  switch hitDirection {
                    case 1:
                      hitReactionZone = EHitReactionZone.LegLeft;
                      break;
                    case 2:
                      hitReactionZone = EHitReactionZone.LegLeft;
                      break;
                    case 3:
                      hitReactionZone = EHitReactionZone.LegRight;
                      break;
                    case 4:
                      hitReactionZone = EHitReactionZone.LegRight;
                      break;
                    default:
                  };
                };
                if Equals(hitReactionZone, EHitReactionZone.Abdomen) {
                  switch hitDirection {
                    case 1:
                      hitReactionZone = EHitReactionZone.ChestLeft;
                      break;
                    case 2:
                      hitReactionZone = EHitReactionZone.ChestLeft;
                      break;
                    case 3:
                      hitReactionZone = EHitReactionZone.ChestRight;
                      break;
                    case 4:
                      hitReactionZone = EHitReactionZone.ChestRight;
                      break;
                    default:
                  };
                };
                break;
              case gamedataMeleeAttackDirection.RightDownToLeftUp:
                this.m_animVariation = 15 + RandDifferent(excludedVariation - 15, 3);
                this.m_overridenHitDirection = true;
                switch hitDirection {
                  case 1:
                    hitDirection = 2;
                    break;
                  case 2:
                    hitDirection = 3;
                    break;
                  case 3:
                    hitDirection = 4;
                    break;
                  case 4:
                    hitDirection = 1;
                    break;
                  default:
                    hitDirection = 1;
                };
                if Equals(hitReactionZone, EHitReactionZone.Abdomen) {
                  switch hitDirection {
                    case 1:
                      hitReactionZone = EHitReactionZone.ChestRight;
                      break;
                    case 2:
                      hitReactionZone = EHitReactionZone.ChestRight;
                      break;
                    case 3:
                      hitReactionZone = EHitReactionZone.ChestLeft;
                      break;
                    case 4:
                      hitReactionZone = EHitReactionZone.ChestLeft;
                      break;
                    default:
                  };
                };
                break;
              case gamedataMeleeAttackDirection.RightToLeft:
                this.m_animVariation = 18 + RandDifferent(excludedVariation - 18, 3);
                this.m_overridenHitDirection = true;
                switch hitDirection {
                  case 1:
                    hitDirection = 2;
                    break;
                  case 2:
                    hitDirection = 3;
                    break;
                  case 3:
                    hitDirection = 4;
                    break;
                  case 4:
                    hitDirection = 1;
                    break;
                  default:
                    hitDirection = 1;
                };
                if Equals(hitReactionZone, EHitReactionZone.Abdomen) {
                  switch hitDirection {
                    case 1:
                      hitDirection = 2;
                      break;
                    case 2:
                      hitDirection = 3;
                      break;
                    case 3:
                      hitDirection = 4;
                      break;
                    case 4:
                      hitDirection = 1;
                      break;
                    default:
                      hitDirection = 1;
                  };
                };
                if Equals(hitReactionZone, EHitReactionZone.Abdomen) {
                  switch hitDirection {
                    case 1:
                      hitReactionZone = EHitReactionZone.ChestRight;
                      break;
                    case 2:
                      hitReactionZone = EHitReactionZone.ChestRight;
                      break;
                    case 3:
                      hitReactionZone = EHitReactionZone.ChestLeft;
                      break;
                    case 4:
                      hitReactionZone = EHitReactionZone.ChestLeft;
                      break;
                    default:
                  };
                };
                break;
              case gamedataMeleeAttackDirection.RightUpToLeftDown:
                this.m_animVariation = 21 + RandDifferent(excludedVariation - 21, 3);
                this.m_overridenHitDirection = true;
                switch hitDirection {
                  case 1:
                    hitDirection = 2;
                    break;
                  case 2:
                    hitDirection = 3;
                    break;
                  case 3:
                    hitDirection = 4;
                    break;
                  case 4:
                    hitDirection = 1;
                    break;
                  default:
                    hitDirection = 1;
                };
                if Equals(this.m_reactionType, animHitReactionType.Knockdown) {
                  switch hitDirection {
                    case 1:
                      hitReactionZone = EHitReactionZone.LegRight;
                      break;
                    case 2:
                      hitReactionZone = EHitReactionZone.LegRight;
                      break;
                    case 3:
                      hitReactionZone = EHitReactionZone.LegLeft;
                      break;
                    case 4:
                      hitReactionZone = EHitReactionZone.LegLeft;
                      break;
                    default:
                  };
                };
                if Equals(hitReactionZone, EHitReactionZone.Abdomen) {
                  switch hitDirection {
                    case 1:
                      hitReactionZone = EHitReactionZone.ChestRight;
                      break;
                    case 2:
                      hitReactionZone = EHitReactionZone.ChestRight;
                      break;
                    case 3:
                      hitReactionZone = EHitReactionZone.ChestLeft;
                      break;
                    case 4:
                      hitReactionZone = EHitReactionZone.ChestLeft;
                      break;
                    default:
                  };
                };
                break;
              case gamedataMeleeAttackDirection.UpToDown:
                this.m_animVariation = 24 + RandDifferent(excludedVariation - 24, 3);
                if Equals(this.m_reactionType, animHitReactionType.Knockdown) {
                  switch hitDirection {
                    case 1:
                      hitReactionZone = EHitReactionZone.LegLeft;
                      break;
                    case 2:
                      hitReactionZone = EHitReactionZone.LegLeft;
                      break;
                    case 3:
                      hitReactionZone = EHitReactionZone.LegRight;
                      break;
                    case 4:
                      hitReactionZone = EHitReactionZone.LegRight;
                      break;
                    default:
                  };
                };
                break;
              default:
                return;
            };
          } else {
            this.m_animVariation = RandRange(0, 3);
            attackDirection = (this.m_attackData.GetAttackDefinition().GetRecord() as Attack_Melee_Record).AttackDirection().Direction().Type();
            switch attackDirection {
              case gamedataMeleeAttackDirection.UpToDown:
                if Equals(this.m_reactionType, animHitReactionType.Knockdown) || Equals(this.m_hitIntensity, EAIHitIntensity.Heavy) {
                  switch hitDirection {
                    case 1:
                      hitReactionZone = EHitReactionZone.LegLeft;
                      break;
                    case 2:
                      hitReactionZone = EHitReactionZone.LegLeft;
                      break;
                    case 3:
                      hitReactionZone = EHitReactionZone.LegRight;
                      break;
                    case 4:
                      hitReactionZone = EHitReactionZone.LegRight;
                      break;
                    default:
                  };
                };
                break;
              case gamedataMeleeAttackDirection.LeftDownToRightUp:
                switch hitDirection {
                  case 1:
                    hitDirection = 4;
                    break;
                  case 2:
                    hitDirection = 1;
                    break;
                  case 3:
                    hitDirection = 2;
                    break;
                  case 4:
                    hitDirection = 3;
                    break;
                  default:
                    hitDirection = 3;
                };
                if Equals(hitReactionZone, EHitReactionZone.Abdomen) {
                  switch hitDirection {
                    case 1:
                      hitReactionZone = EHitReactionZone.ChestLeft;
                      break;
                    case 2:
                      hitReactionZone = EHitReactionZone.ChestLeft;
                      break;
                    case 3:
                      hitReactionZone = EHitReactionZone.ChestRight;
                      break;
                    case 4:
                      hitReactionZone = EHitReactionZone.ChestRight;
                      break;
                    default:
                  };
                };
                break;
              case gamedataMeleeAttackDirection.LeftToRight:
                this.m_overridenHitDirection = true;
                switch hitDirection {
                  case 1:
                    hitDirection = 4;
                    break;
                  case 2:
                    hitDirection = 1;
                    break;
                  case 3:
                    hitDirection = 2;
                    break;
                  case 4:
                    hitDirection = 3;
                    break;
                  default:
                    hitDirection = 3;
                };
                if Equals(hitReactionZone, EHitReactionZone.Abdomen) {
                  switch hitDirection {
                    case 1:
                      hitDirection = 4;
                      break;
                    case 2:
                      hitDirection = 1;
                      break;
                    case 3:
                      hitDirection = 2;
                      break;
                    case 4:
                      hitDirection = 3;
                      break;
                    default:
                      hitDirection = 3;
                  };
                };
                if Equals(hitReactionZone, EHitReactionZone.Abdomen) {
                  switch hitDirection {
                    case 1:
                      hitReactionZone = EHitReactionZone.ChestLeft;
                      break;
                    case 2:
                      hitReactionZone = EHitReactionZone.ChestLeft;
                      break;
                    case 3:
                      hitReactionZone = EHitReactionZone.ChestRight;
                      break;
                    case 4:
                      hitReactionZone = EHitReactionZone.ChestRight;
                      break;
                    default:
                  };
                };
                break;
              case gamedataMeleeAttackDirection.LeftUpToRightDown:
                switch hitDirection {
                  case 1:
                    hitDirection = 4;
                    break;
                  case 2:
                    hitDirection = 1;
                    break;
                  case 3:
                    hitDirection = 2;
                    break;
                  case 4:
                    hitDirection = 3;
                    break;
                  default:
                    hitDirection = 3;
                };
                if Equals(this.m_reactionType, animHitReactionType.Knockdown) || Equals(this.m_hitIntensity, EAIHitIntensity.Heavy) {
                  switch hitDirection {
                    case 1:
                      hitReactionZone = EHitReactionZone.LegLeft;
                      break;
                    case 2:
                      hitReactionZone = EHitReactionZone.LegLeft;
                      break;
                    case 3:
                      hitReactionZone = EHitReactionZone.LegRight;
                      break;
                    case 4:
                      hitReactionZone = EHitReactionZone.LegRight;
                      break;
                    default:
                  };
                };
                if Equals(hitReactionZone, EHitReactionZone.Abdomen) {
                  switch hitDirection {
                    case 1:
                      hitReactionZone = EHitReactionZone.ChestLeft;
                      break;
                    case 2:
                      hitReactionZone = EHitReactionZone.ChestLeft;
                      break;
                    case 3:
                      hitReactionZone = EHitReactionZone.ChestRight;
                      break;
                    case 4:
                      hitReactionZone = EHitReactionZone.ChestRight;
                      break;
                    default:
                  };
                };
                break;
              case gamedataMeleeAttackDirection.RightDownToLeftUp:
                switch hitDirection {
                  case 1:
                    hitDirection = 2;
                    break;
                  case 2:
                    hitDirection = 3;
                    break;
                  case 3:
                    hitDirection = 4;
                    break;
                  case 4:
                    hitDirection = 1;
                    break;
                  default:
                    hitDirection = 1;
                };
                if Equals(hitReactionZone, EHitReactionZone.Abdomen) {
                  switch hitDirection {
                    case 1:
                      hitReactionZone = EHitReactionZone.ChestRight;
                      break;
                    case 2:
                      hitReactionZone = EHitReactionZone.ChestRight;
                      break;
                    case 3:
                      hitReactionZone = EHitReactionZone.ChestLeft;
                      break;
                    case 4:
                      hitReactionZone = EHitReactionZone.ChestLeft;
                      break;
                    default:
                  };
                };
                break;
              case gamedataMeleeAttackDirection.RightToLeft:
                this.m_overridenHitDirection = true;
                switch hitDirection {
                  case 1:
                    hitDirection = 2;
                    break;
                  case 2:
                    hitDirection = 3;
                    break;
                  case 3:
                    hitDirection = 4;
                    break;
                  case 4:
                    hitDirection = 1;
                    break;
                  default:
                    hitDirection = 1;
                };
                if Equals(hitReactionZone, EHitReactionZone.Abdomen) {
                  switch hitDirection {
                    case 1:
                      hitDirection = 2;
                      break;
                    case 2:
                      hitDirection = 3;
                      break;
                    case 3:
                      hitDirection = 4;
                      break;
                    case 4:
                      hitDirection = 1;
                      break;
                    default:
                      hitDirection = 1;
                  };
                };
                if Equals(hitReactionZone, EHitReactionZone.Abdomen) {
                  switch hitDirection {
                    case 1:
                      hitReactionZone = EHitReactionZone.ChestRight;
                      break;
                    case 2:
                      hitReactionZone = EHitReactionZone.ChestRight;
                      break;
                    case 3:
                      hitReactionZone = EHitReactionZone.ChestLeft;
                      break;
                    case 4:
                      hitReactionZone = EHitReactionZone.ChestLeft;
                      break;
                    default:
                  };
                };
                break;
              case gamedataMeleeAttackDirection.RightUpToLeftDown:
                switch hitDirection {
                  case 1:
                    hitDirection = 2;
                    break;
                  case 2:
                    hitDirection = 3;
                    break;
                  case 3:
                    hitDirection = 4;
                    break;
                  case 4:
                    hitDirection = 1;
                    break;
                  default:
                    hitDirection = 1;
                };
                if Equals(this.m_reactionType, animHitReactionType.Knockdown) || Equals(this.m_hitIntensity, EAIHitIntensity.Heavy) {
                  switch hitDirection {
                    case 1:
                      hitReactionZone = EHitReactionZone.LegRight;
                      break;
                    case 2:
                      hitReactionZone = EHitReactionZone.LegRight;
                      break;
                    case 3:
                      hitReactionZone = EHitReactionZone.LegLeft;
                      break;
                    case 4:
                      hitReactionZone = EHitReactionZone.LegLeft;
                      break;
                    default:
                  };
                };
                if Equals(hitReactionZone, EHitReactionZone.Abdomen) {
                  switch hitDirection {
                    case 1:
                      hitReactionZone = EHitReactionZone.ChestRight;
                      break;
                    case 2:
                      hitReactionZone = EHitReactionZone.ChestRight;
                      break;
                    case 3:
                      hitReactionZone = EHitReactionZone.ChestLeft;
                      break;
                    case 4:
                      hitReactionZone = EHitReactionZone.ChestLeft;
                      break;
                    default:
                  };
                };
                break;
              default:
                return;
            };
          };
        } else {
          this.m_animVariation = RandRange(0, 3);
        };
      };
    };
  }

  protected final func StoreHitData(attackAngle: Int32, hitSeverity: EAIHitIntensity, reactionType: animHitReactionType, bodyPart: EHitReactionZone, variation: Int32) -> Void {
    let scriptStoredHitData: ScriptHitData;
    if attackAngle != 0 {
      this.m_animHitReaction.hitDirection = attackAngle;
    } else {
      this.m_animHitReaction.hitDirection = 4;
    };
    if !this.m_attackData.GetInstigator().IsPlayer() {
      if Equals(this.m_hitShapeData.hitShapeName, n"ChestLeft") || Equals(this.m_hitShapeData.hitShapeName, n"ChestRight") || Equals(this.m_hitShapeData.hitShapeName, n"Abdomen") {
        this.m_hitShapeData.hitShapeName = n"Head";
      };
    };
    this.m_animHitReaction.hitIntensity = EnumInt(hitSeverity);
    this.SetHitReactionType(reactionType);
    this.m_animHitReaction.animVariation = variation;
    if this.IsStrongExplosion(this.m_attackData) {
      this.m_animHitReaction.hitBodyPart = 4;
    } else {
      this.m_animHitReaction.hitBodyPart = this.ReactionZoneEnumToBodyPartID(bodyPart);
    };
    if this.m_deathRegisteredTime == 0.00 && Equals(reactionType, animHitReactionType.Death) && !this.m_deathHasBeenPlayed {
      this.m_deathRegisteredTime = this.GetCurrentTime();
      this.m_extendedDeathDelayRegisteredTime = EngineTime.ToFloat(this.GetEngineTime());
    };
    if NotEquals(reactionType, animHitReactionType.Twitch) {
      this.m_lastAnimHitReaction.hitBodyPart = this.m_animHitReaction.hitBodyPart;
      this.m_lastAnimHitReaction.hitDirection = this.m_animHitReaction.hitDirection;
      this.m_lastAnimHitReaction.hitType = this.m_animHitReaction.hitType;
      this.m_lastAnimHitReaction.stance = this.m_animHitReaction.stance;
      this.m_lastAnimHitReaction.hitIntensity = this.m_animHitReaction.hitIntensity;
      this.m_lastAnimHitReaction.animVariation = this.m_animHitReaction.animVariation;
      this.m_lastAnimHitReaction.hitSource = this.m_animHitReaction.hitSource;
      this.m_lastAnimHitReaction.useInitialRotation = this.m_animHitReaction.useInitialRotation;
      if AttackData.IsLightMelee(this.m_attackData.GetAttackType()) || AttackData.IsStrongMelee(this.m_attackData.GetAttackType()) {
        this.m_meleeHitCount += 1;
        if AttackData.IsStrongMelee(this.m_attackData.GetAttackType()) {
          this.m_strongMeleeHitCount += 1;
        };
      } else {
        this.m_meleeHitCount = 0;
        this.m_strongMeleeHitCount = 0;
      };
    };
    this.SetHitStimEvent(this.m_animHitReaction);
    if ArraySize(this.m_previousAnimHitReactionArray) > 3 {
      ArrayErase(this.m_previousAnimHitReactionArray, 0);
    };
    scriptStoredHitData.animVariation = this.m_animHitReaction.animVariation;
    scriptStoredHitData.attackDirection = EnumInt((this.m_attackData.GetAttackDefinition().GetRecord() as Attack_Melee_Record).AttackDirection().Direction().Type());
    this.m_attackDirectionToInt = scriptStoredHitData.attackDirection;
    scriptStoredHitData.hitBodyPart = this.m_animHitReaction.hitBodyPart;
    ArrayPush(this.m_previousAnimHitReactionArray, scriptStoredHitData);
  }

  protected final func SendTwitchDataToAnimationGraph() -> Void {
    this.m_reactionType = animHitReactionType.Twitch;
    this.SetHitReactionType(this.m_reactionType);
    if this.m_animHitReaction.animVariation >= 3 {
      this.m_animHitReaction.animVariation = RandRange(0, 3);
    };
    AnimationControllerComponent.ApplyFeatureToReplicate(this.GetOwner(), n"hit", this.m_animHitReaction);
    AnimationControllerComponent.PushEventToReplicate(this.GetOwner(), n"hit");
  }

  protected final func SendTwitchDataToPlayerAnimationGraph(playerObject: wref<GameObject>) -> Void {
    this.SetHitReactionType(animHitReactionType.Twitch);
    AnimationControllerComponent.ApplyFeatureToReplicate(playerObject, n"hit", this.m_animHitReaction);
    AnimationControllerComponent.PushEventToReplicate(playerObject, n"hit");
  }

  private final func SetHitStimEvent(hitData: ref<AnimFeature_HitReactionsData>) -> Void {
    this.m_hitReactionData = hitData;
  }

  public final const func GetHitStimEvent() -> ref<AnimFeature_HitReactionsData> {
    return this.m_hitReactionData;
  }

  public final const func GetLastHitTimeStamp() -> Float {
    if this.m_previousMeleeHitTimeStamp > this.m_previousHitTime {
      return this.m_previousMeleeHitTimeStamp;
    };
    return this.m_previousHitTime;
  }

  protected cb func OnClearHitStimEvent(evt: ref<ClearHitStimEvent>) -> Bool {
    this.m_hitReactionData = null;
  }

  public final static func ClearHitStim(obj: ref<GameObject>) -> Void {
    let evt: ref<ClearHitStimEvent> = new ClearHitStimEvent();
    obj.QueueEvent(evt);
  }
}
