
public native class AttackData extends IScriptable {

  private native let attackType: gamedataAttackType;

  private native let instigator: wref<GameObject>;

  private native let source: wref<GameObject>;

  private native let weapon: wref<WeaponObject>;

  private native let attackDefinition: ref<IAttack>;

  private native let attackPosition: Vector4;

  private native let weaponCharge: Float;

  private native let numRicochetBounces: Int32;

  private native let numAttackSpread: Int32;

  private native let attackTime: Float;

  private native let triggerMode: gamedataTriggerMode;

  private let flags: [SHitFlag];

  private let statusEffects: [SHitStatusEffect];

  private let hitType: gameuiHitType;

  private let vehicleImpactForce: Float;

  private let minimumHealthPercent: Float;

  private let additionalCritChance: Float;

  private let randRoll: Float;

  private let hitReactionMin: Int32;

  private let hitReactionMax: Int32;

  public final func SetAttackType(attackTypeOverride: gamedataAttackType) -> Void {
    this.attackType = attackTypeOverride;
  }

  public final static func IsMelee(attackType: gamedataAttackType) -> Bool {
    return Equals(attackType, gamedataAttackType.Melee) || Equals(attackType, gamedataAttackType.QuickMelee) || Equals(attackType, gamedataAttackType.StrongMelee);
  }

  public final static func IsQuickMelee(attackType: gamedataAttackType) -> Bool {
    return Equals(attackType, gamedataAttackType.QuickMelee);
  }

  public final static func IsLightMelee(attackType: gamedataAttackType) -> Bool {
    return Equals(attackType, gamedataAttackType.Melee);
  }

  public final static func IsStrongMelee(attackType: gamedataAttackType) -> Bool {
    return Equals(attackType, gamedataAttackType.StrongMelee);
  }

  public final static func IsReflect(attackType: gamedataAttackType) -> Bool {
    return Equals(attackType, gamedataAttackType.Reflect);
  }

  public final static func IsRangedOnly(attackType: gamedataAttackType) -> Bool {
    return Equals(attackType, gamedataAttackType.Ranged);
  }

  public final static func IsRangedOrDirect(attackType: gamedataAttackType) -> Bool {
    return Equals(attackType, gamedataAttackType.Direct) || Equals(attackType, gamedataAttackType.Ranged);
  }

  public final static func IsRangedOrDirectOrThrown(attackType: gamedataAttackType) -> Bool {
    return Equals(attackType, gamedataAttackType.Direct) || Equals(attackType, gamedataAttackType.Ranged) || Equals(attackType, gamedataAttackType.Thrown) || Equals(attackType, gamedataAttackType.Explosion);
  }

  public final static func IsExplosion(attackType: gamedataAttackType) -> Bool {
    return Equals(attackType, gamedataAttackType.Explosion);
  }

  public final static func IsPressureWave(attackType: gamedataAttackType) -> Bool {
    return Equals(attackType, gamedataAttackType.PressureWave);
  }

  public final static func IsAreaOfEffect(attackType: gamedataAttackType) -> Bool {
    return Equals(attackType, gamedataAttackType.PressureWave) || Equals(attackType, gamedataAttackType.Explosion);
  }

  public final static func IsDismembermentCause(attackType: gamedataAttackType) -> Bool {
    return Equals(attackType, gamedataAttackType.ChargedWhipAttack) || Equals(attackType, gamedataAttackType.Explosion);
  }

  public final static func IsEffect(attackType: gamedataAttackType) -> Bool {
    return Equals(attackType, gamedataAttackType.Effect);
  }

  public final static func IsDoT(attackType: gamedataAttackType) -> Bool {
    return Equals(attackType, gamedataAttackType.Effect);
  }

  public final static func IsDoT(attackData: ref<AttackData>) -> Bool {
    return attackData.HasFlag(hitFlag.DamageOverTime);
  }

  public final static func IsHack(attackType: gamedataAttackType) -> Bool {
    return Equals(attackType, gamedataAttackType.Hack);
  }

  public final static func IsThrown(attackType: gamedataAttackType) -> Bool {
    return Equals(attackType, gamedataAttackType.Thrown);
  }

  public final static func IsWhip(attackType: gamedataAttackType) -> Bool {
    return Equals(attackType, gamedataAttackType.WhipAttack) || Equals(attackType, gamedataAttackType.ChargedWhipAttack);
  }

  public final func PreAttack() -> Void {
    let attackRecord: ref<Attack_Record>;
    if IsDefined(this.attackDefinition) {
      attackRecord = this.attackDefinition.GetRecord();
    };
    if IsDefined(attackRecord) {
      this.attackType = attackRecord.AttackType().Type();
      this.hitReactionMin = attackRecord.HitReactionSeverityMin();
      this.hitReactionMax = attackRecord.HitReactionSeverityMax();
    };
  }

  public final func SetInstigator(i: wref<GameObject>) -> Void {
    this.instigator = i;
  }

  public final func SetSource(s: wref<GameObject>) -> Void {
    this.source = s;
  }

  public final func SetWeapon(w: wref<WeaponObject>) -> Void {
    this.weapon = w;
  }

  public final func SetAttackDefinition(a: ref<IAttack>) -> Void {
    this.attackDefinition = a;
  }

  public final func SetHitType(h: gameuiHitType) -> Void {
    this.hitType = h;
  }

  public final func SetAttackPosition(position: Vector4) -> Void {
    this.attackPosition = position;
  }

  public final func SetWeaponCharge(charge: Float) -> Void {
    this.weaponCharge = charge;
  }

  public final func SetVehicleImpactForce(force: Float) -> Void {
    this.vehicleImpactForce = force;
  }

  public final func SetAdditionalCritChance(f: Float) -> Void {
    this.additionalCritChance = f;
  }

  public final func SetHitReactionSeverityMin(i: Int32) -> Void {
    this.hitReactionMin = i;
  }

  public final func SetHitReactionSeverityMax(i: Int32) -> Void {
    this.hitReactionMax = i;
  }

  public final func SetAttackTime(time: Float) -> Void {
    this.attackTime = time;
  }

  public final func SetTriggerMode(mode: gamedataTriggerMode) -> Void {
    this.triggerMode = mode;
  }

  public final func SetRandRoll(roll: Float) -> Void {
    this.randRoll = roll;
  }

  public final func SetMinimumHealthPercent(value: Float) -> Void {
    this.minimumHealthPercent = value;
  }

  public final const func GetInstigator() -> wref<GameObject> {
    return this.instigator;
  }

  public final const func GetSource() -> wref<GameObject> {
    return this.source;
  }

  public final const func GetWeapon() -> wref<WeaponObject> {
    return this.weapon;
  }

  public final const func GetAttackDefinition() -> ref<IAttack> {
    return this.attackDefinition;
  }

  public final const func GetAttackPosition() -> Vector4 {
    return this.attackPosition;
  }

  public final const func GetAttackType() -> gamedataAttackType {
    return this.attackType;
  }

  public final const func GetStatusEffects() -> [SHitStatusEffect] {
    return this.statusEffects;
  }

  public final const func GetHitType() -> gameuiHitType {
    return this.hitType;
  }

  public final const func GetWeaponCharge() -> Float {
    return this.weaponCharge;
  }

  public final const func GetNumRicochetBounces() -> Int32 {
    return this.numRicochetBounces;
  }

  public final const func GetNumAttackSpread() -> Int32 {
    return this.numAttackSpread;
  }

  public final const func GetVehicleImpactForce() -> Float {
    return this.vehicleImpactForce;
  }

  public final const func GetAdditionalCritChance() -> Float {
    return this.additionalCritChance;
  }

  public final const func GetHitReactionSeverityMin() -> Int32 {
    return this.hitReactionMin;
  }

  public final const func GetHitReactionSeverityMax() -> Int32 {
    return this.hitReactionMax;
  }

  public final const func GetAttackTime() -> Float {
    return this.attackTime;
  }

  public final const func GetTriggerMode() -> gamedataTriggerMode {
    return this.triggerMode;
  }

  public final const func GetRandRoll() -> Float {
    return this.randRoll;
  }

  public final const func GetMinimumHealthPercent() -> Float {
    return this.minimumHealthPercent;
  }

  public final const func GetAttackSubtype() -> gamedataAttackSubtype {
    let attackSubTypeRecord: ref<AttackSubtype_Record>;
    let record: ref<Attack_Melee_Record>;
    if AttackData.IsMelee(this.attackType) {
      record = this.attackDefinition.GetRecord() as Attack_Melee_Record;
      if IsDefined(record) {
        attackSubTypeRecord = record.AttackSubtype();
        if IsDefined(attackSubTypeRecord) {
          return attackSubTypeRecord.Type();
        };
      };
    };
    return gamedataAttackSubtype.Invalid;
  }

  public final static func CanEffectCriticallyHit(attackData: ref<AttackData>, statsSystem: ref<StatsSystem>) -> Bool {
    let result: Bool;
    let rec: ref<Attack_GameEffect_Record> = attackData.GetAttackDefinition().GetRecord() as Attack_GameEffect_Record;
    let effectTag: CName = rec.AttackTag();
    switch effectTag {
      case n"Bleeding":
        result = statsSystem.GetStatValue(Cast<StatsObjectID>(attackData.GetInstigator().GetEntityID()), gamedataStatType.CanBleedingCriticallyHit) > 0.00;
        break;
      case n"Poisoned":
        result = false;
        break;
      case n"Electrocuted":
        result = false;
        break;
      case n"Burning":
        result = attackData.HasFlag(hitFlag.AirDropBurningDoT);
        break;
      default:
        return false;
    };
    return result;
  }

  public final static func IsPlayerInCombat(attackData: ref<AttackData>) -> Bool {
    let psmBB: ref<IBlackboard> = GameInstance.GetBlackboardSystem(GetGameInstance()).GetLocalInstanced(attackData.GetInstigator().GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine);
    let combatState: Int32 = psmBB.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat);
    return combatState == 1;
  }

  public final static func CanGrenadeCriticallyHit(attackData: ref<AttackData>, statsSystem: ref<StatsSystem>) -> Bool {
    let result: Bool = statsSystem.GetStatValue(Cast<StatsObjectID>(attackData.GetInstigator().GetEntityID()), gamedataStatType.CanGrenadesCriticallyHit) > 0.00;
    return result;
  }

  public final func WasBlocked() -> Bool {
    return this.HasFlag(hitFlag.WasBlocked);
  }

  public final func WasBulletBlocked() -> Bool {
    return this.HasFlag(hitFlag.WasBulletBlocked);
  }

  public final func WasDeflected() -> Bool {
    return this.HasFlag(hitFlag.WasDeflected);
  }

  public final func WasBulletDeflected() -> Bool {
    return this.HasFlag(hitFlag.WasBulletDeflected) || this.HasFlag(hitFlag.WasBulletParried);
  }

  public final func WasDeflectedAny() -> Bool {
    return this.HasFlag(hitFlag.WasDeflected) || this.HasFlag(hitFlag.WasBulletDeflected) || this.HasFlag(hitFlag.WasBulletParried);
  }

  public final func DoesAttackWeaponHaveTag(tag: CName) -> Bool {
    let i: Int32;
    let record: ref<Item_Record>;
    let tags: array<CName>;
    if !IsDefined(this.weapon) {
      return false;
    };
    record = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(this.weapon.GetItemID()));
    tags = record.Tags();
    i = 0;
    while i < ArraySize(tags) {
      if Equals(tags[i], tag) {
        return true;
      };
      i += 1;
    };
    return false;
  }

  public final func ClearDamage() -> Void {
    if this.HasFlag(hitFlag.CannotModifyDamage) {
      return;
    };
  }

  public final func AddStatusEffect(effect: TweakDBID, stacks: Float) -> Void {
    let newStatusEffect: SHitStatusEffect;
    newStatusEffect.id = effect;
    newStatusEffect.stacks = stacks;
    ArrayPush(this.statusEffects, newStatusEffect);
  }

  public final const func HasFlag(flag: hitFlag) -> Bool {
    let i: Int32 = 0;
    while i < ArraySize(this.flags) {
      if Equals(this.flags[i].flag, flag) {
        return true;
      };
      i += 1;
    };
    return false;
  }

  public final static func HasFlag(const flags: script_ref<[SHitFlag]>, flag: hitFlag) -> Bool {
    let i: Int32 = 0;
    while i < ArraySize(Deref(flags)) {
      if Equals(Deref(flags)[i].flag, flag) {
        return true;
      };
      i += 1;
    };
    return false;
  }

  public final func AddFlag(flag: hitFlag, sourceName: CName) -> Void {
    let f: SHitFlag;
    let insertionIndex: Int32;
    let max: Int32;
    let min: Int32;
    if this.HasFlag(flag) {
      return;
    };
    f.flag = flag;
    f.source = sourceName;
    insertionIndex = 0;
    min = 0;
    max = ArraySize(this.flags) - 1;
    while min < max {
      insertionIndex = (min + max) / 2;
      if Equals(flag, this.flags[insertionIndex].flag) {
        break;
      };
      if flag < this.flags[insertionIndex].flag {
        max = insertionIndex - 1;
      } else {
        min = insertionIndex + 1;
        if min > max {
          insertionIndex += 1;
        };
      };
    };
    ArrayInsert(this.flags, insertionIndex, f);
  }

  public final func RemoveFlag(flag: hitFlag, sourceName: CName) -> Void {
    let f: SHitFlag;
    f.flag = flag;
    f.source = sourceName;
    let removeIndex: Int32 = ArrayFindFirst(this.flags, f);
    if removeIndex >= 0 {
      ArrayErase(this.flags, removeIndex);
    };
  }

  public final func RemoveFlag(flag: hitFlag) -> Void {
    let index: Int32;
    let i: Int32 = 0;
    while i < ArraySize(this.flags) {
      if Equals(this.flags[i].flag, flag) {
        index = i;
        break;
      };
      index = -1;
      i += 1;
    };
    if index >= 0 {
      ArrayErase(this.flags, index);
    };
  }

  public final const func GetFlags() -> [SHitFlag] {
    return this.flags;
  }
}
