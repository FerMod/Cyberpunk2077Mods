
public final native class PlayerSystem extends gamePlayerSystem {

  public final native const func GetGameInstance() -> GameInstance;

  public final native const func GetLocalPlayerMainGameObject() -> ref<GameObject>;

  public final native const func GetLocalPlayerControlledGameObject() -> ref<GameObject>;

  public final native func LocalPlayerControlExistingObject(entityID: EntityID) -> Void;

  public final native func RegisterPlayerPuppetAttachedCallback(object: ref<IScriptable>, func: CName) -> Uint32;

  public final native func UnregisterPlayerPuppetAttachedCallback(callbackID: Uint32) -> Void;

  public final native func RegisterPlayerPuppetDetachedCallback(object: ref<IScriptable>, func: CName) -> Uint32;

  public final native func UnregisterPlayerPuppetDetachedCallback(callbackID: Uint32) -> Void;

  public final native func FindPlayerControlledObjects(position: Vector4, radius: Float, includeLocalPlayers: Bool, includeRemotePlayers: Bool, out outPlayerGameObjects: [ref<GameObject>]) -> Uint32;

  public final native func IsInFreeCamera() -> Bool;

  public final native func SetFreeCameraTransform(newTransform: Transform) -> Void;

  public final native func IsCPOControlSchemeForced() -> Bool;

  public final const func GetPossessedByJohnnyFactName() -> String {
    return "isPlayerPossessedByJohnny";
  }

  protected final cb func OnGameRestored() -> Bool {
    if Cast<Bool>(GameInstance.GetQuestsSystem(this.GetGameInstance()).GetFactStr(this.GetPossessedByJohnnyFactName())) {
      this.OnLocalPlayerPossesionChanged(gamedataPlayerPossesion.Johnny);
    } else {
      this.OnLocalPlayerPossesionChanged(gamedataPlayerPossesion.Default);
    };
    return true;
  }

  protected final cb func OnShutdown() -> Bool {
    this.OnLocalPlayerPossesionChanged(gamedataPlayerPossesion.Default);
    return true;
  }

  protected final cb func OnLocalPlayerChanged(controlledObject: wref<GameObject>) -> Bool {
    let controlledPuppetRecordID: TweakDBID;
    let playerStatsBB: ref<IBlackboard>;
    let controlledPuppet: ref<gamePuppetBase> = controlledObject as gamePuppetBase;
    if controlledPuppet == null {
      return false;
    };
    playerStatsBB = GameInstance.GetBlackboardSystem(this.GetGameInstance()).Get(GetAllBlackboardDefs().UI_PlayerStats);
    controlledPuppetRecordID = controlledPuppet.GetRecordID();
    if controlledPuppetRecordID == t"Character.Player_Puppet_Base" {
      playerStatsBB.SetBool(GetAllBlackboardDefs().UI_PlayerStats.isReplacer, false, true);
    } else {
      if controlledPuppetRecordID == t"Character.johnny_replacer" {
        playerStatsBB.SetBool(GetAllBlackboardDefs().UI_PlayerStats.isReplacer, true, true);
      } else {
        if controlledPuppetRecordID == t"Character.kurt_replacer" {
          playerStatsBB.SetBool(GetAllBlackboardDefs().UI_PlayerStats.isReplacer, true, true);
        } else {
          playerStatsBB.SetBool(GetAllBlackboardDefs().UI_PlayerStats.isReplacer, true, true);
        };
      };
    };
    return true;
  }

  protected final cb func OnLocalPlayerPossesionChanged(playerPossesion: gamedataPlayerPossesion) -> Bool {
    let uiSystem: ref<UISystem> = GameInstance.GetUISystem(this.GetGameInstance());
    if Equals(playerPossesion, gamedataPlayerPossesion.Default) {
      if IsDefined(uiSystem) {
        uiSystem.ClearGlobalThemeOverride();
      };
    } else {
      if Equals(playerPossesion, gamedataPlayerPossesion.Johnny) {
        if IsDefined(uiSystem) {
          uiSystem.SetGlobalThemeOverride(n"Possessed");
        };
      };
    };
    return true;
  }
}
