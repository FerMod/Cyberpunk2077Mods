
public class UseSandevistanAction extends UseAction {

  public func StartAction(gameInstance: GameInstance) -> Void {
    let psmEvent: ref<PSMPostponedParameterBool>;
    let player: ref<PlayerPuppet> = this.GetExecutor() as PlayerPuppet;
    super.StartAction(gameInstance);
    if IsDefined(player) {
      psmEvent = new PSMPostponedParameterBool();
      psmEvent.value = true;
      psmEvent.id = n"requestSandevistanActivation";
      GameInstance.GetTelemetrySystem(gameInstance).LogActiveCyberwareUsed(player, this.GetItemData().GetID());
      player.QueueEvent(psmEvent);
      player.IconicCyberwareActivated();
    };
  }
}

public class DisableSandevistanAction extends UseAction {

  public func StartAction(gameInstance: GameInstance) -> Void {
    let psmEvent: ref<PSMPostponedParameterBool>;
    let player: ref<PlayerPuppet> = this.GetExecutor() as PlayerPuppet;
    super.StartAction(gameInstance);
    if IsDefined(player) {
      if GameInstance.GetStatusEffectSystem(player.GetGame()).HasStatusEffect(player.GetEntityID(), t"BaseStatusEffect.PlayerInFinisherWorkspot") {
        return;
      };
      psmEvent = new PSMPostponedParameterBool();
      psmEvent.id = n"requestSandevistanDeactivation";
      psmEvent.value = true;
      player.QueueEvent(psmEvent);
      StatusEffectHelper.RemoveStatusEffect(player, t"BaseStatusEffect.Tech_Master_Perk_2_Buff");
    };
  }
}
