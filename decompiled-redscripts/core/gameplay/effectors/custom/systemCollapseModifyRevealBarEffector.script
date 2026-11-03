
public class SystemCollapseLifetimeEffector extends Effector {

  protected func Uninitialize(game: GameInstance) -> Void {
    StatusEffectHelper.RemoveStatusEffect(GetPlayer(game), t"BaseStatusEffect.SystemCollapseMemoryCostReduction");
  }
}

public class SystemCollapseModifyRevealBarEffector extends Effector {

  public let m_value: Float;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_value = TweakDBInterface.GetFloat(record + t".value", 0.00);
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    this.ProcessEffector(owner);
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    this.ProcessEffector(owner);
  }

  private final func ProcessEffector(owner: ref<GameObject>) -> Void {
    let ownerPuppet: ref<ScriptedPuppet>;
    let poolSys: ref<StatPoolsSystem>;
    let player: ref<PlayerPuppet> = GetPlayer(owner.GetGame());
    if !player.IsBeingRevealed() {
      return;
    };
    poolSys = GameInstance.GetStatPoolsSystem(owner.GetGame());
    ownerPuppet = owner as ScriptedPuppet;
    if IsDefined(ownerPuppet) && ownerPuppet.IsNetrunnerPuppet() {
      StatusEffectHelper.ApplyStatusEffect(player, t"BaseStatusEffect.RevealInterrupted");
    } else {
      poolSys.RequestChangingStatPoolValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatPoolType.QuickHackUpload, this.m_value, owner, true, true);
    };
    StatusEffectHelper.ApplyStatusEffect(player, t"BaseStatusEffect.SystemCollapseMemoryCostReduction");
  }
}
