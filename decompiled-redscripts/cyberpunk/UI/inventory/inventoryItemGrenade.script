
public class UIInventoryItemGrenadeData extends IScriptable {

  public let Type: GrenadeDamageType;

  public let Range: Float;

  public let DeliveryMethod: gamedataGrenadeDeliveryMethodType;

  public let Duration: Float;

  public let Delay: Float;

  public let DetonationTimer: Float;

  public let DamagePerTick: Float;

  public let DamageType: gamedataStatType;

  public let GrenadeType: EGrenadeType;

  public let TotalDamage: Float;

  public let m_Player: wref<PlayerPuppet>;

  private final static func GetGrenadeContinousEffector(attackRecord: wref<Attack_Record>) -> wref<ContinuousAttackEffector_Record> {
    let continuousAttackEffector: wref<ContinuousAttackEffector_Record>;
    let i: Int32;
    let j: Int32;
    let k: Int32;
    let statusEffectEffectors: array<wref<Effector_Record>>;
    let statusEffectPackages: array<wref<GameplayLogicPackage_Record>>;
    let statusEffects: array<wref<StatusEffectAttackData_Record>>;
    attackRecord.StatusEffects(statusEffects);
    i = 0;
    while i < ArraySize(statusEffects) {
      statusEffects[i].StatusEffect().Packages(statusEffectPackages);
      j = 0;
      while j < ArraySize(statusEffectPackages) {
        statusEffectPackages[j].Effectors(statusEffectEffectors);
        k = 0;
        while k < ArraySize(statusEffectEffectors) {
          if Equals(statusEffectEffectors[k].EffectorClassName(), n"TriggerContinuousAttackEffector") {
            continuousAttackEffector = statusEffectEffectors[k] as ContinuousAttackEffector_Record;
            if IsDefined(continuousAttackEffector) {
              return continuousAttackEffector;
            };
          };
          k += 1;
        };
        j += 1;
      };
      i += 1;
    };
    return null;
  }

  private final static func GetGrenadeTotalDamageFromStats(itemData: wref<gameItemData>) -> Float {
    let damageData: array<ref<InventoryTooltiData_GrenadeDamageData>>;
    let i: Int32;
    let result: Float;
    UIInventoryItemGrenadeData.GetGrenadeDamageStats(itemData, damageData);
    i = 0;
    while i < ArraySize(damageData) {
      result += damageData[i].value;
      i += 1;
    };
    return result;
  }

  private final static func GetGrenadeDamageStats(itemData: wref<gameItemData>, outputArray: script_ref<[ref<InventoryTooltiData_GrenadeDamageData>]>) -> Void {
    let damageData: ref<InventoryTooltiData_GrenadeDamageData>;
    let value: Float = itemData.GetStatValueByType(gamedataStatType.BaseDamage);
    if value > 0.00 {
      damageData = new InventoryTooltiData_GrenadeDamageData();
      damageData.statType = gamedataStatType.BaseDamage;
      damageData.value = value;
      ArrayPush(Deref(outputArray), damageData);
    };
    value = itemData.GetStatValueByType(gamedataStatType.PhysicalDamage);
    if value > 0.00 {
      damageData = new InventoryTooltiData_GrenadeDamageData();
      damageData.statType = gamedataStatType.PhysicalDamage;
      damageData.value = value;
      ArrayPush(Deref(outputArray), damageData);
    };
    value = itemData.GetStatValueByType(gamedataStatType.ChemicalDamage);
    if value > 0.00 {
      damageData = new InventoryTooltiData_GrenadeDamageData();
      damageData.statType = gamedataStatType.ChemicalDamage;
      damageData.value = value;
      ArrayPush(Deref(outputArray), damageData);
    };
    value = itemData.GetStatValueByType(gamedataStatType.ElectricDamage);
    if value > 0.00 {
      damageData = new InventoryTooltiData_GrenadeDamageData();
      damageData.statType = gamedataStatType.ElectricDamage;
      damageData.value = value;
      ArrayPush(Deref(outputArray), damageData);
    };
    value = itemData.GetStatValueByType(gamedataStatType.ThermalDamage);
    if value > 0.00 {
      damageData = new InventoryTooltiData_GrenadeDamageData();
      damageData.statType = gamedataStatType.ThermalDamage;
      damageData.value = value;
      ArrayPush(Deref(outputArray), damageData);
    };
  }

  private final static func GetGrenadeDoTTickDamage(player: wref<PlayerPuppet>, continuousAttackEffector: wref<ContinuousAttackEffector_Record>) -> Float {
    let continuousAttackRecord: wref<Attack_Record>;
    let continuousAttackStatModifiers: array<wref<StatModifier_Record>>;
    if IsDefined(continuousAttackEffector) {
      continuousAttackRecord = continuousAttackEffector.AttackRecord();
      continuousAttackRecord.StatModifiers(continuousAttackStatModifiers);
      return RPGManager.CalculateStatModifiers(continuousAttackStatModifiers, player.GetGame(), player, Cast<StatsObjectID>(player.GetEntityID()));
    };
    return 0.00;
  }

  private final static func GetGrenadeRange(grenadeRecord: wref<Grenade_Record>, player: wref<PlayerPuppet>) -> Float {
    let i: Int32;
    let rangeStatModifier: array<wref<StatModifier_Record>>;
    let statModifier: array<wref<StatModifier_Record>>;
    let result: Float = grenadeRecord.AttackRadius();
    grenadeRecord.StatModifiers(statModifier);
    i = ArraySize(statModifier) - 1;
    while i > 0 {
      if Equals(statModifier[i].StatType().StatType(), gamedataStatType.Range) {
        if IsDefined(statModifier[i] as CombinedStatModifier_Record) || IsDefined(statModifier[i] as ConstantStatModifier_Record) {
          ArrayPush(rangeStatModifier, statModifier[i]);
        };
      };
      i -= 1;
    };
    result = RPGManager.CalculateStatModifiers(rangeStatModifier, player.GetGame(), player, Cast<StatsObjectID>(player.GetEntityID()));
    return result;
  }

  public final static func GetGrenadeType(grenadeRecord: wref<Grenade_Record>) -> EGrenadeType {
    let tags: array<CName> = grenadeRecord.Tags();
    if ArrayContains(tags, n"FragGrenade") {
      return EGrenadeType.Frag;
    };
    if ArrayContains(tags, n"FlashGrenade") {
      return EGrenadeType.Flash;
    };
    if ArrayContains(tags, n"SmokeGrenade") {
      return EGrenadeType.Smoke;
    };
    if ArrayContains(tags, n"PiercingGrenade") {
      return EGrenadeType.Piercing;
    };
    if ArrayContains(tags, n"EMPGrenade") {
      return EGrenadeType.EMP;
    };
    if ArrayContains(tags, n"BiohazardGrenade") {
      return EGrenadeType.Biohazard;
    };
    if ArrayContains(tags, n"IncendiaryGrenade") {
      return EGrenadeType.Incendiary;
    };
    if ArrayContains(tags, n"ReconGrenade") {
      return EGrenadeType.Recon;
    };
    if ArrayContains(tags, n"CuttingGrenade") {
      return EGrenadeType.Cutting;
    };
    if ArrayContains(tags, n"SonicGrenade") {
      return EGrenadeType.Sonic;
    };
    return EGrenadeType.Frag;
  }

  private final static func GetGrenadeDuration(player: wref<PlayerPuppet>, attackRecord: wref<Attack_Record>) -> Float {
    let durationModifiersRecord: wref<StatModifierGroup_Record>;
    let durationStatModifiers: array<wref<StatModifier_Record>>;
    let i: Int32;
    let statusEffects: array<wref<StatusEffectAttackData_Record>>;
    attackRecord.StatusEffects(statusEffects);
    i = 0;
    while i < ArraySize(statusEffects) {
      durationModifiersRecord = statusEffects[i].StatusEffect().Duration();
      if IsDefined(durationModifiersRecord) {
        durationModifiersRecord.StatModifiers(durationStatModifiers);
        return RPGManager.CalculateStatModifiers(durationStatModifiers, player.GetGame(), player, Cast<StatsObjectID>(player.GetEntityID()));
      };
      i += 1;
    };
    return 0.00;
  }

  private final static func GetGrenadeDelay(continuousAttackEffector: wref<ContinuousAttackEffector_Record>) -> Float {
    if IsDefined(continuousAttackEffector) {
      return continuousAttackEffector.DelayTime();
    };
    return 0.00;
  }

  public final static func Make(item: wref<UIInventoryItem>, player: wref<PlayerPuppet>) -> ref<UIInventoryItemGrenadeData> {
    let continousEffector: wref<ContinuousAttackEffector_Record>;
    let deliveryRecord: wref<GrenadeDeliveryMethod_Record>;
    let instance: ref<UIInventoryItemGrenadeData> = new UIInventoryItemGrenadeData();
    let grenadeRecord: wref<Grenade_Record> = TweakDBInterface.GetGrenadeRecord(item.GetTweakDBID());
    if IsDefined(grenadeRecord) {
      continousEffector = UIInventoryItemGrenadeData.GetGrenadeContinousEffector(grenadeRecord.Attack());
      instance.Range = UIInventoryItemGrenadeData.GetGrenadeRange(grenadeRecord, player);
      deliveryRecord = grenadeRecord.DeliveryMethod();
      instance.DeliveryMethod = deliveryRecord.Type().Type();
      instance.DetonationTimer = deliveryRecord.DetonationTimer();
      if IsDefined(continousEffector) {
        instance.Duration = UIInventoryItemGrenadeData.GetGrenadeDuration(player, grenadeRecord.Attack());
        instance.Delay = UIInventoryItemGrenadeData.GetGrenadeDelay(continousEffector);
        instance.DamagePerTick = UIInventoryItemGrenadeData.GetGrenadeDoTTickDamage(player, continousEffector);
        instance.Type = GrenadeDamageType.DoT;
        instance.TotalDamage = instance.DamagePerTick * instance.Duration / instance.Delay;
        instance.GrenadeType = UIInventoryItemGrenadeData.GetGrenadeType(grenadeRecord);
      } else {
        instance.Type = GrenadeDamageType.Normal;
        instance.TotalDamage = UIInventoryItemGrenadeData.GetGrenadeTotalDamageFromStats(item.GetItemData());
      };
    };
    return instance;
  }
}
