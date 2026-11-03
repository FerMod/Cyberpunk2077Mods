
public class FilterNPCDodgeOpportunity extends EffectObjectGroupFilter_Scripted {

  @default(FilterNPCDodgeOpportunity, false)
  private edit let m_applyToTechWeapons: Bool;

  @default(FilterNPCDodgeOpportunity, true)
  private edit let m_doDodgingTargetsGetFilteredOut: Bool;

  public final func Process(ctx: EffectScriptContext, out filterCtx: EffectGroupFilterScriptContext) -> Bool {
    let aiHumanComponent: ref<AIHumanComponent>;
    let dodgingIndices: array<Int32>;
    let enemyVisible: Bool;
    let gameInstance: GameInstance;
    let i: Int32;
    let instigatorID: EntityID;
    let newResults: array<Int32>;
    let numAgents: Int32;
    let targetNPC: ref<NPCPuppet>;
    let weapon: ref<WeaponObject>;
    let instigator: ref<GameObject> = EffectScriptContext.GetInstigator(ctx) as GameObject;
    if !IsDefined(instigator) {
      return true;
    };
    instigatorID = instigator.GetEntityID();
    if GameInstance.GetStatsSystem(EffectScriptContext.GetGameInstance(ctx)).GetStatBoolValue(Cast<StatsObjectID>(instigatorID), gamedataStatType.HasKerenzikovOmen) {
      return false;
    };
    weapon = EffectScriptContext.GetWeapon(ctx) as WeaponObject;
    if !IsDefined(weapon) {
      return true;
    };
    numAgents = EffectGroupFilterScriptContext.GetNumAgents(filterCtx);
    gameInstance = EffectScriptContext.GetGameInstance(ctx);
    i = 0;
    while i < numAgents {
      targetNPC = EffectGroupFilterScriptContext.GetEntity(filterCtx, i) as NPCPuppet;
      if !IsDefined(targetNPC) {
      } else {
        if ScriptedPuppet.IsDefeated(targetNPC) || !ScriptedPuppet.IsAlive(targetNPC) {
        } else {
          if !this.m_applyToTechWeapons && Equals(weapon.GetWeaponRecord().Evolution().Type(), gamedataWeaponEvolution.Tech) {
            if !StatusEffectSystem.ObjectHasStatusEffect(targetNPC, t"BaseStatusEffect.ForceAllowTechWeaponDodge") {
            } else {
              aiHumanComponent = targetNPC.GetAIControllerComponent();
              if !IsDefined(aiHumanComponent) {
              } else {
                if Equals(GameObject.GetAttitudeBetween(instigator, targetNPC), EAIAttitude.AIA_Friendly) {
                } else {
                  enemyVisible = false;
                  if IsDefined(instigator as PlayerPuppet) {
                    enemyVisible = GameInstance.GetTargetingSystem(gameInstance).IsVisibleTarget(instigator, targetNPC);
                  } else {
                    enemyVisible = GameInstance.GetSenseManager(gameInstance).IsObjectVisible(instigator.GetEntityID(), targetNPC.GetEntityID());
                  };
                  if enemyVisible && aiHumanComponent.TryBulletDodgeOpportunity() && this.m_doDodgingTargetsGetFilteredOut {
                    ArrayPush(dodgingIndices, i);
                  };
                };
              };
            };
          };
          aiHumanComponent = targetNPC.GetAIControllerComponent();
          if !IsDefined(aiHumanComponent) {
          } else {
            if Equals(GameObject.GetAttitudeBetween(instigator, targetNPC), EAIAttitude.AIA_Friendly) {
            } else {
              enemyVisible = false;
              if IsDefined(instigator as PlayerPuppet) {
                enemyVisible = GameInstance.GetTargetingSystem(gameInstance).IsVisibleTarget(instigator, targetNPC);
              } else {
                enemyVisible = GameInstance.GetSenseManager(gameInstance).IsObjectVisible(instigator.GetEntityID(), targetNPC.GetEntityID());
              };
              if enemyVisible && aiHumanComponent.TryBulletDodgeOpportunity() && this.m_doDodgingTargetsGetFilteredOut {
                ArrayPush(dodgingIndices, i);
              };
            };
          };
        };
      };
      i = i + 1;
    };
    if ArraySize(dodgingIndices) > 0 {
      i = 0;
      while i < numAgents {
        if !ArrayContains(dodgingIndices, i) {
          ArrayPush(newResults, i);
        };
        i = i + 1;
      };
      filterCtx.resultIndices = newResults;
    };
    return true;
  }
}
