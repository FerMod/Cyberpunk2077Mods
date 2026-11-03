
public class EffectExecutor_GivePlayerReward extends EffectExecutor_Scripted {

  public edit let m_reward: TweakDBID;

  @default(EffectExecutor_GivePlayerReward, 1)
  public edit let m_amount: Int32;

  public final func Process(ctx: EffectScriptContext, applierCtx: EffectExecutionScriptContext) -> Bool {
    let player: ref<PlayerPuppet> = EffectScriptContext.GetInstigator(ctx) as PlayerPuppet;
    let targetNPC: ref<NPCPuppet> = EffectExecutionScriptContext.GetTarget(applierCtx) as NPCPuppet;
    let instigator: ref<Entity> = EffectScriptContext.GetInstigator(ctx);
    let target: ref<Entity> = EffectExecutionScriptContext.GetTarget(applierCtx);
    let effect: ref<StatusEffect> = StatusEffectHelper.GetStatusEffectByID(targetNPC, t"BaseStatusEffect.UtilityGrenadeRewardHarvested");
    if !TDBID.IsValid(this.m_reward) || !IsDefined(player) || !IsDefined(targetNPC) || !targetNPC.AwardsExperience() || instigator == target || IsDefined(effect) {
      return true;
    };
    RPGManager.GiveReward(GetGameInstance(), this.m_reward, this.m_amount, Cast<StatsObjectID>(EffectExecutionScriptContext.GetTarget(applierCtx).GetEntityID()));
    StatusEffectHelper.ApplyStatusEffect(targetNPC, t"BaseStatusEffect.UtilityGrenadeRewardHarvested", player.GetEntityID());
    return true;
  }
}
