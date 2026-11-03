
public class UseCorruptedSandevistanAction extends UseAction {

  public func StartAction(gameInstance: GameInstance) -> Void {
    let player: ref<PlayerPuppet> = this.GetExecutor() as PlayerPuppet;
    super.StartAction(gameInstance);
    if IsDefined(player) {
      this.SetWarningMessage("LocKey#94232");
      if GameInstance.GetStatPoolsSystem(player.GetGame()).HasStatPoolValueReachedMin(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatPoolType.SandevistanCharge) {
        StatusEffectHelper.RemoveStatusEffect(player, t"BaseStatusEffect.NoSandevistanGlitch");
        StatusEffectHelper.RemoveStatusEffect(player, t"BaseStatusEffect.NoCooldownedSandevistanGlitch");
      };
    };
  }

  private final func SetWarningMessage(const lockey: script_ref<String>) -> Void {
    let simpleScreenMessage: SimpleScreenMessage;
    let player: ref<PlayerPuppet> = this.GetExecutor() as PlayerPuppet;
    simpleScreenMessage.isShown = true;
    simpleScreenMessage.duration = 5.00;
    simpleScreenMessage.message = Deref(lockey);
    simpleScreenMessage.isInstant = true;
    GameInstance.GetBlackboardSystem(player.GetGame()).Get(GetAllBlackboardDefs().UI_Notifications).SetVariant(GetAllBlackboardDefs().UI_Notifications.WarningMessage, ToVariant(simpleScreenMessage), true);
  }
}

public class DisableCorruptedSandevistanAction extends UseAction {

  public func StartAction(gameInstance: GameInstance) -> Void {
    let player: ref<PlayerPuppet> = this.GetExecutor() as PlayerPuppet;
    super.StartAction(gameInstance);
    if IsDefined(player) {
      StatusEffectHelper.RemoveStatusEffect(player, t"BaseStatusEffect.NoSandevistanGlitch");
      StatusEffectHelper.RemoveStatusEffect(player, t"BaseStatusEffect.NoCooldownedSandevistanGlitch");
    };
  }
}
