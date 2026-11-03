
public class KurtzComponent extends ScriptableComponent {

  private final func OnGameAttach() -> Void;

  protected cb func OnAIEvent(aiEvent: ref<AIEvent>) -> Bool {
    switch aiEvent.name {
      case n"ScannerOn":
        GameObject.StartReplicatedEffectEvent(this.GetOwner(), n"scanner");
        break;
      case n"ScannerOff":
        GameObject.BreakReplicatedEffectLoopEvent(this.GetOwner(), n"scanner");
    };
  }

  private final func OnGameDetach() -> Void {
    GameObject.BreakReplicatedEffectLoopEvent(this.GetOwner(), n"scanner");
  }

  protected cb func OnDefeated(evt: ref<DefeatedEvent>) -> Bool {
    GameObject.BreakReplicatedEffectLoopEvent(this.GetOwner(), n"scanner");
  }

  protected cb func OnDeath(evt: ref<gameDeathEvent>) -> Bool {
    GameObject.BreakReplicatedEffectLoopEvent(this.GetOwner(), n"scanner");
  }
}
