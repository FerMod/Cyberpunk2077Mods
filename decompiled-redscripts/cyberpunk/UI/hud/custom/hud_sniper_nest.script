
public class hudSniperNestController extends inkHUDGameController {

  private let m_psmBlackboard: wref<IBlackboard>;

  private let m_tcsBlackboard: wref<IBlackboard>;

  private let m_PSM_BBID: ref<CallbackHandle>;

  private let m_tcs_BBID: ref<CallbackHandle>;

  private let m_deviceChain_BBID: ref<CallbackHandle>;

  private let m_root: wref<inkCompoundWidget>;

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
    };
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
    GameInstance.GetAudioSystem(this.GetPlayerControlledObject().GetGame()).Play(n"global_menu_hacking_close");
    GameInstance.GetAudioSystem(this.GetPlayerControlledObject().GetGame()).Play(n"ui_hacking_close");
  }

  protected cb func OnUninitialize() -> Bool {
    this.m_tcsBlackboard.UnregisterListenerEntityID(GetAllBlackboardDefs().DeviceTakeControl.ActiveDevice, this.m_tcs_BBID);
    this.m_tcsBlackboard.UnregisterListenerVariant(GetAllBlackboardDefs().DeviceTakeControl.DevicesChain, this.m_deviceChain_BBID);
    this.m_AnimProxy.UnregisterFromCallback(inkanimEventType.OnEndLoop, this, n"OnEndLoop");
    this.m_AnimProxy.Stop();
    TakeOverControlSystem.CreateInputHint(this.GetPlayerControlledObject().GetGame(), false);
  }

  protected cb func OnChangeControlledDevice(value: EntityID) -> Bool {
    if IsDefined(this.m_ownerObject) {
      this.m_controlledObjectRef = this.m_ownerObject.GetTakeOverControlSystem().GetControlledObject();
      if Equals(this.m_controlledObjectRef.GetPSClassName(), n"SniperNestControllerPS") {
        this.m_root.SetVisible(true);
      } else {
        this.m_root.SetVisible(false);
      };
    };
  }

  protected cb func OnDelayedHUDInitializeEvent(evt: ref<DelayedHUDInitializeEvent>) -> Bool {
    TakeOverControlSystem.CreateInputHint(this.GetPlayerControlledObject().GetGame(), true);
  }
}
