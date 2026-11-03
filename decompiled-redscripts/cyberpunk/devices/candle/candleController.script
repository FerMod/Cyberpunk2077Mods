
public class CandleController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<CandleControllerPS> {
    return this.GetBasePS() as CandleControllerPS;
  }
}

public class CandleControllerPS extends ScriptableDeviceComponentPS {

  protected inline let m_candleSkillChecks: ref<EngDemoContainer>;

  protected func GetSkillCheckContainerForSetup() -> ref<BaseSkillCheckContainer> {
    return this.m_candleSkillChecks;
  }

  protected func GameAttached() -> Void;

  public func GetActions(out actions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    ArrayPush(actions, this.ActionToggleON());
    return true;
  }

  protected func GetBackgroundTextureTweakDBID() -> TweakDBID {
    return t"DeviceIcons.LightDeviceBackground";
  }

  protected func GetDeviceIconTweakDBID() -> TweakDBID {
    return t"DeviceIcons.LightDeviceIcon";
  }
}
