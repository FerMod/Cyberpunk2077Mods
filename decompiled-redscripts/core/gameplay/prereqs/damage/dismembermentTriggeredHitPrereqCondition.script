
public class DismembermentTriggeredHitPrereqCondition extends BaseHitPrereqCondition {

  @default(DismembermentTriggeredHitPrereqCondition, 0)
  private let m_currValue: Uint32;

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    let bb: ref<IBlackboard> = GameInstance.GetBlackboardSystem(hitEvent.attackData.GetInstigator().GetGame()).Get(GetAllBlackboardDefs().PlayerPerkData);
    let dismembermentInfo: DismembermentInstigatedInfo = FromVariant<DismembermentInstigatedInfo>(bb.GetVariant(GetAllBlackboardDefs().PlayerPerkData.DismembermentInstigated));
    if this.m_currValue != dismembermentInfo.value {
      this.m_currValue = dismembermentInfo.value;
      return true;
    };
    return false;
  }
}
