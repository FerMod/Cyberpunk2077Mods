
public class MenuScenario_Storage extends MenuScenario_BaseMenu {

  protected cb func OnEnterScenario(prevScenario: CName, userData: ref<IScriptable>) -> Bool {
    this.OpenMenu(n"vendor_hub_menu", userData, ScreenDisplayContext.Storage);
    this.SwitchMenu(n"fullscreen_vendor", userData, ScreenDisplayContext.Storage);
  }

  protected cb func OnLeaveScenario(nextScenario: CName) -> Bool {
    if NotEquals(this.m_currMenuName, n"None") {
      this.GetMenusState().DispatchEvent(this.m_currMenuName, n"OnBeforeLeaveScenario");
      this.m_currMenuName = n"None";
    };
    super.OnLeaveScenario(nextScenario);
  }

  protected cb func OnVendorClose() -> Bool {
    this.GotoIdleState();
  }

  protected func GotoIdleState() -> Void {
    this.GetMenusState().DispatchEvent(n"vendor_hub_menu", n"OnBack");
    this.SwitchToScenario(n"MenuScenario_Idle");
  }

  protected cb func OnCloseHubMenuRequest() -> Bool {
    this.GotoIdleState();
  }
}
