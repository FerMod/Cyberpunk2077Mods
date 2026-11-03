
public class Crosshair_Power_Defender extends gameuiCrosshairBaseGameController {

  private edit let m_leftPart: inkWidgetRef;

  private edit let m_rightPart: inkWidgetRef;

  private edit let m_topPart: inkWidgetRef;

  private edit let m_botPart: inkWidgetRef;

  public func GetIntroAnimation(firstEquip: Bool) -> ref<inkAnimProxy> {
    let anim: ref<inkAnimDef> = new inkAnimDef();
    let alphaInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    alphaInterpolator.SetStartTransparency(0.00);
    alphaInterpolator.SetEndTransparency(1.00);
    alphaInterpolator.SetDuration(0.25);
    alphaInterpolator.SetType(inkanimInterpolationType.Linear);
    alphaInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    anim.AddInterpolator(alphaInterpolator);
    return this.m_rootWidget.PlayAnimation(anim);
  }

  public func GetOutroAnimation() -> ref<inkAnimProxy> {
    let anim: ref<inkAnimDef> = new inkAnimDef();
    let alphaInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    alphaInterpolator.SetStartTransparency(1.00);
    alphaInterpolator.SetEndTransparency(0.00);
    alphaInterpolator.SetDuration(0.25);
    alphaInterpolator.SetType(inkanimInterpolationType.Linear);
    alphaInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    anim.AddInterpolator(alphaInterpolator);
    return this.m_rootWidget.PlayAnimation(anim);
  }

  protected cb func OnBulletSpreadChanged(spread: Vector2) -> Bool {
    super.OnBulletSpreadChanged(spread);
    inkWidgetRef.SetMargin(this.m_leftPart, new inkMargin(-spread.X, 0.00, 0.00, 0.00));
    inkWidgetRef.SetMargin(this.m_rightPart, new inkMargin(spread.X, 0.00, 0.00, 0.00));
    inkWidgetRef.SetMargin(this.m_topPart, new inkMargin(0.00, spread.Y, 0.00, 0.00));
    inkWidgetRef.SetMargin(this.m_botPart, new inkMargin(0.00, -spread.Y, 0.00, 0.00));
  }

  protected func ApplyCrosshairGUIState(state: CName, aimedAtEntity: ref<Entity>) -> Void {
    inkWidgetRef.SetState(this.m_leftPart, state);
    inkWidgetRef.SetState(this.m_rightPart, state);
    inkWidgetRef.SetState(this.m_topPart, state);
    inkWidgetRef.SetState(this.m_botPart, state);
  }
}
