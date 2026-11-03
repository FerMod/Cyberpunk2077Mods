
public class QuestResetPerfomedActionsStorage extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"QuestResetPerfomedActionsStorage";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(n"QuestResetPerfomedActionsStorage", true, n"QuestResetPerfomedActionsStorage", n"QuestResetPerfomedActionsStorage");
  }
}

public class QuestRemoveQuickHacks extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"QuestRemoveQuickHacks";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(n"QuestRemoveQuickHacks", true, n"QuestRemoveQuickHacks", n"QuestRemoveQuickHacks");
  }
}

public class QuestRestoreQuickHacks extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"QuestRestoreQuickHacks";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(n"QuestRestoreQuickHacks", true, n"QuestRestoreQuickHacks", n"QuestRestoreQuickHacks");
  }
}

public class QuestBreachAccessPoint extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"QuestBreachAccessPoint";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(n"QuestBreachAccessPoint", true, n"QuestBreachAccessPoint", n"QuestBreachAccessPoint");
  }
}

public class SpiderbotEnableAccessPoint extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"SpiderbotEnableAccessPoint";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(this.actionName, true, n"SpiderbotEnableAccessPoint", n"SpiderbotEnableAccessPoint");
  }

  public func GetTweakDBChoiceRecord() -> String {
    return "SpiderbotEnableAccessPoint";
  }

  public final static func IsAvailable(device: ref<ScriptableDeviceComponentPS>) -> Bool {
    return true;
  }

  public final static func IsClearanceValid(clearance: ref<Clearance>) -> Bool {
    if Clearance.IsInRange(clearance, 2) {
      return true;
    };
    return false;
  }

  public final static func IsContextValid(const context: script_ref<GetActionsContext>) -> Bool {
    if Equals(Deref(context).requestType, gamedeviceRequestType.Remote) {
      return true;
    };
    return false;
  }
}

public class RevealEnemiesProgram extends ProgramAction {

  public final func SetProperties() -> Void {
    this.actionName = n"RevealEnemiesProgram";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(this.actionName, true, n"LocKey#17840", n"LocKey#17840");
  }
}

public class ResetNetworkBreachState extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"ResetNetworkBreachState";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(this.actionName, true, this.actionName, this.actionName);
  }
}

public class ToggleNetrunnerDive extends ActionBool {

  public let m_skipMinigame: Bool;

  public let m_attempt: Int32;

  public let m_isRemote: Bool;

  public final func SetProperties(terminateDive: Bool, skipMinigame: Bool, attempt: Int32, isRemote: Bool) -> Void {
    this.actionName = n"ToggleNetrunnerDive";
    this.m_skipMinigame = skipMinigame;
    this.m_attempt = attempt;
    this.m_isRemote = isRemote;
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(this.actionName, terminateDive, n"LocKey#17841", n"LocKey#17841");
  }

  public func GetTweakDBChoiceRecord() -> String {
    return "ToggleNetrunnerDive";
  }

  public final const func ShouldTerminate() -> Bool {
    return FromVariant<Bool>(this.prop.first);
  }

  public final static func IsAvailable(device: ref<ScriptableDeviceComponentPS>) -> Bool {
    return device.IsPowered();
  }

  public final static func IsClearanceValid(clearance: ref<Clearance>) -> Bool {
    if Clearance.IsInRange(clearance, 2) {
      return true;
    };
    return false;
  }

  public final static func IsContextValid(const context: script_ref<GetActionsContext>) -> Bool {
    if Equals(Deref(context).requestType, gamedeviceRequestType.Direct) {
      return true;
    };
    return false;
  }
}

public class AccessPointController extends MasterController {

  public const func GetPS() -> ref<AccessPointControllerPS> {
    return this.GetBasePS() as AccessPointControllerPS;
  }
}

public class AccessPointControllerPS extends MasterControllerPS {

  private let m_rewardNotificationIcons: [String];

  private let m_rewardNotificationString: String;

  private inline let m_accessPointSkillChecks: ref<HackingContainer>;

  private persistent let m_isBreached: Bool;

  private persistent let m_moneyAwarded: Bool;

  private edit let m_isVirtual: Bool;

  private let m_pingedSquads: [CName];

  protected cb func OnInstantiated() -> Bool {
    super.OnInstantiated();
    if !IsStringValid(this.m_deviceName) {
      this.m_deviceName = "LocKey#138";
    };
  }

  protected func GetSkillCheckContainerForSetup() -> ref<BaseSkillCheckContainer> {
    return this.m_accessPointSkillChecks;
  }

  protected func GameAttached() -> Void;

  public final const func IsVirtual() -> Bool {
    return this.m_isVirtual;
  }

  public final const func HasNetworkBackdoor() -> Bool {
    if EnumInt(this.GetDeviceState()) <= -1 {
      return false;
    };
    return true;
  }

  public const func GetMinigameDefinition() -> TweakDBID {
    return this.m_minigameDefinition;
  }

  public const func GetBackdoorAccessPoint() -> ref<AccessPointControllerPS> {
    let masterAP: ref<AccessPointControllerPS> = super.GetBackdoorAccessPoint();
    if IsDefined(masterAP) {
      return masterAP;
    };
    return this;
  }

  public final const func GetDevicesThatPlayerCanBreach() -> [ref<ScriptableDeviceComponentPS>] {
    let breachableDevices: array<ref<ScriptableDeviceComponentPS>>;
    let children: array<ref<DeviceComponentPS>>;
    let currentDevice: ref<ScriptableDeviceComponentPS>;
    let i: Int32;
    this.GetChildren(children);
    i = 0;
    while i < ArraySize(children) {
      if IsDefined(children[i] as ScriptableDeviceComponentPS) {
        currentDevice = children[i] as ScriptableDeviceComponentPS;
        if currentDevice.ShouldRevealNetworkGrid() {
          ArrayPush(breachableDevices, currentDevice);
        };
      };
      i += 1;
    };
    return breachableDevices;
  }

  public final const func IsAccessPointOf(slaveToCheck: PersistentID) -> Bool {
    let children: array<ref<DeviceComponentPS>>;
    let i: Int32;
    let k: Int32;
    let singleSlaveChildren: array<ref<DeviceComponentPS>>;
    let slaveAPs: array<ref<DeviceComponentPS>>;
    this.GetChildren(children);
    i = 0;
    while i < ArraySize(children) {
      if Equals(children[i].GetID(), slaveToCheck) {
        return true;
      };
      if IsDefined(children[i] as AccessPointControllerPS) {
        ArrayPush(slaveAPs, children[i]);
      };
      i += 1;
    };
    i = 0;
    while i < ArraySize(slaveAPs) {
      slaveAPs[i].GetChildren(singleSlaveChildren);
      k = 0;
      while k < ArraySize(singleSlaveChildren) {
        if Equals(singleSlaveChildren[k].GetID(), slaveToCheck) {
          return true;
        };
        k += 1;
      };
      i += 1;
    };
    return false;
  }

  public const func IsConnectedToBackdoorDevice() -> Bool {
    return true;
  }

  public const func ShouldRevealNetworkGrid() -> Bool {
    if this.m_isVirtual {
      return false;
    };
    return this.HasNetworkBackdoor();
  }

  public const func IsMainframe() -> Bool {
    let children: array<ref<DeviceComponentPS>>;
    let i: Int32;
    let parents: array<ref<DeviceComponentPS>>;
    this.GetParents(parents);
    this.GetChildren(children);
    i = 0;
    while i < ArraySize(parents) {
      if IsDefined(parents[i] as AccessPointControllerPS) {
        return false;
      };
      i += 1;
    };
    i = 0;
    while i < ArraySize(children) {
      if IsDefined(children[i] as AccessPointControllerPS) {
        return true;
      };
      i += 1;
    };
    return true;
  }

  protected const func GetClearance() -> ref<Clearance> {
    return Clearance.CreateClearance(1, 9);
  }

  private final func SetIsBreached(isBreached: Bool) -> Void {
    this.m_isBreached = isBreached;
    this.ExposeQuickHacks(isBreached);
  }

  public const func GetNetworkName() -> String {
    let networkName: String = this.GetDeviceName();
    if IsStringValid(networkName) {
      return networkName;
    };
    return "LOCAL NETWORK";
  }

  public const func GetNetworkSizeCount() -> Int32 {
    let slaves: array<ref<DeviceComponentPS>>;
    this.GetChildren(slaves);
    return ArraySize(slaves);
  }

  public final const quest func IsNetworkBreached() -> Bool {
    return this.m_isBreached;
  }

  public const quest func IsBreached() -> Bool {
    return this.m_isBreached || this.WasHackingMinigameSucceeded();
  }

  public final func BreachConnectedDevices() -> Void {
    this.RefreshSlaves_Event();
  }

  protected final func ActionSpiderbotEnableAccessPoint() -> ref<SpiderbotEnableAccessPoint> {
    let action: ref<SpiderbotEnableAccessPoint> = new SpiderbotEnableAccessPoint();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    action.CreateInteraction();
    return action;
  }

  protected final func ActionRevealEnemiesProgram() -> ref<RevealEnemiesProgram> {
    let action: ref<RevealEnemiesProgram> = new RevealEnemiesProgram();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  public final func OnRevealEnemiesProgram(evt: ref<RevealEnemiesProgram>) -> EntityNotificationType {
    this.SendActionToAllSlaves(evt);
    return EntityNotificationType.DoNotNotifyEntity;
  }

  private final func RefreshSlaves(const devices: script_ref<[ref<DeviceComponentPS>]>) -> Void {
    let baseMoney: Float;
    let baseShardDropChance: Float;
    let craftingMaterial: Bool;
    let i: Int32;
    let lootAllAdvancedID: TweakDBID;
    let lootAllID: TweakDBID;
    let lootAllMasterID: TweakDBID;
    let lootQ003: TweakDBID;
    let markForErase: Bool;
    let shouldLoot: Bool;
    let TS: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGameInstance());
    let minigameBB: ref<IBlackboard> = GameInstance.GetBlackboardSystem(this.GetGameInstance()).Get(GetAllBlackboardDefs().HackingMinigame);
    let minigamePrograms: array<TweakDBID> = FromVariant<array<TweakDBID>>(minigameBB.GetVariant(GetAllBlackboardDefs().HackingMinigame.ActivePrograms));
    this.CheckMasterRunnerAchievement(ArraySize(minigamePrograms));
    this.FilterRedundantPrograms(minigamePrograms);
    lootQ003 = t"MinigameAction.NetworkLootQ003";
    lootAllID = t"MinigameAction.NetworkDataMineLootAll";
    lootAllAdvancedID = t"MinigameAction.NetworkDataMineLootAllAdvanced";
    lootAllMasterID = t"MinigameAction.NetworkDataMineLootAllMaster";
    baseMoney = 0.00;
    craftingMaterial = false;
    baseShardDropChance = 0.00;
    i = ArraySize(minigamePrograms) - 1;
    while i >= 0 {
      if minigamePrograms[i] == t"minigame_v2.FindAnna" {
        AddFact(this.GetPlayerMainObject().GetGame(), n"Kab08Minigame_program_uploaded");
      } else {
        if minigamePrograms[i] == lootQ003 {
          TS.GiveItemByItemQuery(this.GetPlayerMainObject(), t"Query.Q003CyberdeckProgram");
        } else {
          if minigamePrograms[i] == lootAllID || minigamePrograms[i] == lootAllAdvancedID || minigamePrograms[i] == lootAllMasterID {
            if minigamePrograms[i] == lootAllID {
              baseMoney += 1.00;
            } else {
              if minigamePrograms[i] == lootAllAdvancedID {
                baseMoney += 1.00;
                craftingMaterial = true;
              } else {
                if minigamePrograms[i] == lootAllMasterID {
                  baseShardDropChance += 1.00;
                };
              };
            };
            shouldLoot = true;
            markForErase = true;
          };
        };
      };
      i -= 1;
    };
    if markForErase {
      ArrayErase(minigamePrograms, i);
      minigameBB.SetVariant(GetAllBlackboardDefs().HackingMinigame.ActivePrograms, ToVariant(minigamePrograms));
    };
    if shouldLoot {
      this.ProcessLoot(baseMoney, craftingMaterial, baseShardDropChance, TS);
    };
    this.ProcessMinigameNetworkActions(this);
    i = 0;
    while i < ArraySize(Deref(devices)) {
      this.QueuePSEvent(Deref(devices)[i], this.ActionSetExposeQuickHacks());
      this.ProcessMinigameNetworkActions(Deref(devices)[i]);
      i += 1;
    };
    if baseMoney >= 1.00 && this.ShouldRewardMoney() {
      this.RewardMoney(baseMoney);
    };
    RPGManager.GiveReward(this.GetGameInstance(), t"RPGActionRewards.Hacking", Cast<StatsObjectID>(this.GetMyEntityID()));
  }

  private final func FilterRedundantPrograms(programs: script_ref<[TweakDBID]>) -> Void {
    if ArrayContains(Deref(programs), t"MinigameAction.NetworkTurretShutdown") && ArrayContains(Deref(programs), t"MinigameAction.NetworkTurretFriendly") {
      ArrayRemove(Deref(programs), t"MinigameAction.NetworkTurretShutdown");
    };
  }

  private final func ProcessLoot(baseMoney: Float, craftingMaterial: Bool, baseShardDropChance: Float, TS: ref<TransactionSystem>) -> Void {
    let playerLevel: Float;
    this.CleanRewardNotification();
    playerLevel = GameInstance.GetStatsSystem(this.GetGameInstance()).GetStatValue(Cast<StatsObjectID>(this.GetPlayerMainObject().GetEntityID()), gamedataStatType.Level);
    if baseShardDropChance > 0.00 {
      this.GetQuickhackReward(playerLevel, TS);
    };
    if craftingMaterial {
      this.GenerateMaterialDrops(playerLevel, TS);
    };
    this.ShowRewardNotification();
  }

  private final func GetQuickhackReward(playerLevel: Float, TS: ref<TransactionSystem>) -> Void {
    let dataTrackingEvent: ref<UpdateShardFailedDropsRequest>;
    let dataTrackingSystem: ref<DataTrackingSystem>;
    let failedattempbonus: Float;
    let hacksPlayerMissing: array<TweakDBID>;
    let hacksPool: array<TweakDBID>;
    let hacksToGet: array<TweakDBID>;
    let i: Int32;
    let legendaryPlusPlusAwarded: ref<FirstPlusPlusLegendaryAwardedRequest>;
    let playerHacksTweak: array<TweakDBID>;
    let quality: gamedataQuality;
    let randomHack: Int32;
    let recipeItem: ref<ItemRecipe_Record>;
    let recipeResult: TweakDBID;
    let recipes: array<TweakDBID>;
    let recipesPlayerMissing: array<TweakDBID>;
    let tweakID: TweakDBID;
    let craftingSystem: ref<CraftingSystem> = CraftingSystem.GetInstance(this.GetGameInstance());
    let playerCraftBook: ref<CraftBook> = craftingSystem.GetPlayerCraftBook();
    let debugForceBonus: Bool = false;
    let getBonusReward: Float = RandRangeF(0.00, 1.00);
    let difficulty: Float = Cast<Float>(EnumInt(this.m_accessPointSkillChecks.GetHackingSlot().GetDifficulty()));
    getBonusReward = getBonusReward + difficulty * 0.05;
    if debugForceBonus {
      getBonusReward = 1.00;
    };
    if playerLevel < 3.00 {
      getBonusReward = 0.80;
    };
    if playerLevel >= 3.00 && playerLevel < 14.00 {
      recipes = TDB.GetForeignKeyArray(t"Items.AllUncommonProgramsRecipes.recipes");
    } else {
      if playerLevel >= 14.00 && playerLevel < 22.00 {
        recipes = TDB.GetForeignKeyArray(t"Items.AllRareProgramsRecipes.recipes");
      } else {
        if playerLevel >= 22.00 && playerLevel < 30.00 {
          recipes = TDB.GetForeignKeyArray(t"Items.AllEpicProgramsRecipes.recipes");
        } else {
          if playerLevel >= 30.00 {
            recipes = TDB.GetForeignKeyArray(t"Items.AllLegendaryProgramsRecipes.recipes");
          };
        };
      };
    };
    if playerLevel < 8.00 {
      hacksPool = TDB.GetForeignKeyArray(t"Items.AllCommonPrograms.programs");
      quality = gamedataQuality.Common;
    };
    if playerLevel >= 8.00 && playerLevel < 16.00 {
      hacksPool = TDB.GetForeignKeyArray(t"Items.AllUncommonPrograms.programs");
      quality = gamedataQuality.Uncommon;
    } else {
      if playerLevel >= 16.00 && playerLevel < 24.00 {
        hacksPool = TDB.GetForeignKeyArray(t"Items.AllRarePrograms.programs");
        quality = gamedataQuality.Rare;
      } else {
        if playerLevel >= 24.00 && playerLevel < 32.00 {
          hacksPool = TDB.GetForeignKeyArray(t"Items.AllEpicPrograms.programs");
          quality = gamedataQuality.Epic;
        } else {
          if playerLevel >= 32.00 {
            hacksPool = TDB.GetForeignKeyArray(t"Items.AllLegendaryPrograms.programs");
            quality = gamedataQuality.Legendary;
          };
        };
      };
    };
    if playerLevel >= 51.00 {
      dataTrackingSystem = GameInstance.GetScriptableSystemsContainer(this.GetPlayerMainObject().GetGame()).Get(n"DataTrackingSystem") as DataTrackingSystem;
      if !dataTrackingSystem.IsFirstPlusPlusLegendaryAwarded() {
        legendaryPlusPlusAwarded = new FirstPlusPlusLegendaryAwardedRequest();
        GameInstance.GetScriptableSystemsContainer(this.GetPlayerMainObject().GetGame()).Get(n"DataTrackingSystem").QueueRequest(legendaryPlusPlusAwarded);
        getBonusReward = 1.00;
      } else {
        failedattempbonus = dataTrackingSystem.GetFailedShardDrops() * 0.10;
        getBonusReward += failedattempbonus;
      };
      if getBonusReward >= 0.95 {
        recipes = TDB.GetForeignKeyArray(t"Items.AllLegendaryPlusPlusProgramsRecipes.recipes");
        if getBonusReward >= 0.99 {
          quality = gamedataQuality.LegendaryPlusPlus;
          hacksPool = TDB.GetForeignKeyArray(t"Items.AllLegendaryPlusPlusPrograms.programs");
          getBonusReward = 0.80;
        } else {
          getBonusReward = 0.00;
        };
        dataTrackingEvent.resetCounter = true;
      } else {
        dataTrackingEvent = new UpdateShardFailedDropsRequest();
        dataTrackingEvent.newFailedAttempts = 1.00;
      };
      GameInstance.GetScriptableSystemsContainer(this.GetPlayerMainObject().GetGame()).Get(n"DataTrackingSystem").QueueRequest(dataTrackingEvent);
    };
    hacksPlayerMissing = this.GetPlayersUniqueHacks(TS, hacksPool, quality, playerHacksTweak);
    i = 0;
    while i < ArraySize(recipes) {
      if !craftingSystem.IsRecipeKnown(recipes[i], playerCraftBook) {
        ArrayPush(recipesPlayerMissing, recipes[i]);
      };
      i += 1;
    };
    if getBonusReward <= 0.90 {
      if ArraySize(recipesPlayerMissing) > 0 {
        if ArraySize(recipesPlayerMissing) - 1 > 0 {
          i = 0;
          while i < ArraySize(recipesPlayerMissing) {
            recipeItem = TweakDBInterface.GetItemRecipeRecord(recipesPlayerMissing[i]);
            recipeResult = recipeItem.CraftingResult().ItemHandle().GetID();
            if !ArrayContains(playerHacksTweak, recipeResult) {
              tweakID = recipesPlayerMissing[i];
              break;
            };
            i += 1;
          };
          if !TDBID.IsValid(tweakID) {
            tweakID = recipesPlayerMissing[RandRange(0, ArraySize(recipesPlayerMissing) - 1)];
          };
        } else {
          tweakID = recipesPlayerMissing[0];
        };
        this.AddHackReward(TS, tweakID, 1u);
        getBonusReward = 0.00;
        return;
      };
    };
    if getBonusReward >= 0.95 && ArraySize(recipesPlayerMissing) == 0 {
      if ArraySize(hacksPlayerMissing) == 0 {
        i = 0;
        while i < 2 {
          randomHack = RandRange(0, ArraySize(hacksPool) - 1);
          tweakID = hacksPool[i];
          ArrayPush(hacksToGet, tweakID);
          i += 1;
        };
      } else {
        if ArraySize(hacksPlayerMissing) == 1 {
          tweakID = hacksPlayerMissing[i];
          ArrayPush(hacksToGet, tweakID);
          randomHack = RandRange(0, ArraySize(hacksPool) - 1);
          tweakID = hacksPool[randomHack];
          ArrayPush(hacksToGet, tweakID);
        } else {
          if ArraySize(hacksPlayerMissing) >= 2 {
            randomHack = RandRange(0, ArraySize(hacksPlayerMissing) - 1);
            tweakID = hacksPlayerMissing[randomHack];
            ArrayPush(hacksToGet, tweakID);
            ArrayRemove(hacksPlayerMissing, tweakID);
            if ArraySize(hacksPlayerMissing) == 1 {
              tweakID = hacksPlayerMissing[0];
            } else {
              randomHack = RandRange(0, ArraySize(hacksPlayerMissing) - 1);
              tweakID = hacksPlayerMissing[randomHack];
            };
            ArrayPush(hacksToGet, tweakID);
          };
        };
      };
    } else {
      if ArraySize(hacksPlayerMissing) == 0 {
        randomHack = RandRange(0, ArraySize(hacksPool) - 1);
        tweakID = hacksPool[randomHack];
      } else {
        if ArraySize(hacksPlayerMissing) == 1 {
          tweakID = hacksPlayerMissing[0];
        } else {
          randomHack = RandRange(0, ArraySize(hacksPlayerMissing) - 1);
          tweakID = hacksPlayerMissing[randomHack];
        };
      };
      ArrayPush(hacksToGet, tweakID);
    };
    i = 0;
    while i < ArraySize(hacksToGet) {
      this.AddHackReward(TS, hacksToGet[i], 1u);
      i += 1;
    };
  }

  private final const func GetPlayersUniqueHacks(TS: ref<TransactionSystem>, hacksPool: [TweakDBID], quality: gamedataQuality, out playerHacksTweak: [TweakDBID]) -> [TweakDBID] {
    let hackID: ItemID;
    let hackQuality: gamedataQuality;
    let hacksPlayerMissing: array<TweakDBID>;
    let i: Int32;
    let playersHacks: array<wref<gameItemData>>;
    let tweakID: TweakDBID;
    let player: ref<PlayerPuppet> = this.GetPlayerMainObject() as PlayerPuppet;
    playerHacksTweak = PlayerPuppet.GetPlayerQuickHackInCyberDeckTweakDBID(player, quality);
    TS.GetItemListByTag(player, n"SoftwareShard", playersHacks);
    i = 0;
    while i < ArraySize(playersHacks) {
      hackID = playersHacks[i].GetID();
      tweakID = ItemID.GetTDBID(hackID);
      hackQuality = TweakDBInterface.GetItemRecord(tweakID).Quality().Type();
      if Equals(quality, gamedataQuality.LegendaryPlusPlus) {
        if Equals(hackQuality, gamedataQuality.Legendary) && RPGManager.IsItemIconic(RPGManager.GetItemData(player.GetGame(), player, hackID)) {
          ArrayPush(playerHacksTweak, tweakID);
        };
      } else {
        if Equals(hackQuality, quality) {
          ArrayPush(playerHacksTweak, tweakID);
        };
      };
      i += 1;
    };
    i = 0;
    while i < ArraySize(playerHacksTweak) {
      if ArrayCount(playerHacksTweak, playerHacksTweak[i]) > 1 {
        ArrayRemove(playerHacksTweak, playerHacksTweak[i]);
      };
      i += 1;
    };
    if ArraySize(playerHacksTweak) < ArraySize(hacksPool) {
      i = 0;
      while i < ArraySize(hacksPool) {
        if !ArrayContains(playerHacksTweak, hacksPool[i]) {
          ArrayPush(hacksPlayerMissing, hacksPool[i]);
        };
        i += 1;
      };
    };
    return hacksPlayerMissing;
  }

  private final const func WasMoneyAwarded() -> Bool {
    return this.m_moneyAwarded;
  }

  private final const func ShouldRewardMoney() -> Bool {
    let master: ref<AccessPointControllerPS>;
    let shouldRewardMoney: Bool;
    if this.IsMainframe() {
      shouldRewardMoney = !this.WasMoneyAwarded();
    } else {
      master = this.GetBackdoorAccessPoint();
      if IsDefined(master) {
        shouldRewardMoney = !master.WasMoneyAwarded();
      };
    };
    return shouldRewardMoney;
  }

  private final func RewardMoney(baseMoney: Float) -> Void {
    let deckQuality: gamedataQuality;
    let moneyModifier: Float;
    let moneyReward: Float;
    let relevantAP: ref<AccessPointControllerPS>;
    let player: ref<PlayerPuppet> = this.GetPlayerMainObject() as PlayerPuppet;
    let systemReplacementID: ItemID = EquipmentSystem.GetData(player).GetActiveItem(gamedataEquipmentArea.SystemReplacementCW);
    if EquipmentSystem.IsCyberdeckEquipped(player) {
      deckQuality = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(systemReplacementID)).Quality().Type();
    };
    moneyModifier = Cast<Float>(EnumInt(this.m_accessPointSkillChecks.GetHackingSlot().GetDifficulty())) * 0.03 + baseMoney;
    switch deckQuality {
      case gamedataQuality.Common:
        moneyReward = 100.00;
        break;
      case gamedataQuality.CommonPlus:
        moneyReward = 150.00;
        break;
      case gamedataQuality.Uncommon:
        moneyReward = 250.00;
        break;
      case gamedataQuality.UncommonPlus:
        moneyReward = 350.00;
        break;
      case gamedataQuality.Rare:
        moneyReward = 500.00;
        break;
      case gamedataQuality.RarePlus:
        moneyReward = 800.00;
        break;
      case gamedataQuality.Epic:
        moneyReward = 1200.00;
        break;
      case gamedataQuality.EpicPlus:
        moneyReward = 1500.00;
        break;
      case gamedataQuality.Legendary:
        moneyReward = 2000.00;
        break;
      case gamedataQuality.LegendaryPlusPlus:
        moneyReward = 2500.00;
        break;
      default:
        moneyReward = 100.00;
    };
    if RPGManager.IsItemIconic(RPGManager.GetItemData(player.GetGame(), player, systemReplacementID)) {
      moneyReward *= 1.05;
    };
    GameInstance.GetTransactionSystem(player.GetGame()).GiveMoney(this.GetPlayerMainObject(), Cast<Int32>(moneyReward * moneyModifier), n"money");
    relevantAP = this.GetBackdoorAccessPoint();
    this.QueuePSEvent(relevantAP, new NetworkMoneySiphoned());
  }

  private final func OnNetworkMoneySiphoned(evt: ref<NetworkMoneySiphoned>) -> EntityNotificationType {
    this.m_moneyAwarded = true;
    return EntityNotificationType.DoNotNotifyEntity;
  }

  private final func GenerateMaterialDrops(playerLevel: Float, TS: ref<TransactionSystem>) -> Void {
    let materialsAmmountEpic: Int32;
    let materialsAmmountLeg: Int32;
    let materialsAmmountUnc: Int32;
    let materialsAmmountRare: Int32 = materialsAmmountEpic = materialsAmmountLeg = 0;
    let materialsMultiplier: Int32 = EnumInt(this.m_accessPointSkillChecks.GetHackingSlot().GetDifficulty());
    if materialsMultiplier == 0 {
      materialsMultiplier = 1;
    };
    if playerLevel < 14.00 {
      materialsAmmountUnc = 15;
    } else {
      if playerLevel >= 14.00 && playerLevel < 22.00 {
        materialsAmmountUnc = 20;
        materialsAmmountRare = 5;
      } else {
        if playerLevel >= 22.00 && playerLevel < 32.00 {
          materialsAmmountUnc = 25;
          materialsAmmountRare = 10;
          materialsAmmountEpic = 4;
        } else {
          if playerLevel >= 32.00 && playerLevel < 37.00 {
            materialsAmmountUnc = 25;
            materialsAmmountRare = 15;
            materialsAmmountEpic = 8;
            materialsAmmountLeg = 1;
          } else {
            if playerLevel >= 37.00 {
              materialsAmmountUnc = 30;
              materialsAmmountRare = 20;
              materialsAmmountEpic = 10;
              materialsAmmountLeg = 2;
            };
          };
        };
      };
    };
    materialsAmmountUnc = RandRange(materialsAmmountUnc, materialsAmmountUnc + materialsMultiplier + 2);
    this.AddReward(TS, t"Query.QuickHackUncommonMaterial", Cast<Uint32>(materialsAmmountUnc));
    if materialsAmmountRare > 0 {
      materialsAmmountRare = RandRange(materialsAmmountRare, materialsAmmountRare + materialsMultiplier);
      this.AddReward(TS, t"Query.QuickHackRareMaterial", Cast<Uint32>(materialsAmmountRare));
    };
    if materialsAmmountEpic > 0 {
      materialsAmmountEpic = RandRange(materialsAmmountEpic, materialsAmmountEpic + materialsMultiplier);
      this.AddReward(TS, t"Query.QuickHackEpicMaterial", Cast<Uint32>(materialsAmmountEpic));
    };
    if materialsAmmountLeg > 0 {
      materialsAmmountLeg = RandRange(materialsAmmountLeg, materialsAmmountLeg);
      this.AddReward(TS, t"Query.QuickHackLegendaryMaterial", Cast<Uint32>(materialsAmmountLeg));
    };
  }

  private final func AddReward(TS: ref<TransactionSystem>, itemQueryTDBID: TweakDBID, opt amount: Uint32) -> Void {
    let iconName: String;
    let iconsNameResolver: ref<IconsNameResolver>;
    let itemRecord: ref<Item_Record>;
    let itemRecordID: TweakDBID;
    let itemTypeRecordName: CName;
    if amount > 0u {
      itemTypeRecordName = TweakDBInterface.GetItemQueryRecord(itemQueryTDBID).RecordType();
      itemRecordID = TDBID.Create(NameToString(itemTypeRecordName));
      itemRecord = TweakDBInterface.GetItemRecord(itemRecordID);
      iconsNameResolver = IconsNameResolver.GetIconsNameResolver();
      iconName = itemRecord.IconPath();
      if !IsStringValid(iconName) {
        iconName = NameToString(iconsNameResolver.TranslateItemToIconName(itemRecordID, true));
      };
      if NotEquals(iconName, "None") && NotEquals(iconName, "") {
        ArrayPush(this.m_rewardNotificationIcons, iconName);
      };
      this.m_rewardNotificationString += Cast<Int32>(amount) + " " + GetLocalizedTextByKey(itemRecord.DisplayName());
      if StrLen(this.m_rewardNotificationString) > 0 {
        this.m_rewardNotificationString += "\\n";
      };
      TS.GiveItemByItemQuery(this.GetPlayerMainObject(), itemQueryTDBID, amount, 18446744073709551615u, "minigame");
    };
  }

  private final func AddHackReward(TS: ref<TransactionSystem>, itemTweakID: TweakDBID, opt amount: Uint32) -> Void {
    let itemRecord: ref<Item_Record>;
    if amount > 0u {
      itemRecord = TweakDBInterface.GetItemRecord(itemTweakID);
      if itemRecord.TagsContains(n"Recipe") {
        this.m_rewardNotificationString += GetLocalizedText("LocKey#49392") + " ";
      } else {
        if itemRecord.TagsContains(n"SoftwareShard") {
          this.m_rewardNotificationString += GetLocalizedText("LocKey#46554") + " ";
        };
      };
      this.m_rewardNotificationString += GetLocalizedTextByKey(itemRecord.DisplayName());
      if StrLen(this.m_rewardNotificationString) > 0 {
        this.m_rewardNotificationString += "\\n";
      };
      TS.GiveItemByTDBID(this.GetPlayerMainObject(), itemTweakID, 1);
    };
  }

  private final func CleanRewardNotification() -> Void {
    this.m_rewardNotificationString = "";
    ArrayClear(this.m_rewardNotificationIcons);
  }

  private final func ShowRewardNotification() -> Void {
    let notificationEvent: ref<HackingRewardNotificationEvent>;
    let uiSystem: ref<UISystem>;
    if StrLen(this.m_rewardNotificationString) > 0 {
      uiSystem = GameInstance.GetUISystem(this.GetGameInstance());
      notificationEvent = new HackingRewardNotificationEvent();
      notificationEvent.m_text = this.m_rewardNotificationString;
      notificationEvent.m_icons = this.m_rewardNotificationIcons;
      uiSystem.QueueEvent(notificationEvent);
    };
  }

  private final func ProcessMinigameNetworkActions(device: ref<DeviceComponentPS>) -> Void {
    let actionName: CName;
    let context: GetActionsContext;
    let i: Int32;
    let networkAction: ref<ScriptableDeviceAction>;
    let setDetectionEvent: ref<SetDetectionMultiplier>;
    let slaveClass: CName;
    let targetClass: CName;
    let TS: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGameInstance());
    let minigameBB: ref<IBlackboard> = GameInstance.GetBlackboardSystem(this.GetGameInstance()).Get(GetAllBlackboardDefs().HackingMinigame);
    let minigamePrograms: array<TweakDBID> = FromVariant<array<TweakDBID>>(minigameBB.GetVariant(GetAllBlackboardDefs().HackingMinigame.ActivePrograms));
    let activeTraps: array<TweakDBID> = FromVariant<array<TweakDBID>>(minigameBB.GetVariant(GetAllBlackboardDefs().HackingMinigame.ActiveTraps));
    this.FilterRedundantPrograms(minigamePrograms);
    if IsDefined(minigameBB) {
      context.requestType = gamedeviceRequestType.Remote;
      i = 0;
      while i < ArraySize(activeTraps) {
        if activeTraps[i] == t"MinigameTraps.MaterialBonus" {
          TS.GiveItemByItemQuery(this.GetPlayerMainObject(), t"Query.QuickHackMaterial", 1u);
        } else {
          if activeTraps[i] == t"MinigameTraps.IncreaseAwareness" {
            setDetectionEvent = new SetDetectionMultiplier();
            setDetectionEvent.multiplier = 10.00;
            (GameInstance.FindEntityByID(this.GetGameInstance(), PersistentID.ExtractEntityID(device.GetID())) as SensorDevice).QueueEvent(setDetectionEvent);
          };
        };
        i += 1;
      };
      i = 0;
      while i < ArraySize(minigamePrograms) {
        actionName = TweakDBInterface.GetObjectActionRecord(minigamePrograms[i]).ActionName();
        targetClass = TweakDBInterface.GetCName(minigamePrograms[i] + t".targetClass", n"None");
        slaveClass = device.GetClassName();
        if Equals(targetClass, slaveClass) || Equals(targetClass, n"None") {
          networkAction = (device as ScriptableDeviceComponentPS).GetMinigameActionByName(actionName, context) as ScriptableDeviceAction;
          if !IsDefined(networkAction) {
            networkAction = new PuppetAction();
            networkAction.SetUp(device);
          };
          networkAction.RegisterAsRequester(PersistentID.ExtractEntityID(device.GetID()));
          networkAction.SetExecutor(GetPlayer(this.GetGameInstance()));
          networkAction.SetObjectActionID(minigamePrograms[i]);
          networkAction.ProcessRPGAction(this.GetGameInstance());
        };
        i += 1;
      };
    };
  }

  private final func ExtractActions() -> [ref<DeviceAction>] {
    let extractedActions: array<ref<DeviceAction>>;
    ArrayPush(extractedActions, this.GetActionByName(n"ToggleNetrunnerDive"));
    (extractedActions[0] as ScriptableDeviceAction).RegisterAsRequester(PersistentID.ExtractEntityID(this.GetID()));
    return extractedActions;
  }

  public func GetQuestActionByName(actionName: CName) -> ref<DeviceAction> {
    let action: ref<DeviceAction> = super.GetQuestActionByName(actionName);
    if action == null {
      switch actionName {
        case n"QuestBreachAccessPoint":
          action = this.ActionQuestBreachAccessPoint();
          break;
        case n"ResetNetworkBreachState":
          action = this.ActionResetNetworkBreachState();
      };
    };
    return action;
  }

  protected func GetQuestActions(out outActions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    super.GetQuestActions(outActions, context);
    ArrayPush(outActions, this.ActionQuestBreachAccessPoint());
    ArrayPush(outActions, this.ActionResetNetworkBreachState());
  }

  protected final func ActionResetNetworkBreachState() -> ref<ResetNetworkBreachState> {
    let action: ref<ResetNetworkBreachState> = new ResetNetworkBreachState();
    action.SetUp(this);
    action.SetProperties();
    action.AddDeviceName(this.m_deviceName);
    return action;
  }

  public final func OnResetNetworkBreachState(evt: ref<ResetNetworkBreachState>) -> EntityNotificationType {
    this.SetIsBreached(false);
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected const func CanCreateAnyQuickHackActions() -> Bool {
    return false;
  }

  protected func CanCreateAnySpiderbotActions() -> Bool {
    return false;
  }

  public func FinalizeNetrunnerDive(state: HackingMinigameState) -> Void {
    super.FinalizeNetrunnerDive(state);
    if Equals(state, HackingMinigameState.Failed) {
      this.SendMinigameFailedToAllNPCs();
    };
  }

  public final func OnNPCBreachEvent(evt: ref<NPCBreachEvent>) -> EntityNotificationType {
    if Equals(evt.state, HackingMinigameState.Succeeded) {
      this.SetIsBreached(true);
      this.RefreshSlaves_Event();
    } else {
      if Equals(evt.state, HackingMinigameState.Failed) {
        this.m_minigameAttempt += 1;
        this.SendMinigameFailedToAllNPCs();
      };
    };
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected const func ResolveDive(isRemote: Bool) -> Void {
    super.ResolveDive(isRemote);
  }

  private final const func SendMinigameFailedToAllNPCs() -> Void {
    let evt: ref<MinigameFailEvent> = new MinigameFailEvent();
    let puppets: array<ref<PuppetDeviceLinkPS>> = this.GetPuppets();
    let i: Int32 = 0;
    while i < ArraySize(puppets) {
      this.GetPersistencySystem().QueueEntityEvent(PersistentID.ExtractEntityID(puppets[i].GetID()), evt);
      i += 1;
    };
  }

  public func OnSetExposeQuickHacks(evt: ref<SetExposeQuickHacks>) -> EntityNotificationType {
    if evt.isRemote {
      this.SetIsBreached(true);
    };
    this.RefreshSlaves_Event();
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected final func OnValidate(evt: ref<Validate>) -> EntityNotificationType {
    let slaves: array<ref<DeviceComponentPS>> = this.GetImmediateSlaves();
    let i: Int32 = 0;
    while i < ArraySize(slaves) {
      if !(slaves[i] as ScriptableDeviceComponentPS).IsQuickHacksExposed() {
        return EntityNotificationType.DoNotNotifyEntity;
      };
      i += 1;
    };
    this.SetIsBreached(true);
    this.m_skillCheckContainer.GetHackingSlot().SetIsActive(false);
    this.m_skillCheckContainer.GetHackingSlot().SetIsPassed(true);
    this.m_skillCheckContainer.GetHackingSlot().CheckPerformed();
    return EntityNotificationType.SendThisEventToEntity;
  }

  public func OnQuestRemoveQuickHacks(evt: ref<QuestRemoveQuickHacks>) -> EntityNotificationType {
    this.SetIsBreached(false);
    this.SendActionToAllSlaves(evt);
    return EntityNotificationType.SendPSChangedEventToEntity;
  }

  public func OnQuestBreachAccessPoint(evt: ref<QuestBreachAccessPoint>) -> EntityNotificationType {
    this.ExecutePSAction(this.ActionSetExposeQuickHacks());
    this.m_skillCheckContainer.GetHackingSlot().SetIsActive(false);
    this.m_skillCheckContainer.GetHackingSlot().SetIsPassed(true);
    this.m_skillCheckContainer.GetHackingSlot().CheckPerformed();
    this.TurnAuthorizationModuleOFF();
    this.UseNotifier(evt);
    if !IsFinal() {
    };
    return EntityNotificationType.DoNotNotifyEntity;
  }

  public final func OnSpiderbotEnableAccessPoint(evt: ref<SpiderbotEnableAccessPoint>) -> EntityNotificationType {
    this.m_isBreached = true;
    this.m_hasPersonalLinkSlot = false;
    this.m_skillCheckContainer.GetHackingSlot().SetIsActive(false);
    this.m_skillCheckContainer.GetHackingSlot().SetIsPassed(true);
    this.m_skillCheckContainer.GetHackingSlot().CheckPerformed();
    this.TurnAuthorizationModuleOFF();
    this.UseNotifier(evt);
    if !IsFinal() {
    };
    return EntityNotificationType.SendThisEventToEntity;
  }

  public final func DebugBreachConnectedDevices() -> Void {
    this.RefreshSlaves_Event(false, true);
  }

  public final func OnBreachAccessPointEvent(evt: ref<BreachAccessPointEvent>) -> EntityNotificationType {
    this.SetIsBreached(true);
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected func OnRefreshSlavesEvent(evt: ref<RefreshSlavesEvent>) -> EntityNotificationType {
    if this.IsON() || evt.force {
      this.RefreshSlaves(evt.devices);
    };
    return EntityNotificationType.DoNotNotifyEntity;
  }

  private final const func GetCommunityProxies() -> [ref<CommunityProxyPS>] {
    let proxies: array<ref<CommunityProxyPS>>;
    let slaves: array<ref<DeviceComponentPS>> = this.GetImmediateSlaves();
    let i: Int32 = 0;
    while i < ArraySize(slaves) {
      if IsDefined(slaves[i] as CommunityProxyPS) {
        ArrayPush(proxies, slaves[i] as CommunityProxyPS);
      };
      i += 1;
    };
    return proxies;
  }

  protected const func GetNetworkArea() -> wref<NetworkAreaControllerPS> {
    let i: Int32;
    let networkArea: wref<NetworkAreaControllerPS>;
    let parents: array<ref<DeviceComponentPS>>;
    this.GetParents(parents);
    i = 0;
    while i < ArraySize(parents) {
      if IsDefined(parents[i] as NetworkAreaControllerPS) {
        networkArea = parents[i] as NetworkAreaControllerPS;
        return networkArea;
      };
      i += 1;
    };
    return null;
  }

  protected final func IsSpiderbotHackingConditionFullfilled() -> Bool {
    let checkResult: Bool;
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGameInstance());
    let player: ref<PlayerPuppet> = GetPlayer(this.GetGameInstance());
    if Cast<Bool>(statsSystem.GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.HasRemoteBotAccessPointBreach)) {
      checkResult = true;
    } else {
      checkResult = false;
    };
    if !AIActionHelper.CheckFlatheadStatPoolRequirements(this.GetGameInstance(), "DeviceAction") {
      checkResult = false;
    };
    return checkResult;
  }

  public final func UploadProgram(programID: Int32) -> Void {
    let programToExecute: ref<ProgramAction>;
    if !this.m_isBreached {
      return;
    };
    switch programID {
      case 1:
        programToExecute = this.ActionRevealEnemiesProgram();
    };
    if IsDefined(programToExecute) {
      this.ExecutePSAction(programToExecute);
    };
  }

  public func RevealDevicesGrid(shouldDraw: Bool, opt ownerEntityPosition: Vector4, opt fxDefault: FxResource, opt isPing: Bool, opt lifetime: Float, opt revealSlave: Bool, opt revealMaster: Bool, opt ignoreRevealed: Bool) -> Void {
    return;
  }

  public const func GetBlackboardDef() -> ref<BackDoorDeviceBlackboardDef> {
    return GetAllBlackboardDefs().BackdoorBlackboard;
  }

  protected final const func CheckMasterRunnerAchievement(minigameProgramsCompleted: Int32) -> Void {
    let achievementRequest: ref<AddAchievementRequest>;
    let dataTrackingSystem: ref<DataTrackingSystem> = GameInstance.GetScriptableSystemsContainer(this.GetGameInstance()).Get(n"DataTrackingSystem") as DataTrackingSystem;
    let achievement: gamedataAchievement = gamedataAchievement.MasterRunner;
    if minigameProgramsCompleted >= 3 {
      achievementRequest = new AddAchievementRequest();
      achievementRequest.achievement = achievement;
      dataTrackingSystem.QueueRequest(achievementRequest);
    };
  }

  private func PingSquad() -> Void {
    let puppetObject: wref<GameObject>;
    let squadName: CName;
    let puppets: array<ref<PuppetDeviceLinkPS>> = this.GetPuppets();
    let i: Int32 = 0;
    while i < ArraySize(puppets) {
      puppetObject = puppets[i].GetOwnerEntityWeak() as GameObject;
      if IsDefined(puppetObject) {
        squadName = AISquadHelper.GetSquadName(puppetObject as ScriptedPuppet);
        if this.IsSquadMarkedWithPing(squadName) {
        } else {
          this.AddPingedSquad(squadName);
          puppets[i].PingSquadNetwork();
        };
      };
      i += 1;
    };
    this.ClearPingedSquads();
  }

  private final func AddPingedSquad(squadName: CName) -> Void {
    if !ArrayContains(this.m_pingedSquads, squadName) {
      ArrayPush(this.m_pingedSquads, squadName);
    };
  }

  private final func RemovePingedSquad(squadName: CName) -> Void {
    ArrayRemove(this.m_pingedSquads, squadName);
  }

  private final func ClearPingedSquads() -> Void {
    if ArraySize(this.m_pingedSquads) > 0 {
      ArrayClear(this.m_pingedSquads);
    };
  }

  private final func IsSquadMarkedWithPing(squadName: CName) -> Bool {
    return ArrayContains(this.m_pingedSquads, squadName);
  }

  protected func OnFillTakeOverChainBBoardEvent(evt: ref<FillTakeOverChainBBoardEvent>) -> EntityNotificationType {
    this.FillTakeOverChainBB();
    return EntityNotificationType.DoNotNotifyEntity;
  }

  public final const func CheckConnectedClassTypes() -> ConnectedClassTypes {
    let data: ConnectedClassTypes;
    let puppet: ref<GameObject>;
    let slaves: array<ref<DeviceComponentPS>> = this.GetImmediateSlaves();
    let i: Int32 = 0;
    while i < ArraySize(slaves) {
      if data.surveillanceCamera && data.securityTurret && data.puppet {
        break;
      };
      if IsDefined(slaves[i] as ScriptableDeviceComponentPS) && (!(slaves[i] as ScriptableDeviceComponentPS).IsON() || (slaves[i] as ScriptableDeviceComponentPS).IsBroken()) {
      } else {
        if !data.surveillanceCamera && IsDefined(slaves[i] as SurveillanceCameraControllerPS) {
          data.surveillanceCamera = true;
        } else {
          if !data.securityTurret && IsDefined(slaves[i] as SecurityTurretControllerPS) {
            data.securityTurret = true;
          } else {
            if !data.puppet && IsDefined(slaves[i] as PuppetDeviceLinkPS) {
              puppet = slaves[i].GetOwnerEntityWeak() as GameObject;
              if IsDefined(puppet) && puppet.IsActive() {
                data.puppet = true;
              };
            };
          };
        };
      };
      i += 1;
    };
    return data;
  }
}
