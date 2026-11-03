
public native class gameEffectExecutor_BulletImpact extends EffectExecutor {

  public final func GetImpactMaterialOverride(ctx: EffectScriptContext, isMelee: Bool, orginalHitMaterial: CName, target: ref<Entity>, hitPosition: Vector4, hitDirection: Vector4) -> CName {
    let aiComponent: ref<AIHumanComponent>;
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(EffectScriptContext.GetGameInstance(ctx));
    let result: CName = orginalHitMaterial;
    let ignoreArmor: Bool = WeaponObject.CanIgnoreArmor(EffectScriptContext.GetWeapon(ctx) as WeaponObject) > 0.25;
    if !ignoreArmor && statsSystem.GetStatValue(Cast<StatsObjectID>(target.GetEntityID()), gamedataStatType.Armor) > 0.00 || Equals(RPGManager.CalculatePowerDifferential(target as GameObject), gameEPowerDifferential.IMPOSSIBLE) {
      result = n"cyberware_metal.physmat";
    } else {
      if Equals(orginalHitMaterial, n"cyberware_metal.physmat") && ignoreArmor {
        result = n"character_flesh.physmat";
      } else {
        if isMelee {
          aiComponent = (target as ScriptedPuppet).GetAIControllerComponent();
          if aiComponent.GetActionBlackboard().GetBool(GetAllBlackboardDefs().AIAction.attackParried) || aiComponent.GetActionBlackboard().GetBool(GetAllBlackboardDefs().AIAction.attackBlocked) {
            result = n"None";
          };
        };
      };
    };
    return result;
  }
}
