
public abstract native class IWorldWidgetComponent extends WidgetBaseComponent {

  public final native func GetWidget() -> ref<inkWidget>;

  protected final native func GetGameControllerInterface() -> wref<worlduiIGameController>;

  public final func GetGameController() -> wref<inkGameController> {
    return this.GetGameControllerInterface() as inkGameController;
  }

  public const func GetScreenDefinition() -> ScreenDefinitionPackage {
    let screen: ScreenDefinitionPackage;
    return screen;
  }

  public const func IsScreenDefinitionValid() -> Bool {
    return false;
  }

  private final func ShouldReactToHit() -> Bool {
    let owner: ref<Entity> = this.GetEntity();
    return (owner as Device) == null && (owner as VehicleObject) == null;
  }

  protected cb func OnHitEvent(hit: ref<gameHitEvent>) -> Bool {
    if this.ShouldReactToHit() {
      this.StartGlitching(1.00, 0.25);
    };
  }

  protected final func StartGlitching(intensity: Float, lifetime: Float) -> Void {
    let evt: ref<AdvertGlitchEvent> = new AdvertGlitchEvent();
    evt.SetShouldGlitch(intensity);
    evt.SetGlitchTime(lifetime);
    this.QueueEntityEvent(evt);
  }

  protected final func StopGlitching() -> Void {
    let evt: ref<AdvertGlitchEvent> = new AdvertGlitchEvent();
    evt.SetShouldGlitch(0.00);
    this.QueueEntityEvent(evt);
  }
}

public abstract native class worlduiWidgetComponent extends IWorldWidgetComponent {

  @runtimeProperty("category", "Screen Definition")
  protected let m_screenDefinition: SUIScreenDefinition;

  public const func GetScreenDefinition() -> ScreenDefinitionPackage {
    let screen: ScreenDefinitionPackage;
    screen.style = TweakDBInterface.GetWidgetStyleRecord(this.m_screenDefinition.style);
    screen.screenDefinition = TweakDBInterface.GetDeviceUIDefinitionRecord(this.m_screenDefinition.screenDefinition);
    return screen;
  }

  public const func IsScreenDefinitionValid() -> Bool {
    return TDBID.IsValid(this.m_screenDefinition.screenDefinition);
  }
}

public native class frameWidgetComponent extends worlduiWidgetComponent {

  public final func InitDefaultScreenshot() -> Void {
    let controller: ref<FrameInkGameController> = this.GetGameController() as FrameInkGameController;
    let widget: ref<inkImage> = controller.GetDefaultScreenWidget();
    let size: Vector2 = widget.GetSize();
    let format: Vector2 = this.GetFormat();
    if format.X > format.Y {
      size.Y *= format.X / format.Y;
    } else {
      if format.Y > format.X {
        size.X *= format.Y / format.X;
      };
    };
    widget.SetSize(size);
    controller.SetDefaultScreenshot(true);
  }

  public final func SetDefaultScreenshot(value: Bool) -> Void {
    let controller: ref<FrameInkGameController> = this.GetGameController() as FrameInkGameController;
    controller.SetDefaultScreenshot(value);
  }

  public final func GetScreenshotWidget() -> wref<inkImage> {
    let controller: ref<FrameInkGameController> = this.GetGameController() as FrameInkGameController;
    return controller.GetScreenWidget();
  }

  public final func StartGlitchTransition() -> Void {
    let evt: ref<AdvertGlitchEvent> = new AdvertGlitchEvent();
    evt.SetShouldGlitch(1.00);
    this.QueueEntityEvent(evt);
  }

  public final func StopGlitchTransition() -> Void {
    let evt: ref<AdvertGlitchEvent> = new AdvertGlitchEvent();
    evt.SetShouldGlitch(0.00);
    this.QueueEntityEvent(evt);
  }

  public final native func InitScreenshot(hash: Uint32, widget: wref<inkImage>, opt object: wref<IScriptable>, opt callback: CName) -> Void;

  public final native func GetRequestHandler() -> ref<inkISystemRequestsHandler>;

  public final native func GetFormat() -> Vector2;

  public final native func GetPathHash(path: String) -> Int32;
}
