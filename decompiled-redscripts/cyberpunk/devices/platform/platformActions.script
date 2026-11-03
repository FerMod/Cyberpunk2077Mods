
public class QuestMoveToFloor extends ActionInt {

  public final func SetProperties(floor: Int32) -> Void {
    this.actionName = n"MoveToFloor";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Int(n"floorNumber", floor);
  }
}

public class QuestMoveToNextFloor extends ActionBool {

  public let floor: NodeRef;

  public final func SetProperties() -> Void {
    this.actionName = n"MoveToNextFloor";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(this.actionName, true, n"MoveToNextFloor", n"MoveToNextFloor");
  }
}

public class QuestMoveToPrevFloor extends ActionBool {

  public let floor: NodeRef;

  public final func SetProperties() -> Void {
    this.actionName = n"MoveToPrevFloor";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(this.actionName, true, n"MoveToPrevFloor", n"MoveToPrevFloor");
  }
}

public class QuestPause extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"Pause";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(this.actionName, true, n"Pause", n"Pause");
  }
}

public class QuestResume extends ActionBool {

  public let pauseTime: Float;

  public final func SetProperties() -> Void {
    this.actionName = n"Resume";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(this.actionName, true, n"Resume", n"Resume");
  }
}
