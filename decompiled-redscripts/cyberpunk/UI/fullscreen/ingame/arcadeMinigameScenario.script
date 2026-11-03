
public class MenuScenario_ArcadeMinigame extends MenuScenario_BaseMenu {

  protected cb func OnEnterScenario(prevScenario: CName, userData: ref<IScriptable>) -> Bool {
    let minigameUserData: ref<ArcadeMinigameUserData> = userData as ArcadeMinigameUserData;
    this.SwitchMenu(minigameUserData.GetMinigameName());
  }

  protected cb func OnBack() -> Bool;

  protected cb func OnCloseHubMenuRequest() -> Bool;

  protected cb func OnArcadeMinigameEnd() -> Bool {
    this.GotoIdleState();
  }
}

public class ArcadeMinigameUserData extends inkUserData {

  public let m_minigame: ArcadeMinigame;

  public final const func GetMinigameName() -> CName {
    switch this.m_minigame {
      case ArcadeMinigame.RoachRace:
        return n"roach_race";
      case ArcadeMinigame.Shooter:
        return n"shooter";
      case ArcadeMinigame.INVALID:
      case ArcadeMinigame.Quadracer:
      case ArcadeMinigame.Retros:
      case ArcadeMinigame.Tank:
        return n"None";
    };
    return n"None";
  }
}
