
public class ChargedItemsPrereqListener extends BaseStatPoolPrereqListener {

  protected let m_state: wref<ChargedItemsPrereqState>;

  public func OnStatPoolValueChanged(oldValue: Float, newValue: Float, percToPoints: Float) -> Void {
    let currentCharges: Float;
    let maxChargeValue: Float;
    let rechargeDuration: Float;
    let chargesState: EChargesAmount = this.m_state.GetChargesState();
    let chargesStatpool: Float = Cast<Float>(RoundMath(newValue * percToPoints));
    switch this.m_state.getTypeOfItem() {
      case EChargesItem.HealingItems:
        rechargeDuration = Cast<Float>(GetPlayer(this.m_state.m_owner).GetHealingItemUseCost());
        maxChargeValue = GameInstance.GetStatsSystem(this.m_state.m_owner).GetStatValue(Cast<StatsObjectID>(GetPlayer(this.m_state.m_owner).GetEntityID()), gamedataStatType.HealingItemMaxCharges);
        break;
      case EChargesItem.Grenade:
        rechargeDuration = Cast<Float>(GetPlayer(this.m_state.m_owner).GetGrenadeThrowCostClean());
        maxChargeValue = GameInstance.GetStatsSystem(this.m_state.m_owner).GetStatValue(Cast<StatsObjectID>(GetPlayer(this.m_state.m_owner).GetEntityID()), gamedataStatType.GrenadesMaxCharges);
        break;
      case EChargesItem.ProjectileLauncher:
        rechargeDuration = Cast<Float>(GetPlayer(this.m_state.m_owner).GetProjectileLauncherShootCost());
        maxChargeValue = GameInstance.GetStatsSystem(this.m_state.m_owner).GetStatValue(Cast<StatsObjectID>(GetPlayer(this.m_state.m_owner).GetEntityID()), gamedataStatType.ProjectileLauncherMaxCharges);
    };
    currentCharges = chargesStatpool / rechargeDuration;
    if Equals(chargesState, EChargesAmount.Empty) {
      this.m_state.OnChanged(currentCharges < 1.00);
    } else {
      if Equals(chargesState, EChargesAmount.Last) {
        this.m_state.OnChanged(currentCharges >= 1.00 && currentCharges < 2.00);
      } else {
        if Equals(chargesState, EChargesAmount.FirstFromTop) {
          this.m_state.OnChanged(maxChargeValue - 1.00 < currentCharges && currentCharges <= maxChargeValue);
        } else {
          if Equals(chargesState, EChargesAmount.Max) {
            this.m_state.OnChanged(currentCharges == maxChargeValue);
          };
        };
      };
    };
  }

  public func RegisterState(state: ref<PrereqState>) -> Void {
    this.m_state = state as ChargedItemsPrereqState;
  }
}

public class ChargedItemsPrereqState extends PrereqState {

  public let m_chargesState: EChargesAmount;

  public let m_typeOfItem: EChargesItem;

  public let m_listener: ref<BaseStatPoolPrereqListener>;

  public let m_owner: GameInstance;

  public final func SetChargesState(value: EChargesAmount) -> Void {
    this.m_chargesState = value;
  }

  public final func GetChargesState() -> EChargesAmount {
    return this.m_chargesState;
  }

  public final func SetTypeOfItem(value: EChargesItem) -> Void {
    this.m_typeOfItem = value;
  }

  public final func getTypeOfItem() -> EChargesItem {
    return this.m_typeOfItem;
  }
}

public class ChargedItemsPrereq extends IScriptablePrereq {

  public let m_chargesToCheck: EChargesAmount;

  public let m_typeOfItem: EChargesItem;

  protected const func OnRegister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Bool {
    let owner: ref<GameObject> = context as GameObject;
    let castedState: ref<ChargedItemsPrereqState> = state as ChargedItemsPrereqState;
    castedState.SetChargesState(this.m_chargesToCheck);
    castedState.SetTypeOfItem(this.m_typeOfItem);
    castedState.m_listener = new ChargedItemsPrereqListener();
    castedState.m_listener.RegisterState(castedState);
    castedState.m_owner = owner.GetGame();
    switch this.m_typeOfItem {
      case EChargesItem.HealingItems:
        GameInstance.GetStatPoolsSystem(game).RequestRegisteringListener(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatPoolType.HealingItemsCharges, castedState.m_listener);
        break;
      case EChargesItem.Grenade:
        GameInstance.GetStatPoolsSystem(game).RequestRegisteringListener(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatPoolType.GrenadesCharges, castedState.m_listener);
        break;
      case EChargesItem.ProjectileLauncher:
        GameInstance.GetStatPoolsSystem(game).RequestRegisteringListener(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatPoolType.ProjectileLauncherCharges, castedState.m_listener);
    };
    return true;
  }

  protected const func OnUnregister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Void {
    let owner: ref<GameObject> = context as GameObject;
    let castedState: ref<ChargedItemsPrereqState> = state as ChargedItemsPrereqState;
    switch this.m_typeOfItem {
      case EChargesItem.HealingItems:
        GameInstance.GetStatPoolsSystem(game).RequestUnregisteringListener(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatPoolType.HealingItemsCharges, castedState.m_listener);
        break;
      case EChargesItem.Grenade:
        GameInstance.GetStatPoolsSystem(game).RequestUnregisteringListener(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatPoolType.GrenadesCharges, castedState.m_listener);
        break;
      case EChargesItem.ProjectileLauncher:
        GameInstance.GetStatPoolsSystem(game).RequestUnregisteringListener(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatPoolType.ProjectileLauncherCharges, castedState.m_listener);
    };
    castedState.m_listener = null;
  }

  protected func Initialize(recordID: TweakDBID) -> Void {
    let str: String = TweakDBInterface.GetString(recordID + t".howManyCharges", "");
    this.m_chargesToCheck = IntEnum<EChargesAmount>(Cast<Int32>(EnumValueFromString("EChargesAmount", str)));
    str = TweakDBInterface.GetString(recordID + t".typeOfItem", "");
    this.m_typeOfItem = IntEnum<EChargesItem>(Cast<Int32>(EnumValueFromString("EChargesItem", str)));
  }
}
