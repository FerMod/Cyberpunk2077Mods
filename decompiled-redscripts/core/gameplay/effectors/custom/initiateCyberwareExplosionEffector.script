
public class InitiateCyberwareExplosionEffector extends Effector {

  public let m_maxRangeAddition: Float;

  public let m_attackRecord: wref<Attack_Record>;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    super.Initialize(record, game, parentRecord);
    this.m_maxRangeAddition = TDB.GetFloat(record + t".maxRangeAddition");
    this.m_attackRecord = TweakDBInterface.GetAttackRecord(TweakDBInterface.GetForeignKeyDefault(record + t".attackRecord"));
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    this.RepeatedAction(owner);
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    let attack: ref<Attack_GameEffect>;
    let attackContext: AttackInitContext;
    let attackEffect: ref<EffectInstance>;
    let explosionRadius: Float;
    let impulseRadius: Float;
    let statMods: array<ref<gameStatModifierData>>;
    let equippedCyberwareCount: Int32 = 0;
    let maxCyberwareCount: Int32 = 0;
    let equipmentSystemPlayerData: ref<EquipmentSystemPlayerData> = EquipmentSystem.GetData(owner);
    let equipmentAreas: array<gamedataEquipmentArea> = equipmentSystemPlayerData.GetAllCyberwareEquipmentAreas();
    let i: Int32 = 0;
    while i < ArraySize(equipmentAreas) {
      maxCyberwareCount += equipmentSystemPlayerData.GetNumberOfSlots(equipmentAreas[i]);
      equippedCyberwareCount += equipmentSystemPlayerData.GetNumberOfItemsInEquipmentArea(equipmentAreas[i]);
      i += 1;
    };
    if maxCyberwareCount == 0 {
      return;
    };
    explosionRadius = TDB.GetFloat(t"weapons.E3_grenade.damageRadius") + Cast<Float>(equippedCyberwareCount) / Cast<Float>(maxCyberwareCount) * this.m_maxRangeAddition;
    impulseRadius = TDB.GetFloat(t"weapons.E3_grenade.physicalImpulseRadius") + Cast<Float>(equippedCyberwareCount) / Cast<Float>(maxCyberwareCount) * this.m_maxRangeAddition;
    attackContext.record = this.m_attackRecord;
    attackContext.instigator = owner;
    attackContext.source = owner;
    attack = IAttack.Create(attackContext) as Attack_GameEffect;
    attackEffect = attack.PrepareAttack(owner);
    attack.GetStatModList(statMods);
    EffectData.SetFloat(attackEffect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.range, explosionRadius);
    EffectData.SetFloat(attackEffect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.radius, explosionRadius);
    EffectData.SetVector(attackEffect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.position, owner.GetWorldPosition());
    EffectData.SetVariant(attackEffect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.attack, ToVariant(attack));
    EffectData.SetVariant(attackEffect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.attackStatModList, ToVariant(statMods));
    attack.StartAttack();
    CombatGadgetHelper.SpawnPhysicalImpulse(owner, impulseRadius);
    GameObject.PlayMetadataEvent(owner, n"exploded");
    GameInstance.GetAudioSystem(owner.GetGame()).PlayShockwave(n"explosion", owner.GetWorldPosition());
    GameObjectEffectHelper.StartEffectEvent(owner, n"cyberware_explosion", false);
    if !StatusEffectHelper.HasStatusEffectWithTagConst(owner, n"BerserkBuff") {
      GameObjectEffectHelper.StartEffectEvent(owner, n"screen_scanning", false);
    };
  }
}
