
public class ModifyStaminaHandlerEffector extends Effector {

  private let m_opSymbol: CName;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_opSymbol = TweakDBInterface.GetCName(record + t".opSymbol", n"None");
  }

  protected func Uninitialize(game: GameInstance) -> Void {
    let handler: ref<PlayerWeaponHandlingModifiers>;
    let player: ref<PlayerPuppet> = GetPlayer(game);
    if IsDefined(player) {
      handler = player.GetPlayerWeaponHandler();
      handler.ModifyOpSymbol(n"none");
    };
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    let handler: ref<PlayerWeaponHandlingModifiers>;
    let player: ref<PlayerPuppet> = owner as PlayerPuppet;
    if IsDefined(player) {
      handler = player.GetPlayerWeaponHandler();
      handler.ModifyOpSymbol(this.m_opSymbol);
    };
  }

  protected func ActionOff(owner: ref<GameObject>) -> Void {
    let handler: ref<PlayerWeaponHandlingModifiers>;
    let player: ref<PlayerPuppet> = owner as PlayerPuppet;
    if IsDefined(player) {
      handler = player.GetPlayerWeaponHandler();
      handler.ModifyOpSymbol(n"none");
    };
  }
}
