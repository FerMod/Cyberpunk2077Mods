
public class CyberdeckTooltip extends AGenericTooltipController {

  protected edit let m_itemNameText: inkTextRef;

  protected edit let m_nameTextContainer: inkWidgetRef;

  protected edit let m_nameForRecipeText: inkTextRef;

  protected edit let m_itemRarityText: inkTextRef;

  protected edit let m_rarityBars: inkWidgetRef;

  protected edit let m_categoriesWrapper: inkCompoundRef;

  protected edit let m_topContainer: inkCompoundRef;

  protected edit let m_headerContainer: inkCompoundRef;

  protected edit let m_statsContainer: inkCompoundRef;

  protected edit let m_hacksContainer: inkCompoundRef;

  protected edit let m_descriptionContainer: inkCompoundRef;

  protected edit let m_bottomContainer: inkCompoundRef;

  protected edit let m_statsList: inkCompoundRef;

  protected edit let m_priceContainer: inkCompoundRef;

  protected edit let m_descriptionText: inkTextRef;

  protected edit let m_priceText: inkTextRef;

  protected edit let m_equipedWrapper: inkWidgetRef;

  protected edit let m_itemTypeText: inkTextRef;

  protected edit let m_itemWeightWrapper: inkWidgetRef;

  protected edit let m_itemWeightText: inkTextRef;

  protected edit let m_cybderdeckBaseMemoryValue: inkTextRef;

  protected edit let m_cybderdeckBufferValue: inkTextRef;

  protected edit let m_cybderdeckSlotsValue: inkTextRef;

  protected edit let m_deviceHacksGrid: inkCompoundRef;

  protected edit let m_deviceHackHeader: inkTextRef;

  protected edit let m_namesTextContainer: inkWidgetRef;

  protected edit let m_deviceHackNamesText: inkTextRef;

  protected edit let m_textBG: inkWidgetRef;

  protected edit let m_namesTextContainer2: inkWidgetRef;

  protected edit let m_deviceHackNamesText2: inkTextRef;

  protected edit let m_textBG2: inkWidgetRef;

  protected edit let m_namesTextContainer3: inkWidgetRef;

  protected edit let m_deviceHackNamesText3: inkTextRef;

  protected edit let m_textBG3: inkWidgetRef;

  protected edit let m_namesTextContainer4: inkWidgetRef;

  protected edit let m_deviceHackNamesText4: inkTextRef;

  protected edit let m_textBG4: inkWidgetRef;

  protected edit let m_itemIconImage: inkImageRef;

  protected edit let m_itemAttributeRequirementsWrapper: inkWidgetRef;

  protected edit let m_itemAttributeRequirements: inkWidgetRef;

  protected edit let m_itemAttributeRequirementsText: inkTextRef;

  protected edit let m_allocationCostsWrapper: inkCompoundRef;

  protected edit let m_iconicLines: inkImageRef;

  protected edit let m_equipedCorner: inkWidgetRef;

  protected edit let m_root: inkWidgetRef;

  protected edit let m_iconicBG: inkWidgetRef;

  protected edit let m_recipeWrapper: inkWidgetRef;

  protected edit let m_recipeBG: inkWidgetRef;

  protected edit let m_illegalBG: inkWidgetRef;

  protected edit let m_cyberwareUpgradeContainer: inkWidgetRef;

  protected edit let m_itemCWQuickHackMenuLinkContainer: inkWidgetRef;

  @default(CyberdeckTooltip, base\gameplay\gui\common\tooltip\cyberware_tooltip_modules.inkwidget)
  protected edit let m_additionalModulesLibraryRes: ResRef;

  @default(CyberdeckTooltip, itemCyberwareUpgrade)
  protected edit let m_cyberwareUpgradeModuleName: CName;

  protected let m_rarityBarsController: wref<LevelBarsController>;

  protected let m_data: ref<InventoryTooltipData>;

  private let m_itemDisplayContext: ItemDisplayContext;

  protected let m_player: wref<PlayerPuppet>;

  protected let m_cyberwareUpgradeController: wref<ItemTooltipCyberwareUpgradeController>;

  protected let m_hasVehiclePerk: Bool;

  protected let m_animProxy: ref<inkAnimProxy>;

  protected let m_settings: ref<UserSettings>;

  protected let m_settingsListener: ref<CyberdeckTooltipSettingsListener>;

  @default(CyberdeckTooltip, /accessibility/interface)
  protected let m_groupPath: CName;

  protected edit let m_minWidth: inkWidgetRef;

  protected let m_bigFontEnabled: Bool;

  protected let m_itemData: wref<UIInventoryItem>;

  protected let m_displayContext: ref<ItemDisplayContextData>;

  protected let m_comparisonData: ref<UIInventoryItemComparisonManager>;

  protected let m_tooltipDisplayContext: InventoryTooltipDisplayContext;

  protected cb func OnInitialize() -> Bool {
    super.OnInitialize();
    this.m_rarityBarsController = inkWidgetRef.GetController(this.m_rarityBars) as LevelBarsController;
  }

  public func SetData(tooltipData: ref<ATooltipData>) -> Void {
    let tooltipWrapper: ref<UIInventoryItemTooltipWrapper>;
    this.m_settings = new UserSettings();
    this.m_settingsListener = new CyberdeckTooltipSettingsListener();
    this.m_settingsListener.RegisterController(this);
    this.m_settingsListener.Register(this.m_groupPath);
    this.UpdateTooltipSize();
    if IsDefined(tooltipData as InventoryTooltipData) {
      this.m_data = tooltipData as InventoryTooltipData;
      this.m_player = this.m_data.GetManager().GetAttachedPlayer();
      this.m_hasVehiclePerk = this.m_data.cyberdeckData.vehicleHackUnlocked;
      this.UpdateLayout();
    } else {
      if IsDefined(tooltipData as UIInventoryItemTooltipWrapper) {
        tooltipWrapper = tooltipData as UIInventoryItemTooltipWrapper;
        this.m_itemData = tooltipWrapper.m_data;
        this.m_comparisonData = tooltipWrapper.m_comparisonData;
        this.m_player = tooltipWrapper.m_displayContext.GetPlayerAsPuppet();
        this.m_displayContext = tooltipWrapper.m_displayContext;
        this.m_hasVehiclePerk = Cast<Bool>(PlayerDevelopmentSystem.GetData(this.m_player).IsNewPerkBought(gamedataNewPerkType.Intelligence_Right_Milestone_1));
        this.NEW_UpdateLayout();
      };
    };
  }

  public func Show() -> Void {
    super.Show();
    if IsDefined(this.m_animProxy) {
      this.m_animProxy.Stop();
      this.m_animProxy = null;
    };
    this.m_animProxy = this.PlayLibraryAnimationOnAutoSelectedTargets(n"show_item_tooltip", this.GetRootWidget());
    this.m_animProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnShowAnimationFinished");
  }

  protected final func UpdateLayout() -> Void {
    let itemRecord: wref<Item_Record> = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(InventoryItemData.GetID(this.m_data.inventoryItemData)));
    let itemData: ref<gameItemData> = InventoryItemData.GetGameItemData(this.m_data.inventoryItemData);
    this.UpdateName();
    this.UpdateRarity();
    this.UpdateCyberdeckStats();
    this.UpdateAbilities(itemData, itemRecord);
    this.GetDeviceHackNames(itemData, itemRecord);
    this.UpdateDescription(this.m_data.description);
    this.UpdatePrice();
    this.UpdateWeight(itemData.GetStatValueByType(gamedataStatType.Weight));
    this.UpdateIcon();
    this.UpdateRequirements();
    this.UpdateAllocationStats();
    this.UpdateIconicBG(RPGManager.IsItemIconic(InventoryItemData.GetGameItemData(this.m_data.inventoryItemData)));
    this.UpdateRecipeBG(this.m_data.parentItemData.HasTag(n"Recipe") && NotEquals(this.m_tooltipDisplayContext, InventoryTooltipDisplayContext.Crafting));
    this.UpdateIllegalBG(this.m_data.parentItemData.HasTag(n"IllegalItem"));
    this.UpdateCyberwareUpgradeModule();
    this.UpdateCyberwareQuickHackMenuLinkModule();
    inkWidgetRef.SetVisible(this.m_equipedWrapper, this.m_data.isEquipped);
    inkWidgetRef.SetVisible(this.m_equipedCorner, this.m_data.isEquipped);
    inkWidgetRef.SetVisible(this.m_recipeWrapper, this.m_data.parentItemData.HasTag(n"Recipe") && NotEquals(this.m_tooltipDisplayContext, InventoryTooltipDisplayContext.Crafting));
    if Equals(this.m_data.isEquipped, true) {
      inkWidgetRef.SetState(this.m_root, n"Equipped");
    } else {
      inkWidgetRef.SetState(this.m_root, n"Default");
    };
    this.FixLines();
  }

  protected final func NEW_UpdateLayout() -> Void {
    this.NEW_UpdateName();
    this.NEW_UpdateRarity();
    this.NEW_UpdateCyberdeckStats();
    this.UpdateAbilities(this.m_itemData.GetItemData(), this.m_itemData.GetItemRecord());
    this.GetDeviceHackNames(this.m_itemData.GetItemData(), this.m_itemData.GetItemRecord());
    this.UpdateDescription(this.m_itemData.GetDescription());
    this.NEW_UpdatePrice();
    this.UpdateWeight(this.m_itemData.GetWeight());
    this.NEW_UpdateIcon();
    this.UpdateRequirements();
    this.NEW_UpdateAttributeAllocationStats(this.m_itemData, this.m_displayContext.GetPlayerAsPuppet());
    this.UpdateIconicBG(this.m_itemData.IsIconic());
    this.UpdateRecipeBG(this.m_itemData.IsRecipe() && !this.m_displayContext.IsCraftingItem());
    this.UpdateIllegalBG(this.m_itemData.IsIllegal());
    this.UpdateCyberwareUpgradeModule();
    this.NEW_UpdateCyberwareQuickHackMenuLinkModule();
    inkWidgetRef.SetVisible(this.m_equipedWrapper, this.m_itemData.IsEquipped());
    inkWidgetRef.SetVisible(this.m_equipedCorner, this.m_itemData.IsEquipped());
    inkWidgetRef.SetVisible(this.m_recipeWrapper, this.m_itemData.IsRecipe() && !this.m_displayContext.IsCraftingItem());
    if Equals(this.m_itemData.IsEquipped(), true) {
      inkWidgetRef.SetState(this.m_root, n"Equipped");
    } else {
      inkWidgetRef.SetState(this.m_root, n"Default");
    };
    this.FixLines();
  }

  protected func UpdateIconicBG(visible: Bool) -> Void {
    if visible {
      inkWidgetRef.SetVisible(this.m_iconicBG, true);
    } else {
      inkWidgetRef.SetVisible(this.m_iconicBG, false);
    };
  }

  protected func UpdateRecipeBG(visible: Bool) -> Void {
    if visible {
      inkWidgetRef.SetVisible(this.m_recipeBG, true);
      inkWidgetRef.SetVisible(this.m_itemNameText, false);
      inkWidgetRef.SetVisible(this.m_nameTextContainer, false);
      inkWidgetRef.SetVisible(this.m_nameForRecipeText, true);
    } else {
      inkWidgetRef.SetVisible(this.m_recipeBG, false);
      inkWidgetRef.SetVisible(this.m_itemNameText, true);
      inkWidgetRef.SetVisible(this.m_nameTextContainer, true);
      inkWidgetRef.SetVisible(this.m_nameForRecipeText, false);
    };
  }

  protected func UpdateIllegalBG(visible: Bool) -> Void {
    if visible {
      inkWidgetRef.SetVisible(this.m_illegalBG, true);
    } else {
      inkWidgetRef.SetVisible(this.m_illegalBG, false);
    };
  }

  protected final func GetAbilities(itemData: ref<gameItemData>, itemRecord: wref<Item_Record>) -> [InventoryItemAbility] {
    let GLPAbilities: array<wref<GameplayLogicPackage_Record>>;
    let abilities: array<InventoryItemAbility>;
    let ability: InventoryItemAbility;
    let i: Int32;
    let limit: Int32;
    let uiData: wref<GameplayLogicPackageUIData_Record>;
    itemRecord.OnAttach(GLPAbilities);
    i = 0;
    limit = ArraySize(GLPAbilities);
    while i < limit {
      if IsDefined(GLPAbilities[i]) {
        uiData = GLPAbilities[i].UIData();
        if IsDefined(uiData) {
          ability = new InventoryItemAbility(uiData.IconPath(), uiData.LocalizedName(), uiData.LocalizedDescription(), UILocalizationDataPackage.FromLogicUIDataPackage(uiData, itemData));
          ArrayPush(abilities, ability);
        };
      };
      i += 1;
    };
    ArrayClear(GLPAbilities);
    itemRecord.OnEquip(GLPAbilities);
    i = 0;
    limit = ArraySize(GLPAbilities);
    while i < limit {
      if IsDefined(GLPAbilities[i]) {
        uiData = GLPAbilities[i].UIData();
        if IsDefined(uiData) {
          ability = new InventoryItemAbility(uiData.IconPath(), uiData.LocalizedName(), uiData.LocalizedDescription(), UILocalizationDataPackage.FromLogicUIDataPackage(uiData, itemData));
          ArrayPush(abilities, ability);
        };
      };
      i += 1;
    };
    return abilities;
  }

  protected final func UpdateAbilities(itemData: ref<gameItemData>, itemRecord: wref<Item_Record>) -> Void {
    let controller: ref<CyberdeckStatController>;
    let i: Int32;
    let abilities: array<InventoryItemAbility> = this.GetAbilities(itemData, itemRecord);
    let abilitiesSize: Int32 = ArraySize(abilities);
    if abilitiesSize > 0 {
      while inkCompoundRef.GetNumChildren(this.m_statsList) > abilitiesSize {
        inkCompoundRef.RemoveChildByIndex(this.m_statsList, 0);
      };
      while inkCompoundRef.GetNumChildren(this.m_statsList) < abilitiesSize {
        this.SpawnFromLocal(inkWidgetRef.Get(this.m_statsList), n"cyberdeckStat");
      };
      i = 0;
      while i < abilitiesSize {
        controller = inkCompoundRef.GetWidgetByIndex(this.m_statsList, i).GetController() as CyberdeckStatController;
        controller.Setup(abilities[i]);
        i += 1;
      };
      inkWidgetRef.SetVisible(this.m_statsContainer, abilitiesSize > 0);
    } else {
      inkWidgetRef.SetVisible(this.m_statsContainer, false);
    };
  }

  protected final func UpdateCyberdeckStats() -> Void {
    let cyberdeckBufferValue: Float;
    let i: Int32;
    let j: Int32;
    let memoryValue: Float;
    let onEquipList: array<wref<GameplayLogicPackage_Record>>;
    let slots: Int32;
    let slots2: array<SPartSlots>;
    let stat: wref<ConstantStatModifier_Record>;
    let statType: wref<Stat_Record>;
    let statsList: array<wref<StatModifier_Record>>;
    let tweakID: TweakDBID = ItemID.GetTDBID(InventoryItemData.GetID(this.m_data.inventoryItemData));
    let tweakRecord: wref<Item_Record> = TweakDBInterface.GetItemRecord(tweakID);
    tweakRecord.OnEquip(onEquipList);
    i = 0;
    while i < ArraySize(onEquipList) {
      onEquipList[i].Stats(statsList);
      j = 0;
      while j < ArraySize(statsList) {
        statType = statsList[j].StatType();
        stat = statsList[j] as ConstantStatModifier_Record;
        if IsDefined(stat) {
          if Equals(statType.StatType(), gamedataStatType.Memory) {
            memoryValue = stat.Value();
          } else {
            if Equals(statType.StatType(), gamedataStatType.BufferSize) {
              cyberdeckBufferValue = stat.Value();
            };
          };
        };
        j += 1;
      };
      i += 1;
    };
    slots = InventoryItemData.GetAttachmentsSize(this.m_data.inventoryItemData);
    if slots == 0 {
      slots2 = ItemModificationSystem.GetSlotsForCyberdeckFromItemData(InventoryItemData.GetGameItemData(this.m_data.inventoryItemData));
      slots = ArraySize(slots2);
    };
    inkTextRef.SetText(this.m_cybderdeckBaseMemoryValue, FloatToStringPrec(memoryValue, 0));
    inkTextRef.SetText(this.m_cybderdeckBufferValue, FloatToStringPrec(cyberdeckBufferValue, 0));
    inkTextRef.SetText(this.m_cybderdeckSlotsValue, IntToString(slots));
  }

  protected final func NEW_UpdateCyberdeckStats() -> Void {
    let cyberdeckBufferValue: Float;
    let i: Int32;
    let j: Int32;
    let memoryValue: Float;
    let onEquipList: array<wref<GameplayLogicPackage_Record>>;
    let slots: Int32;
    let slots2: array<SPartSlots>;
    let stat: wref<ConstantStatModifier_Record>;
    let statType: wref<Stat_Record>;
    let statsList: array<wref<StatModifier_Record>>;
    this.m_itemData.GetItemRecord().OnEquip(onEquipList);
    i = 0;
    while i < ArraySize(onEquipList) {
      onEquipList[i].Stats(statsList);
      j = 0;
      while j < ArraySize(statsList) {
        statType = statsList[j].StatType();
        stat = statsList[j] as ConstantStatModifier_Record;
        if IsDefined(stat) {
          if Equals(statType.StatType(), gamedataStatType.Memory) {
            memoryValue = stat.Value();
          } else {
            if Equals(statType.StatType(), gamedataStatType.BufferSize) {
              cyberdeckBufferValue = stat.Value();
            };
          };
        };
        j += 1;
      };
      i += 1;
    };
    slots = this.m_itemData.GetModsManager().GetAllSlotsSize();
    if slots == 0 {
      slots2 = ItemModificationSystem.GetSlotsForCyberdeckFromItemData(this.m_itemData.GetItemData());
      slots = ArraySize(slots2);
    };
    inkTextRef.SetText(this.m_cybderdeckBaseMemoryValue, FloatToStringPrec(memoryValue, 0));
    inkTextRef.SetText(this.m_cybderdeckBufferValue, FloatToStringPrec(cyberdeckBufferValue, 0));
    inkTextRef.SetText(this.m_cybderdeckSlotsValue, IntToString(slots));
  }

  protected final func SetupDeviceHacks(itemRecord: wref<Item_Record>) -> Void {
    let controller: ref<CyberdeckDeviceHackIcon>;
    let i: Int32;
    let widget: wref<inkWidget>;
    let hacks: array<CyberdeckDeviceQuickhackData> = this.GetCyberdeckDeviceQuickhacks(itemRecord);
    inkCompoundRef.RemoveAllChildren(this.m_deviceHacksGrid);
    i = 0;
    while i < ArraySize(hacks) {
      widget = this.SpawnFromLocal(inkWidgetRef.Get(this.m_deviceHacksGrid), n"deviceHackIcon");
      controller = widget.GetController() as CyberdeckDeviceHackIcon;
      controller.Setup(hacks[i]);
      i += 1;
    };
  }

  protected final func GetDeviceHackNames(itemData: ref<gameItemData>, itemRecord: wref<Item_Record>) -> Void {
    let currentHack: CyberdeckDeviceQuickhackData;
    let currentName: String;
    let hackNamesTier1: String;
    let hackNamesTier2: String;
    let hackNamesTier3: String;
    let hackNamesTier45: String;
    let hacks: array<CyberdeckDeviceQuickhackData>;
    let uniqueActionNames: array<CName>;
    let quality: gamedataQuality = RPGManager.GetItemDataQuality(itemData);
    let showTier1: Bool = false;
    let showTier2: Bool = false;
    let showTier3: Bool = false;
    let showTier4: Bool = false;
    let allHacks: array<CyberdeckDeviceQuickhackData> = this.GetCyberdeckDeviceQuickhacks(itemRecord);
    let nextIndex: Int32 = 0;
    let i: Int32 = 0;
    while i < ArraySize(allHacks) {
      currentHack = allHacks[i];
      if ArrayContains(uniqueActionNames, currentHack.ObjectActionName) {
      } else {
        ArrayPush(uniqueActionNames, currentHack.ObjectActionName);
        if Equals(currentHack.ObjectActionType, gamedataObjectActionType.VehicleQuickHack) && this.m_hasVehiclePerk {
          ArrayPush(hacks, currentHack);
        } else {
          if Equals(currentHack.ObjectActionType, gamedataObjectActionType.DeviceQuickHack) {
            if Equals(currentHack.ObjectActionName, n"TakeControlClassHack") || Equals(currentHack.ObjectActionName, n"TurretToggleStateClassHack") || Equals(currentHack.ObjectActionName, n"TurretOverloadClassHack") {
              ArrayPush(hacks, currentHack);
            } else {
              ArrayInsert(hacks, nextIndex, currentHack);
              nextIndex += 1;
            };
          };
        };
      };
      i += 1;
    };
    i = 0;
    while i < ArraySize(hacks) {
      currentHack = hacks[i];
      currentName = GetLocalizedText(NameToString(currentHack.ObjectActionLocName));
      if Equals(currentHack.ObjectActionTier, gamedataDeviceHackTier.Tier4DeviceHack) || Equals(currentHack.ObjectActionTier, gamedataDeviceHackTier.Tier5DeviceHack) {
        if Equals(currentHack.ObjectActionType, gamedataObjectActionType.VehicleQuickHack) {
          currentName = GetLocalizedText(NameToString(currentHack.ObjectActionLocName)) + " (" + GetLocalizedText("LocKey#77971") + ")";
        };
        hackNamesTier45 += showTier4 ? ", " + currentName : "" + currentName;
        showTier4 = true;
      };
      if Equals(currentHack.ObjectActionTier, gamedataDeviceHackTier.Tier3DeviceHack) {
        if Equals(currentHack.ObjectActionType, gamedataObjectActionType.VehicleQuickHack) {
          currentName = GetLocalizedText(NameToString(currentHack.ObjectActionLocName)) + " (" + GetLocalizedText("LocKey#77971") + ")";
        };
        hackNamesTier3 += showTier3 ? ", " + currentName : "" + currentName;
        showTier3 = true;
      };
      if Equals(currentHack.ObjectActionTier, gamedataDeviceHackTier.Tier2DeviceHack) {
        if Equals(currentHack.ObjectActionType, gamedataObjectActionType.VehicleQuickHack) {
          currentName = GetLocalizedText(NameToString(currentHack.ObjectActionLocName)) + " (" + GetLocalizedText("LocKey#77971") + ")";
        };
        if Equals(currentHack.ObjectActionName, n"TakeControlClassHack") || Equals(currentHack.ObjectActionName, n"TurretToggleStateClassHack") || Equals(currentHack.ObjectActionName, n"TurretOverloadClassHack") {
          currentName = GetLocalizedText(NameToString(currentHack.ObjectActionLocName)) + " (" + GetLocalizedText("LocKey#38436") + ")";
        };
        hackNamesTier2 += showTier2 ? ", " + currentName : "" + currentName;
        showTier2 = true;
      };
      if Equals(currentHack.ObjectActionTier, gamedataDeviceHackTier.Tier1DeviceHack) {
        if Equals(currentHack.ObjectActionType, gamedataObjectActionType.VehicleQuickHack) {
          currentName = GetLocalizedText(NameToString(currentHack.ObjectActionLocName)) + " (" + GetLocalizedText("LocKey#77971") + ")";
        };
        if Equals(currentHack.ObjectActionName, n"TurretToggleStateClassHack") || Equals(currentHack.ObjectActionName, n"TurretOverloadClassHack") {
          currentName = GetLocalizedText(NameToString(currentHack.ObjectActionLocName)) + " (" + GetLocalizedText("LocKey#38436") + ")";
        };
        hackNamesTier1 += showTier1 ? ", " + currentName : "" + currentName;
        showTier1 = true;
      };
      i += 1;
    };
    inkWidgetRef.SetVisible(this.m_namesTextContainer, showTier1);
    inkWidgetRef.SetVisible(this.m_namesTextContainer2, showTier2);
    inkWidgetRef.SetVisible(this.m_namesTextContainer3, showTier3);
    inkWidgetRef.SetVisible(this.m_namesTextContainer4, showTier4);
    inkTextRef.SetText(this.m_deviceHackNamesText, hackNamesTier1);
    inkTextRef.SetText(this.m_deviceHackNamesText2, hackNamesTier2);
    inkTextRef.SetText(this.m_deviceHackNamesText3, hackNamesTier3);
    inkTextRef.SetText(this.m_deviceHackNamesText4, hackNamesTier45);
    if Equals(quality, gamedataQuality.Epic) || Equals(quality, gamedataQuality.Legendary) {
      inkWidgetRef.SetVisible(this.m_textBG, false);
      inkWidgetRef.SetVisible(this.m_textBG2, false);
      inkWidgetRef.SetVisible(this.m_textBG3, false);
      inkWidgetRef.SetVisible(this.m_textBG4, true);
    };
    if Equals(quality, gamedataQuality.Rare) {
      inkWidgetRef.SetVisible(this.m_textBG, false);
      inkWidgetRef.SetVisible(this.m_textBG2, false);
      inkWidgetRef.SetVisible(this.m_textBG3, true);
      inkWidgetRef.SetVisible(this.m_textBG4, false);
    };
    if Equals(quality, gamedataQuality.Uncommon) {
      inkWidgetRef.SetVisible(this.m_textBG, false);
      inkWidgetRef.SetVisible(this.m_textBG2, true);
      inkWidgetRef.SetVisible(this.m_textBG3, false);
      inkWidgetRef.SetVisible(this.m_textBG4, false);
    };
    if Equals(quality, gamedataQuality.Common) {
      inkWidgetRef.SetVisible(this.m_textBG, true);
      inkWidgetRef.SetVisible(this.m_textBG2, false);
      inkWidgetRef.SetVisible(this.m_textBG3, false);
      inkWidgetRef.SetVisible(this.m_textBG4, false);
    };
    inkTextRef.SetText(this.m_deviceHackHeader, GetLocalizedText(this.m_hasVehiclePerk ? "LocKey#53490" : "LocKey#95038"));
  }

  protected final func GetCyberdeckDeviceQuickhacks(itemRecord: wref<Item_Record>) -> [CyberdeckDeviceQuickhackData] {
    let data: CyberdeckDeviceQuickhackData;
    let deviceHacks: array<wref<ObjectAction_Record>>;
    let i: Int32;
    let objectActionType: ref<ObjectActionType_Record>;
    let objectActions: array<wref<ObjectAction_Record>>;
    let result: array<CyberdeckDeviceQuickhackData>;
    let uiAction: wref<InteractionBase_Record>;
    itemRecord.ObjectActions(objectActions);
    i = 0;
    while i < ArraySize(objectActions) {
      objectActionType = objectActions[i].ObjectActionType();
      if IsDefined(objectActionType) {
        if Equals(objectActionType.Type(), gamedataObjectActionType.DeviceQuickHack) || Equals(objectActionType.Type(), gamedataObjectActionType.VehicleQuickHack) {
          ArrayPush(deviceHacks, objectActions[i]);
        };
      };
      i += 1;
    };
    i = 0;
    while i < ArraySize(deviceHacks) {
      uiAction = deviceHacks[i].ObjectActionUI();
      data.UIIcon = uiAction.CaptionIcon().TexturePartID();
      data.ObjectActionRecord = deviceHacks[i];
      data.ObjectActionLocName = StringToName(LocKeyToString(uiAction.Caption()));
      data.ObjectActionName = deviceHacks[i].ActionName();
      data.ObjectActionTier = deviceHacks[i].HackTier().Type();
      data.ObjectActionCategory = deviceHacks[i].DeviceHackCategory().Type();
      data.ObjectActionType = deviceHacks[i].ObjectActionType().Type();
      data.Priority = deviceHacks[i].Priority();
      ArrayPush(result, data);
      i += 1;
    };
    return result;
  }

  protected final func UpdateName() -> Void {
    let quantity: Int32 = InventoryItemData.GetQuantity(this.m_data.inventoryItemData);
    let finalItemName: String = UIItemsHelper.GetTooltipItemName(this.m_data);
    if quantity > 1 {
      finalItemName += " [" + IntToString(quantity) + "]";
    };
    inkTextRef.SetText(this.m_itemNameText, finalItemName);
    inkTextRef.SetText(this.m_nameForRecipeText, finalItemName);
  }

  protected final func NEW_UpdateName() -> Void {
    let quantity: Int32 = this.m_itemData.GetQuantity();
    let finalItemName: String = this.m_itemData.GetName();
    if quantity > 1 {
      finalItemName += " [" + IntToString(quantity) + "]";
    };
    inkTextRef.SetText(this.m_itemNameText, finalItemName);
    inkTextRef.SetText(this.m_nameForRecipeText, finalItemName);
  }

  protected final func UpdateRarity() -> Void {
    let iconicLabel: String;
    let isIconic: Bool;
    let plusLabel: String;
    let quality: gamedataQuality;
    let rarityLabel: String;
    let minimalItemTooltipData: ref<MinimalItemTooltipData> = MinimalItemTooltipData.FromInventoryTooltipData(this.m_data);
    if this.m_data.overrideRarity {
      quality = UIItemsHelper.QualityNameToEnum(StringToName(this.m_data.quality));
    } else {
      quality = RPGManager.GetItemDataQuality(InventoryItemData.GetGameItemData(this.m_data.inventoryItemData));
    };
    iconicLabel = GetLocalizedText(UIItemsHelper.QualityToDefaultString(gamedataQuality.Iconic, RarityItemType.Cyberdeck));
    rarityLabel = GetLocalizedText(UIItemsHelper.QualityToTierString(quality));
    isIconic = RPGManager.IsItemIconic(InventoryItemData.GetGameItemData(this.m_data.inventoryItemData));
    plusLabel = rarityLabel;
    if minimalItemTooltipData.isPlus >= 2.00 {
      plusLabel += "++";
    } else {
      if minimalItemTooltipData.isPlus >= 1.00 {
        plusLabel += "+";
      };
    };
    if minimalItemTooltipData.isIconic {
      plusLabel += " / " + iconicLabel;
    };
    inkWidgetRef.SetState(this.m_itemNameText, UIItemsHelper.QualityEnumToName(quality));
    inkWidgetRef.SetState(this.m_itemRarityText, UIItemsHelper.QualityEnumToName(quality));
    inkTextRef.SetText(this.m_itemRarityText, plusLabel);
    this.m_rarityBarsController.Update(UIItemsHelper.QualityToInt(quality));
    inkWidgetRef.SetVisible(this.m_iconicLines, isIconic);
  }

  protected final func NEW_UpdateRarity() -> Void {
    let quality: gamedataQuality = this.m_itemData.GetQuality();
    inkWidgetRef.SetState(this.m_itemNameText, UIItemsHelper.QualityEnumToName(quality));
    inkWidgetRef.SetState(this.m_itemRarityText, UIItemsHelper.QualityEnumToName(quality));
    inkTextRef.SetText(this.m_itemRarityText, this.m_itemData.GetQualityText(RarityItemType.Cyberdeck));
    this.m_rarityBarsController.Update(UIItemsHelper.QualityToInt(quality));
    inkWidgetRef.SetVisible(this.m_iconicLines, this.m_itemData.IsIconic());
  }

  protected final func UpdateDescription(const description: script_ref<String>) -> Void {
    if NotEquals(this.m_data.description, "") {
      inkTextRef.SetText(this.m_descriptionText, this.m_data.description);
      inkWidgetRef.SetVisible(this.m_descriptionContainer, true);
    } else {
      inkWidgetRef.SetVisible(this.m_descriptionContainer, false);
    };
  }

  protected final func UpdateWeight(weight: Float) -> Void {
    inkTextRef.SetText(this.m_itemWeightText, FloatToStringPrec(weight, 2));
    if weight == 0.00 {
      inkWidgetRef.SetVisible(this.m_itemWeightWrapper, false);
    };
  }

  protected func UpdateIcon() -> Void {
    let emptyIcon: CName;
    let iconName: String;
    let iconsNameResolver: ref<IconsNameResolver> = IconsNameResolver.GetIconsNameResolver();
    if IsDefined(this.m_data) {
      if IsStringValid(InventoryItemData.GetIconPath(this.m_data.inventoryItemData)) {
        iconName = InventoryItemData.GetIconPath(this.m_data.inventoryItemData);
      } else {
        iconName = NameToString(iconsNameResolver.TranslateItemToIconName(ItemID.GetTDBID(InventoryItemData.GetID(this.m_data.inventoryItemData)), Equals(InventoryItemData.GetIconGender(this.m_data.inventoryItemData), ItemIconGender.Male)));
      };
      if NotEquals(iconName, "None") && NotEquals(iconName, "") {
        inkWidgetRef.SetScale(this.m_itemIconImage, Equals(InventoryItemData.GetEquipmentArea(this.m_data.inventoryItemData), gamedataEquipmentArea.Outfit) ? new Vector2(0.50, 0.50) : new Vector2(1.00, 1.00));
        InkImageUtils.RequestSetImage(this, this.m_itemIconImage, "UIIcon." + iconName, n"OnIconCallback");
      } else {
        emptyIcon = UIItemsHelper.GetSlotShadowIcon(TDBID.None(), InventoryItemData.GetItemType(this.m_data.inventoryItemData), InventoryItemData.GetEquipmentArea(this.m_data.inventoryItemData));
        InkImageUtils.RequestSetImage(this, this.m_itemIconImage, emptyIcon);
      };
    };
  }

  protected func NEW_UpdateIcon() -> Void {
    let emptyIcon: CName;
    let iconPath: String;
    if this.m_itemData != null {
      iconPath = this.m_itemData.GetIconPath();
      if IsStringValid(iconPath) {
        InkImageUtils.RequestSetImage(this, this.m_itemIconImage, iconPath, n"OnIconCallback");
      } else {
        emptyIcon = UIItemsHelper.GetSlotShadowIcon(TDBID.None(), this.m_itemData.GetItemType(), this.m_itemData.GetEquipmentArea());
        InkImageUtils.RequestSetImage(this, this.m_itemIconImage, emptyIcon);
      };
    };
  }

  protected final func UpdatePrice() -> Void {
    if this.m_data.isVendorItem {
      inkTextRef.SetText(this.m_priceText, FloatToStringPrec(this.m_data.buyPrice, 0));
    } else {
      inkTextRef.SetText(this.m_priceText, FloatToStringPrec(this.m_data.price, 0));
    };
    inkWidgetRef.SetVisible(this.m_priceContainer, true);
  }

  protected final func NEW_UpdatePrice() -> Void {
    if this.m_displayContext.IsVendorItem() {
      inkTextRef.SetText(this.m_priceText, FloatToStringPrec(this.m_itemData.GetBuyPrice(), 0));
    } else {
      inkTextRef.SetText(this.m_priceText, FloatToStringPrec(this.m_itemData.GetSellPrice(), 0));
    };
    inkWidgetRef.SetVisible(this.m_priceContainer, true);
  }

  protected final func UpdateRequirements() -> Void {
    let equipRequirements: array<SItemStackRequirementData>;
    let requirement: SItemStackRequirementData;
    let statRecord: ref<Stat_Record>;
    let textParams: ref<inkTextParams>;
    inkWidgetRef.SetVisible(this.m_itemAttributeRequirementsWrapper, false);
    inkWidgetRef.SetState(this.m_statsContainer, n"Default");
    inkWidgetRef.SetState(this.m_hacksContainer, n"Default");
    inkWidgetRef.SetState(this.m_descriptionContainer, n"Default");
    inkWidgetRef.SetState(this.m_allocationCostsWrapper, n"Default");
    if !InventoryItemData.IsEmpty(this.m_data.inventoryItemData) {
      requirement = InventoryItemData.GetRequirement(this.m_data.inventoryItemData);
      if NotEquals(requirement.statType, gamedataStatType.Invalid) && !InventoryItemData.IsRequirementMet(this.m_data.inventoryItemData) {
        inkWidgetRef.SetVisible(this.m_itemAttributeRequirementsWrapper, true);
        inkWidgetRef.SetVisible(this.m_itemAttributeRequirements, true);
        textParams = new inkTextParams();
        textParams.AddNumber("value", RoundF(requirement.requiredValue));
        statRecord = RPGManager.GetStatRecord(requirement.statType);
        textParams.AddString("statName", GetLocalizedText(UILocalizationHelper.GetStatNameLockey(statRecord)));
        textParams.AddString("statColor", "StatTypeColor." + EnumValueToString("gamedataStatType", Cast<Int64>(EnumInt(requirement.statType))));
        inkTextRef.SetLocalizedTextScript(this.m_itemAttributeRequirementsText, "LocKey#49215", textParams);
      };
      equipRequirements = InventoryItemData.GetEquipRequirements(this.m_data.inventoryItemData);
      if ArraySize(equipRequirements) > 0 {
        if !InventoryItemData.IsEquippable(this.m_data.inventoryItemData) {
          inkWidgetRef.SetVisible(this.m_itemAttributeRequirementsWrapper, true);
          inkWidgetRef.SetVisible(this.m_itemAttributeRequirements, true);
          textParams = new inkTextParams();
          textParams.AddNumber("value", RoundF(equipRequirements[0].requiredValue));
          statRecord = RPGManager.GetStatRecord(equipRequirements[0].statType);
          textParams.AddString("statName", GetLocalizedText(UILocalizationHelper.GetStatNameLockey(statRecord)));
          textParams.AddString("statColor", "StatTypeColor." + EnumValueToString("gamedataStatType", Cast<Int64>(EnumInt(equipRequirements[0].statType))));
          if MinimalItemTooltipData.IsAttributeAllocationStat(equipRequirements[0].statType) {
            inkTextRef.SetLocalizedTextScript(this.m_itemAttributeRequirementsText, "LocKey#80932", textParams);
          } else {
            inkTextRef.SetLocalizedTextScript(this.m_itemAttributeRequirementsText, "LocKey#77652", textParams);
          };
          if Equals(equipRequirements[0].statType, gamedataStatType.HumanityAvailable) {
            inkWidgetRef.SetState(this.m_allocationCostsWrapper, n"lowCapacity");
          };
        } else {
          if MinimalItemTooltipData.IsAttributeAllocationStat(equipRequirements[0].statType) {
            inkWidgetRef.SetVisible(this.m_itemAttributeRequirementsWrapper, true);
            inkWidgetRef.SetVisible(this.m_itemAttributeRequirements, false);
          };
        };
        inkWidgetRef.SetState(this.m_statsContainer, n"ReqNotMet");
        inkWidgetRef.SetState(this.m_hacksContainer, n"ReqNotMet");
        inkWidgetRef.SetState(this.m_descriptionContainer, n"ReqNotMet");
      };
    };
  }

  protected final func UpdateAllocationStats() -> Void {
    let minimalItemTooltipData: ref<MinimalItemTooltipData>;
    inkWidgetRef.SetVisible(this.m_allocationCostsWrapper, true);
    minimalItemTooltipData = MinimalItemTooltipData.FromInventoryTooltipData(this.m_data);
    this.UpdateAttributeAllocationStats(minimalItemTooltipData);
  }

  private final func UpdateAttributeAllocationStats(data: ref<MinimalItemTooltipData>) -> Void {
    let allocationCostsSize: Int32;
    let controller: ref<ItemTooltipStatController>;
    let i: Int32;
    inkWidgetRef.SetVisible(this.m_allocationCostsWrapper, true);
    allocationCostsSize = ArraySize(data.attributeAllocationStats);
    while inkCompoundRef.GetNumChildren(this.m_allocationCostsWrapper) > allocationCostsSize {
      inkCompoundRef.RemoveChildByIndex(this.m_allocationCostsWrapper, 0);
    };
    while inkCompoundRef.GetNumChildren(this.m_allocationCostsWrapper) < allocationCostsSize {
      this.SpawnFromLocal(inkWidgetRef.Get(this.m_allocationCostsWrapper), n"allocationCosts");
    };
    i = 0;
    while i < allocationCostsSize {
      controller = inkCompoundRef.GetWidgetByIndex(this.m_allocationCostsWrapper, i).GetController() as ItemTooltipStatController;
      controller.SetData(data.attributeAllocationStats[i]);
      i += 1;
    };
    if allocationCostsSize == 0 {
      this.SpawnFromLocal(inkWidgetRef.Get(this.m_allocationCostsWrapper), n"allocationCosts");
      controller = inkCompoundRef.GetWidgetByIndex(this.m_allocationCostsWrapper, i).GetController() as ItemTooltipStatController;
      controller.SetZeroData();
    };
  }

  private final func NEW_UpdateAttributeAllocationStats(data: wref<UIInventoryItem>, player: wref<PlayerPuppet>) -> Void {
    let allocationCostsSize: Int32;
    let controller: ref<ItemTooltipStatController>;
    let i: Int32;
    let statsManger: wref<UIInventoryItemStatsManager> = data.GetStatsManager();
    inkWidgetRef.SetVisible(this.m_allocationCostsWrapper, true);
    allocationCostsSize = statsManger.SizeAttributeAllocationStats();
    while inkCompoundRef.GetNumChildren(this.m_allocationCostsWrapper) > allocationCostsSize {
      inkCompoundRef.RemoveChildByIndex(this.m_allocationCostsWrapper, 0);
    };
    while inkCompoundRef.GetNumChildren(this.m_allocationCostsWrapper) < allocationCostsSize {
      this.SpawnFromLocal(inkWidgetRef.Get(this.m_allocationCostsWrapper), n"allocationCosts");
    };
    i = 0;
    while i < allocationCostsSize {
      controller = inkCompoundRef.GetWidgetByIndex(this.m_allocationCostsWrapper, i).GetController() as ItemTooltipStatController;
      controller.SetData(statsManger.GetAttributeAllocationStats(i));
      i += 1;
    };
    if allocationCostsSize == 0 {
      this.SpawnFromLocal(inkWidgetRef.Get(this.m_allocationCostsWrapper), n"allocationCosts");
      controller = inkCompoundRef.GetWidgetByIndex(this.m_allocationCostsWrapper, i).GetController() as ItemTooltipStatController;
      controller.SetZeroData();
    };
  }

  private final func UpdateCyberwareUpgradeModule() -> Void {
    let hasValidData: Bool;
    let isCyberware: Bool;
    if this.m_itemData != null {
      isCyberware = this.m_itemData.IsCyberware();
      hasValidData = !this.m_displayContext.HasTag(n"CyberwareUpgrade") && this.m_itemData.IsEquipped() && this.m_itemData.GetCyberwareUpgradeData(this.m_player).IsValid();
    } else {
      isCyberware = UIInventoryItemsManager.IsItemTypeCyberware(this.m_data.itemType);
      hasValidData = IsDefined(this.m_data.cyberwareUpgradeData) && this.m_data.cyberwareUpgradeData.IsValid();
    };
    if isCyberware && hasValidData {
      if !IsDefined(this.m_cyberwareUpgradeController) {
        this.AsyncSpawnFromExternal(inkWidgetRef.Get(this.m_cyberwareUpgradeContainer), this.m_additionalModulesLibraryRes, this.m_cyberwareUpgradeModuleName, this, n"OnCyberwareUpgradeModuleSpawned");
        return;
      };
      if this.m_itemData != null {
        this.m_cyberwareUpgradeController.NEW_Update(this.m_itemData, this.m_displayContext.GetPlayerAsPuppet());
      } else {
        this.m_cyberwareUpgradeController.Update(this.m_data);
      };
      inkWidgetRef.SetVisible(this.m_cyberwareUpgradeContainer, this.m_cyberwareUpgradeController.IsVisible());
    } else {
      inkWidgetRef.SetVisible(this.m_cyberwareUpgradeContainer, false);
    };
  }

  private final func UpdateCyberwareQuickHackMenuLinkModule() -> Void {
    inkWidgetRef.SetVisible(this.m_itemCWQuickHackMenuLinkContainer, this.m_data.cyberdeckData.viewingTooltipFromCyberwareMenu && this.m_data.isEquipped);
  }

  private final func NEW_UpdateCyberwareQuickHackMenuLinkModule() -> Void {
    inkWidgetRef.SetVisible(this.m_itemCWQuickHackMenuLinkContainer, this.m_displayContext.HasTag(n"AllowProgramLink") && this.m_itemData.IsEquipped());
  }

  protected cb func OnCyberwareUpgradeModuleSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
    this.m_cyberwareUpgradeController = widget.GetController() as ItemTooltipCyberwareUpgradeController;
    this.m_cyberwareUpgradeController.SetDisplayContext(this.m_itemDisplayContext, this.m_tooltipDisplayContext, this.m_displayContext);
    this.UpdateCyberwareUpgradeModule();
  }

  protected final func FixLines() -> Void {
    let container: wref<inkCompoundWidget>;
    let lineWidget: wref<inkWidget>;
    let firstHidden: Bool = false;
    let i: Int32 = 0;
    while i < inkCompoundRef.GetNumChildren(this.m_categoriesWrapper) {
      container = inkCompoundRef.GetWidgetByIndex(this.m_categoriesWrapper, i) as inkCompoundWidget;
      if IsDefined(container) {
        if container.IsVisible() {
          lineWidget = container.GetWidgetByPath(inkWidgetPath.Build(n"line"));
          if IsDefined(lineWidget) {
            lineWidget.SetVisible(firstHidden);
            firstHidden = true;
          };
        };
      };
      i += 1;
    };
  }

  public final func OnVarModified(groupPath: CName, varName: CName, varType: ConfigVarType, reason: ConfigChangeReason) -> Void {
    switch varName {
      case n"BigFont":
        this.UpdateTooltipSize();
        break;
      default:
    };
  }

  private final func UpdateTooltipSize() -> Void {
    let configVar: ref<ConfigVarBool> = this.m_settings.GetVar(this.m_groupPath, n"BigFont") as ConfigVarBool;
    this.SetTooltipSize(configVar.GetValue());
  }

  protected func SetTooltipSize(value: Bool) -> Void {
    if Equals(value, true) {
      inkWidgetRef.SetSize(this.m_minWidth, 800.00, 0.00);
      inkTextRef.SetWrappingAtPosition(this.m_itemNameText, 754.00);
      inkTextRef.SetWrappingAtPosition(this.m_itemRarityText, 754.00);
      inkTextRef.SetWrappingAtPosition(this.m_itemTypeText, 754.00);
      inkTextRef.SetWrappingAtPosition(this.m_itemAttributeRequirementsText, 700.00);
      inkTextRef.SetWrappingAtPosition(this.m_deviceHackNamesText, 710.00);
      inkTextRef.SetWrappingAtPosition(this.m_deviceHackNamesText2, 710.00);
      inkTextRef.SetWrappingAtPosition(this.m_deviceHackNamesText3, 710.00);
      inkTextRef.SetWrappingAtPosition(this.m_deviceHackNamesText4, 710.00);
      this.m_bigFontEnabled = true;
    } else {
      inkWidgetRef.SetSize(this.m_minWidth, 700.00, 0.00);
      inkTextRef.SetWrappingAtPosition(this.m_itemNameText, 654.00);
      inkTextRef.SetWrappingAtPosition(this.m_itemRarityText, 654.00);
      inkTextRef.SetWrappingAtPosition(this.m_itemTypeText, 654.00);
      inkTextRef.SetWrappingAtPosition(this.m_itemAttributeRequirementsText, 600.00);
      inkTextRef.SetWrappingAtPosition(this.m_deviceHackNamesText, 610.00);
      inkTextRef.SetWrappingAtPosition(this.m_deviceHackNamesText2, 610.00);
      inkTextRef.SetWrappingAtPosition(this.m_deviceHackNamesText3, 610.00);
      inkTextRef.SetWrappingAtPosition(this.m_deviceHackNamesText4, 610.00);
      this.m_bigFontEnabled = false;
    };
  }
}

public class CyberdeckTooltipSettingsListener extends ConfigVarListener {

  private let m_ctrl: wref<CyberdeckTooltip>;

  private let m_statctrl: wref<CyberdeckStatController>;

  public final func RegisterController(ctrl: ref<CyberdeckTooltip>) -> Void {
    this.m_ctrl = ctrl;
  }

  public final func RegisterStatController(ctrl: ref<CyberdeckStatController>) -> Void {
    this.m_statctrl = ctrl;
  }

  public func OnVarModified(groupPath: CName, varName: CName, varType: ConfigVarType, reason: ConfigChangeReason) -> Void {
    this.m_ctrl.OnVarModified(groupPath, varName, varType, reason);
    this.m_statctrl.OnVarModified(groupPath, varName, varType, reason);
  }
}

public class CyberdeckDeviceHackIcon extends inkLogicController {

  protected edit let m_image: inkImageRef;

  public final func Setup(data: CyberdeckDeviceQuickhackData) -> Void {
    inkImageRef.SetAtlasResource(this.m_image, data.UIIcon.AtlasResourcePath());
    inkImageRef.SetTexturePart(this.m_image, data.UIIcon.AtlasPartName());
  }
}

public class CyberdeckStatController extends inkLogicController {

  protected edit let m_label: inkTextRef;

  protected let m_settings: ref<UserSettings>;

  protected let m_settingsListener: ref<CyberdeckTooltipSettingsListener>;

  @default(CyberdeckStatController, /accessibility/interface)
  protected let m_groupPath: CName;

  protected edit let m_minWidth: inkWidgetRef;

  protected let m_bigFontEnabled: Bool;

  public final func Setup(const ability: script_ref<InventoryItemAbility>) -> Void {
    this.m_settings = new UserSettings();
    this.m_settingsListener = new CyberdeckTooltipSettingsListener();
    this.m_settingsListener.RegisterStatController(this);
    this.m_settingsListener.Register(this.m_groupPath);
    this.UpdateTooltipSize();
    if NotEquals(Deref(ability).Description, "") {
      inkTextRef.SetText(this.m_label, Deref(ability).Description);
      if Deref(ability).LocalizationDataPackage.GetParamsCount() > 0 {
        inkTextRef.SetTextParameters(this.m_label, Deref(ability).LocalizationDataPackage.GetTextParams());
      };
    } else {
      inkTextRef.SetText(this.m_label, GetLocalizedText("UI-Labels-EmptySlot"));
    };
  }

  public final func OnVarModified(groupPath: CName, varName: CName, varType: ConfigVarType, reason: ConfigChangeReason) -> Void {
    switch varName {
      case n"BigFont":
        this.UpdateTooltipSize();
        break;
      default:
    };
  }

  private final func UpdateTooltipSize() -> Void {
    let configVar: ref<ConfigVarBool> = this.m_settings.GetVar(this.m_groupPath, n"BigFont") as ConfigVarBool;
    this.SetTooltipSize(configVar.GetValue());
  }

  protected func SetTooltipSize(value: Bool) -> Void {
    if Equals(value, true) {
      inkTextRef.SetWrappingAtPosition(this.m_label, 700.00);
      this.m_bigFontEnabled = true;
    } else {
      inkTextRef.SetWrappingAtPosition(this.m_label, 600.00);
      this.m_bigFontEnabled = false;
    };
  }
}
