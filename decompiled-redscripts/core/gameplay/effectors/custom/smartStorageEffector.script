
public class SmartStorageEffector extends ModifyAttackEffector {

  protected let m_baseRevengeChance: Float;

  protected let m_revengeChanceStep: Float;

  protected let m_revealDuration: Float;

  protected let m_statusEffectForTarget: TweakDBID;

  protected let m_statusEffectForSelf: TweakDBID;

  private let m_currentChance: Float;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_baseRevengeChance = TDB.GetFloat(record + t".baseChance");
    this.m_revengeChanceStep = TDB.GetFloat(record + t".chanceStep");
    this.m_revealDuration = TDB.GetFloat(record + t".revealDuration");
    this.m_statusEffectForTarget = TDB.GetForeignKey(record + t".statusEffectForTarget");
    this.m_statusEffectForSelf = TDB.GetForeignKey(record + t".statusEffectForSelf");
    this.m_currentChance = this.m_baseRevengeChance;
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    let attackInstigator: ref<GameObject>;
    let outlineData: OutlineData;
    let outlineRequestEvt: ref<OutlineRequestEvent>;
    let randomValue: Float;
    let statusEffectSystem: ref<StatusEffectSystem>;
    let hitEvent: ref<gameHitEvent> = this.GetHitEvent();
    if !IsDefined(hitEvent) {
      return;
    };
    attackInstigator = hitEvent.attackData.GetInstigator();
    if !IsDefined(attackInstigator) {
      return;
    };
    if hitEvent.attackComputed.GetTotalAttackValue(gamedataStatPoolType.Health) <= 0.00 {
      return;
    };
    randomValue = RandF();
    if randomValue > this.m_currentChance {
      this.m_currentChance += this.m_revengeChanceStep;
      return;
    };
    statusEffectSystem = GameInstance.GetStatusEffectSystem(owner.GetGame());
    if TDBID.IsValid(this.m_statusEffectForTarget) {
      statusEffectSystem.ApplyStatusEffect(attackInstigator.GetEntityID(), this.m_statusEffectForTarget);
    };
    if TDBID.IsValid(this.m_statusEffectForSelf) {
      statusEffectSystem.ApplyStatusEffect(owner.GetEntityID(), this.m_statusEffectForSelf);
    };
    if this.m_revealDuration > 0.00 {
      outlineData.outlineType = EOutlineType.YELLOW;
      outlineData.outlineOpacity = 0.80;
      outlineRequestEvt = new OutlineRequestEvent();
      outlineRequestEvt.outlineRequest = OutlineRequest.CreateRequest(n"SmartStorageEffector", outlineData, this.m_revealDuration);
      attackInstigator.QueueEvent(outlineRequestEvt);
    };
    hitEvent.attackData.AddFlag(hitFlag.RevengeActivatingHit, n"Smart Storage Revenge");
    this.m_currentChance = this.m_baseRevengeChance;
  }
}
