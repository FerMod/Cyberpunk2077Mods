
public class GrappleInteractionCondition extends InteractionScriptedCondition {

  public final const func Test(const activatorObject: wref<GameObject>, const hotSpotObject: wref<GameObject>) -> Bool {
    return this.IsAreaBetweenPlayerAndVictim(activatorObject, hotSpotObject);
  }

  protected final const func IsAreaBetweenPlayerAndVictim(const activatorObject: wref<GameObject>, const hotSpotObject: wref<GameObject>) -> Bool {
    let maxGrabDistOverCover: Float = 1.30;
    let toHotSpot: Vector4 = hotSpotObject.GetWorldPosition() - activatorObject.GetWorldPosition();
    let distanceFromHotspot: Float = Vector4.Length2D(toHotSpot);
    let behindCoverHeightDifferenceLockout: Float = -0.50;
    if !SpatialQueriesHelper.HasSpaceInFront(activatorObject, toHotSpot, 1.30, 0.50, distanceFromHotspot, 0.40) {
      return false;
    };
    if toHotSpot.Z < behindCoverHeightDifferenceLockout && !SpatialQueriesHelper.HasSpaceInFront(activatorObject, toHotSpot, 0.60, 0.50, distanceFromHotspot, 0.70) {
      return false;
    };
    if distanceFromHotspot < maxGrabDistOverCover {
      return true;
    };
    return SpatialQueriesHelper.HasSpaceInFront(hotSpotObject, toHotSpot * -1.00, 0.60, 0.50, distanceFromHotspot - maxGrabDistOverCover, 1.10);
  }
}

public class NewPerkFinisherCondition extends InteractionScriptedCondition {

  public final const func Test(const activatorObject: wref<GameObject>, const hotSpotObject: wref<GameObject>) -> Bool {
    let choiceData: DialogChoiceHubs;
    let eMeleeWeaponState: gamePSMMeleeWeapon;
    let gameInstance: GameInstance;
    let interactionData: ref<UIInteractionsDef>;
    let interactonsBlackboard: ref<IBlackboard>;
    let npcTarget: ref<NPCPuppet>;
    let psmBlackBoard: ref<IBlackboard>;
    let result: Bool;
    let tags: array<CName>;
    let targetPuppet: wref<ScriptedPuppet>;
    let weaponRecord: ref<Item_Record>;
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(activatorObject.GetGame());
    let equippedWeapon: ref<WeaponObject> = GameObject.GetActiveWeapon(activatorObject);
    if !equippedWeapon.IsMelee() {
      return false;
    };
    weaponRecord = TweakDBInterface.GetWeaponItemRecord(ItemID.GetTDBID(equippedWeapon.GetItemID()));
    tags = weaponRecord.Tags();
    if !ArrayContains(tags, n"FinisherFront") && !ArrayContains(tags, n"FinisherBack") {
      return false;
    };
    targetPuppet = hotSpotObject as ScriptedPuppet;
    if !IsDefined(targetPuppet) {
      return false;
    };
    if targetPuppet.IsCrowd() || targetPuppet.IsCharacterCivilian() {
      return false;
    };
    if !ScriptedPuppet.IsActive(targetPuppet) {
      return false;
    };
    if StatusEffectSystem.ObjectHasStatusEffect(activatorObject, t"GameplayRestriction.FistFight") {
      return false;
    };
    gameInstance = activatorObject.GetGame();
    if GameInstance.GetGodModeSystem(gameInstance).HasGodMode(targetPuppet.GetEntityID(), gameGodModeType.Immortal) {
      return false;
    };
    if GameInstance.GetGodModeSystem(gameInstance).HasGodMode(targetPuppet.GetEntityID(), gameGodModeType.Invulnerable) {
      return false;
    };
    if GameInstance.GetMountingFacility(gameInstance).IsMountedToAnything(activatorObject.GetEntityID()) {
      return false;
    };
    if GameInstance.GetMountingFacility(gameInstance).IsMountedToAnything(targetPuppet.GetEntityID()) {
      return false;
    };
    interactonsBlackboard = GameInstance.GetBlackboardSystem(gameInstance).Get(GetAllBlackboardDefs().UIInteractions);
    interactionData = GetAllBlackboardDefs().UIInteractions;
    choiceData = FromVariant<DialogChoiceHubs>(interactonsBlackboard.GetVariant(interactionData.DialogChoiceHubs));
    if ArraySize(choiceData.choiceHubs) > 0 {
      return false;
    };
    psmBlackBoard = GameInstance.GetBlackboardSystem(gameInstance).GetLocalInstanced(activatorObject.GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    eMeleeWeaponState = IntEnum<gamePSMMeleeWeapon>(psmBlackBoard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.MeleeWeapon));
    if Equals(eMeleeWeaponState, gamePSMMeleeWeapon.NotReady) {
      return false;
    };
    if Equals(eMeleeWeaponState, gamePSMMeleeWeapon.StrongAttack) {
      return false;
    };
    npcTarget = hotSpotObject as NPCPuppet;
    if IsDefined(npcTarget) && npcTarget.IsAboutToDieOrDefeated() {
      return false;
    };
    if equippedWeapon.IsBlunt() && statsSystem.GetStatBoolValue(Cast<StatsObjectID>(activatorObject.GetEntityID()), gamedataStatType.CanPerformBluntFinisher) {
      result = this.IsFinisherAvailable(activatorObject, hotSpotObject) && this.NewPerkFinisherBluntEnabled(activatorObject, hotSpotObject, equippedWeapon);
    } else {
      if equippedWeapon.IsThrowable() && statsSystem.GetStatBoolValue(Cast<StatsObjectID>(activatorObject.GetEntityID()), gamedataStatType.CanPerformCoolFinisher) {
        result = this.IsFinisherAvailable(activatorObject, hotSpotObject) && this.NewPerkFinisherThrowableEnabled(activatorObject, hotSpotObject, equippedWeapon);
      } else {
        if equippedWeapon.IsBlade() && statsSystem.GetStatBoolValue(Cast<StatsObjectID>(activatorObject.GetEntityID()), gamedataStatType.CanPerformReflexFinisher) {
          result = this.IsFinisherAvailable(activatorObject, hotSpotObject) && this.NewPerkFinisherBladeEnabled(activatorObject, hotSpotObject, equippedWeapon);
        } else {
          if equippedWeapon.IsMonowire() && statsSystem.GetStatBoolValue(Cast<StatsObjectID>(activatorObject.GetEntityID()), gamedataStatType.CanPerformMonowireFinisher) {
            result = this.IsFinisherAvailable(activatorObject, hotSpotObject) && this.NewPerkFinisherMonowireEnabled(activatorObject, hotSpotObject, equippedWeapon);
          } else {
            return false;
          };
        };
      };
    };
    if !result {
      return false;
    };
    if !targetPuppet.IsFinisherSoundPlayed() && !hotSpotObject.GetIsInFastFinisher() {
      GameObject.PlaySound(activatorObject, n"w_melee_perk_finisher_ready");
      targetPuppet.SetFinisherSoundPlayed(true);
    };
    return this.IsAreaClear(activatorObject, hotSpotObject);
  }

  private final const func IsFinisherAvailable(const activatorObject: wref<GameObject>, const hotSpotObject: wref<GameObject>) -> Bool {
    let isInPoiseState: Bool = StatusEffectSystem.ObjectHasStatusEffect(hotSpotObject, t"BaseStatusEffect.FinisherActiveStatusEffect");
    let isInThreshold: Bool = hotSpotObject.IsInFinisherHealthThreshold(activatorObject);
    if !isInPoiseState && !isInThreshold {
      return false;
    };
    return true;
  }

  protected final const func NewPerkFinisherBladeEnabled(const activatorObject: wref<GameObject>, const hotSpotObject: wref<GameObject>, equippedWeapon: ref<WeaponObject>) -> Bool {
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(activatorObject.GetGame());
    let distanceFromHotspot: Float = Vector4.Length2D(hotSpotObject.GetWorldPosition() - activatorObject.GetWorldPosition());
    let minDistance: Float = statsSystem.GetStatValue(Cast<StatsObjectID>(activatorObject.GetEntityID()), gamedataStatType.NewPerkFinisherReflexes_TargetDistanceMax);
    if PlayerDevelopmentSystem.GetData(activatorObject).IsNewPerkBoughtAnyLevel(gamedataNewPerkType.Reflexes_Right_Perk_3_4) {
      minDistance *= TweakDBInterface.GetFloat(t"NewPerks.Reflexes_Right_Perk_3_4.distanceMult", 2.00);
    };
    return distanceFromHotspot < minDistance;
  }

  protected final const func NewPerkFinisherThrowableEnabled(const activatorObject: wref<GameObject>, const hotSpotObject: wref<GameObject>, equippedWeapon: ref<WeaponObject>) -> Bool {
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(activatorObject.GetGame());
    let distanceFromHotspot: Float = Vector4.Length2D(hotSpotObject.GetWorldPosition() - activatorObject.GetWorldPosition());
    let minDistance: Float = statsSystem.GetStatValue(Cast<StatsObjectID>(activatorObject.GetEntityID()), gamedataStatType.NewPerkFinisherCool_TargetDistanceMax);
    minDistance += TweakDBInterface.GetFloat(t"NewPerks.Cool_Inbetween_Right_3.distanceBase", 5.00) * ClampF(GameInstance.GetStatsSystem(hotSpotObject.GetGame()).GetStatValue(Cast<StatsObjectID>(hotSpotObject.GetEntityID()), gamedataStatType.Cool_Inbetween_Right_3_Stacks), 0.00, TweakDBInterface.GetFloat(t"NewPerks.Cool_Inbetween_Right_3.distanceMaxStacks", 3.00));
    if distanceFromHotspot > minDistance {
      return false;
    };
    return true;
  }

  protected final const func NewPerkFinisherMonowireEnabled(const activatorObject: wref<GameObject>, const hotSpotObject: wref<GameObject>, equippedWeapon: ref<WeaponObject>) -> Bool {
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(activatorObject.GetGame());
    let distanceFromHotspot: Float = Vector4.Length2D(hotSpotObject.GetWorldPosition() - activatorObject.GetWorldPosition());
    let minDistance: Float = statsSystem.GetStatValue(Cast<StatsObjectID>(activatorObject.GetEntityID()), gamedataStatType.NewPerkFinisherMonowire_TargetDistanceMax);
    minDistance += TweakDBInterface.GetFloat(t"NewPerks.Reflexes_Right_Perk_3_4.distanceMult", 3.00) * Cast<Float>((hotSpotObject as ScriptedPuppet).GetDeviceActionQueueSize());
    if distanceFromHotspot > minDistance {
      return false;
    };
    return true;
  }

  protected final const func NewPerkFinisherBluntEnabled(const activatorObject: wref<GameObject>, const hotSpotObject: wref<GameObject>, const equippedWeapon: ref<WeaponObject>) -> Bool {
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(activatorObject.GetGame());
    let targetDistanceMax: Float = statsSystem.GetStatValue(Cast<StatsObjectID>(activatorObject.GetEntityID()), gamedataStatType.NewPerkFinisherBlunt_TargetDistanceMax);
    if Vector4.Length2D(hotSpotObject.GetWorldPosition() - activatorObject.GetWorldPosition()) > targetDistanceMax {
      return false;
    };
    return true;
  }

  private final const func IsAreaClear(const activatorObject: wref<GameObject>, const hotSpotObject: wref<GameObject>) -> Bool {
    let distanceFromHotspot: Float;
    let isObstacleVaultable: Bool;
    let toHotSpot: Vector4 = hotSpotObject.GetWorldPosition() - activatorObject.GetWorldPosition();
    let leapAngle: EulerAngles = Vector4.ToRotation(toHotSpot);
    if -leapAngle.Pitch > TDB.GetFloat(t"playerStateMachineFinisher.finisherLeapToTarget.leapMaxPitch") {
      return false;
    };
    distanceFromHotspot = Vector4.Length2D(toHotSpot);
    distanceFromHotspot = MinF(distanceFromHotspot, 1.50);
    if !SpatialQueriesHelper.HasSpaceInFront(activatorObject, toHotSpot, 1.30, 0.50, distanceFromHotspot, 0.40) {
      return false;
    };
    if !GameInstance.GetTargetingSystem(activatorObject.GetGame()).IsVisibleTarget(activatorObject, hotSpotObject) {
      return false;
    };
    return SpatialQueriesHelper.IsTargetReachable(activatorObject, hotSpotObject, hotSpotObject.GetWorldPosition(), true, isObstacleVaultable);
  }
}

public class BlackwallForceInteractionCondition extends InteractionScriptedCondition {

  public final const func Test(const activatorObject: wref<GameObject>, const hotSpotObject: wref<GameObject>) -> Bool {
    return this.CanUseBlackwall(activatorObject, hotSpotObject);
  }

  protected final const func BlackwallForceEnabled(const activatorObject: wref<GameObject>, const hotSpotObject: wref<GameObject>) -> Bool {
    let player: ref<PlayerPuppet> = activatorObject as PlayerPuppet;
    return player.IsBlackwallForceEquippedOnPlayer() && !StatusEffectSystem.ObjectHasStatusEffectWithTag(player, n"BlackwallSQCooldown");
  }

  protected final const func TargetMarkedByBlackwall(const activatorObject: wref<GameObject>, const hotSpotObject: wref<GameObject>) -> Bool {
    let target: ref<GameObject> = hotSpotObject;
    return StatusEffectSystem.ObjectHasStatusEffectWithTag(target, n"BlackwallMark");
  }

  protected final const func CanUseBlackwall(const activatorObject: wref<GameObject>, const hotSpotObject: wref<GameObject>) -> Bool {
    return this.BlackwallForceEnabled(activatorObject, hotSpotObject) && this.TargetMarkedByBlackwall(activatorObject, hotSpotObject);
  }
}

public class ContainerStateInteractionCondition extends InteractionScriptedCondition {

  public final const func Test(const activatorObject: wref<GameObject>, const hotSpotObject: wref<GameObject>) -> Bool {
    let container: ref<gameLootContainerBase> = hotSpotObject as gameLootContainerBase;
    if IsDefined(container) {
      return !container.IsDisabled();
    };
    return false;
  }
}

public class DeviceDirectInteractionCondition extends InteractionScriptedCondition {

  public final const func Test(const activatorObject: wref<GameObject>, const hotSpotObject: wref<GameObject>) -> Bool {
    return (hotSpotObject as Device).IsDirectInteractionCondition();
  }
}

public class IsPlayerNotInteractingWithDevice extends InteractionScriptedCondition {

  public final const func Test(const activatorObject: wref<GameObject>, const hotSpotObject: wref<GameObject>) -> Bool {
    let player: ref<PlayerPuppet> = activatorObject as PlayerPuppet;
    let result: Bool = !player.GetPlayerStateMachineBlackboard().GetBool(GetAllBlackboardDefs().PlayerStateMachine.IsInteractingWithDevice);
    return result;
  }
}

public class DeviceRemoteInteractionCondition extends InteractionScriptedCondition {

  public final const func Test(const activatorObject: wref<GameObject>, const hotSpotObject: wref<GameObject>) -> Bool {
    if !this.IsScannerTarget(hotSpotObject) && !this.IsLookaAtTarget(activatorObject, hotSpotObject) {
      return false;
    };
    return this.ShouldEnableLayer(hotSpotObject);
  }

  private final const func IsScannerTarget(const hotSpotObject: wref<GameObject>) -> Bool {
    let blackBoard: ref<IBlackboard> = GameInstance.GetBlackboardSystem(hotSpotObject.GetGame()).Get(GetAllBlackboardDefs().UI_Scanner);
    let entityID: EntityID = blackBoard.GetEntityID(GetAllBlackboardDefs().UI_Scanner.ScannedObject);
    return hotSpotObject.GetEntityID() == entityID;
  }

  private final const func IsLookaAtTarget(const activatorObject: wref<GameObject>, const hotSpotObject: wref<GameObject>) -> Bool {
    return GameInstance.GetInteractionManager(activatorObject.GetGame()).IsInteractionLookAtTarget(activatorObject, hotSpotObject);
  }

  private final const func ShouldEnableLayer(const hotSpotObject: wref<GameObject>) -> Bool {
    if IsDefined(hotSpotObject) {
      return hotSpotObject.ShouldEnableRemoteLayer();
    };
    return false;
  }
}

public class PlayerIsSwimmingCondition extends InteractionScriptedCondition {

  public final const func Test(const activatorObject: wref<GameObject>, const hotSpotObject: wref<GameObject>) -> Bool {
    let player: ref<PlayerPuppet> = activatorObject as PlayerPuppet;
    let result: Bool = player.GetPlayerStateMachineBlackboard().GetInt(GetAllBlackboardDefs().PlayerStateMachine.HighLevel) == 6;
    return result;
  }
}

public class LootPickupScriptedCondition extends InteractionScriptedCondition {

  public final const func Test(const activatorObject: wref<GameObject>, const hotSpotObject: wref<GameObject>) -> Bool {
    let chargeCost: Float;
    let chargeItemCurrentCharge: Float;
    let chargeItemMaxCharge: Float;
    let isGrenade: Bool;
    let isHealingItem: Bool;
    let itemType: gamedataItemType;
    let weaponRecord: ref<WeaponItem_Record>;
    let player: ref<PlayerPuppet> = activatorObject as PlayerPuppet;
    let itemDropObject: ref<gameItemDropObject> = hotSpotObject as gameItemDropObject;
    let itemObject: ref<ItemObject> = itemDropObject.GetItemObject();
    let weaponObject: ref<WeaponObject> = itemObject as WeaponObject;
    if IsDefined(weaponObject) {
      weaponRecord = weaponObject.GetWeaponRecord();
      if Equals(weaponRecord.EquipArea().Type(), gamedataEquipmentArea.WeaponHeavy) {
        if player.GetPlayerStateMachineBlackboard().GetBool(GetAllBlackboardDefs().PlayerStateMachine.Carrying) {
          return false;
        };
      };
    };
    itemType = itemObject.GetItemData().GetItemType();
    isGrenade = Equals(itemType, gamedataItemType.Gad_Grenade);
    isHealingItem = Equals(itemType, gamedataItemType.Con_Inhaler) || Equals(itemType, gamedataItemType.Con_Injector);
    if (isGrenade || isHealingItem) && !itemObject.GetItemData().HasTag(n"ForceRevealConsumable") {
      chargeItemCurrentCharge = GameInstance.GetStatPoolsSystem(player.GetGame()).GetStatPoolValue(Cast<StatsObjectID>(player.GetEntityID()), isGrenade ? gamedataStatPoolType.GrenadesCharges : gamedataStatPoolType.HealingItemsCharges, false);
      chargeItemMaxCharge = GameInstance.GetStatsSystem(player.GetGame()).GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), isGrenade ? gamedataStatType.GrenadesMaxCharges : gamedataStatType.HealingItemMaxCharges);
      chargeCost = Cast<Float>(isGrenade ? player.GetGrenadeThrowCostClean() : player.GetHealingItemUseCost());
      return chargeItemCurrentCharge / chargeCost < chargeItemMaxCharge;
    };
    return true;
  }
}
