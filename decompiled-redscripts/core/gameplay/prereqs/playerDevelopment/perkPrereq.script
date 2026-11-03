
public class PerkPrereq extends IScriptablePrereq {

  public let m_invert: Bool;

  public let m_perk: gamedataPerkType;

  protected func Initialize(recordID: TweakDBID) -> Void {
    let str: String = TweakDBInterface.GetString(recordID + t".perk", "");
    this.m_invert = TDB.GetBool(recordID + t".invert");
    this.m_perk = IntEnum<gamedataPerkType>(Cast<Int32>(EnumValueFromString("gamedataPerkType", str)));
  }

  public const func IsFulfilled(game: GameInstance, context: ref<IScriptable>) -> Bool {
    let owner: ref<GameObject> = context as GameObject;
    let result: Bool = PlayerDevelopmentSystem.GetData(owner).HasPerk(this.m_perk);
    if this.m_invert {
      return !result;
    };
    return result;
  }
}

public class IsNewPerkBoughtPrereq extends IScriptablePrereq {

  public let m_invert: Bool;

  public let m_perkType: gamedataNewPerkType;

  public let m_level: Int32;

  protected func Initialize(recordID: TweakDBID) -> Void {
    let str: String = TweakDBInterface.GetString(recordID + t".perkType", "");
    this.m_perkType = IntEnum<gamedataNewPerkType>(Cast<Int32>(EnumValueFromString("gamedataNewPerkType", str)));
    this.m_invert = TDB.GetBool(recordID + t".invert");
    this.m_level = TweakDBInterface.GetInt(recordID + t".level", 0);
  }

  public const func IsFulfilled(game: GameInstance, context: ref<IScriptable>) -> Bool {
    let owner: ref<GameObject> = context as GameObject;
    let result: Bool = PlayerDevelopmentSystem.GetData(owner).IsNewPerkBought(this.m_perkType) == this.m_level;
    if this.m_invert {
      return !result;
    };
    return result;
  }
}

public class PlayerIsNewPerkBoughtPrereqState extends PrereqState {

  public let m_listenerPerksVariant: ref<CallbackHandle>;

  public let m_owner: wref<GameObject>;

  protected cb func OnPerkStateUpdate(value: Variant) -> Bool {
    let prereq: ref<PlayerIsNewPerkBoughtPrereq> = this.GetPrereq() as PlayerIsNewPerkBoughtPrereq;
    let checkPassed: Bool = prereq.IsFulfilled(this.m_owner.GetGame(), this.m_owner);
    this.OnChanged(checkPassed);
  }
}

public class PlayerIsNewPerkBoughtPrereq extends IScriptablePrereq {

  public let m_invert: Bool;

  public let m_perkType: gamedataNewPerkType;

  public let m_level: Int32;

  protected const func OnRegister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Bool {
    let bb: ref<IBlackboard>;
    let castedState: ref<PlayerIsNewPerkBoughtPrereqState> = state as PlayerIsNewPerkBoughtPrereqState;
    castedState.m_owner = context as GameObject;
    let player: ref<PlayerPuppet> = context as PlayerPuppet;
    if IsDefined(player) {
      bb = GameInstance.GetBlackboardSystem(game).Get(GetAllBlackboardDefs().UI_PlayerStats);
      castedState.m_listenerPerksVariant = bb.RegisterListenerVariant(GetAllBlackboardDefs().UI_PlayerStats.Perks, castedState, n"OnPerkStateUpdate");
    };
    return false;
  }

  protected const func OnUnregister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Void {
    let bb: ref<IBlackboard>;
    let castedState: ref<PlayerIsNewPerkBoughtPrereqState>;
    let player: ref<PlayerPuppet> = context as PlayerPuppet;
    if IsDefined(player) {
      castedState = state as PlayerIsNewPerkBoughtPrereqState;
      if IsDefined(castedState.m_listenerPerksVariant) {
        bb = GameInstance.GetBlackboardSystem(game).Get(GetAllBlackboardDefs().UI_PlayerStats);
        bb.UnregisterListenerVariant(GetAllBlackboardDefs().UI_PlayerStats.Perks, castedState.m_listenerPerksVariant);
      };
    };
  }

  protected func Initialize(recordID: TweakDBID) -> Void {
    let str: String = TweakDBInterface.GetString(recordID + t".perkType", "");
    this.m_perkType = IntEnum<gamedataNewPerkType>(Cast<Int32>(EnumValueFromString("gamedataNewPerkType", str)));
    this.m_invert = TDB.GetBool(recordID + t".invert");
    this.m_level = TweakDBInterface.GetInt(recordID + t".level", 0);
  }

  protected const func OnApplied(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Void {
    let castedState: ref<PlayerIsNewPerkBoughtPrereqState> = state as PlayerIsNewPerkBoughtPrereqState;
    castedState.OnChanged(this.IsFulfilled(game, context));
  }

  public const func IsFulfilled(game: GameInstance, context: ref<IScriptable>) -> Bool {
    let player: ref<GameObject> = GameInstance.GetPlayerSystem(game).GetLocalPlayerControlledGameObject();
    let result: Bool = PlayerDevelopmentSystem.GetData(player).IsNewPerkBought(this.m_perkType) >= this.m_level;
    if this.m_invert {
      return !result;
    };
    return result;
  }
}
