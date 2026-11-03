
public class InvisibleSceneStash extends Device {

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as InvisibleSceneStashController;
  }

  protected cb func OnQuestUndressPlayer(evt: ref<UndressPlayer>) -> Bool {
    let i: Int32;
    let id: ItemID;
    let itemList: array<ItemID>;
    let player: ref<PlayerPuppet> = GetPlayer(this.GetGame());
    let equipmentSys: ref<EquipmentSystem> = this.GetEquipmentSystem();
    let equipmentData: ref<EquipmentSystemPlayerData> = EquipmentSystem.GetData(player);
    let slotList: array<gamedataEquipmentArea> = this.GetSlots(equipmentData.IsBuildCensored() || evt.isCensored);
    let unequipSetRequest: ref<QuestDisableWardrobeSetRequest> = new QuestDisableWardrobeSetRequest();
    unequipSetRequest.owner = player;
    equipmentSys.QueueRequest(unequipSetRequest);
    i = 0;
    while i < ArraySize(slotList) {
      id = equipmentData.GetActiveItem(slotList[i]);
      if ItemID.IsValid(id) {
        ArrayPush(itemList, id);
        equipmentSys.QueueRequest(this.CreateUnequipRequest(player, slotList[i]));
      };
      i += 1;
    };
    this.GetDevicePS().StoreItems(itemList);
  }

  protected cb func OnQuestDressPlayer(evt: ref<DressPlayer>) -> Bool {
    let i: Int32;
    let equipSetRequest: ref<QuestRestoreWardrobeSetRequest> = new QuestRestoreWardrobeSetRequest();
    let itemList: array<ItemID> = this.GetDevicePS().GetItems();
    let player: ref<PlayerPuppet> = GetPlayer(this.GetGame());
    let equipmentSys: ref<EquipmentSystem> = this.GetEquipmentSystem();
    equipSetRequest.owner = player;
    equipmentSys.QueueRequest(equipSetRequest);
    i = 0;
    while i < ArraySize(itemList) {
      equipmentSys.QueueRequest(this.CreateEquipRequest(player, itemList[i]));
      i += 1;
    };
    this.GetDevicePS().ClearStoredItems();
  }

  private final const func GetSlots(censored: Bool) -> [gamedataEquipmentArea] {
    let slots: array<gamedataEquipmentArea>;
    ArrayPush(slots, gamedataEquipmentArea.Face);
    ArrayPush(slots, gamedataEquipmentArea.Head);
    ArrayPush(slots, gamedataEquipmentArea.Feet);
    ArrayPush(slots, gamedataEquipmentArea.Legs);
    ArrayPush(slots, gamedataEquipmentArea.InnerChest);
    ArrayPush(slots, gamedataEquipmentArea.OuterChest);
    ArrayPush(slots, gamedataEquipmentArea.Outfit);
    if !censored {
      ArrayPush(slots, gamedataEquipmentArea.UnderwearBottom);
      ArrayPush(slots, gamedataEquipmentArea.UnderwearTop);
    };
    return slots;
  }

  private final const func GetEquipmentSystem() -> ref<EquipmentSystem> {
    return GameInstance.GetScriptableSystemsContainer(this.GetGame()).Get(n"EquipmentSystem") as EquipmentSystem;
  }

  private final const func CreateUnequipRequest(player: ref<PlayerPuppet>, area: gamedataEquipmentArea) -> ref<UnequipRequest> {
    let unequipRequest: ref<UnequipRequest> = new UnequipRequest();
    unequipRequest.owner = player;
    unequipRequest.slotIndex = 0;
    unequipRequest.areaType = area;
    return unequipRequest;
  }

  private final const func CreateEquipRequest(player: ref<PlayerPuppet>, item: ItemID) -> ref<EquipRequest> {
    let equipRequest: ref<EquipRequest> = new EquipRequest();
    equipRequest.owner = player;
    equipRequest.slotIndex = 0;
    equipRequest.itemID = item;
    return equipRequest;
  }

  private const func GetController() -> ref<InvisibleSceneStashController> {
    return this.m_controller as InvisibleSceneStashController;
  }

  public const func GetDevicePS() -> ref<InvisibleSceneStashControllerPS> {
    return this.GetController().GetPS();
  }
}

public class UndressPlayer extends Event {

  public edit let isCensored: Bool;

  public final func GetFriendlyDescription() -> String {
    return "Undress Player";
  }
}

public class DressPlayer extends Event {

  public final func GetFriendlyDescription() -> String {
    return "Dress Player Up";
  }
}
