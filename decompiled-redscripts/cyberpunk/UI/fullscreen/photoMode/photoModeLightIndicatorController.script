
public native class PhotomodeSetActiveLightEvent extends Event {

  private native let isLightTabActive: Bool;

  private native let isCurrentLightEnabled: Bool;

  private native let lightIndex: Int32;

  public final const func GetIndex() -> Int32 {
    if !this.isLightTabActive || !this.isCurrentLightEnabled {
      return -1;
    };
    return this.lightIndex;
  }
}

public native class PhotomodeLightIndicatorController extends inkLogicController {

  public edit let m_indicatorRef: inkWidgetRef;

  public edit let m_indicatorIconRef: inkWidgetRef;

  public edit let m_indicatorNumRef: inkTextRef;

  public edit let m_correctionAngle: Float;

  public let m_activeIndex: Int32;

  public let m_currentCamera: wref<Entity>;

  public let m_maxSize: Vector2;

  public final native func GetProjection(index: Int32) -> wref<inkScreenProjection>;

  public final native func ClearProjections() -> Void;

  protected cb func OnInitialize() -> Bool {
    this.m_maxSize = this.GetRootWidget().GetSize();
    inkWidgetRef.SetVisible(this.m_indicatorRef, false);
  }

  protected cb func OnUninitialize() -> Bool {
    this.ClearProjections();
  }

  protected cb func OnSetActiveCamera(evt: ref<PhotomodeCameraSwitchedEvent>) -> Bool {
    this.m_currentCamera = evt.camera;
  }

  protected cb func OnActiveIndexChanged(evt: ref<PhotomodeSetActiveLightEvent>) -> Bool {
    let projection: wref<inkScreenProjection>;
    if !inkWidgetRef.IsValid(this.m_indicatorRef) {
      return false;
    };
    projection = this.GetCurrentProjection();
    if projection != null {
      projection.UnregisterListener(this, n"OnUpdateProjection");
    };
    this.m_activeIndex = evt.GetIndex();
    inkTextRef.SetText(this.m_indicatorNumRef, IntToString(this.m_activeIndex + 1));
    projection = this.GetCurrentProjection();
    if projection != null {
      projection.RegisterListener(this, n"OnUpdateProjection");
      this.OnUpdateProjection(projection);
    } else {
      inkWidgetRef.SetVisible(this.m_indicatorRef, false);
    };
  }

  protected cb func OnUpdateProjection(projection: ref<inkScreenProjection>) -> Bool {
    let angle: Float;
    let direction: Vector2;
    let halfSize: Vector2;
    let position: Vector2;
    if !IsDefined(this.m_currentCamera) || projection.IsInScreen() {
      inkWidgetRef.SetVisible(this.m_indicatorRef, false);
      return false;
    };
    inkWidgetRef.SetVisible(this.m_indicatorRef, true);
    halfSize = new Vector2(this.m_maxSize.X / 4.00, this.m_maxSize.Y / 4.00);
    position = projection.uvPosition;
    position.X = ClampF(position.X, -1.00, 1.00);
    position.Y = ClampF(position.Y, -1.00, 1.00);
    if position.X == 1.00 {
      inkWidgetRef.SetAnchor(this.m_indicatorRef, inkEAnchor.CenterRight);
      position.Y = halfSize.Y * position.Y;
      inkWidgetRef.SetMargin(this.m_indicatorRef, 0.00, -position.Y, 0.00, position.Y);
    } else {
      if position.X == -1.00 {
        inkWidgetRef.SetAnchor(this.m_indicatorRef, inkEAnchor.CenterLeft);
        position.Y = halfSize.Y * position.Y;
        inkWidgetRef.SetMargin(this.m_indicatorRef, 0.00, -position.Y, 0.00, position.Y);
      } else {
        if position.Y == 1.00 {
          inkWidgetRef.SetAnchor(this.m_indicatorRef, inkEAnchor.TopCenter);
          position.X = halfSize.X * position.X;
          inkWidgetRef.SetMargin(this.m_indicatorRef, position.X, 0.00, -position.X, 0.00);
        } else {
          if position.Y == -1.00 {
            inkWidgetRef.SetAnchor(this.m_indicatorRef, inkEAnchor.BottomCenter);
            position.X = halfSize.X * position.X;
            inkWidgetRef.SetMargin(this.m_indicatorRef, position.X, 0.00, -position.X, 0.00);
          };
        };
      };
    };
    direction = Vector2.Normalize(projection.uvPosition);
    angle = Rad2Deg(AcosF(-direction.X));
    angle = direction.Y < 0.00 ? -angle : angle + this.m_correctionAngle;
    inkWidgetRef.SetRotation(this.m_indicatorRef, angle);
    inkWidgetRef.SetRotation(this.m_indicatorIconRef, -angle);
  }

  private final func GetCurrentProjection() -> wref<inkScreenProjection> {
    return this.GetProjection(this.m_activeIndex);
  }
}
