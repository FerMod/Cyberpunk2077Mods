
public struct GameTimeUtils {

  public final static func CanPlayerTimeSkip(playerPuppet: ref<PlayerPuppet>) -> Bool {
    let autoDriveSystem: wref<AutoDriveSystem>;
    let psmVehicle: Int32;
    let securityData: SecurityAreaData;
    let timeSystem: ref<TimeSystem>;
    let blockTimeSkip: Bool = false;
    let tier: Int32 = playerPuppet.GetPlayerStateMachineBlackboard().GetInt(GetAllBlackboardDefs().PlayerStateMachine.HighLevel);
    let psmBlackboard: ref<IBlackboard> = playerPuppet.GetPlayerStateMachineBlackboard();
    let variantData: Variant = psmBlackboard.GetVariant(GetAllBlackboardDefs().PlayerStateMachine.SecurityZoneData);
    if IsDefined(variantData) {
      securityData = FromVariant<SecurityAreaData>(variantData);
    };
    psmVehicle = psmBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Vehicle);
    autoDriveSystem = GameInstance.GetScriptableSystemsContainer(playerPuppet.GetGame()).Get(n"AutoDriveSystem") as AutoDriveSystem;
    blockTimeSkip = psmBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat) == 1 || StatusEffectSystem.ObjectHasStatusEffectWithTag(playerPuppet, n"NoTimeSkip") || timeSystem.IsPausedState() || playerPuppet.IsMovingVertically() || psmBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Swimming) == 2 || psmVehicle == 4 || psmVehicle == 1 && VehicleComponent.GetOwnerVehicleSpeed(playerPuppet.GetGame(), playerPuppet) > 13.80 || tier >= 3 && tier <= 5 || securityData.securityAreaType > ESecurityAreaType.SAFE || GameInstance.GetPhoneManager(playerPuppet.GetGame()).IsPhoneCallActive() || psmBlackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.Carrying) || psmBlackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.IsInLoreAnimationScene) || playerPuppet.GetPreventionSystem().IsChasingPlayer() || HubMenuUtility.IsPlayerHardwareDisabled(playerPuppet) || autoDriveSystem.GetAutodriveEnabled();
    return !blockTimeSkip;
  }

  public final static func IsTimeDisplayGlitched(playerPuppet: ref<PlayerPuppet>) -> Bool {
    let blockTimeSkip: Bool = false;
    blockTimeSkip = StatusEffectSystem.ObjectHasStatusEffectWithTag(playerPuppet, n"NoTimeDisplay");
    return blockTimeSkip;
  }

  public final static func UpdateGameTimeText(timeSystem: ref<TimeSystem>, textWidgetRef: inkTextRef, textParamsRef: ref<inkTextParams>, opt addSeconds: Int32) -> Void {
    let gameTime: GameTime;
    if timeSystem == null {
      return;
    };
    gameTime = timeSystem.GetGameTime();
    gameTime += addSeconds;
    GameTimeUtils.SetGameTimeText(textWidgetRef, textParamsRef, gameTime);
  }

  public final static func SetGameTimeText(textWidgetRef: inkTextRef, textParamsRef: ref<inkTextParams>, gameTime: GameTime) -> Void {
    if textParamsRef == null {
      textParamsRef = new inkTextParams();
      textParamsRef.AddNCGameTime("VALUE", gameTime);
      inkTextRef.SetText(textWidgetRef, "{VALUE,time,short}", textParamsRef);
    } else {
      textParamsRef.UpdateTime("VALUE", gameTime);
    };
  }

  public final static func FastForwardPlayerState(player: ref<GameObject>) -> Void {
    let effects: array<ref<StatusEffect>>;
    let i: Int32;
    let maxPassiveRegenValue: Float;
    let remainingTime: Float;
    let statPoolsSys: ref<StatPoolsSystem>;
    let statusEffectSys: ref<StatusEffectSystem>;
    if IsDefined(player) {
      statPoolsSys = GameInstance.GetStatPoolsSystem(player.GetGame());
      if IsDefined(statPoolsSys) {
        maxPassiveRegenValue = GameInstance.GetStatsSystem(player.GetGame()).GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.HealthOutOfCombatRegenEndThreshold);
        if statPoolsSys.GetStatPoolValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatPoolType.Health) < maxPassiveRegenValue {
          statPoolsSys.RequestSettingStatPoolValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatPoolType.Health, maxPassiveRegenValue, player);
        };
        statPoolsSys.RequestSettingStatPoolValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatPoolType.Stamina, 100.00, player);
      };
      statusEffectSys = GameInstance.GetStatusEffectSystem(player.GetGame());
      statusEffectSys.GetAppliedEffects(player.GetEntityID(), effects);
      i = 0;
      while i < ArraySize(effects) {
        remainingTime = effects[i].GetRemainingDuration();
        if remainingTime > 0.00 {
          statusEffectSys.RemoveStatusEffect(player.GetEntityID(), effects[i].GetRecord().GetID(), effects[i].GetStackCount());
        };
        i += 1;
      };
    };
  }
}
