
public class RipperdocTokenManager extends IScriptable {

  public let m_player: wref<PlayerPuppet>;

  public let m_tokenBlackboard: wref<IBlackboard>;

  public let m_gameInstance: GameInstance;

  public final func Initialize(player: wref<PlayerPuppet>) -> Void {
    this.m_player = player;
    this.m_gameInstance = this.m_player.GetGame();
    this.m_tokenBlackboard = GameInstance.GetBlackboardSystem(this.m_player.GetGame()).Get(GetAllBlackboardDefs().TokenUpgradedCyberwareBlackboard);
  }

  public final func IfPlayerHasTokens() -> Bool {
    return GameInstance.GetTransactionSystem(this.m_gameInstance).HasItem(this.m_player, ItemID.CreateQuery(t"Items.StatsToken"));
  }

  public final func GetTokensAmount() -> Int32 {
    let itemID: ItemID = ItemID.CreateQuery(t"Items.StatsToken");
    return GameInstance.GetTransactionSystem(this.m_gameInstance).GetItemQuantity(this.m_player, itemID);
  }

  public final func IsItemUpgraded(cyberwareItem: ItemID) -> Bool {
    let cyberwareTypesList: array<CName> = FromVariant<array<CName>>(this.m_tokenBlackboard.GetVariant(GetAllBlackboardDefs().TokenUpgradedCyberwareBlackboard.CyberwareTypes));
    let cyberwareType: CName = TweakDBInterface.GetCName(ItemID.GetTDBID(cyberwareItem) + t".cyberwareType", n"None");
    return ArrayContains(cyberwareTypesList, cyberwareType);
  }

  public final func ApplyToken(cyberwareItemID: ItemID) -> Void {
    let cyberwareTypesList: array<CName> = FromVariant<array<CName>>(this.m_tokenBlackboard.GetVariant(GetAllBlackboardDefs().TokenUpgradedCyberwareBlackboard.CyberwareTypes));
    let cyberwareType: CName = TweakDBInterface.GetCName(ItemID.GetTDBID(cyberwareItemID) + t".cyberwareType", n"None");
    if this.IsItemUpgraded(cyberwareItemID) {
    } else {
      ArrayPush(cyberwareTypesList, cyberwareType);
      this.m_tokenBlackboard.SetVariant(GetAllBlackboardDefs().TokenUpgradedCyberwareBlackboard.CyberwareTypes, ToVariant(cyberwareTypesList));
    };
  }
}
