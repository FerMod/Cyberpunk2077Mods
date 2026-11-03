
public class CrosshairGameController_Simple extends gameuiCrosshairBaseGameController {

  private edit let m_topPart: inkWidgetRef;

  private edit let m_bottomPart: inkWidgetRef;

  private edit let m_horiPart: inkWidgetRef;

  private edit let m_vertPart: inkWidgetRef;

  private edit let m_leftPart: inkWidgetRef;

  private edit let m_rightPart: inkWidgetRef;

  private edit let m_targetColorChange: inkWidgetRef;

  @default(CrosshairGameController_Simple, .8f)
  private let offsetLeftRight: Float;

  @default(CrosshairGameController_Simple, 40.0f)
  private let latchVertical: Float;

  protected cb func OnInitialize() -> Bool {
    super.OnInitialize();
  }

  public func GetIntroAnimation(firstEquip: Bool) -> ref<inkAnimProxy> {
    let crosshairReticleData: gameuiDriverCombatCrosshairReticleData = FromVariant<gameuiDriverCombatCrosshairReticleData>(this.GetUIBlackboard().GetVariant(GetAllBlackboardDefs().UIGameData.DriverCombatCrosshairReticle));
    let anim: ref<inkAnimDef> = new inkAnimDef();
    let alphaInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    alphaInterpolator.SetStartTransparency(0.00);
    alphaInterpolator.SetEndTransparency(crosshairReticleData.opacity);
    alphaInterpolator.SetDuration(0.25);
    alphaInterpolator.SetType(inkanimInterpolationType.Linear);
    alphaInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    anim.AddInterpolator(alphaInterpolator);
    return this.m_rootWidget.PlayAnimation(anim);
  }

  public func GetOutroAnimation() -> ref<inkAnimProxy> {
    let crosshairReticleData: gameuiDriverCombatCrosshairReticleData = FromVariant<gameuiDriverCombatCrosshairReticleData>(this.GetUIBlackboard().GetVariant(GetAllBlackboardDefs().UIGameData.DriverCombatCrosshairReticle));
    let anim: ref<inkAnimDef> = new inkAnimDef();
    let alphaInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    alphaInterpolator.SetStartTransparency(crosshairReticleData.opacity);
    alphaInterpolator.SetEndTransparency(0.00);
    alphaInterpolator.SetDuration(0.25);
    alphaInterpolator.SetType(inkanimInterpolationType.Linear);
    alphaInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    anim.AddInterpolator(alphaInterpolator);
    return this.m_rootWidget.PlayAnimation(anim);
  }

  protected cb func OnBulletSpreadChanged(spread: Vector2) -> Bool {
    super.OnBulletSpreadChanged(spread);
    inkWidgetRef.SetMargin(this.m_leftPart, new inkMargin(-spread.X * this.offsetLeftRight, 0.00, 0.00, 0.00));
    inkWidgetRef.SetMargin(this.m_rightPart, new inkMargin(spread.X * this.offsetLeftRight, 0.00, 0.00, 0.00));
    inkWidgetRef.SetSize(this.m_vertPart, 3.00, spread.Y * 2.00 + this.latchVertical);
    inkWidgetRef.SetSize(this.m_horiPart, spread.X * 2.00, 3.00);
    inkWidgetRef.SetMargin(this.m_topPart, new inkMargin(0.00, -spread.Y, 0.00, 0.00));
    inkWidgetRef.SetMargin(this.m_bottomPart, new inkMargin(0.00, spread.Y, 0.00, 0.00));
  }

  protected func ApplyCrosshairGUIState(state: CName, aimedAtEntity: ref<Entity>) -> Void {
    inkWidgetRef.SetState(this.m_targetColorChange, state);
  }

  protected func OnState_HipFire() -> Void {
    this.m_rootWidget.SetVisible(true);
  }

  protected func OnState_Aim() -> Void {
    this.m_rootWidget.SetVisible(false);
  }
}
