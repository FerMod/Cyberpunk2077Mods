
public class OvershieldEffectorBase extends ContinuousEffector {

  public let m_statSystem: ref<StatsSystem>;

  public let m_poolSystem: ref<StatPoolsSystem>;

  public let m_immunityTypes: [ref<gameStatModifierData>];

  public let m_modifiersAdded: Bool;

  public let m_owner: wref<GameObject>;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_statSystem = GameInstance.GetStatsSystem(game);
    this.m_poolSystem = GameInstance.GetStatPoolsSystem(game);
    this.m_modifiersAdded = false;
    this.m_immunityTypes = this.SetStatsToModify();
  }

  protected func ContinuousAction(owner: ref<GameObject>, instigator: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }

  protected func ProcessAction(owner: ref<GameObject>) -> Void {
    let i: Int32;
    let overShieldValue: Float = this.m_poolSystem.GetStatPoolValue(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatPoolType.Overshield, false);
    if overShieldValue > 0.00 {
      if !this.m_modifiersAdded {
        i = 0;
        while i < ArraySize(this.m_immunityTypes) {
          this.m_statSystem.AddModifier(Cast<StatsObjectID>(owner.GetEntityID()), this.m_immunityTypes[i]);
          i += 1;
        };
      };
      this.m_modifiersAdded = true;
    } else {
      if this.m_modifiersAdded {
        i = 0;
        while i < ArraySize(this.m_immunityTypes) {
          this.m_statSystem.RemoveModifier(Cast<StatsObjectID>(owner.GetEntityID()), this.m_immunityTypes[i]);
          i += 1;
        };
      };
      this.m_modifiersAdded = false;
    };
  }

  protected func SetStatsToModify() -> [ref<gameStatModifierData>] {
    let result: array<ref<gameStatModifierData>>;
    return result;
  }
}
