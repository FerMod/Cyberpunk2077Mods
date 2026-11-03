
public class StrikeExecutor_ApplyStatusEffect extends EffectExecutor_Scripted {

  public final func Process(ctx: EffectScriptContext, applierCtx: EffectExecutionScriptContext) -> Bool {
    let data: EffectData;
    let statPool: Int32;
    let statusEffect: Variant;
    let statusEffectID: TweakDBID;
    let value: Float;
    let target: ref<Entity> = EffectExecutionScriptContext.GetTarget(applierCtx);
    let puppet: ref<ScriptedPuppet> = target as ScriptedPuppet;
    if IsDefined(puppet) {
      data = EffectScriptContext.GetSharedData(ctx);
      EffectData.GetInt(data, GetAllBlackboardDefs().EffectSharedData.statType, statPool);
      EffectData.GetFloat(data, GetAllBlackboardDefs().EffectSharedData.value, value);
      EffectData.GetVariant(data, GetAllBlackboardDefs().EffectSharedData.statusEffect, statusEffect);
      statusEffectID = FromVariant<TweakDBID>(statusEffect);
      GameInstance.GetStatusEffectSystem(puppet.GetGame()).ApplyStatusEffect(puppet.GetEntityID(), statusEffectID);
      return true;
    };
    return true;
  }
}
