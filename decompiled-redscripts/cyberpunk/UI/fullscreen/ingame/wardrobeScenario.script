
public class MenuScenario_Wardrobe extends MenuScenario_BaseMenu {

  protected cb func OnEnterScenario(prevScenario: CName, userData: ref<IScriptable>) -> Bool {
    this.SwitchMenu(n"wardrobe", userData);
  }

  protected cb func OnWardrobeClose() -> Bool {
    this.GotoIdleState();
  }

  protected func GotoIdleState() -> Void {
    this.SwitchToScenario(n"MenuScenario_Idle");
  }
}
