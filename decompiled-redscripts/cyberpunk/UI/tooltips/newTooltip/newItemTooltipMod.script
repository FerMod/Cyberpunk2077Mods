
public class NewItemTooltipAttachmentGroupController extends inkLogicController {

  private edit let m_indicatorContainer: inkWidgetRef;

  private edit let m_indicatorWidget: inkWidgetRef;

  private edit let m_rarityContainer: inkWidgetRef;

  private edit let m_rarityWidget: inkImageRef;

  private edit let m_entriesContainer: inkCompoundRef;

  private let m_entriesControllers: [wref<NewItemTooltipAttachmentEntryController>];

  private let m_entriesData: [ref<NewItemTooltipAttachmentEntryData>];

  private let m_requestedEntries: Int32;

  private let m_isEmpty: Bool;

  private let m_colorState: CName;

  private edit let m_isCrafting: Bool;

  public final static func StaticDefaultColorState() -> CName {
    return n"Default";
  }

  public final func DefaultColorState() -> CName {
    return n"Default";
  }

  public final func SetData(data: ref<MinimalItemTooltipModData>) -> Void {
    if IsDefined(data as MinimalItemTooltipModAttachmentData) {
      this.SetData(data as MinimalItemTooltipModAttachmentData);
      return;
    };
    ArrayClear(this.m_entriesData);
    this.m_isEmpty = false;
    this.m_colorState = this.DefaultColorState();
    ArrayPush(this.m_entriesData, NewItemTooltipAttachmentEntryData.Make(data as MinimalItemTooltipModRecordData.description, data as MinimalItemTooltipModRecordData.dataPackage));
    this.Update();
  }

  public final func SetData(data: ref<MinimalItemTooltipModAttachmentData>) -> Void {
    let ability: InventoryItemAbility;
    let i: Int32;
    ArrayClear(this.m_entriesData);
    if data.isEmpty || data.abilitiesSize == 0 {
      this.m_isEmpty = data.isEmpty;
      this.m_colorState = data.qualityName;
      ArrayPush(this.m_entriesData, NewItemTooltipAttachmentEntryData.Make(data.slotName));
    } else {
      this.m_isEmpty = data.isEmpty;
      this.m_colorState = data.qualityName;
      i = 0;
      while i < data.abilitiesSize {
        ability = data.abilities[i];
        if NotEquals(ability.Description, "") {
          ArrayPush(this.m_entriesData, NewItemTooltipAttachmentEntryData.Make(ability.Description, ability.LocalizationDataPackage));
        } else {
          ArrayPush(this.m_entriesData, NewItemTooltipAttachmentEntryData.Make(GetLocalizedText("UI-Labels-EmptySlot")));
        };
        i += 1;
      };
    };
    this.Update();
  }

  public final func SetData(data: ref<UIInventoryItemMod>) -> Void {
    if IsDefined(data as UIInventoryItemModAttachment) {
      this.SetData(data as UIInventoryItemModAttachment);
      return;
    };
    this.m_isEmpty = false;
    this.m_colorState = this.DefaultColorState();
    ArrayClear(this.m_entriesData);
    ArrayPush(this.m_entriesData, NewItemTooltipAttachmentEntryData.Make(data as UIInventoryItemModDataPackage.Description, data as UIInventoryItemModDataPackage.DataPackage, data as UIInventoryItemModDataPackage.AttunementData));
    this.Update();
  }

  public final func SetData(data: ref<UIInventoryItemModAttachment>) -> Void {
    let ability: InventoryItemAbility;
    let i: Int32;
    ArrayClear(this.m_entriesData);
    if data.IsEmpty || data.AbilitiesSize == 0 {
      this.m_isEmpty = data.IsEmpty;
      if Equals(data.Quality, gamedataQuality.Invalid) {
        this.m_colorState = n"Empty";
      } else {
        this.m_colorState = UIItemsHelper.QualityStringToStateName(UIItemsHelper.QualityEnumToString(data.Quality));
      };
      ArrayPush(this.m_entriesData, NewItemTooltipAttachmentEntryData.Make(data.SlotName));
    } else {
      this.m_isEmpty = false;
      this.m_colorState = UIItemsHelper.QualityStringToStateName(UIItemsHelper.QualityEnumToString(data.Quality));
      i = 0;
      while i < data.AbilitiesSize {
        ability = data.Abilities[i];
        if NotEquals(ability.Description, "") {
          ArrayPush(this.m_entriesData, NewItemTooltipAttachmentEntryData.Make(ability.Description, ability.LocalizationDataPackage));
        } else {
          ArrayPush(this.m_entriesData, NewItemTooltipAttachmentEntryData.Make(GetLocalizedText("UI-Labels-EmptySlot")));
        };
        i += 1;
      };
    };
    this.Update();
  }

  private final func Update() -> Void {
    this.UpdateEntries();
    this.UpdateState();
  }

  private final func UpdateEntries() -> Void {
    let i: Int32;
    let limit: Int32;
    let dataSize: Int32 = ArraySize(this.m_entriesData);
    while this.m_requestedEntries < dataSize {
      this.AsyncSpawnFromLocal(inkWidgetRef.Get(this.m_entriesContainer), n"itemTooltipModEntry", this, n"OnEntrySpawned");
      this.m_requestedEntries += 1;
    };
    i = 0;
    limit = ArraySize(this.m_entriesControllers);
    while i < limit {
      if i < dataSize {
        this.m_entriesControllers[i].GetRootWidget().SetVisible(true);
        this.m_entriesControllers[i].SetData(this.m_entriesData[i]);
      } else {
        this.m_entriesControllers[i].GetRootWidget().SetVisible(false);
      };
      i += 1;
    };
  }

  private final func UpdateState() -> Void {
    inkWidgetRef.SetVisible(this.m_rarityWidget, !this.m_isEmpty);
    inkWidgetRef.SetState(this.m_rarityContainer, this.m_colorState);
    inkWidgetRef.SetVisible(this.m_indicatorWidget, !this.m_isEmpty);
  }

  protected cb func OnEntrySpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
    let index: Int32;
    ArrayPush(this.m_entriesControllers, widget.GetController() as NewItemTooltipAttachmentEntryController);
    index = ArraySize(this.m_entriesControllers) - 1;
    if index >= ArraySize(this.m_entriesData) {
      widget.SetVisible(false);
    } else {
      (widget.GetController() as NewItemTooltipAttachmentEntryController).GetContext(this.m_isCrafting);
      (widget.GetController() as NewItemTooltipAttachmentEntryController).SetData(this.m_entriesData[index]);
    };
  }

  public final func GetContext(isCrafting: Bool) -> Void {
    this.m_isCrafting = isCrafting;
  }
}

public class NewItemTooltipAttachmentEntryController extends inkLogicController {

  protected edit let m_text: inkTextRef;

  protected edit let m_attunementContainer: inkWidgetRef;

  protected edit let m_attunementText: inkTextRef;

  protected edit let m_attunementIcon: inkImageRef;

  protected let m_settings: ref<UserSettings>;

  protected let m_settingsListener: ref<NewItemTooltipAttachmentEntrySettingsListener>;

  @default(NewItemTooltipAttachmentEntryController, /accessibility/interface)
  protected let m_groupPath: CName;

  protected let m_bigFontEnabled: Bool;

  protected let m_isCrafting: Bool;

  protected cb func OnInitialize() -> Bool {
    inkWidgetRef.SetVisible(this.m_attunementContainer, false);
  }

  public final func SetData(data: ref<NewItemTooltipAttachmentEntryData>) -> Void {
    inkTextRef.SetText(this.m_text, data.text);
    inkWidgetRef.SetState(this.m_text, data.colorState);
    this.m_settings = new UserSettings();
    this.m_settingsListener = new NewItemTooltipAttachmentEntrySettingsListener();
    this.m_settingsListener.RegisterController(this);
    this.m_settingsListener.Register(this.m_groupPath);
    this.NewUpdateTooltipSize();
    if IsDefined(data.dataPackage) && Cast<Bool>(data.dataPackage.GetParamsCount()) {
      inkTextRef.SetTextParameters(this.m_text, data.dataPackage.GetTextParams());
    };
    if data.attunementData != null {
      inkTextRef.SetText(this.m_attunementText, data.attunementData.Name);
      InkImageUtils.RequestSetImage(this, this.m_attunementIcon, data.attunementData.Icon);
      inkWidgetRef.SetVisible(this.m_attunementContainer, true);
    } else {
      inkWidgetRef.SetVisible(this.m_attunementContainer, false);
    };
  }

  public final func OnVarModified(groupPath: CName, varName: CName, varType: ConfigVarType, reason: ConfigChangeReason) -> Void {
    switch varName {
      case n"BigFont":
        this.NewUpdateTooltipSize();
        break;
      default:
    };
  }

  private final func NewUpdateTooltipSize() -> Void {
    let configVar: ref<ConfigVarBool> = this.m_settings.GetVar(this.m_groupPath, n"BigFont") as ConfigVarBool;
    this.NewSetTooltipSize(configVar.GetValue());
  }

  protected func NewSetTooltipSize(value: Bool) -> Void {
    if Equals(value, true) && !this.m_isCrafting {
      inkTextRef.SetWrappingAtPosition(this.m_text, 668.00);
      this.m_bigFontEnabled = true;
    } else {
      inkTextRef.SetWrappingAtPosition(this.m_text, 538.00);
      this.m_bigFontEnabled = false;
    };
  }

  public final func GetContext(isCrafting: Bool) -> Void {
    this.m_isCrafting = isCrafting;
  }
}

public class NewItemTooltipAttachmentEntrySettingsListener extends ConfigVarListener {

  private let m_ctrl: wref<NewItemTooltipAttachmentEntryController>;

  public final func RegisterController(ctrl: ref<NewItemTooltipAttachmentEntryController>) -> Void {
    this.m_ctrl = ctrl;
  }

  public func OnVarModified(groupPath: CName, varName: CName, varType: ConfigVarType, reason: ConfigChangeReason) -> Void {
    this.m_ctrl.OnVarModified(groupPath, varName, varType, reason);
  }
}

public class NewItemTooltipAttachmentEntryData extends IScriptable {

  public let text: String;

  public let colorState: CName;

  public let dataPackage: ref<UILocalizationDataPackage>;

  public let attunementData: ref<UIInventoryItemModAttunementData>;

  public final static func Make(text: String, opt dataPackage: ref<UILocalizationDataPackage>, opt attunementData: ref<UIInventoryItemModAttunementData>) -> ref<NewItemTooltipAttachmentEntryData> {
    return NewItemTooltipAttachmentEntryData.Make(text, n"Default", dataPackage, attunementData);
  }

  public final static func Make(text: String, colorState: CName, opt dataPackage: ref<UILocalizationDataPackage>, opt attunementData: ref<UIInventoryItemModAttunementData>) -> ref<NewItemTooltipAttachmentEntryData> {
    let instance: ref<NewItemTooltipAttachmentEntryData> = new NewItemTooltipAttachmentEntryData();
    instance.text = text;
    instance.colorState = colorState;
    instance.dataPackage = dataPackage;
    instance.attunementData = attunementData;
    return instance;
  }
}
