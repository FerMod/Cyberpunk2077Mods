
public class NanoTechPlatesEffector extends ModifyAttackEffector {

  private let m_chanceToTrigger: Float;

  private let m_chanceIncrement: Float;

  private let m_nanoPlatesStacks: Int32;

  private let m_timeWindow: Float;

  private let m_minTimeBetweenBlocks: Float;

  private let m_timeStamps: [Float];

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_chanceToTrigger = TDB.GetFloat(record + t".chanceToTrigger");
    this.m_chanceIncrement = TDB.GetFloat(record + t".chanceIncrement");
    this.m_nanoPlatesStacks = TDB.GetInt(record + t".nanoPlatesStacks");
    this.m_timeWindow = TDB.GetFloat(record + t".timeWindow");
    this.m_minTimeBetweenBlocks = TDB.GetFloat(record + t".minTimeBetweenBlocks");
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }

  private final func ProcessAction(owner: ref<GameObject>) -> Void {
    let calculatedChance: Float;
    let damage: Float;
    let statusEffectSystem: ref<StatusEffectSystem>;
    let timeStampsSize: Int32;
    let unavailabilityDuration: Float;
    let useIncreasedChance: Bool;
    let timeStamp: Float = EngineTime.ToFloat(GameInstance.GetTimeSystem(owner.GetGame()).GetSimTime());
    let hitEvent: ref<gameHitEvent> = this.GetHitEvent();
    if !IsDefined(hitEvent) {
      return;
    };
    damage = hitEvent.attackComputed.GetTotalAttackValue(gamedataStatPoolType.Health);
    if damage <= 0.00 {
      return;
    };
    statusEffectSystem = GameInstance.GetStatusEffectSystem(owner.GetGame());
    useIncreasedChance = statusEffectSystem.HasStatusEffectWithTag(owner.GetEntityID(), n"NanoTechPlatesAfterDash");
    calculatedChance = this.m_chanceToTrigger + useIncreasedChance ? this.m_chanceIncrement : 0.00;
    if RandF() >= calculatedChance {
      return;
    };
    if useIncreasedChance {
      this.CleanUpTimeStamps(owner, timeStamp);
      timeStampsSize = ArraySize(this.m_timeStamps);
      if timeStampsSize >= this.m_nanoPlatesStacks {
        StatusEffectHelper.RemoveStatusEffectsWithTag(owner, n"NanoTechPlatesAfterDash", 0.00);
        return;
      };
      if timeStampsSize != 0 && AbsF(ArrayLast(this.m_timeStamps) - timeStamp) < this.m_minTimeBetweenBlocks {
        return;
      };
      ArrayPush(this.m_timeStamps, timeStamp);
      timeStampsSize += 1;
    };
    hitEvent.attackComputed.MultAttackValue(0.00);
    StatusEffectHelper.RemoveStatusEffectsWithTag(owner, n"NanoTechPlatesAfterDash", 0.00);
    if useIncreasedChance {
      StatusEffectHelper.ApplyStatusEffectForTimeWindow(owner, t"BaseStatusEffect.NanoTechPlatesBlockIndication", owner.GetEntityID(), 0.00, this.m_timeWindow);
      if timeStampsSize >= this.m_nanoPlatesStacks {
        unavailabilityDuration = this.m_timeStamps[0] + this.m_timeWindow - timeStamp;
        if unavailabilityDuration <= 0.00 {
          unavailabilityDuration = this.m_timeWindow;
        };
        StatusEffectHelper.ApplyStatusEffectForTimeWindow(owner, t"BaseStatusEffect.NanoTechPlatesUnavailableStatusEffect", owner.GetEntityID(), 0.00, unavailabilityDuration);
      };
    };
    GameObject.PlaySound(owner, n"w_cyb_nanotech_plates_deflecting");
  }

  private final func CleanUpTimeStamps(owner: ref<GameObject>, currentTime: Float) -> Void {
    let size: Int32 = ArraySize(this.m_timeStamps);
    let i: Int32 = 0;
    while i < size {
      if this.m_timeStamps[0] < currentTime - this.m_timeWindow {
        ArrayRemove(this.m_timeStamps, this.m_timeStamps[0]);
      } else {
        return;
      };
      i += 1;
    };
  }
}
