
public class UIInventoryItemStatsManager extends IScriptable {

  public let Stats: [ref<UIInventoryItemStat>];

  public let TooltipStats: [ref<UIInventoryItemStat>];

  public let AdditionalStats: [ref<UIInventoryItemStat>];

  public let AttributeAllocationStats: [ref<UIInventoryItemStat>];

  private let m_item: wref<UIInventoryItem>;

  private let m_gameItemData: wref<gameItemData>;

  private let m_itemType: gamedataItemType;

  private let m_manager: wref<UIInventoryItemsManager>;

  private let m_statMap: wref<UIStatsMap_Record>;

  private let m_statsFetched: Bool;

  private let m_tooltipStatsFetched: Bool;

  private let m_weaponBars: ref<UIInventoryItemWeaponBars>;

  private let m_weaponBarsFetched: Bool;

  private let m_useBareStats: Bool;

  public final func SetTooltipsStats(tooltipStats: script_ref<[ref<UIInventoryItemStat>]>) -> Void {
    this.TooltipStats = Deref(tooltipStats);
  }

  public final static func Make(item: wref<UIInventoryItem>, statMap: wref<UIStatsMap_Record>, opt manager: wref<UIInventoryItemsManager>) -> ref<UIInventoryItemStatsManager> {
    let instance: ref<UIInventoryItemStatsManager> = new UIInventoryItemStatsManager();
    instance.m_manager = manager;
    instance.m_item = item;
    instance.m_itemType = item.GetItemType();
    instance.m_gameItemData = item.GetItemData();
    instance.m_statMap = statMap;
    return instance;
  }

  public final static func Make(itemData: wref<gameItemData>, statMap: wref<UIStatsMap_Record>, opt manager: wref<UIInventoryItemsManager>) -> ref<UIInventoryItemStatsManager> {
    let instance: ref<UIInventoryItemStatsManager> = new UIInventoryItemStatsManager();
    instance.m_manager = manager;
    instance.m_gameItemData = itemData;
    instance.m_itemType = itemData.GetItemType();
    instance.m_statMap = statMap;
    return instance;
  }

  private final func FetchSecondayStats() -> Void {
    let i: Int32;
    let isClothing: Bool;
    let isGrenade: Bool;
    let limit: Int32;
    let secondaryStats: array<wref<Stat_Record>>;
    let stat: ref<UIInventoryItemStat>;
    let statType: gamedataStatType;
    if this.m_statsFetched {
      return;
    };
    this.m_statMap.SecondaryStats(secondaryStats);
    isClothing = UIInventoryItemsManager.IsItemTypeCloting(this.m_item.GetItemType());
    isGrenade = UIInventoryItemsManager.IsItemTypeGrenade(this.m_item.GetItemType());
    i = 0;
    limit = ArraySize(secondaryStats);
    while i < limit {
      statType = secondaryStats[i].StatType();
      if isGrenade || isClothing && Equals(statType, gamedataStatType.Armor) {
      } else {
        stat = this.InternalFetchStatByType(statType, secondaryStats[i].GetID(), true);
        if stat != null {
          if UIItemsHelper.IsAttributeAllocationStat(statType) {
            ArrayPush(this.AttributeAllocationStats, stat);
          } else {
            ArrayPush(this.Stats, stat);
          };
        };
      };
      i += 1;
    };
    this.m_statsFetched = true;
  }

  private final func FetchTooltipStats() -> Void {
    let i: Int32;
    let limit: Int32;
    let stat: ref<UIInventoryItemStat>;
    let tooltipStats: array<wref<Stat_Record>>;
    if this.m_tooltipStatsFetched {
      return;
    };
    this.m_statMap.TooltipStats(tooltipStats);
    i = 0;
    limit = ArraySize(tooltipStats);
    while i < limit {
      stat = this.InternalFetchStatByType(tooltipStats[i].StatType(), tooltipStats[i].GetID(), true);
      if stat != null {
        ArrayPush(this.TooltipStats, stat);
      };
      i += 1;
    };
    this.m_tooltipStatsFetched = true;
  }

  private final func FetchAdditionalStatByType(statType: gamedataStatType) -> wref<UIInventoryItemStat> {
    let statId: TweakDBID = TDBID.Create("BaseStats." + EnumValueToString("gamedataStatType", Cast<Int64>(EnumInt(statType))));
    let stat: ref<UIInventoryItemStat> = this.InternalFetchStatByType(statType, statId, false);
    ArrayPush(this.AdditionalStats, stat);
    return stat;
  }

  private final func InternalFetchStatByType(statType: gamedataStatType, statId: TweakDBID, skipEmpty: Bool) -> ref<UIInventoryItemStat> {
    let absValue: Float;
    let itemStat: ref<UIInventoryItemStat>;
    let roundValue: Bool;
    let value: Float;
    let gameItemDataStrong: ref<gameItemData> = this.m_gameItemData;
    if IsDefined(gameItemDataStrong) {
      if this.m_useBareStats {
        value = gameItemDataStrong.GetBareStatValueByType(statType);
      } else {
        value = gameItemDataStrong.GetStatValueByType(statType);
      };
    };
    roundValue = TweakDBInterface.GetBool(statId + t".roundValue", false);
    absValue = AbsF(value);
    if skipEmpty {
      if roundValue ? RoundF(absValue) <= 0 : absValue <= 0.00 {
        return null;
      };
    };
    itemStat = new UIInventoryItemStat();
    itemStat.Type = statType;
    itemStat.Value = value;
    itemStat.PropertiesProvider = DefaultUIInventoryItemStatsProvider.Make(itemStat.Type, this.m_manager);
    return itemStat;
  }

  public final static func FromMinimalItemTooltipData(data: ref<MinimalItemTooltipData>, opt manager: wref<UIInventoryItemsManager>) -> ref<UIInventoryItemStatsManager> {
    let itemStat: ref<UIInventoryItemStat>;
    let instance: ref<UIInventoryItemStatsManager> = new UIInventoryItemStatsManager();
    instance.m_manager = manager;
    let i: Int32 = 0;
    let limit: Int32 = ArraySize(data.stats);
    while i < limit {
      itemStat = new UIInventoryItemStat();
      itemStat.Type = data.stats[i].type;
      itemStat.Value = data.stats[i].value;
      itemStat.SetProperties(UIItemStatProperties.Make(data.stats[i].statName, data.stats[i].decimalPlaces, data.stats[i].displayPercent, data.stats[i].displayPlus, data.stats[i].inMeters, data.stats[i].inSeconds, data.stats[i].inSpeed, data.stats[i].multiplyBy100InText, data.stats[i].roundValue, manager != null ? manager.GetWeaponStatMaxValue(itemStat.Type) : -1.00, data.stats[i].flipNegative));
      ArrayPush(instance.Stats, itemStat);
      i += 1;
    };
    return instance;
  }

  public final static func FromMinimalItemTooltipDataToTooltipStats(data: ref<MinimalItemTooltipData>, opt manager: wref<UIInventoryItemsManager>) -> ref<UIInventoryItemStatsManager> {
    let itemStat: ref<UIInventoryItemStat>;
    let instance: ref<UIInventoryItemStatsManager> = new UIInventoryItemStatsManager();
    instance.m_manager = manager;
    let i: Int32 = 0;
    let limit: Int32 = ArraySize(data.stats);
    while i < limit {
      itemStat = new UIInventoryItemStat();
      itemStat.Type = data.stats[i].type;
      itemStat.Value = data.stats[i].value;
      itemStat.SetProperties(UIItemStatProperties.Make(data.stats[i].statName, data.stats[i].decimalPlaces, data.stats[i].displayPercent, data.stats[i].displayPlus, data.stats[i].inMeters, data.stats[i].inSeconds, data.stats[i].inSpeed, data.stats[i].multiplyBy100InText, data.stats[i].roundValue, manager != null ? manager.GetWeaponStatMaxValue(itemStat.Type) : -1.00, data.stats[i].flipNegative));
      ArrayPush(instance.TooltipStats, itemStat);
      i += 1;
    };
    return instance;
  }

  public final func Size() -> Int32 {
    this.FetchSecondayStats();
    return ArraySize(this.Stats);
  }

  public final func SizeTooltipStats() -> Int32 {
    this.FetchTooltipStats();
    return ArraySize(this.TooltipStats);
  }

  public final func SizeAttributeAllocationStats() -> Int32 {
    this.FetchSecondayStats();
    return ArraySize(this.AttributeAllocationStats);
  }

  public final func Get(index: Int32) -> wref<UIInventoryItemStat> {
    this.FetchSecondayStats();
    return this.Stats[index];
  }

  public final func GetTooltipStat(index: Int32) -> wref<UIInventoryItemStat> {
    this.FetchTooltipStats();
    return this.TooltipStats[index];
  }

  public final func GetAttributeAllocationStats(index: Int32) -> wref<UIInventoryItemStat> {
    this.FetchSecondayStats();
    return this.AttributeAllocationStats[index];
  }

  public final func GetByType(type: gamedataStatType) -> wref<UIInventoryItemStat> {
    let i: Int32;
    let limit: Int32;
    this.FetchSecondayStats();
    i = 0;
    limit = ArraySize(this.Stats);
    while i < limit {
      if Equals(this.Stats[i].Type, type) {
        return this.Stats[i];
      };
      i += 1;
    };
    return null;
  }

  public final func GetTooltipStatByType(type: gamedataStatType) -> wref<UIInventoryItemStat> {
    let i: Int32;
    let limit: Int32;
    this.FetchTooltipStats();
    i = 0;
    limit = ArraySize(this.TooltipStats);
    while i < limit {
      if Equals(this.TooltipStats[i].Type, type) {
        return this.TooltipStats[i];
      };
      i += 1;
    };
    return null;
  }

  public final func GetAdditionalStatByType(type: gamedataStatType) -> wref<UIInventoryItemStat> {
    let i: Int32 = 0;
    let limit: Int32 = ArraySize(this.AdditionalStats);
    while i < limit {
      if Equals(this.AdditionalStats[i].Type, type) {
        return this.AdditionalStats[i];
      };
      i += 1;
    };
    return this.FetchAdditionalStatByType(type);
  }

  public final func GetAttributeAllocationStatByType(type: gamedataStatType) -> wref<UIInventoryItemStat> {
    let i: Int32;
    let limit: Int32;
    this.FetchSecondayStats();
    i = 0;
    limit = ArraySize(this.AttributeAllocationStats);
    while i < limit {
      if Equals(this.AttributeAllocationStats[i].Type, type) {
        return this.AttributeAllocationStats[i];
      };
      i += 1;
    };
    return null;
  }

  private final func GetWeaponBarsType(itemType: gamedataItemType, item: wref<UIInventoryItem>) -> UIInventoryItemWeaponBarsType {
    if Equals(itemType, gamedataItemType.Con_Injector) {
      return UIInventoryItemWeaponBarsType.InjectorHealing;
    };
    if Equals(itemType, gamedataItemType.Con_Inhaler) {
      return UIInventoryItemWeaponBarsType.InhalerHealing;
    };
    if Equals(itemType, gamedataItemType.Cyb_Launcher) {
      return UIInventoryItemWeaponBarsType.CyberwareRangedWeapon;
    };
    if RPGManager.IsItemTypeCyberwareWeapon(itemType) {
      return UIInventoryItemWeaponBarsType.CyberwareWeapon;
    };
    if Equals(item.GetWeaponType(), WeaponType.Melee) {
      if Equals(item.GetWeaponEvolution(), gamedataWeaponEvolution.Throwable) {
        return UIInventoryItemWeaponBarsType.Throwable;
      };
      return UIInventoryItemWeaponBarsType.Melee;
    };
    return UIInventoryItemWeaponBarsType.Ranged;
  }

  private final func GetWeaponBarsType(itemType: gamedataItemType, itemData: ref<gameItemData>) -> UIInventoryItemWeaponBarsType {
    let weaponRecord: wref<WeaponItem_Record>;
    let itemID: ItemID = itemData.GetID();
    let itemTweakID: TweakDBID = ItemID.GetTDBID(itemID);
    if Equals(itemType, gamedataItemType.Con_Injector) {
      return UIInventoryItemWeaponBarsType.InjectorHealing;
    };
    if Equals(itemType, gamedataItemType.Con_Inhaler) {
      return UIInventoryItemWeaponBarsType.InhalerHealing;
    };
    if Equals(itemType, gamedataItemType.Cyb_Launcher) {
      return UIInventoryItemWeaponBarsType.CyberwareRangedWeapon;
    };
    if RPGManager.IsItemTypeCyberwareWeapon(itemType) {
      return UIInventoryItemWeaponBarsType.CyberwareWeapon;
    };
    if UIInventoryItemsManager.IsItemTypeMeleeWeapon(this.m_gameItemData.GetItemType()) {
      weaponRecord = TweakDBInterface.GetItemRecord(itemTweakID) as WeaponItem_Record;
      if IsDefined(weaponRecord) && Equals(weaponRecord.Evolution().Type(), gamedataWeaponEvolution.Throwable) {
        return UIInventoryItemWeaponBarsType.Throwable;
      };
      return UIInventoryItemWeaponBarsType.Melee;
    };
    return UIInventoryItemWeaponBarsType.Ranged;
  }

  private final func IsItemTypeUsingBars(itemData: ref<UIInventoryItem>) -> Bool {
    return itemData.IsWeapon() || itemData.IsUsingBars();
  }

  public final func GetWeaponBars(opt force: Bool) -> wref<UIInventoryItemWeaponBars> {
    let itemData: ref<gameItemData>;
    let itemType: gamedataItemType;
    let weaponType: UIInventoryItemWeaponBarsType;
    let itemStrong: ref<UIInventoryItem> = this.m_item;
    let gameItemDataStrong: ref<gameItemData> = this.m_gameItemData;
    if IsDefined(itemStrong) {
      if !this.IsItemTypeUsingBars(itemStrong) {
        return null;
      };
    };
    if this.m_weaponBarsFetched && !force {
      return this.m_weaponBars;
    };
    if IsDefined(itemStrong) {
      itemType = itemStrong.GetItemType();
      weaponType = this.GetWeaponBarsType(itemType, itemStrong);
      itemData = itemStrong.GetItemData();
    } else {
      itemType = gameItemDataStrong.GetItemType();
      weaponType = this.GetWeaponBarsType(itemType, gameItemDataStrong);
      itemData = gameItemDataStrong;
    };
    this.m_useBareStats = true;
    this.m_weaponBars = UIInventoryItemWeaponBars.Make(this, itemData, itemType, weaponType);
    this.m_weaponBarsFetched = true;
    return this.m_weaponBars;
  }

  public final func FlushComparedBars() -> Void {
    if this.m_weaponBarsFetched {
      this.m_weaponBars.SetComparedBars(null);
    };
  }

  public final func GetGameItemData() -> wref<gameItemData> {
    return this.m_gameItemData;
  }

  public final func GetAttachedPlayer() -> wref<PlayerPuppet> {
    return this.m_manager.GetAttachedPlayer();
  }

  public final func IsCurveBarsEnabled() -> Bool {
    if this.m_manager != null {
      return this.m_manager.GetCurveBarsEnabled();
    };
    return true;
  }

  public final func IsSeparatorBarsEnabled() -> Bool {
    if this.m_manager != null {
      return this.m_manager.GetSeparatorBarsEnabled();
    };
    return true;
  }

  private final static func MapBarTypeToStat(type: WeaponBarType) -> gamedataStatType {
    switch type {
      case WeaponBarType.AttackSpeed:
        return gamedataStatType.AttacksPerSecond;
      case WeaponBarType.DamagePerHit:
        return gamedataStatType.EffectiveDamagePerHit;
      case WeaponBarType.ReloadSpeed:
        return gamedataStatType.ReloadTime;
      case WeaponBarType.Range:
        return gamedataStatType.EffectiveRange;
      case WeaponBarType.Handling:
        return gamedataStatType.Handling;
      case WeaponBarType.Stamina:
        return gamedataStatType.Stamina;
      case WeaponBarType.MeleeAttackSpeed:
        return gamedataStatType.AttacksPerSecond;
      case WeaponBarType.MeleeDamagePerHit:
        return gamedataStatType.EffectiveDamagePerHit;
      case WeaponBarType.MeleeStamina:
        return gamedataStatType.Stamina;
      case WeaponBarType.ThrowableEffectiveRange:
        return gamedataStatType.EffectiveRange;
      case WeaponBarType.ThrowableReturnTime:
        return gamedataStatType.ThrowRecovery;
      case WeaponBarType.CyberwareAttackSpeed:
        return gamedataStatType.AttacksPerSecond;
      case WeaponBarType.CyberwareDamagePerHit:
        return gamedataStatType.EffectiveDamagePerHit;
      case WeaponBarType.Healing:
        return gamedataStatType.InhalerBaseHealing;
      case WeaponBarType.HealingOverTime:
        return gamedataStatType.InjectorBaseHealing;
    };
    return gamedataStatType.Invalid;
  }

  private final static func IsBarTypeMelee(type: WeaponBarType) -> Bool {
    return Equals(type, WeaponBarType.MeleeAttackSpeed) || Equals(type, WeaponBarType.MeleeDamagePerHit) || Equals(type, WeaponBarType.MeleeStamina) || Equals(type, WeaponBarType.ThrowableEffectiveRange) || Equals(type, WeaponBarType.ThrowableReturnTime);
  }

  private final static func IsUsingCurveCustom(itemType: gamedataItemType, type: WeaponBarType) -> Bool {
    if Equals(type, WeaponBarType.DamagePerHit) {
      if Equals(itemType, gamedataItemType.Wea_Shotgun) || Equals(itemType, gamedataItemType.Wea_ShotgunDual) || Equals(itemType, gamedataItemType.Wea_SniperRifle) {
        return true;
      };
    };
    if Equals(type, WeaponBarType.CyberwareDamagePerHit) {
      if Equals(itemType, gamedataItemType.Cyb_Launcher) {
        return true;
      };
    };
    return false;
  }

  private final func GetPercentageCurveName(type: WeaponBarType) -> CName {
    let prefix: String;
    let statType: gamedataStatType = UIInventoryItemStatsManager.MapBarTypeToStat(type);
    if UIInventoryItemStatsManager.IsBarTypeMelee(type) {
      prefix = "melee_";
    };
    if UIInventoryItemStatsManager.IsUsingCurveCustom(this.m_itemType, type) {
      return StringToName(prefix + EnumValueToString("gamedataStatType", EnumInt(statType)) + "_" + EnumValueToString("gamedataItemType", EnumInt(this.m_itemType)));
    };
    return StringToName(prefix + EnumValueToString("gamedataStatType", EnumInt(statType)) + "_default");
  }

  public final func GetPercentageFromCurve(type: WeaponBarType, value: Float) -> Float {
    if IsDefined(this.m_manager) {
      return this.m_manager.GetStatsSystemValueFromCurve(n"tooltip_weapon_bars", this.GetPercentageCurveName(type), value);
    };
    return -1.00;
  }
}

public class UIItemStatProperties extends IScriptable {

  private let localizedName: String;

  private let decimalPlaces: Int32;

  private let displayPercent: Bool;

  private let displayPlus: Bool;

  private let inMeters: Bool;

  private let inSeconds: Bool;

  private let inSpeed: Bool;

  private let multiplyBy100InText: Bool;

  private let roundValue: Bool;

  private let maxValue: Float;

  private let flipNegative: Bool;

  public final static func Make(const localizedName: script_ref<String>, decimalPlaces: Int32, displayPercent: Bool, displayPlus: Bool, inMeters: Bool, inSeconds: Bool, inSpeed: Bool, multiplyBy100InText: Bool, roundValue: Bool, maxValue: Float, flipNegative: Bool) -> ref<UIItemStatProperties> {
    let instance: ref<UIItemStatProperties> = new UIItemStatProperties();
    instance.localizedName = Deref(localizedName);
    instance.decimalPlaces = decimalPlaces;
    instance.displayPercent = displayPercent;
    instance.displayPlus = displayPlus;
    instance.inMeters = inMeters;
    instance.inSeconds = inSeconds;
    instance.inSpeed = inSpeed;
    instance.multiplyBy100InText = multiplyBy100InText;
    instance.roundValue = roundValue;
    instance.maxValue = maxValue;
    instance.flipNegative = flipNegative;
    return instance;
  }

  public final func GetName() -> String {
    return this.localizedName;
  }

  public final func DecimalPlaces() -> Int32 {
    return this.decimalPlaces;
  }

  public final func DisplayPercent() -> Bool {
    return this.displayPercent;
  }

  public final func DisplayPlus() -> Bool {
    return this.displayPlus;
  }

  public final func InMeters() -> Bool {
    return this.inMeters;
  }

  public final func InSeconds() -> Bool {
    return this.inSeconds;
  }

  public final func InSpeed() -> Bool {
    return this.inSpeed;
  }

  public final func MultiplyBy100InText() -> Bool {
    return this.multiplyBy100InText;
  }

  public final func RoundValue() -> Bool {
    return this.roundValue;
  }

  public final func MaxValue() -> Float {
    return this.maxValue;
  }

  public final func FlipNegative() -> Bool {
    return this.flipNegative;
  }
}

public class UIInventoryItemWeaponBar extends IScriptable {

  public let Value: Float;

  public let MaxValue: Float;

  public let Percentage: Float;

  public let Type: WeaponBarType;

  private let m_isValueSet: Bool;

  public final static func Make(itemType: gamedataItemType, type: WeaponBarType, value: Float, maxValue: Float, opt withoutValue: Bool) -> ref<UIInventoryItemWeaponBar> {
    let instance: ref<UIInventoryItemWeaponBar> = new UIInventoryItemWeaponBar();
    if withoutValue {
      value = 0.00;
    };
    instance.Value = value;
    instance.MaxValue = maxValue;
    instance.Type = type;
    instance.m_isValueSet = !withoutValue;
    if UIInventoryItemWeaponBars.IsBarReversed(type) {
      value = maxValue - value;
    };
    instance.Percentage = (value * UIInventoryItemWeaponBars.GetItemTypeMultiplier(itemType)) / maxValue;
    return instance;
  }

  public final static func MakeCurve(type: WeaponBarType, value: Float, statsManager: ref<UIInventoryItemStatsManager>, opt withoutValue: Bool) -> ref<UIInventoryItemWeaponBar> {
    let instance: ref<UIInventoryItemWeaponBar> = new UIInventoryItemWeaponBar();
    if withoutValue {
      value = 0.00;
    };
    instance.Value = value;
    instance.Type = type;
    instance.m_isValueSet = !withoutValue;
    instance.Percentage = statsManager.GetPercentageFromCurve(type, value);
    return instance;
  }

  public final func IsValueSet() -> Bool {
    return this.m_isValueSet;
  }

  public final static func GetBarTypeGroup(barType: WeaponBarType) -> WeaponBarTypeGroup {
    switch barType {
      case WeaponBarType.AttackSpeed:
        return WeaponBarTypeGroup.AttackSpeed;
      case WeaponBarType.MeleeAttackSpeed:
        return WeaponBarTypeGroup.AttackSpeed;
      case WeaponBarType.DamagePerHit:
        return WeaponBarTypeGroup.DamagePerHit;
      case WeaponBarType.MeleeDamagePerHit:
        return WeaponBarTypeGroup.DamagePerHit;
      case WeaponBarType.Range:
        return WeaponBarTypeGroup.Range;
      case WeaponBarType.ThrowableEffectiveRange:
        return WeaponBarTypeGroup.Range;
      case WeaponBarType.Stamina:
        return WeaponBarTypeGroup.Stamina;
      case WeaponBarType.MeleeStamina:
        return WeaponBarTypeGroup.Stamina;
      case WeaponBarType.ReloadSpeed:
        return WeaponBarTypeGroup.ReloadSpeed;
      case WeaponBarType.ThrowableReturnTime:
        return WeaponBarTypeGroup.ReturnTime;
      case WeaponBarType.Handling:
        return WeaponBarTypeGroup.Handling;
      case WeaponBarType.Healing:
        return WeaponBarTypeGroup.Healing;
      case WeaponBarType.HealingOverTime:
        return WeaponBarTypeGroup.HealingOverTime;
    };
    return WeaponBarTypeGroup.Invalid;
  }

  public final func GetBarTypeGroup() -> WeaponBarTypeGroup {
    return UIInventoryItemWeaponBar.GetBarTypeGroup(this.Type);
  }
}

public class UIInventoryItemWeaponBars extends IScriptable {

  public let Values: [ref<UIInventoryItemWeaponBar>];

  private let m_type: UIInventoryItemWeaponBarsType;

  private let m_itemType: gamedataItemType;

  private let m_comparedBars: ref<UIInventoryItemWeaponBars>;

  public final static func Make(statsManager: ref<UIInventoryItemStatsManager>, itemData: ref<gameItemData>, itemType: gamedataItemType, type: UIInventoryItemWeaponBarsType) -> ref<UIInventoryItemWeaponBars> {
    if Equals(type, UIInventoryItemWeaponBarsType.InjectorHealing) || Equals(type, UIInventoryItemWeaponBarsType.InhalerHealing) {
      return UIInventoryItemWeaponBars.MakeHealing(statsManager, itemData, itemType);
    };
    if Equals(type, UIInventoryItemWeaponBarsType.CyberwareRangedWeapon) {
      return UIInventoryItemWeaponBars.MakeCyberwareRangedWeapon(statsManager, itemType);
    };
    if NotEquals(type, UIInventoryItemWeaponBarsType.Ranged) {
      return UIInventoryItemWeaponBars.MakeMelee(statsManager, itemType, type);
    };
    return UIInventoryItemWeaponBars.MakeRanged(statsManager, itemType);
  }

  public final static func MakeHealing(statsManager: ref<UIInventoryItemStatsManager>, itemData: ref<gameItemData>, itemType: gamedataItemType) -> ref<UIInventoryItemWeaponBars> {
    let instance: ref<UIInventoryItemWeaponBars> = new UIInventoryItemWeaponBars();
    instance.m_type = Equals(itemType, gamedataItemType.Con_Injector) ? UIInventoryItemWeaponBarsType.InjectorHealing : UIInventoryItemWeaponBarsType.InhalerHealing;
    instance.m_itemType = itemType;
    ArrayPush(instance.Values, UIInventoryItemWeaponBar.MakeCurve(WeaponBarType.Healing, UIInventoryItemWeaponBars.GetInstantHealing(itemData), statsManager));
    ArrayPush(instance.Values, UIInventoryItemWeaponBar.MakeCurve(WeaponBarType.HealingOverTime, UIInventoryItemWeaponBars.GetCumulativeHealing(itemData), statsManager));
    return instance;
  }

  private final static func GetInstantHealing(itemData: ref<gameItemData>) -> Float {
    let constantStatModifier: wref<ConstantStatModifier_Record>;
    let dataPackages: array<wref<GameplayLogicPackage_Record>>;
    let i: Int32;
    let iLimit: Int32;
    let j: Int32;
    let jLimit: Int32;
    let stats: array<wref<StatModifier_Record>>;
    let itemRecord: wref<Item_Record> = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(itemData.GetID()));
    itemRecord.OnEquip(dataPackages);
    i = 0;
    iLimit = ArraySize(dataPackages);
    while i < iLimit {
      ArrayClear(stats);
      dataPackages[i].Stats(stats);
      j = 0;
      jLimit = ArraySize(stats);
      while j < jLimit {
        if Equals(stats[j].StatType().StatType(), gamedataStatType.InhalerBaseHealing) || Equals(stats[j].StatType().StatType(), gamedataStatType.InjectorBaseHealing) {
          constantStatModifier = stats[j] as ConstantStatModifier_Record;
          if constantStatModifier != null {
            return constantStatModifier.Value();
          };
        };
        j += 1;
      };
      i += 1;
    };
    return 0.00;
  }

  private final static func GetInjectorDuration() -> Float {
    let stat: wref<ConstantStatModifier_Record>;
    let injectorDurationStat: wref<StatModifierGroup_Record> = TweakDBInterface.GetStatModifierGroupRecord(t"Items.BonesMcCoy70Duration");
    if injectorDurationStat != null {
      stat = injectorDurationStat.GetStatModifiersItem(0) as ConstantStatModifier_Record;
      if stat != null {
        return stat.Value();
      };
    };
    return 0.00;
  }

  private final static func GetCumulativeHealing(itemData: ref<gameItemData>) -> Float {
    let constantStatModifier: wref<ConstantStatModifier_Record>;
    let dataPackages: array<wref<GameplayLogicPackage_Record>>;
    let i: Int32;
    let iLimit: Int32;
    let instantValue: Float;
    let j: Int32;
    let jLimit: Int32;
    let overTimeValue: Float;
    let statType: gamedataStatType;
    let stats: array<wref<StatModifier_Record>>;
    let itemRecord: wref<Item_Record> = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(itemData.GetID()));
    let injectorDuration: Float = UIInventoryItemWeaponBars.GetInjectorDuration();
    itemRecord.OnEquip(dataPackages);
    i = 0;
    iLimit = ArraySize(dataPackages);
    while i < iLimit {
      ArrayClear(stats);
      dataPackages[i].Stats(stats);
      j = 0;
      jLimit = ArraySize(stats);
      while j < jLimit {
        statType = stats[j].StatType().StatType();
        if Equals(statType, gamedataStatType.InjectorBaseOverTheTimeHealing) {
          constantStatModifier = stats[j] as ConstantStatModifier_Record;
          if constantStatModifier != null {
            overTimeValue += constantStatModifier.Value() * injectorDuration;
          };
        };
        j += 1;
      };
      i += 1;
    };
    return instantValue + overTimeValue;
  }

  private final static func GetProjectileLauncherDamage(itemData: wref<gameItemData>, player: wref<PlayerPuppet>) -> Float {
    let attackRecord: wref<Attack_Record>;
    let attackString: String;
    let curveModifier: wref<CurveStatModifier_Record>;
    let i: Int32;
    let installedProjectile: InnerItemData;
    let limit: Int32;
    let qualityMultiplier: Float;
    let resultDamage: Float;
    let statModifiers: array<wref<StatModifier_Record>>;
    itemData.GetItemPart(installedProjectile, t"AttachmentSlots.ProjectileLauncherRound");
    attackString = TweakDBInterface.GetString(ItemID.GetTDBID(InnerItemData.GetItemID(installedProjectile)) + t".attack", "");
    attackRecord = TweakDBInterface.GetAttackRecord(TDBID.Create(attackString));
    attackRecord.StatModifiers(statModifiers);
    i = 0;
    limit = ArraySize(statModifiers);
    while i < limit {
      if !RPGManager.IsDamageStat(statModifiers[i].StatType().StatType()) {
      } else {
        if IsDefined(statModifiers[i] as ConstantStatModifier_Record) {
          resultDamage += (statModifiers[i] as ConstantStatModifier_Record).Value();
        };
        curveModifier = statModifiers[i] as CurveStatModifier_Record;
        if IsDefined(curveModifier) {
          if Equals(curveModifier.Column(), "quality_to_dps_multiplier_new") {
            qualityMultiplier = itemData.GetStatValueByType(gamedataStatType.ProjectileLauncherQualityMult);
            resultDamage *= GameInstance.GetStatsDataSystem(player.GetGame()).GetValueFromCurve(StringToName(curveModifier.Id()), qualityMultiplier, StringToName(curveModifier.Column()));
          };
        };
      };
      i += 1;
    };
    return resultDamage;
  }

  public final static func MakeCyberwareRangedWeapon(statsManager: ref<UIInventoryItemStatsManager>, itemType: gamedataItemType) -> ref<UIInventoryItemWeaponBars> {
    let attacksPerSecondStat: ref<UIInventoryItemStat>;
    let cycleTimeBaseStat: ref<UIInventoryItemStat>;
    let effectiveDamagePerHitStat: ref<UIInventoryItemStat>;
    let statCurveEnabled: Bool = statsManager.IsCurveBarsEnabled();
    let instance: ref<UIInventoryItemWeaponBars> = new UIInventoryItemWeaponBars();
    instance.m_type = UIInventoryItemWeaponBarsType.CyberwareRangedWeapon;
    instance.m_itemType = itemType;
    if statCurveEnabled {
      cycleTimeBaseStat = statsManager.GetAdditionalStatByType(gamedataStatType.CycleTimeBase);
      ArrayPush(instance.Values, UIInventoryItemWeaponBar.MakeCurve(WeaponBarType.CyberwareAttackSpeed, 1.00 / (cycleTimeBaseStat.Value / 5.00), statsManager));
      effectiveDamagePerHitStat = statsManager.GetAdditionalStatByType(gamedataStatType.EffectiveDamagePerHit);
      ArrayPush(instance.Values, UIInventoryItemWeaponBar.MakeCurve(WeaponBarType.CyberwareDamagePerHit, UIInventoryItemWeaponBars.GetProjectileLauncherDamage(statsManager.GetGameItemData(), statsManager.GetAttachedPlayer()), statsManager));
      return instance;
    };
    attacksPerSecondStat = statsManager.GetAdditionalStatByType(gamedataStatType.AttacksPerSecond);
    cycleTimeBaseStat = statsManager.GetAdditionalStatByType(gamedataStatType.CycleTimeBase);
    ArrayPush(instance.Values, UIInventoryItemWeaponBar.Make(itemType, WeaponBarType.AttackSpeed, 1.00 / (cycleTimeBaseStat.Value / 5.00), attacksPerSecondStat.GetProperties().MaxValue()));
    effectiveDamagePerHitStat = statsManager.GetAdditionalStatByType(gamedataStatType.EffectiveDamagePerHit);
    ArrayPush(instance.Values, UIInventoryItemWeaponBar.Make(itemType, WeaponBarType.DamagePerHit, UIInventoryItemWeaponBars.GetProjectileLauncherDamage(statsManager.GetGameItemData(), statsManager.GetAttachedPlayer()), effectiveDamagePerHitStat.GetProperties().MaxValue()));
    return instance;
  }

  public final static func MakeRanged(statsManager: ref<UIInventoryItemStatsManager>, itemType: gamedataItemType) -> ref<UIInventoryItemWeaponBars> {
    let attacksPerSecondStat: ref<UIInventoryItemStat>;
    let cycleTimeStat: ref<UIInventoryItemStat>;
    let effectiveDamagePerHitStat: ref<UIInventoryItemStat>;
    let effectiveRangeStat: ref<UIInventoryItemStat>;
    let reloadSpeedStat: ref<UIInventoryItemStat>;
    let statCurveEnabled: Bool = statsManager.IsCurveBarsEnabled();
    let instance: ref<UIInventoryItemWeaponBars> = new UIInventoryItemWeaponBars();
    instance.m_type = UIInventoryItemWeaponBarsType.Ranged;
    instance.m_itemType = itemType;
    if statCurveEnabled {
      cycleTimeStat = statsManager.GetAdditionalStatByType(gamedataStatType.CycleTime);
      ArrayPush(instance.Values, UIInventoryItemWeaponBar.MakeCurve(WeaponBarType.AttackSpeed, 1.00 / cycleTimeStat.Value, statsManager));
      effectiveDamagePerHitStat = statsManager.GetAdditionalStatByType(gamedataStatType.EffectiveDamagePerHit);
      ArrayPush(instance.Values, UIInventoryItemWeaponBar.MakeCurve(WeaponBarType.DamagePerHit, effectiveDamagePerHitStat.Value, statsManager));
      reloadSpeedStat = statsManager.GetAdditionalStatByType(gamedataStatType.ReloadTime);
      ArrayPush(instance.Values, UIInventoryItemWeaponBar.MakeCurve(WeaponBarType.ReloadSpeed, reloadSpeedStat.Value, statsManager));
      effectiveRangeStat = statsManager.GetAdditionalStatByType(gamedataStatType.EffectiveRange);
      ArrayPush(instance.Values, UIInventoryItemWeaponBar.MakeCurve(WeaponBarType.Range, effectiveRangeStat.Value, statsManager));
      ArrayPush(instance.Values, UIInventoryItemWeaponBar.MakeCurve(WeaponBarType.Handling, UIInventoryItemWeaponBars.CalculateHandling(statsManager.GetAdditionalStatByType(gamedataStatType.CycleTime).Value, statsManager.GetAdditionalStatByType(gamedataStatType.SpreadDefaultX).Value, statsManager.GetAdditionalStatByType(gamedataStatType.RecoilKickMax).Value, statsManager.GetAdditionalStatByType(gamedataStatType.RecoilDir).Value, statsManager.GetAdditionalStatByType(gamedataStatType.RecoilAngle).Value, statsManager.GetAdditionalStatByType(gamedataStatType.SwaySideMaximumAngleDistance).Value, statsManager.GetAdditionalStatByType(gamedataStatType.SwaySideBottomAngleLimit).Value), statsManager));
      return instance;
    };
    attacksPerSecondStat = statsManager.GetAdditionalStatByType(gamedataStatType.AttacksPerSecond);
    cycleTimeStat = statsManager.GetAdditionalStatByType(gamedataStatType.CycleTime);
    ArrayPush(instance.Values, UIInventoryItemWeaponBar.Make(itemType, WeaponBarType.AttackSpeed, 1.00 / cycleTimeStat.Value, attacksPerSecondStat.GetProperties().MaxValue()));
    effectiveDamagePerHitStat = statsManager.GetAdditionalStatByType(gamedataStatType.EffectiveDamagePerHit);
    ArrayPush(instance.Values, UIInventoryItemWeaponBar.Make(itemType, WeaponBarType.DamagePerHit, effectiveDamagePerHitStat.Value, effectiveDamagePerHitStat.GetProperties().MaxValue()));
    reloadSpeedStat = statsManager.GetAdditionalStatByType(gamedataStatType.ReloadTime);
    ArrayPush(instance.Values, UIInventoryItemWeaponBar.Make(itemType, WeaponBarType.ReloadSpeed, reloadSpeedStat.Value, reloadSpeedStat.GetProperties().MaxValue()));
    effectiveRangeStat = statsManager.GetAdditionalStatByType(gamedataStatType.EffectiveRange);
    ArrayPush(instance.Values, UIInventoryItemWeaponBar.Make(itemType, WeaponBarType.Range, effectiveRangeStat.Value, effectiveRangeStat.GetProperties().MaxValue()));
    ArrayPush(instance.Values, UIInventoryItemWeaponBar.Make(itemType, WeaponBarType.Handling, UIInventoryItemWeaponBars.CalculateHandling(statsManager.GetAdditionalStatByType(gamedataStatType.CycleTime).Value, statsManager.GetAdditionalStatByType(gamedataStatType.SpreadDefaultX).Value, statsManager.GetAdditionalStatByType(gamedataStatType.RecoilKickMax).Value, statsManager.GetAdditionalStatByType(gamedataStatType.RecoilDir).Value, statsManager.GetAdditionalStatByType(gamedataStatType.RecoilAngle).Value, statsManager.GetAdditionalStatByType(gamedataStatType.SwaySideMaximumAngleDistance).Value, statsManager.GetAdditionalStatByType(gamedataStatType.SwaySideBottomAngleLimit).Value), statsManager.GetAdditionalStatByType(gamedataStatType.Handling).GetProperties().MaxValue()));
    return instance;
  }

  public final static func MakeMelee(statsManager: ref<UIInventoryItemStatsManager>, itemType: gamedataItemType, type: UIInventoryItemWeaponBarsType) -> ref<UIInventoryItemWeaponBars> {
    let attacksPerSecondStat: ref<UIInventoryItemStat>;
    let effectiveDamagePerHitStat: ref<UIInventoryItemStat>;
    let effectiveRangeStat: ref<UIInventoryItemStat>;
    let meleeAttackComboDurationStat: ref<UIInventoryItemStat>;
    let statCurveEnabled: Bool = statsManager.IsCurveBarsEnabled();
    let instance: ref<UIInventoryItemWeaponBars> = new UIInventoryItemWeaponBars();
    instance.m_type = type;
    instance.m_itemType = itemType;
    if statCurveEnabled {
      meleeAttackComboDurationStat = statsManager.GetAdditionalStatByType(gamedataStatType.AttacksPerSecond);
      ArrayPush(instance.Values, UIInventoryItemWeaponBar.MakeCurve(WeaponBarType.MeleeAttackSpeed, meleeAttackComboDurationStat.Value, statsManager));
      effectiveDamagePerHitStat = statsManager.GetAdditionalStatByType(gamedataStatType.EffectiveDamagePerHit);
      ArrayPush(instance.Values, UIInventoryItemWeaponBar.MakeCurve(WeaponBarType.MeleeDamagePerHit, effectiveDamagePerHitStat.Value, statsManager));
      ArrayPush(instance.Values, UIInventoryItemWeaponBar.MakeCurve(WeaponBarType.MeleeStamina, statsManager.GetAdditionalStatByType(gamedataStatType.BaseMeleeAttackStaminaCost).Value, statsManager));
      effectiveRangeStat = statsManager.GetAdditionalStatByType(gamedataStatType.EffectiveRange);
      ArrayPush(instance.Values, UIInventoryItemWeaponBar.MakeCurve(WeaponBarType.ThrowableEffectiveRange, effectiveRangeStat.Value, statsManager, NotEquals(type, UIInventoryItemWeaponBarsType.Throwable)));
      ArrayPush(instance.Values, UIInventoryItemWeaponBar.MakeCurve(WeaponBarType.ThrowableReturnTime, statsManager.GetAdditionalStatByType(gamedataStatType.ThrowRecovery).Value, statsManager, NotEquals(type, UIInventoryItemWeaponBarsType.Throwable)));
      return instance;
    };
    attacksPerSecondStat = statsManager.GetAdditionalStatByType(gamedataStatType.AttacksPerSecond);
    meleeAttackComboDurationStat = statsManager.GetAdditionalStatByType(gamedataStatType.MeleeAttackComboDuration);
    ArrayPush(instance.Values, UIInventoryItemWeaponBar.Make(itemType, WeaponBarType.MeleeAttackSpeed, 1.00 / meleeAttackComboDurationStat.Value, attacksPerSecondStat.GetProperties().MaxValue()));
    effectiveDamagePerHitStat = statsManager.GetAdditionalStatByType(gamedataStatType.EffectiveDamagePerHit);
    ArrayPush(instance.Values, UIInventoryItemWeaponBar.Make(itemType, WeaponBarType.MeleeDamagePerHit, effectiveDamagePerHitStat.Value, effectiveDamagePerHitStat.GetProperties().MaxValue()));
    ArrayPush(instance.Values, UIInventoryItemWeaponBar.Make(itemType, WeaponBarType.MeleeStamina, statsManager.GetAdditionalStatByType(gamedataStatType.BaseMeleeAttackStaminaCost).Value, statsManager.GetAdditionalStatByType(gamedataStatType.Stamina).GetProperties().MaxValue()));
    effectiveRangeStat = statsManager.GetAdditionalStatByType(gamedataStatType.EffectiveRange);
    ArrayPush(instance.Values, UIInventoryItemWeaponBar.Make(itemType, WeaponBarType.ThrowableEffectiveRange, effectiveRangeStat.Value, effectiveRangeStat.GetProperties().MaxValue(), NotEquals(type, UIInventoryItemWeaponBarsType.Throwable)));
    ArrayPush(instance.Values, UIInventoryItemWeaponBar.Make(itemType, WeaponBarType.ThrowableReturnTime, statsManager.GetAdditionalStatByType(gamedataStatType.ThrowRecovery).Value, statsManager.GetAdditionalStatByType(gamedataStatType.ThrowRecovery).GetProperties().MaxValue(), NotEquals(type, UIInventoryItemWeaponBarsType.Throwable)));
    return instance;
  }

  public final func SetComparedBars(comparedBars: ref<UIInventoryItemWeaponBars>) -> ref<UIInventoryItemWeaponBars> {
    this.m_comparedBars = comparedBars;
    return this;
  }

  public final func GetComparedBars() -> wref<UIInventoryItemWeaponBars> {
    return this.m_comparedBars;
  }

  public final func GetPercentages() -> [Float] {
    let itemTypeMultiplier: Float;
    let result: array<Float>;
    let value: Float;
    let displayedStats: array<WeaponBarType> = UIInventoryItemWeaponBars.GetDisplayedStats(this.GetType());
    let i: Int32 = 0;
    let limit: Int32 = ArraySize(displayedStats);
    while i < limit {
      value = this.Values[i].Value;
      itemTypeMultiplier = UIInventoryItemWeaponBars.GetItemTypeMultiplier(this.GetItemType());
      value *= itemTypeMultiplier;
      ArrayPush(result, value / this.Values[i].MaxValue * 100.00);
      i += 1;
    };
    return result;
  }

  public final static func GetItemTypeMultiplier(itemType: gamedataItemType) -> Float {
    if Equals(itemType, gamedataItemType.Wea_SniperRifle) {
      return 0.50;
    };
    if Equals(itemType, gamedataItemType.Wea_Shotgun) || Equals(itemType, gamedataItemType.Wea_ShotgunDual) {
      return 0.70;
    };
    return 1.00;
  }

  public final static func IsBarReversed(barType: WeaponBarType) -> Bool {
    return Equals(barType, WeaponBarType.ReloadSpeed) || Equals(barType, WeaponBarType.ThrowableReturnTime) || Equals(barType, WeaponBarType.Stamina) || Equals(barType, WeaponBarType.MeleeStamina);
  }

  public final static func GetDisplayedStats(barsType: UIInventoryItemWeaponBarsType) -> [WeaponBarType] {
    let result: array<WeaponBarType>;
    if Equals(barsType, UIInventoryItemWeaponBarsType.Ranged) {
      ArrayPush(result, WeaponBarType.AttackSpeed);
      ArrayPush(result, WeaponBarType.DamagePerHit);
      ArrayPush(result, WeaponBarType.ReloadSpeed);
      ArrayPush(result, WeaponBarType.Range);
      ArrayPush(result, WeaponBarType.Handling);
    } else {
      if Equals(barsType, UIInventoryItemWeaponBarsType.CyberwareRangedWeapon) {
        ArrayPush(result, WeaponBarType.CyberwareAttackSpeed);
        ArrayPush(result, WeaponBarType.CyberwareDamagePerHit);
      } else {
        if Equals(barsType, UIInventoryItemWeaponBarsType.InjectorHealing) || Equals(barsType, UIInventoryItemWeaponBarsType.InhalerHealing) {
          ArrayPush(result, WeaponBarType.Healing);
          ArrayPush(result, WeaponBarType.HealingOverTime);
        } else {
          ArrayPush(result, WeaponBarType.MeleeAttackSpeed);
          ArrayPush(result, WeaponBarType.MeleeDamagePerHit);
          ArrayPush(result, WeaponBarType.MeleeStamina);
          if Equals(barsType, UIInventoryItemWeaponBarsType.Throwable) {
            ArrayPush(result, WeaponBarType.ThrowableEffectiveRange);
            ArrayPush(result, WeaponBarType.ThrowableReturnTime);
          };
        };
      };
    };
    return result;
  }

  public final func GetType() -> UIInventoryItemWeaponBarsType {
    return this.m_type;
  }

  public final func GetItemType() -> gamedataItemType {
    return this.m_itemType;
  }

  public final func GetComparableBar(barType: WeaponBarType) -> wref<UIInventoryItemWeaponBar> {
    let targetGroup: WeaponBarTypeGroup = UIInventoryItemWeaponBar.GetBarTypeGroup(barType);
    let i: Int32 = 0;
    let limit: Int32 = ArraySize(this.Values);
    while i < limit {
      if Equals(this.Values[i].GetBarTypeGroup(), targetGroup) {
        return this.Values[i];
      };
      i += 1;
    };
    return null;
  }

  private final static func CalculateHandling(cycleTime: Float, spreadDefaultX: Float, recoilKickMax: Float, recoilDirection: Float, recoilAngle: Float, swaySide: Float, swayBottom: Float) -> Float {
    return 1.00 / (1.00 + (1.00 + cycleTime) * spreadDefaultX + (1.00 + recoilKickMax / 5.00) * (1.00 + AbsF(recoilDirection) / 360.00) * (1.00 + recoilAngle / 90.00) + 0.10 + (swaySide * swayBottom) / 90.00);
  }

  private final static func CalculateStamina(weaponTypeToStaminaCost: Float, magazineCapacity: Float, weaponEvolutionToStaminaCost: Float, firePower: Float) -> Float {
    return weaponTypeToStaminaCost * 1.00 / magazineCapacity * weaponEvolutionToStaminaCost * firePower;
  }

  private final static func CalculateMeleeStamina() -> Float {
    return 0.00;
  }

  private final static func CalculateMeleeReturnTime() -> Float {
    return 0.00;
  }
}

public class UIInventoryItemStat extends IScriptable {

  public let Type: gamedataStatType;

  public let Value: Float;

  public let PropertiesProvider: ref<IUIInventoryItemStatsProvider>;

  private let m_properties: ref<UIItemStatProperties>;

  private let m_propertiesFetched: Bool;

  public final func GetProperties() -> wref<UIItemStatProperties> {
    if this.m_propertiesFetched {
      return this.m_properties;
    };
    this.m_properties = this.PropertiesProvider.Get();
    this.m_propertiesFetched = true;
    return this.m_properties;
  }

  public final func SetProperties(properties: ref<UIItemStatProperties>) -> Void {
    this.m_propertiesFetched = true;
    this.m_properties = properties;
  }
}

public abstract class IUIInventoryItemStatsProvider extends IScriptable {

  public func Get() -> ref<UIItemStatProperties> {
    return null;
  }
}

public class DefaultUIInventoryItemStatsProvider extends IUIInventoryItemStatsProvider {

  private let m_statType: gamedataStatType;

  private let m_manager: wref<UIInventoryItemsManager>;

  public final static func Make(statType: gamedataStatType, opt manager: wref<UIInventoryItemsManager>) -> ref<DefaultUIInventoryItemStatsProvider> {
    let instance: ref<DefaultUIInventoryItemStatsProvider> = new DefaultUIInventoryItemStatsProvider();
    instance.m_statType = statType;
    instance.m_manager = manager;
    return instance;
  }

  public func Get() -> ref<UIItemStatProperties> {
    if this.m_manager != null {
      return this.m_manager.GetCachedUIStatProperties(this.m_statType);
    };
    return UIInventoryItemsManager.GetUIStatProperties(this.m_statType);
  }
}
