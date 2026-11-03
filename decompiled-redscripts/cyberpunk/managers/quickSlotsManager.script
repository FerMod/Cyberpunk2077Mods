
public struct QuickSlotCommand {

  @default(QuickSlotCommand, QuickSlotActionType.Undefined)
  public let ActionType: QuickSlotActionType;

  @default(QuickSlotCommand, true)
  public let IsSlotUnlocked: Bool;

  public let IsLocked: Bool;

  public let AtlasPath: CName;

  public let IconName: CName;

  public let MaxTier: Int32;

  public let VehicleState: Int32;

  public let ItemId: ItemID;

  public let Title: String;

  public let Type: String;

  public let Description: String;

  public let IsEquipped: Bool;

  public let intData: Int32;

  public let playerVehicleData: PlayerVehicle;

  @default(QuickSlotCommand, QuickSlotItemType.Undefined)
  public let itemType: QuickSlotItemType;

  public let equipType: gamedataEquipmentArea;

  public let slotIndex: Int32;

  public let interactiveAction: ref<DeviceAction>;

  public let interactiveActionOwner: EntityID;

  public final static func IsEmpty(const self: script_ref<QuickSlotCommand>) -> Bool {
    let empty: QuickSlotCommand;
    if Equals(empty.ActionType, Deref(self).ActionType) && Equals(empty.IsSlotUnlocked, Deref(self).IsSlotUnlocked) && Equals(empty.IsLocked, Deref(self).IsLocked) && Equals(empty.IsSlotUnlocked, Deref(self).IsSlotUnlocked) && Equals(empty.AtlasPath, Deref(self).AtlasPath) && Equals(empty.IconName, Deref(self).IconName) && empty.MaxTier == Deref(self).MaxTier && empty.VehicleState == Deref(self).VehicleState && Equals(empty.Title, Deref(self).Title) && Equals(empty.Type, Deref(self).Type) && Equals(empty.Description, Deref(self).Description) && Equals(empty.IsEquipped, Deref(self).IsEquipped) && empty.intData == Deref(self).intData && empty.slotIndex == Deref(self).slotIndex {
      return true;
    };
    return false;
  }
}

public class QuickSlotsManagerPS extends GameComponentPS {

  @default(QuickSlotsManagerPS, gamedataVehicleType.Car)
  private persistent let m_activeVehicleType: gamedataVehicleType;

  public final func SetActiveType(type: gamedataVehicleType) -> Void {
    this.m_activeVehicleType = type;
  }

  public final func GetActiveType() -> gamedataVehicleType {
    return this.m_activeVehicleType;
  }
}

public class QuickSlotsManager extends ScriptableComponent {

  private let m_Player: wref<PlayerPuppet>;

  private let m_QuickSlotsBB: wref<IBlackboard>;

  private let m_IsPlayerInCar: Bool;

  private let m_PlayerVehicleID: EntityID;

  private let m_QuickDpadCommands: [QuickSlotCommand];

  private let m_QuickDpadCommands_Vehicle: [QuickSlotCommand];

  private let m_DefaultHoldCommands: [QuickSlotCommand];

  private let m_DefaultHoldCommands_Vehicle: [QuickSlotCommand];

  @default(QuickSlotsManager, 8)
  private let m_NumberOfItemsPerWheel: Int32;

  private let m_QuickKeyboardCommands: [QuickSlotCommand];

  private let m_QuickKeyboardCommands_Vehicle: [QuickSlotCommand];

  private let m_lastPressAndHoldBtn: ref<QuickSlotButtonHoldEndEvent>;

  private let m_WheelList_Vehicles: [QuickSlotCommand];

  private let m_currentWheelItem: QuickSlotCommand;

  private let m_currentWeaponWheelItem: QuickSlotCommand;

  private let m_currentGadgetWheelConsumable: QuickSlotCommand;

  private let m_currentGadgetWheelGadget: QuickSlotCommand;

  private let m_currentVehicleWheelItem: QuickSlotCommand;

  private let m_currentGadgetWheelItem: QuickSlotCommand;

  private let m_currentInteractionWheelItem: QuickSlotCommand;

  private let m_OnVehPlayerStateDataChangedCallback: ref<CallbackHandle>;

  public final func OnGameAttach() -> Void {
    this.m_Player = this.GetOwner() as PlayerPuppet;
    this.m_QuickSlotsBB = GameInstance.GetBlackboardSystem(this.m_Player.GetGame()).Get(GetAllBlackboardDefs().UI_QuickSlotsData);
    let vehBlackbord: ref<IBlackboard> = GameInstance.GetBlackboardSystem(this.m_Player.GetGame()).Get(GetAllBlackboardDefs().UI_ActiveVehicleData);
    this.m_OnVehPlayerStateDataChangedCallback = vehBlackbord.RegisterListenerVariant(GetAllBlackboardDefs().UI_ActiveVehicleData.VehPlayerStateData, this, n"OnVehPlayerStateDataChanged");
    this.InitializeCommandsData();
  }

  private final func OnVehPlayerStateDataChanged(vehPlayerStateData: Variant) -> Void {
    let vehData: VehEntityPlayerStateData = FromVariant<VehEntityPlayerStateData>(vehPlayerStateData);
    this.m_PlayerVehicleID = vehData.entID;
    this.m_IsPlayerInCar = vehData.state > 0;
  }

  protected const func GetPS() -> ref<QuickSlotsManagerPS> {
    return this.GetBasePS() as QuickSlotsManagerPS;
  }

  protected cb func OnQuickSlotButtonTap(evt: ref<QuickSlotButtonTap>) -> Bool {
    let currentCommand: QuickSlotCommand;
    let success: Bool;
    let index: Int32 = this.GetDPadIndex(evt.dPadItemDirection);
    if !this.m_IsPlayerInCar {
      if this.IsDPadActionAvaliable(index) {
        currentCommand = this.GetDPadCommandAtSlot(index);
        success = this.TryExecuteCommand(currentCommand);
        this.m_QuickSlotsBB.SetVariant(GetAllBlackboardDefs().UI_QuickSlotsData.DPadCommand, ToVariant(new QuickSlotUIStructure(index, success)), true);
      };
    } else {
      if this.IsDPadActionAvaliable(index) {
        currentCommand = this.GetDPadCommandAtSlot(index);
        success = this.TryExecuteCommand(currentCommand);
        this.m_QuickSlotsBB.SetVariant(GetAllBlackboardDefs().UI_QuickSlotsData.DPadCommand, ToVariant(new QuickSlotUIStructure(index, success)), true);
      };
    };
  }

  protected cb func OnCallAction(evt: ref<CallAction>) -> Bool {
    let command: QuickSlotCommand = this.CreateEmptyQuickSlotCommand();
    command.ActionType = evt.calledAction;
    this.ExecuteCommand(command);
  }

  protected cb func OnQuickSlotKeyboardTap(evt: ref<QuickSlotKeyboardTap>) -> Bool {
    let currentCommand: QuickSlotCommand;
    let success: Bool;
    let index: Int32 = evt.keyIndex;
    if this.IsKeyboardActionAvaliable(index) {
      currentCommand = this.GetKeyboardCommandAtSlot(index);
      success = this.TryExecuteCommand(currentCommand);
      this.m_QuickSlotsBB.SetVariant(GetAllBlackboardDefs().UI_QuickSlotsData.KeyboardCommand, ToVariant(new QuickSlotUIStructure(index, success)), true);
    };
  }

  protected cb func OnQuickSlotButtonHoldStartEvent(evt: ref<QuickSlotButtonHoldStartEvent>) -> Bool {
    let wheelCommands: array<QuickSlotCommand>;
    if NotEquals(evt.dPadItemDirection, EDPadSlot.CallVehicle) {
      return false;
    };
    if !this.m_IsPlayerInCar {
      wheelCommands = this.GetWheelCommands(evt.dPadItemDirection);
    } else {
      wheelCommands = this.GetVehicleWheelCommands(evt.dPadItemDirection);
    };
    TimeDilationHelper.SetTimeDilationWithProfile(this.m_Player, "radialMenu", true, true);
    this.m_QuickSlotsBB.SetVariant(GetAllBlackboardDefs().UI_QuickSlotsData.WheelInteractionStarted, ToVariant(new QuickWheelStartUIStructure(wheelCommands, evt.dPadItemDirection)), true);
  }

  public final func SetWheelItem(const currentWheelItem: script_ref<QuickSlotCommand>) -> Void {
    switch Deref(currentWheelItem).itemType {
      case QuickSlotItemType.Vehicle:
        this.m_currentVehicleWheelItem = Deref(currentWheelItem);
        break;
      case QuickSlotItemType.Gadget:
        this.m_currentGadgetWheelGadget = Deref(currentWheelItem);
        this.m_currentGadgetWheelItem = Deref(currentWheelItem);
        break;
      case QuickSlotItemType.Cyberware:
        this.m_currentGadgetWheelGadget = Deref(currentWheelItem);
        this.m_currentGadgetWheelItem = Deref(currentWheelItem);
        break;
      case QuickSlotItemType.Consumable:
        this.m_currentGadgetWheelConsumable = Deref(currentWheelItem);
        this.m_currentGadgetWheelItem = Deref(currentWheelItem);
        break;
      case QuickSlotItemType.Weapon:
        this.m_currentWeaponWheelItem = Deref(currentWheelItem);
        break;
      case QuickSlotItemType.Interaction:
        this.m_currentInteractionWheelItem = Deref(currentWheelItem);
        break;
      default:
        this.m_currentWheelItem = Deref(currentWheelItem);
    };
  }

  public final func GetWheelItem(const currentWheelItem: script_ref<QuickSlotCommand>) -> QuickSlotCommand {
    switch Deref(currentWheelItem).itemType {
      case QuickSlotItemType.Vehicle:
        return this.m_currentVehicleWheelItem;
      case QuickSlotItemType.Gadget:
        return this.m_currentGadgetWheelGadget;
      case QuickSlotItemType.Cyberware:
        return this.m_currentGadgetWheelGadget;
      case QuickSlotItemType.Consumable:
        return this.m_currentGadgetWheelConsumable;
      case QuickSlotItemType.Weapon:
        return this.m_currentWeaponWheelItem;
      case QuickSlotItemType.Interaction:
        return this.m_currentInteractionWheelItem;
      default:
        return this.m_currentWheelItem;
    };
  }

  public final const func GetQuickSlotCommandByDpadSlot(wheelType: EDPadSlot) -> QuickSlotCommand {
    switch wheelType {
      case EDPadSlot.VehicleWheel:
        return this.m_currentVehicleWheelItem;
      case EDPadSlot.GadgetWheel:
        return this.m_currentGadgetWheelItem;
      case EDPadSlot.ConsumableWheel:
        return this.m_currentGadgetWheelConsumable;
      case EDPadSlot.WeaponsWheel:
        return this.m_currentWeaponWheelItem;
      case EDPadSlot.InteractionWheel:
        return this.m_currentInteractionWheelItem;
      default:
        return this.m_currentWheelItem;
    };
  }

  protected final const func IsSelectingCombatItemPrevented() -> Bool {
    return StatusEffectSystem.ObjectHasStatusEffectWithTag(this.m_Player, n"VehicleScene") || StatusEffectSystem.ObjectHasStatusEffectWithTag(this.m_Player, n"NoCombat") || StatusEffectSystem.ObjectHasStatusEffectWithTag(this.m_Player, n"FirearmsNoUnequip") || StatusEffectSystem.ObjectHasStatusEffectWithTag(this.m_Player, n"NoCombat") || StatusEffectSystem.ObjectHasStatusEffectWithTag(this.m_Player, n"FirearmsNoSwitch");
  }

  protected final const func IsSelectingCombatGadgetPrevented() -> Bool {
    return StatusEffectSystem.ObjectHasStatusEffectWithTag(this.m_Player, n"Fists") || StatusEffectSystem.ObjectHasStatusEffectWithTag(this.m_Player, n"Melee") || StatusEffectSystem.ObjectHasStatusEffectWithTag(this.m_Player, n"Firearms");
  }

  protected final func GetDPadIndex(direction: EDPadSlot) -> Int32 {
    switch direction {
      case EDPadSlot.Left:
        return 0;
      case EDPadSlot.LeftDouble:
        return 4;
      case EDPadSlot.Up:
        return 1;
      case EDPadSlot.UpDouble:
        return 5;
      case EDPadSlot.Right:
        return 2;
      case EDPadSlot.RightDouble:
        return 6;
      case EDPadSlot.Down:
        return 3;
      case EDPadSlot.DownDouble:
        return 7;
      case EDPadSlot.WeaponsWheel:
        return 8;
      default:
        return -1;
    };
  }

  protected final func TryExecuteCommand(const currentCommand: script_ref<QuickSlotCommand>) -> Bool {
    if IsDefined(this.m_Player) && NotEquals(Deref(currentCommand).ActionType, QuickSlotActionType.Undefined) {
      this.ExecuteCommand(currentCommand);
      return true;
    };
    return false;
  }

  public final func IsDPadActionAvaliable(direction: EDPadSlot) -> Bool {
    return this.IsDPadActionAvaliable(this.GetDPadIndex(direction));
  }

  public final func IsDPadActionAvaliable(actionIndex: Int32) -> Bool {
    let list: array<QuickSlotCommand> = this.m_IsPlayerInCar ? this.m_QuickDpadCommands_Vehicle : this.m_QuickDpadCommands;
    return actionIndex >= 0 && ArraySize(list) > actionIndex && list[actionIndex].IsSlotUnlocked;
  }

  public final func GetDPadCommandAtSlot(argIndex: Int32) -> QuickSlotCommand {
    let list: array<QuickSlotCommand> = this.m_IsPlayerInCar ? this.m_QuickDpadCommands_Vehicle : this.m_QuickDpadCommands;
    return list[argIndex];
  }

  public final static func GetMaxKeyboardItems() -> Int32 {
    return 8;
  }

  public final const func GetNumberOfItemsPerWheel() -> Int32 {
    return this.m_NumberOfItemsPerWheel;
  }

  public final func IsKeyboardActionAvaliable(actionIndex: Int32) -> Bool {
    let list: array<QuickSlotCommand> = this.m_IsPlayerInCar ? this.m_QuickKeyboardCommands_Vehicle : this.m_QuickKeyboardCommands;
    return actionIndex >= 0 && ArraySize(list) > actionIndex && list[actionIndex].IsSlotUnlocked;
  }

  public final func GetKeyboardCommandAtSlot(argIndex: Int32) -> QuickSlotCommand {
    let list: array<QuickSlotCommand> = this.m_IsPlayerInCar ? this.m_QuickKeyboardCommands_Vehicle : this.m_QuickKeyboardCommands;
    return list[argIndex];
  }

  private final const func CreateQuickSlotCommand(actionType: QuickSlotActionType, imageAtlasPath: CName, actionName: CName, maxTier: Int32, vehicleState: Int32, isLocked: Bool, isSlotUnlocked: Bool, opt intData: Int32, opt argTitle: String, opt argType: String) -> QuickSlotCommand {
    let newItem: QuickSlotCommand;
    newItem.IsSlotUnlocked = isSlotUnlocked;
    newItem.ActionType = actionType;
    newItem.IconName = imageAtlasPath;
    newItem.MaxTier = maxTier;
    newItem.VehicleState = vehicleState;
    newItem.IsLocked = isLocked;
    newItem.intData = intData;
    newItem.Title = argTitle;
    newItem.Type = argType;
    if NotEquals(actionName, n"None") {
      newItem.ItemId = ItemID.FromTDBID(TDBID.Create(NameToString(actionName)));
    };
    return newItem;
  }

  private final const func CreateQuickSlotItemCommand(itemID: ItemID, argActionType: QuickSlotActionType, argIcon: CName, const argTitle: script_ref<String>, const argType: script_ref<String>, const argDesc: script_ref<String>) -> QuickSlotCommand {
    let currWheelItem: QuickSlotCommand;
    currWheelItem.IconName = argIcon;
    currWheelItem.Title = Deref(argTitle);
    currWheelItem.Type = Deref(argType);
    currWheelItem.Description = Deref(argDesc);
    currWheelItem.ActionType = argActionType;
    currWheelItem.IsLocked = false;
    if itemID != ItemID.None() {
      currWheelItem.ItemId = itemID;
    };
    return currWheelItem;
  }

  private final const func GetActionData() -> QuickSlotCommand {
    let ret: QuickSlotCommand;
    return ret;
  }

  private final func InitializeCommandsData() -> Void {
    ArrayClear(this.m_QuickDpadCommands);
    ArrayPush(this.m_QuickDpadCommands, this.CreateQuickSlotCommand(QuickSlotActionType.Undefined, n"None", n"None", 1, 0, false, true));
    ArrayPush(this.m_QuickDpadCommands, this.CreateQuickSlotCommand(QuickSlotActionType.Undefined, n"None", n"None", 1, 0, false, true));
    ArrayPush(this.m_QuickDpadCommands, this.CreateQuickSlotCommand(QuickSlotActionType.CycleTrackedQuest, n"None", n"None", 1, 0, true, true, "Cycle Objective"));
    ArrayClear(this.m_QuickDpadCommands_Vehicle);
    ArrayPush(this.m_QuickDpadCommands_Vehicle, this.CreateQuickSlotCommand(QuickSlotActionType.OpenPhone, n"temp_kiroshi", n"None", 1, 0, true, true));
    ArrayPush(this.m_QuickDpadCommands_Vehicle, this.CreateQuickSlotCommand(QuickSlotActionType.ToggleRadio, n"temp_car", n"None", 1, 0, true, true));
    ArrayPush(this.m_QuickDpadCommands_Vehicle, this.CreateQuickSlotCommand(QuickSlotActionType.CycleTrackedQuest, n"temp_katana", n"None", 1, 0, true, true, "Cycle Objective"));
    ArrayClear(this.m_QuickKeyboardCommands);
    ArrayPush(this.m_QuickKeyboardCommands, this.CreateQuickSlotCommand(QuickSlotActionType.OpenPhone, n"temp_kiroshi", n"None", 1, 0, false, true));
    ArrayClear(this.m_QuickKeyboardCommands_Vehicle);
    ArrayPush(this.m_QuickKeyboardCommands_Vehicle, this.CreateQuickSlotCommand(QuickSlotActionType.OpenPhone, n"temp_kiroshi", n"None", 1, 0, false, true));
    ArrayPush(this.m_DefaultHoldCommands, this.CreateQuickSlotCommand(QuickSlotActionType.Undefined, n"None", n"None", 1, 0, false, false));
    ArrayPush(this.m_DefaultHoldCommands, this.CreateQuickSlotCommand(QuickSlotActionType.Undefined, n"None", n"None", 1, 0, false, false));
    ArrayPush(this.m_DefaultHoldCommands, this.CreateQuickSlotCommand(QuickSlotActionType.Undefined, n"None", n"None", 1, 0, false, false));
    ArrayPush(this.m_DefaultHoldCommands, this.CreateQuickSlotCommand(QuickSlotActionType.Undefined, n"None", n"None", 1, 0, false, false));
    ArrayPush(this.m_DefaultHoldCommands_Vehicle, this.CreateQuickSlotCommand(QuickSlotActionType.Undefined, n"None", n"None", 1, 0, false, false));
    ArrayPush(this.m_DefaultHoldCommands_Vehicle, this.CreateQuickSlotCommand(QuickSlotActionType.Undefined, n"None", n"None", 1, 0, false, false));
    ArrayPush(this.m_DefaultHoldCommands_Vehicle, this.CreateQuickSlotCommand(QuickSlotActionType.TurnOffRadio, n"temp_car", n"None", 1, 0, true, true, "TURN OFF", "RADIO"));
    ArrayPush(this.m_DefaultHoldCommands_Vehicle, this.CreateQuickSlotCommand(QuickSlotActionType.Undefined, n"None", n"None", 1, 0, false, false));
  }

  public final func GetWheelCommands(direction: EDPadSlot) -> [QuickSlotCommand] {
    let currentWheelCommands: array<QuickSlotCommand>;
    switch direction {
      case EDPadSlot.VehicleWheel:
        if StatusEffectSystem.ObjectHasStatusEffectWithTag(this.m_Player, n"VehicleNoInteraction") {
          this.GetEmptyWheel(currentWheelCommands);
          return currentWheelCommands;
        };
        this.GetVehicleWheel(currentWheelCommands);
        return currentWheelCommands;
      case EDPadSlot.GadgetWheel:
        if this.IsSelectingCombatItemPrevented() || this.IsSelectingCombatGadgetPrevented() {
          this.GetEmptyWheel(currentWheelCommands);
          return currentWheelCommands;
        };
        this.GetRPGWheel(currentWheelCommands);
        return currentWheelCommands;
      case EDPadSlot.WeaponsWheel:
        if this.IsSelectingCombatItemPrevented() {
          this.GetEmptyWheel(currentWheelCommands);
          return currentWheelCommands;
        };
        this.ChooseWeaponsWheel(currentWheelCommands);
        return currentWheelCommands;
      case EDPadSlot.ConsumableWheel:
        this.GetConsumablesWheel(currentWheelCommands);
        return currentWheelCommands;
      default:
        return currentWheelCommands;
    };
  }

  public final func GetVehicleWheelCommands(direction: EDPadSlot) -> [QuickSlotCommand] {
    let currentWheelCommands: array<QuickSlotCommand>;
    switch direction {
      case EDPadSlot.VehicleInsideWheel:
        this.GetVehicleInsideWheel(currentWheelCommands);
        return currentWheelCommands;
      case EDPadSlot.GadgetWheel:
        if this.IsSelectingCombatItemPrevented() {
          this.GetEmptyWheel(currentWheelCommands);
          return currentWheelCommands;
        };
        this.GetRPGWheel(currentWheelCommands);
        return currentWheelCommands;
      case EDPadSlot.WeaponsWheel:
        this.ChooseWeaponsWheel(currentWheelCommands);
        return currentWheelCommands;
      case EDPadSlot.ConsumableWheel:
        this.GetConsumablesWheel(currentWheelCommands);
        return currentWheelCommands;
      default:
        return currentWheelCommands;
    };
  }

  private final const func GetVehicleObject() -> ref<VehicleObject> {
    let mountInfo: MountingInfo = GameInstance.GetMountingFacility(this.m_Player.GetGame()).GetMountingInfoSingleWithIds(this.m_Player.GetEntityID());
    let entity: ref<Entity> = GameInstance.FindEntityByID(this.m_Player.GetGame(), mountInfo.parentId);
    let vehicleEntity: ref<VehicleObject> = entity as VehicleObject;
    return vehicleEntity;
  }

  public final const func GetVehicleInsideWheel(wheel: script_ref<[QuickSlotCommand]>) -> Void {
    let isRadioActive: Bool = this.GetVehicleObject().GetBlackboard().GetBool(GetAllBlackboardDefs().Vehicle.VehRadioState);
    ArrayPush(Deref(wheel), this.CreateQuickSlotCommand(QuickSlotActionType.ToggleRadio, n"temp_car", n"None", 1, 0, true, true, "NEXT STATION", "RADIO"));
    if isRadioActive {
      ArrayPush(Deref(wheel), this.CreateQuickSlotCommand(QuickSlotActionType.TurnOffRadio, n"temp_car", n"None", 1, 0, true, true, "TURN OFF", "RADIO"));
    };
  }

  public final const func GetRPGWheel(rpgWheel: script_ref<[QuickSlotCommand]>) -> Void {
    this.GetQuickWheel(rpgWheel);
  }

  public final const func GetConsumablesWheel(wheel: script_ref<[QuickSlotCommand]>) -> Void {
    this.PushBackCommands(gamedataEquipmentArea.Consumable, wheel);
  }

  public final const func GetCyberwareWheel(wheel: script_ref<[QuickSlotCommand]>) -> Void {
    this.GetLauncher(wheel);
    this.PushBackCommands(gamedataEquipmentArea.CyberwareWheel, wheel);
  }

  public final const func GetGadgetsWheel(wheel: script_ref<[QuickSlotCommand]>) -> Void {
    this.PushBackCommands(gamedataEquipmentArea.QuickSlot, wheel);
  }

  public final const func GetQuickWheel(wheel: script_ref<[QuickSlotCommand]>) -> Void {
    this.PushBackCommands(gamedataEquipmentArea.QuickWheel, wheel);
  }

  public final const func GetLauncher(wheel: script_ref<[QuickSlotCommand]>) -> Void {
    let record: ref<Item_Record>;
    let item: ItemID = EquipmentSystem.GetData(this.m_Player).GetActiveItem(gamedataEquipmentArea.ArmsCW);
    if ItemID.IsValid(item) {
      record = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(item));
      if Equals(record.ItemType().Type(), gamedataItemType.Cyb_Launcher) {
        this.PushBackCommands(gamedataEquipmentArea.ArmsCW, wheel);
      };
    };
  }

  public final const func ChooseWeaponsWheel(out weaponsWheel: [QuickSlotCommand]) -> Void {
    if this.IsSelectingCombatItemPrevented() {
      this.GetEmptyWheel(weaponsWheel);
    } else {
      if StatusEffectSystem.ObjectHasStatusEffectWithTag(this.m_Player, n"Fists") {
        this.GetFistFightOnlyWeaponsWheel(weaponsWheel);
      } else {
        if StatusEffectSystem.ObjectHasStatusEffectWithTag(this.m_Player, n"Melee") {
          this.GetMeleeOnlyWeaponsWheel(weaponsWheel);
        } else {
          if StatusEffectSystem.ObjectHasStatusEffectWithTag(this.m_Player, n"NoArmsCW") {
            this.GetNoArmsCWWeaponsWheel(weaponsWheel);
          } else {
            if StatusEffectSystem.ObjectHasStatusEffectWithTag(this.m_Player, n"OneHandedFirearms") {
              this.GetOneHandedOnlyOnlyWeaponsWheel(weaponsWheel);
            } else {
              if StatusEffectSystem.ObjectHasStatusEffectWithTag(this.m_Player, n"DriverCombatFirearms") {
                this.GetDriverCombatOnlyWeaponsWheel(weaponsWheel);
              } else {
                if StatusEffectSystem.ObjectHasStatusEffectWithTag(this.m_Player, n"DriverCombatBikeWeapons") {
                  this.GetDriverCombatBikeOnlyWeaponsWheel(weaponsWheel);
                } else {
                  if StatusEffectSystem.ObjectHasStatusEffectWithTag(this.m_Player, n"Firearms") {
                    this.GetFirearmsOnlyWeaponsWheel(weaponsWheel);
                  } else {
                    this.GetRegularWeaponsWheel(weaponsWheel);
                  };
                };
              };
            };
          };
        };
      };
    };
  }

  public final const func GetRegularWeaponsWheel(weaponsWheel: script_ref<[QuickSlotCommand]>) -> Void {
    let allowedItemTypes: array<gamedataItemType>;
    this.GetWeaponsWheel(weaponsWheel, allowedItemTypes);
  }

  public final const func GetEmptyWheel(weaponsWheel: script_ref<[QuickSlotCommand]>) -> Void {
    let allowedItemTypes: array<gamedataItemType>;
    ArrayPush(allowedItemTypes, gamedataItemType.Invalid);
    this.GetWeaponsWheel(weaponsWheel, allowedItemTypes);
  }

  public final const func GetFistFightOnlyWeaponsWheel(weaponsWheel: script_ref<[QuickSlotCommand]>) -> Void {
    let allowedItemTypes: array<gamedataItemType>;
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Fists);
    ArrayPush(allowedItemTypes, gamedataItemType.Cyb_StrongArms);
    this.GetWeaponsWheel(weaponsWheel, allowedItemTypes);
  }

  public final const func GetMeleeOnlyWeaponsWheel(weaponsWheel: script_ref<[QuickSlotCommand]>) -> Void {
    let allowedItemTypes: array<gamedataItemType>;
    ArrayPush(allowedItemTypes, gamedataItemType.Cyb_MantisBlades);
    ArrayPush(allowedItemTypes, gamedataItemType.Cyb_NanoWires);
    ArrayPush(allowedItemTypes, gamedataItemType.Cyb_StrongArms);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Fists);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Hammer);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Katana);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Sword);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Knife);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_LongBlade);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Melee);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_OneHandedClub);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_ShortBlade);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_TwoHandedClub);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Axe);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Chainsword);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Machete);
    this.GetWeaponsWheel(weaponsWheel, allowedItemTypes, n"MeleeWeapon");
  }

  public final const func GetOneHandedOnlyOnlyWeaponsWheel(weaponsWheel: script_ref<[QuickSlotCommand]>) -> Void {
    let allowedItemTypes: array<gamedataItemType>;
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Handgun);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Revolver);
    this.GetWeaponsWheel(weaponsWheel, allowedItemTypes, n"OneHandedRangedWeapon");
  }

  public final const func GetDriverCombatOnlyWeaponsWheel(weaponsWheel: script_ref<[QuickSlotCommand]>) -> Void {
    let allowedItemTypes: array<gamedataItemType>;
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Handgun);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Revolver);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_SubmachineGun);
    this.GetWeaponsWheel(weaponsWheel, allowedItemTypes, n"DriverCombatRangedWeapon");
  }

  public final const func GetDriverCombatBikeOnlyWeaponsWheel(weaponsWheel: script_ref<[QuickSlotCommand]>) -> Void {
    let allowedItemTypes: array<gamedataItemType>;
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Handgun);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Revolver);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_SubmachineGun);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Katana);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Sword);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_OneHandedClub);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Machete);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_LongBlade);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_ShortBlade);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_TwoHandedClub);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Chainsword);
    this.GetWeaponsWheel(weaponsWheel, allowedItemTypes, n"DriverCombatRangedWeapon");
  }

  public final const func GetFirearmsOnlyWeaponsWheel(weaponsWheel: script_ref<[QuickSlotCommand]>) -> Void {
    let allowedItemTypes: array<gamedataItemType>;
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_AssaultRifle);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Handgun);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_HeavyMachineGun);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_LightMachineGun);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_PrecisionRifle);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Revolver);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Rifle);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Shotgun);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_ShotgunDual);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_SniperRifle);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_SubmachineGun);
    this.GetWeaponsWheel(weaponsWheel, allowedItemTypes, n"RangedWeapon");
  }

  public final const func GetNoArmsCWWeaponsWheel(weaponsWheel: script_ref<[QuickSlotCommand]>) -> Void {
    let allowedItemTypes: array<gamedataItemType>;
    ArrayPush(allowedItemTypes, gamedataItemType.Cyb_StrongArms);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Fists);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Hammer);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Katana);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Sword);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Knife);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_LongBlade);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Melee);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_OneHandedClub);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_ShortBlade);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_TwoHandedClub);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Axe);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Chainsword);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Machete);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_AssaultRifle);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Handgun);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_HeavyMachineGun);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_LightMachineGun);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_PrecisionRifle);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Revolver);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Rifle);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_Shotgun);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_ShotgunDual);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_SniperRifle);
    ArrayPush(allowedItemTypes, gamedataItemType.Wea_SubmachineGun);
    this.GetWeaponsWheel(weaponsWheel, allowedItemTypes, n"RangedWeapon");
  }

  private final const func GetWeaponsWheel(weaponsWheel: script_ref<[QuickSlotCommand]>, const opt allowedItemTypes: [gamedataItemType], const opt allowedTag: CName) -> Void {
    let holsterCommand: QuickSlotCommand = this.CreateQuickSlotCommand(QuickSlotActionType.HideWeapon, n"temp_switchweapon", n"HOLSTER WEAPON", 1, 0, false, false);
    holsterCommand.itemType = QuickSlotItemType.Weapon;
    let equipFistsCommand: QuickSlotCommand = this.CreateQuickSlotCommand(QuickSlotActionType.EquipFists, n"fist", n"FISTS", 1, 0, false, false);
    equipFistsCommand.itemType = QuickSlotItemType.Weapon;
    ArrayPush(Deref(weaponsWheel), holsterCommand);
    this.PushBackCommands(gamedataEquipmentArea.WeaponWheel, weaponsWheel, allowedItemTypes, allowedTag);
    if (ArraySize(allowedItemTypes) == 0 || ArrayContains(allowedItemTypes, gamedataItemType.Wea_Fists)) && !ItemID.IsValid(EquipmentSystem.GetData(this.m_Player).GetActiveMeleeWare()) {
      ArrayPush(Deref(weaponsWheel), equipFistsCommand);
    };
  }

  public final const func GetVehicleWheel(vehicleWheel: script_ref<[QuickSlotCommand]>) -> Void {
    let gmplSettingBB: ref<IBlackboard>;
    let i: Int32;
    let iconPath: CName;
    let itemRecord: ref<Vehicle_Record>;
    let quickSlotCommand: QuickSlotCommand;
    let summonToggleEnabled: Bool;
    let title: String;
    let type: String;
    let vehicles: array<PlayerVehicle>;
    GameInstance.GetVehicleSystem(this.m_Player.GetGame()).GetPlayerUnlockedVehicles(vehicles);
    i = 0;
    while i < ArraySize(vehicles) {
      if TDBID.IsValid(vehicles[i].recordID) {
        itemRecord = TweakDBInterface.GetVehicleRecord(vehicles[i].recordID);
        iconPath = this.FindTempVehicleIcon(vehicles[i]);
        title = itemRecord.Model().EnumName();
        type = itemRecord.Type().EnumName();
        quickSlotCommand = this.CreateQuickSlotItemCommand(ItemID.None(), QuickSlotActionType.SetActiveVehicle, iconPath, title, type, "");
        quickSlotCommand.playerVehicleData = vehicles[i];
        quickSlotCommand.itemType = QuickSlotItemType.Vehicle;
        ArrayPush(Deref(vehicleWheel), quickSlotCommand);
      };
      i += 1;
    };
    gmplSettingBB = GameInstance.GetBlackboardSystem(this.m_Player.GetGame()).Get(GetAllBlackboardDefs().GameplaySettings);
    summonToggleEnabled = gmplSettingBB.GetBool(GetAllBlackboardDefs().GameplaySettings.EnableVehicleToggleSummonMode);
    if summonToggleEnabled {
      title = "Toggle summon mode";
      quickSlotCommand = this.CreateQuickSlotItemCommand(ItemID.None(), QuickSlotActionType.ToggleSummonMode, n"None", title, "", "");
      quickSlotCommand.itemType = QuickSlotItemType.Vehicle;
      ArrayPush(Deref(vehicleWheel), quickSlotCommand);
    };
  }

  private final const func FindTempVehicleIcon(vehicle: PlayerVehicle) -> CName {
    switch vehicle.vehicleType {
      case gamedataVehicleType.Car:
        return n"temp_car";
      case gamedataVehicleType.Bike:
        return n"temp_bike";
      default:
        return n"None";
    };
  }

  protected final const func PushBackCommands(area: gamedataEquipmentArea, commandList: script_ref<[QuickSlotCommand]>, const opt allowedItemTypes: [gamedataItemType], const opt allowedTag: CName) -> Void {
    let areaCommandList: array<QuickSlotCommand> = this.GetEquipAreaCommands(area, allowedItemTypes, allowedTag);
    let i: Int32 = 0;
    while i < ArraySize(areaCommandList) {
      ArrayPush(Deref(commandList), areaCommandList[i]);
      i += 1;
    };
  }

  public final const func GetEquipAreaCommands(const equipArea: gamedataEquipmentArea, const opt allowedItemTypes: [gamedataItemType], const opt allowedTag: CName) -> [QuickSlotCommand] {
    let ammoCount: String;
    let iconPath: CName;
    let itemID: ItemID;
    let itemRecord: ref<Item_Record>;
    let itemTags: array<CName>;
    let quickSlotCommand: QuickSlotCommand;
    let quickSlotCommands: array<QuickSlotCommand>;
    let title: String;
    let type: String;
    let equipData: ref<EquipmentSystemPlayerData> = EquipmentSystem.GetData(this.m_Player);
    let numSlots: Int32 = equipData.GetNumberOfSlots(equipArea);
    let i: Int32 = 0;
    while i < numSlots {
      itemID = equipData.GetItemInEquipSlot(equipArea, i);
      quickSlotCommand.equipType = equipArea;
      quickSlotCommand.slotIndex = i;
      if itemID == ItemID.None() {
        quickSlotCommand = QuickSlotsManager.CreateBlankWheelCommand();
        ArrayPush(quickSlotCommands, quickSlotCommand);
      } else {
        itemRecord = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(itemID));
        if ArraySize(allowedItemTypes) > 0 && !ArrayContains(allowedItemTypes, itemRecord.ItemType().Type()) {
          quickSlotCommand = QuickSlotsManager.CreateBlankWheelCommand();
          ArrayPush(quickSlotCommands, quickSlotCommand);
        } else {
          if IsNameValid(allowedTag) {
            itemTags = itemRecord.Tags();
            if !ArrayContains(itemTags, allowedTag) {
              quickSlotCommand = QuickSlotsManager.CreateBlankWheelCommand();
              ArrayPush(quickSlotCommands, quickSlotCommand);
            } else {
              iconPath = StringToName(itemRecord.IconPath());
              title = NameToString(itemRecord.DisplayName());
              type = LocKeyToString(itemRecord.ItemType().LocalizedType());
              ammoCount = RPGManager.GetAmmoCount(this.m_Player, itemID);
              quickSlotCommand = this.CreateQuickSlotItemCommand(itemID, QuickSlotActionType.SelectItem, iconPath, title, type, ammoCount);
              quickSlotCommand.itemType = this.GetQuickSlotItemTypeByEquipArea(equipArea);
              ArrayPush(quickSlotCommands, quickSlotCommand);
            };
          };
          iconPath = StringToName(itemRecord.IconPath());
          title = NameToString(itemRecord.DisplayName());
          type = LocKeyToString(itemRecord.ItemType().LocalizedType());
          ammoCount = RPGManager.GetAmmoCount(this.m_Player, itemID);
          quickSlotCommand = this.CreateQuickSlotItemCommand(itemID, QuickSlotActionType.SelectItem, iconPath, title, type, ammoCount);
          quickSlotCommand.itemType = this.GetQuickSlotItemTypeByEquipArea(equipArea);
          ArrayPush(quickSlotCommands, quickSlotCommand);
        };
      };
      i += 1;
    };
    return quickSlotCommands;
  }

  protected final const func GetQuickSlotItemTypeByEquipArea(eqArea: gamedataEquipmentArea) -> QuickSlotItemType {
    switch eqArea {
      case gamedataEquipmentArea.Consumable:
        return QuickSlotItemType.Consumable;
      case gamedataEquipmentArea.QuickSlot:
        return QuickSlotItemType.Gadget;
      case gamedataEquipmentArea.QuickWheel:
        return QuickSlotItemType.Gadget;
      case gamedataEquipmentArea.WeaponWheel:
        return QuickSlotItemType.Weapon;
      case gamedataEquipmentArea.CyberwareWheel:
        return QuickSlotItemType.Cyberware;
      case gamedataEquipmentArea.ArmsCW:
        return QuickSlotItemType.Cyberware;
      default:
        return QuickSlotItemType.Undefined;
    };
  }

  private final func ChooseWheelItem(direction: EDPadSlot, const wheelItem: script_ref<QuickSlotCommand>) -> Bool {
    let success: Bool = this.TryExecuteCommand(wheelItem);
    return success;
  }

  public final static func CreateBlankWheelCommand() -> QuickSlotCommand {
    let wheelCommand: QuickSlotCommand;
    wheelCommand.ActionType = QuickSlotActionType.Undefined;
    wheelCommand.IconName = n"temp_x";
    wheelCommand.Type = "";
    wheelCommand.Title = "";
    wheelCommand.Description = "";
    return wheelCommand;
  }

  protected final func ExecuteCommand(const command: script_ref<QuickSlotCommand>) -> Void {
    switch Deref(command).ActionType {
      case QuickSlotActionType.SelectItem:
        this.SelectItem(command);
        break;
      case QuickSlotActionType.HideWeapon:
        this.HideWeapon();
        break;
      case QuickSlotActionType.EquipFists:
        this.RequestEquipFists();
        break;
      case QuickSlotActionType.OpenPhone:
        this.UsePhone();
        break;
      case QuickSlotActionType.ToggleRadio:
        this.SendRadioEvent(true, false, 0);
        break;
      case QuickSlotActionType.SelectRadioStation:
        this.SendRadioEvent(true, true, Deref(command).intData);
        break;
      case QuickSlotActionType.TurnOffRadio:
        this.SendRadioEvent(false, false, -1);
        break;
      case QuickSlotActionType.SetActiveVehicle:
        this.SetActiveVehicle(Deref(command).playerVehicleData);
        break;
      case QuickSlotActionType.SummonVehicle:
        this.SummonActiveVehicle(false);
        break;
      case QuickSlotActionType.QuickHack:
        this.ApplyQuickHack(command);
        break;
      case QuickSlotActionType.ToggleSummonMode:
        this.ToggleSummonMode();
    };
  }

  public final func SelectItem(const command: script_ref<QuickSlotCommand>) -> Void {
    if Equals(Deref(command).itemType, QuickSlotItemType.Weapon) {
      this.RequestWeaponEquip(Deref(command).ItemId);
    } else {
      this.AssignItem(Deref(command).ItemId);
    };
  }

  private final func ToggleFireMode() -> Void {
    this.m_Player.GetPlayerStateMachineBlackboard().SetBool(GetAllBlackboardDefs().PlayerStateMachine.ToggleFireMode, true);
  }

  private final func HideWeapon() -> Void {
    let equipmentManipulationRequest: ref<EquipmentSystemWeaponManipulationRequest> = new EquipmentSystemWeaponManipulationRequest();
    let eqSystem: wref<EquipmentSystem> = GameInstance.GetScriptableSystemsContainer(this.m_Player.GetGame()).Get(n"EquipmentSystem") as EquipmentSystem;
    equipmentManipulationRequest.requestType = EquipmentManipulationAction.UnequipWeapon;
    equipmentManipulationRequest.owner = this.m_Player;
    eqSystem.QueueRequest(equipmentManipulationRequest);
  }

  private final func UsePhone() -> Void {
    GameInstance.GetScriptableSystemsContainer(this.m_Player.GetGame()).Get(n"PhoneSystem").QueueRequest(new UsePhoneRequest());
  }

  public final func GetActiveVehicleType() -> gamedataVehicleType {
    return this.GetPS().GetActiveType();
  }

  public final func SetActiveVehicle(vehicleData: PlayerVehicle) -> Void {
    if TDBID.IsValid(vehicleData.recordID) {
      GameInstance.GetVehicleSystem(this.m_Player.GetGame()).TogglePlayerActiveVehicle(Cast<GarageVehicleID>(vehicleData.recordID), vehicleData.vehicleType, true);
      this.GetPS().SetActiveType(vehicleData.vehicleType);
    };
  }

  public final func SummonActiveVehicle(force: Bool) -> Void {
    let dpadAction: ref<DPADActionPerformed>;
    let canSummonVehicle: Bool = force || !GameInstance.GetVehicleSystem(this.m_Player.GetGame()).IsActivePlayerVehicleOnCooldown(this.GetActiveVehicleType());
    if !canSummonVehicle {
      return;
    };
    dpadAction = new DPADActionPerformed();
    dpadAction.action = EHotkey.DPAD_RIGHT;
    dpadAction.state = EUIActionState.COMPLETED;
    dpadAction.successful = true;
    GameInstance.GetVehicleSystem(this.m_Player.GetGame()).SpawnActivePlayerVehicle(this.GetActiveVehicleType());
    GameInstance.GetUISystem(this.m_Player.GetGame()).QueueEvent(dpadAction);
  }

  public final func SummonVehicle(force: Bool, type: gamedataVehicleType, vehicle: TweakDBID, spawnOnlyOnValidRoad: Bool) -> Void {
    let dpadAction: ref<DPADActionPerformed>;
    let canSummonVehicle: Bool = force || !GameInstance.GetVehicleSystem(this.m_Player.GetGame()).IsPlayerVehicleOnCooldown(type, vehicle);
    if !canSummonVehicle {
      return;
    };
    dpadAction = new DPADActionPerformed();
    dpadAction.action = EHotkey.DPAD_RIGHT;
    dpadAction.state = EUIActionState.COMPLETED;
    dpadAction.successful = true;
    GameInstance.GetVehicleSystem(this.m_Player.GetGame()).SpawnPlayerVehicle(type, vehicle, spawnOnlyOnValidRoad);
    GameInstance.GetUISystem(this.m_Player.GetGame()).QueueEvent(dpadAction);
  }

  private final func ApplyQuickHack(const command: script_ref<QuickSlotCommand>) -> Void {
    let commandUsed: ref<QuickSlotCommandUsed> = new QuickSlotCommandUsed();
    commandUsed.action = Deref(command).interactiveAction;
    this.m_Player.QueueEventForEntityID(Deref(command).interactiveActionOwner, commandUsed);
  }

  private final func ToggleSummonMode() -> Void {
    GameInstance.GetVehicleSystem(this.m_Player.GetGame()).ToggleSummonMode();
  }

  public final func SendRadioEvent(toggle: Bool, setStation: Bool, stationIndex: Int32) -> Void {
    let vehRadioEvent: ref<VehicleRadioEvent> = new VehicleRadioEvent();
    vehRadioEvent.toggle = toggle;
    vehRadioEvent.setStation = setStation;
    vehRadioEvent.station = stationIndex >= 0 ? EnumInt(RadioStationDataProvider.GetRadioStationByUIIndex(stationIndex)) : -1;
    if this.m_IsPlayerInCar {
      this.m_Player.QueueEventForEntityID(this.m_PlayerVehicleID, vehRadioEvent);
    };
    this.m_Player.QueueEvent(vehRadioEvent);
  }

  public final func RequestWeaponEquip(itemId: ItemID) -> Void {
    let setActiveItemRequest: ref<SetActiveItemInEquipmentArea> = new SetActiveItemInEquipmentArea();
    let equipmentManipulationRequest: ref<EquipmentSystemWeaponManipulationRequest> = new EquipmentSystemWeaponManipulationRequest();
    let eqSystem: wref<EquipmentSystem> = GameInstance.GetScriptableSystemsContainer(this.m_Player.GetGame()).Get(n"EquipmentSystem") as EquipmentSystem;
    setActiveItemRequest.itemID = itemId;
    setActiveItemRequest.owner = this.m_Player;
    eqSystem.QueueRequest(setActiveItemRequest);
    equipmentManipulationRequest.requestType = EquipmentManipulationAction.RequestActiveWeapon;
    equipmentManipulationRequest.owner = this.m_Player;
    eqSystem.QueueRequest(equipmentManipulationRequest);
  }

  public final func RequestEquipFists() -> Void {
    let equipmentManipulationRequest: ref<EquipmentSystemWeaponManipulationRequest> = new EquipmentSystemWeaponManipulationRequest();
    let eqSystem: wref<EquipmentSystem> = GameInstance.GetScriptableSystemsContainer(this.m_Player.GetGame()).Get(n"EquipmentSystem") as EquipmentSystem;
    equipmentManipulationRequest.requestType = EquipmentManipulationAction.RequestFists;
    equipmentManipulationRequest.owner = this.m_Player;
    eqSystem.QueueRequest(equipmentManipulationRequest);
  }

  public final func AssignItem(itemId: ItemID) -> Void {
    let setActiveItemRequest: ref<SetActiveItemInEquipmentArea> = new SetActiveItemInEquipmentArea();
    let eqSystem: wref<EquipmentSystem> = GameInstance.GetScriptableSystemsContainer(this.m_Player.GetGame()).Get(n"EquipmentSystem") as EquipmentSystem;
    setActiveItemRequest.itemID = itemId;
    setActiveItemRequest.owner = this.m_Player;
    eqSystem.QueueRequest(setActiveItemRequest);
  }

  public final func AssignItemToCyberwareSlot(itemId: ItemID, slotIndex: Int32) -> Void {
    let eqSystem: wref<EquipmentSystem> = GameInstance.GetScriptableSystemsContainer(this.m_Player.GetGame()).Get(n"EquipmentSystem") as EquipmentSystem;
    let request: ref<AssignToCyberwareWheelRequest> = new AssignToCyberwareWheelRequest();
    request.owner = this.m_Player;
    request.itemID = itemId;
    request.slotIndex = slotIndex;
    eqSystem.QueueRequest(request);
  }

  private final func IsPhoneAvailable() -> Bool {
    let context: JournalRequestContext;
    let entries: array<wref<JournalEntry>>;
    context.stateFilter.active = true;
    let journalMgr: ref<JournalManager> = GameInstance.GetJournalManager(this.m_Player.GetGame());
    journalMgr.GetContacts(context, entries);
    return ArraySize(entries) > 0 && (GameInstance.GetScriptableSystemsContainer(this.m_Player.GetGame()).Get(n"PhoneSystem") as PhoneSystem).IsPhoneAvailable();
  }

  public final func GetAssignedQuickSlotCommand(itemType: QuickSlotItemType) -> QuickSlotCommand {
    let i: Int32;
    let quickSlots: array<QuickSlotCommand>;
    let item: ItemID = this.GetAssignedItemIDByType(itemType);
    if Equals(itemType, QuickSlotItemType.Vehicle) {
    };
    if !ItemID.IsValid(item) {
      return this.CreateEmptyQuickSlotCommand();
    };
    this.PushBackCommands(this.GetGamedataEquipmentAreaFromItemType(itemType), quickSlots);
    i = 0;
    while i < ArraySize(quickSlots) {
      if item == quickSlots[i].ItemId {
        return quickSlots[i];
      };
      i += 1;
    };
    return this.CreateEmptyQuickSlotCommand();
  }

  private final func GetAssignedItemIDByType(itemType: QuickSlotItemType) -> ItemID {
    switch itemType {
      case QuickSlotItemType.Weapon:
        return EquipmentSystem.GetData(this.m_Player).GetActiveItem(gamedataEquipmentArea.WeaponWheel);
      case QuickSlotItemType.Consumable:
        return EquipmentSystem.GetData(this.m_Player).GetActiveConsumable();
      case QuickSlotItemType.Gadget:
        return EquipmentSystem.GetData(this.m_Player).GetActiveGadget();
      default:
        return ItemID.None();
    };
  }

  private final func GetGamedataEquipmentAreaFromItemType(itemType: QuickSlotItemType) -> gamedataEquipmentArea {
    switch itemType {
      case QuickSlotItemType.Weapon:
        return gamedataEquipmentArea.WeaponWheel;
      case QuickSlotItemType.Consumable:
        return gamedataEquipmentArea.Consumable;
      case QuickSlotItemType.Gadget:
        return gamedataEquipmentArea.QuickWheel;
      default:
        return gamedataEquipmentArea.Invalid;
    };
  }

  protected final func CreateEmptyQuickSlotCommand() -> QuickSlotCommand {
    return this.CreateQuickSlotItemCommand(ItemID.None(), QuickSlotActionType.Undefined, n"None", "", "", "");
  }
}
