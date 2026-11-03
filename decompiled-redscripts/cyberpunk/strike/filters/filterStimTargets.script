
public class FilterStimTargets extends EffectObjectSingleFilter_Scripted {

  public final func Process(ctx: EffectScriptContext, filterCtx: EffectSingleFilterScriptContext) -> Bool {
    let entity: ref<Entity>;
    let puppet: ref<NPCPuppet>;
    let targets: array<NPCstubData>;
    let targetsVariant: Variant;
    EffectData.GetVariant(EffectScriptContext.GetSharedData(ctx), GetAllBlackboardDefs().EffectSharedData.targets, targetsVariant);
    if IsDefined(targetsVariant) {
      targets = FromVariant<array<NPCstubData>>(targetsVariant);
    };
    if ArraySize(targets) <= 0 {
      return true;
    };
    entity = EffectSingleFilterScriptContext.GetEntity(filterCtx);
    puppet = entity as NPCPuppet;
    if IsDefined(puppet) {
      return this.EvaluateTarget(puppet, targets);
    };
    return false;
  }

  private final func EvaluateTarget(puppet: ref<NPCPuppet>, const targets: script_ref<[NPCstubData]>) -> Bool {
    let i: Int32 = 0;
    while i < ArraySize(Deref(targets)) {
      if puppet.CheckStubData(Deref(targets)[i]) {
        return true;
      };
      i += 1;
    };
    return false;
  }
}
