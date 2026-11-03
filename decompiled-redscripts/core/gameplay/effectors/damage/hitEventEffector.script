
public class HitEventEffector extends Effector {

  protected final func GetHitEvent() -> ref<gameHitEvent> {
    let multiPrereqState: ref<MultiPrereqState>;
    let hitPrereqState: ref<GenericHitPrereqState> = this.GetPrereqState() as GenericHitPrereqState;
    if IsDefined(hitPrereqState) {
      return hitPrereqState.GetHitEvent();
    };
    multiPrereqState = this.GetPrereqState() as MultiPrereqState;
    if IsDefined(multiPrereqState) {
      return this.FindHitEventInMultiPrereq(multiPrereqState);
    };
    return null;
  }

  private final func FindHitEventInMultiPrereq(multiPrereqState: ref<MultiPrereqState>) -> ref<gameHitEvent> {
    let hitPrereqState: ref<GenericHitPrereqState>;
    let nextMultiPrereqState: ref<MultiPrereqState>;
    let result: ref<gameHitEvent>;
    let i: Int32 = 0;
    while i < ArraySize(multiPrereqState.nestedStates) {
      hitPrereqState = multiPrereqState.nestedStates[i] as GenericHitPrereqState;
      if IsDefined(hitPrereqState) {
        return hitPrereqState.GetHitEvent();
      };
      nextMultiPrereqState = multiPrereqState.nestedStates[i] as MultiPrereqState;
      if IsDefined(nextMultiPrereqState) {
        result = this.FindHitEventInMultiPrereq(nextMultiPrereqState);
        if IsDefined(result) {
          return result;
        };
      };
      i += 1;
    };
    return result;
  }
}
