module SelfDestructVehicle

public class SelfDestructVehicleSettings extends ScriptableSystem {
  @runtimeProperty("ModSettings.mod", "Self Destruct Vehicle")
  @runtimeProperty("ModSettings.category", "General")
  @runtimeProperty("ModSettings.category.order", "1")
  @runtimeProperty("ModSettings.displayName", "Detonation Delay")
  @runtimeProperty("ModSettings.description", "Seconds between pressing the key and the vehicle exploding.")
  @runtimeProperty("ModSettings.min", "0.0")
  @runtimeProperty("ModSettings.max", "15.0")
  @runtimeProperty("ModSettings.step", "0.1")
  public let playerDelay: Float = 5.0;

  @runtimeProperty("ModSettings.mod", "Self Destruct Vehicle")
  @runtimeProperty("ModSettings.category", "Key Bindings")
  @runtimeProperty("ModSettings.category.order", "2")
  @runtimeProperty("ModSettings.displayName", "Self Destruct Key")
  @runtimeProperty("ModSettings.description", "Key that detonates your vehicle while driving.")
  public let selfDestructKey: EInputKey = EInputKey.IK_Z;

  @if(ModuleExists("ModSettingsModule"))
  public func OnAttach() -> Void {
    ModSettings.RegisterListenerToClass(this);
  }

  @if(ModuleExists("ModSettingsModule"))
  public func OnDetach() -> Void {
    ModSettings.UnregisterListenerToClass(this);
  }

  public final static func Get(gameInstance: GameInstance) -> ref<SelfDestructVehicleSettings> {
    return GameInstance
      .GetScriptableSystemsContainer(gameInstance)
      .Get(NameOf<SelfDestructVehicleSettings>()) as SelfDestructVehicleSettings;
  }
}

