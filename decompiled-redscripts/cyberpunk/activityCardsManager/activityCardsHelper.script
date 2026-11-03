
public class ActivityCardsHelper extends IScriptable {

  public final func CanPlayerSkipTime() -> Bool {
    let securityData: SecurityAreaData;
    let timeSystem: ref<TimeSystem>;
    let blockTimeSkip: Bool = false;
    let playerPuppet: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(GetGameInstance()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    let tier: Int32 = playerPuppet.GetPlayerStateMachineBlackboard().GetInt(GetAllBlackboardDefs().PlayerStateMachine.HighLevel);
    let psmBlackboard: ref<IBlackboard> = playerPuppet.GetPlayerStateMachineBlackboard();
    let variantData: Variant = psmBlackboard.GetVariant(GetAllBlackboardDefs().PlayerStateMachine.SecurityZoneData);
    if IsDefined(variantData) {
      securityData = FromVariant<SecurityAreaData>(variantData);
    };
    blockTimeSkip = psmBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Combat) == 1 || StatusEffectSystem.ObjectHasStatusEffectWithTag(playerPuppet, n"NoTimeSkip") || timeSystem.IsPausedState() || playerPuppet.IsMovingVertically() || psmBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Swimming) == 2 || psmBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Vehicle) == 4 || tier >= 3 && tier <= 5 || securityData.securityAreaType > ESecurityAreaType.SAFE || GameInstance.GetPhoneManager(playerPuppet.GetGame()).IsPhoneCallActive() || psmBlackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.Carrying) || psmBlackboard.GetBool(GetAllBlackboardDefs().PlayerStateMachine.IsInLoreAnimationScene);
    return !blockTimeSkip;
  }

  public final func GetCurrentDisctrictName() -> String {
    let currentLocationName: String;
    let uiBlackboard: ref<IBlackboard> = GameInstance.GetBlackboardSystem(GetGameInstance()).Get(GetAllBlackboardDefs().UI_Map);
    if IsDefined(uiBlackboard) {
      currentLocationName = uiBlackboard.GetString(GetAllBlackboardDefs().UI_Map.currentLocationEnumName);
    };
    return currentLocationName;
  }
}
