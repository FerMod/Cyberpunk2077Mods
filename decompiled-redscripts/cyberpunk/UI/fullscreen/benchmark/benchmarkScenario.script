
public class MenuScenario_BenchmarkResults extends MenuScenario_BaseMenu {

  private let m_callbackData: ref<inkCallbackConnectorData>;

  protected cb func OnEnterScenario(prevScenario: CName, userData: ref<IScriptable>) -> Bool {
    this.GetMenusState().OpenMenu(n"benchmark_results_menu", userData);
    this.m_callbackData = userData as inkCallbackConnectorData;
  }

  protected cb func OnBenchmarkResultsClose() -> Bool {
    this.SwitchToScenario(n"MenuScenario_Idle");
    this.m_callbackData.TriggerCallback();
  }

  protected cb func OnBenchmarkSettings() -> Bool {
    let settingsUserData: ref<SettingsMenuUserData> = new SettingsMenuUserData();
    settingsUserData.m_isDlcSettings = false;
    settingsUserData.m_isBenchmarkSettings = true;
    this.OpenSubMenu(n"settings_main", settingsUserData);
  }

  protected cb func OnCloseSettingsScreen() -> Bool {
    let evt: ref<OnBnechmarkHideSettings> = new OnBnechmarkHideSettings();
    this.QueueBroadcastEvent(evt);
    this.CloseSubMenu();
  }
}
