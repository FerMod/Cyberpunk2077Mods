
public class CleaningMachineController extends BasicDistractionDeviceController {

  public const func GetPS() -> ref<CleaningMachineControllerPS> {
    return this.GetBasePS() as CleaningMachineControllerPS;
  }
}

public class CleaningMachineControllerPS extends BasicDistractionDeviceControllerPS {

  protected inline let m_cleaningMachineSkillChecks: ref<EngDemoContainer>;

  protected func GetSkillCheckContainerForSetup() -> ref<BaseSkillCheckContainer> {
    return this.m_cleaningMachineSkillChecks;
  }

  protected func GameAttached() -> Void;
}
