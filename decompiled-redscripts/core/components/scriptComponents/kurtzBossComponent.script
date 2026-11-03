
public class KurtzBossComponent extends ScriptableComponent {

  private let m_owner: wref<NPCPuppet>;

  private let m_owner_id: EntityID;

  private final func OnGameAttach() -> Void {
    this.m_owner = this.GetOwner() as NPCPuppet;
    this.m_owner_id = this.m_owner.GetEntityID();
    StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"BaseStatusEffect.BossNoTakeDownInfinite", this.m_owner_id);
  }

  protected cb func OnAIEvent(aiEvent: ref<AIEvent>) -> Bool {
    switch aiEvent.name {
      case n"KnifeOff":
        this.m_owner.ScheduleAppearanceChange(n"kurt_pistol_knfe_off_pistol_on");
        break;
      case n"KnifeOn":
        if NotEquals(this.m_owner.GetCurrentAppearanceName(), n"kurt_bossfight") {
          this.m_owner.ScheduleAppearanceChange(n"kurt_bossfight");
        };
    };
  }

  protected cb func OnDefeated(evt: ref<DefeatedEvent>) -> Bool {
    StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"AdamSmasher.Invulnerable", this.m_owner_id);
  }

  protected cb func OnDeath(evt: ref<gameDeathEvent>) -> Bool;

  protected cb func OnStatusEffectApplied(evt: ref<ApplyStatusEffectEvent>) -> Bool {
    let tags: array<CName> = evt.staticData.GameplayTags();
    if ArrayContains(tags, n"BossGrenadeHackEffect") {
      StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"BaseStatusEffect.SasquatchSuicideWithGrenade", this.m_owner_id);
    };
    if StatusEffectSystem.ObjectHasStatusEffect(this.m_owner, t"Oda.Main_boss_oda_allow_knockdown") {
      StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"BaseStatusEffect.Knockdown", this.m_owner_id);
    };
    if ArrayContains(tags, n"BossSuicide") {
      StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"BaseStatusEffect.SuicideWithWeapon", this.m_owner_id);
      StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"Sasquatch.ForceStaggerSuicide", this.m_owner_id);
    };
  }

  protected cb func OnStatusEffectRemoved(evt: ref<RemoveStatusEffect>) -> Bool {
    let tags: array<CName> = evt.staticData.GameplayTags();
    if ArrayContains(tags, n"Madness") {
      StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"BaseStatusEffect.SuicideWithWeapon", this.m_owner_id);
      StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"Sasquatch.ForceStaggerSuicide", this.m_owner_id);
    };
  }
}
