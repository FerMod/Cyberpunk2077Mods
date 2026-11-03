
public class SetTimeDilationEffector extends Effector {

  public let m_owner: wref<GameObject>;

  public let m_reason: CName;

  public let m_easeInCurve: CName;

  public let m_easeOutCurve: CName;

  public let m_dilation: Float;

  public let m_duration: Float;

  public let m_affectsPlayer: Bool;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_reason = TDB.GetCName(record + t".reason");
    this.m_dilation = TDB.GetFloat(record + t".dilation");
    this.m_duration = TDB.GetFloat(record + t".duration");
    this.m_easeInCurve = TDB.GetCName(record + t".easeInCurve");
    this.m_easeOutCurve = TDB.GetCName(record + t".easeOutCurve");
    this.m_affectsPlayer = TDB.GetBool(record + t".affectsPlayer");
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    let timeSystem: ref<TimeSystem>;
    if timeSystem.IsTimeDilationActive() || this.m_duration == 0.00 {
      return;
    };
    this.m_owner = owner;
    timeSystem = GameInstance.GetTimeSystem(this.m_owner.GetGame());
    if IsDefined(this.m_owner) && IsDefined(timeSystem) {
      if !this.m_affectsPlayer {
        timeSystem.SetIgnoreTimeDilationOnLocalPlayerZero(true);
      };
      timeSystem.SetTimeDilation(this.m_reason, this.m_dilation, this.m_duration, this.m_easeInCurve, this.m_easeOutCurve);
    };
  }

  protected func ActionOff(owner: ref<GameObject>) -> Void {
    let timeSystem: ref<TimeSystem>;
    if IsDefined(this.m_owner) && this.m_duration > 0.00 {
      timeSystem = GameInstance.GetTimeSystem(this.m_owner.GetGame());
      if IsDefined(timeSystem) {
        timeSystem.UnsetTimeDilation(this.m_reason, Equals(this.m_reason, n"berserk") ? n"None" : this.m_easeOutCurve);
      };
    };
  }
}
