
public class NPCRarityPrereq extends IScriptablePrereq {

  public let m_rarity: gamedataNPCRarity;

  public let m_invert: Bool;

  protected func Initialize(recordID: TweakDBID) -> Void {
    let str: String = TweakDBInterface.GetString(recordID + t".rarity", "");
    this.m_rarity = IntEnum<gamedataNPCRarity>(Cast<Int32>(EnumValueFromString("gamedataNPCRarity", str)));
    this.m_invert = TweakDBInterface.GetBool(recordID + t".invert", false);
  }

  protected const func IsOnRegisterSupported() -> Bool {
    return false;
  }

  protected const func OnApplied(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Void {
    state.OnChanged(this.IsFulfilled(game, context));
  }

  public const func IsFulfilled(game: GameInstance, context: ref<IScriptable>) -> Bool {
    let owner: ref<GameObject> = context as GameObject;
    let targetPuppet: ref<ScriptedPuppet> = owner as ScriptedPuppet;
    let rarity: gamedataNPCRarity = targetPuppet.GetNPCRarity();
    if NotEquals(rarity, this.m_rarity) {
      return this.m_invert ? true : false;
    };
    return this.m_invert ? false : true;
  }
}
