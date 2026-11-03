
public class ElectricBoxInkGameController extends DeviceInkGameControllerBase {

  private let m_onOverrideListener: ref<CallbackHandle>;

  protected func RegisterBlackboardCallbacks(blackboard: ref<IBlackboard>) -> Void {
    super.RegisterBlackboardCallbacks(blackboard);
    if IsDefined(blackboard) {
      this.m_onOverrideListener = blackboard.RegisterListenerBool(this.GetOwner().GetBlackboardDef() as ElectricBoxBlackboardDef.isOverriden, this, n"OnOverride");
    };
  }

  protected func UnRegisterBlackboardCallbacks(blackboard: ref<IBlackboard>) -> Void {
    super.UnRegisterBlackboardCallbacks(blackboard);
    if IsDefined(blackboard) {
      blackboard.UnregisterListenerBool(this.GetOwner().GetBlackboardDef() as ElectricBoxBlackboardDef.isOverriden, this.m_onOverrideListener);
    };
  }

  protected cb func OnOverride(value: Bool) -> Bool {
    if value {
      this.PlayLibraryAnimation(n"on_to_off");
    };
  }
}
