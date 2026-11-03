
public class HerculesCrosshairtGameController extends IronsightGameController {

  protected edit let m_appearanceFill: Int32;

  protected edit let m_appearanceOutline: Int32;

  protected edit let m_appearanceShowThroughWalls: Bool;

  protected edit let m_appearanceTransitionTime: Float;

  private let m_weaponParamsListenerId: ref<CallbackHandle>;

  private let m_game: GameInstance;

  private let m_visionModeSystem: ref<VisionModeSystem>;

  private let m_targetedApperance: VisionAppearance;

  private let m_targets: [EntityID];

  protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
    super.OnPlayerAttach(playerPuppet);
    this.m_weaponParamsListenerId = this.m_weaponDataBB.RegisterDelayedListenerVariant(GetAllBlackboardDefs().UI_ActiveWeaponData.SmartGunParams, this, n"OnSmartGunParams");
    this.m_game = playerPuppet.GetGame();
    this.m_visionModeSystem = GameInstance.GetVisionModeSystem(this.m_game);
    this.m_targetedApperance.fill = this.m_appearanceFill;
    this.m_targetedApperance.outline = this.m_appearanceOutline;
    this.m_targetedApperance.showThroughWalls = this.m_appearanceShowThroughWalls;
    this.m_targetedApperance.patternType = VisionModePatternType.Default;
  }

  protected cb func OnPlayerDetach(playerPuppet: ref<GameObject>) -> Bool {
    super.OnPlayerDetach(playerPuppet);
    this.m_weaponDataBB.UnregisterDelayedListener(GetAllBlackboardDefs().UI_ActiveWeaponData.SmartGunParams, this.m_weaponParamsListenerId);
  }

  protected cb func OnSmartGunParams(argParams: Variant) -> Bool {
    let contains: Bool;
    let currTargetData: smartGunUITargetParameters;
    let i: Int32;
    let smartData: ref<smartGunUIParameters> = FromVariant<ref<smartGunUIParameters>>(argParams);
    let newTargets: array<smartGunUITargetParameters> = smartData.targets;
    let numTargets: Int32 = ArraySize(smartData.targets);
    if this.IsWeaponActive() && Equals(this.m_upperBodyState, gamePSMUpperBodyStates.Aim) {
      i = 0;
      while i < numTargets {
        currTargetData = newTargets[i];
        contains = ArrayContains(this.m_targets, currTargetData.entityID);
        if Equals(currTargetData.state, gamesmartGunTargetState.Locked) {
          if !contains {
            this.m_visionModeSystem.ForceVisionAppearance(GameInstance.FindEntityByID(this.m_game, currTargetData.entityID) as GameObject, this.m_targetedApperance, this.m_appearanceTransitionTime);
            ArrayPush(this.m_targets, currTargetData.entityID);
          };
        } else {
          if contains {
            ArrayRemove(this.m_targets, currTargetData.entityID);
            if Equals(currTargetData.state, gamesmartGunTargetState.Unlocking) {
              this.m_visionModeSystem.CancelForceVisionAppearance(GameInstance.FindEntityByID(this.m_game, currTargetData.entityID) as GameObject, smartData.timeToUnlock);
            } else {
              this.m_visionModeSystem.CancelForceVisionAppearance(GameInstance.FindEntityByID(this.m_game, currTargetData.entityID) as GameObject, this.m_appearanceTransitionTime);
            };
          };
        };
        i += 1;
      };
    };
  }

  protected cb func OnUpperBodyChanged(state: Int32) -> Bool {
    let i: Int32;
    let limit: Int32;
    let target: ref<GameObject>;
    super.OnUpperBodyChanged(state);
    if state != 6 {
      i = 0;
      limit = ArraySize(this.m_targets);
      while i < limit {
        target = GameInstance.FindEntityByID(this.m_game, this.m_targets[i]) as GameObject;
        if IsDefined(target) {
          this.m_visionModeSystem.CancelForceVisionAppearance(target, this.m_appearanceTransitionTime);
        };
        i += 1;
      };
      ArrayClear(this.m_targets);
    };
  }
}
