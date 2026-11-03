
public class ApplyEffectToDismemberedEffector extends Effector {

  protected final func GetDismembermentInfo() -> DismembermentInstigatedInfo {
    let i: Int32;
    let multiPrereqState: ref<MultiPrereqState>;
    let dismembermentPrereqState: ref<DismembermentTriggeredPrereqState> = this.GetPrereqState() as DismembermentTriggeredPrereqState;
    if IsDefined(dismembermentPrereqState) {
      return dismembermentPrereqState.GetDismembermentInfo();
    };
    multiPrereqState = this.GetPrereqState() as MultiPrereqState;
    if IsDefined(multiPrereqState) {
      i = 0;
      while i < ArraySize(multiPrereqState.nestedStates) {
        dismembermentPrereqState = multiPrereqState.nestedStates[i] as DismembermentTriggeredPrereqState;
        if IsDefined(dismembermentPrereqState) {
          return dismembermentPrereqState.GetDismembermentInfo();
        };
        i += 1;
      };
    };
    return new DismembermentInstigatedInfo();
  }
}
