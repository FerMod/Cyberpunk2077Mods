
public class ModifyDamageWithCyberwareCountEffector extends ModifyDamageEffector {

  public let m_minPlayerHealthPercentage: Float;

  public let m_playerIncomingDamageMultiplier: Float;

  public let m_playerMaxIncomingDamage: Float;

  public let m_damageBuffAmount: Float;

  public let m_damageBuffRarity: Float;

  public let m_playVFXOnHitTargets: CName;

  public let m_statusEffectRecord: wref<StatusEffect_Record>;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    super.Initialize(record, game, parentRecord);
    this.m_minPlayerHealthPercentage = TDB.GetFloat(record + t".minPlayerHealthPercentage") / 100.00;
    this.m_playerIncomingDamageMultiplier = TDB.GetFloat(record + t".playerIncomingDamageMultiplier");
    this.m_playerMaxIncomingDamage = TDB.GetFloat(record + t".playerMaxIncomingDamage");
    this.m_damageBuffAmount = TDB.GetFloat(record + t".damageBuffAmount");
    this.m_damageBuffRarity = TDB.GetFloat(record + t".damageBuffRarity");
    this.m_playVFXOnHitTargets = TDB.GetCName(record + t".playVFXOnHitTargets");
    this.m_statusEffectRecord = TweakDBInterface.GetStatusEffectRecord(TweakDBInterface.GetForeignKeyDefault(record + t".statusEffectRecord"));
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    let attackdamage: Float;
    let breakEffectLoopEvent: ref<entBreakEffectLoopEvent>;
    let calculatedDamageMultiplier: Float;
    let currentCyberware: ItemID;
    let currentCyberwareData: wref<gameItemData>;
    let equipmentAreas: array<gamedataEquipmentArea>;
    let equipmentSystemPlayerData: ref<EquipmentSystemPlayerData>;
    let health: Float;
    let i: Int32;
    let maxHealth: Float;
    let minAllowedHealth: Float;
    let equippedCyberwareCount: Int32 = 0;
    let maxCyberwareCount: Int32 = 0;
    let equippedCyberwareRarity: Float = 0.00;
    let hitEvent: ref<gameHitEvent> = this.GetHitEvent();
    if !IsDefined(hitEvent) {
      return;
    };
    equipmentSystemPlayerData = EquipmentSystem.GetData(owner);
    equipmentAreas = equipmentSystemPlayerData.GetAllCyberwareEquipmentAreas();
    i = 0;
    while i < ArraySize(equipmentAreas) {
      maxCyberwareCount += equipmentSystemPlayerData.GetNumberOfSlots(equipmentAreas[i], true);
      equippedCyberwareCount += equipmentSystemPlayerData.GetNumberOfItemsInEquipmentArea(equipmentAreas[i]);
      currentCyberware = equipmentSystemPlayerData.GetActiveItem(equipmentAreas[i]);
      currentCyberwareData = RPGManager.GetItemData(owner.GetGame(), owner, currentCyberware);
      equippedCyberwareRarity += RPGManager.ItemQualityEnumToValue(RPGManager.GetItemDataQuality(currentCyberwareData));
      if RPGManager.IsItemIconic(currentCyberwareData) {
        equippedCyberwareRarity += 1.00;
      };
      i += 1;
    };
    if maxCyberwareCount == 0 {
      return;
    };
    calculatedDamageMultiplier = 1.00;
    calculatedDamageMultiplier *= 1.00 + (this.m_damageBuffAmount * Cast<Float>(equippedCyberwareCount)) / Cast<Float>(maxCyberwareCount);
    calculatedDamageMultiplier *= 1.00 + equippedCyberwareRarity * this.m_damageBuffRarity;
    if hitEvent.target == owner {
      calculatedDamageMultiplier *= this.m_playerIncomingDamageMultiplier;
    };
    hitEvent.attackComputed.MultAttackValue(calculatedDamageMultiplier);
    if hitEvent.target == owner {
      attackdamage = hitEvent.attackComputed.GetTotalAttackValue(gamedataStatPoolType.Health);
      health = GameInstance.GetStatPoolsSystem(owner.GetGame()).GetStatPoolValue(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatPoolType.Health, false);
      maxHealth = GameInstance.GetStatPoolsSystem(owner.GetGame()).GetStatPoolMaxPointValue(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatPoolType.Health);
      minAllowedHealth = MaxF(maxHealth * this.m_minPlayerHealthPercentage, health - maxHealth * this.m_playerMaxIncomingDamage);
      if attackdamage > 0.00 && health - attackdamage < minAllowedHealth {
        if health > minAllowedHealth {
          hitEvent.attackComputed.MultAttackValue((health - minAllowedHealth) / attackdamage);
        } else {
          hitEvent.attackComputed.MultAttackValue(0.00);
        };
      };
    } else {
      if IsDefined(hitEvent.target as ScriptedPuppet) && NotEquals(GameObject.GetAttitudeBetween(hitEvent.target, hitEvent.attackData.GetInstigator()), EAIAttitude.AIA_Friendly) {
        if IsNameValid(this.m_playVFXOnHitTargets) {
          GameObjectEffectHelper.StartEffectEvent(hitEvent.target, this.m_playVFXOnHitTargets);
          breakEffectLoopEvent = new entBreakEffectLoopEvent();
          breakEffectLoopEvent.effectName = this.m_playVFXOnHitTargets;
          GameInstance.GetDelaySystem(owner.GetGame()).DelayEvent(hitEvent.target, breakEffectLoopEvent, 2.50);
        };
        StatusEffectHelper.ApplyStatusEffect(hitEvent.target, this.m_statusEffectRecord.GetID(), GameObject.GetTDBID(owner));
      };
    };
  }
}
