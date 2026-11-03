
public class CrosshairGameController_Mantis_Blade extends gameuiCrosshairBaseGameController {

  private let m_weaponBBID: ref<CallbackHandle>;

  private let m_meleeWeaponState: gamePSMMeleeWeapon;

  private edit let m_targetColorChange: inkWidgetRef;

  private let holdAnim: ref<inkAnimProxy>;

  private let aimAnim: ref<inkAnimProxy>;

  private let m_isInHoldState: Bool;

  private let m_meleeLeapAttackObjectTagger: ref<MeleeLeapAttackObjectTagger>;

  protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
    let playerSMBB: ref<IBlackboard> = this.GetPSMBlackboard(playerPuppet);
    this.m_weaponBBID = playerSMBB.RegisterDelayedListenerInt(GetAllBlackboardDefs().PlayerStateMachine.MeleeWeapon, this, n"OnPSMMeleeWeaponStateChanged");
    this.OnPSMMeleeWeaponStateChanged(playerSMBB.GetInt(GetAllBlackboardDefs().PlayerStateMachine.MeleeWeapon));
    this.m_meleeLeapAttackObjectTagger = new MeleeLeapAttackObjectTagger();
    this.m_meleeLeapAttackObjectTagger.SetUp(playerPuppet);
    this.OnPreIntro();
  }

  protected cb func OnPlayerDetach(playerPuppet: ref<GameObject>) -> Bool {
    let playerSMBB: ref<IBlackboard>;
    if IsDefined(this.m_weaponBBID) {
      playerSMBB = this.GetPSMBlackboard(playerPuppet);
      playerSMBB.UnregisterDelayedListener(GetAllBlackboardDefs().PlayerStateMachine.MeleeWeapon, this.m_weaponBBID);
    };
  }

  protected cb func OnPSMMeleeWeaponStateChanged(value: Int32) -> Bool {
    let oldState: gamePSMMeleeWeapon = this.m_meleeWeaponState;
    let newState: gamePSMMeleeWeapon = IntEnum<gamePSMMeleeWeapon>(value);
    if NotEquals(oldState, newState) {
      this.m_meleeWeaponState = newState;
      this.OnMeleeWeaponStateChange(oldState, newState);
    };
  }

  private final func OnMeleeWeaponStateChange(oldState: gamePSMMeleeWeapon, newState: gamePSMMeleeWeapon) -> Void {
    switch newState {
      case gamePSMMeleeWeapon.Hold:
      case gamePSMMeleeWeapon.ChargedHold:
        this.OnState_Hold();
        break;
      default:
        this.OnState_Default();
    };
  }

  public func GetIntroAnimation(firstEquip: Bool) -> ref<inkAnimProxy> {
    let anim: ref<inkAnimDef> = new inkAnimDef();
    let alphaInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    alphaInterpolator.SetStartTransparency(0.00);
    alphaInterpolator.SetEndTransparency(1.00);
    alphaInterpolator.SetDuration(0.25);
    alphaInterpolator.SetType(inkanimInterpolationType.Linear);
    alphaInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    anim.AddInterpolator(alphaInterpolator);
    return this.GetRootWidget().PlayAnimation(anim);
  }

  protected func ApplyCrosshairGUIState(state: CName, aimedAtEntity: ref<Entity>) -> Void {
    inkWidgetRef.SetState(this.m_targetColorChange, state);
    this.UpdateTargetIndicator();
  }

  public final func UpdateTargetIndicator() -> Void {
    if IsDefined(this.m_targetEntity) && this.m_isInHoldState {
      this.m_meleeLeapAttackObjectTagger.SetVisionOnTargetObj(this.m_targetEntity, this.GetDistanceToTarget());
    };
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

  private final func PlayAnimation(animName: CName) -> ref<inkAnimProxy> {
    let m_animationProxy: ref<inkAnimProxy> = this.PlayLibraryAnimation(animName);
    return m_animationProxy;
  }

  protected final func OnState_Hold() -> Void {
    if this.holdAnim.IsPlaying() {
      this.holdAnim.Stop();
    };
    this.holdAnim = this.PlayAnimation(n"go_to_hold_state");
    this.m_isInHoldState = true;
    this.m_meleeLeapAttackObjectTagger.SetVisionOnTargetObj(this.m_targetEntity, this.GetDistanceToTarget());
    this.UpdateCrosshairGUIState(false);
  }

  protected final func OnState_Default() -> Void {
    if this.aimAnim.IsPlaying() {
      this.aimAnim.Stop();
    };
    this.aimAnim = this.PlayAnimation(n"go_to_default_state");
    this.m_isInHoldState = false;
    this.m_meleeLeapAttackObjectTagger.ResetVisionOnTargetObj();
    this.UpdateCrosshairGUIState(false);
  }
}
