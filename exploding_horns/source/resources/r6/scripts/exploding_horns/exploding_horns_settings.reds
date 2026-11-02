module ExplodingHorns

public class ExplodingHornsSettings extends ScriptableSystem {
  @runtimeProperty("ModSettings.mod", "Exploding Horns")
  @runtimeProperty("ModSettings.displayName", "Explosion delay")
  @runtimeProperty("ModSettings.description", "Seconds between the horn and explosion.")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "10.0")
  @runtimeProperty("ModSettings.step", "0.1")
  public let playerDelay: Float = 1.0;

  @if(ModuleExists("ModSettingsModule"))
  public func OnAttach() -> Void {
    ModSettings.RegisterListenerToClass(this);
  }

  @if(ModuleExists("ModSettingsModule"))
  public func OnDetach() -> Void {
    ModSettings.UnregisterListenerToClass(this);
  }

  public final static func Get(gameInstance: GameInstance) -> ref<ExplodingHornsSettings> {
    return GameInstance
      .GetScriptableSystemsContainer(gameInstance)
      .Get(NameOf<ExplodingHornsSettings>()) as ExplodingHornsSettings;
  }
}

