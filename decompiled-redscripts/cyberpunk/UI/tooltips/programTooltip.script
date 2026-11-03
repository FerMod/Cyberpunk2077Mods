
public class ProgramTooltipController extends AGenericTooltipControllerWithDebug {

  protected edit let m_backgroundContainer: inkCompoundRef;

  protected edit let m_equipedWrapper: inkWidgetRef;

  protected edit let m_equipedCorner: inkWidgetRef;

  protected edit let m_recipeWrapper: inkWidgetRef;

  protected edit let m_recipeBG: inkWidgetRef;

  protected edit let m_root: inkWidgetRef;

  private edit let m_nameText: inkTextRef;

  private edit let m_nameTextContainer: inkWidgetRef;

  private edit let m_nameForRecipeText: inkTextRef;

  private edit let m_tierText: inkTextRef;

  private edit let m_durationWidget: inkWidgetRef;

  private edit let m_uploadTimeWidget: inkWidgetRef;

  private edit let m_cooldownWidget: inkWidgetRef;

  private edit let m_memoryCostValueText: inkTextRef;

  private edit let m_damageWrapper: inkWidgetRef;

  private edit let m_damageLabel: inkTextRef;

  private edit let m_damageValue: inkTextRef;

  private edit let m_damageContinuous: inkTextRef;

  private edit let m_healthPercentageLabel: inkTextRef;

  private edit let m_priceContainer: inkWidgetRef;

  private edit let m_priceText: inkTextRef;

  private edit let m_descriptionWrapper: inkWidgetRef;

  private edit let m_descriptionText: inkTextRef;

  private edit let m_hackTypeWrapper: inkWidgetRef;

  private edit let m_hackTypeText: inkTextRef;

  private edit let m_perkContainer: inkWidgetRef;

  private edit let m_perkText: inkTextRef;

  private edit let m_qualityContainer: inkWidgetRef;

  private edit let m_qualityText: inkTextRef;

  private edit let m_effectsList: inkCompoundRef;

  private edit let m_headerSegment: inkWidgetRef;

  private edit let m_typeSegment: inkWidgetRef;

  private edit let DEBUG_iconErrorWrapper: inkWidgetRef;

  private edit let DEBUG_iconErrorText: inkTextRef;

  private let m_data: ref<InventoryTooltipData>;

  private let m_quickHackData: InventoryTooltipData_QuickhackData;

  private let m_itemData: wref<UIInventoryItem>;

  private let m_displayContext: InventoryTooltipDisplayContext;

  private let m_itemDisplayContext: ItemDisplayContext;

  private edit let m_isCrafting: Bool;

  public func SetData(tooltipData: ref<ATooltipData>) -> Void {
    let wrappedData: ref<UIInventoryItemTooltipWrapper>;
    if IsDefined(tooltipData as UIInventoryItemTooltipWrapper) {
      wrappedData = tooltipData as UIInventoryItemTooltipWrapper;
      this.m_itemData = wrappedData.m_data;
      this.m_itemDisplayContext = wrappedData.m_displayContext.GetDisplayContext();
      this.m_isCrafting = Equals(this.m_displayContext, InventoryTooltipDisplayContext.Crafting) || Equals(this.m_displayContext, InventoryTooltipDisplayContext.Upgrading);
      this.NewRefreshUI(this.m_itemData, wrappedData.m_displayContext.GetPlayerAsPuppet());
      return;
    };
    this.m_data = tooltipData as InventoryTooltipData;
    this.m_isCrafting = Equals(this.m_data.displayContext, InventoryTooltipDisplayContext.Crafting) || Equals(this.m_data.displayContext, InventoryTooltipDisplayContext.Upgrading);
    this.m_quickHackData = this.m_data.quickhackData;
    this.RefreshUI();
  }

  private final func NewRefreshUI(itemData: wref<UIInventoryItem>, player: wref<PlayerPuppet>) -> Void {
    let programData: wref<UIInventoryItemProgramData> = itemData.GetProgramData(player, true);
    if itemData.IsRecipe() && NotEquals(this.m_displayContext, InventoryTooltipDisplayContext.Crafting) {
      inkTextRef.SetText(this.m_nameForRecipeText, itemData.GetName());
      inkWidgetRef.SetVisible(this.m_nameText, false);
      inkWidgetRef.SetVisible(this.m_nameTextContainer, false);
      inkWidgetRef.SetVisible(this.m_nameForRecipeText, true);
    } else {
      inkTextRef.SetText(this.m_nameText, itemData.GetName());
      inkWidgetRef.SetVisible(this.m_nameForRecipeText, false);
      inkWidgetRef.SetVisible(this.m_nameTextContainer, true);
      inkWidgetRef.SetVisible(this.m_nameText, true);
    };
    inkWidgetRef.Get(this.m_headerSegment).SetVisible(NotEquals(this.m_displayContext, InventoryTooltipDisplayContext.Crafting));
    inkWidgetRef.Get(this.m_typeSegment).SetVisible(NotEquals(this.m_displayContext, InventoryTooltipDisplayContext.Crafting));
    inkTextRef.SetText(this.m_memoryCostValueText, IntToString(programData.BaseCost));
    this.UpdateDetail(itemData, programData.Duration);
    this.UpdateUploadDetail(this.m_uploadTimeWidget, "UI-Quickhacks-DetailsUploadTime", programData.UploadTime, 0.00);
    this.NewUpdateDamage(programData);
    this.NewUpdateMods();
    this.NewUpdatePrice(player);
    this.NewUpdateCategory();
    this.NewUpdateRarity(programData);
    inkWidgetRef.SetVisible(this.m_equipedWrapper, itemData.IsEquipped());
    inkWidgetRef.SetVisible(this.m_equipedCorner, itemData.IsEquipped());
    inkWidgetRef.SetVisible(this.m_recipeWrapper, itemData.IsRecipe() && NotEquals(this.m_displayContext, InventoryTooltipDisplayContext.Crafting));
    inkWidgetRef.SetVisible(this.m_recipeBG, itemData.IsRecipe() && NotEquals(this.m_displayContext, InventoryTooltipDisplayContext.Crafting));
    if Equals(this.m_data.isEquipped, true) {
      inkWidgetRef.SetState(this.m_root, n"Equipped");
    } else {
      inkWidgetRef.SetState(this.m_root, n"Default");
    };
    this.UpdateRequirements();
  }

  private func UpdateDetail(shwoProgramDuration: Bool, targetWidget: inkWidgetRef, const key: script_ref<String>, value: Float, diff: Float) -> Void {
    let controller: ref<ProgramTooltipStatController> = inkWidgetRef.GetController(targetWidget) as ProgramTooltipStatController;
    if value != 0.00 {
      controller.SetData(GetLocalizedText(key), value, diff);
      inkWidgetRef.Get(targetWidget).SetVisible(shwoProgramDuration);
    } else {
      inkWidgetRef.Get(targetWidget).SetVisible(false);
    };
  }

  private func UpdateDetail(item: wref<UIInventoryItem>, value: Float) -> Void {
    let controller: ref<ProgramTooltipStatController>;
    if value != 0.00 {
      controller = inkWidgetRef.GetController(this.m_durationWidget) as ProgramTooltipStatController;
      controller.SetData(GetLocalizedText("UI-Quickhacks-DetailsDuration"), value, 0.00);
      inkWidgetRef.SetVisible(this.m_durationWidget, !item.GetItemData().HasTag(n"HideProgramDuration"));
    } else {
      inkWidgetRef.SetVisible(this.m_durationWidget, false);
    };
  }

  private func UpdateUploadDetail(targetWidget: inkWidgetRef, const key: script_ref<String>, value: Float, diff: Float) -> Void {
    let controller: ref<ProgramTooltipStatController> = inkWidgetRef.GetController(targetWidget) as ProgramTooltipStatController;
    if value != 0.00 {
      controller.SetData(GetLocalizedText(key), value, diff);
      inkWidgetRef.Get(targetWidget).SetVisible(true);
    } else {
      inkWidgetRef.Get(targetWidget).SetVisible(false);
    };
  }

  private func NewUpdateDescription() -> Void {
    let description: String = this.m_itemData.GetDescription();
    if IsStringValid(description) {
      inkTextRef.SetText(this.m_descriptionText, description);
      inkWidgetRef.SetVisible(this.m_descriptionWrapper, true);
    } else {
      inkWidgetRef.SetVisible(this.m_descriptionWrapper, false);
    };
  }

  private func UpdateDescription() -> Void {
    let description: String = this.m_data.description;
    if IsStringValid(description) {
      inkTextRef.SetText(this.m_descriptionText, description);
      inkWidgetRef.SetVisible(this.m_descriptionWrapper, true);
    } else {
      inkWidgetRef.SetVisible(this.m_descriptionWrapper, false);
    };
  }

  private func NewGetHackCategory() -> wref<HackCategory_Record> {
    let actionRecord: wref<ObjectAction_Record>;
    let actions: array<wref<ObjectAction_Record>>;
    let hackCategory: wref<HackCategory_Record>;
    let i: Int32;
    let limit: Int32;
    this.m_itemData.GetItemRecord().ObjectActions(actions);
    i = 0;
    limit = ArraySize(actions);
    while i < limit {
      actionRecord = TweakDBInterface.GetObjectActionRecord(actions[i].GetID());
      hackCategory = actionRecord.HackCategory();
      if IsDefined(hackCategory) && NotEquals(hackCategory.Type(), gamedataHackCategory.NotAHack) {
        return hackCategory;
      };
      i += 1;
    };
    return null;
  }

  private func NewUpdateCategory() -> Void {
    let hackCategory: wref<HackCategory_Record> = this.NewGetHackCategory();
    if IsDefined(hackCategory) && NotEquals(hackCategory.Type(), gamedataHackCategory.NotAHack) {
      inkTextRef.SetText(this.m_hackTypeText, hackCategory.LocalizedDescription());
      inkWidgetRef.SetVisible(this.m_hackTypeWrapper, true);
    } else {
      inkWidgetRef.SetVisible(this.m_hackTypeWrapper, false);
    };
  }

  private func GetHackCategory() -> wref<HackCategory_Record> {
    let actionRecord: wref<ObjectAction_Record>;
    let actions: array<wref<ObjectAction_Record>>;
    let hackCategory: wref<HackCategory_Record>;
    let i: Int32;
    let tweakRecord: wref<Item_Record> = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(InventoryItemData.GetID(this.m_data.inventoryItemData)));
    tweakRecord.ObjectActions(actions);
    i = 0;
    while i < ArraySize(actions) {
      actionRecord = TweakDBInterface.GetObjectActionRecord(actions[i].GetID());
      hackCategory = actionRecord.HackCategory();
      if IsDefined(hackCategory) && NotEquals(hackCategory.Type(), gamedataHackCategory.NotAHack) {
        return hackCategory;
      };
      i += 1;
    };
    return null;
  }

  private func UpdateCategory() -> Void {
    let locKey: String;
    let localizedDescription: String;
    let hackCategory: wref<HackCategory_Record> = this.GetHackCategory();
    if IsDefined(hackCategory) && NotEquals(hackCategory.Type(), gamedataHackCategory.NotAHack) {
      locKey = hackCategory.LocalizedDescription();
      localizedDescription = GetLocalizedText(locKey);
      inkTextRef.SetText(this.m_hackTypeText, localizedDescription);
      inkWidgetRef.SetVisible(this.m_hackTypeWrapper, true);
    } else {
      inkWidgetRef.SetVisible(this.m_hackTypeWrapper, false);
    };
  }

  private final func NewUpdateRarity(programData: wref<UIInventoryItemProgramData>) -> Void {
    let qualityName: CName = UIItemsHelper.QualityEnumToName(this.m_itemData.GetQuality());
    inkWidgetRef.SetState(this.m_tierText, qualityName);
    inkWidgetRef.SetState(this.m_nameText, qualityName);
    inkTextRef.SetText(this.m_tierText, this.m_itemData.GetQualityText(RarityItemType.Program));
  }

  private final func UpdateRarity() -> Void {
    let isIconic: Bool;
    let quality: gamedataQuality;
    let rarityLabel: String;
    let state: CName;
    let tierKey: String;
    let iconicLabel: String = GetLocalizedText(UIItemsHelper.QualityToDefaultString(gamedataQuality.Iconic));
    let inventoryItemData: InventoryItemData = this.m_data.inventoryItemData;
    let gameData: ref<gameItemData> = InventoryItemData.GetGameItemData(inventoryItemData);
    if this.m_data.overrideRarity {
      quality = UIItemsHelper.QualityNameToEnum(StringToName(this.m_data.quality));
    } else {
      quality = RPGManager.GetItemDataQuality(gameData);
    };
    if Equals(quality, gamedataQuality.Invalid) {
      quality = inventoryItemData.ComparedQuality;
    };
    isIconic = inventoryItemData.IsIconic;
    tierKey = UIItemsHelper.QualityToTierString(quality);
    state = UIItemsHelper.QualityEnumToName(quality);
    inkWidgetRef.SetState(this.m_tierText, state);
    inkWidgetRef.SetState(this.m_nameText, state);
    inkWidgetRef.SetState(this.m_hackTypeText, state);
    rarityLabel = GetLocalizedText(tierKey);
    if isIconic {
      rarityLabel += " / " + iconicLabel;
    };
    (inkWidgetRef.Get(this.m_tierText) as inkText).SetText(rarityLabel);
  }

  private func RefreshUI() -> Void {
    let itemRecord: wref<Item_Record>;
    let quickHackData: InventoryTooltipData_QuickhackData = this.m_data.quickhackData;
    let itemID: TweakDBID = ItemID.GetTDBID(this.m_data.itemID);
    inkTextRef.SetText(this.m_nameText, this.m_data.itemName);
    inkWidgetRef.Get(this.m_headerSegment).SetVisible(NotEquals(this.m_data.displayContext, InventoryTooltipDisplayContext.Crafting));
    inkWidgetRef.Get(this.m_typeSegment).SetVisible(NotEquals(this.m_data.displayContext, InventoryTooltipDisplayContext.Crafting));
    inkTextRef.SetText(this.m_memoryCostValueText, IntToString(this.m_data.quickhackData.baseCost));
    itemRecord = TweakDBInterface.GetItemRecord(itemID);
    this.UpdateDetail(!itemRecord.TagsContains(n"HideProgramDuration"), this.m_durationWidget, "UI-Quickhacks-DetailsDuration", quickHackData.duration, quickHackData.durationDiff);
    this.UpdateUploadDetail(this.m_uploadTimeWidget, "UI-Quickhacks-DetailsUploadTime", quickHackData.uploadTime, quickHackData.uploadTimeDiff);
    this.UpdateDamage();
    this.UpdateMods();
    this.UpdatePrice();
    this.UpdateCategory();
    this.UpdateRarity();
    this.UpdateRequirements();
    this.DEBUG_UpdateDebugInfo();
    inkWidgetRef.SetVisible(this.m_equipedWrapper, this.m_data.isEquipped);
    inkWidgetRef.SetVisible(this.m_equipedCorner, this.m_data.isEquipped);
    if this.m_data.parentItemData.HasTag(n"Recipe") && NotEquals(this.m_displayContext, InventoryTooltipDisplayContext.Crafting) {
      inkTextRef.SetText(this.m_nameForRecipeText, this.m_data.itemName);
      inkWidgetRef.SetVisible(this.m_nameText, false);
      inkWidgetRef.SetVisible(this.m_nameTextContainer, false);
      inkWidgetRef.SetVisible(this.m_nameForRecipeText, true);
    } else {
      inkTextRef.SetText(this.m_nameText, this.m_data.itemName);
      inkWidgetRef.SetVisible(this.m_nameForRecipeText, false);
      inkWidgetRef.SetVisible(this.m_nameTextContainer, true);
      inkWidgetRef.SetVisible(this.m_nameText, true);
    };
    inkWidgetRef.SetVisible(this.m_recipeWrapper, this.m_data.parentItemData.HasTag(n"Recipe") && NotEquals(this.m_displayContext, InventoryTooltipDisplayContext.Crafting));
    inkWidgetRef.SetVisible(this.m_recipeBG, this.m_data.parentItemData.HasTag(n"Recipe") && NotEquals(this.m_displayContext, InventoryTooltipDisplayContext.Crafting));
    if Equals(this.m_data.isEquipped, true) {
      inkWidgetRef.SetState(this.m_root, n"Equipped");
    } else {
      inkWidgetRef.SetState(this.m_root, n"Default");
    };
    inkWidgetRef.SetVisible(this.m_backgroundContainer, NotEquals(this.m_data.displayContext, InventoryTooltipDisplayContext.Crafting));
  }

  protected func DEBUG_UpdateDebugInfo() -> Void {
    let errorData: ref<DEBUG_IconErrorInfo>;
    let itemRecordID: TweakDBID;
    let resultText: String;
    let iconsNameResolver: ref<IconsNameResolver> = IconsNameResolver.GetIconsNameResolver();
    if !iconsNameResolver.IsInDebugMode() {
      inkWidgetRef.SetVisible(this.DEBUG_iconErrorWrapper, false);
      return;
    };
    errorData = this.m_data.DEBUG_iconErrorInfo;
    inkWidgetRef.SetVisible(this.DEBUG_iconErrorWrapper, errorData != null || this.DEBUG_showDebug);
    if this.DEBUG_showDebug {
      itemRecordID = ItemID.GetTDBID(InventoryItemData.GetID(this.m_data.inventoryItemData));
      resultText += " - itemID:\\n";
      resultText += TDBID.ToStringDEBUG(itemRecordID);
      inkTextRef.SetText(this.DEBUG_iconErrorText, resultText);
      this.OpenTweakDBRecordInVSCodeIfRequested(itemRecordID);
    } else {
      if errorData != null {
        resultText += "   ErrorType: " + EnumValueToString("inkIconResult", Cast<Int64>(EnumInt(errorData.errorType))) + "\\n\\n";
        resultText += " - itemID:\\n";
        resultText += errorData.itemName;
        if errorData.isManuallySet {
          resultText += "\\n - resolved icon name (manually set):\\n";
        } else {
          resultText += "\\n - resolved icon name (auto generated):\\n";
        };
        resultText += errorData.resolvedIconName;
        resultText += "\\n - error message:\\n";
        resultText += errorData.errorMessage;
        inkTextRef.SetText(this.DEBUG_iconErrorText, resultText);
      };
    };
  }

  private final func IsDamageStat(targetStat: gamedataStatType, valueStat: gamedataStatType) -> Bool {
    if Equals(targetStat, gamedataStatType.Invalid) {
      switch valueStat {
        case gamedataStatType.ThermalDamage:
        case gamedataStatType.ElectricDamage:
        case gamedataStatType.ChemicalDamage:
        case gamedataStatType.PhysicalDamage:
        case gamedataStatType.BaseDamage:
          return true;
        default:
          return false;
      };
    } else {
      return Equals(targetStat, gamedataStatType.Health);
    };
    return false;
  }

  private final func NewUpdateDamage(programData: wref<UIInventoryItemProgramData>) -> Void {
    let effect: ref<DamageEffectUIEntry>;
    let i: Int32;
    let isHealthPercentageStat: Bool;
    let limit: Int32;
    let statKey: String;
    let statRecord: ref<Stat_Record>;
    let statType: gamedataStatType;
    let valueToDisplay: String;
    inkWidgetRef.SetVisible(this.m_damageWrapper, false);
    inkWidgetRef.SetVisible(this.m_damageContinuous, false);
    i = 0;
    limit = ArraySize(programData.AttackEffects);
    while i < limit {
      effect = programData.AttackEffects[i];
      if !this.IsDamageStat(effect.targetStat, effect.valueStat) {
      } else {
        isHealthPercentageStat = Equals(effect.targetStat, gamedataStatType.Health);
        inkWidgetRef.SetVisible(this.m_healthPercentageLabel, isHealthPercentageStat);
        if isHealthPercentageStat {
          valueToDisplay = "-";
        };
        valueToDisplay += IntToString(CeilF(effect.valueToDisplay));
        if isHealthPercentageStat {
          valueToDisplay += "%";
        };
        inkWidgetRef.SetVisible(this.m_damageContinuous, effect.isContinuous);
        if effect.isContinuous {
          inkTextRef.SetText(this.m_damageContinuous, "/" + GetLocalizedText("UI-Quickhacks-Seconds"));
        };
        inkTextRef.SetText(this.m_damageValue, valueToDisplay);
        statType = effect.valueStat;
        statRecord = RPGManager.GetStatRecord(statType);
        statKey = UILocalizationHelper.GetStatNameLockey(statRecord);
        inkTextRef.SetText(this.m_damageLabel, statKey);
        inkWidgetRef.SetVisible(this.m_damageWrapper, true);
        break;
      };
      i += 1;
    };
  }

  private final func UpdateDamage() -> Void {
    let damageType: gamedataDamageType;
    let damageTypeLocKey: String;
    let damageTypeRecord: ref<Stat_Record>;
    let effect: ref<DamageEffectUIEntry>;
    let i: Int32;
    let isHealthPercentageStat: Bool;
    let valueToDisplay: String;
    let attackEffectsSize: Int32 = ArraySize(this.m_data.quickhackData.attackEffects);
    inkWidgetRef.SetVisible(this.m_damageWrapper, false);
    inkWidgetRef.SetVisible(this.m_damageValue, false);
    inkWidgetRef.SetVisible(this.m_damageContinuous, false);
    i = 0;
    while i < attackEffectsSize {
      effect = this.m_data.quickhackData.attackEffects[i];
      if !this.IsDamageStat(effect.targetStat, effect.valueStat) {
      } else {
        isHealthPercentageStat = Equals(effect.targetStat, gamedataStatType.Health);
        inkWidgetRef.SetVisible(this.m_healthPercentageLabel, isHealthPercentageStat);
        if isHealthPercentageStat {
          valueToDisplay = "-";
        };
        valueToDisplay += IntToString(CeilF(effect.valueToDisplay));
        if isHealthPercentageStat {
          valueToDisplay += "%";
        };
        if effect.isContinuous {
          inkTextRef.SetText(this.m_damageContinuous, "/" + GetLocalizedText("UI-Quickhacks-Seconds"));
          inkWidgetRef.SetVisible(this.m_damageContinuous, true);
          inkWidgetRef.SetVisible(this.m_damageWrapper, true);
        };
        damageType = effect.damageType;
        if effect.valueToDisplay > 0.00 {
          inkTextRef.SetText(this.m_damageValue, valueToDisplay);
          inkWidgetRef.SetVisible(this.m_damageValue, true);
          inkWidgetRef.SetVisible(this.m_damageWrapper, true);
        };
        if NotEquals(damageType, gamedataDamageType.Invalid) {
          damageTypeRecord = RPGManager.GetStatRecord(UIItemsHelper.GetStatTypeByDamageType(damageType));
          damageTypeLocKey = UILocalizationHelper.GetStatNameLockey(damageTypeRecord);
          inkTextRef.SetText(this.m_damageLabel, damageTypeLocKey);
          inkWidgetRef.SetVisible(this.m_damageLabel, true);
        } else {
          inkWidgetRef.SetVisible(this.m_damageLabel, false);
        };
        break;
      };
      i += 1;
    };
  }

  private final func NewUpdateMods() -> Void {
    let controller: ref<ItemTooltipModController>;
    let i: Int32;
    let modsManager: wref<UIInventoryItemModsManager> = this.m_itemData.GetModsManager();
    let limit: Int32 = modsManager.GetModsSize();
    if limit > 0 {
      while inkCompoundRef.GetNumChildren(this.m_effectsList) > 0 {
        inkCompoundRef.RemoveChildByIndex(this.m_effectsList, 0);
      };
      while inkCompoundRef.GetNumChildren(this.m_effectsList) < limit {
        this.SpawnFromLocal(inkWidgetRef.Get(this.m_effectsList), n"programTooltipEffect");
      };
      i = 0;
      while i < limit {
        controller = inkCompoundRef.GetWidgetByIndex(this.m_effectsList, i).GetController() as ItemTooltipModController;
        controller.GetContext(this.m_isCrafting);
        controller.SetData(modsManager.GetMod(i));
        i += 1;
      };
    };
  }

  private final func UpdateMods() -> Void {
    let attachment: ref<InventoryItemAttachments>;
    let controller: ref<ItemTooltipModController>;
    let i: Int32;
    if ArraySize(this.m_data.itemAttachments) > 0 {
      while inkCompoundRef.GetNumChildren(this.m_effectsList) > 0 {
        inkCompoundRef.RemoveChildByIndex(this.m_effectsList, 0);
      };
      while inkCompoundRef.GetNumChildren(this.m_effectsList) < ArraySize(this.m_data.itemAttachments) {
        this.SpawnFromLocal(inkWidgetRef.Get(this.m_effectsList), n"programTooltipEffect");
      };
      i = 0;
      while i < ArraySize(this.m_data.itemAttachments) {
        attachment = this.m_data.itemAttachments[i];
        controller = inkCompoundRef.GetWidgetByIndex(this.m_effectsList, i).GetController() as ItemTooltipModController;
        controller.GetContext(this.m_isCrafting);
        controller.SetData(attachment);
        i += 1;
      };
    } else {
      if ArraySize(this.m_data.itemAttachments) == 0 && ArraySize(this.m_data.specialAbilities) > 0 {
        while inkCompoundRef.GetNumChildren(this.m_effectsList) > 0 {
          inkCompoundRef.RemoveChildByIndex(this.m_effectsList, 0);
        };
        while inkCompoundRef.GetNumChildren(this.m_effectsList) < ArraySize(this.m_data.specialAbilities) {
          this.SpawnFromLocal(inkWidgetRef.Get(this.m_effectsList), n"programTooltipEffect");
        };
        i = 0;
        while i < ArraySize(this.m_data.specialAbilities) {
          controller = inkCompoundRef.GetWidgetByIndex(this.m_effectsList, i).GetController() as ItemTooltipModController;
          controller.GetContext(this.m_isCrafting);
          controller.SetData(this.m_data.specialAbilities[i]);
          i += 1;
        };
      };
    };
  }

  private final func NewUpdatePrice(player: wref<PlayerPuppet>) -> Void {
    if Equals(this.m_itemDisplayContext, ItemDisplayContext.Vendor) {
      inkTextRef.SetText(this.m_priceText, IntToString(RoundF(this.m_itemData.GetBuyPrice()) * this.m_itemData.GetQuantity()));
    } else {
      inkTextRef.SetText(this.m_priceText, IntToString(RoundF(this.m_itemData.GetSellPrice()) * this.m_itemData.GetQuantity()));
    };
    inkWidgetRef.SetVisible(this.m_priceContainer, NotEquals(this.m_data.displayContext, InventoryTooltipDisplayContext.Crafting));
  }

  private final func UpdatePrice() -> Void {
    if this.m_data.isVendorItem {
      inkTextRef.SetText(this.m_priceText, FloatToStringPrec(this.m_data.buyPrice, 0));
    } else {
      inkTextRef.SetText(this.m_priceText, FloatToStringPrec(this.m_data.price, 0));
    };
    inkWidgetRef.SetVisible(this.m_priceContainer, NotEquals(this.m_data.displayContext, InventoryTooltipDisplayContext.Crafting));
  }

  private final func UpdatePerkRequirement() -> Void {
    let textParams: ref<inkTextParams>;
    inkWidgetRef.SetVisible(this.m_perkContainer, false);
    if this.m_data.isPerkRequired {
      textParams = new inkTextParams();
      textParams.AddLocalizedString("perkName", this.m_data.perkRequiredName);
      inkWidgetRef.SetVisible(this.m_perkContainer, true);
      inkTextRef.SetLocalizedTextScript(this.m_perkText, "LocKey#42796", textParams);
    };
  }

  private final func UpdateRequirements() -> Void {
    let itemData: InventoryItemData = this.m_data.inventoryItemData;
    let islocked: Bool = !InventoryItemData.IsRequirementMet(itemData);
    inkWidgetRef.SetVisible(this.m_qualityContainer, islocked);
    if islocked {
      inkTextRef.SetLocalizedText(this.m_qualityText, n"UI-Tooltips-ModQualityRestriction");
    };
  }
}

public class ProgramTooltipEffectController extends ItemTooltipModController {

  private func EntryWidgetToSpawn() -> CName {
    return n"programTooltipEffectEntry";
  }
}

public class ProgramTooltipStatController extends inkLogicController {

  private edit let m_arrow: inkImageRef;

  private edit let m_value: inkTextRef;

  private edit let m_name: inkTextRef;

  private edit let m_diffValue: inkTextRef;

  public final func SetData(const localizedKey: script_ref<String>, value: Float, diff: Float) -> Void {
    if AbsF(value) > 0.01 {
      this.GetRootWidget().SetState(n"Default");
      if value > 0.01 {
        inkTextRef.SetText(this.m_name, localizedKey + " ");
        inkTextRef.SetText(this.m_value, FloatToStringPrec(value, 1) + GetLocalizedText("UI-Quickhacks-Seconds"));
      } else {
        inkTextRef.SetText(this.m_name, localizedKey + " ");
        inkTextRef.SetText(this.m_value, GetLocalizedText("UI-Quickhacks-Infinite"));
      };
    } else {
      this.GetRootWidget().SetState(n"Empty");
      inkTextRef.SetText(this.m_value, localizedKey + " " + GetLocalizedText("UI-Quickhacks-NotApplicable"));
      inkWidgetRef.SetVisible(this.m_name, false);
    };
    this.UpdateComparedValue(diff);
  }

  private final func UpdateComparedValue(diffValue: Float) -> Void {
    let comaredStatText: String;
    let isVisible: Bool = diffValue != 0.00;
    let statToSet: CName = diffValue > 0.00 ? n"Better" : n"Worse";
    comaredStatText += diffValue > 0.00 ? "+" : "-";
    comaredStatText += FloatToStringPrec(AbsF(diffValue), 2);
    inkTextRef.SetText(this.m_diffValue, comaredStatText);
    inkWidgetRef.SetVisible(this.m_arrow, isVisible);
    inkWidgetRef.SetVisible(this.m_diffValue, isVisible);
    inkWidgetRef.SetState(this.m_arrow, statToSet);
    inkWidgetRef.SetState(this.m_diffValue, statToSet);
    inkImageRef.SetBrushMirrorType(this.m_arrow, diffValue > 0.00 ? inkBrushMirrorType.NoMirror : inkBrushMirrorType.Vertical);
  }
}
