
public class ModifyDamageWithLeapedDistance extends ModifyDamageEffector {

  public let m_maxPercentMult: Float;

  public let m_minDistance: Float;

  public let m_maxDistance: Float;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    super.Initialize(record, game, parentRecord);
    this.m_maxPercentMult = TweakDBInterface.GetFloat(record + t".maxPercentMult", 0.00);
    this.m_minDistance = TweakDBInterface.GetFloat(record + t".minDistance", 0.00);
    this.m_maxDistance = TweakDBInterface.GetFloat(record + t".maxDistance", 0.00);
  }

  protected func Uninitialize(game: GameInstance) -> Void;

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    let leapedDistance: Float;
    let playerPerkDataBB: ref<IBlackboard>;
    let hitEvent: ref<gameHitEvent> = this.GetHitEvent();
    if !IsDefined(hitEvent) {
      return;
    };
    playerPerkDataBB = GameInstance.GetBlackboardSystem(owner.GetGame()).Get(GetAllBlackboardDefs().PlayerPerkData);
    if IsDefined(playerPerkDataBB) {
      leapedDistance = playerPerkDataBB.GetFloat(GetAllBlackboardDefs().PlayerPerkData.LeapedDistance);
      if leapedDistance > this.m_maxDistance || this.m_minDistance == this.m_maxDistance || this.m_maxDistance == 0.00 {
        this.ModifyDamage(hitEvent, this.m_operationType, this.m_maxPercentMult);
      } else {
        if leapedDistance > this.m_minDistance {
          this.ModifyDamage(hitEvent, this.m_operationType, 1.00 + ((this.m_maxPercentMult - 1.00) * leapedDistance) / this.m_maxDistance);
        };
      };
    };
  }
}
