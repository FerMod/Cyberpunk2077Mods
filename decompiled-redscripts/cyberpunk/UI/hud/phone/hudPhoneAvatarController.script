
public class HudPhoneAvatarController extends HUDPhoneElement {

  private edit let m_ContactAvatar: inkImageRef;

  private edit let m_HolocallRenderTexture: inkImageRef;

  private edit let m_SignalRangeIcon: inkImageRef;

  private edit let m_ContactName: inkTextRef;

  private edit let m_StatusText: inkTextRef;

  private edit let m_WaveformPlaceholder: inkCanvasRef;

  private edit let m_HolocallHolder: inkFlexRef;

  @default(HudPhoneAvatarController, Unknown)
  private edit let m_UnknownAvatarName: CName;

  private edit let m_DefaultPortraitColor: Color;

  private edit let m_DefaultImageSize: Vector2;

  @default(HudPhoneAvatarController, false)
  private edit let m_blackWallEffectOnShow: Bool;

  @default(HudPhoneAvatarController, avatarHoloCallLoopAnimation)
  private edit let m_LoopAnimationName: CName;

  @default(HudPhoneAvatarController, portraitIntro)
  private edit let m_ShowingAnimationName: CName;

  @default(HudPhoneAvatarController, portraitOutro)
  private edit let m_HidingAnimationName: CName;

  @default(HudPhoneAvatarController, avatarAudiocallShowingAnimation)
  private edit let m_AudiocallShowingAnimationName: CName;

  @default(HudPhoneAvatarController, avatarAudiocallHidingAnimation)
  private edit let m_AudiocallHidingAnimationName: CName;

  @default(HudPhoneAvatarController, avatarHolocallShowingAnimation)
  private edit let m_HolocallShowingAnimationName: CName;

  @default(HudPhoneAvatarController, avatarHolocallHidingAnimation)
  private edit let m_HolocallHidingAnimationName: CName;

  private let m_LoopAnimation: ref<inkAnimProxy>;

  private let m_JournalManager: ref<IJournalManager>;

  private let m_RootAnimation: ref<inkAnimProxy>;

  private let m_AudiocallAnimation: ref<inkAnimProxy>;

  private let m_HolocallAnimation: ref<inkAnimProxy>;

  private let m_Holder: inkWidgetRef;

  private let m_Owner: wref<GameObject>;

  private let m_CurrentMode: EHudAvatarMode;

  @default(HudPhoneAvatarController, false)
  private let m_Minimized: Bool;

  @default(HudPhoneAvatarController, false)
  private let m_showAvatar: Bool;

  protected cb func OnInitialize() -> Bool {
    let placeholder: inkWidgetRef;
    super.OnInitialize();
    placeholder = this.m_WaveformPlaceholder;
    this.SpawnFromLocal(inkWidgetRef.Get(placeholder), n"waveform");
    this.ShowAvatar(false);
  }

  public final func SetJournalManager(journalManager: ref<IJournalManager>) -> Void {
    this.m_JournalManager = journalManager;
  }

  public final func SetHolder(holder: inkWidgetRef) -> Void {
    this.m_Holder = holder;
  }

  public final func SetOwner(playerPuppet: wref<GameObject>) -> Void {
    this.m_Owner = playerPuppet;
  }

  public final func ShowIncomingContact(avatarID: TweakDBID, const contactName: script_ref<String>) -> Void {
    this.ShowAvatar(false);
    this.RefreshView(avatarID, contactName, EHudAvatarMode.Connecting);
  }

  public final func ShowEndCallContact(avatarID: TweakDBID, const contactName: script_ref<String>) -> Void {
    if Equals(this.m_CurrentMode, EHudAvatarMode.Holocall) || Equals(this.m_CurrentMode, EHudAvatarMode.Audiocall) {
      this.m_Minimized = false;
      this.ShowAvatar(false);
      this.RefreshView(avatarID, contactName, EHudAvatarMode.Disconnecting);
    } else {
      this.Hide();
    };
  }

  public final func StartAudiocall(avatarID: TweakDBID, const contactName: script_ref<String>, showAvatar: Bool) -> Void {
    this.ShowAvatar(showAvatar);
    this.RefreshView(avatarID, contactName, EHudAvatarMode.Audiocall);
  }

  private final func ShowAvatar(showAvatar: Bool) -> Void {
    this.m_showAvatar = showAvatar;
    inkWidgetRef.SetMargin(this.m_WaveformPlaceholder, 0.00, this.m_showAvatar ? 450.00 : 0.00, 0.00, 0.00);
  }

  public final func StartHolocall(avatarID: TweakDBID, const contactName: script_ref<String>) -> Void {
    this.ShowAvatar(false);
    this.RefreshView(avatarID, contactName, EHudAvatarMode.Holocall);
  }

  public final func ChangeMinimized(minimized: Bool) -> Void {
    if NotEquals(minimized, this.m_Minimized) {
      this.m_Minimized = minimized;
      inkWidgetRef.SetVisible(this.m_SignalRangeIcon, Equals(this.m_CurrentMode, EHudAvatarMode.Audiocall) || this.m_Minimized);
      inkWidgetRef.SetVisible(this.m_WaveformPlaceholder, Equals(this.m_CurrentMode, EHudAvatarMode.Audiocall) || this.m_Minimized);
      this.PlayElementAnimations();
    };
  }

  public final func SetStatusText(const statusText: script_ref<String>) -> Void {
    inkTextRef.SetLetterCase(this.m_StatusText, textLetterCase.UpperCase);
    inkTextRef.SetText(this.m_StatusText, Deref(statusText));
  }

  protected cb func OnStateChanged(widget: wref<inkWidget>, oldState: CName, newState: CName) -> Bool {
    let currentState: EHudPhoneVisibility;
    let options: inkAnimOptions;
    this.StopRootAnimation();
    currentState = this.GetStateFromName(newState);
    if Equals(currentState, EHudPhoneVisibility.Showing) {
      if this.m_blackWallEffectOnShow {
        GameObjectEffectHelper.StartEffectEvent(this.m_Owner, n"hacking_interference_shot");
        GameObjectEffectHelper.StartEffectEvent(this.m_Owner, n"q301_holocall_blackwall");
      };
      this.m_RootAnimation = this.PlayLibraryAnimation(this.m_ShowingAnimationName, options);
      this.m_RootAnimation.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnRootAnimationFinished");
    } else {
      if Equals(currentState, EHudPhoneVisibility.Visible) {
        options.loopType = inkanimLoopType.Cycle;
        options.loopInfinite = true;
        this.m_RootWidget.SetOpacity(1.00);
        if !this.m_LoopAnimation.IsPlaying() {
          this.m_LoopAnimation = this.PlayLibraryAnimation(this.m_LoopAnimationName, options);
        };
      } else {
        if Equals(currentState, EHudPhoneVisibility.Hiding) {
          this.m_LoopAnimation.Stop();
          this.m_RootAnimation = this.PlayLibraryAnimation(this.m_HidingAnimationName, options);
          this.m_RootAnimation.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnRootAnimationFinished");
        } else {
          if Equals(currentState, EHudPhoneVisibility.Invisible) {
            this.m_RootWidget.SetOpacity(0.00);
            inkWidgetRef.SetTintColor(this.m_ContactAvatar, this.m_DefaultPortraitColor);
            inkWidgetRef.SetSize(this.m_ContactAvatar, this.m_DefaultImageSize);
            inkWidgetRef.SetSize(this.m_HolocallRenderTexture, this.m_DefaultImageSize);
            this.GetRootWidget().CallCustomCallback(n"OnAvatarControllerHidden");
          };
        };
      };
    };
  }

  private final func RefreshView(avatarID: TweakDBID, const contactName: script_ref<String>, mode: EHudAvatarMode) -> Void {
    let statusText: String;
    this.m_CurrentMode = mode;
    inkWidgetRef.SetVisible(this.m_ContactAvatar, Equals(mode, EHudAvatarMode.Connecting) || this.m_showAvatar);
    InkImageUtils.RequestAvatarOrUnknown(this, this.m_ContactAvatar, avatarID);
    inkTextRef.SetLetterCase(this.m_ContactName, textLetterCase.UpperCase);
    inkTextRef.SetText(this.m_ContactName, Deref(contactName));
    inkWidgetRef.SetVisible(this.m_SignalRangeIcon, Equals(mode, EHudAvatarMode.Audiocall) || this.m_Minimized);
    inkWidgetRef.SetVisible(this.m_WaveformPlaceholder, Equals(mode, EHudAvatarMode.Audiocall) || this.m_Minimized);
    inkWidgetRef.SetVisible(this.m_HolocallRenderTexture, Equals(mode, EHudAvatarMode.Holocall));
    switch mode {
      case EHudAvatarMode.Connecting:
        statusText = "Connecting";
        inkWidgetRef.SetOpacity(this.m_Holder, 1.00);
        break;
      case EHudAvatarMode.Disconnecting:
        statusText = "Disconnecting";
        break;
      case EHudAvatarMode.Holocall:
        statusText = this.m_Minimized ? "Connection Status: Active Voice Call" : "Connection 541.44.10";
        break;
      case EHudAvatarMode.Audiocall:
        statusText = "Connection Status: Active Voice Call";
        break;
      default:
        statusText = "Connected";
    };
    this.SetStatusText(statusText);
    this.Show();
    this.PlayElementAnimations();
    inkWidgetRef.SetVisible(this.m_HolocallHolder, !this.m_Minimized);
  }

  private final func StopRootAnimation() -> Void {
    if IsDefined(this.m_RootAnimation) {
      this.m_RootAnimation.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnAnimationFinished");
      this.m_RootAnimation.Stop();
      this.m_RootAnimation = null;
    };
  }

  private final func StopAudiocallAnimation() -> Void {
    if IsDefined(this.m_AudiocallAnimation) {
      this.m_AudiocallAnimation.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnAudiocallAnimationFinished");
      this.m_AudiocallAnimation.Stop();
      this.m_AudiocallAnimation = null;
    };
  }

  private final func StopHolocallAnimation() -> Void {
    if IsDefined(this.m_HolocallAnimation) {
      this.m_HolocallAnimation.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnHolocallAnimationFinished");
      this.m_HolocallAnimation.Stop();
      this.m_HolocallAnimation = null;
    };
  }

  private final func PlayElementAnimations() -> Void {
    let animationName: CName;
    let isAudiocall: Bool;
    let isHolocall: Bool;
    let isMinimized: Bool;
    let showAvatar: Bool;
    this.StopAudiocallAnimation();
    this.StopHolocallAnimation();
    isMinimized = this.m_Minimized;
    showAvatar = Equals(this.m_CurrentMode, EHudAvatarMode.Connecting) || this.m_showAvatar;
    isHolocall = Equals(this.m_CurrentMode, EHudAvatarMode.Holocall);
    isAudiocall = Equals(this.m_CurrentMode, EHudAvatarMode.Audiocall);
    animationName = showAvatar || isHolocall && !isMinimized ? this.m_HolocallShowingAnimationName : this.m_HolocallHidingAnimationName;
    if NotEquals(animationName, n"None") {
      this.m_HolocallAnimation = this.PlayLibraryAnimation(animationName);
      this.m_HolocallAnimation.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnHolocallAnimationFinished");
    } else {
      this.OnHolocallAnimationFinished(null);
    };
    animationName = isAudiocall || isMinimized ? this.m_AudiocallShowingAnimationName : this.m_AudiocallHidingAnimationName;
    if NotEquals(animationName, n"None") {
      this.m_AudiocallAnimation = this.PlayLibraryAnimation(animationName);
      this.m_AudiocallAnimation.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnAudiocallAnimationFinished");
    } else {
      this.OnAudiocallAnimationFinished(null);
    };
  }

  private final func AreElementAnimationsComplete() -> Bool {
    return (!IsDefined(this.m_AudiocallAnimation) || !this.m_AudiocallAnimation.IsPlaying()) && (!IsDefined(this.m_HolocallAnimation) || !this.m_HolocallAnimation.IsPlaying());
  }

  protected cb func OnHolocallAnimationFinished(anim: ref<inkAnimProxy>) -> Bool {
    this.StopHolocallAnimation();
    this.OnElementAnimationsFinished();
  }

  protected cb func OnAudiocallAnimationFinished(anim: ref<inkAnimProxy>) -> Bool {
    this.StopAudiocallAnimation();
    this.OnElementAnimationsFinished();
  }

  private final func OnElementAnimationsFinished() -> Void {
    if this.AreElementAnimationsComplete() {
      if Equals(this.m_CurrentMode, EHudAvatarMode.Disconnecting) {
        inkWidgetRef.SetOpacity(this.m_Holder, 0.00);
        this.Hide();
      };
    };
  }

  protected cb func OnRootAnimationFinished(anim: ref<inkAnimProxy>) -> Bool {
    let currentState: EHudPhoneVisibility;
    this.StopRootAnimation();
    currentState = this.GetState();
    if Equals(currentState, EHudPhoneVisibility.Showing) {
      this.SetState(EHudPhoneVisibility.Visible);
    } else {
      if Equals(currentState, EHudPhoneVisibility.Hiding) {
        this.SetState(EHudPhoneVisibility.Invisible);
      };
    };
  }
}
