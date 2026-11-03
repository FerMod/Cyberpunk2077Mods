
public class JuggernautEffector extends ContinuousEffector {

  public let m_modifiersAdded: Bool;

  public let m_poolSystem: ref<StatPoolsSystem>;

  public let m_statusEffectSystem: ref<StatusEffectSystem>;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_modifiersAdded = false;
    this.m_poolSystem = GameInstance.GetStatPoolsSystem(game);
    this.m_statusEffectSystem = GameInstance.GetStatusEffectSystem(game);
  }

  protected func ContinuousAction(owner: ref<GameObject>, instigator: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }

  protected func ProcessAction(owner: ref<GameObject>) -> Void {
    if this.m_poolSystem.GetStatPoolValue(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatPoolType.Overshield, false) > 0.00 {
      if !this.m_modifiersAdded {
        this.m_statusEffectSystem.ApplyStatusEffect(owner.GetEntityID(), t"BaseStatusEffect.JuggernautBuff");
        this.m_modifiersAdded = true;
      };
    } else {
      if this.m_modifiersAdded {
        this.m_statusEffectSystem.RemoveStatusEffect(owner.GetEntityID(), t"BaseStatusEffect.JuggernautBuff");
        this.m_modifiersAdded = false;
      };
    };
  }
}
