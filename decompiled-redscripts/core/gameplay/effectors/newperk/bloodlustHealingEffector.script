
public class BloodlustHealingEffector extends ApplyEffectToDismemberedEffector {

  public let m_poolSystem: ref<StatPoolsSystem>;

  public let m_maxDistanceSquared: Float;

  public let m_healAmount: Float;

  public let m_usePercent: Bool;

  public let m_lastActivationTime: Float;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_usePercent = TweakDBInterface.GetBool(record + t".usePercent", false);
    this.m_healAmount = TweakDBInterface.GetFloat(record + t".healAmount", 0.00);
    this.m_poolSystem = GameInstance.GetStatPoolsSystem(game);
    this.m_maxDistanceSquared = PowF(TweakDBInterface.GetFloat(record + t".maxDistance", 0.00), 2.00);
    this.m_lastActivationTime = 0.00;
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }

  private final func ProcessAction(owner: ref<GameObject>) -> Void {
    let dismembermentInfo: DismembermentInstigatedInfo;
    let targetPuppet: ref<ScriptedPuppet>;
    let currentTime: Float = EngineTime.ToFloat(GameInstance.GetSimTime(owner.GetGame()));
    if currentTime - this.m_lastActivationTime < 0.50 {
      return;
    };
    dismembermentInfo = this.GetDismembermentInfo();
    if dismembermentInfo.wasTargetAlreadyDead && dismembermentInfo.timeSinceDeath > 0.50 {
      return;
    };
    if dismembermentInfo.wasTargetAlreadyDefeated && dismembermentInfo.timeSinceDefeat > 0.50 {
      return;
    };
    if dismembermentInfo.attackIsExplosion {
      if !dismembermentInfo.weaponRecord.TagsContains(n"RangedWeapon") {
        return;
      };
      if Vector4.DistanceSquared(dismembermentInfo.targetPosition, dismembermentInfo.attackPosition) > 1.00 {
        return;
      };
    };
    targetPuppet = dismembermentInfo.target as ScriptedPuppet;
    if !IsDefined(targetPuppet) || targetPuppet.IsCrowd() {
      return;
    };
    if Vector4.DistanceSquared(owner.GetWorldPosition(), dismembermentInfo.targetPosition) > this.m_maxDistanceSquared {
      return;
    };
    if this.m_poolSystem.GetStatPoolValue(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatPoolType.Overshield, false) <= 0.00 {
      return;
    };
    GameInstance.GetStatPoolsSystem(owner.GetGame()).RequestChangingStatPoolValue(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatPoolType.Overshield, this.m_healAmount, owner, false, this.m_usePercent);
    this.m_lastActivationTime = currentTime;
  }
}
