
public class OverclockHudListener extends ScriptStatusEffectListener {

  private let m_hudController: wref<inkHUDGameController>;

  public final func BindHudController(hudController: wref<inkHUDGameController>) -> Void {
    this.m_hudController = hudController;
  }

  public func OnStatusEffectApplied(statusEffect: wref<StatusEffect_Record>) -> Void {
    let overclockHudEvent: ref<OverclockHudEvent>;
    if statusEffect.GetID() == t"BaseStatusEffect.Intelligence_Central_Milestone_3_Overclock_Buff" {
      overclockHudEvent = new OverclockHudEvent();
      overclockHudEvent.m_activated = true;
      this.m_hudController.QueueEvent(overclockHudEvent);
    };
  }

  public func OnStatusEffectRemoved(statusEffect: wref<StatusEffect_Record>) -> Void {
    let overclockHudEvent: ref<OverclockHudEvent>;
    if statusEffect.GetID() == t"BaseStatusEffect.Intelligence_Central_Milestone_3_Overclock_Buff" {
      overclockHudEvent = new OverclockHudEvent();
      overclockHudEvent.m_activated = false;
      this.m_hudController.QueueEvent(overclockHudEvent);
    };
  }
}
