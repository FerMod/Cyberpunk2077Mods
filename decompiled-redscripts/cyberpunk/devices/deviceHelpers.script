
public class DeviceDebuggerComponent extends ScriptableComponent {

  private let m_isActive: Bool;

  private let m_exclusiveModeTriggered: Bool;

  private let m_currentDeviceProperties: DebuggerProperties;

  private let m_debuggedDevice: wref<Device>;

  private let m_debuggerColor: EDebuggerColor;

  @default(DeviceDebuggerComponent, NONE)
  private let m_previousContext: String;

  @default(DeviceDebuggerComponent, NONE)
  private let m_cachedContext: String;

  private let m_layerIDs: [Uint32];

  protected cb func OnRegisterDebuggerCandidate(evt: ref<RegisterDebuggerCanditateEvent>) -> Bool {
    if this.m_exclusiveModeTriggered && IsDefined(this.m_debuggedDevice) {
      if !IsFinal() {
      };
      return false;
    };
    if evt.m_device == this.m_debuggedDevice {
      if !IsFinal() {
      };
      return false;
    };
    if !evt.m_device.ShouldInitiateDebug() {
      if !IsFinal() {
      };
      return false;
    };
    if IsDefined(evt.m_device) {
      if !IsFinal() {
      };
      this.m_debuggedDevice = evt.m_device;
      this.m_currentDeviceProperties = this.m_debuggedDevice.GetDebuggerProperties();
      this.m_exclusiveModeTriggered = this.m_currentDeviceProperties.m_exclusiveMode;
      this.ToggleDebuggerColor();
      return true;
    };
    if !IsFinal() {
    };
    return false;
  }

  protected final func OnUpdate(deltaTime: Float) -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_layerIDs) {
      GameInstance.GetDebugVisualizerSystem(this.GetOwner().GetGame()).ClearLayer(this.m_layerIDs[i]);
      i += 1;
    };
    if !IsDefined(this.m_debuggedDevice) || !this.IsFactValid() {
      return;
    };
    this.PerformDebug();
  }

  private final func PerformDebug() -> Void {
    let actions: array<ref<DeviceAction>>;
    let context: GetActionsContext;
    let distance: Float;
    let dynamicPosition: Vector4;
    let i: Int32;
    let positionDevice: Vector4;
    let positionDistance: Vector4;
    let positionLayer: Vector4;
    let positionPreviousLayer: Vector4;
    let separator: String;
    let separatorPosition: Vector4;
    let statusPosition: Vector4;
    let textActions: array<String>;
    let textDevice: String;
    let textDistance: String;
    let textLayer: String;
    let textPreviousLayer: String;
    let textStatus: String;
    let verticalAxis: Float;
    let verticalDistance: Float;
    let verticalStartingPos: Float;
    ArrayClear(this.m_layerIDs);
    verticalDistance = 20.00;
    verticalStartingPos = 180.00;
    verticalAxis = verticalStartingPos;
    positionDevice = new Vector4(100.00, verticalAxis, 0.00, 0.00);
    verticalAxis += verticalDistance;
    positionLayer = new Vector4(100.00, verticalAxis, 0.00, 0.00);
    verticalAxis += verticalDistance;
    positionPreviousLayer = new Vector4(100.00, verticalAxis, 0.00, 0.00);
    verticalAxis += verticalDistance;
    positionDistance = new Vector4(100.00, verticalAxis, 0.00, 0.00);
    verticalAxis += verticalDistance;
    separatorPosition = new Vector4(100.00, verticalAxis, 0.00, 0.00);
    verticalAxis += verticalDistance;
    statusPosition = new Vector4(100.00, verticalAxis, 0.00, 0.00);
    verticalAxis += verticalDistance;
    separator = " ------------ ";
    distance = Vector4.Distance(this.m_debuggedDevice.GetWorldPosition(), GameInstance.GetPlayerSystem(this.GetOwner().GetGame()).GetLocalPlayerMainGameObject().GetWorldPosition());
    this.m_debuggedDevice.GetActionsDebug(context, this, actions);
    textDevice = "DEVICE: " + this.m_debuggedDevice.GetDeviceName();
    textLayer = "CONTEXT: " + NameToString(context.interactionLayerTag);
    if NotEquals(textLayer, this.m_cachedContext) {
      this.m_previousContext = this.m_cachedContext;
      this.m_cachedContext = textLayer;
    };
    textPreviousLayer = "PREV CONTEXT: " + this.m_previousContext;
    textDistance = "DISTANCE :" + FloatToString(distance);
    textStatus = "STATUS: " + this.m_debuggedDevice.GetDeviceStatusString();
    i = 0;
    while i < ArraySize(actions) {
      ArrayPush(textActions, actions[i].GetCurrentDisplayString());
      i += 1;
    };
    this.AddDebugBit(positionDevice, textDevice, this.GetColor());
    this.AddDebugBit(positionLayer, textLayer, this.GetColor());
    this.AddDebugBit(positionPreviousLayer, textPreviousLayer, this.GetColor(true));
    this.AddDebugBit(positionDistance, textDistance, this.GetColor());
    this.AddDebugBit(separatorPosition, separator, this.GetColor());
    this.AddDebugBit(statusPosition, textStatus, this.GetColor());
    i = 0;
    while i < ArraySize(textActions) {
      dynamicPosition = new Vector4(100.00, verticalAxis, 0.00, 0.00);
      this.AddDebugBit(dynamicPosition, textActions[i], this.GetColor());
      verticalAxis += verticalDistance;
      i += 1;
    };
    if this.GetQuestsSystem().GetFact(n"disableLine") == 0 {
      this.DrawDbgLine();
    };
  }

  private final func DrawDbgLine() -> Void {
    let devicePos: Vector4;
    let playerPos: Vector4 = this.GetPlayerSystem().GetLocalPlayerMainGameObject().GetWorldPosition();
    playerPos.Z += 1.50;
    devicePos = this.m_debuggedDevice.GetWorldPosition();
    devicePos.Z += 1.50;
    ArrayPush(this.m_layerIDs, this.GetDebugVisualizerSystem().DrawLine3D(playerPos, devicePos, this.GetColor()));
  }

  private final func IsFactValid() -> Bool {
    return this.m_debuggedDevice.ShouldInitiateDebug();
  }

  private final func AddDebugBit(position: Vector4, const text: script_ref<String>, color: Color) -> Void {
    ArrayPush(this.m_layerIDs, GameInstance.GetDebugVisualizerSystem(this.GetOwner().GetGame()).DrawText(position, Deref(text), color));
  }

  private final func GetColor(opt reverse: Bool) -> Color {
    if Equals(this.m_debuggerColor, EDebuggerColor.RED) {
      if reverse {
        return SColor.Yellow();
      };
      return SColor.Red();
    };
    if reverse {
      return SColor.Red();
    };
    return SColor.Yellow();
  }

  private final func ToggleDebuggerColor() -> Void {
    if Equals(this.m_debuggerColor, EDebuggerColor.RED) {
      this.m_debuggerColor = EDebuggerColor.YELLOW;
    } else {
      this.m_debuggerColor = EDebuggerColor.RED;
    };
  }
}

public struct DeviceHelper {

  public final static func IDMO(gameInstance: GameInstance) -> Bool {
    return DeviceHelper.IsDebugModeON(gameInstance);
  }

  public final static func IsDebugModeON(gameInstance: GameInstance) -> Bool {
    let val: Int32 = GameInstance.GetQuestsSystem(gameInstance).GetFact(n"dbgDevices");
    if val > 0 {
      return true;
    };
    return false;
  }

  public final static func DebugLog(gameInstance: GameInstance, const message: script_ref<String>) -> Void {
    if DeviceHelper.IsDebugModeON(gameInstance) {
      GameInstance.GetActivityLogSystem(gameInstance).AddLog(Deref(message));
    };
  }

  public final static func ExtractSpecificStateClass(const states: script_ref<[ref<PersistentState>]>, desiredClassName: CName, extractedStates: [ref<PersistentState>]) -> Bool {
    let wasSuccessful: Bool;
    let i: Int32 = 0;
    while i < ArraySize(Deref(states)) {
      if Equals(Deref(states)[i].GetClassName(), desiredClassName) {
        ArrayPush(extractedStates, Deref(states)[i]);
        wasSuccessful = true;
      };
      i += 1;
    };
    return wasSuccessful;
  }

  public final static func ConvertActionsArray(const puppetActions: script_ref<[ref<PuppetAction>]>) -> [ref<DeviceAction>] {
    let deviceActions: array<ref<DeviceAction>>;
    let i: Int32 = 0;
    while i < ArraySize(Deref(puppetActions)) {
      ArrayPush(deviceActions, Deref(puppetActions)[i]);
      i += 1;
    };
    return deviceActions;
  }

  public final static func ConvertActionIntoScriptableAction(const inActions: script_ref<[ref<DeviceAction>]>, outActions: script_ref<[ref<ScriptableDeviceAction>]>) -> Bool {
    let i: Int32 = 0;
    while i < ArraySize(Deref(inActions)) {
      ArrayPush(Deref(outActions), Deref(inActions)[i] as ScriptableDeviceAction);
      i += 1;
    };
    if ArraySize(Deref(inActions)) == ArraySize(Deref(outActions)) {
      return true;
    };
    return false;
  }

  public final static func PushActionsIntoInteractionChoice(choice: script_ref<InteractionChoice>, const actions: script_ref<[ref<DeviceAction>]>) -> Void {
    let i: Int32 = 0;
    while i < ArraySize(Deref(actions)) {
      ArrayPush(Deref(choice).data, ToVariant(Deref(actions)[i]));
      i += 1;
    };
  }

  public final static func FindAction(actionName: CName, const actions: script_ref<[ref<DeviceAction>]>, out foundAction: ref<DeviceAction>) -> Int32 {
    let i: Int32 = 0;
    while i < ArraySize(Deref(actions)) {
      if Equals(Deref(actions)[i].actionName, actionName) {
        foundAction = Deref(actions)[i];
        return i;
      };
      i += 1;
    };
    return -1;
  }

  public final static func RemoveActionFromArray(actionName: CName, actions: script_ref<[ref<DeviceAction>]>) -> Void {
    let dummyAction: ref<DeviceAction>;
    let index: Int32 = DeviceHelper.FindAction(actionName, actions, dummyAction);
    if index < 0 {
      return;
    };
    ArrayErase(Deref(actions), index);
  }

  public final static func FindStatusAction(const actions: script_ref<[ref<DeviceAction>]>, out status: ref<BaseDeviceStatus>) -> Int32 {
    let i: Int32 = 0;
    while i < ArraySize(Deref(actions)) {
      if IsDefined(Deref(actions)[i] as BaseDeviceStatus) {
        status = Deref(actions)[i] as BaseDeviceStatus;
        return i;
      };
      i += 1;
    };
    return -1;
  }

  public final static func RemoveStatusAction(actions: script_ref<[ref<DeviceAction>]>) -> Bool {
    let i: Int32 = 0;
    while i < ArraySize(Deref(actions)) {
      if IsDefined(Deref(actions)[i] as BaseDeviceStatus) {
        ArrayErase(Deref(actions), i);
        return true;
      };
      i += 1;
    };
    return false;
  }
}

public static func DebugDevices(gameInstance: GameInstance, shouldDebug: Bool) -> Void {
  if shouldDebug {
    SetFactValue(gameInstance, n"dbgDevices", 1);
    if !IsFinal() {
    };
  } else {
    SetFactValue(gameInstance, n"dbgDevices", 0);
    if !IsFinal() {
    };
  };
}
