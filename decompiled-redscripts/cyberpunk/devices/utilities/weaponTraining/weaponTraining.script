
public class WeaponTraining extends InteractiveDevice {

  @runtimeProperty("customEditor", "TweakDBGroupInheritance;RPGActionRewards.ProficiencyReward")
  protected edit let m_rewardRecord: TweakDBID;

  protected edit const let m_weaponTypes: [gamedataItemType];

  @default(WeaponTraining, 30)
  protected edit let m_limitOfHits: Int32;

  protected let m_amountOfHits: Int32;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as WeaponTrainingController;
  }

  protected cb func OnHitEvent(hit: ref<gameHitEvent>) -> Bool {
    let weaponRecord: wref<Item_Record>;
    let attackData: ref<AttackData> = hit.attackData;
    if attackData.GetInstigator().IsPlayer() && !hit.target.IsPlayer() {
      weaponRecord = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(attackData.GetWeapon().GetItemID()));
      if this.m_amountOfHits < this.m_limitOfHits && this.MatchWeaponItemType(weaponRecord.ItemType().Type()) && TDBID.IsValid(this.m_rewardRecord) {
        this.AwardRewardXP(attackData.GetInstigator(), hit.target.GetEntityID());
        this.m_amountOfHits += 1;
      };
    };
  }

  protected final func MatchWeaponItemType(type: gamedataItemType) -> Bool {
    let i: Int32 = 0;
    while i < ArraySize(this.m_weaponTypes) {
      if Equals(this.m_weaponTypes[i], type) {
        return true;
      };
      i += 1;
    };
    return false;
  }

  protected final func AwardRewardXP(instigator: wref<GameObject>, target: EntityID) -> Void {
    let expArr: array<wref<XPPoints_Record>>;
    let expType: gamedataProficiencyType;
    let expValue: Float;
    let hitModifier: Float;
    let i: Int32;
    let quantityMods: array<wref<StatModifier_Record>>;
    let rewardRecord: ref<RewardBase_Record> = TweakDBInterface.GetRewardBaseRecord(this.m_rewardRecord);
    rewardRecord.Experience(expArr);
    hitModifier = 1.00 - Cast<Float>(this.m_amountOfHits) / (Cast<Float>(this.m_limitOfHits) + 1.00);
    i = 0;
    while i < ArraySize(expArr) {
      ArrayClear(quantityMods);
      expArr[i].QuantityModifiers(quantityMods);
      expValue = RPGManager.CalculateStatModifiers(quantityMods, this.GetGame(), instigator, Cast<StatsObjectID>(target));
      expType = expArr[i].Type().Type();
      RPGManager.AwardXP(this.GetGame(), expValue * hitModifier, expType);
      i += 1;
    };
  }

  protected const func HasAnyDirectInteractionActive() -> Bool {
    return true;
  }

  public const func DeterminGameplayRole() -> EGameplayRole {
    return EGameplayRole.GenericRole;
  }
}

public class WeaponTrainingController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<GameComponentPS> {
    return this.GetBasePS();
  }
}
