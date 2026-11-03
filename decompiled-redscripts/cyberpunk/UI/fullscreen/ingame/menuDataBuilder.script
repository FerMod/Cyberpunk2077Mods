
public class MenuDataBuilder extends IScriptable {

  public let m_data: [MenuData];

  public final static func Make() -> ref<MenuDataBuilder> {
    let instance: ref<MenuDataBuilder> = new MenuDataBuilder();
    return instance;
  }

  public final func AddIf(condition: Bool, identifier: Int32, fullscreenName: CName, icon: CName, labelKey: CName, opt userData: ref<IScriptable>) -> ref<MenuDataBuilder> {
    if condition {
      return this.Add(identifier, fullscreenName, icon, labelKey, userData);
    };
    return this;
  }

  public final func Add(identifier: Int32, fullscreenName: CName, icon: CName, labelKey: CName, opt userData: ref<IScriptable>) -> ref<MenuDataBuilder> {
    let data: MenuData;
    data.label = GetLocalizedTextByKey(labelKey);
    data.icon = icon;
    data.fullscreenName = fullscreenName;
    data.identifier = identifier;
    data.userData = userData;
    ArrayPush(this.m_data, data);
    return this;
  }

  private final func Add(data: MenuData, identifier: HubMenuItems, parentIdentifier: HubMenuItems, fullscreenName: CName, icon: CName, opt userData: ref<IScriptable>, opt disabled: Bool) -> ref<MenuDataBuilder> {
    data.icon = icon;
    data.fullscreenName = fullscreenName;
    data.identifier = EnumInt(identifier);
    data.parentIdentifier = EnumInt(parentIdentifier);
    data.userData = userData;
    data.disabled = disabled;
    ArrayPush(this.m_data, data);
    return this;
  }

  public final func Add(identifier: HubMenuItems, parentIdentifier: HubMenuItems, fullscreenName: CName, icon: CName, labelKey: String, opt userData: ref<IScriptable>, opt disabled: Bool) -> ref<MenuDataBuilder> {
    let data: MenuData;
    data.label = GetLocalizedText(labelKey);
    return this.Add(data, identifier, parentIdentifier, fullscreenName, icon, userData, disabled);
  }

  public final func Add(identifier: HubMenuItems, parentIdentifier: HubMenuItems, fullscreenName: CName, icon: CName, labelName: CName, opt userData: ref<IScriptable>, opt disabled: Bool) -> ref<MenuDataBuilder> {
    let data: MenuData;
    data.label = GetLocalizedTextByKey(labelName);
    return this.Add(data, identifier, parentIdentifier, fullscreenName, icon, userData, disabled);
  }

  public final func AddWithSubmenu(identifier: Int32, fullscreenName: CName, icon: CName, labelKey: CName, opt userData: ref<IScriptable>, opt disabled: Bool) -> ref<SubmenuDataBuilder> {
    let data: MenuData;
    data.label = GetLocalizedTextByKey(labelKey);
    data.icon = icon;
    data.fullscreenName = fullscreenName;
    data.identifier = identifier;
    data.userData = userData;
    data.disabled = disabled;
    ArrayPush(this.m_data, data);
    return SubmenuDataBuilder.Make(this, ArraySize(this.m_data) - 1);
  }

  public final func Get() -> [MenuData] {
    return this.m_data;
  }

  public final func GetMainMenus() -> [MenuData] {
    let currentData: MenuData;
    let res: array<MenuData>;
    let count: Int32 = ArraySize(this.m_data);
    let i: Int32 = 0;
    while i < count {
      currentData = this.m_data[i];
      if currentData.parentIdentifier == -1 {
        ArrayPush(res, currentData);
      };
      i = i + 1;
    };
    return res;
  }

  public final func GetData(identifier: Int32) -> MenuData {
    let res: MenuData;
    let count: Int32 = ArraySize(this.m_data);
    let i: Int32 = 0;
    while i < count {
      res = this.m_data[i];
      if res.identifier == identifier {
        return res;
      };
      i = i + 1;
    };
    res.identifier = -1;
    return res;
  }

  public final func GetData(fullscreenName: CName) -> MenuData {
    let res: MenuData;
    let count: Int32 = ArraySize(this.m_data);
    let i: Int32 = 0;
    while i < count {
      res = this.m_data[i];
      if Equals(res.fullscreenName, fullscreenName) {
        return res;
      };
      i = i + 1;
    };
    res.identifier = -1;
    return res;
  }
}

public class HubMenuUtility extends IScriptable {

  public final static func IsPlayerHardwareDisabled(player: wref<GameObject>) -> Bool {
    let gameInstance: GameInstance = player.GetGame();
    let questsSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(gameInstance);
    let isDisabled: Bool = Cast<Bool>(questsSystem.GetFact(n"q307_hub_disabled_except_journal"));
    return isDisabled;
  }

  public final static func IsCraftingAvailable(player: wref<PlayerPuppet>) -> Bool {
    let isInComaQuest: Bool = HubMenuUtility.IsPlayerHardwareDisabled(player);
    let psmBlackboard: ref<IBlackboard> = player.GetPlayerStateMachineBlackboard();
    let playerStateID: Int32 = psmBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat);
    let isPlayerInCombat: Bool = playerStateID == 1;
    let hasCraftingRestriction: Bool = StatusEffectSystem.ObjectHasStatusEffectWithTag(player, n"NoCrafting");
    return !isPlayerInCombat && !hasCraftingRestriction && !isInComaQuest;
  }

  public final static func CreateMenuData(player: wref<PlayerPuppet>) -> ref<MenuDataBuilder> {
    let isInComaQuest: Bool = HubMenuUtility.IsPlayerHardwareDisabled(player);
    let gameInstance: GameInstance = player.GetGame();
    let questsSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(gameInstance);
    let isCraftingAvailable: Bool = HubMenuUtility.IsCraftingAvailable(player);
    let isMapAvailable: Bool = Cast<Bool>(questsSystem.GetFact(n"map_blocked")) || !isInComaQuest;
    let isTarotAvailable: Bool = !Cast<Bool>(questsSystem.GetFact(n"q101_done"));
    return MenuDataBuilder.Make().Add(HubMenuItems.Cyberware, HubMenuItems.None, n"cyberware_equip", n"ico_cyberware", n"UI-PanelNames-CYBERWARE", isInComaQuest).Add(HubMenuItems.Inventory, HubMenuItems.None, n"inventory_screen", n"ico_inventory", n"UI-PanelNames-INVENTORY", isInComaQuest).Add(HubMenuItems.Map, HubMenuItems.None, n"world_map", n"ico_map", n"UI-PanelNames-MAP", !isMapAvailable).Add(HubMenuItems.Character, HubMenuItems.None, n"new_perks", n"ico_character", n"UI-PanelNames-CHARACTER", isInComaQuest).Add(HubMenuItems.Journal, HubMenuItems.None, n"quest_log", n"ico_journal", n"UI-PanelNames-JOURNAL").Add(HubMenuItems.Crafting, HubMenuItems.Inventory, n"crafting_main", n"ico_cafting", n"Gameplay-RPG-Skills-CraftingName", !isCraftingAvailable).Add(HubMenuItems.Stats, HubMenuItems.Character, n"temp_stats", n"ico_stats_hub", n"UI-PanelNames-STATS", isInComaQuest).Add(HubMenuItems.Phone, HubMenuItems.Journal, n"phone", n"ico_phone", n"UI-PanelNames-PHONE").Add(HubMenuItems.Tarot, HubMenuItems.Journal, n"tarot_main", n"ico_tarot_hub", n"UI-PanelNames-TAROT", isTarotAvailable).Add(HubMenuItems.Shards, HubMenuItems.Journal, n"shards", n"ico_shards_hub", n"UI-PanelNames-SHARDS", CodexUserData.Make(CodexDataSource.Onscreen)).Add(HubMenuItems.Gallery, HubMenuItems.Journal, n"gallery", n"ico_gallery_hub", n"UI-Gallery-GalleryTitle").Add(HubMenuItems.Backpack, HubMenuItems.Inventory, n"backpack", n"ico_backpack", n"UI-PanelNames-BACKPACK", isInComaQuest).Add(HubMenuItems.Codex, HubMenuItems.Journal, n"codex", n"ico_data", n"UI-PanelNames-CODEX", CodexUserData.Make(CodexDataSource.Codex), isInComaQuest);
  }
}

public class SubmenuDataBuilder extends IScriptable {

  private let m_menuBuilder: ref<MenuDataBuilder>;

  private let m_menuDataIndex: Int32;

  public final static func Make(menuBuilder: ref<MenuDataBuilder>, menuDataIndex: Int32) -> ref<SubmenuDataBuilder> {
    let instance: ref<SubmenuDataBuilder> = new SubmenuDataBuilder();
    instance.m_menuDataIndex = menuDataIndex;
    instance.m_menuBuilder = menuBuilder;
    return instance;
  }

  public final func AddSubmenu(identifier: Int32, fullscreenName: CName, labelKey: CName, opt userData: ref<IScriptable>) -> ref<SubmenuDataBuilder> {
    let data: MenuData;
    data.label = GetLocalizedTextByKey(labelKey);
    data.fullscreenName = fullscreenName;
    data.identifier = identifier;
    data.userData = userData;
    ArrayPush(this.m_menuBuilder.m_data[this.m_menuDataIndex].subMenus, data);
    return this;
  }

  public final func AddSubmenuIf(condition: Bool, identifier: Int32, fullscreenName: CName, labelKey: CName, opt userData: ref<IScriptable>) -> ref<SubmenuDataBuilder> {
    if condition {
      return this.AddSubmenu(identifier, fullscreenName, labelKey, userData);
    };
    return this;
  }

  public final func GetMenuBuilder() -> ref<MenuDataBuilder> {
    return this.m_menuBuilder;
  }
}
