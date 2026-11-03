
public class CodexListVirtualEntry extends inkVirtualCompoundItemController {

  protected edit let m_title: inkTextRef;

  protected edit let m_icon: inkImageRef;

  protected edit let m_newWrapper: inkWidgetRef;

  protected edit let m_ep1Icon: inkWidgetRef;

  private let m_entryData: ref<CodexEntryData>;

  private let m_nestedListData: ref<VirutalNestedListData>;

  private let m_activeItemSync: wref<CodexListSyncData>;

  private let m_isActive: Bool;

  private let m_isItemHovered: Bool;

  private let m_isItemToggled: Bool;

  protected cb func OnInitialize() -> Bool {
    this.RegisterToCallback(n"OnToggledOn", this, n"OnToggledOn");
    this.RegisterToCallback(n"OnToggledOff", this, n"OnToggledOff");
    this.RegisterToCallback(n"OnSelected", this, n"OnSelected");
    this.RegisterToCallback(n"OnDeselected", this, n"OnDeselected");
  }

  public final func OnDataChanged(value: Variant) -> Void {
    this.m_nestedListData = FromVariant<ref<IScriptable>>(value) as VirutalNestedListData;
    this.m_entryData = this.m_nestedListData.m_data as CodexEntryData;
    this.m_activeItemSync = this.m_entryData.m_activeDataSync;
    inkTextRef.SetText(this.m_title, this.m_entryData.m_title);
    if this.m_entryData.m_isEp1 {
      inkWidgetRef.SetVisible(this.m_ep1Icon, true);
    } else {
      inkWidgetRef.SetVisible(this.m_ep1Icon, false);
    };
    this.CheckIsNew();
    this.UpdateState();
  }

  protected cb func OnContactSyncData(evt: ref<CodexSyncBackEvent>) -> Bool {
    this.UpdateState();
  }

  private final func CheckIsNew() -> Void {
    if ArrayContains(this.m_entryData.m_newEntries, this.m_entryData.m_hash) {
      inkWidgetRef.SetVisible(this.m_newWrapper, true);
      inkWidgetRef.SetState(this.m_newWrapper, n"isNew");
      inkWidgetRef.SetState(this.m_title, n"isNew");
      inkWidgetRef.SetState(this.m_icon, n"isNew");
    } else {
      inkWidgetRef.SetVisible(this.m_newWrapper, false);
      inkWidgetRef.SetState(this.m_newWrapper, n"Default");
      inkWidgetRef.SetState(this.m_title, n"Default");
      inkWidgetRef.SetState(this.m_icon, n"Default");
    };
  }

  protected cb func OnEntrySelected(evt: ref<CodexEntrySelectedEvent>) -> Bool {
    if ArrayContains(this.m_entryData.m_newEntries, Cast<Int32>(evt.m_hash)) {
      ArrayRemove(this.m_entryData.m_newEntries, Cast<Int32>(evt.m_hash));
    };
    this.CheckIsNew();
  }

  protected cb func OnToggledOn(itemController: wref<inkVirtualCompoundItemController>) -> Bool {
    let evt: ref<CodexSelectedEvent> = new CodexSelectedEvent();
    evt.m_entryHash = this.m_entryData.m_hash;
    evt.m_level = this.m_nestedListData.m_level;
    evt.m_group = this.m_nestedListData.m_isHeader;
    evt.m_data = this.m_entryData;
    this.QueueEvent(evt);
    this.m_isItemToggled = true;
  }

  protected cb func OnToggledOff(itemController: wref<inkVirtualCompoundItemController>) -> Bool {
    this.m_isItemToggled = false;
    this.UpdateState();
  }

  protected cb func OnSelected(itemController: wref<inkVirtualCompoundItemController>, discreteNav: Bool) -> Bool {
    this.m_isItemHovered = true;
    this.UpdateState();
    if discreteNav {
      this.SetCursorOverWidget(this.GetRootWidget());
    };
  }

  protected cb func OnDeselected(itemController: wref<inkVirtualCompoundItemController>) -> Bool {
    this.m_isItemHovered = false;
    this.UpdateState();
  }

  private final func UpdateState() -> Void {
    if this.m_activeItemSync.m_level == this.m_nestedListData.m_level && this.m_nestedListData.m_isHeader {
      this.GetRootWidget().SetState(n"SubActive");
    } else {
      if this.m_activeItemSync.m_entryHash == this.m_entryData.m_hash && !this.m_nestedListData.m_isHeader {
        this.GetRootWidget().SetState(n"Active");
      } else {
        if this.m_isItemHovered {
          this.GetRootWidget().SetState(n"Hover");
        } else {
          this.GetRootWidget().SetState(n"Default");
        };
      };
    };
  }
}

public class CodexListVirtualGroup extends inkVirtualCompoundItemController {

  protected edit let m_title: inkTextRef;

  protected edit let m_arrow: inkWidgetRef;

  protected edit let m_newWrapper: inkWidgetRef;

  protected edit let m_counter: inkTextRef;

  private let m_entryData: ref<CodexEntryData>;

  private let m_nestedListData: ref<VirutalNestedListData>;

  private let m_activeItemSync: wref<CodexListSyncData>;

  private let m_isActive: Bool;

  private let m_isItemHovered: Bool;

  private let m_isItemToggled: Bool;

  private let m_isItemCollapsed: Bool;

  protected cb func OnInitialize() -> Bool {
    this.RegisterToCallback(n"OnToggledOn", this, n"OnToggledOn");
    this.RegisterToCallback(n"OnToggledOff", this, n"OnToggledOff");
    this.RegisterToCallback(n"OnSelected", this, n"OnSelected");
    this.RegisterToCallback(n"OnDeselected", this, n"OnDeselected");
    inkWidgetRef.SetRotation(this.m_arrow, 90.00);
  }

  public final func OnDataChanged(value: Variant) -> Void {
    this.m_nestedListData = FromVariant<ref<IScriptable>>(value) as VirutalNestedListData;
    this.m_entryData = this.m_nestedListData.m_data as CodexEntryData;
    this.m_activeItemSync = this.m_entryData.m_activeDataSync;
    inkTextRef.SetText(this.m_title, this.m_entryData.m_title);
    inkTextRef.SetText(this.m_counter, "(" + ToString(this.m_entryData.m_counter) + ")");
    this.CheckIsNew();
    this.UpdateState();
  }

  protected cb func OnContactSyncData(evt: ref<CodexSyncBackEvent>) -> Bool {
    this.UpdateState();
  }

  protected cb func OnEntrySelected(evt: ref<CodexEntrySelectedEvent>) -> Bool {
    if ArrayContains(this.m_entryData.m_newEntries, Cast<Int32>(evt.m_hash)) {
      ArrayRemove(this.m_entryData.m_newEntries, Cast<Int32>(evt.m_hash));
    };
    this.CheckIsNew();
  }

  protected cb func OnToggledOn(itemController: wref<inkVirtualCompoundItemController>) -> Bool {
    let evt: ref<CodexSelectedEvent> = new CodexSelectedEvent();
    evt.m_entryHash = this.m_entryData.m_hash;
    evt.m_level = this.m_nestedListData.m_level;
    evt.m_group = this.m_nestedListData.m_isHeader;
    evt.m_data = this.m_entryData;
    this.QueueEvent(evt);
    this.m_isItemToggled = true;
  }

  protected cb func OnToggledOff(itemController: wref<inkVirtualCompoundItemController>) -> Bool {
    this.m_isItemToggled = false;
    this.UpdateState();
  }

  protected cb func OnSelected(itemController: wref<inkVirtualCompoundItemController>, discreteNav: Bool) -> Bool {
    this.m_isItemHovered = true;
    this.UpdateState();
    if discreteNav {
      this.SetCursorOverWidget(this.GetRootWidget());
    };
    this.CheckIsNew();
  }

  protected cb func OnDeselected(itemController: wref<inkVirtualCompoundItemController>) -> Bool {
    this.m_isItemHovered = false;
    this.UpdateState();
  }

  private final func CheckIsNew() -> Void {
    if ArraySize(this.m_entryData.m_newEntries) > 0 {
      inkWidgetRef.SetState(this.m_newWrapper, n"isNew");
      inkWidgetRef.SetState(this.m_title, n"isNew");
      inkWidgetRef.SetState(this.m_arrow, n"isNew");
    } else {
      inkWidgetRef.SetState(this.m_newWrapper, n"Default");
      inkWidgetRef.SetState(this.m_title, n"Default");
      inkWidgetRef.SetState(this.m_arrow, n"Default");
    };
  }

  private final func UpdateState() -> Void {
    if this.m_activeItemSync.m_level == this.m_nestedListData.m_level && this.m_nestedListData.m_isHeader {
      this.GetRootWidget().SetState(n"SubActive");
    } else {
      if this.m_activeItemSync.m_entryHash == this.m_entryData.m_hash && !this.m_nestedListData.m_isHeader {
        this.GetRootWidget().SetState(n"Active");
      } else {
        if this.m_isItemHovered {
          this.GetRootWidget().SetState(n"Hover");
        } else {
          this.GetRootWidget().SetState(n"Default");
        };
      };
    };
    if IsDefined(this.m_nestedListData) && IsDefined(this.m_activeItemSync) {
      this.m_isItemCollapsed = !ArrayContains(this.m_activeItemSync.m_toggledLevels, this.m_nestedListData.m_level);
    };
    if inkWidgetRef.IsValid(this.m_arrow) {
      inkWidgetRef.SetRotation(this.m_arrow, this.m_isItemCollapsed ? 90.00 : 180.00);
    };
  }
}

public class CodexListVirtualNestedDataView extends VirtualNestedListDataView {

  public let m_currentFilter: CodexCategoryType;

  public final func SetFilter(filterType: CodexCategoryType) -> Void {
    this.m_currentFilter = filterType;
    this.Filter();
    this.EnableSorting();
    this.Sort();
    this.DisableSorting();
  }

  protected func FilterItems(data: ref<VirutalNestedListData>) -> Bool {
    let entryData: ref<CodexEntryData>;
    if Equals(this.m_currentFilter, CodexCategoryType.All) || Equals(this.m_currentFilter, CodexCategoryType.Invalid) {
      return true;
    };
    entryData = data.m_data as CodexEntryData;
    return entryData.m_category == EnumInt(this.m_currentFilter);
  }

  protected func SortItems(compareBuilder: ref<CompareBuilder>, left: ref<VirutalNestedListData>, right: ref<VirutalNestedListData>) -> Void {
    let leftDataTitle: String;
    let rightDataTitle: String;
    let leftData: ref<CodexEntryData> = left.m_data as CodexEntryData;
    let rightData: ref<CodexEntryData> = right.m_data as CodexEntryData;
    if IsDefined(leftData) && IsDefined(rightData) && left.m_isSortable && right.m_isSortable {
      leftDataTitle = GetLocalizedText(leftData.m_title);
      rightDataTitle = GetLocalizedText(rightData.m_title);
      compareBuilder.BoolTrue(leftData.m_isNew, rightData.m_isNew).StringAsc(leftDataTitle, rightDataTitle);
    };
  }
}

public class CodexListVirtualNestedListController extends VirtualNestedListController {

  private let m_currentDataView: wref<CodexListVirtualNestedDataView>;

  public final func SetFilter(filterType: CodexCategoryType) -> Void {
    this.m_currentDataView.SetFilter(filterType);
  }

  protected func GetDataView() -> ref<VirtualNestedListDataView> {
    let view: ref<CodexListVirtualNestedDataView> = new CodexListVirtualNestedDataView();
    this.m_currentDataView = view;
    return view;
  }
}
