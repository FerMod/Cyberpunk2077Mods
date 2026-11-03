
public class GiveRewardEffector extends Effector {

  public let m_reward: TweakDBID;

  public let m_target: EntityID;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    let str: String = TweakDBInterface.GetString(record + t".reward", "");
    this.m_reward = TDBID.Create(str);
  }

  protected func Uninitialize(game: GameInstance) -> Void;

  private final func ProcessAction(owner: ref<GameObject>) -> Void {
    this.GetApplicationTarget(owner, n"Target", this.m_target);
    if EntityID.IsDefined(this.m_target) {
      RPGManager.GiveReward(owner.GetGame(), this.m_reward, Cast<StatsObjectID>(this.m_target));
    } else {
      RPGManager.GiveReward(owner.GetGame(), this.m_reward);
    };
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }

  protected func ActionOff(owner: ref<GameObject>) -> Void;
}
