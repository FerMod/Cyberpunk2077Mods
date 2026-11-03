
public class NewPerksAttributeButtonController extends inkLogicController {

  private edit let m_attributePointsButton: inkWidgetRef;

  private edit let m_attributeText: inkTextRef;

  private edit let m_currentText: inkTextRef;

  private edit let m_textGhost: inkTextRef;

  private edit let m_requirementText: inkTextRef;

  private edit let m_buttonWidget: inkWidgetRef;

  private let m_buttonHintsController: wref<ButtonHints>;

  private let m_totalPoints: Int32;

  private let m_initData: ref<NewPerksScreenInitData>;

  @default(NewPerksAttributeButtonController, false)
  private let m_isHovered: Bool;

  @default(NewPerksAttributeButtonController, false)
  private let m_isPressed: Bool;

  private let idleAnimProxy: ref<inkAnimProxy>;

  protected cb func OnInitialize() -> Bool {
    inkWidgetRef.RegisterToCallback(this.m_attributePointsButton, n"OnPress", this, n"OnAttributeInvestPress");
    inkWidgetRef.RegisterToCallback(this.m_attributePointsButton, n"OnHold", this, n"OnAttributeInvestHold");
    inkWidgetRef.RegisterToCallback(this.m_attributePointsButton, n"OnRelease", this, n"OnAttributeInvestRelease");
    inkWidgetRef.RegisterToCallback(this.m_attributePointsButton, n"OnHoverOver", this, n"OnAttributeInvestHoverOver");
    inkWidgetRef.RegisterToCallback(this.m_attributePointsButton, n"OnHoverOut", this, n"OnAttributeInvestHoverOut");
  }

  protected cb func OnUninitialize() -> Bool {
    inkWidgetRef.UnregisterFromCallback(this.m_attributePointsButton, n"OnPress", this, n"OnAttributeInvestPress");
    inkWidgetRef.UnregisterFromCallback(this.m_attributePointsButton, n"OnHold", this, n"OnAttributeInvestHold");
    inkWidgetRef.UnregisterFromCallback(this.m_attributePointsButton, n"OnRelease", this, n"OnAttributeInvestRelease");
    inkWidgetRef.UnregisterFromCallback(this.m_attributePointsButton, n"OnHoverOver", this, n"OnAttributeInvestHoverOver");
    inkWidgetRef.UnregisterFromCallback(this.m_attributePointsButton, n"OnHoverOut", this, n"OnAttributeInvestHoverOut");
  }

  public final func SetData(initData: ref<NewPerksScreenInitData>, buttonHintsController: wref<ButtonHints>) -> Void {
    this.m_initData = initData;
    this.m_buttonHintsController = buttonHintsController;
    inkTextRef.SetText(this.m_attributeText, GetLocalizedText(PerkAttributeHelper.GetShortNameLocKey(this.m_initData.perkMenuAttribute)));
  }

  public final func PlayIdleAnimation() -> Void {
    let playbackOptions: inkAnimOptions;
    this.StopIdleAnimation();
    if this.m_isHovered || this.m_totalPoints <= 0 || !inkWidgetRef.IsInteractive(this.m_buttonWidget) {
      return;
    };
    playbackOptions.executionDelay = 1.00;
    playbackOptions.loopType = inkanimLoopType.Cycle;
    playbackOptions.loopInfinite = true;
    this.idleAnimProxy = this.PlayLibraryAnimation(n"tier_button_anim_idle", playbackOptions);
  }

  public final func StopIdleAnimation() -> Void {
    if IsDefined(this.idleAnimProxy) && this.idleAnimProxy.IsPlaying() {
      this.idleAnimProxy.GotoEndAndStop();
    };
  }

  public final func SetValues(currentPoints: Int32, requiredPoints: Int32, totalPoints: Int32) -> Void {
    inkTextRef.SetText(this.m_currentText, IntToString(currentPoints));
    inkTextRef.SetText(this.m_requirementText, IntToString(requiredPoints));
    inkTextRef.SetText(this.m_textGhost, IntToString(currentPoints));
    this.m_totalPoints = totalPoints;
    this.UpdateState();
  }

  public final func SetInteractive(value: Bool) -> Void {
    inkWidgetRef.SetInteractive(this.m_buttonWidget, value);
    if !value {
      this.m_buttonHintsController.RemoveButtonHint(n"upgrade_attribute_button");
    };
  }

  private final func UpdateState() -> Void {
    if this.m_totalPoints > 0 {
      this.PlayIdleAnimation();
      inkWidgetRef.SetState(this.m_attributePointsButton, this.m_isHovered ? n"Hover" : n"Default");
    } else {
      this.StopIdleAnimation();
      inkWidgetRef.SetState(this.m_attributePointsButton, this.m_isHovered ? n"DisabledHover" : n"Disabled");
    };
  }

  private final func UpdateCursorData() -> Void {
    let cursorData: ref<MenuCursorUserData>;
    if this.m_isPressed && this.m_totalPoints > 0 {
      cursorData = new MenuCursorUserData();
      cursorData.SetAnimationOverride(n"hoverOnHoldToComplete");
      cursorData.AddAction(n"upgrade_attribute_button");
      this.SetCursorContext(n"Hover", cursorData);
      this.PlayRumbleLoop(RumbleStrength.SuperLight);
    } else {
      this.SetCursorContext(n"Hover");
      this.StopRumbleLoop(RumbleStrength.SuperLight);
    };
  }

  protected cb func OnAttributeInvestPress(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"upgrade_attribute_button") {
      this.m_isPressed = true;
      this.UpdateCursorData();
      if this.m_totalPoints > 0 {
        this.PlaySound(n"Attributes", n"OnStart");
        inkWidgetRef.SetState(this.m_attributePointsButton, n"Press");
      } else {
        this.PlaySound(n"Attributes", n"OnFail");
        this.PlayLibraryAnimation(n"tier_button_anim_locked");
      };
    };
  }

  protected cb func OnAttributeInvestHold(evt: ref<inkPointerEvent>) -> Bool {
    let holdFinishedEvent: ref<NewPerksTabAttributeInvestHoldFinished>;
    let progress: Float;
    if evt.IsAction(n"upgrade_attribute_button") {
      if !this.m_isPressed {
        this.m_isPressed = true;
        this.UpdateCursorData();
      };
      progress = MinF(evt.GetHoldProgress(), 1.00);
      if progress >= 1.00 {
        holdFinishedEvent = new NewPerksTabAttributeInvestHoldFinished();
        holdFinishedEvent.attribute = this.m_initData.perkMenuAttribute;
        this.QueueEvent(holdFinishedEvent);
        this.m_isPressed = false;
        this.UpdateCursorData();
        this.UpdateState();
        if this.m_totalPoints > 0 {
          this.PlayLibraryAnimation(n"tier_button_anim_hoverClick");
        };
      };
    };
  }

  protected cb func OnAttributeInvestRelease(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"upgrade_attribute_button") {
      this.m_isPressed = false;
      this.UpdateCursorData();
      this.UpdateState();
    };
  }

  protected cb func OnAttributeInvestHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    this.m_isHovered = true;
    this.UpdateState();
    this.UpdateCursorData();
    this.StopIdleAnimation();
    if this.m_totalPoints > 0 {
      this.m_buttonHintsController.AddButtonHint(n"upgrade_attribute_button", GetLocalizedText("LocKey#49715"));
    };
  }

  protected cb func OnAttributeInvestHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    this.HoverOut();
  }

  public final func HoverOut() -> Void {
    this.m_isHovered = false;
    this.m_isPressed = false;
    this.UpdateState();
    this.UpdateCursorData();
    this.PlayIdleAnimation();
    this.m_buttonHintsController.RemoveButtonHint(n"upgrade_attribute_button");
  }
}
