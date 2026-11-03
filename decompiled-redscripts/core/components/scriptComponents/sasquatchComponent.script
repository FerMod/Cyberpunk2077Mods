
public class SasquatchComponent extends ScriptableComponent {

  private let m_owner: wref<NPCPuppet>;

  private let m_owner_id: EntityID;

  private let m_weakspotDestroyed: Bool;

  private let m_player: wref<PlayerPuppet>;

  public final func OnGameAttach() -> Void {
    this.m_owner = this.GetOwner() as NPCPuppet;
    this.m_owner_id = this.m_owner.GetEntityID();
    this.m_weakspotDestroyed = false;
    if !this.m_owner.IsDead() {
      StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"Sasquatch.Phase1", this.m_owner.GetEntityID());
      StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"BaseStatusEffect.PainInhibitors", this.m_owner.GetEntityID());
      StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"Sasquatch.Healing", this.m_owner.GetEntityID());
    };
    this.m_player = this.GetPlayerSystem().GetLocalPlayerControlledGameObject() as PlayerPuppet;
    StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"BaseStatusEffect.DamageHackNoReaction", this.m_owner_id);
  }

  protected cb func OnStatusEffectApplied(evt: ref<ApplyStatusEffectEvent>) -> Bool {
    let tags: array<CName> = evt.staticData.GameplayTags();
    let weapon: wref<WeaponObject> = ScriptedPuppet.GetWeaponRight(this.m_owner);
    let weaponType: gamedataItemType = WeaponObject.GetWeaponType(weapon.GetItemID());
    if ArrayContains(tags, n"WeakspotDestruction") {
      StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"BaseStatusEffect.BossNoTakeDown", this.m_owner.GetEntityID());
      if Equals(weaponType, gamedataItemType.Wea_Hammer) {
        this.m_owner.DropWeapons();
        AIActionHelper.TryStartCombatWithTarget(this.m_owner, this.m_player);
      };
    };
    if ArrayContains(tags, n"BossSuicide") {
      StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"BaseStatusEffect.SuicideWithWeapon", this.m_owner.GetEntityID());
      StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"Sasquatch.ForceStaggerSuicide", this.m_owner_id);
    };
    if ArrayContains(tags, n"BossGrenadeHackEffect") {
      StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"Sasquatch.BurningGrenade", this.m_owner_id);
      StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"BaseStatusEffect.SasquatchSuicideWithGrenade", this.m_owner_id);
    };
  }

  protected cb func OnStatusEffectRemoved(evt: ref<RemoveStatusEffect>) -> Bool {
    let tags: array<CName> = evt.staticData.GameplayTags();
    if ArrayContains(tags, n"Madness") {
      StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"BaseStatusEffect.SuicideWithWeapon", this.m_owner.GetEntityID());
      StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"Sasquatch.ForceStaggerSuicide", this.m_owner_id);
    };
  }

  private final func DestroyAllWeakspots() -> Void {
    let i: Int32;
    let scriptWeakspot: ref<ScriptedWeakspotObject>;
    let weakspots: array<wref<WeakspotObject>>;
    this.m_owner.GetWeakspotComponent().GetWeakspots(weakspots);
    if ArraySize(weakspots) > 0 {
      i = 0;
      while i < ArraySize(weakspots) {
        scriptWeakspot = weakspots[i] as ScriptedWeakspotObject;
        scriptWeakspot.DestroyWeakspot(this.m_owner);
        ScriptedWeakspotObject.Kill(weakspots[i]);
        i += 1;
      };
    };
  }

  protected cb func OnDefeatedSasquatch(evt: ref<DefeatedEvent>) -> Bool {
    let player: wref<PlayerPuppet> = this.GetPlayerSystem().GetLocalPlayerControlledGameObject() as PlayerPuppet;
    StatusEffectHelper.RemoveStatusEffect(player, t"BaseStatusEffect.NetwatcherGeneral");
    StatusEffectHelper.RemoveStatusEffect(this.m_owner, t"Sasquatch.Phase1");
    StatusEffectHelper.RemoveStatusEffect(this.m_owner, t"BaseStatusEffect.PainInhibitors");
    StatusEffectHelper.RemoveStatusEffect(this.m_owner, t"Sasquatch.Healing");
    StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"AdamSmasher.InvulnerableDefeated", this.m_owner_id);
  }

  protected cb func OnDeath(evt: ref<gameDeathEvent>) -> Bool {
    StatusEffectHelper.RemoveStatusEffect(this.m_owner, t"Sasquatch.Phase1");
    StatusEffectHelper.RemoveStatusEffect(this.m_owner, t"BaseStatusEffect.PainInhibitors");
    StatusEffectHelper.RemoveStatusEffect(this.m_owner, t"Sasquatch.Healing");
  }
}
