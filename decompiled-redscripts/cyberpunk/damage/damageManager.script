
public class DamageManager extends IScriptable {

  public final static func ModifyHitData(hitEvent: ref<gameHitEvent>) -> Void {
    let chargeVal: Float;
    let attackData: ref<AttackData> = hitEvent.attackData;
    let statusEffectsSystem: ref<StatusEffectSystem> = GameInstance.GetStatusEffectSystem(hitEvent.target.GetGame());
    let statPoolSystem: ref<StatPoolsSystem> = GameInstance.GetStatPoolsSystem(hitEvent.target.GetGame());
    let ownerStatsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(attackData.GetInstigator().GetGame());
    let attackType: gamedataAttackType = attackData.GetAttackType();
    if !IsDefined(DamageManager.GetScriptedPuppetTarget(hitEvent)) {
      return;
    };
    if ArraySize(hitEvent.hitRepresentationResult.hitShapes) > 0 && DamageSystemHelper.IsProtectionLayer(DamageSystemHelper.GetHitShape(hitEvent)) {
      if !(Equals(attackData.GetAttackType(), gamedataAttackType.Hack) && DamageSystemHelper.DoQuickHacksPierceProtection(DamageSystemHelper.GetHitShape(hitEvent))) {
        attackData.AddFlag(hitFlag.DamageNullified, n"ProtectionLayer");
      };
    };
    if IsDefined(attackData.GetWeapon()) && GameInstance.GetStatsSystem(hitEvent.target.GetGame()).GetStatValue(Cast<StatsObjectID>(attackData.GetWeapon().GetEntityID()), gamedataStatType.CanSilentKill) > 0.00 {
      attackData.AddFlag(hitFlag.SilentKillModifier, n"CanSilentKill");
    };
    if attackData.GetInstigator().IsPlayer() {
      if !AttackData.IsPlayerInCombat(attackData) {
        attackData.AddFlag(hitFlag.StealthHit, n"Player attacked from out of combat");
      };
    };
    if AttackData.IsRangedOrDirect(attackType) || AttackData.IsMelee(attackType) || AttackData.IsStrongMelee(attackType) {
      if ownerStatsSystem.GetStatValue(Cast<StatsObjectID>(attackData.GetInstigator().GetEntityID()), gamedataStatType.CanForceDismbember) > 0.00 {
        attackData.AddFlag(hitFlag.ForceDismember, n"CanForceDismbember ability");
      };
      if !hitEvent.target.IsPlayer() && ownerStatsSystem.GetStatValue(Cast<StatsObjectID>(attackData.GetInstigator().GetEntityID()), gamedataStatType.CanInstaKillNPCs) > 0.00 {
        attackData.AddFlag(hitFlag.Kill, n"CanInstaKillNPCs ability");
      };
    };
    if statusEffectsSystem.HasStatusEffect(hitEvent.target.GetEntityID(), t"BaseStatusEffect.Defeated") {
      attackData.AddFlag(hitFlag.Defeated, n"Defeated");
    };
    if statPoolSystem.HasActiveStatPool(Cast<StatsObjectID>(attackData.GetWeapon().GetEntityID()), gamedataStatPoolType.WeaponCharge) {
      chargeVal = statPoolSystem.GetStatPoolValue(Cast<StatsObjectID>(attackData.GetWeapon().GetEntityID()), gamedataStatPoolType.WeaponCharge, false);
      if Equals(RPGManager.GetWeaponEvolution(attackData.GetWeapon().GetItemID()), gamedataWeaponEvolution.Tech) && chargeVal >= attackData.GetWeapon().GetMaxChargeTreshold() {
        attackData.AddFlag(hitFlag.WeaponFullyCharged, n"Charge Weapon");
      } else {
        if chargeVal >= 100.00 {
          attackData.AddFlag(hitFlag.WeaponFullyCharged, n"Charge Weapon");
        };
      };
    };
    if !AttackData.IsExplosion(attackType) {
      DamageManager.ProcessDefensiveState(hitEvent);
    };
    if hitEvent.target.IsPlayer() && GameInstance.GetStatPoolsSystem(hitEvent.target.GetGame()).HasStatPoolValueReachedMin(Cast<StatsObjectID>(hitEvent.target.GetEntityID()), gamedataStatPoolType.SandevistanCharge) {
      StatusEffectHelper.RemoveStatusEffect(hitEvent.target, t"BaseStatusEffect.NoSandevistanGlitch");
      StatusEffectHelper.RemoveStatusEffect(hitEvent.target, t"BaseStatusEffect.NoCooldownedSandevistanGlitch");
    };
    return;
  }

  public final static func IsValidDirectionToDefendMeleeAttack(attackerForward: Vector4, defenderForward: Vector4, opt kerenzikov: Bool) -> Bool {
    let angle: Float = Vector4.GetAngleBetween(attackerForward, defenderForward);
    let meleeMaxDefendAngle: Float = kerenzikov ? TweakDBInterface.GetFloat(t"player.melee.meleeMaxDefendAngleKerenzikov", 90.00) : TweakDBInterface.GetFloat(t"player.melee.meleeMaxDefendAngle", 45.00);
    if angle <= 180.00 && angle > 180.00 - meleeMaxDefendAngle {
      return true;
    };
    return false;
  }

  private final static func CanBlockBullet(hitEvent: ref<gameHitEvent>) -> Bool {
    let cameraForward: Vector4;
    let defenderWeapon: ref<WeaponObject> = GameObject.GetActiveWeapon(hitEvent.target);
    if !IsDefined(defenderWeapon) {
      return false;
    };
    if !defenderWeapon.IsBlade() {
      return false;
    };
    if !AttackData.IsRangedOnly(hitEvent.attackData.GetAttackType()) {
      return false;
    };
    if PlayerDevelopmentSystem.GetData(hitEvent.target).IsNewPerkBought(gamedataNewPerkType.Reflexes_Right_Milestone_2) < 2 {
      return false;
    };
    cameraForward = GameInstance.GetCameraSystem(hitEvent.target.GetGame()).GetActiveCameraForward();
    if !DamageManager.IsValidDirectionToDefendMeleeAttack(hitEvent.hitDirection, cameraForward) {
      return false;
    };
    if AbsF(Vector4.GetAngleDegAroundAxis(hitEvent.target.GetWorldForward(), cameraForward, hitEvent.target.GetWorldUp())) > TweakDBInterface.GetFloat(t"player.melee.maxLookbackDefendAngle", 150.00) {
      return false;
    };
    return true;
  }

  private final static func ProcessDefensiveState(hitEvent: ref<gameHitEvent>) -> Void {
    let attackType: gamedataAttackType;
    let hasStaminaToDeflect: Bool;
    let meleeAttackRecord: ref<Attack_Melee_Record>;
    let totalStamina: Float;
    let attackData: ref<AttackData> = hitEvent.attackData;
    let targetID: StatsObjectID = Cast<StatsObjectID>(hitEvent.target.GetEntityID());
    let targetPuppet: wref<ScriptedPuppet> = hitEvent.target as ScriptedPuppet;
    let aiComponent: ref<AIHumanComponent> = targetPuppet.GetAIControllerComponent();
    let hitReactionComponent: ref<HitReactionComponent> = targetPuppet.GetHitReactionComponent();
    let statSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(hitEvent.target.GetGame());
    let hitAIEvent: ref<AIEvent> = new AIEvent();
    let instigator: wref<GameObject> = attackData.GetInstigator();
    let currentStamina: Float = GameInstance.GetStatPoolsSystem(targetPuppet.GetGame()).GetStatPoolValue(targetID, gamedataStatPoolType.Stamina, false);
    let dodgingWithKerenzikov: Bool = !targetPuppet.IsPlayer() && IsDefined(hitReactionComponent) && hitReactionComponent.GetHasKerenzikov() && !hitReactionComponent.GetCanBlock();
    let dodgingFromAnyDirection: Bool = dodgingWithKerenzikov && StatusEffectSystem.ObjectHasStatusEffect(targetPuppet, t"BaseStatusEffect.ForceAllowAnyDirectionDodge");
    if AttackData.IsMelee(hitEvent.attackData.GetAttackType()) && (dodgingFromAnyDirection || DamageManager.IsValidDirectionToDefendMeleeAttack(instigator.GetWorldForward(), hitEvent.target.GetWorldForward(), dodgingWithKerenzikov)) {
      attackType = attackData.GetAttackType();
      meleeAttackRecord = attackData.GetAttackDefinition().GetRecord() as Attack_Melee_Record;
      if statSystem.GetStatValue(targetID, gamedataStatType.IsDeflecting) == 1.00 && NotEquals(attackType, gamedataAttackType.QuickMelee) && (targetPuppet.IsPlayer() || aiComponent.GetActionBlackboard().GetBool(GetAllBlackboardDefs().AIAction.attackParried)) {
        attackData.AddFlag(hitFlag.WasDeflected, n"Parry");
        attackData.AddFlag(hitFlag.DontShowDamageFloater, n"Parry");
        AnimationControllerComponent.PushEvent(instigator, n"myAttackParried");
        hitAIEvent.name = n"MyAttackParried";
        instigator.QueueEvent(hitAIEvent);
        if hitEvent.target.IsPlayer() {
          DamageManager.SendNameEventToPSM(n"successfulDeflect", hitEvent);
        };
      } else {
        if aiComponent.GetActionBlackboard().GetBool(GetAllBlackboardDefs().AIAction.attackBlocked) || targetPuppet.IsPlayer() && (statSystem.GetStatValue(targetID, gamedataStatType.IsBlocking) == 1.00 && IsDefined(meleeAttackRecord) && !meleeAttackRecord.CanSkipBlock() || statSystem.GetStatValue(targetID, gamedataStatType.IsDeflecting) == 1.00 && Equals(attackType, gamedataAttackType.QuickMelee)) {
          attackData.AddFlag(hitFlag.WasBlocked, n"Block");
          attackData.AddFlag(hitFlag.DontShowDamageFloater, n"Block");
          AnimationControllerComponent.PushEvent(instigator, n"myAttackBlocked");
          ScriptedPuppet.SendActionSignal(instigator as NPCPuppet, n"BlockSignal", 0.30);
          hitAIEvent.name = n"MyAttackBlocked";
          instigator.QueueEvent(hitAIEvent);
          DamageManager.DealStaminaDamage(hitEvent, targetID, statSystem);
        } else {
          ScriptedPuppet.SendActionSignal(instigator as NPCPuppet, n"HitSignal", 0.30);
          hitAIEvent.name = n"MyAttackHit";
          instigator.QueueEvent(hitAIEvent);
        };
      };
    } else {
      if currentStamina > 0.00 && DamageManager.CanBlockBullet(hitEvent) {
        if statSystem.GetStatValue(targetID, gamedataStatType.IsBlocking) == 1.00 || statSystem.GetStatValue(targetID, gamedataStatType.IsDeflecting) == 1.00 {
          totalStamina = GameInstance.GetStatsSystem(targetPuppet.GetGame()).GetStatValue(targetID, gamedataStatType.Stamina);
          hasStaminaToDeflect = currentStamina > totalStamina * statSystem.GetStatValue(targetID, gamedataStatType.Reflexes_Right_Milestone_2_StaminaDeflectPerc);
          if PlayerDevelopmentSystem.GetData(hitEvent.target).IsNewPerkBought(gamedataNewPerkType.Reflexes_Right_Perk_2_1) > 0 && hasStaminaToDeflect {
            if statSystem.GetStatValue(targetID, gamedataStatType.IsBlocking) == 1.00 {
              attackData.AddFlag(hitFlag.WasBulletDeflected, n"BulletDeflect");
            } else {
              if statSystem.GetStatValue(targetID, gamedataStatType.IsDeflecting) == 1.00 {
                attackData.AddFlag(hitFlag.WasBulletParried, n"BulletParry");
              };
            };
            attackData.AddFlag(hitFlag.DontShowDamageFloater, n"BulletDeflect");
          } else {
            attackData.AddFlag(hitFlag.WasBlocked, n"BulletBlock");
            attackData.AddFlag(hitFlag.WasBulletBlocked, n"BulletBlock");
            attackData.AddFlag(hitFlag.DontShowDamageFloater, n"BulletBlock");
            AnimationControllerComponent.PushEvent(instigator, n"myAttackBlocked");
            ScriptedPuppet.SendActionSignal(instigator as NPCPuppet, n"BlockSignal", 0.30);
            hitAIEvent.name = n"MyAttackBlocked";
            instigator.QueueEvent(hitAIEvent);
            DamageManager.DealStaminaDamage(hitEvent, targetID, statSystem);
          };
        } else {
          ScriptedPuppet.SendActionSignal(instigator as NPCPuppet, n"HitSignal", 0.30);
          hitAIEvent.name = n"MyAttackHit";
          instigator.QueueEvent(hitAIEvent);
        };
      } else {
        ScriptedPuppet.SendActionSignal(instigator as NPCPuppet, n"HitSignal", 0.30);
        hitAIEvent.name = n"MyAttackHit";
        instigator.QueueEvent(hitAIEvent);
      };
    };
  }

  protected final static func SendNameEventToPSM(eventName: CName, hitEvent: ref<gameHitEvent>) -> Void {
    let player: ref<PlayerPuppet> = hitEvent.target as PlayerPuppet;
    let es: ref<EquipmentSystem> = GameInstance.GetScriptableSystemsContainer(player.GetGame()).Get(n"EquipmentSystem") as EquipmentSystem;
    let playerWeapon: ref<ItemObject> = es.GetActiveWeaponObject(player, gamedataEquipmentArea.Weapon);
    let psmEvent: ref<PSMPostponedParameterBool> = new PSMPostponedParameterBool();
    psmEvent.id = eventName;
    psmEvent.value = true;
    player.QueueEvent(psmEvent);
    player.QueueEventForEntityID(playerWeapon.GetEntityID(), psmEvent);
  }

  public final static func PostProcess(hitEvent: ref<gameHitEvent>) -> Void;

  public final static func CalculateSourceModifiers(hitEvent: ref<gameHitEvent>) -> Void {
    let tempStat: Float;
    let targetPuppet: ref<ScriptedPuppet> = hitEvent.target as ScriptedPuppet;
    let instigator: ref<GameObject> = hitEvent.attackData.GetInstigator();
    if targetPuppet.IsMechanical() || targetPuppet.IsTurret() {
      tempStat = StatsSystemHelper.GetStatValue(instigator, gamedataStatType.BonusDamageAgainstMechanicals);
      if !FloatIsEqual(tempStat, 0.00) {
        hitEvent.attackComputed.MultAttackValue(1.00 + tempStat);
      };
    };
    if Equals(targetPuppet.GetNPCRarity(), gamedataNPCRarity.Boss) || Equals(targetPuppet.GetNPCRarity(), gamedataNPCRarity.MaxTac) {
      tempStat = StatsSystemHelper.GetStatValue(instigator, gamedataStatType.BonusDamageAgainstBosses);
      if !FloatIsEqual(tempStat, 0.00) {
        hitEvent.attackComputed.MultAttackValue(1.00 + tempStat * 0.01);
      };
    };
    if instigator.IsPlayer() {
      if Equals(targetPuppet.GetNPCRarity(), gamedataNPCRarity.Elite) {
        tempStat = StatsSystemHelper.GetStatValue(instigator, gamedataStatType.BonusDamageAgainstElites);
        if !FloatIsEqual(tempStat, 0.00) {
          hitEvent.attackComputed.MultAttackValue(1.00 + tempStat * 0.01);
        };
      } else {
        if Equals(targetPuppet.GetNPCRarity(), gamedataNPCRarity.Rare) {
          tempStat = StatsSystemHelper.GetStatValue(instigator, gamedataStatType.BonusDamageAgainstRares);
          if !FloatIsEqual(tempStat, 0.00) {
            hitEvent.attackComputed.MultAttackValue(1.00 + tempStat * 0.01);
          };
        };
      };
      if AttackData.IsMelee(hitEvent.attackData.GetAttackType()) && StatusEffectSystem.ObjectHasStatusEffect(instigator, t"BaseStatusEffect.BerserkPlayerBuff") {
        tempStat = StatsSystemHelper.GetStatValue(instigator, gamedataStatType.BerserkMeleeDamageBonus);
        if !FloatIsEqual(tempStat, 0.00) {
          hitEvent.attackComputed.MultAttackValue(1.00 + tempStat * 0.01);
        };
      };
    };
  }

  public final static func CalculateTargetModifiers(hitEvent: ref<gameHitEvent>) -> Void {
    let tempStat: Float;
    let attackType: gamedataAttackType = hitEvent.attackData.GetAttackType();
    if AttackData.IsExplosion(attackType) || hitEvent.attackData.HasFlag(hitFlag.BreachExplosion) {
      tempStat = StatsSystemHelper.GetStatValue(hitEvent.target, gamedataStatType.DamageReductionExplosion);
      if !FloatIsEqual(tempStat, 0.00) {
        hitEvent.attackComputed.MultAttackValue(1.00 - tempStat);
      };
    };
    if hitEvent.attackData.HasFlag(hitFlag.BulletExplosion) {
      tempStat = StatsSystemHelper.GetStatValue(hitEvent.target, gamedataStatType.DamageReductionBulletExplosion);
      if !FloatIsEqual(tempStat, 0.00) {
        hitEvent.attackComputed.MultAttackValue(1.00 - tempStat);
        if tempStat == 1.00 {
          hitEvent.attackData.AddFlag(hitFlag.DontShowDamageFloater, n"BulletExplosionInvulnerability");
        };
      };
    };
    if AttackData.IsDoT(hitEvent.attackData) {
      tempStat = StatsSystemHelper.GetStatValue(hitEvent.target, gamedataStatType.DamageReductionDamageOverTime);
      if !FloatIsEqual(tempStat, 0.00) {
        hitEvent.attackComputed.MultAttackValue(1.00 - tempStat);
      };
    };
    if AttackData.IsMelee(attackType) {
      tempStat = StatsSystemHelper.GetStatValue(hitEvent.target, gamedataStatType.DamageReductionMelee);
      if !FloatIsEqual(tempStat, 0.00) {
        hitEvent.attackComputed.MultAttackValue(1.00 - tempStat / 100.00);
      };
    };
    if AttackData.IsHack(attackType) {
      tempStat = StatsSystemHelper.GetStatValue(hitEvent.target, gamedataStatType.DamageReductionQuickhacks);
      if !FloatIsEqual(tempStat, 0.00) {
        hitEvent.attackComputed.MultAttackValue(1.00 - tempStat / 100.00);
      };
    };
  }

  public final static func CalculateGlobalModifiers(hitEvent: ref<gameHitEvent>) -> Void;

  private final static func GetScriptedPuppetTarget(hitEvent: ref<gameHitEvent>) -> ref<ScriptedPuppet> {
    return hitEvent.target as ScriptedPuppet;
  }

  protected final static func DealStaminaDamage(hitEvent: ref<gameHitEvent>, targetID: StatsObjectID, statSystem: ref<StatsSystem>) -> Void {
    let weapon: ref<WeaponObject> = hitEvent.attackData.GetWeapon();
    let staminaDamageValue: Float = statSystem.GetStatValue(Cast<StatsObjectID>(weapon.GetEntityID()), gamedataStatType.StaminaDamage);
    GameInstance.GetStatPoolsSystem(hitEvent.target.GetGame()).RequestChangingStatPoolValue(targetID, gamedataStatPoolType.Stamina, -staminaDamageValue, hitEvent.attackData.GetInstigator(), false, false);
  }
}
