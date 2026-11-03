
public class QuickhacksListItemController extends ListItemController {

  @default(QuickhacksListItemController, 0.2f)
  private let m_expandAnimationDuration: Float;

  private edit let m_icon: inkImageRef;

  private edit let m_description: inkTextRef;

  private edit let m_memoryValue: inkTextRef;

  private edit let m_memoryCells: inkCompoundRef;

  private edit let m_actionStateRoot: inkWidgetRef;

  private edit let m_actionStateText: inkTextRef;

  private edit let m_categoryRoot: inkWidgetRef;

  private edit let m_categoryText: inkTextRef;

  private edit let m_revealRoot: inkWidgetRef;

  private edit let m_revealText: inkTextRef;

  private edit let m_cooldownIcon: inkWidgetRef;

  private edit let m_cooldownValue: inkTextRef;

  private edit let m_descriptionSize: inkWidgetRef;

  private edit let m_costReductionArrow: inkImageRef;

  private edit let m_curveRadius: Float;

  @default(QuickhacksListItemController, false)
  private edit let m_categorizedHacks: Bool;

  @default(QuickhacksListItemController, false)
  private edit let m_colorCodedHacks: Bool;

  @default(QuickhacksListItemController, QuickHackAction.iconColorDamage)
  private edit let m_hackColorDamage: CName;

  @default(QuickhacksListItemController, QuickHackAction.iconColorControl)
  private edit let m_hackColorControl: CName;

  @default(QuickhacksListItemController, QuickHackAction.iconColorCovert)
  private edit let m_hackColorCovert: CName;

  @default(QuickhacksListItemController, QuickHackAction.iconColorUltimate)
  private edit let m_hackColorUltimate: CName;

  @default(QuickhacksListItemController, QuickHackAction.textColor)
  private edit let m_hackColorDefault: CName;

  private let m_selectedLoop: ref<inkAnimProxy>;

  private let m_currentAnimationName: CName;

  private let m_choiceAccepted: ref<inkAnimProxy>;

  private let m_resizeAnim: ref<inkAnimController>;

  private let m_root: wref<inkWidget>;

  private let m_data: ref<QuickhackData>;

  private let m_isSelected: Bool;

  private let m_expanded: Bool;

  private let m_cachedDescriptionSize: Vector2;

  private let m_defaultMargin: inkMargin;

  protected cb func OnInitialize() -> Bool {
    this.m_root = this.GetRootWidget();
    this.RegisterToCallback(n"OnSelected", this, n"OnSelected");
    this.RegisterToCallback(n"OnDeselected", this, n"OnDeselected");
    inkWidgetRef.SetVisible(this.m_description, false);
    this.AdjustToTextDescriptionSize(true);
  }

  protected cb func OnUninitialize() -> Bool {
    this.UnregisterFromCallback(n"OnSelected", this, n"OnSelected");
    this.UnregisterFromCallback(n"OnDeselected", this, n"OnDeselected");
  }

  protected cb func OnDataChanged(value: ref<IScriptable>) -> Bool {
    let currText: String;
    let textParams: ref<inkTextParams>;
    let hackColor: CName = this.m_hackColorDefault;
    this.m_currentAnimationName = n"None";
    this.m_data = value as QuickhackData;
    let hackCategory: ref<HackCategory_Record> = this.m_data.m_category;
    if this.m_colorCodedHacks && IsDefined(hackCategory) {
      if Equals(hackCategory.Type(), gamedataHackCategory.DamageHack) {
        hackColor = this.m_hackColorDamage;
      } else {
        if Equals(hackCategory.Type(), gamedataHackCategory.ControlHack) {
          hackColor = this.m_hackColorControl;
        } else {
          if Equals(hackCategory.Type(), gamedataHackCategory.CovertHack) {
            hackColor = this.m_hackColorCovert;
          } else {
            if Equals(hackCategory.Type(), gamedataHackCategory.UltimateHack) {
              hackColor = this.m_hackColorUltimate;
            };
          };
        };
      };
    };
    if TDBID.IsValid(this.m_data.m_icon) {
      InkImageUtils.RequestSetImage(this, this.m_icon, this.m_data.m_icon);
      if this.m_colorCodedHacks {
        inkWidgetRef.Get(this.m_icon).BindProperty(n"tintColor", hackColor);
      };
    };
    this.m_selectedLoop.UnregisterFromAllCallbacks(inkanimEventType.OnFinish);
    inkTextRef.SetText(this.m_labelPathRef, this.m_data.m_title);
    if this.m_categorizedHacks && IsDefined(hackCategory) {
      inkWidgetRef.SetVisible(this.m_categoryRoot, true);
      inkTextRef.SetLocalizedTextScript(this.m_categoryText, hackCategory.LocalizedDescription());
      if this.m_colorCodedHacks {
        inkWidgetRef.Get(this.m_categoryText).BindProperty(n"tintColor", hackColor);
      };
    } else {
      inkWidgetRef.SetVisible(this.m_categoryRoot, false);
    };
    if IsDefined(this.m_data) && IsStringValid(this.m_data.m_titleAlternative) {
      inkTextRef.SetText(this.m_labelPathRef, this.m_data.m_titleAlternative);
    } else {
      inkTextRef.SetText(this.m_labelPathRef, this.m_data.m_title);
    };
    inkWidgetRef.SetVisible(this.m_revealRoot, this.m_data.m_willReveal || this.m_data.m_showRevealInfo);
    if this.m_data.m_willReveal {
      inkTextRef.SetLocalizedTextString(this.m_revealText, "LocKey#92125");
    } else {
      if this.m_data.m_showRevealInfo {
        currText = GetLocalizedText("LocKey#92126");
        if this.m_data.m_awarenessCost < 0.00 {
          currText = StrReplace(currText, "+", "");
        };
        textParams = new inkTextParams();
        textParams.AddNumber("float_0", this.m_data.m_awarenessCost);
        inkTextRef.SetText(this.m_revealText, currText, textParams);
      };
    };
    this.SetCooldownVisibility(false);
    this.SetActionState();
    inkTextRef.SetText(this.m_memoryValue, IntToString(this.m_data.m_cost));
    this.UpdateState();
    this.ChangeMargin();
    this.SetReductionArrowVisibility();
  }

  protected cb func OnQuickhackDescriptionUpdate(evt: ref<QuickhackDescriptionUpdate>) -> Bool {
    this.m_cachedDescriptionSize = inkWidgetRef.GetDesiredSize(this.m_description);
    this.Expand(this.m_isSelected);
  }

  protected cb func OnSelected(itemController: wref<ListItemController>) -> Bool {
    this.m_isSelected = true;
    this.UpdateState();
  }

  protected cb func OnDeselected(itemController: wref<ListItemController>) -> Bool {
    this.m_isSelected = false;
    this.UpdateState();
  }

  private final func UpdateState() -> Void {
    if this.m_selectedLoop.IsPlaying() {
      this.m_selectedLoop.Stop();
    };
    if this.m_isSelected {
      if this.m_data.m_isLocked {
        this.GetRootWidget().SetState(n"LockedSelected");
        if NotEquals(this.m_currentAnimationName, n"lockedSelected") {
          this.PlayLibraryAnimation(n"loopSelected_out");
        };
        if !this.IsChoiceAcceptedPlaying() {
          this.m_selectedLoop = this.PlayLibraryAnimation(n"lockedSelected", GetAnimOptionsInfiniteLoop(inkanimLoopType.Cycle));
          this.m_currentAnimationName = n"lockedSelected";
        };
      } else {
        this.GetRootWidget().SetState(n"Selected");
        if NotEquals(this.m_currentAnimationName, n"loopSelected") {
          this.PlayLibraryAnimation(n"lockedSelected_out");
        };
        if !this.IsChoiceAcceptedPlaying() {
          this.m_selectedLoop = this.PlayLibraryAnimation(n"loopSelected", GetAnimOptionsInfiniteLoop(inkanimLoopType.Cycle));
          this.m_currentAnimationName = n"loopSelected";
        };
      };
    } else {
      if this.m_data.m_isLocked {
        this.GetRootWidget().SetState(n"Locked");
        this.m_selectedLoop = this.PlayLibraryAnimation(n"lockedSelected_out");
      } else {
        this.GetRootWidget().SetState(n"Default");
        this.m_selectedLoop = this.PlayLibraryAnimation(n"loopSelected_out");
      };
    };
  }

  protected cb func OnUpdateAnimationState(opt e: ref<inkAnimProxy>) -> Bool {
    this.UpdateState();
  }

  private final func SetActionState() -> Void {
    inkTextRef.SetLocalizationKeyString(this.m_actionStateText, QuickhacksListGameController.EActionInactivityResonToLocalizationString(this.m_data.m_actionState));
    if Equals(this.m_data.m_actionState, EActionInactivityReson.Ready) {
      inkWidgetRef.SetState(this.m_actionStateRoot, n"Default");
    } else {
      inkWidgetRef.SetState(this.m_actionStateRoot, n"Locked");
    };
  }

  private final func SetReductionArrowVisibility() -> Void {
    if Equals(this.m_data.m_type, gamedataObjectActionType.VehicleQuickHack) {
      inkWidgetRef.SetVisible(this.m_costReductionArrow, false);
    } else {
      if this.m_data.m_cost < this.m_data.m_costRaw {
        inkWidgetRef.SetVisible(this.m_costReductionArrow, true);
        inkImageRef.SetBrushMirrorType(this.m_costReductionArrow, inkBrushMirrorType.NoMirror);
        inkWidgetRef.SetState(this.m_costReductionArrow, n"Down");
      } else {
        if this.m_data.m_cost > this.m_data.m_costRaw {
          inkWidgetRef.SetVisible(this.m_costReductionArrow, true);
          inkImageRef.SetBrushMirrorType(this.m_costReductionArrow, inkBrushMirrorType.Vertical);
          inkWidgetRef.SetState(this.m_costReductionArrow, n"Up");
        } else {
          inkWidgetRef.SetVisible(this.m_costReductionArrow, false);
        };
      };
    };
  }

  public final func UpdateCooldown(cooldown: Float) -> Void {
    inkTextRef.SetText(this.m_cooldownValue, FloatToStringPrec(cooldown, 4));
    this.SetCooldownVisibility(true);
  }

  public final func SetCooldownVisibility(isVisible: Bool) -> Void {
    if NotEquals(inkWidgetRef.IsVisible(this.m_cooldownValue), isVisible) {
      if isVisible {
        this.m_data.m_actionState = EActionInactivityReson.Recompilation;
      };
      this.SetActionState();
      inkWidgetRef.SetVisible(this.m_cooldownValue, isVisible);
      inkWidgetRef.SetVisible(this.m_cooldownIcon, isVisible);
    };
  }

  private final func Expand(value: Bool, opt force: Bool) -> Void {
    let animSizeFrom: Vector2;
    let animSizeTo: Vector2;
    if Equals(this.m_expanded, value) && !force {
      return;
    };
    this.m_expanded = value;
    inkWidgetRef.SetVisible(this.m_description, this.m_expanded);
    if this.m_expanded {
      inkWidgetRef.SetVisible(this.m_description, true);
    };
    if IsDefined(this.m_resizeAnim) {
      this.m_resizeAnim.Stop();
    };
    this.m_resizeAnim = new inkAnimController();
    if this.m_expanded {
      animSizeFrom = new Vector2(0.00, 0.00);
      animSizeTo = this.m_cachedDescriptionSize;
      this.m_resizeAnim.Select(inkWidgetRef.Get(this.m_descriptionSize)).Interpolate(n"size", ToVariant(animSizeFrom), ToVariant(animSizeTo)).Duration(this.m_expandAnimationDuration).Type(inkanimInterpolationType.Exponential).Mode(inkanimInterpolationMode.EasyOut);
      this.m_resizeAnim.Play();
      this.m_resizeAnim.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnResizingFinished");
    } else {
      animSizeFrom = this.m_cachedDescriptionSize;
      animSizeTo = new Vector2(0.00, 0.00);
      this.m_resizeAnim.Select(inkWidgetRef.Get(this.m_descriptionSize)).Interpolate(n"size", ToVariant(animSizeFrom), ToVariant(animSizeTo)).Duration(this.m_expandAnimationDuration).Type(inkanimInterpolationType.Exponential).Mode(inkanimInterpolationMode.EasyOut);
      this.m_resizeAnim.Play();
      this.m_resizeAnim.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnResizingFinished");
    };
  }

  protected cb func OnResizingFinished(anim: ref<inkAnimProxy>) -> Bool {
    if !this.m_expanded {
      inkWidgetRef.SetVisible(this.m_description, false);
    };
    this.AdjustToTextDescriptionSize(true);
  }

  private final func ShowMemoryCell(value: Int32) -> Void {
    let i: Int32;
    inkCompoundRef.RemoveAllChildren(this.m_memoryCells);
    i = 0;
    while i < 1 {
      this.SpawnFromLocal(inkWidgetRef.Get(this.m_memoryCells) as inkCompoundWidget, n"memory_cell_small");
      i += 1;
    };
  }

  private final func AdjustToTextDescriptionSize(value: Bool) -> Void {
    if value {
      inkWidgetRef.SetVAlign(this.m_description, inkEVerticalAlign.Top);
      inkWidgetRef.SetHAlign(this.m_description, inkEHorizontalAlign.Left);
      inkWidgetRef.SetVAlign(this.m_descriptionSize, inkEVerticalAlign.Fill);
      inkWidgetRef.SetHAlign(this.m_descriptionSize, inkEHorizontalAlign.Fill);
    } else {
      inkWidgetRef.SetVAlign(this.m_description, inkEVerticalAlign.Fill);
      inkWidgetRef.SetHAlign(this.m_description, inkEHorizontalAlign.Fill);
      inkWidgetRef.SetVAlign(this.m_descriptionSize, inkEVerticalAlign.Top);
      inkWidgetRef.SetHAlign(this.m_descriptionSize, inkEHorizontalAlign.Left);
    };
  }

  private final func ChangeMargin() -> Void {
    let index: Float = Cast<Float>(this.GetIndex());
    let angleRange: Float = (Cast<Float>(Min(this.m_data.m_maxListSize, 8)) * 180.00) / 8.00;
    let anglePerItem: Float = angleRange / Cast<Float>(this.m_data.m_maxListSize);
    let angleOffset: Float = AbsF(angleRange * 0.50 - 90.00) + anglePerItem * 0.50;
    let offset: Float = this.m_curveRadius * SinF(Deg2Rad(angleOffset + anglePerItem * index));
    this.m_root.SetMargin(new inkMargin(-offset, 0.00, offset, 0.00));
  }

  public final func PlayChoiceAcceptedAnimation() -> Void {
    if !this.IsChoiceAcceptedPlaying() {
      if this.m_data.m_isLocked {
        this.m_choiceAccepted = this.PlayLibraryAnimation(n"click_locked");
      } else {
        this.m_choiceAccepted = this.PlayLibraryAnimation(n"choiceAccept");
      };
      this.m_choiceAccepted.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnUpdateAnimationState");
      if NotEquals(this.m_currentAnimationName, n"lockedSelected") {
        this.PlayLibraryAnimation(n"loopSelected_out");
      };
      if NotEquals(this.m_currentAnimationName, n"loopSelected") {
        this.PlayLibraryAnimation(n"lockedSelected_out");
      };
    };
  }

  private final func IsChoiceAcceptedPlaying() -> Bool {
    return this.m_choiceAccepted.IsPlaying();
  }
}
