
public class RipperdocTokenPopup extends inkGameController {

  @runtimeProperty("category", "Upgrade options")
  private edit let m_optionRef: [inkWidgetRef; 4];

  @runtimeProperty("category", "Upgrade options")
  private edit let m_optionTooltipParent: [inkWidgetRef; 4];

  @runtimeProperty("category", "Upgrade options")
  private edit let m_option1ProgressBarRef: inkWidgetRef;

  @runtimeProperty("category", "Upgrade options")
  private edit let m_option2ProgressBarRef: inkWidgetRef;

  @runtimeProperty("category", "Upgrade options")
  private edit let m_option3ProgressBarRef: inkWidgetRef;

  @runtimeProperty("category", "Upgrade options")
  private edit let m_option1HoverZone: inkWidgetRef;

  @runtimeProperty("category", "Upgrade options")
  private edit let m_option2HoverZone: inkWidgetRef;

  @runtimeProperty("category", "Upgrade options")
  private edit let m_option3HoverZone: inkWidgetRef;

  @runtimeProperty("category", "Upgrade options")
  @default(RipperdocTokenPopup, progress)
  private edit let m_progressEffectName: CName;

  @runtimeProperty("category", "Upgrade Button")
  private edit let m_option1UpgradeBtnAnchor: inkWidgetRef;

  @runtimeProperty("category", "Upgrade Button")
  private edit let m_option2UpgradeBtnAnchor: inkWidgetRef;

  @runtimeProperty("category", "Upgrade Button")
  private edit let m_option3UpgradeBtnAnchor: inkWidgetRef;

  @runtimeProperty("category", "Upgrade Button")
  private edit let m_upgradeBtnContainerRef: inkWidgetRef;

  @runtimeProperty("category", "Upgrade Button")
  private edit let m_upgradeButtonLabelKey: String;

  @runtimeProperty("category", "Upgrade Button")
  @default(RipperdocTokenPopup, 0.3f)
  private edit let m_upgradeButtonAnimDuration: Float;

  @runtimeProperty("category", "Upgrade Button")
  @default(RipperdocTokenPopup, base\gameplay\gui\common\tooltip\cyberware_tooltip_modules.inkwidget)
  private edit let m_upgradeButtonResRef: ResRef;

  @runtimeProperty("category", "Upgrade Button")
  @default(RipperdocTokenPopup, itemCyberwareUpgrade)
  private edit let m_upgradeButtonResName: CName;

  @runtimeProperty("category", "Animations")
  @runtimeProperty("tooltip", "Intro animation without choices (no Connoisseur perk)")
  private edit let m_noChoiceIntroAnimName: CName;

  @runtimeProperty("category", "Animations")
  @runtimeProperty("tooltip", "Intro animation with 2 choices (Connoisseur perk, low level CW)")
  private edit let m_twoChoiceIntroAnimName: CName;

  @runtimeProperty("category", "Animations")
  @runtimeProperty("tooltip", "Intro animation with 3 choices (Connoisseur perk, high level CW)")
  private edit let m_threeChoiceIntroAnimName: CName;

  @runtimeProperty("category", "Animations")
  @runtimeProperty("tooltip", "Outro animation without choices (no Connoisseur perk)")
  private edit let m_noChoiceOutroAnimName: CName;

  @runtimeProperty("category", "Animations")
  @runtimeProperty("tooltip", "Outro animation for 1st choice with 2 choices (Connoisseur perk, low level CW)")
  private edit let m_twoChoice1OutroAnimName: CName;

  @runtimeProperty("category", "Animations")
  @runtimeProperty("tooltip", "Outro animation for 2nd choice with 2 choices (Connoisseur perk, low level CW)")
  private edit let m_twoChoice2OutroAnimName: CName;

  @runtimeProperty("category", "Animations")
  @runtimeProperty("tooltip", "Outro animation for 1st choice with 3 choices (Connoisseur perk, high level CW)")
  private edit let m_threeChoice1OutroAnimName: CName;

  @runtimeProperty("category", "Animations")
  @runtimeProperty("tooltip", "Outro animation for 2nd choice with 3 choices (Connoisseur perk, high level CW)")
  private edit let m_threeChoice2OutroAnimName: CName;

  @runtimeProperty("category", "Animations")
  @runtimeProperty("tooltip", "Outro animation for 3rd choice with 3 choices (Connoisseur perk, high level CW)")
  private edit let m_threeChoice3OutroAnimName: CName;

  @runtimeProperty("category", "Input")
  private edit let m_holdInputName: CName;

  @runtimeProperty("category", "Input")
  @default(RipperdocTokenPopup, close_popup)
  private edit let m_exitInputName: CName;

  @runtimeProperty("category", "Input")
  private edit let m_buttonHintsRoot: inkWidgetRef;

  @runtimeProperty("category", "Tooltip")
  @default(RipperdocTokenPopup, base\gameplay\gui\common\tooltip\itemtooltip.inkwidget)
  private edit let m_itemToolitpResRef: ResRef;

  @runtimeProperty("category", "Tooltip")
  @default(RipperdocTokenPopup, itemTooltip)
  private edit let m_itemTooltipName: CName;

  @runtimeProperty("category", "Tooltip")
  @default(RipperdocTokenPopup, base\gameplay\gui\common\tooltip\cyberdecktooltip.inkwidget)
  private edit let m_cyberdeckToolitpResRef: ResRef;

  @runtimeProperty("category", "Tooltip")
  @default(RipperdocTokenPopup, cyberdeckTooltip)
  private edit let m_cyberdeckTooltipName: CName;

  private let m_toolitpWidgetRef: ResRef;

  private let m_tooltipName: CName;

  private let m_itemTooltipController0: wref<AGenericTooltipController>;

  private let m_itemTooltipController1: wref<AGenericTooltipController>;

  private let m_itemTooltipController2: wref<AGenericTooltipController>;

  private let m_itemTooltipController3: wref<AGenericTooltipController>;

  private let m_itemTooltipCyberwareUpgrade: wref<ItemTooltipCyberwareUpgradeController>;

  private let m_option1ProgressBar: wref<inkWidget>;

  private let m_option2ProgressBar: wref<inkWidget>;

  private let m_option3ProgressBar: wref<inkWidget>;

  private let m_audioSystem: wref<AudioSystem>;

  private let m_data: ref<RipperdocTokenPopupData>;

  private let m_multichoice: Bool;

  private let m_thirdChoiceAvailable: Bool;

  private let m_progressStarted: Bool;

  private let m_introAnimationPlaying: Bool;

  private let m_choicesAnimProxy: ref<inkAnimProxy>;

  private let m_buttonAnimProxy: ref<inkAnimProxy>;

  private let m_currentOption: Int32;

  @default(RipperdocTokenPopup, -1)
  private let m_choice: Int32;

  private let m_result: Bool;

  private let m_inputListenersRegistered: Bool;

  protected cb func OnInitialize() -> Bool {
    let player: wref<GameObject> = this.GetPlayerControlledObject();
    this.m_audioSystem = GameInstance.GetAudioSystem(player.GetGame());
    this.RegisterToGlobalInputCallback(n"OnPostOnPress", this, n"OnPressInput");
    this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnInputRelease");
    this.m_data = this.GetRootWidget().GetUserData(n"RipperdocTokenPopupData") as RipperdocTokenPopupData;
    if this.m_data.option1GameItemData.HasTag(n"Cyberdeck") || this.m_data.option2GameItemData.HasTag(n"Cyberdeck") || this.m_data.option3GameItemData.HasTag(n"Cyberdeck") {
      this.m_toolitpWidgetRef = this.m_cyberdeckToolitpResRef;
      this.m_tooltipName = this.m_cyberdeckTooltipName;
    } else {
      this.m_toolitpWidgetRef = this.m_itemToolitpResRef;
      this.m_tooltipName = this.m_itemTooltipName;
    };
    this.m_itemTooltipController0 = this.SpawnFromExternal(inkWidgetRef.Get(this.m_optionTooltipParent[0]), this.m_toolitpWidgetRef, this.m_tooltipName).GetController() as AGenericTooltipController;
    this.m_itemTooltipController1 = this.SpawnFromExternal(inkWidgetRef.Get(this.m_optionTooltipParent[1]), this.m_toolitpWidgetRef, this.m_tooltipName).GetController() as AGenericTooltipController;
    inkWidgetRef.SetVisible(this.m_upgradeBtnContainerRef, false);
    this.m_itemTooltipCyberwareUpgrade = this.SpawnFromExternal(inkWidgetRef.Get(this.m_upgradeBtnContainerRef), this.m_upgradeButtonResRef, this.m_upgradeButtonResName).GetController() as ItemTooltipCyberwareUpgradeController;
    this.m_itemTooltipCyberwareUpgrade.UpdateData(this.m_data.cyberwareUpgradeData);
    this.m_itemTooltipCyberwareUpgrade.ReplaceLabelText(GetLocalizedText(this.m_upgradeButtonLabelKey));
    this.m_option1ProgressBar = inkWidgetRef.Get(this.m_option1ProgressBarRef);
    if IsDefined(this.m_data.option2GameItemData) {
      this.m_itemTooltipController2 = this.SpawnFromExternal(inkWidgetRef.Get(this.m_optionTooltipParent[2]), this.m_toolitpWidgetRef, this.m_tooltipName).GetController() as AGenericTooltipController;
      this.m_option2ProgressBar = inkWidgetRef.Get(this.m_option2ProgressBarRef);
      this.m_multichoice = true;
    } else {
      inkWidgetRef.SetVisible(this.m_optionRef[2], false);
      inkWidgetRef.SetVisible(this.m_option2HoverZone, false);
    };
    if IsDefined(this.m_data.option3GameItemData) {
      this.m_itemTooltipController3 = this.SpawnFromExternal(inkWidgetRef.Get(this.m_optionTooltipParent[3]), this.m_toolitpWidgetRef, this.m_tooltipName).GetController() as AGenericTooltipController;
      this.m_option3ProgressBar = inkWidgetRef.Get(this.m_option3ProgressBarRef);
      this.m_multichoice = true;
      this.m_thirdChoiceAvailable = true;
      inkWidgetRef.SetSize(this.m_option1HoverZone, 1965.00, 400.00);
      inkWidgetRef.SetSize(this.m_option2HoverZone, 805.00, 400.00);
    } else {
      inkWidgetRef.SetVisible(this.m_optionRef[3], false);
      inkWidgetRef.SetVisible(this.m_option3HoverZone, false);
      this.m_thirdChoiceAvailable = false;
      inkWidgetRef.SetSize(this.m_option1HoverZone, 2365.00, 400.00);
      inkWidgetRef.SetSize(this.m_option2HoverZone, 1495.00, 400.00);
    };
    this.SetTooltipsData();
    if this.m_multichoice {
      inkWidgetRef.RegisterToCallback(this.m_option1HoverZone, n"OnHoverOver", this, n"OnOption1HoverOver");
      inkWidgetRef.RegisterToCallback(this.m_option2HoverZone, n"OnHoverOver", this, n"OnOption2HoverOver");
      inkWidgetRef.RegisterToCallback(this.m_option3HoverZone, n"OnHoverOver", this, n"OnOption3HoverOver");
      inkWidgetRef.RegisterToCallback(this.m_option1HoverZone, n"OnHoverOut", this, n"OnOptionOnHoverOut");
      inkWidgetRef.RegisterToCallback(this.m_option2HoverZone, n"OnHoverOut", this, n"OnOptionOnHoverOut");
      inkWidgetRef.RegisterToCallback(this.m_option3HoverZone, n"OnHoverOut", this, n"OnOptionOnHoverOut");
      inkWidgetRef.RegisterToCallback(this.m_option1HoverZone, n"OnPress", this, n"OnOption1Press");
      inkWidgetRef.RegisterToCallback(this.m_option2HoverZone, n"OnPress", this, n"OnOption2Press");
      inkWidgetRef.RegisterToCallback(this.m_option3HoverZone, n"OnPress", this, n"OnOption3Press");
      inkWidgetRef.RegisterToCallback(this.m_option1HoverZone, n"OnHold", this, n"OnOption1Hold");
      inkWidgetRef.RegisterToCallback(this.m_option2HoverZone, n"OnHold", this, n"OnOption2Hold");
      inkWidgetRef.RegisterToCallback(this.m_option3HoverZone, n"OnHold", this, n"OnOption3Hold");
      this.m_choicesAnimProxy = this.PlayLibraryAnimation(this.m_thirdChoiceAvailable ? this.m_threeChoiceIntroAnimName : this.m_twoChoiceIntroAnimName);
    } else {
      this.RegisterToGlobalInputCallback(n"OnPostOnPress", this, n"OnOption1Press");
      this.RegisterToGlobalInputCallback(n"OnPostOnHold", this, n"OnOption1Hold");
      inkWidgetRef.SetState(this.m_optionRef[1], n"Hover");
      inkWidgetRef.SetVisible(this.m_option1HoverZone, false);
      this.m_choicesAnimProxy = this.PlayLibraryAnimation(this.m_noChoiceIntroAnimName);
    };
    this.m_choicesAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnIntroFinished");
    this.m_currentOption = 1;
    this.m_introAnimationPlaying = true;
    this.m_inputListenersRegistered = true;
    this.m_progressStarted = false;
  }

  protected cb func OnIntroFinished(anim: ref<inkAnimProxy>) -> Bool {
    let targetBtnAnchor: inkWidgetRef;
    switch this.m_currentOption {
      case 1:
        targetBtnAnchor = this.m_option1UpgradeBtnAnchor;
        break;
      case 2:
        targetBtnAnchor = this.m_option2UpgradeBtnAnchor;
        break;
      case 3:
        targetBtnAnchor = this.m_option3UpgradeBtnAnchor;
        break;
      default:
        targetBtnAnchor = this.m_option1UpgradeBtnAnchor;
    };
    this.MoveButtonToOption(this.m_upgradeBtnContainerRef, targetBtnAnchor, true);
    inkWidgetRef.SetState(this.m_optionRef[Clamp(this.m_currentOption, 1, 3)], n"Hover");
    inkWidgetRef.SetVisible(this.m_upgradeBtnContainerRef, true);
    this.SetButtonHints();
    this.m_choicesAnimProxy.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnIntorFinished");
    this.m_introAnimationPlaying = false;
  }

  protected cb func OnUninitialize() -> Bool {
    this.UnregisterInputListeners();
  }

  private final func UnregisterInputListeners() -> Void {
    if this.m_inputListenersRegistered {
      this.UnregisterFromGlobalInputCallback(n"OnPostOnPress", this, n"OnPressInput");
      this.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"OnInputRelease");
      if this.m_multichoice {
        inkWidgetRef.UnregisterFromCallback(this.m_option1HoverZone, n"OnHoverOver", this, n"OnOption1HoverOver");
        inkWidgetRef.UnregisterFromCallback(this.m_option2HoverZone, n"OnHoverOver", this, n"OnOption2HoverOver");
        inkWidgetRef.UnregisterFromCallback(this.m_option3HoverZone, n"OnHoverOver", this, n"OnOption3HoverOver");
        inkWidgetRef.UnregisterFromCallback(this.m_option1HoverZone, n"OnHoverOut", this, n"OnOptionOnHoverOut");
        inkWidgetRef.UnregisterFromCallback(this.m_option2HoverZone, n"OnHoverOut", this, n"OnOptionOnHoverOut");
        inkWidgetRef.UnregisterFromCallback(this.m_option3HoverZone, n"OnHoverOut", this, n"OnOptionOnHoverOut");
        inkWidgetRef.UnregisterFromCallback(this.m_option1HoverZone, n"OnPress", this, n"OnOption1Press");
        inkWidgetRef.UnregisterFromCallback(this.m_option2HoverZone, n"OnPress", this, n"OnOption2Press");
        inkWidgetRef.UnregisterFromCallback(this.m_option3HoverZone, n"OnPress", this, n"OnOption3Press");
        inkWidgetRef.UnregisterFromCallback(this.m_option1HoverZone, n"OnHold", this, n"OnOption1Hold");
        inkWidgetRef.UnregisterFromCallback(this.m_option2HoverZone, n"OnHold", this, n"OnOption2Hold");
        inkWidgetRef.UnregisterFromCallback(this.m_option3HoverZone, n"OnHold", this, n"OnOption3Hold");
      } else {
        this.UnregisterFromGlobalInputCallback(n"OnPostOnPress", this, n"OnOption1Press");
        this.UnregisterFromGlobalInputCallback(n"OnPostOnHold", this, n"OnOption1Hold");
      };
      this.m_inputListenersRegistered = false;
      inkWidgetRef.SetVisible(this.m_buttonHintsRoot, false);
    };
  }

  private final func SetTooltipsData() -> Void {
    let tooltipWrapper: ref<UIInventoryItemTooltipWrapper>;
    if this.m_itemTooltipController0 != null {
      this.m_itemTooltipController0.GetRootWidget().SetVisible(true);
      this.m_itemTooltipController0.SetData(UIInventoryItemTooltipWrapper.Make(this.m_data.baseItemData, this.m_data.displayContext));
    };
    if this.m_itemTooltipController1 != null {
      this.m_itemTooltipController1.GetRootWidget().SetVisible(true);
      tooltipWrapper = UIInventoryItemTooltipWrapper.Make(this.m_data.option1InventoryItem, this.m_data.displayContext);
      tooltipWrapper.m_comparisonData = UIInventoryItemComparisonManager.Make(this.m_data.baseItemData, this.m_data.option1InventoryItem);
      this.m_itemTooltipController1.SetData(tooltipWrapper);
    };
    if this.m_itemTooltipController2 != null {
      this.m_itemTooltipController2.GetRootWidget().SetVisible(true);
      tooltipWrapper = UIInventoryItemTooltipWrapper.Make(this.m_data.option2InventoryItem, this.m_data.displayContext);
      tooltipWrapper.m_comparisonData = UIInventoryItemComparisonManager.Make(this.m_data.baseItemData, this.m_data.option1InventoryItem);
      this.m_itemTooltipController2.SetData(tooltipWrapper);
    };
    if this.m_itemTooltipController3 != null {
      this.m_itemTooltipController3.GetRootWidget().SetVisible(true);
      tooltipWrapper = UIInventoryItemTooltipWrapper.Make(this.m_data.option3InventoryItem, this.m_data.displayContext);
      tooltipWrapper.m_comparisonData = UIInventoryItemComparisonManager.Make(this.m_data.baseItemData, this.m_data.option1InventoryItem);
      this.m_itemTooltipController3.SetData(tooltipWrapper);
    };
    if this.m_itemTooltipController0 != null {
      this.m_data.baseItemData.GetStatsManager().GetWeaponBars().SetComparedBars(null);
    };
  }

  private final func SetButtonHints() -> Void {
    this.AddButtonHints(this.m_exitInputName, "UI-ResourceExports-Cancel", false);
  }

  private final func AddButtonHints(actionName: CName, const label: script_ref<String>, isHold: Bool) -> Void {
    let buttonHint: ref<LabelInputDisplayController> = this.SpawnFromExternal(inkWidgetRef.Get(this.m_buttonHintsRoot), r"base\\gameplay\\gui\\common\\buttons\\base_buttons.inkwidget", n"inputDisplayLabelFlex").GetController() as LabelInputDisplayController;
    buttonHint.SetInputActionLabel(actionName, label);
    if isHold {
      buttonHint.SetHoldIndicatorType(inkInputHintHoldIndicationType.Hold);
    };
  }

  private final func SetCursorVisible(visible: Bool) -> Void {
    let cursorEvt: ref<inkGameNotificationLayer_SetCursorVisibility> = new inkGameNotificationLayer_SetCursorVisibility();
    cursorEvt.Init(visible);
    this.QueueEvent(cursorEvt);
  }

  private final func ForceResetCursor() -> Void {
    let cursorEvt: ref<inkMenuLayer_SetCursorType> = new inkMenuLayer_SetCursorType();
    cursorEvt.Init(n"default", true);
    this.QueueBroadcastEvent(cursorEvt);
  }

  private final func Close() -> Void {
    let closeData: ref<RipperdocTokenPopupCloseData> = new RipperdocTokenPopupCloseData();
    closeData.confirm = this.m_result;
    closeData.chosenOptionIndex = this.m_choice;
    if this.m_result {
      this.m_audioSystem.Play(n"ui_menu_item_crafting_done");
    };
    switch this.m_choice {
      case 0:
        closeData.chosenOptionData = this.m_data.option1GameItemData;
        break;
      case 1:
        closeData.chosenOptionData = this.m_data.option2GameItemData;
        break;
      default:
        closeData.chosenOptionData = this.m_data.option3GameItemData;
    };
    closeData.costData = this.m_data.costData;
    this.SetCursorVisible(true);
    this.ForceResetCursor();
    this.m_data.token.TriggerCallback(closeData);
  }

  private final func NavigateOptions(navDirection: ECustomFilterDPadNavigationOption) -> Void {
    let lastOption: Int32 = this.m_thirdChoiceAvailable ? 3 : 2;
    switch navDirection {
      case ECustomFilterDPadNavigationOption.SelectNext:
        this.m_currentOption = this.m_currentOption < lastOption ? this.m_currentOption + 1 : 1;
        break;
      case ECustomFilterDPadNavigationOption.SelectPrev:
        this.m_currentOption = this.m_currentOption > 1 ? this.m_currentOption - 1 : lastOption;
    };
    this.SetCursorOverWidget(inkWidgetRef.Get(this.m_optionTooltipParent[this.m_currentOption]), 0.00, true);
  }

  private final func ResetProgress() -> Void {
    this.m_progressStarted = false;
    if IsDefined(this.m_option1ProgressBar) {
      this.m_option1ProgressBar.SetEffectParamValue(inkEffectType.LinearWipe, this.m_progressEffectName, n"transition", 1.00);
      this.m_option1ProgressBar.SetEffectEnabled(inkEffectType.LinearWipe, this.m_progressEffectName, false);
      inkWidgetRef.SetVisible(this.m_option1ProgressBarRef, false);
    };
    if IsDefined(this.m_option2ProgressBar) {
      this.m_option2ProgressBar.SetEffectParamValue(inkEffectType.LinearWipe, this.m_progressEffectName, n"transition", 1.00);
      this.m_option2ProgressBar.SetEffectEnabled(inkEffectType.LinearWipe, this.m_progressEffectName, false);
      inkWidgetRef.SetVisible(this.m_option2ProgressBarRef, false);
    };
    if IsDefined(this.m_option3ProgressBar) {
      this.m_option3ProgressBar.SetEffectParamValue(inkEffectType.LinearWipe, this.m_progressEffectName, n"transition", 1.00);
      this.m_option3ProgressBar.SetEffectEnabled(inkEffectType.LinearWipe, this.m_progressEffectName, false);
      inkWidgetRef.SetVisible(this.m_option3ProgressBarRef, false);
    };
    this.m_itemTooltipCyberwareUpgrade.ResetProgress();
  }

  protected final func MoveButtonToOption(button: inkWidgetRef, anchor: inkWidgetRef, instant: Bool) -> Void {
    let animation: ref<inkAnimDef>;
    let horizontalDelta: Float;
    let marginInterpolator: ref<inkAnimMargin>;
    let newLeftMargin: Float;
    let newMargin: inkMargin;
    let newTopMargin: Float;
    let oldMargin: inkMargin;
    let verticalDelta: Float;
    let distance: Vector2 = WidgetUtils.WidgetToWidget(inkWidgetRef.Get(button), inkWidgetRef.Get(anchor));
    if this.m_buttonAnimProxy != null {
      this.m_buttonAnimProxy.GotoEndAndStop();
    };
    oldMargin = inkWidgetRef.GetMargin(button);
    newLeftMargin = distance.X;
    newTopMargin = distance.Y;
    newMargin = new inkMargin(newLeftMargin, newTopMargin, oldMargin.right, oldMargin.bottom);
    if instant {
      inkWidgetRef.SetMargin(button, newMargin);
    } else {
      horizontalDelta = AbsF(oldMargin.left - distance.X);
      verticalDelta = AbsF(oldMargin.top - distance.Y);
      if horizontalDelta != 0.00 || verticalDelta != 0.00 {
        marginInterpolator = new inkAnimMargin();
        marginInterpolator.SetDuration(this.m_upgradeButtonAnimDuration);
        marginInterpolator.SetStartMargin(oldMargin);
        marginInterpolator.SetEndMargin(newMargin);
        marginInterpolator.SetType(inkanimInterpolationType.Sinusoidal);
        marginInterpolator.SetMode(inkanimInterpolationMode.EasyOut);
        animation = new inkAnimDef();
        animation.AddInterpolator(marginInterpolator);
        this.m_buttonAnimProxy = inkWidgetRef.PlayAnimation(button, animation);
      };
    };
  }

  private final func PlayOutro() -> Void {
    this.UnregisterInputListeners();
    inkWidgetRef.SetVisible(this.m_upgradeBtnContainerRef, false);
    this.SetCursorVisible(false);
    if !this.m_multichoice {
      this.PlayRumble(RumbleStrength.Heavy, RumbleType.Fast, RumblePosition.Both);
      this.m_choicesAnimProxy = this.PlayLibraryAnimation(this.m_noChoiceOutroAnimName);
      this.m_choicesAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnOutroFinished");
    } else {
      if this.m_choice == 0 {
        this.PlayRumble(RumbleStrength.Heavy, RumbleType.Fast, RumblePosition.Both);
        this.m_choicesAnimProxy = this.PlayLibraryAnimation(this.m_thirdChoiceAvailable ? this.m_threeChoice1OutroAnimName : this.m_twoChoice1OutroAnimName);
        this.m_choicesAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnOutroFinished");
      } else {
        if this.m_choice == 1 {
          this.PlayRumble(RumbleStrength.Heavy, RumbleType.Fast, RumblePosition.Both);
          this.m_choicesAnimProxy = this.PlayLibraryAnimation(this.m_thirdChoiceAvailable ? this.m_threeChoice2OutroAnimName : this.m_twoChoice2OutroAnimName);
          this.m_choicesAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnOutroFinished");
        } else {
          if this.m_choice == 2 {
            this.PlayRumble(RumbleStrength.Heavy, RumbleType.Fast, RumblePosition.Both);
            this.m_choicesAnimProxy = this.PlayLibraryAnimation(this.m_threeChoice3OutroAnimName);
            this.m_choicesAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnOutroFinished");
          } else {
            this.Close();
          };
        };
      };
    };
  }

  protected cb func OnOutroFinished(anim: ref<inkAnimProxy>) -> Bool {
    this.m_choicesAnimProxy.UnregisterFromAllCallbacks(inkanimEventType.OnFinish);
    this.Close();
  }

  protected cb func OnPressInput(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(this.m_exitInputName) {
      this.m_choice = -1;
      this.m_result = false;
      this.Close();
    };
    if evt.IsAction(this.m_holdInputName) || evt.IsAction(n"click_hold") {
      this.m_audioSystem.Play(n"ui_menu_item_crafting_start");
    };
    if this.m_multichoice && evt.IsAction(n"popup_moveRight") {
      this.NavigateOptions(ECustomFilterDPadNavigationOption.SelectNext);
    } else {
      if this.m_multichoice && evt.IsAction(n"popup_moveLeft") {
        this.NavigateOptions(ECustomFilterDPadNavigationOption.SelectPrev);
      };
    };
  }

  protected cb func OnInputRelease(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(this.m_holdInputName) || evt.IsAction(n"click_hold") {
      this.m_audioSystem.Play(n"ui_menu_item_crafting_fail");
      this.ResetProgress();
    };
  }

  protected cb func OnOption1HoverOver(evt: ref<inkPointerEvent>) -> Bool {
    if this.m_introAnimationPlaying {
      this.m_currentOption = 1;
    } else {
      this.MoveButtonToOption(this.m_upgradeBtnContainerRef, this.m_option1UpgradeBtnAnchor, false);
      inkWidgetRef.SetState(this.m_optionRef[1], n"Hover");
    };
  }

  protected cb func OnOption2HoverOver(evt: ref<inkPointerEvent>) -> Bool {
    if this.m_introAnimationPlaying {
      this.m_currentOption = 2;
    } else {
      this.MoveButtonToOption(this.m_upgradeBtnContainerRef, this.m_option2UpgradeBtnAnchor, false);
      inkWidgetRef.SetState(this.m_optionRef[2], n"Hover");
    };
  }

  protected cb func OnOption3HoverOver(evt: ref<inkPointerEvent>) -> Bool {
    if this.m_introAnimationPlaying {
      this.m_currentOption = 3;
    } else {
      this.MoveButtonToOption(this.m_upgradeBtnContainerRef, this.m_option3UpgradeBtnAnchor, false);
      inkWidgetRef.SetState(this.m_optionRef[3], n"Hover");
    };
  }

  protected cb func OnOptionOnHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    this.m_audioSystem.Play(n"ui_menu_item_crafting_fail");
    inkWidgetRef.SetState(this.m_optionRef[1], n"Default");
    inkWidgetRef.SetState(this.m_optionRef[2], n"Default");
    inkWidgetRef.SetState(this.m_optionRef[3], n"Default");
    this.ResetProgress();
  }

  protected cb func OnOption1Press(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(this.m_holdInputName) || evt.IsAction(n"click_hold") {
      if IsDefined(this.m_option1ProgressBar) {
        inkWidgetRef.SetVisible(this.m_option1ProgressBarRef, true);
        this.m_option1ProgressBar.SetEffectEnabled(inkEffectType.LinearWipe, this.m_progressEffectName, true);
      };
      this.m_progressStarted = true;
    };
  }

  protected cb func OnOption2Press(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(this.m_holdInputName) || evt.IsAction(n"click_hold") {
      if IsDefined(this.m_option2ProgressBar) {
        inkWidgetRef.SetVisible(this.m_option2ProgressBarRef, true);
        this.m_option2ProgressBar.SetEffectEnabled(inkEffectType.LinearWipe, this.m_progressEffectName, true);
      };
      this.m_progressStarted = true;
    };
  }

  protected cb func OnOption3Press(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(this.m_holdInputName) || evt.IsAction(n"click_hold") {
      if IsDefined(this.m_option3ProgressBar) {
        inkWidgetRef.SetVisible(this.m_option3ProgressBarRef, true);
        this.m_option3ProgressBar.SetEffectEnabled(inkEffectType.LinearWipe, this.m_progressEffectName, true);
      };
      this.m_progressStarted = true;
    };
  }

  protected cb func OnOption1Hold(evt: ref<inkPointerEvent>) -> Bool {
    let progress: Float;
    if (evt.IsAction(this.m_holdInputName) || evt.IsAction(n"click_hold")) && this.m_progressStarted {
      progress = MinF(evt.GetHoldProgress(), 1.00);
      if IsDefined(this.m_option1ProgressBar) {
        this.m_option1ProgressBar.SetEffectParamValue(inkEffectType.LinearWipe, this.m_progressEffectName, n"transition", AbsF(1.00 - progress));
      };
      if progress >= 1.00 {
        this.m_choice = 0;
        this.m_result = true;
        this.PlayOutro();
      };
    };
  }

  protected cb func OnOption2Hold(evt: ref<inkPointerEvent>) -> Bool {
    let progress: Float;
    if (evt.IsAction(this.m_holdInputName) || evt.IsAction(n"click_hold")) && this.m_progressStarted {
      progress = MinF(evt.GetHoldProgress(), 1.00);
      if IsDefined(this.m_option2ProgressBar) {
        this.m_option2ProgressBar.SetEffectParamValue(inkEffectType.LinearWipe, this.m_progressEffectName, n"transition", AbsF(1.00 - progress));
      };
      if progress >= 1.00 {
        this.m_choice = 1;
        this.m_result = true;
        this.PlayOutro();
      };
    };
  }

  protected cb func OnOption3Hold(evt: ref<inkPointerEvent>) -> Bool {
    let progress: Float;
    if (evt.IsAction(this.m_holdInputName) || evt.IsAction(n"click_hold")) && this.m_progressStarted {
      progress = MinF(evt.GetHoldProgress(), 1.00);
      if IsDefined(this.m_option3ProgressBar) {
        this.m_option3ProgressBar.SetEffectParamValue(inkEffectType.LinearWipe, this.m_progressEffectName, n"transition", AbsF(1.00 - progress));
      };
      if progress >= 1.00 {
        this.m_choice = 2;
        this.m_result = true;
        this.PlayOutro();
      };
    };
  }
}
