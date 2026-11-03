
public class Frame extends InteractiveDevice {

  @default(Frame, false)
  private let m_isLinkedToPower: Bool;

  @default(Frame, SMARTFRAMES™)
  private edit let m_smartFrameName: String;

  @default(Frame, UI-SmartFrames-Description)
  private edit let m_smartFrameDescriptionLocKey: String;

  private let m_systemHandler: wref<inkISystemRequestsHandler>;

  private let m_squatFactToken: Uint32;

  private let m_questFactToken: Uint32;

  private let m_powerFactToken: Uint32;

  @default(Frame, 0)
  private let m_activePhotoID: Int32;

  private let m_activePhotoHash: Uint32;

  private let m_activePhotoUV: RectF;

  private let m_frameSwitcherToken: ref<inkGameNotificationToken>;

  protected cb func OnFrameInitialisation(evt: ref<FrameInitialisation>) -> Bool {
    let ps: ref<FramePS> = this.GetPS();
    let frameComp: ref<frameWidgetComponent> = this.m_uiComponent as frameWidgetComponent;
    this.m_activePhotoHash = ps.GetHash();
    this.m_activePhotoUV = ps.GetUV();
    frameComp.InitDefaultScreenshot();
    if this.m_activePhotoHash != 0u {
      frameComp.InitScreenshot(this.m_activePhotoHash, evt.widget, this, n"OnScreenshotChanged");
      frameComp.StartGlitchTransition();
      GameObjectEffectHelper.StartEffectEvent(this, n"frameEffect");
    };
    frameComp.GetRequestHandler().RegisterToCallback(n"OnDeleteSreenshotComplete", this, n"OnDeleteSreenshotComplete");
    if this.m_isLinkedToPower {
      this.LinkToPower();
    };
  }

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
    EntityRequestComponentsInterface.RequestComponent(ri, n"ui", n"frameWidgetComponent", true);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_uiComponent = EntityResolveComponentsInterface.GetComponent(ri, n"ui") as frameWidgetComponent;
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as FrameController;
  }

  protected cb func OnScanningLookedAt(evt: ref<ScanningLookAtEvent>) -> Bool {
    super.OnScanningLookedAt(evt);
  }

  private const func GetController() -> ref<FrameController> {
    return this.m_controller as FrameController;
  }

  public const func GetDevicePS() -> ref<FrameControllerPS> {
    return this.GetController().GetPS();
  }

  protected const func GetPS() -> ref<FramePS> {
    return super.GetPS() as FramePS;
  }

  public const func CompileScannerChunks() -> Bool {
    let customDescriptions: array<String>;
    let descriptionChunk: ref<ScannerDescription>;
    let deviceStatusChunk: ref<ScannerDeviceStatus>;
    let nameChunk: ref<ScannerName>;
    let nameParams: ref<inkTextParams>;
    let devicePS: ref<ScriptableDeviceComponentPS> = this.GetDevicePS();
    let scannerBlackboard: wref<IBlackboard> = GameInstance.GetBlackboardSystem(this.GetGame()).Get(GetAllBlackboardDefs().UI_ScannerModules);
    if !IsDefined(devicePS) || !IsDefined(scannerBlackboard) {
      return false;
    };
    if devicePS.IsDisabled() {
      return false;
    };
    scannerBlackboard.SetInt(GetAllBlackboardDefs().UI_ScannerModules.ObjectType, 3, true);
    nameParams = new inkTextParams();
    nameParams.AddString("TEXT_PRIMARY", this.m_smartFrameName);
    nameParams.AddString("TEXT_SECONDARY", "");
    nameChunk = new ScannerName();
    nameChunk.SetTextParams(nameParams);
    scannerBlackboard.SetVariant(GetAllBlackboardDefs().UI_ScannerModules.ScannerName, ToVariant(nameChunk));
    if devicePS.ShouldScannerShowStatus() {
      deviceStatusChunk = new ScannerDeviceStatus();
      deviceStatusChunk.Set(LocKeyToString(TweakDBInterface.GetScannableDataRecord(devicePS.GetScannerStatusRecord()).LocalizedDescription()));
      deviceStatusChunk.SetFriendlyName(TweakDBInterface.GetScannableDataRecord(devicePS.GetScannerStatusRecord()).FriendlyName());
      scannerBlackboard.SetVariant(GetAllBlackboardDefs().UI_ScannerModules.ScannerDeviceStatus, ToVariant(deviceStatusChunk));
    };
    descriptionChunk = new ScannerDescription();
    descriptionChunk.Set(this.m_smartFrameDescriptionLocKey, customDescriptions);
    scannerBlackboard.SetVariant(GetAllBlackboardDefs().UI_ScannerModules.ScannerDescription, ToVariant(descriptionChunk));
    return true;
  }

  public const func DeterminGameplayRole() -> EGameplayRole {
    return EGameplayRole.SmartFrame;
  }

  private final func LinkToPower() -> Void {
    let questSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGame());
    this.m_questFactToken = questSystem.RegisterEntity(n"q302_squat_sh_unlocked", this.GetEntityID());
    if !this.TestPowerFact(questSystem) {
      this.m_uiComponent.Toggle(false);
      this.GetDevicePS().SetState(false);
    };
  }

  private final func TestPowerFact(questSystem: ref<QuestsSystem>) -> Bool {
    return Cast<Bool>(questSystem.GetFact(n"q302_squat_sh_unlocked"));
  }

  protected cb func OnFactChangedEvent(evt: ref<FactChangedEvent>) -> Bool {
    let questSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGame());
    if this.TestPowerFact(questSystem) {
      this.m_uiComponent.Toggle(true);
      this.GetDevicePS().SetState(true);
      questSystem.UnregisterEntity(n"q302_squat_sh_unlocked", this.m_questFactToken);
    };
  }

  private final func UpdateCurrentPhoto() -> Void {
    let frameComp: ref<frameWidgetComponent> = this.m_uiComponent as frameWidgetComponent;
    if this.m_activePhotoHash != 0u {
      if frameComp.GetRequestHandler().RequestGameScreenshotByHash(this.m_activePhotoHash, frameComp.GetScreenshotWidget(), this, n"OnScreenshotChanged") {
        frameComp.StartGlitchTransition();
        GameObjectEffectHelper.StartEffectEvent(this, n"glitchEffect");
      };
    } else {
      GameObjectEffectHelper.StartEffectEvent(this, n"glitchEffect");
      frameComp.SetDefaultScreenshot(true);
    };
  }

  private final func TrySpawnFrameSwitcherPopup() -> Bool {
    if this.GetBlackboard().GetBool(GetAllBlackboardDefs().UIGameData.Popup_FrameSwitcher_IsShown) {
      return false;
    };
    this.SpawnFrameSwitcherPopup();
    return true;
  }

  private final func SpawnFrameSwitcherPopup() -> Void {
    let evt: ref<FrameSwitcherEvent> = new FrameSwitcherEvent();
    evt.frame = this;
    evt.hash = this.m_activePhotoHash;
    evt.index = this.m_activePhotoID;
    evt.uv = this.m_activePhotoUV;
    GetPlayer(this.GetGame()).QueueEvent(evt);
  }

  public final const func GetFrameSize() -> Vector2 {
    return (this.m_uiComponent as frameWidgetComponent).GetFormat();
  }

  protected cb func OnFrameSwitcher(evt: ref<FrameSwitcher>) -> Bool {
    this.TrySpawnFrameSwitcherPopup();
  }

  protected cb func OnFrameSwitch(evt: ref<FrameSwitch>) -> Bool {
    this.m_activePhotoHash = evt.hash;
    this.m_activePhotoID = evt.index;
    this.m_activePhotoUV = evt.uv;
    this.UpdateCurrentPhoto();
    this.GetPS().SetHash(this.m_activePhotoHash);
    this.GetPS().SetUV(this.m_activePhotoUV);
  }

  protected cb func OnScreenshotChanged(screenshotSize: Vector2, errorCode: Int32) -> Bool {
    let frameComp: ref<frameWidgetComponent> = this.m_uiComponent as frameWidgetComponent;
    let widget: wref<inkImage> = frameComp.GetScreenshotWidget();
    frameComp.StopGlitchTransition();
    if screenshotSize.X == 0.00 || screenshotSize.Y == 0.00 {
      frameComp.SetDefaultScreenshot(true);
    } else {
      frameComp.SetDefaultScreenshot(false);
      widget.SetDynamicTextureUV(this.m_activePhotoUV);
    };
    widget.FlagForVisualInvalidation();
  }

  protected cb func OnDeleteSreenshotComplete(hash: Uint32) -> Bool {
    let frameComp: ref<frameWidgetComponent> = this.m_uiComponent as frameWidgetComponent;
    if hash == this.m_activePhotoHash {
      frameComp.SetDefaultScreenshot(true);
    };
  }
}

public class FramePS extends GameObjectPS {

  @default(FramePS, 0)
  private persistent let m_screenshotHash: Uint32;

  @default(FramePS, -1)
  private persistent let m_screenshotID: Int32;

  private persistent let m_screenshotUVLeft: Float;

  private persistent let m_screenshotUVRight: Float;

  private persistent let m_screenshotUVTop: Float;

  private persistent let m_screenshotUVBottom: Float;

  public final func SetHash(hash: Uint32) -> Void {
    this.m_screenshotHash = hash;
  }

  public final func SetUV(uv: RectF) -> Void {
    this.m_screenshotUVLeft = uv.Left;
    this.m_screenshotUVRight = uv.Right;
    this.m_screenshotUVTop = uv.Top;
    this.m_screenshotUVBottom = uv.Bottom;
  }

  public final const func GetHash() -> Uint32 {
    return this.m_screenshotHash;
  }

  public final const func GetIndex() -> Int32 {
    return this.m_screenshotID;
  }

  public final const func GetUV() -> RectF {
    let rect: RectF;
    rect.Left = this.m_screenshotUVLeft;
    rect.Right = this.m_screenshotUVRight;
    rect.Top = this.m_screenshotUVTop;
    rect.Bottom = this.m_screenshotUVBottom;
    return rect;
  }
}
