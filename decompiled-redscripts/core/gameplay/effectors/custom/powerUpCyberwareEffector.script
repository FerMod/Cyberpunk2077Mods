
public class PowerUpCyberwareEffector extends Effector {

  public let m_targetEquipArea: gamedataEquipmentArea;

  public let m_targetEquipSlotIndex: Int32;

  public let m_playerData: wref<EquipmentSystemPlayerData>;

  public let m_owner: wref<GameObject>;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_targetEquipArea = IntEnum<gamedataEquipmentArea>(Cast<Int32>(EnumValueFromString("gamedataEquipmentArea", TweakDBInterface.GetString(record + t".targetEquipArea", ""))));
    this.m_targetEquipSlotIndex = TweakDBInterface.GetInt(record + t".targetEquipSlotIndex", 0);
  }

  protected func Uninitialize(game: GameInstance) -> Void {
    let sideUpgradeItem: ref<Item_Record>;
    let itemID: ItemID = this.m_playerData.GetItemInEquipSlot(this.m_targetEquipArea, this.m_targetEquipSlotIndex);
    if ItemID.IsValid(itemID) && !RPGManager.CyberwareHasSideUpgrade(itemID, sideUpgradeItem) {
      GameInstance.GetTransactionSystem(game).RemoveItem(this.m_owner, itemID, 1);
    };
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    this.m_owner = owner;
    this.m_playerData = EquipmentSystem.GetData(owner);
    PowerUpCyberwareEffector.PowerUpCyberwareInSlot(owner, this.m_targetEquipArea, this.m_targetEquipSlotIndex);
  }

  public final static func PowerUpCyberwareInSlot(owner: ref<GameObject>, targetEquipArea: gamedataEquipmentArea, targetEquipSlotIndex: Int32) -> Void {
    let newStatsShardItemID: ItemID;
    let oldStatsShardData: InnerItemData;
    let replaceEquipmentRequest: ref<ReplaceEquipmentRequest>;
    let sideUpgradeItem: ref<Item_Record>;
    let statsShardSlotTDBID: TweakDBID;
    let originalItemID: ItemID = EquipmentSystem.GetData(owner).GetItemInEquipSlot(targetEquipArea, targetEquipSlotIndex);
    if !ItemID.IsValid(originalItemID) {
      return;
    };
    statsShardSlotTDBID = t"AttachmentSlots.StatsShardSlot";
    GameInstance.GetTransactionSystem(owner.GetGame()).GetItemData(owner, originalItemID).GetItemPart(oldStatsShardData, statsShardSlotTDBID);
    if PlayerDevelopmentSystem.GetData(owner).IsNewPerkBought(gamedataNewPerkType.Tech_Central_Milestone_3) < 3 {
      return;
    };
    if ItemID.IsValid(originalItemID) && RPGManager.CyberwareHasSideUpgrade(originalItemID, sideUpgradeItem) {
      replaceEquipmentRequest = new ReplaceEquipmentRequest();
      replaceEquipmentRequest.owner = owner;
      replaceEquipmentRequest.slotIndex = targetEquipSlotIndex;
      replaceEquipmentRequest.itemID = ItemID.FromTDBID(sideUpgradeItem.GetID());
      replaceEquipmentRequest.addToInventory = true;
      replaceEquipmentRequest.removeOldItem = false;
      replaceEquipmentRequest.transferInstalledParts = true;
      newStatsShardItemID = ItemID.DuplicateRandomSeedWithOffset(InnerItemData.GetItemID(oldStatsShardData), InnerItemData.GetStaticData(oldStatsShardData).GetRecordID(), 0);
      replaceEquipmentRequest.customPartToGenerateID = newStatsShardItemID;
      EquipmentSystem.GetInstance(owner).QueueRequest(replaceEquipmentRequest);
    };
  }
}
