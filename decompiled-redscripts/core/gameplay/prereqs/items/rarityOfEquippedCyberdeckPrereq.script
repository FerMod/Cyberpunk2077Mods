
public class RarityOfEquippedCyberdeckPrereq extends IScriptablePrereq {

  public let m_minimumQuality: Int32;

  protected func Initialize(recordID: TweakDBID) -> Void {
    this.m_minimumQuality = TweakDBInterface.GetInt(recordID + t".minimumQuality", 0);
  }

  public const func IsFulfilled(game: GameInstance, context: ref<IScriptable>) -> Bool {
    let deckQuality: Int32;
    let result: Bool;
    let player: ref<PlayerPuppet> = GetPlayer(game);
    let systemReplacementID: ItemID = EquipmentSystem.GetData(player).GetActiveItem(gamedataEquipmentArea.SystemReplacementCW);
    if EquipmentSystem.IsCyberdeckEquipped(player) {
      deckQuality = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(systemReplacementID)).Quality().Value();
    };
    result = deckQuality == this.m_minimumQuality;
    return result;
  }
}
