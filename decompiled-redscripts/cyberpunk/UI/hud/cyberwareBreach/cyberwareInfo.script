
public native class HUDCyberwareInfoGameController extends inkHUDGameController {

  @default(HUDCyberwareInfoGameController, cw_reactivated_popup)
  public edit let m_activatePopupAnimName: CName;

  @default(HUDCyberwareInfoGameController, cw_deactivated_popup)
  public edit let m_deactivatePopupAnimName: CName;

  @default(HUDCyberwareInfoGameController, hud_addon_outro)
  public edit let m_activateAnimName: CName;

  @default(HUDCyberwareInfoGameController, hud_addon_intro)
  public edit let m_deactivateAnimName: CName;

  @default(HUDCyberwareInfoGameController, q306_cyberware_deactivated)
  public edit let m_fact: CName;

  public edit let m_hudElement: inkWidgetRef;

  public let m_isCyberwareDeactivated: Bool;

  public let m_popupAnimProxy: ref<inkAnimProxy>;

  public let m_animProxy: ref<inkAnimProxy>;

  public final native func ListenToFact(fact: CName) -> Void;

  protected cb func OnInitialize() -> Bool {
    this.m_isCyberwareDeactivated = GetFact(this.GetGame(), this.m_fact) > 0;
    inkWidgetRef.SetOpacity(this.m_hudElement, this.m_isCyberwareDeactivated ? 1.00 : 0.00);
    this.ListenToFact(this.m_fact);
  }

  protected cb func OnFactChanged(fact: CName, value: Int32) -> Bool {
    let isCyberwareDeactivated: Bool;
    if Equals(this.m_fact, fact) {
      isCyberwareDeactivated = value > 0;
      if NotEquals(this.m_isCyberwareDeactivated, isCyberwareDeactivated) {
        this.m_isCyberwareDeactivated = isCyberwareDeactivated;
        this.StopPopupAnim();
        this.StopAnim();
        this.m_popupAnimProxy = this.PlayLibraryAnimation(this.m_isCyberwareDeactivated ? this.m_deactivatePopupAnimName : this.m_activatePopupAnimName);
        this.m_popupAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnPopupAnimationFinished");
      };
    };
  }

  protected cb func OnPopupAnimationFinished(proxy: ref<inkAnimProxy>) -> Bool {
    this.StopPopupAnim();
    this.StopAnim();
    this.m_animProxy = this.PlayLibraryAnimation(this.m_isCyberwareDeactivated ? this.m_deactivateAnimName : this.m_activateAnimName);
    this.m_popupAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnAnimationFinished");
  }

  protected cb func OnAnimationFinished(proxy: ref<inkAnimProxy>) -> Bool {
    this.StopPopupAnim();
    this.StopAnim();
    inkWidgetRef.SetOpacity(this.m_hudElement, this.m_isCyberwareDeactivated ? 1.00 : 0.00);
  }

  public final func StopPopupAnim() -> Void {
    if IsDefined(this.m_popupAnimProxy) {
      this.m_popupAnimProxy.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnPopupAnimationFinished");
      this.m_popupAnimProxy.GotoEndAndStop();
      this.m_popupAnimProxy = null;
    };
  }

  public final func StopAnim() -> Void {
    if IsDefined(this.m_animProxy) {
      this.m_animProxy.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnPopupAnimationFinished");
      this.m_animProxy.GotoEndAndStop();
      this.m_animProxy = null;
    };
  }

  public final func GetGame() -> GameInstance {
    let gameInstance: GameInstance;
    let gameObject: ref<GameObject> = this.GetPlayerControlledObject();
    if IsDefined(gameObject) {
      gameInstance = gameObject.GetGame();
    };
    return gameInstance;
  }
}
