
public class StrikeFilterSingle_NPC extends EffectObjectSingleFilter_Scripted {

  public edit let onlyAlive: Bool;

  public edit let onlyEnemies: Bool;

  public final func Process(ctx: EffectScriptContext, filterCtx: EffectSingleFilterScriptContext) -> Bool {
    let puppet: ref<NPCPuppet> = EffectSingleFilterScriptContext.GetEntity(filterCtx) as NPCPuppet;
    return IsDefined(puppet) && this.onlyAlive ? ScriptedPuppet.IsAlive(puppet) : true && this.onlyEnemies ? puppet.IsEnemy() : true;
  }
}

public class FilterNPCsByType extends EffectObjectSingleFilter_Scripted {

  public edit const let m_allowedTypes: [gamedataNPCType];

  public edit let m_invert: Bool;

  public final func Process(ctx: EffectScriptContext, filterCtx: EffectSingleFilterScriptContext) -> Bool {
    let isTypeInList: Bool;
    let entity: ref<Entity> = EffectSingleFilterScriptContext.GetEntity(filterCtx);
    let puppet: ref<NPCPuppet> = entity as NPCPuppet;
    if IsDefined(puppet) {
      isTypeInList = ArrayContains(this.m_allowedTypes, puppet.GetNPCType());
      return this.m_invert ? !isTypeInList : isTypeInList;
    };
    return true;
  }
}
