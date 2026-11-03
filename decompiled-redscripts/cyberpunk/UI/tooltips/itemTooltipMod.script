
public class ItemTooltipModController extends inkLogicController {

  protected edit let m_dotIndicator: inkWidgetRef;

  protected edit let m_rarityContainer: inkWidgetRef;

  protected edit let m_rarityWidget: inkImageRef;

  protected edit let m_modAbilitiesContainer: inkCompoundRef;

  protected let m_partIndicatorController: wref<InventoryItemPartDisplay>;

  protected edit let m_isCrafting: Bool;

  public final static func StaticDefaultColorState() -> CName {
    return n"Default";
  }

  public final func DefaultColorState() -> CName {
    return n"Default";
  }

  protected func EntryWidgetToSpawn() -> CName {
    return n"itemTooltipModEntry";
  }

  public final func SetData(record: wref<GameplayLogicPackageUIData_Record>) -> Void {
    inkCompoundRef.RemoveAllChildren(this.m_modAbilitiesContainer);
    this.SpawnController().Setup(record, this.m_isCrafting);
  }

  public final func SetData(record: wref<GameplayLogicPackageUIData_Record>, itemData: wref<gameItemData>) -> Void {
    inkCompoundRef.RemoveAllChildren(this.m_modAbilitiesContainer);
    this.SpawnController().Setup(record, itemData, this.m_isCrafting);
  }

  public final func SetData(record: wref<GameplayLogicPackageUIData_Record>, innerItemData: InnerItemData) -> Void {
    inkCompoundRef.RemoveAllChildren(this.m_modAbilitiesContainer);
    this.SpawnController().Setup(record, innerItemData, this.m_isCrafting);
  }

  public final func SetData(const ability: script_ref<InventoryItemAbility>) -> Void {
    inkCompoundRef.RemoveAllChildren(this.m_modAbilitiesContainer);
    this.SpawnController().Setup(ability, this.m_isCrafting);
  }

  public final func SetData(attachment: ref<InventoryItemAttachments>) -> Void {
    let abilitiesSize: Int32;
    let i: Int32;
    let quality: CName;
    let slotName: String;
    inkCompoundRef.RemoveAllChildren(this.m_modAbilitiesContainer);
    quality = InventoryItemData.GetQuality(attachment.ItemData);
    inkWidgetRef.SetVisible(this.m_dotIndicator, true);
    inkWidgetRef.SetState(this.m_dotIndicator, IsNameValid(quality) ? quality : n"Empty");
    if InventoryItemData.IsEmpty(attachment.ItemData) {
      slotName = GetLocalizedText(UIItemsHelper.GetEmptySlotName(attachment.SlotID));
      if !IsStringValid(slotName) {
        slotName = UIItemsHelper.GetEmptySlotName(attachment.SlotID);
      };
      this.SpawnController().Setup(slotName, this.m_isCrafting);
      return;
    };
    abilitiesSize = InventoryItemData.GetAbilitiesSize(attachment.ItemData);
    if abilitiesSize == 0 {
      this.SpawnController().Setup(InventoryItemData.GetName(attachment.ItemData), this.m_isCrafting);
      return;
    };
    i = 0;
    while i < abilitiesSize {
      this.SpawnController().Setup(InventoryItemData.GetAbility(attachment.ItemData, i), this.m_isCrafting);
      i += 1;
    };
  }

  public final func SetData(data: ref<MinimalItemTooltipModData>) -> Void {
    if IsDefined(data as MinimalItemTooltipModRecordData) {
      this.SetData(data as MinimalItemTooltipModRecordData);
    } else {
      this.SetData(data as MinimalItemTooltipModAttachmentData);
    };
  }

  public final func SetData(data: ref<MinimalItemTooltipModRecordData>) -> Void {
    inkCompoundRef.RemoveAllChildren(this.m_modAbilitiesContainer);
    this.SpawnController().Setup(data, this.m_isCrafting);
    this.HideDotIndicator();
  }

  public final func SetData(data: ref<MinimalItemTooltipModAttachmentData>) -> Void {
    let i: Int32;
    inkCompoundRef.RemoveAllChildren(this.m_modAbilitiesContainer);
    inkWidgetRef.SetVisible(this.m_dotIndicator, true);
    inkWidgetRef.SetState(this.m_rarityWidget, data.qualityName);
    if data.isEmpty || data.abilitiesSize == 0 {
      inkWidgetRef.SetState(this.m_rarityContainer, n"Common");
      this.SpawnController().Setup(data.slotName, this.m_isCrafting);
    } else {
      i = 0;
      while i < data.abilitiesSize {
        inkWidgetRef.SetState(this.m_rarityContainer, data.qualityName);
        this.SpawnController().Setup(data.abilities[i], this.m_isCrafting);
        i += 1;
      };
    };
  }

  public final func SetData(data: ref<UIInventoryItemMod>) -> Void {
    if IsDefined(data as UIInventoryItemModDataPackage) {
      this.SetData(data as UIInventoryItemModDataPackage);
    } else {
      this.SetData(data as UIInventoryItemModAttachment);
    };
  }

  public final func SetData(data: ref<UIInventoryItemModDataPackage>) -> Void {
    inkCompoundRef.RemoveAllChildren(this.m_modAbilitiesContainer);
    this.SpawnController().Setup(data, this.m_isCrafting);
    this.HideDotIndicator();
  }

  public final func SetData(data: ref<UIInventoryItemModAttachment>) -> Void {
    let i: Int32;
    inkCompoundRef.RemoveAllChildren(this.m_modAbilitiesContainer);
    inkWidgetRef.SetVisible(this.m_dotIndicator, true);
    inkWidgetRef.SetState(this.m_rarityWidget, UIItemsHelper.QualityEnumToName(data.Quality));
    inkWidgetRef.SetState(this.m_rarityContainer, UIItemsHelper.QualityEnumToName(data.Quality));
    if data.IsEmpty || data.AbilitiesSize == 0 {
      this.SpawnController().Setup(data.SlotName, this.m_isCrafting);
    } else {
      i = 0;
      while i < data.AbilitiesSize {
        this.SpawnController().Setup(data.Abilities[i], this.m_isCrafting);
        i += 1;
      };
    };
  }

  private final func SpawnController() -> wref<ItemTooltipModEntryController> {
    let widget: wref<inkWidget> = this.SpawnFromLocal(inkWidgetRef.Get(this.m_modAbilitiesContainer), this.EntryWidgetToSpawn());
    widget.SetVAlign(inkEVerticalAlign.Top);
    widget.SetHAlign(inkEHorizontalAlign.Left);
    return widget.GetController() as ItemTooltipModEntryController;
  }

  public final func HideDotIndicator() -> Void {
    inkWidgetRef.SetVisible(this.m_dotIndicator, false);
  }

  public final func GetContext(isCrafting: Bool) -> Void {
    this.m_isCrafting = isCrafting;
  }
}

public class ItemTooltipModEntryController extends inkLogicController {

  protected edit let m_modName: inkTextRef;

  protected edit let m_attunementContainer: inkWidgetRef;

  protected edit let m_attunementText: inkTextRef;

  protected edit let m_attunementIcon: inkImageRef;

  protected edit let m_attunementLine: inkWidgetRef;

  protected let m_settings: ref<UserSettings>;

  protected let m_settingsListener: ref<ItemTooltipModSettingsListener>;

  @default(ItemTooltipModEntryController, /accessibility/interface)
  protected let m_groupPath: CName;

  protected let m_bigFontEnabled: Bool;

  protected let m_isCrafting: Bool;

  protected cb func OnInitialize() -> Bool {
    inkWidgetRef.SetVisible(this.m_attunementContainer, false);
  }

  public final func Setup(const text: script_ref<String>, isCrafting: Bool) -> Void {
    inkTextRef.SetText(this.m_modName, Deref(text));
    this.m_settings = new UserSettings();
    this.m_settingsListener = new ItemTooltipModSettingsListener();
    this.m_settingsListener.RegisterController(this);
    this.m_settingsListener.Register(this.m_groupPath);
    this.m_isCrafting = isCrafting;
    this.NewUpdateTooltipSize();
  }

  public final func Setup(data: ref<MinimalItemTooltipModRecordData>, isCrafting: Bool) -> Void {
    inkTextRef.SetText(this.m_modName, data.description);
    if Cast<Bool>(data.dataPackage.GetParamsCount()) {
      inkTextRef.SetTextParameters(this.m_modName, data.dataPackage.GetTextParams());
    };
    if data.attunementData != null {
      inkTextRef.SetText(this.m_attunementText, data.attunementData.name);
      InkImageUtils.RequestSetImage(this, this.m_attunementIcon, data.attunementData.icon);
      inkWidgetRef.SetVisible(this.m_attunementContainer, true);
    } else {
      inkWidgetRef.SetVisible(this.m_attunementContainer, false);
    };
    this.m_settings = new UserSettings();
    this.m_settingsListener = new ItemTooltipModSettingsListener();
    this.m_settingsListener.RegisterController(this);
    this.m_settingsListener.Register(this.m_groupPath);
    this.m_isCrafting = isCrafting;
    this.NewUpdateTooltipSize();
  }

  public final func Setup(data: ref<UIInventoryItemModDataPackage>, isCrafting: Bool) -> Void {
    inkTextRef.SetText(this.m_modName, data.Description);
    if Cast<Bool>(data.DataPackage.GetParamsCount()) {
      inkTextRef.SetTextParameters(this.m_modName, data.DataPackage.GetTextParams());
    };
    if data.AttunementData != null {
      inkTextRef.SetText(this.m_attunementText, data.AttunementData.Name);
      InkImageUtils.RequestSetImage(this, this.m_attunementIcon, data.AttunementData.Icon);
      inkWidgetRef.SetVisible(this.m_attunementContainer, true);
    } else {
      inkWidgetRef.SetVisible(this.m_attunementContainer, false);
    };
    this.m_settings = new UserSettings();
    this.m_settingsListener = new ItemTooltipModSettingsListener();
    this.m_settingsListener.RegisterController(this);
    this.m_settingsListener.Register(this.m_groupPath);
    this.m_isCrafting = isCrafting;
    this.NewUpdateTooltipSize();
  }

  public final func Setup(record: wref<GameplayLogicPackageUIData_Record>, isCrafting: Bool) -> Void {
    let dataPackage: ref<UILocalizationDataPackage>;
    inkTextRef.SetText(this.m_modName, record.LocalizedDescription());
    dataPackage = UILocalizationDataPackage.FromLogicUIDataPackage(record);
    if Cast<Bool>(dataPackage.GetParamsCount()) {
      inkTextRef.SetTextParameters(this.m_modName, dataPackage.GetTextParams());
    };
    this.m_settings = new UserSettings();
    this.m_settingsListener = new ItemTooltipModSettingsListener();
    this.m_settingsListener.RegisterController(this);
    this.m_settingsListener.Register(this.m_groupPath);
    this.m_isCrafting = isCrafting;
    this.NewUpdateTooltipSize();
  }

  public final func Setup(record: wref<GameplayLogicPackageUIData_Record>, itemData: wref<gameItemData>, isCrafting: Bool) -> Void {
    let dataPackage: ref<UILocalizationDataPackage>;
    inkTextRef.SetText(this.m_modName, record.LocalizedDescription());
    dataPackage = UILocalizationDataPackage.FromLogicUIDataPackage(record, itemData);
    if Cast<Bool>(dataPackage.GetParamsCount()) {
      inkTextRef.SetTextParameters(this.m_modName, dataPackage.GetTextParams());
    };
    this.m_settings = new UserSettings();
    this.m_settingsListener = new ItemTooltipModSettingsListener();
    this.m_settingsListener.RegisterController(this);
    this.m_settingsListener.Register(this.m_groupPath);
    this.m_isCrafting = isCrafting;
    this.NewUpdateTooltipSize();
  }

  public final func Setup(record: wref<GameplayLogicPackageUIData_Record>, partItemData: InnerItemData, isCrafting: Bool) -> Void {
    let dataPackage: ref<UILocalizationDataPackage>;
    inkTextRef.SetText(this.m_modName, record.LocalizedDescription());
    dataPackage = UILocalizationDataPackage.FromLogicUIDataPackage(record, partItemData);
    if Cast<Bool>(dataPackage.GetParamsCount()) {
      inkTextRef.SetTextParameters(this.m_modName, dataPackage.GetTextParams());
    };
    this.m_settings = new UserSettings();
    this.m_settingsListener = new ItemTooltipModSettingsListener();
    this.m_settingsListener.RegisterController(this);
    this.m_settingsListener.Register(this.m_groupPath);
    this.m_isCrafting = isCrafting;
    this.NewUpdateTooltipSize();
  }

  public final func Setup(const ability: script_ref<InventoryItemAbility>, isCrafting: Bool) -> Void {
    if NotEquals(Deref(ability).Description, "") {
      inkTextRef.SetText(this.m_modName, Deref(ability).Description);
      if Deref(ability).LocalizationDataPackage.GetParamsCount() > 0 {
        inkTextRef.SetTextParameters(this.m_modName, Deref(ability).LocalizationDataPackage.GetTextParams());
      };
    } else {
      inkTextRef.SetText(this.m_modName, GetLocalizedText("UI-Labels-EmptySlot"));
    };
    this.m_settings = new UserSettings();
    this.m_settingsListener = new ItemTooltipModSettingsListener();
    this.m_settingsListener.RegisterController(this);
    this.m_settingsListener.Register(this.m_groupPath);
    this.m_isCrafting = isCrafting;
    this.NewUpdateTooltipSize();
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
      inkTextRef.SetWrappingAtPosition(this.m_modName, 700.00);
      inkTextRef.SetWrappingAtPosition(this.m_attunementText, 700.00);
      inkWidgetRef.SetSize(this.m_attunementLine, 750.00, 2.00);
      this.m_bigFontEnabled = true;
    } else {
      inkTextRef.SetWrappingAtPosition(this.m_modName, 580.00);
      inkTextRef.SetWrappingAtPosition(this.m_attunementText, 580.00);
      inkWidgetRef.SetSize(this.m_attunementLine, 650.00, 2.00);
      this.m_bigFontEnabled = false;
    };
  }
}

public class ItemTooltipModSettingsListener extends ConfigVarListener {

  private let m_ctrl: wref<ItemTooltipModEntryController>;

  public final func RegisterController(ctrl: ref<ItemTooltipModEntryController>) -> Void {
    this.m_ctrl = ctrl;
  }

  public func OnVarModified(groupPath: CName, varName: CName, varType: ConfigVarType, reason: ConfigChangeReason) -> Void {
    this.m_ctrl.OnVarModified(groupPath, varName, varType, reason);
  }
}
