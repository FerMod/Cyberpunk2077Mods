
public class CheckYaibaOption extends inkLogicController {

  private edit let m_checkBox: inkWidgetRef;

  private edit let m_checkMark: inkWidgetRef;

  private edit let m_option: MuramasaOption;

  private let m_defaultOpacity: Float;

  @default(CheckYaibaOption, false)
  private let m_isChecked: Bool;

  @default(CheckYaibaOption, false)
  private let m_isHovered: Bool;

  @default(CheckYaibaOption, false)
  private let m_isEnabled: Bool;

  private let m_previewController: wref<YaibaOptionPreview>;

  public final func Initialize(gameInstance: GameInstance, preview: wref<inkWidget>, fact: CName) -> Void {
    this.m_defaultOpacity = inkWidgetRef.GetOpacity(this.m_checkBox);
    this.RegisterToCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.RegisterToCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.RegisterToCallback(n"OnRelease", this, n"OnRelease");
    this.m_isChecked = GetFact(gameInstance, fact) == 1;
    this.m_previewController = preview.GetController() as YaibaOptionPreview;
    this.m_previewController.SetActive(this.m_isChecked);
    this.RefreshVisibility();
  }

  public final func Uninitialize() -> Void {
    this.UnregisterFromCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.UnregisterFromCallback(n"OnHoverOut", this, n"OnHoverOut");
    this.UnregisterFromCallback(n"OnRelease", this, n"OnRelease");
  }

  public final func SetEnabled(enabled: Bool) -> Void {
    this.m_isEnabled = enabled;
    this.RefreshVisibility();
  }

  protected cb func OnHoverOver(e: ref<inkPointerEvent>) -> Bool {
    if !this.m_isEnabled || e.IsHandled() {
      return false;
    };
    this.m_previewController.SetHovered(true);
    this.m_isHovered = true;
    this.RefreshVisibility();
  }

  protected cb func OnHoverOut(e: ref<inkPointerEvent>) -> Bool {
    if !this.m_isEnabled || e.IsHandled() {
      return false;
    };
    this.m_previewController.SetHovered(false);
    this.m_isHovered = false;
    this.RefreshVisibility();
  }

  protected cb func OnRelease(e: ref<inkPointerEvent>) -> Bool {
    if !this.m_isEnabled || this.m_previewController.IsAnimated() || e.IsHandled() {
      return false;
    };
    if e.IsAction(n"click") {
      this.m_isChecked = !this.m_isChecked;
      this.m_previewController.SetActive(this.m_isChecked);
      this.RefreshVisibility();
      this.CallCustomCallback(n"OnValueChanged");
      e.Handle();
    };
  }

  private final func RefreshVisibility() -> Void {
    inkWidgetRef.SetVisible(this.m_checkMark, this.m_isChecked || this.m_isHovered);
    inkWidgetRef.SetOpacity(this.m_checkBox, this.m_isEnabled && this.m_isHovered ? 1.00 : this.m_defaultOpacity);
  }

  public final func IsChecked() -> Bool {
    return this.m_isChecked;
  }

  public final func IsHovered() -> Bool {
    return this.m_isHovered;
  }

  public final func GetOption() -> MuramasaOption {
    return this.m_option;
  }

  public final const func GetSelectionAnim() -> CName {
    return this.m_previewController.GetSelectionAnim();
  }

  public final const func GetRemovalAnim() -> CName {
    return this.m_previewController.GetRemovalAnim();
  }
}

public class YaibaOptionPreview extends inkLogicController {

  private edit let m_selectionPreviewRef: inkWidgetRef;

  private edit let m_removalPreviewRef: inkWidgetRef;

  private edit let m_selectionAnimName: CName;

  private edit let m_removalAnimName: CName;

  private let m_active: Bool;

  @default(YaibaOptionPreview, false)
  private let m_isAnimated: Bool;

  private let m_proxy: ref<inkAnimProxy>;

  public final func SetHovered(hovered: Bool) -> Void {
    if this.m_active {
      inkWidgetRef.SetVisible(this.m_selectionPreviewRef, false);
      inkWidgetRef.SetVisible(this.m_removalPreviewRef, hovered);
    } else {
      inkWidgetRef.SetVisible(this.m_selectionPreviewRef, hovered);
      inkWidgetRef.SetVisible(this.m_removalPreviewRef, false);
    };
  }

  public final func SetActive(active: Bool, opt force: Bool) -> Void {
    if !force && Equals(active, this.m_active) {
      return;
    };
    this.m_active = active;
    this.m_proxy = this.PlayLibraryAnimation(this.m_active ? this.m_selectionAnimName : this.m_removalAnimName);
    this.m_proxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnAnimFinished");
    this.m_isAnimated = true;
    this.SetHovered(false);
  }

  protected cb func OnAnimFinished(proxy: ref<inkAnimProxy>) -> Bool {
    this.m_isAnimated = false;
  }

  public final const func IsAnimated() -> Bool {
    return this.m_isAnimated;
  }

  public final const func GetSelectionAnim() -> CName {
    return this.m_selectionAnimName;
  }

  public final const func GetRemovalAnim() -> CName {
    return this.m_removalAnimName;
  }
}

public class YaibaButton extends inkButtonController {

  private edit let m_normalBackground: inkImageRef;

  private edit let m_pressBackground: inkImageRef;

  private edit let m_hoverBackground: inkImageRef;

  private edit let m_disabledBackground: inkImageRef;

  private edit let m_enabledText: inkTextRef;

  private edit let m_disabledText: inkTextRef;

  protected cb func OnInitialize() -> Bool {
    inkWidgetRef.SetVisible(this.m_normalBackground, true);
    inkWidgetRef.SetVisible(this.m_hoverBackground, false);
    inkWidgetRef.SetVisible(this.m_disabledBackground, false);
    inkWidgetRef.SetVisible(this.m_enabledText, true);
    inkWidgetRef.SetVisible(this.m_disabledText, false);
  }

  protected cb func OnButtonStateChanged(controller: wref<inkButtonController>, oldState: inkEButtonState, newState: inkEButtonState) -> Bool {
    let isEnabled: Bool;
    inkWidgetRef.SetVisible(this.m_normalBackground, false);
    inkWidgetRef.SetVisible(this.m_pressBackground, false);
    inkWidgetRef.SetVisible(this.m_hoverBackground, false);
    inkWidgetRef.SetVisible(this.m_disabledBackground, false);
    switch newState {
      case inkEButtonState.Normal:
        inkWidgetRef.SetVisible(this.m_normalBackground, true);
        break;
      case inkEButtonState.Press:
        this.SetImageOrDefaultVisible(this.m_pressBackground, true, this.m_normalBackground);
        break;
      case inkEButtonState.Hover:
        this.SetImageOrDefaultVisible(this.m_hoverBackground, true, this.m_normalBackground);
        break;
      case inkEButtonState.Disabled:
        this.SetImageOrDefaultVisible(this.m_disabledBackground, true, this.m_normalBackground);
    };
    if inkWidgetRef.IsValid(this.m_enabledText) && inkWidgetRef.IsValid(this.m_disabledText) {
      isEnabled = NotEquals(newState, inkEButtonState.Disabled);
      inkWidgetRef.SetVisible(this.m_enabledText, isEnabled);
      inkWidgetRef.SetVisible(this.m_disabledText, !isEnabled);
    };
  }

  private final func SetImageOrDefaultVisible(image: inkImageRef, visible: Bool, defaultImage: inkImageRef) -> Void {
    if inkWidgetRef.IsValid(image) {
      inkWidgetRef.SetVisible(image, true);
    } else {
      inkWidgetRef.SetVisible(defaultImage, true);
    };
  }
}

public class ComputerYaibaShowroomController extends inkGameController {

  @runtimeProperty("category", "Settings")
  private edit let m_orderedFact: CName;

  @runtimeProperty("category", "Settings")
  private edit let m_toBuyPageAnim: CName;

  @runtimeProperty("category", "Webpage")
  protected edit let m_modelText: inkTextRef;

  @runtimeProperty("category", "Webpage")
  protected edit let m_homePage: inkWidgetRef;

  @runtimeProperty("category", "Webpage")
  protected edit let m_buyButton: inkWidgetRef;

  @runtimeProperty("category", "Webpage")
  protected edit let m_buyPage: inkWidgetRef;

  @runtimeProperty("category", "Webpage")
  protected edit let m_playerBalanceText: inkTextRef;

  @runtimeProperty("category", "Webpage")
  protected edit let m_detailsCanvas: inkWidgetRef;

  @runtimeProperty("category", "Webpage")
  protected edit let m_speedometer: inkImageRef;

  @runtimeProperty("category", "Offer")
  protected edit let m_orderButton: inkWidgetRef;

  @runtimeProperty("category", "Offer")
  protected edit let m_backButton: inkWidgetRef;

  @runtimeProperty("category", "Check Box")
  private edit let m_wheelCoverCheckBox: inkWidgetRef;

  @runtimeProperty("category", "Check Box")
  private edit let m_wheelRimsCheckBox: inkWidgetRef;

  @runtimeProperty("category", "Check Box")
  private edit let m_brandingCheckBox: inkWidgetRef;

  @runtimeProperty("category", "Check Box")
  private edit let m_backRestCheckBox: inkWidgetRef;

  @runtimeProperty("category", "Preview")
  private edit let m_wheelCoverPreview: inkWidgetRef;

  @runtimeProperty("category", "Preview")
  private edit let m_wheelRimsPreview: inkWidgetRef;

  @runtimeProperty("category", "Preview")
  private edit let m_brandingPreview: inkWidgetRef;

  @runtimeProperty("category", "Preview")
  private edit let m_backRestPreview: inkWidgetRef;

  private let m_inventoryListener: ref<InventoryScriptListener>;

  private let m_orderButtonController: wref<YaibaButton>;

  private let m_backButtonController: wref<YaibaButton>;

  private let m_wheelCoverCheckController: wref<CheckYaibaOption>;

  private let m_wheelRimsCheckController: wref<CheckYaibaOption>;

  private let m_brandingCheckController: wref<CheckYaibaOption>;

  private let m_backRestCheckController: wref<CheckYaibaOption>;

  @default(ComputerYaibaShowroomController, mq060_muramasa_wheel_cover)
  private let m_wheelCoverFact: CName;

  @default(ComputerYaibaShowroomController, mq060_muramasa_wheel_rims)
  private let m_WheelRimsFact: CName;

  @default(ComputerYaibaShowroomController, mq060_muramasa_branding)
  private let m_BrandingFact: CName;

  @default(ComputerYaibaShowroomController, mq060_muramasa_back_rest)
  private let m_BackRestFact: CName;

  private let m_isAnimated: Bool;

  private let m_settings: ref<UserSettings>;

  protected cb func OnInitialize() -> Bool {
    let isVehicleAvailable: Bool;
    let speedunitsVar: ref<ConfigVarListString>;
    let isAvailable: Bool = this.CheckAvailability();
    this.RefreshModelText();
    inkWidgetRef.RegisterToCallback(this.m_buyButton, n"OnRelease", this, n"OnReleaseBuyButton");
    isVehicleAvailable = isAvailable;
    this.m_orderButtonController = inkWidgetRef.GetController(this.m_orderButton) as YaibaButton;
    this.m_orderButtonController.RegisterToCallback(n"OnRelease", this, n"OnOrderRelease");
    this.m_orderButtonController.SetEnabled(isAvailable);
    this.m_backButtonController = inkWidgetRef.GetController(this.m_backButton) as YaibaButton;
    this.m_backButtonController.RegisterToCallback(n"OnRelease", this, n"OnBackRelease");
    this.m_wheelCoverCheckController = this.InitCheckBox(this.m_wheelCoverCheckBox, isVehicleAvailable, inkWidgetRef.Get(this.m_wheelCoverPreview), this.m_wheelCoverFact);
    this.m_wheelRimsCheckController = this.InitCheckBox(this.m_wheelRimsCheckBox, isVehicleAvailable, inkWidgetRef.Get(this.m_wheelRimsPreview), this.m_WheelRimsFact);
    this.m_brandingCheckController = this.InitCheckBox(this.m_brandingCheckBox, isVehicleAvailable, inkWidgetRef.Get(this.m_brandingPreview), this.m_BrandingFact);
    this.m_backRestCheckController = this.InitCheckBox(this.m_backRestCheckBox, isVehicleAvailable, inkWidgetRef.Get(this.m_backRestPreview), this.m_BackRestFact);
    this.m_settings = this.GetSystemRequestsHandler().GetUserSettings();
    speedunitsVar = this.m_settings.GetVar(n"/interface", n"SpeedometerUnits") as ConfigVarListString;
    switch speedunitsVar.GetIndex() {
      case 0:
        inkImageRef.SetTexturePart(this.m_speedometer, n"muramasa_maxspeed_kph");
        break;
      case 1:
        inkImageRef.SetTexturePart(this.m_speedometer, n"muramasa_maxspeed_mph");
    };
  }

  protected cb func OnReleaseBuyButton(e: ref<inkPointerEvent>) -> Bool {
    if this.m_isAnimated {
      return false;
    };
    if e.IsAction(n"click") {
      this.SwitchToBuyPage();
      e.Handle();
    };
  }

  protected cb func OnBackRelease(e: ref<inkPointerEvent>) -> Bool {
    if this.m_isAnimated {
      return false;
    };
    if e.IsAction(n"click") {
      this.SwitchToHomePage();
      e.Handle();
    };
  }

  protected cb func OnAnimFinished(proxy: ref<inkAnimProxy>) -> Bool {
    this.m_isAnimated = false;
  }

  protected cb func OnCheckChanged(checkBox: wref<inkWidget>) -> Bool {
    this.RefreshModelText();
  }

  protected cb func OnOrderRelease(e: ref<inkPointerEvent>) -> Bool {
    if this.m_isAnimated {
      return false;
    };
    if e.IsAction(n"click") {
      if this.CheckAvailability() {
        this.SetFact(this.m_wheelCoverFact, this.m_wheelCoverCheckController.IsChecked() ? 1 : 0);
        this.SetFact(this.m_WheelRimsFact, this.m_wheelRimsCheckController.IsChecked() ? 1 : 0);
        this.SetFact(this.m_BrandingFact, this.m_brandingCheckController.IsChecked() ? 1 : 0);
        this.SetFact(this.m_BackRestFact, this.m_backRestCheckController.IsChecked() ? 1 : 0);
        this.SetFact(this.m_orderedFact, 1);
        this.OnOrdered();
      };
    };
  }

  private final func InitCheckBox(checkBox: inkWidgetRef, isEnabled: Bool, preview: wref<inkWidget>, fact: CName) -> wref<CheckYaibaOption> {
    let controller: wref<CheckYaibaOption> = inkWidgetRef.GetController(checkBox) as CheckYaibaOption;
    controller.Initialize((this.GetOwnerEntity() as GameObject).GetGame(), preview, fact);
    controller.SetEnabled(isEnabled);
    controller.RegisterToCallback(n"OnValueChanged", this, n"OnCheckChanged");
    return controller;
  }

  private final func RefreshModelText() -> Void {
    let text: String = GetLocalizedTextByKey(n"Story-base-journal-onscreens-emails-quests-minor_quest-mq060-terminal-Mq060_terminal_Muramasa_subtitle_codename");
    text += " - ";
    text += this.m_wheelCoverCheckController.IsChecked() ? "1" : "0";
    text += this.m_wheelRimsCheckController.IsChecked() ? "1" : "0";
    text += this.m_brandingCheckController.IsChecked() ? "1" : "0";
    text += this.m_backRestCheckController.IsChecked() ? "1" : "0";
    inkTextRef.SetText(this.m_modelText, text);
  }

  private final func SwitchToHomePage() -> Void {
    let options: inkAnimOptions;
    options.playReversed = true;
    this.PlayLibraryAnimation(this.m_toBuyPageAnim, options).RegisterToCallback(inkanimEventType.OnFinish, this, n"OnAnimFinished");
    this.m_isAnimated = true;
  }

  private final func SwitchToBuyPage() -> Void {
    this.PlayLibraryAnimation(this.m_toBuyPageAnim).RegisterToCallback(inkanimEventType.OnFinish, this, n"OnAnimFinished");
    this.m_isAnimated = true;
  }

  public final func CheckAvailability() -> Bool {
    return GetFact(this.GetGame(), this.m_orderedFact) == 0;
  }

  public final func SetFact(factName: CName, factCount: Int32) -> Bool {
    return SetFactValue(this.GetGame(), factName, factCount);
  }

  protected final func GetGame() -> GameInstance {
    let gameInstance: GameInstance;
    let gameObject: ref<GameObject> = this.GetOwnerEntity() as GameObject;
    if IsDefined(gameObject) {
      gameInstance = gameObject.GetGame();
    };
    return gameInstance;
  }

  private final func GetPlayerMoney() -> Int32 {
    let gi: GameInstance = this.GetGame();
    let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(gi).GetLocalPlayerControlledGameObject() as PlayerPuppet;
    let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(gi);
    return transactionSystem.GetItemQuantity(player, MarketSystem.Money());
  }

  private final func RemovePlayerMoney(amount: Int32) -> Bool {
    let gi: GameInstance = this.GetGame();
    let player: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(gi).GetLocalPlayerControlledGameObject() as PlayerPuppet;
    let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(gi);
    return transactionSystem.RemoveItem(player, MarketSystem.Money(), amount);
  }

  private final func OnOrdered() -> Void {
    this.m_wheelCoverCheckController.SetEnabled(false);
    this.m_wheelRimsCheckController.SetEnabled(false);
    this.m_brandingCheckController.SetEnabled(false);
    this.m_backRestCheckController.SetEnabled(false);
    this.m_orderButtonController.SetEnabled(false);
    this.ShowNotification();
  }

  private final func ShowNotification() -> Void {
    this.PlayLibraryAnimation(n"notification_anim");
  }
}
