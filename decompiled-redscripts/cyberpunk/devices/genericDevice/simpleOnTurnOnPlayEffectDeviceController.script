
public class SimpleOnTurnOnPlayEffectDeviceController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<SimpleOnTurnOnPlayEffectDeviceControllerPS> {
    return this.GetBasePS() as SimpleOnTurnOnPlayEffectDeviceControllerPS;
  }
}

public class SimpleOnTurnOnPlayEffectDeviceControllerPS extends ScriptableDeviceComponentPS {

  protected func GameAttached() -> Void;

  protected func LogicReady() -> Void {
    super.LogicReady();
    this.m_isAttachedToGame = true;
  }
}
