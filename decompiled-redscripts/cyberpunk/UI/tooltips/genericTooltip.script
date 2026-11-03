
public abstract class AGenericTooltipController extends inkLogicController {

  protected let m_Root: wref<inkCompoundWidget>;

  protected cb func OnInitialize() -> Bool {
    this.m_Root = this.GetRootCompoundWidget();
  }

  public func SetStyle(styleResPath: ResRef) -> Void;

  public func Show() -> Void {
    this.m_Root.SetVisible(true);
    this.m_Root.SetAffectsLayoutWhenHidden(true);
  }

  public func Hide() -> Void {
    this.m_Root.SetVisible(false);
    this.m_Root.SetAffectsLayoutWhenHidden(false);
  }

  public func SetData(tooltipData: ref<ATooltipData>) -> Void;

  public func Refresh() -> Void;

  public func PrespawnLazyModules() -> Void;
}

public abstract class AGenericTooltipControllerWithDebug extends AGenericTooltipController {

  protected let DEBUG_showDebug: Bool;

  protected let DEBUG_openInVSCode: Bool;

  protected let DEBUG_openInVSCodeBlocked: Bool;

  protected func DEBUG_UpdateDebugInfo() -> Void;

  protected final func OpenTweakDBRecordInVSCodeIfRequested(tdbID: TweakDBID) -> Void {
    if this.DEBUG_openInVSCode && !this.DEBUG_openInVSCodeBlocked {
      TDBID.OpenRecordInVSCode(tdbID);
      this.DEBUG_openInVSCodeBlocked = true;
    };
  }

  protected cb func OnInitialize() -> Bool {
    super.OnInitialize();
    if !IsFinal() {
      this.RegisterToGlobalInputCallback(n"OnPostOnPress", this, n"OnGlobalPress_DEBUG");
      this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnGlobalRelease_DEBUG");
    };
  }

  protected cb func OnUninitialize() -> Bool {
    if !IsFinal() {
      this.UnregisterFromGlobalInputCallback(n"OnPostOnPress", this, n"OnGlobalPress_DEBUG");
      this.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"OnGlobalRelease_DEBUG");
    };
  }

  protected cb func OnGlobalPress_DEBUG(evt: ref<inkPointerEvent>) -> Bool {
    this.DEBUG_showDebug = evt.IsShiftDown();
    this.DEBUG_openInVSCode = evt.IsControlDown();
    this.DEBUG_openInVSCodeBlocked = !this.DEBUG_showDebug;
    this.DEBUG_UpdateDebugInfo();
  }

  protected cb func OnGlobalRelease_DEBUG(evt: ref<inkPointerEvent>) -> Bool {
    this.DEBUG_showDebug = false;
    this.DEBUG_openInVSCode = false;
    this.DEBUG_openInVSCodeBlocked = false;
    this.DEBUG_UpdateDebugInfo();
  }
}

public class IdentifiedWrappedTooltipData extends ATooltipData {

  public let m_identifier: CName;

  public let m_tooltipOwner: EntityID;

  public let m_data: ref<ATooltipData>;

  public final static func Make(identifier: CName, opt data: ref<ATooltipData>) -> ref<IdentifiedWrappedTooltipData> {
    let instance: ref<IdentifiedWrappedTooltipData> = new IdentifiedWrappedTooltipData();
    instance.m_identifier = identifier;
    instance.m_data = data;
    return instance;
  }
}

public class UIInventoryItemTooltipWrapper extends ATooltipData {

  public let m_data: wref<UIInventoryItem>;

  public let m_displayContext: ref<ItemDisplayContextData>;

  @default(UIInventoryItemTooltipWrapper, -1)
  public let m_overridePrice: Int32;

  public let m_comparisonData: ref<UIInventoryItemComparisonManager>;

  public final static func Make(data: wref<UIInventoryItem>, displayContext: ref<ItemDisplayContextData>) -> ref<UIInventoryItemTooltipWrapper> {
    let instance: ref<UIInventoryItemTooltipWrapper> = new UIInventoryItemTooltipWrapper();
    instance.m_data = data;
    instance.m_displayContext = displayContext;
    return instance;
  }
}
