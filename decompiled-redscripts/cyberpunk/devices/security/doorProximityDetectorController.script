
public class DoorProximityDetectorController extends ProximityDetectorController {

  public const func GetPS() -> ref<DoorProximityDetectorControllerPS> {
    return this.GetBasePS() as DoorProximityDetectorControllerPS;
  }
}

public class DoorProximityDetectorControllerPS extends ProximityDetectorControllerPS {

  protected func OnSecuritySystemOutput(evt: ref<SecuritySystemOutput>) -> EntityNotificationType {
    super.OnSecuritySystemOutput(evt);
    return EntityNotificationType.SendThisEventToEntity;
  }

  public func GetQuestActionByName(actionName: CName) -> ref<DeviceAction> {
    let action: ref<DeviceAction> = super.GetQuestActionByName(actionName);
    if action == null {
      switch actionName {
        case n"QuestStartGlitch":
          action = this.ActionQuestStartGlitch();
          break;
        case n"QuestStopGlitch":
          action = this.ActionQuestStopGlitch();
      };
    };
    return action;
  }

  public func GetQuestActions(out outActions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    super.GetQuestActions(outActions, context);
    ArrayPush(outActions, this.ActionQuestStartGlitch());
    ArrayPush(outActions, this.ActionQuestStopGlitch());
  }
}
