
public class FilterRadioGroup extends inkRadioGroupController {

  private edit let m_libraryPath: inkWidgetLibraryReference;

  private let m_TooltipsManager: wref<gameuiTooltipsManager>;

  private let m_TooltipIndex: Int32;

  private let m_toggles: [wref<inkToggleController>];

  private let m_rootRef: wref<inkCompoundWidget>;

  public final func SetData(enumCount: Int32, opt tooltipsManager: wref<gameuiTooltipsManager>, opt tooltipIndex: Int32) -> Void {
    let data: array<Int32>;
    let i: Int32 = 0;
    while i < enumCount {
      ArrayPush(data, i);
      i += 1;
    };
    this.SetData(data, tooltipsManager, tooltipIndex);
  }

  public final func SetData(const data: script_ref<[Int32]>, opt tooltipsManager: wref<gameuiTooltipsManager>, opt tooltipIndex: Int32) -> Void {
    let filterToggle: ref<ToggleController>;
    let i: Int32;
    let limit: Int32 = ArraySize(Deref(data));
    this.m_TooltipIndex = tooltipIndex;
    this.m_TooltipsManager = tooltipsManager;
    this.m_rootRef = this.GetRootCompoundWidget();
    while this.m_rootRef.GetNumChildren() > limit {
      ArrayErase(this.m_toggles, 0);
      this.m_rootRef.RemoveChildByIndex(0);
      this.RemoveToggle(0);
    };
    while this.m_rootRef.GetNumChildren() < limit {
      filterToggle = this.SpawnFromExternal(this.m_rootRef, inkWidgetLibraryResource.GetPath(this.m_libraryPath.widgetLibrary), this.m_libraryPath.widgetItem).GetController() as ToggleController;
      this.AddToggle(filterToggle);
      ArrayPush(this.m_toggles, filterToggle);
      filterToggle.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOver");
      filterToggle.RegisterToCallback(n"OnHoverOut", this, n"OnHoverOut");
    };
    i = 0;
    while i < ArraySize(Deref(data)) {
      filterToggle = this.m_toggles[i] as ToggleController;
      filterToggle.SetToggleData(Deref(data)[i]);
      i += 1;
    };
  }

  public final func AddFilter(data: Int32) -> Void {
    let filterToggle: ref<ToggleController>;
    let i: Int32 = 0;
    while i < ArraySize(this.m_toggles) {
      if (this.m_toggles[i] as ToggleController).GetData() == data {
        return;
      };
      i += 1;
    };
    filterToggle = this.SpawnFromExternal(this.m_rootRef, inkWidgetLibraryResource.GetPath(this.m_libraryPath.widgetLibrary), this.m_libraryPath.widgetItem).GetController() as ToggleController;
    this.AddToggle(filterToggle);
    ArrayPush(this.m_toggles, filterToggle);
    filterToggle.SetToggleData(data);
    filterToggle.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOver");
    filterToggle.RegisterToCallback(n"OnHoverOut", this, n"OnHoverOut");
  }

  public final func RemoveFilter(data: Int32) -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_toggles) {
      if (this.m_toggles[i] as ToggleController).GetData() == data {
        ArrayErase(this.m_toggles, i);
        this.m_rootRef.RemoveChildByIndex(i);
        this.RemoveToggle(i);
        return;
      };
      i += 1;
    };
  }

  public final func ToggleData(data: Int32) -> Void {
    let filterToggle: ref<ToggleController>;
    let i: Int32 = 0;
    while i < ArraySize(this.m_toggles) {
      filterToggle = this.m_toggles[i] as ToggleController;
      if filterToggle.GetData() == data {
        filterToggle.Toggle();
      };
      i += 1;
    };
  }

  protected cb func OnHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    let parentEvent: ref<FilterRadioItemHoverOver>;
    let tooltipData: ref<MessageTooltipData>;
    let widget: ref<inkWidget> = evt.GetCurrentTarget();
    let controller: ref<ToggleController> = widget.GetController() as ToggleController;
    if IsDefined(this.m_TooltipsManager) {
      tooltipData = new MessageTooltipData();
      tooltipData.Title = GetLocalizedText(controller.GetLabelKey());
      this.m_TooltipsManager.ShowTooltipAtWidget(this.m_TooltipIndex, evt.GetCurrentTarget(), tooltipData, gameuiETooltipPlacement.RightCenter);
    };
    parentEvent = new FilterRadioItemHoverOver();
    parentEvent.target = evt.GetTarget();
    parentEvent.identifier = controller.GetData();
    this.QueueEvent(parentEvent);
  }

  protected cb func OnHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    let parentEvent: ref<FilterRadioItemHoverOut>;
    let widget: ref<inkWidget> = evt.GetCurrentTarget();
    let controller: ref<ToggleController> = widget.GetController() as ToggleController;
    if IsDefined(this.m_TooltipsManager) {
      this.m_TooltipsManager.HideTooltips();
    };
    parentEvent = new FilterRadioItemHoverOut();
    parentEvent.target = evt.GetTarget();
    parentEvent.identifier = controller.GetData();
    this.QueueEvent(parentEvent);
  }
}

public class ToggleController extends inkToggleController {

  protected edit let m_label: inkTextRef;

  protected edit let m_icon: inkImageRef;

  protected let m_data: Int32;

  public final func SetToggleData(data: Int32) -> Void {
    this.m_data = data;
    inkTextRef.SetText(this.m_label, this.GetLabelKey());
    InkImageUtils.RequestSetImage(this, this.m_icon, this.GetIcon());
  }

  public final func GetData() -> Int32 {
    return this.m_data;
  }

  public func GetLabelKey() -> String {
    return "";
  }

  public func GetIcon() -> String {
    return "";
  }
}
