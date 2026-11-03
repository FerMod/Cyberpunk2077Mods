
public class CompareBuilder extends IScriptable {

  @default(CompareBuilder, 0.01f)
  private let FLOAT_EQUAL_EPSILON: Float;

  private let value: Int32;

  public final static func Make() -> ref<CompareBuilder> {
    let builder: ref<CompareBuilder> = new CompareBuilder();
    return builder;
  }

  public final func Reset() -> Void {
    this.value = 0;
  }

  public final func Get() -> Int32 {
    return this.value;
  }

  public final func GetBool() -> Bool {
    return this.value > 0;
  }

  public final func StringAsc(const a: script_ref<String>, const b: script_ref<String>) -> ref<CompareBuilder> {
    if this.value == 0 {
      this.value = UnicodeStringCompare(a, b) * -1;
    };
    return this;
  }

  public final func StringDesc(const a: script_ref<String>, const b: script_ref<String>) -> ref<CompareBuilder> {
    if this.value == 0 {
      this.value = UnicodeStringCompare(a, b);
    };
    return this;
  }

  public final func UnicodeStringAsc(const a: script_ref<String>, const b: script_ref<String>) -> ref<CompareBuilder> {
    if this.value == 0 {
      this.value = UnicodeStringLessThan(a, b) ? 1 : -1;
    };
    return this;
  }

  public final func UnicodeStringDesc(const a: script_ref<String>, const b: script_ref<String>) -> ref<CompareBuilder> {
    if this.value == 0 {
      this.value = !UnicodeStringLessThanEqual(a, b) ? 1 : -1;
    };
    return this;
  }

  public final func IntAsc(a: Int32, b: Int32) -> ref<CompareBuilder> {
    if this.value == 0 {
      if a == b {
        this.value = 0;
      } else {
        this.value = a < b ? 1 : -1;
      };
    };
    return this;
  }

  public final func IntDesc(a: Int32, b: Int32) -> ref<CompareBuilder> {
    if this.value == 0 {
      if a == b {
        this.value = 0;
      } else {
        this.value = a > b ? 1 : -1;
      };
    };
    return this;
  }

  public final func FloatAsc(a: Float, b: Float) -> ref<CompareBuilder> {
    if this.value == 0 {
      if AbsF(a - b) < this.FLOAT_EQUAL_EPSILON {
        this.value = 0;
      } else {
        this.value = a < b ? 1 : -1;
      };
    };
    return this;
  }

  public final func FloatDesc(a: Float, b: Float) -> ref<CompareBuilder> {
    if this.value == 0 {
      if AbsF(a - b) < this.FLOAT_EQUAL_EPSILON {
        this.value = 0;
      } else {
        this.value = a > b ? 1 : -1;
      };
    };
    return this;
  }

  public final func BoolTrue(a: Bool, b: Bool) -> ref<CompareBuilder> {
    if this.value == 0 {
      if Equals(a, b) {
        this.value = 0;
      } else {
        this.value = a ? 1 : -1;
      };
    };
    return this;
  }

  public final func BoolFalse(a: Bool, b: Bool) -> ref<CompareBuilder> {
    if this.value == 0 {
      if Equals(a, b) {
        this.value = 0;
      } else {
        this.value = a ? -1 : 1;
      };
    };
    return this;
  }

  public final func GameTimeAsc(a: GameTime, b: GameTime) -> ref<CompareBuilder> {
    if this.value == 0 {
      if a == b {
        this.value = 0;
      } else {
        this.value = a < b ? 1 : -1;
      };
    };
    return this;
  }

  public final func GameTimeDesc(a: GameTime, b: GameTime) -> ref<CompareBuilder> {
    if this.value == 0 {
      if a == b {
        this.value = 0;
      } else {
        this.value = a > b ? 1 : -1;
      };
    };
    return this;
  }
}

public class NewItemCompareBuilder extends IScriptable {

  private let m_sortData1: ref<UIInventoryItem>;

  private let m_sortData2: ref<UIInventoryItem>;

  private let m_compareBuilder: ref<CompareBuilder>;

  public final static func Make(sortData1: ref<UIInventoryItem>, sortData2: ref<UIInventoryItem>) -> ref<NewItemCompareBuilder> {
    let builder: ref<NewItemCompareBuilder> = new NewItemCompareBuilder();
    builder.m_compareBuilder = CompareBuilder.Make();
    builder.m_sortData1 = sortData1;
    builder.m_sortData2 = sortData2;
    return builder;
  }

  public final func Get() -> Int32 {
    return this.m_compareBuilder.Get();
  }

  public final func GetBool() -> Bool {
    return this.m_compareBuilder.GetBool();
  }

  public final func NameAsc() -> ref<NewItemCompareBuilder> {
    this.m_compareBuilder.StringAsc(this.m_sortData1.GetName(), this.m_sortData2.GetName());
    return this;
  }

  public final func NameDesc() -> ref<NewItemCompareBuilder> {
    this.m_compareBuilder.StringDesc(this.m_sortData1.GetName(), this.m_sortData2.GetName());
    return this;
  }

  public final func QualityAsc() -> ref<NewItemCompareBuilder> {
    this.m_compareBuilder.IntAsc(this.m_sortData1.GetQualityInt(), this.m_sortData2.GetQualityInt());
    return this;
  }

  public final func QualityDesc() -> ref<NewItemCompareBuilder> {
    this.m_compareBuilder.IntDesc(this.m_sortData1.GetQualityInt(), this.m_sortData2.GetQualityInt());
    return this;
  }

  public final func PriceAsc() -> ref<NewItemCompareBuilder> {
    this.m_compareBuilder.FloatAsc(this.m_sortData1.GetSellPrice(), this.m_sortData2.GetSellPrice());
    return this;
  }

  public final func PriceDesc() -> ref<NewItemCompareBuilder> {
    this.m_compareBuilder.FloatDesc(this.m_sortData1.GetSellPrice(), this.m_sortData2.GetSellPrice());
    return this;
  }

  public final func WeightAsc() -> ref<NewItemCompareBuilder> {
    this.m_compareBuilder.FloatAsc(this.m_sortData1.GetWeight(), this.m_sortData2.GetWeight());
    return this;
  }

  public final func WeightDesc() -> ref<NewItemCompareBuilder> {
    this.m_compareBuilder.FloatDesc(this.m_sortData1.GetWeight(), this.m_sortData2.GetWeight());
    return this;
  }

  public final func DPSAsc() -> ref<NewItemCompareBuilder> {
    let leftValue: Float;
    let rightValue: Float;
    if this.m_sortData1.IsWeapon() {
      leftValue = this.m_sortData1.GetPrimaryStat().Value;
    };
    if this.m_sortData2.IsWeapon() {
      rightValue = this.m_sortData2.GetPrimaryStat().Value;
    };
    this.m_compareBuilder.FloatAsc(leftValue, rightValue);
    return this;
  }

  public final func DPSDesc() -> ref<NewItemCompareBuilder> {
    let leftValue: Float;
    let rightValue: Float;
    if this.m_sortData1.IsWeapon() {
      leftValue = this.m_sortData1.GetPrimaryStat().Value;
    };
    if this.m_sortData2.IsWeapon() {
      rightValue = this.m_sortData2.GetPrimaryStat().Value;
    };
    this.m_compareBuilder.FloatDesc(leftValue, rightValue);
    return this;
  }

  public final func ItemType() -> ref<NewItemCompareBuilder> {
    this.m_compareBuilder.IntAsc(this.m_sortData1.GetItemTypeOrder(), this.m_sortData2.GetItemTypeOrder());
    return this;
  }

  public final func QuestItem() -> ref<NewItemCompareBuilder> {
    this.m_compareBuilder.BoolTrue(this.m_sortData1.IsQuestItem(), this.m_sortData2.IsQuestItem());
    return this;
  }

  public final func NewItem() -> ref<NewItemCompareBuilder> {
    this.m_compareBuilder.BoolTrue(this.m_sortData1.IsNew(), this.m_sortData2.IsNew());
    return this;
  }

  public final func FavouriteItem() -> ref<NewItemCompareBuilder> {
    this.m_compareBuilder.BoolTrue(this.m_sortData1.IsPlayerFavourite(), this.m_sortData2.IsPlayerFavourite());
    return this;
  }
}

public class ItemCompareBuilder extends IScriptable {

  private let m_sortData1: InventoryItemSortData;

  private let m_sortData2: InventoryItemSortData;

  private let m_compareBuilder: ref<CompareBuilder>;

  public final static func Make(const sortData1: script_ref<InventoryItemSortData>, const sortData2: script_ref<InventoryItemSortData>) -> ref<ItemCompareBuilder> {
    let builder: ref<ItemCompareBuilder> = new ItemCompareBuilder();
    builder.m_compareBuilder = CompareBuilder.Make();
    builder.m_sortData1 = Deref(sortData1);
    builder.m_sortData2 = Deref(sortData2);
    return builder;
  }

  public final func Get() -> Int32 {
    return this.m_compareBuilder.Get();
  }

  public final func GetBool() -> Bool {
    return this.m_compareBuilder.GetBool();
  }

  public final func NameAsc() -> ref<ItemCompareBuilder> {
    this.m_compareBuilder.StringAsc(this.m_sortData1.Name, this.m_sortData2.Name);
    return this;
  }

  public final func NameDesc() -> ref<ItemCompareBuilder> {
    this.m_compareBuilder.StringDesc(this.m_sortData1.Name, this.m_sortData2.Name);
    return this;
  }

  public final func QualityAsc() -> ref<ItemCompareBuilder> {
    this.m_compareBuilder.IntAsc(this.m_sortData1.Quality, this.m_sortData2.Quality);
    return this;
  }

  public final func QualityDesc() -> ref<ItemCompareBuilder> {
    this.m_compareBuilder.IntDesc(this.m_sortData1.Quality, this.m_sortData2.Quality);
    return this;
  }

  public final func PriceAsc() -> ref<ItemCompareBuilder> {
    this.m_compareBuilder.IntAsc(this.m_sortData1.Price, this.m_sortData2.Price);
    return this;
  }

  public final func PriceDesc() -> ref<ItemCompareBuilder> {
    this.m_compareBuilder.IntDesc(this.m_sortData1.Price, this.m_sortData2.Price);
    return this;
  }

  public final func WeightAsc() -> ref<ItemCompareBuilder> {
    this.m_compareBuilder.FloatAsc(this.m_sortData1.Weight, this.m_sortData2.Weight);
    return this;
  }

  public final func WeightDesc() -> ref<ItemCompareBuilder> {
    this.m_compareBuilder.FloatDesc(this.m_sortData1.Weight, this.m_sortData2.Weight);
    return this;
  }

  public final func DPSAsc() -> ref<ItemCompareBuilder> {
    this.m_compareBuilder.IntAsc(this.m_sortData1.DPS, this.m_sortData2.DPS);
    return this;
  }

  public final func DPSDesc() -> ref<ItemCompareBuilder> {
    this.m_compareBuilder.IntDesc(this.m_sortData1.DPS, this.m_sortData2.DPS);
    return this;
  }

  public final func ItemType() -> ref<ItemCompareBuilder> {
    this.m_compareBuilder.IntAsc(this.m_sortData1.ItemType, this.m_sortData2.ItemType);
    return this;
  }

  public final func QuestItem() -> ref<ItemCompareBuilder> {
    this.m_compareBuilder.BoolTrue(this.m_sortData1.QuestItem, this.m_sortData2.QuestItem);
    return this;
  }

  public final func NewItem(uiScriptableSystem: ref<UIScriptableSystem>) -> ref<ItemCompareBuilder> {
    this.m_compareBuilder.BoolTrue(this.m_sortData1.NewItem, this.m_sortData2.NewItem);
    return this;
  }

  public final func DLCAddedItem() -> ref<ItemCompareBuilder> {
    this.m_compareBuilder.BoolTrue(this.m_sortData1.DLCAddedItem, this.m_sortData2.DLCAddedItem);
    return this;
  }

  public final func ChimeraMod() -> ref<ItemCompareBuilder> {
    this.m_compareBuilder.BoolTrue(this.m_sortData1.ChimeraMod, this.m_sortData2.ChimeraMod);
    return this;
  }

  public final func FavouriteItem() -> ref<ItemCompareBuilder> {
    this.m_compareBuilder.BoolTrue(this.m_sortData1.IsPlayerFavourite, this.m_sortData2.IsPlayerFavourite);
    return this;
  }

  public final static func BuildInventoryItemSortData(const item: script_ref<InventoryItemData>, uiScriptableSystem: ref<UIScriptableSystem>) -> InventoryItemSortData {
    let sortData: InventoryItemSortData;
    let itemID: ItemID = InventoryItemData.GetID(item);
    sortData.Name = GetLocalizedText(InventoryItemData.GetName(item));
    sortData.Quality = UIItemsHelper.QualityNameToInt(InventoryItemData.GetQuality(item));
    sortData.Price = Cast<Int32>(InventoryItemData.GetPrice(item));
    sortData.Weight = InventoryItemData.GetGameItemData(item).GetStatValueByType(gamedataStatType.Weight);
    sortData.DPS = ItemCompareBuilder.GetDPS(item);
    sortData.ItemType = ItemCompareBuilder.GetItemTypeOrder(item);
    sortData.QuestItem = InventoryItemData.GetGameItemData(item).HasTag(n"Quest");
    sortData.NewItem = uiScriptableSystem.IsInventoryItemNew(itemID);
    sortData.DLCAddedItem = InventoryItemData.GetGameItemData(item).HasTag(n"DLCAdded") && uiScriptableSystem.IsDLCAddedActiveItem(ItemID.GetTDBID(itemID));
    sortData.ChimeraMod = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(itemID)).TagsContains(n"ChimeraMod");
    sortData.IsPlayerFavourite = uiScriptableSystem.IsItemPlayerFavourite(itemID);
    return sortData;
  }

  private final static func GetDPS(const item: script_ref<InventoryItemData>) -> Int32 {
    let stat: StatViewData;
    let size: Int32 = InventoryItemData.GetPrimaryStatsSize(item);
    let i: Int32 = 0;
    while i < size {
      stat = InventoryItemData.GetPrimaryStat(item, i);
      if Equals(stat.type, gamedataStatType.EffectiveDPS) {
        return stat.value;
      };
      i += 1;
    };
    return -1;
  }

  private final static func GetTypeSortValue(const item: script_ref<InventoryItemData>) -> Int32 {
    if InventoryItemData.GetGameItemData(item).HasTag(n"Quest") {
      return 0;
    };
    switch InventoryItemData.GetEquipmentArea(item) {
      case gamedataEquipmentArea.Weapon:
        return 1;
      case gamedataEquipmentArea.Outfit:
        return 2;
      case gamedataEquipmentArea.Head:
        return 3;
      case gamedataEquipmentArea.Face:
        return 4;
      case gamedataEquipmentArea.OuterChest:
        return 5;
      case gamedataEquipmentArea.InnerChest:
        return 6;
      case gamedataEquipmentArea.Legs:
        return 7;
      case gamedataEquipmentArea.Feet:
        return 8;
      case gamedataEquipmentArea.Gadget:
        return 9;
      case gamedataEquipmentArea.QuickSlot:
        return 9;
      case gamedataEquipmentArea.Consumable:
        return 9;
    };
    return 99;
  }

  private final static func GetEquipmentAreaIndex(equipmentArea: gamedataEquipmentArea) -> Int32 {
    switch equipmentArea {
      case gamedataEquipmentArea.Weapon:
        return 1;
      case gamedataEquipmentArea.Outfit:
        return 2;
      case gamedataEquipmentArea.Head:
        return 3;
      case gamedataEquipmentArea.Face:
        return 4;
      case gamedataEquipmentArea.OuterChest:
        return 5;
      case gamedataEquipmentArea.InnerChest:
        return 6;
      case gamedataEquipmentArea.Legs:
        return 7;
      case gamedataEquipmentArea.Feet:
        return 8;
      case gamedataEquipmentArea.Gadget:
        return 9;
      case gamedataEquipmentArea.QuickSlot:
        return 10;
      case gamedataEquipmentArea.Consumable:
        return 11;
    };
    return 12;
  }

  private final static func GetItemTypeIndex(itemType: gamedataItemType) -> Int32 {
    switch itemType {
      case gamedataItemType.Clo_Face:
        return 1;
      case gamedataItemType.Clo_Head:
        return 2;
      case gamedataItemType.Clo_OuterChest:
        return 3;
      case gamedataItemType.Clo_InnerChest:
        return 4;
      case gamedataItemType.Clo_Legs:
        return 5;
      case gamedataItemType.Clo_Feet:
        return 6;
      case gamedataItemType.Clo_Outfit:
        return 7;
      case gamedataItemType.Con_Edible:
        return 1;
      case gamedataItemType.Con_Inhaler:
        return 2;
      case gamedataItemType.Con_Injector:
        return 3;
      case gamedataItemType.Con_LongLasting:
        return 4;
      case gamedataItemType.Cyb_Ability:
        return 5;
      case gamedataItemType.Cyb_Launcher:
        return 6;
      case gamedataItemType.Cyb_MantisBlades:
        return 7;
      case gamedataItemType.Cyb_NanoWires:
        return 8;
      case gamedataItemType.Cyb_StrongArms:
        return 9;
      case gamedataItemType.Fla_Launcher:
        return 1;
      case gamedataItemType.Fla_Rifle:
        return 2;
      case gamedataItemType.Fla_Shock:
        return 3;
      case gamedataItemType.Fla_Support:
        return 4;
      case gamedataItemType.Gad_Grenade:
        return 1;
      case gamedataItemType.Gen_CraftingMaterial:
        return 2;
      case gamedataItemType.Gen_DataBank:
        return 3;
      case gamedataItemType.Gen_Junk:
        return 4;
      case gamedataItemType.Gen_Jewellery:
        return 5;
      case gamedataItemType.Gen_Keycard:
        return 6;
      case gamedataItemType.Gen_Misc:
        return 7;
      case gamedataItemType.Gen_Readable:
        return 8;
      case gamedataItemType.GrenadeDelivery:
        return 9;
      case gamedataItemType.Grenade_Core:
        return 10;
      case gamedataItemType.Gen_Tarot:
        return 11;
      case gamedataItemType.Prt_Capacitor:
        return 1;
      case gamedataItemType.Prt_FabricEnhancer:
        return 2;
      case gamedataItemType.Prt_Fragment:
        return 3;
      case gamedataItemType.Prt_Magazine:
        return 4;
      case gamedataItemType.Prt_Mod:
        return 5;
      case gamedataItemType.Prt_RangedMod:
        return 6;
      case gamedataItemType.Prt_PowerMod:
        return 7;
      case gamedataItemType.Prt_TechMod:
        return 8;
      case gamedataItemType.Prt_SmartMod:
        return 9;
      case gamedataItemType.Prt_AR_SMG_LMGMod:
        return 10;
      case gamedataItemType.Prt_HandgunMod:
        return 11;
      case gamedataItemType.Prt_Precision_Sniper_RifleMod:
        return 12;
      case gamedataItemType.Prt_ShotgunMod:
        return 13;
      case gamedataItemType.Prt_MeleeMod:
        return 14;
      case gamedataItemType.Prt_BladeMod:
        return 15;
      case gamedataItemType.Prt_BluntMod:
        return 16;
      case gamedataItemType.Prt_ThrowableMod:
        return 17;
      case gamedataItemType.Prt_Muzzle:
        return 18;
      case gamedataItemType.Prt_Program:
        return 19;
      case gamedataItemType.Prt_Receiver:
        return 20;
      case gamedataItemType.Prt_Scope:
        return 21;
      case gamedataItemType.Prt_ShortScope:
        return 22;
      case gamedataItemType.Prt_LongScope:
        return 23;
      case gamedataItemType.Prt_TechSniperScope:
        return 24;
      case gamedataItemType.Prt_PowerSniperScope:
        return 25;
      case gamedataItemType.Prt_ScopeRail:
        return 26;
      case gamedataItemType.Prt_Stock:
        return 27;
      case gamedataItemType.Prt_TargetingSystem:
        return 28;
      case gamedataItemType.Wea_SniperRifle:
        return 1;
      case gamedataItemType.Wea_PrecisionRifle:
        return 2;
      case gamedataItemType.Wea_AssaultRifle:
        return 3;
      case gamedataItemType.Wea_Rifle:
        return 4;
      case gamedataItemType.Wea_HeavyMachineGun:
        return 5;
      case gamedataItemType.Wea_LightMachineGun:
        return 6;
      case gamedataItemType.Wea_SubmachineGun:
        return 7;
      case gamedataItemType.Wea_Shotgun:
        return 8;
      case gamedataItemType.Wea_ShotgunDual:
        return 9;
      case gamedataItemType.Wea_Handgun:
        return 10;
      case gamedataItemType.Wea_Revolver:
        return 11;
      case gamedataItemType.Wea_TwoHandedClub:
        return 12;
      case gamedataItemType.Wea_Hammer:
        return 13;
      case gamedataItemType.Wea_ShortBlade:
        return 14;
      case gamedataItemType.Wea_LongBlade:
        return 15;
      case gamedataItemType.Wea_Melee:
        return 16;
      case gamedataItemType.Wea_OneHandedClub:
        return 17;
      case gamedataItemType.Wea_Katana:
        return 18;
      case gamedataItemType.Wea_Knife:
        return 19;
      case gamedataItemType.Wea_Axe:
        return 20;
      case gamedataItemType.Wea_Chainsword:
        return 21;
      case gamedataItemType.Wea_Machete:
        return 22;
      case gamedataItemType.Wea_Sword:
        return 23;
    };
    return 0;
  }

  private final static func HasItemTypeInnerIndex(itemType: gamedataItemType) -> Bool {
    return Equals(itemType, gamedataItemType.Prt_Mod);
  }

  private final static func GetItemTypeInnerIndex(itemType: gamedataItemType, itemData: wref<gameItemData>) -> Int32 {
    let tags: array<CName>;
    if RPGManager.IsWeaponMod(itemType) {
      tags = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(itemData.GetID())).Tags();
      if ArrayContains(tags, n"Power") {
        return 1;
      };
      if ArrayContains(tags, n"Tech") {
        return 2;
      };
      if ArrayContains(tags, n"Smart") {
        return 3;
      };
      if ArrayContains(tags, n"MeleeMod") {
        return 4;
      };
    };
    return 0;
  }

  public final static func GetItemTypeOrder(const item: script_ref<InventoryItemData>) -> Int32 {
    let value: Int32;
    let equipmentArea: gamedataEquipmentArea = InventoryItemData.GetEquipmentArea(item);
    let itemType: gamedataItemType = InventoryItemData.GetItemType(item);
    if Equals(itemType, gamedataItemType.Invalid) {
      return 0;
    };
    value += ItemCompareBuilder.GetEquipmentAreaIndex(equipmentArea) * 10000;
    value += ItemCompareBuilder.GetItemTypeIndex(itemType) * 100;
    if ItemCompareBuilder.HasItemTypeInnerIndex(itemType) {
      value += ItemCompareBuilder.GetItemTypeInnerIndex(itemType, InventoryItemData.GetGameItemData(item));
    };
    return value;
  }

  public final static func GetItemTypeOrder(itemData: wref<gameItemData>, equipmentArea: gamedataEquipmentArea, itemType: gamedataItemType) -> Int32 {
    let value: Int32;
    if Equals(itemType, gamedataItemType.Invalid) {
      return 0;
    };
    value += ItemCompareBuilder.GetEquipmentAreaIndex(equipmentArea) * 10000;
    value += ItemCompareBuilder.GetItemTypeIndex(itemType) * 100;
    if ItemCompareBuilder.HasItemTypeInnerIndex(itemType) {
      value += ItemCompareBuilder.GetItemTypeInnerIndex(itemType, itemData);
    };
    return value;
  }
}
