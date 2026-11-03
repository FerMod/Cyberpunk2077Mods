
public class PlayerDoesntHaveQuickhackPrereq extends IScriptablePrereq {

  public let m_quickhackID: TweakDBID;

  protected func Initialize(recordID: TweakDBID) -> Void {
    this.m_quickhackID = TDBID.Create(TweakDBInterface.GetString(recordID + t".quickhack", ""));
  }

  public const func IsFulfilled(game: GameInstance, context: ref<IScriptable>) -> Bool {
    let i: Int32;
    let playersHacks: array<wref<gameItemData>>;
    let result: Bool = true;
    let playerHacksTweak: array<TweakDBID> = PlayerPuppet.GetPlayerQuickHackInCyberDeckTweakDBID(GetPlayer(game));
    GameInstance.GetTransactionSystem(game).GetItemListByTag(GetPlayer(game), n"SoftwareShard", playersHacks);
    i = 0;
    while i < ArraySize(playersHacks) {
      ArrayPush(playerHacksTweak, ItemID.GetTDBID(playersHacks[i].GetID()));
      i += 1;
    };
    i = 0;
    while i < ArraySize(playerHacksTweak) {
      if playerHacksTweak[i] == this.m_quickhackID {
        result = false;
      };
      i += 1;
    };
    return result;
  }
}
