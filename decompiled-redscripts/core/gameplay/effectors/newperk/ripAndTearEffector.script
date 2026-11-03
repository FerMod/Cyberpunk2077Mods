
public class RipAndTearEffector extends ModifyDamageEffector {

  public let m_sfxName: CName;

  public let m_vfxName: CName;

  public let m_statusEffectToRemove: String;

  public let m_prevCleanupTime: EngineTime;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    super.Initialize(record, game, parentRecord);
    this.m_sfxName = TDB.GetCName(record + t".sfxName");
    this.m_vfxName = TDB.GetCName(record + t".vfxName");
    this.m_statusEffectToRemove = TDB.GetString(record + t".statusEffectToRemove");
    this.m_prevCleanupTime = EngineTime.FromFloat(0.00);
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    super.RepeatedAction(owner);
    this.ProcessAction(owner);
  }

  private final func ProcessAction(owner: ref<GameObject>) -> Void {
    if this.m_prevCleanupTime != GameInstance.GetSimTime(owner.GetGame()) {
      this.m_prevCleanupTime = GameInstance.GetSimTime(owner.GetGame());
      GameObject.PlaySound(owner, this.m_sfxName, n"RipAndTearEffector");
      GameObjectEffectHelper.StartEffectEvent(owner, this.m_vfxName);
      StatusEffectHelper.RemoveStatusEffect(owner, TDBID.Create(this.m_statusEffectToRemove));
    };
  }
}
