
public abstract class PlayerStaminaHelpers extends IScriptable {

  public final static func GetSprintStaminaCost() -> Float {
    return TweakDBInterface.GetFloat(t"player.staminaCosts.sprint", 0.00);
  }

  public final static func GetCrouchSprintStaminaCost() -> Float {
    return TweakDBInterface.GetFloat(t"player.staminaCosts.crouchSprint", 0.00);
  }

  public final static func GetSlideStaminaCost() -> Float {
    return TweakDBInterface.GetFloat(t"player.staminaCosts.slide", 0.00);
  }

  public final static func GetJumpStaminaCost() -> Float {
    return TweakDBInterface.GetFloat(t"player.staminaCosts.jump", 0.00);
  }

  public final static func GetDodgeStaminaCost() -> Float {
    return TweakDBInterface.GetFloat(t"player.staminaCosts.dodge", 0.00);
  }

  public final static func GetAirDodgeStaminaCost() -> Float {
    return TweakDBInterface.GetFloat(t"player.staminaCosts.airDodge", 0.00);
  }

  public final static func GetLeapAttackStaminaCost() -> Float {
    return TweakDBInterface.GetFloat(t"player.staminaCosts.leapAttack", 0.00);
  }

  public final static func GetAirLeapAttackStaminaCost() -> Float {
    return TweakDBInterface.GetFloat(t"player.staminaCosts.airLeapAttack", 0.00);
  }

  public final static func GetExhaustedStatusEffectID() -> TweakDBID {
    return t"BaseStatusEffect.PlayerExhausted";
  }

  public final static func GetBlockStaminaDelay() -> Float {
    return TweakDBInterface.GetFloat(t"player.staminaCosts.blockStaminaDelay", 0.00);
  }

  public final static func OnPlayerBlock(player: ref<PlayerPuppet>) -> Void {
    GameObject.StartCooldown(player, n"OnBlockStaminaCooldown", PlayerStaminaHelpers.GetBlockStaminaDelay());
  }

  public final static func ModifyStaminaBasedOnLeapAttackDistance(player: ref<PlayerPuppet>, isPlayerOnGround: Bool, targetDistance: Float, targetMaxDistance: Float) -> Void {
    let staminaReduction: Float;
    if isPlayerOnGround {
      staminaReduction = PlayerStaminaHelpers.GetLeapAttackStaminaCost();
    } else {
      staminaReduction = PlayerStaminaHelpers.GetAirLeapAttackStaminaCost();
    };
    if targetMaxDistance > 0.00 {
      staminaReduction = (staminaReduction * targetDistance) / targetMaxDistance;
    };
    PlayerStaminaHelpers.ModifyStamina(player, -staminaReduction);
  }

  public final static func ModifyStamina(player: ref<PlayerPuppet>, delta: Float, opt perc: Bool) -> Void {
    let canIgnoreStamina: Bool;
    if IsDefined(player) {
      canIgnoreStamina = RPGManager.HasStatFlag(player, gamedataStatType.CanIgnoreStamina);
      if delta != 0.00 && !canIgnoreStamina {
        GameInstance.GetStatPoolsSystem(player.GetGame()).RequestChangingStatPoolValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatPoolType.Stamina, delta, null, false, perc);
      };
    };
  }
}

public abstract class StaminaTransition extends DefaultTransition {

  public let staminaChangeToggle: Bool;

  protected final const func ShouldRegenStamina(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    let locomotionState: Int32;
    let meleeState: Int32;
    let meleeWeaponState: Int32;
    let staminaState: Int32;
    let isBodySlamming: Bool = scriptInterface.localBlackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.IsInBodySlamState);
    if isBodySlamming {
      return false;
    };
    staminaState = scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Stamina);
    if staminaState == 2 {
      return true;
    };
    if scriptInterface.HasStatFlag(gamedataStatType.CanIgnoreStamina) {
      return true;
    };
    meleeWeaponState = scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.MeleeWeapon);
    if meleeWeaponState == 7 {
      return true;
    };
    meleeState = scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Melee);
    if meleeState == 1 {
      return true;
    };
    locomotionState = scriptInterface.localBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.LocomotionDetailed);
    if locomotionState == 7 || locomotionState == 5 || locomotionState == 22 || locomotionState == 25 {
      return false;
    };
    if GameObject.IsCooldownActive(scriptInterface.owner, n"OnBlockStaminaCooldown") {
      return false;
    };
    return true;
  }

  protected final func EnableStaminaPoolRegen(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>, enable: Bool) -> Void {
    let staminaCost: Float = 0.10;
    if !enable {
      if this.staminaChangeToggle {
        staminaCost = staminaCost * -1.00;
      };
      this.staminaChangeToggle = !this.staminaChangeToggle;
      PlayerStaminaHelpers.ModifyStamina(scriptInterface.executionOwner as PlayerPuppet, staminaCost, true);
    };
  }

  protected final func OnUpdate(timeDelta: Float, stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let shouldRegenStamina: Bool = true;
    shouldRegenStamina = this.ShouldRegenStamina(stateContext, scriptInterface);
    this.EnableStaminaPoolRegen(stateContext, scriptInterface, shouldRegenStamina);
  }
}

public class RestedEvents extends StaminaEventsTransition {

  protected final func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.Stamina, 0);
    StatusEffectHelper.RemoveStatusEffect(scriptInterface.executionOwner, t"BaseStatusEffect.PlayerExhausted");
  }
}

public class ExhaustedDecisions extends StaminaTransition {

  private let m_staminaRatioEnterCondition: Float;

  protected func OnAttach(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.m_staminaRatioEnterCondition = TweakDBInterface.GetFloat(t"playerStateMachineStamina.exhausted.staminaRatioEnterCondition", 0.00);
  }

  protected final func EnterCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    let player: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
    let currentExhaustion: Float = player.GetStaminaPercUnsafe() / 100.00;
    if this.IsJuggernautPerkContitionSatisfied(player, scriptInterface) {
      return false;
    };
    return currentExhaustion <= this.m_staminaRatioEnterCondition;
  }

  protected final const func ExitCondition(const stateContext: ref<StateContext>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    let player: ref<PlayerPuppet> = scriptInterface.executionOwner as PlayerPuppet;
    let currentExhaustion: Float = player.GetStaminaPercUnsafe() / 100.00;
    if this.IsJuggernautPerkContitionSatisfied(player, scriptInterface) {
      return true;
    };
    return currentExhaustion > this.m_staminaRatioEnterCondition || scriptInterface.GetStatusEffectSystem().HasStatusEffectOfType(scriptInterface.executionOwnerEntityID, gamedataStatusEffectType.Berserk);
  }

  private final const func IsJuggernautPerkContitionSatisfied(player: ref<PlayerPuppet>, const scriptInterface: ref<StateGameScriptInterface>) -> Bool {
    let statPoolSys: ref<StatPoolsSystem> = GameInstance.GetStatPoolsSystem(player.GetGame());
    let overShieldValue: Float = statPoolSys.GetStatPoolValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatPoolType.Overshield, false);
    let hasUnstoppablePerk: Int32 = PlayerDevelopmentSystem.GetInstance(scriptInterface.executionOwner).IsNewPerkBought(scriptInterface.executionOwner, gamedataNewPerkType.Body_Central_Perk_3_2);
    return hasUnstoppablePerk > 0 && overShieldValue > 0.00;
  }
}

public class ExhaustedEvents extends StaminaEventsTransition {

  public let m_staminaVfxBlackboard: ref<worldEffectBlackboard>;

  public let m_disableStaminaRegenModifier: ref<gameConstantStatModifierData>;

  public let m_player: wref<PlayerPuppet>;

  protected final func OnEnter(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    let animFeature: ref<AnimFeature_Stamina>;
    this.SetBlackboardIntVariable(scriptInterface, GetAllBlackboardDefs().PlayerStateMachine.Stamina, 2);
    StatusEffectHelper.ApplyStatusEffect(scriptInterface.executionOwner, t"BaseStatusEffect.PlayerExhausted");
    GameInstance.GetAudioSystem(scriptInterface.executionOwner.GetGame()).ReplaceTriggerEffect(n"te_wea_melee_swing_exhausted", n"PSM_MeleeAttackGeneric", false);
    this.m_player = scriptInterface.executionOwner as PlayerPuppet;
    this.m_staminaVfxBlackboard = new worldEffectBlackboard();
    if IsDefined(this.m_staminaVfxBlackboard) {
      this.m_staminaVfxBlackboard.SetValue(n"alpha", 1.00);
      GameObjectEffectHelper.StartEffectEvent(scriptInterface.executionOwner, n"status_tired", false, this.m_staminaVfxBlackboard);
    };
    animFeature = new AnimFeature_Stamina();
    animFeature.staminaValue = 0.00;
    animFeature.tiredness = 1.00;
    AnimationControllerComponent.ApplyFeature(scriptInterface.executionOwner, n"StaminaData", animFeature);
  }

  protected final func HandleExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    GameObjectEffectHelper.StopEffectEvent(scriptInterface.executionOwner, n"status_tired");
    this.m_staminaVfxBlackboard = null;
    AnimationControllerComponent.ApplyFeature(scriptInterface.executionOwner, n"StaminaData", new AnimFeature_Stamina());
    StatusEffectHelper.RemoveStatusEffect(scriptInterface.executionOwner, t"BaseStatusEffect.PlayerExhausted");
    GameInstance.GetAudioSystem(scriptInterface.executionOwner.GetGame()).RevertTriggerEffect(n"PSM_MeleeAttackGeneric");
  }

  protected final func OnExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.HandleExit(stateContext, scriptInterface);
  }

  protected final func OnForcedExit(stateContext: ref<StateContext>, scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.HandleExit(stateContext, scriptInterface);
  }
}
