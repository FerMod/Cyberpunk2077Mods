
public class RipperdocScreenAnimationController extends inkLogicController {

  private edit let m_doll: inkWidgetRef;

  private edit let m_defaultAnimationTab: inkWidgetRef;

  private edit let m_itemAnimationTab: inkWidgetRef;

  private edit let m_femaleHovers: inkWidgetRef;

  private edit let m_maleHovers: inkWidgetRef;

  private edit let m_F_immuneHoverTexture: inkWidgetRef;

  private edit let m_F_systemReplacementHoverTexture: inkWidgetRef;

  private edit let m_F_integumentaryHoverTexture: inkWidgetRef;

  private edit let m_F_musculoskeletalHoverTexture: inkWidgetRef;

  private edit let m_F_nervousHoverTexture: inkWidgetRef;

  private edit let m_F_eyesHoverTexture: inkImageRef;

  private edit let m_F_legsHoverTexture: inkWidgetRef;

  private edit let m_F_frontalCortexHoverTexture: inkWidgetRef;

  private edit let m_F_handsHoverTexture: inkWidgetRef;

  private edit let m_F_cardiovascularHoverTexture: inkWidgetRef;

  private edit let m_F_armsHoverTexture: inkWidgetRef;

  private edit let m_M_integumentaryHoverTexture: inkWidgetRef;

  private edit let m_M_armsHoverTexture: inkWidgetRef;

  private edit let m_M_cardiovascularHoverTexture: inkWidgetRef;

  private edit let m_M_handsHoverTexture: inkWidgetRef;

  private edit let m_M_frontalCortexHoverTexture: inkWidgetRef;

  private edit let m_M_immuneHoverTexture: inkWidgetRef;

  private edit let m_M_legsHoverTexture: inkWidgetRef;

  private edit let m_M_systemReplacementHoverTexture: inkWidgetRef;

  private edit let m_M_musculoskeletalHoverTexture: inkWidgetRef;

  private edit let m_M_nervousHoverTexture: inkWidgetRef;

  private edit let m_M_eyesHoverTexture: inkImageRef;

  private edit let m_man_wiresTexture: inkWidgetRef;

  private edit let m_woman_wiresTexture: inkWidgetRef;

  private let m_hoverAnimation: ref<inkAnimProxy>;

  private let m_hoverOverAnimation: ref<inkAnimProxy>;

  private let m_introDefaultAnimation: ref<inkAnimProxy>;

  private let m_outroDefaultAnimation: ref<inkAnimProxy>;

  private let m_introPaperdollAnimation: ref<inkAnimProxy>;

  private let m_outroPaperdollAnimation: ref<inkAnimProxy>;

  private let m_slideAnimation: ref<inkAnimProxy>;

  private let m_hoveredArea: gamedataEquipmentArea;

  private let m_introArea: gamedataEquipmentArea;

  private let m_isFemale: Bool;

  private let m_area: gamedataEquipmentArea;

  private let m_anim: ref<inkAnimProxy>;

  private let m_animHover: ref<inkAnimProxy>;

  private let m_animCancel: ref<inkAnimProxy>;

  private let m_isHovering: Bool;

  private let m_isSelected: Bool;

  private let m_animName: CName;

  private let m_position: inkMargin;

  private let m_positionOffset: Float;

  private let m_root: wref<inkWidget>;

  private let m_isSlidingOut: Bool;

  private let m_zoomOutAnim: ref<inkAnimProxy>;

  private let m_zoomInAnim: ref<inkAnimProxy>;

  private let m_slideOutAnim: ref<inkAnimProxy>;

  private let m_slideInAnim: ref<inkAnimProxy>;

  private let m_slideDirection: Bool;

  private let m_cancelSlideIn: Bool;

  private let m_isInside: Bool;

  @default(RipperdocScreenAnimationController, gamedataEquipmentArea.Invalid)
  private let m_currentArea: gamedataEquipmentArea;

  private let m_nextArea: gamedataEquipmentArea;

  private let m_midArea: gamedataEquipmentArea;

  @default(RipperdocScreenAnimationController, 0.25f)
  private const let SLIDE_DURATION: Float;

  public final func StartSlide(isRight: Bool, nextArea: gamedataEquipmentArea) -> Void {
    this.m_slideDirection = isRight;
    this.m_nextArea = nextArea;
    this.m_isInside = true;
    if Equals(this.m_currentArea, gamedataEquipmentArea.Invalid) {
      this.m_currentArea = this.m_area;
    };
    if this.m_zoomOutAnim != null && this.m_zoomOutAnim.IsPlaying() || this.m_slideOutAnim != null && this.m_slideOutAnim.IsPlaying() {
      this.m_cancelSlideIn = true;
      return;
    };
    if this.m_slideInAnim != null && this.m_slideInAnim.IsPlaying() {
      this.m_slideInAnim.Stop();
    };
    this.m_cancelSlideIn = false;
    this.SlideDoll(true);
  }

  private final func ZoomDoll(isZoomOut: Bool) -> Void {
    let options: inkAnimOptions;
    if this.m_zoomInAnim != null {
      this.m_zoomInAnim.Stop();
    };
    if isZoomOut {
      options.customTimeDilation = 100.00;
      options.applyCustomTimeDilation = true;
      this.m_zoomOutAnim = this.PlayLibraryAnimation(this.GetName(this.m_currentArea, n"outro"), options);
      this.m_zoomOutAnim.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnZoomOutFinished");
    } else {
      this.m_currentArea = this.m_nextArea;
      options.fromMarker = n"SkipIntro";
      this.m_zoomInAnim = this.PlayLibraryAnimation(this.GetName(this.m_nextArea, n"intro"), options);
      this.m_zoomInAnim.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnZoomInFinished");
    };
  }

  protected cb func OnZoomOutFinished(anim: ref<inkAnimProxy>) -> Bool {
    if !this.m_isInside {
      this.StopSelect();
    } else {
      if this.m_cancelSlideIn {
        if this.m_slideOutAnim != null {
          this.m_slideOutAnim.Stop();
        };
        this.ZoomDoll(false);
        this.StartSlide(this.m_slideDirection, this.m_nextArea);
      } else {
        this.ZoomDoll(false);
        this.SlideDoll(false);
      };
    };
  }

  protected cb func OnZoomInFinished(anim: ref<inkAnimProxy>) -> Bool {
    if this.m_cancelSlideIn {
      this.StartSlide(this.m_slideDirection, this.m_nextArea);
    };
  }

  private final func SlideDoll(isSlideOut: Bool) -> Void {
    let animation: ref<inkAnimDef>;
    let endOpacity: Float;
    let endPosition: inkMargin;
    let marginInterpolator: ref<inkAnimMargin>;
    let opacityInterpolator: ref<inkAnimTransparency>;
    let startOpacity: Float;
    let startPosition: inkMargin;
    if this.m_slideAnimation != null {
      this.m_slideAnimation.Stop();
    };
    startOpacity = isSlideOut ? 1.00 : 0.00;
    endOpacity = isSlideOut ? 0.00 : 1.00;
    startPosition = this.m_position;
    startPosition.left += isSlideOut ? 0.00 : this.m_positionOffset * this.m_slideDirection ? 1.00 : -1.00;
    endPosition = this.m_position;
    endPosition.left += isSlideOut ? this.m_positionOffset : 0.00 * this.m_slideDirection ? -1.00 : 1.00;
    opacityInterpolator = new inkAnimTransparency();
    opacityInterpolator.SetDuration(this.SLIDE_DURATION);
    opacityInterpolator.SetStartTransparency(startOpacity);
    opacityInterpolator.SetEndTransparency(endOpacity);
    opacityInterpolator.SetType(inkanimInterpolationType.Sinusoidal);
    opacityInterpolator.SetMode(inkanimInterpolationMode.EasyOut);
    marginInterpolator = new inkAnimMargin();
    marginInterpolator.SetDuration(this.SLIDE_DURATION);
    marginInterpolator.SetStartMargin(startPosition);
    marginInterpolator.SetEndMargin(endPosition);
    marginInterpolator.SetType(inkanimInterpolationType.Sinusoidal);
    marginInterpolator.SetMode(inkanimInterpolationMode.EasyOut);
    animation = new inkAnimDef();
    animation.AddInterpolator(opacityInterpolator);
    animation.AddInterpolator(marginInterpolator);
    if isSlideOut {
      this.m_slideOutAnim = this.m_root.PlayAnimation(animation);
      this.m_slideOutAnim.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnSlideOutFinished");
    } else {
      this.m_slideInAnim = this.m_root.PlayAnimation(animation);
    };
  }

  protected cb func OnSlideOutFinished(anim: ref<inkAnimProxy>) -> Bool {
    if this.m_isInside {
      this.ZoomDoll(true);
    };
  }

  protected cb func OnInitialize() -> Bool {
    this.HideAllBodyParts();
    this.m_root = inkWidgetRef.Get(this.m_doll);
    this.m_position = this.m_root.GetMargin();
    this.m_positionOffset = 500.00;
  }

  public final func SetMask(hasMask: Bool) -> Void {
    if hasMask {
      inkImageRef.SetTexturePart(this.m_M_eyesHoverTexture, n"ma_ocular_mask");
      inkImageRef.SetTexturePart(this.m_F_eyesHoverTexture, n"wo_ocular_mask");
    } else {
      inkImageRef.SetTexturePart(this.m_M_eyesHoverTexture, n"ma_ocular");
      inkImageRef.SetTexturePart(this.m_F_eyesHoverTexture, n"wo_ocular");
    };
  }

  public final func ForceRestartFaceAnimation() -> Void {
    this.m_anim = this.PlayLibraryAnimation(!this.m_isFemale ? n"M_ocular_intro" : n"ocular_intro");
  }

  public final func SetGender(female: Bool) -> Void {
    this.m_isFemale = female;
    inkWidgetRef.SetVisible(this.m_femaleHovers, this.m_isFemale);
    inkWidgetRef.SetVisible(this.m_maleHovers, !this.m_isFemale);
    inkWidgetRef.SetVisible(this.m_woman_wiresTexture, this.m_isFemale);
    inkWidgetRef.SetVisible(this.m_man_wiresTexture, !this.m_isFemale);
  }

  public final func StartHover(area: gamedataEquipmentArea) -> Void {
    let target: wref<inkWidget>;
    if NotEquals(area, gamedataEquipmentArea.Invalid) && NotEquals(area, this.m_area) {
      if this.m_animHover != null && this.m_animHover.IsPlaying() {
        this.m_animHover.GotoEndAndStop();
      };
      this.m_isHovering = true;
      this.m_area = area;
      target = this.GetHoverAnimationTarget(this.m_area);
      this.m_animHover = this.PlayLibraryAnimationOnTargets(n"hover_area", SelectWidgets(target));
    };
  }

  public final func StopHover() -> Void {
    let target: wref<inkWidget>;
    if this.m_isHovering {
      if this.m_animHover != null && this.m_animHover.IsPlaying() {
        this.m_animHover.GotoEndAndStop();
      };
      target = this.GetHoverAnimationTarget(this.m_area);
      this.m_animHover = this.PlayLibraryAnimationOnTargets(n"hoverover_area", SelectWidgets(target));
      this.m_area = gamedataEquipmentArea.Invalid;
    };
  }

  public final func StartSelect() -> Void {
    if !this.m_isInside {
      this.TryStartAnimation(this.GetName(this.m_area, n"intro"));
      this.m_isInside = true;
    };
  }

  public final func StopSelect() -> Void {
    if this.m_isInside {
      return;
    };
    if this.m_anim != null {
      this.m_anim.Stop();
      this.m_anim = null;
    };
    if this.m_slideOutAnim != null && this.m_slideOutAnim.IsPlaying() {
      this.m_slideOutAnim.Stop();
      this.m_slideOutAnim = null;
      this.ZoomDoll(true);
      return;
    };
    if this.m_slideInAnim != null {
      this.m_slideInAnim.Stop();
      this.m_slideInAnim = null;
    };
    this.m_root.SetOpacity(1.00);
    this.m_root.SetMargin(this.m_position);
    this.m_currentArea = gamedataEquipmentArea.Invalid;
    this.m_anim = this.PlayLibraryAnimation(this.GetName(this.m_area, n"outro"));
  }

  public final func SetOutside() -> Void {
    this.m_isInside = false;
  }

  private final func TryStartAnimation(name: CName) -> Void {
    let options: inkAnimOptions;
    if this.m_anim != null && this.m_anim.IsPlaying() {
      this.m_animName = name;
      options.playReversed = true;
      this.m_anim.Continue(options);
      this.m_anim.RegisterToCallback(inkanimEventType.OnFinish, this, n"AnimQueue");
    } else {
      this.m_animName = name;
      this.m_anim = this.PlayLibraryAnimation(this.m_animName);
      this.m_animName = n"None";
    };
  }

  private final func AnimQueue(anim: ref<inkAnimProxy>) -> Void {
    if NotEquals(this.m_animName, n"None") {
      this.m_anim = this.PlayLibraryAnimation(this.m_animName);
    };
  }

  private final func GetName(area: gamedataEquipmentArea, suffix: CName) -> CName {
    let animName: CName;
    switch area {
      case gamedataEquipmentArea.FrontalCortexCW:
        animName = n"frontalCortex_";
        break;
      case gamedataEquipmentArea.EyesCW:
        animName = n"ocular_";
        break;
      case gamedataEquipmentArea.CardiovascularSystemCW:
        animName = n"circlatory_";
        break;
      case gamedataEquipmentArea.ImmuneSystemCW:
        animName = n"immune_";
        break;
      case gamedataEquipmentArea.NervousSystemCW:
        animName = n"nervous_";
        break;
      case gamedataEquipmentArea.IntegumentarySystemCW:
        animName = n"integumentary_";
        break;
      case gamedataEquipmentArea.SystemReplacementCW:
        animName = n"operating_";
        break;
      case gamedataEquipmentArea.MusculoskeletalSystemCW:
        animName = n"skeleton_";
        break;
      case gamedataEquipmentArea.HandsCW:
        animName = n"hands_";
        break;
      case gamedataEquipmentArea.ArmsCW:
        animName = n"arms_";
        break;
      case gamedataEquipmentArea.LegsCW:
        animName = n"legs_";
    };
    animName = animName + suffix;
    if !this.m_isFemale {
      animName = n"M_" + animName;
    };
    return animName;
  }

  private final func GetHoverAnimationTarget(area: gamedataEquipmentArea) -> wref<inkWidget> {
    let target: wref<inkWidget>;
    switch area {
      case gamedataEquipmentArea.FrontalCortexCW:
        target = this.m_isFemale ? inkWidgetRef.Get(this.m_F_frontalCortexHoverTexture) : inkWidgetRef.Get(this.m_M_frontalCortexHoverTexture);
        break;
      case gamedataEquipmentArea.EyesCW:
        target = this.m_isFemale ? inkWidgetRef.Get(this.m_F_eyesHoverTexture) : inkWidgetRef.Get(this.m_M_eyesHoverTexture);
        break;
      case gamedataEquipmentArea.CardiovascularSystemCW:
        target = this.m_isFemale ? inkWidgetRef.Get(this.m_F_cardiovascularHoverTexture) : inkWidgetRef.Get(this.m_M_cardiovascularHoverTexture);
        break;
      case gamedataEquipmentArea.ImmuneSystemCW:
        target = this.m_isFemale ? inkWidgetRef.Get(this.m_F_immuneHoverTexture) : inkWidgetRef.Get(this.m_M_immuneHoverTexture);
        break;
      case gamedataEquipmentArea.NervousSystemCW:
        target = this.m_isFemale ? inkWidgetRef.Get(this.m_F_nervousHoverTexture) : inkWidgetRef.Get(this.m_M_nervousHoverTexture);
        break;
      case gamedataEquipmentArea.IntegumentarySystemCW:
        target = this.m_isFemale ? inkWidgetRef.Get(this.m_F_integumentaryHoverTexture) : inkWidgetRef.Get(this.m_M_integumentaryHoverTexture);
        break;
      case gamedataEquipmentArea.SystemReplacementCW:
        target = this.m_isFemale ? inkWidgetRef.Get(this.m_F_systemReplacementHoverTexture) : inkWidgetRef.Get(this.m_M_systemReplacementHoverTexture);
        break;
      case gamedataEquipmentArea.MusculoskeletalSystemCW:
        target = this.m_isFemale ? inkWidgetRef.Get(this.m_F_musculoskeletalHoverTexture) : inkWidgetRef.Get(this.m_M_musculoskeletalHoverTexture);
        break;
      case gamedataEquipmentArea.HandsCW:
        target = this.m_isFemale ? inkWidgetRef.Get(this.m_F_handsHoverTexture) : inkWidgetRef.Get(this.m_M_handsHoverTexture);
        break;
      case gamedataEquipmentArea.ArmsCW:
        target = this.m_isFemale ? inkWidgetRef.Get(this.m_F_armsHoverTexture) : inkWidgetRef.Get(this.m_M_armsHoverTexture);
        break;
      case gamedataEquipmentArea.LegsCW:
        target = this.m_isFemale ? inkWidgetRef.Get(this.m_F_legsHoverTexture) : inkWidgetRef.Get(this.m_M_legsHoverTexture);
    };
    return target;
  }

  private final func HideAllBodyParts() -> Void {
    inkWidgetRef.SetOpacity(this.m_F_frontalCortexHoverTexture, 0.00);
    inkWidgetRef.SetOpacity(this.m_F_eyesHoverTexture, 0.00);
    inkWidgetRef.SetOpacity(this.m_F_cardiovascularHoverTexture, 0.00);
    inkWidgetRef.SetOpacity(this.m_F_immuneHoverTexture, 0.00);
    inkWidgetRef.SetOpacity(this.m_F_nervousHoverTexture, 0.00);
    inkWidgetRef.SetOpacity(this.m_F_integumentaryHoverTexture, 0.00);
    inkWidgetRef.SetOpacity(this.m_F_systemReplacementHoverTexture, 0.00);
    inkWidgetRef.SetOpacity(this.m_F_musculoskeletalHoverTexture, 0.00);
    inkWidgetRef.SetOpacity(this.m_F_handsHoverTexture, 0.00);
    inkWidgetRef.SetOpacity(this.m_F_armsHoverTexture, 0.00);
    inkWidgetRef.SetOpacity(this.m_F_legsHoverTexture, 0.00);
    inkWidgetRef.SetOpacity(this.m_M_frontalCortexHoverTexture, 0.00);
    inkWidgetRef.SetOpacity(this.m_M_eyesHoverTexture, 0.00);
    inkWidgetRef.SetOpacity(this.m_M_cardiovascularHoverTexture, 0.00);
    inkWidgetRef.SetOpacity(this.m_M_immuneHoverTexture, 0.00);
    inkWidgetRef.SetOpacity(this.m_M_nervousHoverTexture, 0.00);
    inkWidgetRef.SetOpacity(this.m_M_integumentaryHoverTexture, 0.00);
    inkWidgetRef.SetOpacity(this.m_M_systemReplacementHoverTexture, 0.00);
    inkWidgetRef.SetOpacity(this.m_M_musculoskeletalHoverTexture, 0.00);
    inkWidgetRef.SetOpacity(this.m_M_handsHoverTexture, 0.00);
    inkWidgetRef.SetOpacity(this.m_M_armsHoverTexture, 0.00);
    inkWidgetRef.SetOpacity(this.m_M_legsHoverTexture, 0.00);
  }
}
