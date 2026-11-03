
public class ProximityDetectorController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<ProximityDetectorControllerPS> {
    return this.GetBasePS() as ProximityDetectorControllerPS;
  }
}

public class ProximityDetectorControllerPS extends ScriptableDeviceComponentPS {

  protected func PerformRestart() -> Void;

  public func GetActions(out outActions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    if ToggleON.IsDefaultConditionMet(this, context) && NotEquals(context.requestType, gamedeviceRequestType.Direct) && NotEquals(context.requestType, gamedeviceRequestType.Remote) {
      ArrayPush(outActions, this.ActionToggleON());
    };
    return super.GetActions(outActions, context);
  }

  protected func OnTargetAssessmentRequest(evt: ref<TargetAssessmentRequest>) -> EntityNotificationType {
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected func GetDeviceIconTweakDBID() -> TweakDBID {
    return t"DeviceIcons.SecuritySystemDeviceIcon";
  }

  protected func GetBackgroundTextureTweakDBID() -> TweakDBID {
    return t"DeviceIcons.SecuritySystemDeviceBackground";
  }
}
