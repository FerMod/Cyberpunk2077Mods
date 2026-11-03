
public class StatPoolsManager extends IScriptable {

  public final static func ApplyDamage(hitEvent: ref<gameHitEvent>, forReal: Bool, out valuesLost: [SDamageDealt]) -> Void {
    let asHitDataBase: ref<HitData_Base>;
    let asHitShapeUserDataBase: ref<HitShapeUserDataBase>;
    let attackValues: array<Float>;
    let damageCeiling: Float;
    let dmgType: gamedataDamageType;
    let firstHit: Bool;
    let i: Int32;
    let isProtectionLayer: Bool;
    let j: Int32;
    let maxPercentDamage: Float;
    let npcTarget: wref<NPCPuppet>;
    let poolType: gamedataStatPoolType;
    let projectilesPerShot: Float;
    let statsSystem: ref<StatsSystem>;
    let targetHit: Bool;
    let tempLost: array<SDamageDealt>;
    let hitShapes: array<HitShapeData> = hitEvent.hitRepresentationResult.hitShapes;
    let instigator: wref<GameObject> = hitEvent.attackData.GetInstigator();
    let target: ref<GameObject> = hitEvent.target;
    ArrayClear(valuesLost);
    attackValues = hitEvent.attackComputed.GetAttackValues();
    i = 0;
    while i < ArraySize(attackValues) {
      dmgType = IntEnum<gamedataDamageType>(i);
      statsSystem = GameInstance.GetStatsSystem(target.GetGame());
      maxPercentDamage = statsSystem.GetStatValue(Cast<StatsObjectID>(target.GetEntityID()), gamedataStatType.MaxPercentDamageTakenPerHit);
      npcTarget = target as NPCPuppet;
      if IsDefined(npcTarget) && maxPercentDamage > 0.00 {
        if (npcTarget.IsBoss() || Equals(npcTarget.GetNPCRarity(), gamedataNPCRarity.MaxTac)) && !instigator.GetIsInFastFinisher() {
          projectilesPerShot = statsSystem.GetStatValue(Cast<StatsObjectID>(hitEvent.attackData.GetWeapon().GetEntityID()), gamedataStatType.ProjectilesPerShot);
          if AttackData.IsDoT(hitEvent.attackData) {
            maxPercentDamage *= TweakDBInterface.GetFloat(t"Constants.DamageSystem.maxDamageDoTProportion", 1.00);
          };
          damageCeiling = maxPercentDamage / 100.00 * statsSystem.GetStatValue(Cast<StatsObjectID>(target.GetEntityID()), gamedataStatType.Health);
          if projectilesPerShot > 0.00 {
            damageCeiling /= projectilesPerShot;
          };
          attackValues[i] = ClampF(attackValues[i], 0.00, damageCeiling);
        };
      };
      if attackValues[i] > 0.00 && attackValues[i] < 1.00 {
        attackValues[i] = 1.00;
      };
      firstHit = false;
      j = 0;
      while j < ArraySize(hitShapes) {
        isProtectionLayer = false;
        asHitDataBase = hitShapes[j].userData as HitData_Base;
        asHitShapeUserDataBase = hitShapes[j].userData as HitShapeUserDataBase;
        if IsDefined(asHitDataBase) {
          isProtectionLayer = Equals(asHitDataBase.m_hitShapeType, HitShape_Type.ProtectionLayer);
        } else {
          if IsDefined(asHitShapeUserDataBase) {
            isProtectionLayer = asHitShapeUserDataBase.m_isProtectionLayer && !(Equals(hitEvent.attackData.GetAttackType(), gamedataAttackType.Hack) && asHitShapeUserDataBase.m_quickHacksPierceProtection) && !instigator.GetIsInFastFinisher();
          };
        };
        if !firstHit && !isProtectionLayer {
          firstHit = true;
          targetHit = true;
        };
        if !targetHit && isProtectionLayer && ArraySize(hitShapes) < 12 {
          attackValues[i] = 0.00;
          hitEvent.attackData.RemoveFlag(hitFlag.Headshot);
          hitEvent.attackData.RemoveFlag(hitFlag.CriticalHit);
          hitEvent.attackData.RemoveFlag(hitFlag.BreachHit);
          hitEvent.attackData.SetHitType(gameuiHitType.Glance);
        };
        if IsDefined(asHitDataBase) {
          if StatPoolsManager.GetBodyPartStatPool(target, asHitDataBase.m_bodyPartStatPoolName, poolType) {
            StatPoolsManager.ApplyLocalizedDamageSingle(hitEvent, attackValues[i], dmgType, poolType, forReal, tempLost);
            StatPoolsManager.MergeStatPoolsLost(valuesLost, tempLost);
          };
        };
        j += 1;
      };
      StatPoolsManager.ApplyDamageSingle(hitEvent, dmgType, attackValues[i], forReal, tempLost);
      StatPoolsManager.MergeStatPoolsLost(valuesLost, tempLost);
      i += 1;
    };
    hitEvent.attackComputed.SetAttackValues(attackValues);
  }

  private final static func ApplyLocalizedDamageSingle(hitEvent: ref<gameHitEvent>, dmg: Float, dmgType: gamedataDamageType, poolType: gamedataStatPoolType, forReal: Bool, valuesLost: script_ref<[SDamageDealt]>) -> Void {
    let currentPoolVal: Float;
    let dmgVal: Float;
    let newPool: SDamageDealt;
    let valueToDrain: Float;
    let targetID: StatsObjectID = Cast<StatsObjectID>(hitEvent.target.GetEntityID());
    ArrayClear(Deref(valuesLost));
    currentPoolVal = GameInstance.GetStatPoolsSystem(hitEvent.target.GetGame()).GetStatPoolValue(targetID, poolType, false);
    if currentPoolVal > 0.00 {
      dmgVal = dmg;
      valueToDrain = currentPoolVal <= dmgVal ? currentPoolVal : dmgVal;
      if forReal {
        StatPoolsManager.DrainStatPool(hitEvent, poolType, valueToDrain);
      };
      newPool.affectedStatPool = poolType;
      newPool.value = valueToDrain;
      newPool.type = dmgType;
      ArrayPush(Deref(valuesLost), newPool);
    };
  }

  private final static func MergeStatPoolsLost(out to: [SDamageDealt], const from: script_ref<[SDamageDealt]>) -> Void {
    let i: Int32 = 0;
    while i < ArraySize(Deref(from)) {
      StatPoolsManager.AddDrain(to, Deref(from)[i].affectedStatPool, Deref(from)[i].value, Deref(from)[i].type);
      i += 1;
    };
  }

  private final static func GetBodyPartStatPool(obj: ref<GameObject>, bodyPartName: CName, out poolType: gamedataStatPoolType) -> Bool {
    let value: Float;
    let objectID: StatsObjectID = Cast<StatsObjectID>(obj.GetEntityID());
    let statPoolType: gamedataStatPoolType = IntEnum<gamedataStatPoolType>(Cast<Int32>(EnumValueFromName(n"gamedataStatPoolType", bodyPartName)));
    if StatPoolsManager.IsStatPoolValid(statPoolType) {
      value = GameInstance.GetStatPoolsSystem(obj.GetGame()).GetStatPoolValue(objectID, statPoolType);
      if value > 0.00 {
        poolType = statPoolType;
      };
      return true;
    };
    poolType = gamedataStatPoolType.Invalid;
    return false;
  }

  private final static func AddDrain(out arr: [SDamageDealt], type: gamedataStatPoolType, value: Float, dmgType: gamedataDamageType) -> Void {
    let res: SDamageDealt;
    let i: Int32 = 0;
    while i < ArraySize(arr) {
      if Equals(arr[i].affectedStatPool, type) {
        arr[i].value += value;
        return;
      };
      i += 1;
    };
    res.type = dmgType;
    res.affectedStatPool = type;
    res.value = value;
    ArrayPush(arr, res);
  }

  private final static func ApplyDamageSingle(hitEvent: ref<gameHitEvent>, dmgType: gamedataDamageType, initialDamageValue: Float, forReal: Bool, valuesLost: script_ref<[SDamageDealt]>) -> Void {
    let currentHealthValue: Float;
    let isDeadNPC: Bool;
    let npcTarget: wref<NPCPuppet>;
    let statPoolValue: SDamageDealt;
    let attackData: ref<AttackData> = hitEvent.attackData;
    let instigator: wref<GameObject> = attackData.GetInstigator();
    let statPoolsSystem: ref<StatPoolsSystem> = GameInstance.GetStatPoolsSystem(hitEvent.target.GetGame());
    ArrayClear(Deref(valuesLost));
    currentHealthValue = statPoolsSystem.GetStatPoolValue(Cast<StatsObjectID>(hitEvent.target.GetEntityID()), gamedataStatPoolType.Health, false);
    if currentHealthValue > 0.00 {
      StatPoolsManager.ApplyDamageToOverShieldSingle(hitEvent, dmgType, initialDamageValue, forReal, valuesLost);
      StatPoolsManager.ApplyDamageToArmorSingle(hitEvent, dmgType, initialDamageValue, forReal, valuesLost);
      if initialDamageValue >= 0.00 {
        if currentHealthValue < initialDamageValue {
          npcTarget = hitEvent.target as NPCPuppet;
          isDeadNPC = IsDefined(npcTarget) && (npcTarget.IsDead() || ScriptedPuppet.IsDefeated(npcTarget) || npcTarget.IsAboutToDieOrDefeated());
          if hitEvent.target.IsPlayer() && hitEvent.attackData.HasFlag(hitFlag.CannotKillPlayer) {
            initialDamageValue = currentHealthValue - 1.00;
          } else {
            if !hitEvent.target.IsPlayer() && !isDeadNPC && StatPoolsManager.IsFinisherGrace(hitEvent) {
              initialDamageValue = currentHealthValue - 1.00;
              if IsDefined(npcTarget) && (npcTarget.IsBoss() || Equals(npcTarget.GetNPCRarity(), gamedataNPCRarity.MaxTac)) {
                GameInstance.GetStatPoolsSystem(hitEvent.target.GetGame()).RequestSettingStatPoolValue(Cast<StatsObjectID>(hitEvent.target.GetEntityID()), gamedataStatPoolType.Poise, 0.00, hitEvent.attackData.GetInstigator(), true);
              };
            } else {
              if !hitEvent.target.IsPlayer() && !isDeadNPC && hitEvent.attackData.HasFlag(hitFlag.BleedingDot) && PlayerDevelopmentSystem.GetData(instigator).IsNewPerkBought(gamedataNewPerkType.Reflexes_Master_Perk_5) > 0 {
                initialDamageValue = currentHealthValue - 1.00;
                if IsDefined(npcTarget) && (npcTarget.IsBoss() || Equals(npcTarget.GetNPCRarity(), gamedataNPCRarity.MaxTac)) {
                  GameInstance.GetStatPoolsSystem(hitEvent.target.GetGame()).RequestSettingStatPoolValue(Cast<StatsObjectID>(hitEvent.target.GetEntityID()), gamedataStatPoolType.Poise, 0.00, hitEvent.attackData.GetInstigator(), true);
                };
              } else {
                attackData.AddFlag(hitFlag.WasKillingBlow, n"Killing Blow");
                initialDamageValue = currentHealthValue;
              };
            };
          };
        };
        if forReal {
          statPoolsSystem.RequestSettingStatPoolValue(Cast<StatsObjectID>(hitEvent.target.GetEntityID()), gamedataStatPoolType.CPO_Armor, 0.00, instigator);
          StatPoolsManager.DrainStatPool(hitEvent, gamedataStatPoolType.Health, initialDamageValue);
        };
        statPoolValue.type = dmgType;
        statPoolValue.affectedStatPool = gamedataStatPoolType.Health;
        statPoolValue.value = initialDamageValue;
        ArrayPush(Deref(valuesLost), statPoolValue);
        attackData.AddFlag(hitFlag.SuccessfulAttack, n"DealtDamage");
      };
    };
  }

  private final static func IsFinisherGrace(hitEvent: ref<gameHitEvent>) -> Bool {
    let currentPercValue: Float;
    let healthThreshold: Float;
    let player: wref<PlayerPuppet>;
    let weapon: ref<WeaponObject>;
    let chance: Float = 0.00;
    if !hitEvent.attackData.GetInstigator().IsPlayer() {
      return false;
    };
    if hitEvent.attackData.HasFlag(hitFlag.QuickHack) {
      return false;
    };
    player = hitEvent.attackData.GetInstigator() as PlayerPuppet;
    if player.GetIsInFastFinisher() {
      return false;
    };
    currentPercValue = GameInstance.GetStatPoolsSystem(hitEvent.target.GetGame()).GetStatPoolValue(Cast<StatsObjectID>(hitEvent.target.GetEntityID()), gamedataStatPoolType.Health);
    healthThreshold = TweakDBInterface.GetFloat(t"NewPerks.Reflexes_Right_Milestone_3.graceChanceHealthThreshold", 0.00);
    if currentPercValue < healthThreshold {
      return false;
    };
    weapon = GameObject.GetActiveWeapon(player);
    if weapon.IsThrowable() || weapon.IsMelee() || weapon.IsMonowire() {
      if weapon.IsMelee() {
        chance = TweakDBInterface.GetFloat(t"NewPerks.Reflexes_Right_Milestone_3.graceChance", 0.00);
      };
      if weapon.IsThrowable() {
        chance = TweakDBInterface.GetFloat(t"NewPerks.Reflexes_Right_Milestone_3.graceChanceThrowable", 0.00);
      };
      if IsDefined(player) && player.HasFinisherAvailable() {
        return RandF() < chance;
      };
    };
    return false;
  }

  private final static func ApplyDamageToArmorSingle(hitEvent: ref<gameHitEvent>, dmgType: gamedataDamageType, out initialDamageValue: Float, forReal: Bool, valuesLost: script_ref<[SDamageDealt]>) -> Void {
    let statPoolValue: SDamageDealt;
    let statPoolsSystem: ref<StatPoolsSystem> = GameInstance.GetStatPoolsSystem(hitEvent.target.GetGame());
    let currentArmorValue: Float = statPoolsSystem.GetStatPoolValue(Cast<StatsObjectID>(hitEvent.target.GetEntityID()), gamedataStatPoolType.CPO_Armor, false);
    if currentArmorValue > 0.00 {
      if forReal {
        StatPoolsManager.DrainStatPool(hitEvent, gamedataStatPoolType.CPO_Armor, initialDamageValue);
      };
      statPoolValue.type = dmgType;
      statPoolValue.affectedStatPool = gamedataStatPoolType.CPO_Armor;
      statPoolValue.value = MinF(initialDamageValue, currentArmorValue);
      ArrayPush(Deref(valuesLost), statPoolValue);
      initialDamageValue = initialDamageValue - currentArmorValue;
    };
  }

  private final static func ApplyDamageToOverShieldSingle(hitEvent: ref<gameHitEvent>, dmgType: gamedataDamageType, out initialDamageValue: Float, forReal: Bool, valuesLost: script_ref<[SDamageDealt]>) -> Void {
    let statPoolValue: SDamageDealt;
    let statPoolsSystem: ref<StatPoolsSystem> = GameInstance.GetStatPoolsSystem(hitEvent.target.GetGame());
    let currentOvershieldValue: Float = statPoolsSystem.GetStatPoolValue(Cast<StatsObjectID>(hitEvent.target.GetEntityID()), gamedataStatPoolType.Overshield, false);
    if currentOvershieldValue <= 0.00 {
      return;
    };
    if forReal {
      StatPoolsManager.DrainStatPool(hitEvent, gamedataStatPoolType.Overshield, initialDamageValue);
    };
    statPoolValue.type = dmgType;
    statPoolValue.affectedStatPool = gamedataStatPoolType.Overshield;
    statPoolValue.value = MinF(initialDamageValue, currentOvershieldValue);
    ArrayPush(Deref(valuesLost), statPoolValue);
    initialDamageValue = initialDamageValue - currentOvershieldValue;
    RPGManager.AwardExperienceFromResourceSpent(hitEvent.target as PlayerPuppet, statPoolValue.value, gamedataStatPoolType.Overshield, hitEvent);
  }

  public final static func ApplyStatusEffectDamage(hitEvent: ref<gameHitEvent>, resistPoolRecord: ref<StatPool_Record>, statusEffectID: TweakDBID) -> Void {
    let finalDamage: Float;
    let resistanceFactor: Float;
    let statusEffectListener: ref<StatusEffectTriggerListener>;
    let target: ref<GameObject> = hitEvent.target;
    let instigator: wref<GameObject> = hitEvent.attackData.GetInstigator();
    let targetID: EntityID = target.GetEntityID();
    let statPoolsSystem: ref<StatPoolsSystem> = GameInstance.GetStatPoolsSystem(target.GetGame());
    let resistPool: gamedataStatPoolType = resistPoolRecord.StatPoolType();
    let baseDamage: Float = hitEvent.attackComputed.GetTotalAttackValue(gamedataStatPoolType.Health);
    if !statPoolsSystem.IsStatPoolAdded(Cast<StatsObjectID>(targetID), resistPool) {
      statusEffectListener = new StatusEffectTriggerListener();
      statusEffectListener.m_owner = target;
      statusEffectListener.m_statusEffect = statusEffectID;
      statusEffectListener.m_statPoolType = resistPool;
      statusEffectListener.m_instigator = instigator;
      statPoolsSystem.RequestAddingStatPool(Cast<StatsObjectID>(targetID), resistPoolRecord.GetID());
      statPoolsSystem.RequestRegisteringListener(Cast<StatsObjectID>(targetID), resistPool, statusEffectListener);
      GameObject.AddStatusEffectTriggerListener(target, statusEffectListener);
    };
    resistanceFactor = 0.50;
    finalDamage = baseDamage * resistanceFactor;
    StatPoolsManager.DrainStatPool(hitEvent, resistPool, finalDamage);
  }

  public final static func DrainStatPool(hitEvent: ref<gameHitEvent>, statPoolType: gamedataStatPoolType, value: Float) -> Void {
    let dmgExpPercent: Float;
    let isTargetImmortal: Bool;
    let minHealthPercentValue: Float;
    let percValueToDrain: Float;
    let processVendettaEvent: ref<ProcessVendettaAchievementEvent>;
    let targetID: StatsObjectID = Cast<StatsObjectID>(hitEvent.target.GetEntityID());
    let godModeSystem: ref<GodModeSystem> = GameInstance.GetGodModeSystem(GetGameInstance());
    let statPoolsSystem: ref<StatPoolsSystem> = GameInstance.GetStatPoolsSystem(hitEvent.target.GetGame());
    let currentPercValue: Float = statPoolsSystem.GetStatPoolValue(targetID, statPoolType);
    let currentPointValue: Float = statPoolsSystem.ToPoints(targetID, statPoolType, currentPercValue);
    if currentPointValue <= 0.00 {
      currentPointValue = 1.00;
    };
    percValueToDrain = (value * currentPercValue) / currentPointValue;
    minHealthPercentValue = hitEvent.attackData.GetMinimumHealthPercent();
    isTargetImmortal = godModeSystem.HasGodMode(hitEvent.target.GetEntityID(), gameGodModeType.Immortal);
    if isTargetImmortal {
      minHealthPercentValue = MaxF(minHealthPercentValue, 1.00);
    };
    if Equals(gamedataStatPoolType.Health, statPoolType) && minHealthPercentValue > 0.00 && currentPercValue - percValueToDrain < minHealthPercentValue {
      percValueToDrain = MaxF(currentPercValue - minHealthPercentValue, 0.00);
    };
    percValueToDrain = MinF(percValueToDrain, currentPercValue);
    if percValueToDrain == 0.00 {
      return;
    };
    statPoolsSystem.RequestChangingStatPoolValue(targetID, statPoolType, -percValueToDrain, hitEvent.attackData.GetInstigator(), true, true, hitEvent.attackData.HasFlag(hitFlag.IgnoreStatPoolCustomLimit));
    dmgExpPercent = percValueToDrain;
    if isTargetImmortal && currentPercValue - percValueToDrain <= 1.00 && hitEvent.target.IsPlayer() && hitEvent.attackData.GetInstigator().IsNPC() && Equals(statPoolType, gamedataStatPoolType.Health) {
      processVendettaEvent = new ProcessVendettaAchievementEvent();
      processVendettaEvent.deathInstigator = hitEvent.attackData.GetInstigator();
      hitEvent.target.QueueEvent(processVendettaEvent);
    };
    if dmgExpPercent > 0.00 {
      RPGManager.AwardExperienceFromDamage(hitEvent, dmgExpPercent);
    };
  }

  public final static func IsStatPoolValid(type: gamedataStatPoolType) -> Bool {
    let i: Int32 = 0;
    while i < 47 {
      if Equals(type, IntEnum<gamedataStatPoolType>(i)) {
        return true;
      };
      i += 1;
    };
    return false;
  }

  public final static func SimulateKill(hitEvent: ref<gameHitEvent>) -> Bool {
    let curStatPoolValue: Float;
    let target: ref<GameObject> = hitEvent.target;
    let valueToDrain: Float = hitEvent.attackComputed.GetTotalAttackValue(gamedataStatPoolType.Health);
    if valueToDrain > 0.00 {
      curStatPoolValue = GameInstance.GetStatPoolsSystem(target.GetGame()).GetStatPoolValue(Cast<StatsObjectID>(target.GetEntityID()), gamedataStatPoolType.Health, false);
      return valueToDrain >= curStatPoolValue ? true : false;
    };
    return false;
  }
}
