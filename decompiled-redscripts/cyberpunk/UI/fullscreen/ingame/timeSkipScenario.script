
public class MenuScenario_TimeSkip extends MenuScenario_BaseMenu {

  protected cb func OnEnterScenario(prevScenario: CName, userData: ref<IScriptable>) -> Bool {
    this.GetMenusState().OpenMenu(n"time_skip");
    this.SetCursorVisibility(true);
  }

  protected cb func OnTimeSkipPopupClosed() -> Bool {
    this.SetCursorVisibility(false);
    this.GotoIdleState();
  }

  private final func SetCursorVisibility(visible: Bool) -> Void {
    let evt: ref<inkMenuLayer_SetCursorVisibility> = new inkMenuLayer_SetCursorVisibility();
    evt.Init(visible);
    this.QueueEvent(evt);
  }
}
