
public class DeviceThumbnailWidgetControllerBase extends DeviceButtonLogicControllerBase {

  @runtimeProperty("category", "Widget Refs")
  protected edit let m_deviceIconRef: inkImageRef;

  @runtimeProperty("category", "Widget Refs")
  protected edit let m_statusNameWidget: inkTextRef;

  private let m_thumbnailAction: wref<ThumbnailUI>;

  public func Initialize(gameController: ref<DeviceInkGameControllerBase>, const widgetData: script_ref<SThumbnailWidgetPackage>) -> Void {
    this.RegisterThumbnailActionCallback(gameController);
    inkTextRef.SetLocalizedTextScript(this.m_statusNameWidget, Deref(widgetData).deviceStatus);
    inkTextRef.SetTextParameters(this.m_statusNameWidget, Deref(widgetData).textData);
    inkTextRef.SetLocalizedTextScript(this.m_displayNameWidget, Deref(widgetData).displayName);
    if TDBID.IsValid(Deref(widgetData).iconTextureID) {
      this.SetTexture(this.m_deviceIconRef, Deref(widgetData).iconTextureID);
      inkWidgetRef.SetAnchor(this.m_deviceIconRef, inkEAnchor.Fill);
    } else {
      inkWidgetRef.SetVisible(this.m_deviceIconRef, false);
    };
    if Equals(Deref(widgetData).widgetState, EWidgetState.ALLOWED) {
      inkWidgetRef.SetState(this.m_statusNameWidget, n"Allowed");
      inkWidgetRef.SetState(this.m_displayNameWidget, n"Allowed");
    } else {
      if Equals(Deref(widgetData).widgetState, EWidgetState.LOCKED) {
        inkWidgetRef.SetState(this.m_statusNameWidget, n"Locked");
        inkWidgetRef.SetState(this.m_displayNameWidget, n"Locked");
      } else {
        if Equals(Deref(widgetData).widgetState, EWidgetState.SEALED) {
          inkWidgetRef.SetState(this.m_statusNameWidget, n"Sealed");
          inkWidgetRef.SetState(this.m_displayNameWidget, n"Sealed");
        };
      };
    };
    this.SetAction(Deref(widgetData).thumbnailAction);
    this.m_isInitialized = true;
  }

  public final func SetAction(action: wref<ThumbnailUI>) -> Void {
    this.m_thumbnailAction = action;
  }

  public final func GetAction() -> wref<ThumbnailUI> {
    return this.m_thumbnailAction;
  }

  protected final func RegisterThumbnailActionCallback(gameController: ref<DeviceInkGameControllerBase>) -> Void {
    if !this.m_isInitialized {
      this.m_targetWidget.RegisterToCallback(n"OnRelease", gameController, n"OnThumbnailActionCallback");
      this.RegisterAudioCallbacks(gameController);
    };
  }
}
