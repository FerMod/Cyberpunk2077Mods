
public class sampleTimeListener extends TimeDilationListener {

  public let myOwner: wref<sampleTimeDilatable>;

  protected cb func OnFinished(reason: CName) -> Bool {
    this.myOwner.OnFinished(reason);
  }

  public final func SetOwner(owner: ref<sampleTimeDilatable>) -> Void {
    this.myOwner = owner;
  }
}

public class sampleTimeDilatable extends TimeDilatable {

  public let listener: ref<sampleTimeListener>;

  protected cb func OnGameAttached() -> Bool {
    if !IsDefined(this.listener) {
      this.listener = new sampleTimeListener();
      this.listener.SetOwner(this);
    };
  }

  protected cb func OnInteractionChoice(choice: ref<InteractionChoiceEvent>) -> Bool {
    GameInstance.GetTimeSystem(this.GetGame()).SetTimeDilation(n"ScriptsDebug", 0.20, 2.00, n"Linear", n"Log", this.listener);
  }

  protected cb func OnTimeDilationFinished() -> Bool;

  public final func OnFinished(reason: CName) -> Void {
    if Equals(reason, n"ScriptsDebug") {
    };
  }
}
