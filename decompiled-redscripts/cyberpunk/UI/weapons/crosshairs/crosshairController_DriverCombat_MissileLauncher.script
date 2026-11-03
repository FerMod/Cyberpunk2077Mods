
public native class gameuiDriverCombatMountedMissileLauncherCrosshairGameController extends gameuiCrosshairBaseGameController {

  private edit let m_lockingAnimationWidget: inkWidgetRef;

  private let m_lockingAnimationProxy: ref<inkAnimProxy>;

  private let m_psmTrackedTargetChangedCallback: ref<CallbackHandle>;

  private let m_currentTarget: wref<IPlacedComponent>;

  protected cb func OnPlayerAttach(player: ref<GameObject>) -> Bool {
    super.OnPlayerAttach(player);
    this.m_psmTrackedTargetChangedCallback = this.m_psmBlackboard.RegisterListenerVariant(GetAllBlackboardDefs().PlayerStateMachine.TrackedTarget, this, n"OnPSMTrackedTargetChanged", true);
  }

  protected cb func OnPlayerDetach(player: ref<GameObject>) -> Bool {
    super.OnPlayerDetach(player);
    if IsDefined(this.m_psmTrackedTargetChangedCallback) {
      this.m_psmBlackboard.UnregisterListenerVariant(GetAllBlackboardDefs().PlayerStateMachine.TrackedTarget, this.m_psmTrackedTargetChangedCallback);
    };
  }

  protected cb func OnPSMTrackedTargetChanged(value: Variant) -> Bool {
    let animation: CName;
    if IsDefined(this.m_lockingAnimationProxy) && this.m_lockingAnimationProxy.IsValid() {
      this.m_lockingAnimationProxy.GotoStartAndStop();
    };
    this.m_currentTarget = FromVariant<wref<IPlacedComponent>>(value);
    if IsDefined(this.m_currentTarget) {
      animation = PlayerDevelopmentSystem.GetData(this.m_playerPuppet).IsNewPerkBoughtAnyLevel(gamedataNewPerkType.Tech_Right_Milestone_1) ? n"locking_short" : n"locking";
      this.m_lockingAnimationProxy = this.PlayLibraryAnimation(animation, new inkAnimOptions());
      inkWidgetRef.SetVisible(this.m_lockingAnimationWidget, true);
    } else {
      inkWidgetRef.SetVisible(this.m_lockingAnimationWidget, false);
    };
  }

  protected final func UpdateLockingAnimationWidgetTranslation(uiScreenResolution: Vector2) -> Void {
    let position: Vector2;
    let projection: Vector2;
    let ratio: Vector2;
    let scale: Vector2;
    let uiWidgetResolution: Vector2 = new Vector2(3840.00, 2160.00);
    if IsDefined(this.m_currentTarget) {
      ratio.X = uiWidgetResolution.X / uiScreenResolution.X;
      ratio.Y = uiWidgetResolution.Y / uiScreenResolution.Y;
      if ratio.X > ratio.Y {
        scale.X = 1.00;
        scale.Y = ratio.X / ratio.Y;
      } else {
        scale.X = ratio.Y / ratio.X;
        scale.Y = 1.00;
      };
      projection = this.ProjectWorldToScreen(Matrix.GetTranslation(this.m_currentTarget.GetLocalToWorld()));
      position.X = uiWidgetResolution.X * 0.50 * projection.X * scale.X;
      position.Y = uiWidgetResolution.Y * 0.50 * projection.Y * -1.00 * scale.Y;
      inkWidgetRef.SetTranslation(this.m_lockingAnimationWidget, position);
    };
  }

  public func GetIntroAnimation(firstEquip: Bool) -> ref<inkAnimProxy> {
    return this.PlayLibraryAnimation(n"intro");
  }

  public func GetOutroAnimation() -> ref<inkAnimProxy> {
    return this.PlayLibraryAnimation(n"outro");
  }

  protected func OnState_Aim() -> Void {
    this.m_rootWidget.SetVisible(true);
  }
}
