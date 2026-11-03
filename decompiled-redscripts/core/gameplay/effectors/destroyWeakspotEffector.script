
public class DestroyWeakspotEffector extends Effector {

  public let m_weakspotIndex: Int32;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_weakspotIndex = TweakDBInterface.GetInt(record + t".weakSpotIndex", 0);
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    let breachComponent: ref<BreachComponent>;
    let breachController: ref<BreachControllerComponent>;
    let gi: GameInstance;
    let i: Int32;
    let weakspot: ref<WeakspotObject>;
    let weakspotComponent: ref<WeakspotComponent>;
    let weakspots: array<wref<WeakspotObject>>;
    let npc: ref<NPCPuppet> = owner as NPCPuppet;
    if !IsDefined(npc) {
      return;
    };
    gi = npc.GetGame();
    if GameInstance.GetGodModeSystem(gi).HasGodMode(npc.GetEntityID(), gameGodModeType.Invulnerable) || GameInstance.GetStatsSystem(gi).GetStatValue(Cast<StatsObjectID>(npc.GetEntityID()), gamedataStatType.IsInvulnerable) > 0.00 {
      return;
    };
    weakspotComponent = npc.GetWeakspotComponent();
    if !IsDefined(weakspotComponent) {
      return;
    };
    weakspotComponent.GetWeakspots(weakspots);
    if ArraySize(weakspots) <= 0 {
      return;
    };
    if this.m_weakspotIndex >= ArraySize(weakspots) {
      return;
    };
    if this.m_weakspotIndex >= 0 {
      weakspot = weakspots[this.m_weakspotIndex];
    } else {
      breachController = npc.GetBreachControllerComponent();
      if IsDefined(breachController) {
        breachComponent = breachController.GetPreviouslyTrackedBreach();
        if IsDefined(breachComponent) {
          weakspot = breachComponent.GetAttachedWeakspot();
        };
      };
      if !IsDefined(weakspot) {
        i = 0;
        while i < ArraySize(weakspots) {
          if !weakspots[i].IsDead() && !weakspots[i].IsInvulnerable() {
            weakspot = weakspots[i];
            break;
          };
          i += 1;
        };
      };
    };
    if !IsDefined(weakspot) || weakspot.IsDead() || weakspot.IsInvulnerable() {
      return;
    };
    ScriptedWeakspotObject.Kill(weakspot, GameInstance.GetPlayerSystem(npc.GetGame()).GetLocalPlayerMainGameObject());
    StatusEffectHelper.ApplyStatusEffect(npc, t"BaseStatusEffect.JustDestroyedWeakspot", npc.GetEntityID());
  }
}

public class DestroyBreachEffector extends Effector {

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    let breachController: ref<BreachControllerComponent>;
    let gi: GameInstance;
    let npc: ref<NPCPuppet> = owner as NPCPuppet;
    if !IsDefined(npc) {
      return;
    };
    gi = npc.GetGame();
    if GameInstance.GetGodModeSystem(gi).HasGodMode(npc.GetEntityID(), gameGodModeType.Invulnerable) || GameInstance.GetStatsSystem(gi).GetStatValue(Cast<StatsObjectID>(npc.GetEntityID()), gamedataStatType.IsInvulnerable) > 0.00 {
      return;
    };
    breachController = npc.GetBreachControllerComponent();
    if IsDefined(breachController) {
      breachController.DestroyPreviouslyTrackedBreach();
    };
  }
}
