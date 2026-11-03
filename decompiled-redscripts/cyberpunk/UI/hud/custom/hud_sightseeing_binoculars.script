
public class hudSightseeingBinocularsController extends CustomAnimationsHudGameController {

  @default(hudSightseeingBinocularsController, -360)
  private let pitch_min: Float;

  @default(hudSightseeingBinocularsController, 360)
  private let pitch_max: Float;

  @default(hudSightseeingBinocularsController, -640)
  private let yaw_min: Float;

  @default(hudSightseeingBinocularsController, 640)
  private let yaw_max: Float;

  @default(hudSightseeingBinocularsController, -360)
  private let tele_min: Float;

  @default(hudSightseeingBinocularsController, 360)
  private let tele_max: Float;

  @default(hudSightseeingBinocularsController, .75)
  private let tele_scale: Float;

  @default(hudSightseeingBinocularsController, 4)
  private let max_zoom_level: Float;

  private edit let m_background: inkCanvasRef;

  private let m_psmBlackboard: wref<IBlackboard>;

  private let m_tcsBlackboard: wref<IBlackboard>;

  private let m_PSM_BBID: ref<CallbackHandle>;

  private let m_tcs_BBID: ref<CallbackHandle>;

  private let m_deviceChain_BBID: ref<CallbackHandle>;

  private let m_currentZoom: Float;

  private let m_controlledObjectRef: wref<GameObject>;

  private let m_alpha_fadein: ref<inkAnimDef>;

  private let m_AnimProxy: ref<inkAnimProxy>;

  private let m_AnimOptions: inkAnimOptions;

  private let m_ownerObject: wref<GameObject>;

  private let m_maxZoomLevel: Int32;

  protected cb func OnInitialize() -> Bool {
    let alphaInterpolator: ref<inkAnimTransparency>;
    let delayInitialize: ref<DelayedHUDInitializeEvent>;
    this.m_root = this.GetRootWidget() as inkCompoundWidget;
    this.m_ownerObject = this.GetOwnerEntity() as GameObject;
    this.m_tcsBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().DeviceTakeControl);
    if IsDefined(this.m_tcsBlackboard) {
      this.m_tcs_BBID = this.m_tcsBlackboard.RegisterDelayedListenerEntityID(GetAllBlackboardDefs().DeviceTakeControl.ActiveDevice, this, n"OnChangeControlledDevice");
      this.m_deviceChain_BBID = this.m_tcsBlackboard.RegisterListenerVariant(GetAllBlackboardDefs().DeviceTakeControl.DevicesChain, this, n"OnTakeControllOverDevice");
      this.OnChangeControlledDevice(this.m_tcsBlackboard.GetEntityID(GetAllBlackboardDefs().DeviceTakeControl.ActiveDevice));
      this.OnTakeControllOverDevice(this.m_tcsBlackboard.GetVariant(GetAllBlackboardDefs().DeviceTakeControl.DevicesChain));
    };
    this.UpdateRulers();
    this.m_alpha_fadein = new inkAnimDef();
    alphaInterpolator = new inkAnimTransparency();
    alphaInterpolator.SetDuration(1.00);
    alphaInterpolator.SetStartTransparency(1.00);
    alphaInterpolator.SetEndTransparency(1.00);
    alphaInterpolator.SetType(inkanimInterpolationType.Linear);
    alphaInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    this.m_alpha_fadein.AddInterpolator(alphaInterpolator);
    this.m_AnimOptions.playReversed = false;
    this.m_AnimOptions.executionDelay = 0.00;
    this.m_AnimOptions.loopType = inkanimLoopType.Cycle;
    this.m_AnimOptions.loopInfinite = true;
    this.m_AnimProxy = this.m_root.PlayAnimationWithOptions(this.m_alpha_fadein, this.m_AnimOptions);
    this.m_AnimProxy.RegisterToCallback(inkanimEventType.OnEndLoop, this, n"OnEndLoop");
    this.GetPlayerControlledObject().RegisterInputListener(this);
    delayInitialize = new DelayedHUDInitializeEvent();
    GameInstance.GetDelaySystem(this.GetPlayerControlledObject().GetGame()).DelayEvent(this.GetPlayerControlledObject(), delayInitialize, 0.10);
  }

  protected cb func OnUninitialize() -> Bool {
    this.m_tcsBlackboard.UnregisterListenerEntityID(GetAllBlackboardDefs().DeviceTakeControl.ActiveDevice, this.m_tcs_BBID);
    this.m_tcsBlackboard.UnregisterListenerVariant(GetAllBlackboardDefs().DeviceTakeControl.DevicesChain, this.m_deviceChain_BBID);
    this.m_AnimProxy.UnregisterFromCallback(inkanimEventType.OnEndLoop, this, n"OnEndLoop");
    this.m_AnimProxy.Stop();
    TakeOverControlSystem.CreateInputHint(this.GetPlayerControlledObject().GetGame(), false);
  }

  protected cb func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Bool {
    this.UpdateRulers();
  }

  protected cb func OnEndLoop(proxy: ref<inkAnimProxy>) -> Bool {
    this.UpdateRulers();
  }

  protected cb func OnTakeControllOverDevice(value: Variant) -> Bool;

  private final func UpdateRulers() -> Void {
    let m_pitchMargin: Float;
    let m_yawMargin: Float;
    let pitchPt: Float;
    let yawPt: Float;
    let data: CameraRotationData = (this.m_controlledObjectRef as SensorDevice).GetRotationData();
    let euAngles: EulerAngles = (this.m_controlledObjectRef as SensorDevice).GetRotationFromSlotRotation();
    if data.m_maxPitch == 0.00 {
      data.m_maxPitch = 360.00;
    };
    pitchPt = euAngles.Pitch / AbsF(data.m_maxPitch - data.m_minPitch);
    m_pitchMargin = AbsF(this.pitch_max - this.pitch_min) * pitchPt;
    if data.m_maxYaw == 0.00 {
      data.m_maxYaw = 360.00;
    };
    yawPt = -euAngles.Yaw / AbsF(data.m_maxYaw - data.m_minYaw);
    m_yawMargin = AbsF(this.yaw_max - this.yaw_min) * yawPt;
    inkWidgetRef.SetMargin(this.m_background, m_yawMargin, m_pitchMargin, 0.00, 0.00);
  }

  protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
    this.m_psmBlackboard = this.GetPSMBlackboard(playerPuppet);
    if IsDefined(this.m_psmBlackboard) {
      this.m_PSM_BBID = this.m_psmBlackboard.RegisterDelayedListenerFloat(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel, this, n"OnZoomChange");
      this.m_maxZoomLevel = this.m_psmBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.MaxZoomLevel);
    };
  }

  protected cb func OnPlayerDetach(playerPuppet: ref<GameObject>) -> Bool {
    this.m_psmBlackboard.UnregisterDelayedListener(GetAllBlackboardDefs().PlayerStateMachine.ZoomLevel, this.m_PSM_BBID);
    GameInstance.GetQuestsSystem(this.GetPlayerControlledObject().GetGame()).SetFact(n"sightseeing_binculars_ui_turned_off", 1);
  }

  protected cb func OnChangeControlledDevice(value: EntityID) -> Bool {
    if IsDefined(this.m_ownerObject) {
      this.m_controlledObjectRef = this.m_ownerObject.GetTakeOverControlSystem().GetControlledObject();
      if Equals(this.m_controlledObjectRef.GetPSClassName(), n"SniperNestControllerPS") {
        this.m_root.SetVisible(false);
      } else {
        this.m_root.SetVisible(true);
      };
    };
    this.ResolveState();
  }

  private final func ResolveState() -> Void {
    let ownerObject: ref<GameObject>;
    let stateName: CName;
    if IsDefined(this.m_controlledObjectRef) {
      ownerObject = this.m_controlledObjectRef.GetOwner();
      if IsDefined(ownerObject) && (ownerObject.IsDrone() || ownerObject.IsVehicle()) {
        stateName = n"Drone";
      } else {
        if EntityID.IsDynamic(this.m_controlledObjectRef.GetEntityID()) {
          stateName = n"Drone";
        } else {
          stateName = n"Default";
        };
      };
    } else {
      stateName = n"Default";
    };
    if IsDefined(this.m_root) {
      this.m_root.SetState(stateName);
    };
  }
}
