
public class RarityOfEquippedConsumableItemPrereq extends IScriptablePrereq {

  public let m_consumableItemTag: CName;

  public let m_qualityLessThan: gamedataQuality;

  protected func Initialize(recordID: TweakDBID) -> Void {
    this.m_consumableItemTag = TweakDBInterface.GetCName(recordID + t".consumableItemTag", n"Inhaler");
    this.m_qualityLessThan = IntEnum<gamedataQuality>(Cast<Int32>(EnumValueFromName(n"gamedataQuality", TweakDBInterface.GetCName(recordID + t".qualityLessThan", n"Common"))));
  }

  public const func IsFulfilled(game: GameInstance, context: ref<IScriptable>) -> Bool {
    let healingItem: TweakDBID;
    let playerItems: array<wref<gameItemData>>;
    let qualityRecord: gamedataQuality;
    let result: Bool;
    GameInstance.GetTransactionSystem(game).GetItemListByTag(GetPlayer(game), this.m_consumableItemTag, playerItems);
    healingItem = ItemID.GetTDBID(playerItems[0].GetID());
    qualityRecord = TweakDBInterface.GetItemRecord(healingItem).Quality().Type();
    result = RPGManager.ConvertQualityToCombinedValue(this.m_qualityLessThan) > RPGManager.ConvertQualityToCombinedValue(qualityRecord);
    return result;
  }
}
