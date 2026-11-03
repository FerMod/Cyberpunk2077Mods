
public native class DamageIndicatorGameController extends inkHUDGameController {

  private final func ShouldShowDamage(evt: ref<gameDamageReceivedEvent>) -> Bool {
    if Equals(evt.hitEvent.attackData.GetAttackType(), gamedataAttackType.Effect) {
      return false;
    };
    if evt.hitEvent.attackData.HasFlag(hitFlag.DisableNPCHitReaction) || evt.hitEvent.attackData.HasFlag(hitFlag.DisablePlayerHitReaction) {
      return false;
    };
    return true;
  }
}

public native class DamageIndicatorPartLogicController extends BaseDirectionalIndicatorPartLogicController {

  private edit let m_arrowFrontWidget: inkImageRef;

  private edit let m_arrowBigWidget: inkImageRef;

  @default(DamageIndicatorPartLogicController, 100)
  private edit let m_damageThreshold: Float;

  private let m_root: wref<inkWidget>;

  private let m_animProxy: ref<inkAnimProxy>;

  private let m_damageTaken: Float;

  private let m_continuous: Bool;

  private let m_revengeActive: Bool;

  protected final native func SetReadyToRemove() -> Void;

  protected final native func SetShowingDamage(showing: Bool) -> Void;

  protected final native func SetContinuous(continuous: Bool) -> Void;

  protected final native func SetMinimumOpacity(opacity: Float) -> Void;

  protected final native func ResetMinimumOpacity() -> Void;

  protected cb func OnInitialize() -> Bool {
    this.m_root = this.GetRootWidget();
    this.Reset();
  }

  protected final func InitPart() -> Void {
    this.Reset();
  }

  protected final func AddIncomingDamage(evt: ref<gameDamageReceivedEvent>) -> Void {
    let isRevengeActivatingHit: Bool;
    this.m_damageTaken += evt.totalDamageReceived;
    isRevengeActivatingHit = evt.hitEvent.attackData.HasFlag(hitFlag.RevengeActivatingHit);
    if !this.m_continuous && (!this.m_revengeActive || isRevengeActivatingHit) {
      if IsDefined(this.m_animProxy) && this.m_animProxy.IsPlaying() {
        this.m_animProxy.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnOutroComplete");
        this.m_animProxy.Stop();
      };
      if isRevengeActivatingHit {
        if !this.m_revengeActive {
          this.m_revengeActive = true;
          this.m_root.SetState(n"Revenge");
          inkWidgetRef.SetVisible(this.m_arrowFrontWidget, false);
          inkWidgetRef.SetVisible(this.m_arrowBigWidget, true);
          this.SetMinimumOpacity(0.60);
        };
      } else {
        this.m_root.SetState(n"Damage");
        this.ResetMinimumOpacity();
      };
      this.PlayAnim(n"Outro", n"OnOutroComplete");
      this.SetShowingDamage(true);
    };
  }

  protected final func AddAttackAttempt(evt: ref<AIAttackAttemptEvent>) -> Void {
    let progress: Float;
    if IsDefined(this.m_animProxy) {
      progress = this.m_animProxy.GetProgression();
    };
    if NotEquals(evt.continuousMode, gameEContinuousMode.None) {
      if Equals(evt.continuousMode, gameEContinuousMode.Start) {
        if !this.m_continuous {
          if this.m_animProxy.IsPlaying() {
            this.m_animProxy.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnOutroComplete");
            this.m_animProxy.Stop();
          };
          this.SetShowingDamage(false);
          this.SetMinimumOpacity(evt.minimumOpacity);
          this.ResetRevenge();
          this.m_root.SetState(n"Hacking");
          this.m_continuous = true;
          this.m_animProxy = this.PlayLibraryAnimation(n"Intro_Continuous");
        };
      } else {
        if Equals(evt.continuousMode, gameEContinuousMode.Stop) {
          if this.m_continuous {
            this.SetMinimumOpacity(evt.minimumOpacity);
          };
          this.StopContinuousEffect();
        };
      };
      this.SetContinuous(this.m_continuous);
    } else {
      if !this.m_continuous {
        if this.m_damageTaken == 0.00 || progress > 0.75 {
          this.m_root.SetState(n"Danger");
          this.SetShowingDamage(false);
          this.SetMinimumOpacity(evt.minimumOpacity);
          this.ResetRevenge();
          if IsDefined(this.m_animProxy) && this.m_animProxy.IsPlaying() {
            this.m_animProxy.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnOutroComplete");
            this.m_animProxy.Stop();
            if evt.isWindUp && progress > 0.75 {
              this.PlayAnim(n"Outro_WindUp", n"OnOutroComplete");
            } else {
              this.PlayAnim(n"Outro_Miss_NoDelay", n"OnOutroComplete");
            };
          } else {
            if evt.isWindUp {
              this.PlayAnim(n"Outro_WindUp", n"OnOutroComplete");
            } else {
              this.PlayAnim(n"Outro_Miss", n"OnOutroComplete");
            };
          };
        };
      };
    };
  }

  private final func StopContinuousEffect() -> Void {
    if this.m_continuous {
      if this.m_animProxy.IsPlaying() {
        this.m_animProxy.Stop();
      };
      this.m_continuous = false;
      this.PlayAnim(n"Outro_Continuous", n"OnOutroComplete");
    } else {
      if !IsDefined(this.m_animProxy) || !this.m_animProxy.IsPlaying() {
        this.SetReadyToRemove();
      };
    };
  }

  private final func Reset() -> Void {
    this.m_damageTaken = 0.00;
    this.m_continuous = false;
    this.SetShowingDamage(false);
    this.SetContinuous(this.m_continuous);
    this.ResetRevenge();
  }

  private final func ResetRevenge() -> Void {
    if this.m_revengeActive {
      this.m_revengeActive = false;
      inkWidgetRef.SetVisible(this.m_arrowFrontWidget, true);
      inkWidgetRef.SetVisible(this.m_arrowBigWidget, false);
    };
  }

  private final func PlayAnim(animName: CName, callback: CName) -> Void {
    this.m_animProxy = this.PlayLibraryAnimation(animName);
    this.m_animProxy.RegisterToCallback(inkanimEventType.OnFinish, this, callback);
  }

  protected cb func OnOutroComplete(e: ref<inkAnimProxy>) -> Bool {
    this.SetReadyToRemove();
  }
}
