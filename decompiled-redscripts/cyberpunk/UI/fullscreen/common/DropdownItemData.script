
public abstract final class SortingDropdownData extends IScriptable {

  public final static func GetDropdownOption(const options: script_ref<[ref<DropdownItemData>]>, identifier: ItemSortMode) -> ref<DropdownItemData> {
    let i: Int32 = 0;
    while i < ArraySize(Deref(options)) {
      if Equals(FromVariant<ItemSortMode>(Deref(options)[i].identifier), identifier) {
        return Deref(options)[i];
      };
      i += 1;
    };
    return null;
  }

  private final static func GetDropdownItemData(identifier: Variant, labelKey: CName, direction: DropdownItemDirection) -> ref<DropdownItemData> {
    let itemData: ref<DropdownItemData> = new DropdownItemData();
    itemData.identifier = identifier;
    itemData.labelKey = labelKey;
    itemData.direction = direction;
    return itemData;
  }

  public final static func GetDefaultDropdownOptions() -> [ref<DropdownItemData>] {
    let result: array<ref<DropdownItemData>>;
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.Default), n"UI-Sorting-Default", DropdownItemDirection.None));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.NewItems), n"UI-Sorting-NewItems", DropdownItemDirection.None));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.NameAsc), n"UI-Sorting-Name", DropdownItemDirection.Down));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.NameDesc), n"UI-Sorting-Name", DropdownItemDirection.Up));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.DpsDesc), n"UI-Sorting-DPS", DropdownItemDirection.Down));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.DpsAsc), n"UI-Sorting-DPS", DropdownItemDirection.Up));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.QualityAsc), n"UI-Sorting-Quality", DropdownItemDirection.Down));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.QualityDesc), n"UI-Sorting-Quality", DropdownItemDirection.Up));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.WeightDesc), n"UI-Sorting-Weight", DropdownItemDirection.Down));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.WeightAsc), n"UI-Sorting-Weight", DropdownItemDirection.Up));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.PriceDesc), n"UI-Sorting-Price", DropdownItemDirection.Down));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.PriceAsc), n"UI-Sorting-Price", DropdownItemDirection.Up));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.ItemType), n"UI-Sorting-ItemType", DropdownItemDirection.None));
    return result;
  }

  public final static func GetItemChooserWeaponDropdownOptions() -> [ref<DropdownItemData>] {
    let result: array<ref<DropdownItemData>>;
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.Default), n"UI-Sorting-Default", DropdownItemDirection.None));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.NewItems), n"UI-Sorting-NewItems", DropdownItemDirection.None));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.NameAsc), n"UI-Sorting-Name", DropdownItemDirection.Down));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.NameDesc), n"UI-Sorting-Name", DropdownItemDirection.Up));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.DpsDesc), n"UI-Sorting-DPS", DropdownItemDirection.Down));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.DpsAsc), n"UI-Sorting-DPS", DropdownItemDirection.Up));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.QualityAsc), n"UI-Sorting-Quality", DropdownItemDirection.Down));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.QualityDesc), n"UI-Sorting-Quality", DropdownItemDirection.Up));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.WeightDesc), n"UI-Sorting-Weight", DropdownItemDirection.Down));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.WeightAsc), n"UI-Sorting-Weight", DropdownItemDirection.Up));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.PriceDesc), n"UI-Sorting-Price", DropdownItemDirection.Down));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.PriceAsc), n"UI-Sorting-Price", DropdownItemDirection.Up));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.ItemType), n"UI-Sorting-ItemType", DropdownItemDirection.None));
    return result;
  }

  public final static func GetContextDropdownOptions(context: DropdownDisplayContext) -> [ref<DropdownItemData>] {
    switch context {
      case DropdownDisplayContext.Default:
        return SortingDropdownData.GetDefaultDropdownOptions();
      case DropdownDisplayContext.ItemChooserWeapon:
        return SortingDropdownData.GetItemChooserWeaponDropdownOptions();
    };
    return SortingDropdownData.GetDefaultDropdownOptions();
  }

  public final static func GeVisualsDropdownOptions() -> [ref<DropdownItemData>] {
    let result: array<ref<DropdownItemData>>;
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.Default), n"UI-Sorting-Default", DropdownItemDirection.None));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.NewItems), n"UI-Sorting-NewItems", DropdownItemDirection.None));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.NameAsc), n"UI-Sorting-Name", DropdownItemDirection.Down));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.NameDesc), n"UI-Sorting-Name", DropdownItemDirection.Up));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.QualityAsc), n"UI-Sorting-Quality", DropdownItemDirection.Down));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.QualityDesc), n"UI-Sorting-Quality", DropdownItemDirection.Up));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.PriceDesc), n"UI-Sorting-Price", DropdownItemDirection.Down));
    ArrayPush(result, SortingDropdownData.GetDropdownItemData(ToVariant(ItemSortMode.PriceAsc), n"UI-Sorting-Price", DropdownItemDirection.Up));
    return result;
  }
}
