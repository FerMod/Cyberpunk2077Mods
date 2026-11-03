
public class UseBerserkAction extends UseAction {

  public func StartAction(gameInstance: GameInstance) -> Void {
    let psmEvent: ref<PSMPostponedParameterBool>;
    let player: ref<PlayerPuppet> = this.GetExecutor() as PlayerPuppet;
    super.StartAction(gameInstance);
    if IsDefined(player) {
      psmEvent = new PSMPostponedParameterBool();
      psmEvent.id = n"OnBerserkActivated";
      psmEvent.value = true;
      player.QueueEvent(psmEvent);
      GameObject.PlaySound(player, n"slow");
      GameInstance.GetTelemetrySystem(gameInstance).LogActiveCyberwareUsed(player, this.GetItemData().GetID());
      GameInstance.GetRazerChromaEffectsSystem(gameInstance).PlayAnimation(n"Berserk", true);
    };
  }
}

public class DisableBerserkAction extends UseAction {

  public func StartAction(gameInstance: GameInstance) -> Void {
    let player: ref<PlayerPuppet> = this.GetExecutor() as PlayerPuppet;
    super.StartAction(gameInstance);
    if IsDefined(player) {
      StatusEffectHelper.RemoveAllStatusEffectsByType(gameInstance, player.GetEntityID(), gamedataStatusEffectType.Berserk);
      GameInstance.GetStatPoolsSystem(player.GetGame()).RequestSettingStatPoolMinValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatPoolType.BerserkCharge, player);
      GameInstance.GetRazerChromaEffectsSystem(gameInstance).StopAnimation(n"Berserk");
    };
  }
}
