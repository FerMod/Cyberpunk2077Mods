
public class EffectPreAction_PreAttack extends EffectPreAction_Scripted {

  @default(EffectPreAction_PreAttack, false)
  @default(EffectPreAction_PreAttack_WithFriendlyFire, true)
  protected edit let m_withFriendlyFire: Bool;

  @default(EffectPreAction_PreAttack, false)
  @default(EffectPreAction_PreAttack_WithFriendlyFire, true)
  protected edit let m_withSelfDamage: Bool;

  public final const func Process(ctx: EffectScriptContext) -> Void {
    let TEMP_recordFlags: array<String>;
    let attackPosition: Vector4;
    let attackSource: ref<IAttack>;
    let effects: array<SHitStatusEffect>;
    let i: Int32;
    let newFlags: array<SHitFlag>;
    let randRoll: Float;
    let tempFlag: hitFlag;
    let tempVariant: Variant;
    let weaponCharge: Float;
    let weaponObject: ref<WeaponObject>;
    let data: ref<AttackData> = new AttackData();
    data.SetInstigator(EffectScriptContext.GetInstigator(ctx) as GameObject);
    data.SetSource(EffectScriptContext.GetSource(ctx) as GameObject);
    if EffectData.GetFloat(EffectScriptContext.GetSharedData(ctx), GetAllBlackboardDefs().EffectSharedData.randRoll, randRoll) {
      data.SetRandRoll(randRoll);
    };
    if EffectData.GetVector(EffectScriptContext.GetSharedData(ctx), GetAllBlackboardDefs().EffectSharedData.position, attackPosition) {
      data.SetAttackPosition(attackPosition);
    };
    if EffectData.GetVariant(EffectScriptContext.GetSharedData(ctx), GetAllBlackboardDefs().EffectSharedData.attack, tempVariant) {
      attackSource = FromVariant<ref<IAttack>>(tempVariant);
      if !IsDefined(attackSource) {
        attackSource = FromVariant<ref<Attack_GameEffect>>(tempVariant);
      };
      if !IsDefined(attackSource) {
        attackSource = FromVariant<ref<Attack_Projectile>>(tempVariant);
      };
      if !IsDefined(attackSource) {
        attackSource = FromVariant<ref<Attack_Continuous>>(tempVariant);
      };
    };
    if EffectData.GetFloat(EffectScriptContext.GetSharedData(ctx), GetAllBlackboardDefs().EffectSharedData.charge, weaponCharge) {
      data.SetWeaponCharge(weaponCharge);
    };
    weaponObject = EffectScriptContext.GetWeapon(ctx) as WeaponObject;
    if IsDefined(weaponObject) {
      data.SetWeapon(weaponObject);
      data.SetTriggerMode(weaponObject.GetCurrentTriggerMode().Type());
    };
    if IsDefined(attackSource) {
      data.SetAttackDefinition(attackSource);
    } else {
      if IsDefined(weaponObject) {
        data.SetAttackDefinition(weaponObject.GetCurrentAttack());
      };
    };
    TEMP_recordFlags = data.GetAttackDefinition().GetRecord().HitFlags();
    i = 0;
    while i < ArraySize(TEMP_recordFlags) {
      tempFlag = IntEnum<hitFlag>(Cast<Int32>(EnumValueFromString("hitFlag", TEMP_recordFlags[i])));
      if EnumInt(tempFlag) > -1 {
        data.AddFlag(tempFlag, n"PreAttack");
      };
      i += 1;
    };
    EffectData.GetVariant(EffectScriptContext.GetSharedData(ctx), GetAllBlackboardDefs().EffectSharedData.flags, tempVariant);
    if IsDefined(tempVariant) {
      newFlags = FromVariant<array<SHitFlag>>(tempVariant);
    };
    i = 0;
    while i < ArraySize(newFlags) {
      data.AddFlag(newFlags[i].flag, n"PreAttack");
      i += 1;
    };
    if this.m_withFriendlyFire {
      data.AddFlag(hitFlag.FriendlyFire, n"PreAttack");
    };
    if this.m_withSelfDamage {
      data.AddFlag(hitFlag.CanDamageSelf, n"PreAttack");
    };
    if EffectData.GetVariant(EffectScriptContext.GetSharedData(ctx), GetAllBlackboardDefs().EffectSharedData.statusEffect, tempVariant) {
      effects = FromVariant<array<SHitStatusEffect>>(tempVariant);
    };
    i = 0;
    while i < ArraySize(effects) {
      data.AddStatusEffect(effects[i].id, effects[i].stacks);
      i += 1;
    };
    data.SetAttackTime(EngineTime.ToFloat(GameInstance.GetTimeSystem(EffectScriptContext.GetGameInstance(ctx)).GetSimTime()));
    data.PreAttack();
    EffectData.SetVariant(EffectScriptContext.GetSharedData(ctx), GetAllBlackboardDefs().EffectSharedData.attackData, ToVariant(data));
  }
}
