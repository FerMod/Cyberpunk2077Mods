
public class NewPerksCyberwareTooltipController extends AGenericTooltipController {

  private edit let m_title: inkTextRef;

  private edit let m_subTitle: inkTextRef;

  private edit let m_description: inkTextRef;

  private edit let m_subDescription: inkTextRef;

  private edit let m_videoWidget: inkVideoRef;

  private edit let m_cornerContainer: inkWidgetRef;

  private edit let m_relicCost: inkWidgetRef;

  private edit const let m_bars: [inkWidgetRef];

  private edit let m_inputHints: inkWidgetRef;

  private edit let m_buyHint: inkWidgetRef;

  private edit let m_sellHint: inkWidgetRef;

  private let m_currentEntry: NewPerksCyberwareDetailsMenu;

  private let m_swipeOutAnim: ref<inkAnimProxy>;

  private let m_swipeInAnim: ref<inkAnimProxy>;

  private let m_data: ref<NewPerkTooltipData>;

  protected let m_settings: ref<UserSettings>;

  protected let m_settingsListener: ref<EspionageTooltipSettingsListener>;

  @default(NewPerksCyberwareTooltipController, /accessibility/interface)
  protected let m_groupPath: CName;

  protected let m_bigFontEnabled: Bool;

  private edit let m_wrapper: inkWidgetRef;

  @default(NewPerksCyberwareTooltipController, espionage_central_swipe_left_out)
  private const let c_swipeLeftOut: CName;

  @default(NewPerksCyberwareTooltipController, espionage_central_swipe_left_in)
  private const let c_swipeLeftIn: CName;

  @default(NewPerksCyberwareTooltipController, espionage_central_swipe_right_out)
  private const let c_swipeRightOut: CName;

  @default(NewPerksCyberwareTooltipController, espionage_central_swipe_right_in)
  private const let c_swipeRightIn: CName;

  protected cb func OnInitialize() -> Bool {
    super.OnInitialize();
    this.RegisterToGlobalInputCallback(n"OnPostOnPress", this, n"OnHandlePressInput");
    this.m_currentEntry = NewPerksCyberwareDetailsMenu.MantisBlades;
  }

  protected cb func OnUninitialize() -> Bool {
    this.UnregisterFromGlobalInputCallback(n"OnPostOnPress", this, n"OnHandlePressInput");
  }

  public func Show() -> Void {
    super.Show();
    this.StopSwipeAnims();
  }

  public func Refresh() -> Void {
    this.SetData(this.m_data);
  }

  public func SetData(tooltipData: ref<ATooltipData>) -> Void {
    this.m_data = tooltipData as NewPerkTooltipData;
    this.m_data.RefreshRuntimeData();
    this.UpdateData();
    this.UpdateState(this.m_data.perkData);
    this.UpdateInputHints(this.m_data, this.m_data.perkData);
    this.m_settings = new UserSettings();
    this.m_settingsListener = new EspionageTooltipSettingsListener();
    this.m_settingsListener.RegisterController(this);
    this.m_settingsListener.Register(this.m_groupPath);
    this.UpdateTooltipSize();
  }

  protected cb func OnHandlePressInput(evt: ref<inkPointerEvent>) -> Bool {
    if !this.m_Root.IsVisible() {
      return false;
    };
    if evt.IsAction(n"ep1_cyberware_perk_details_forward") {
      this.StopSwipeAnims();
      this.m_swipeOutAnim = this.PlayLibraryAnimation(this.c_swipeLeftOut);
      this.m_swipeOutAnim.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnSwipeLeftOutAnimFinished");
    } else {
      if evt.IsAction(n"ep1_cyberware_perk_details_back") {
        this.StopSwipeAnims();
        this.m_swipeOutAnim = this.PlayLibraryAnimation(this.c_swipeRightOut);
        this.m_swipeOutAnim.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnSwipeRightOutAnimFinished");
      };
    };
  }

  protected cb func OnSwipeLeftOutAnimFinished(proxy: ref<inkAnimProxy>) -> Bool {
    let count: Int32 = 4;
    this.m_currentEntry = IntEnum<NewPerksCyberwareDetailsMenu>((EnumInt(this.m_currentEntry) + 1 + count) % count);
    this.UpdateData();
    this.m_swipeInAnim = this.PlayLibraryAnimation(this.c_swipeRightIn);
  }

  protected cb func OnSwipeRightOutAnimFinished(proxy: ref<inkAnimProxy>) -> Bool {
    let count: Int32 = 4;
    this.m_currentEntry = IntEnum<NewPerksCyberwareDetailsMenu>((EnumInt(this.m_currentEntry) - 1 + count) % count);
    this.UpdateData();
    this.m_swipeInAnim = this.PlayLibraryAnimation(this.c_swipeLeftIn);
  }

  private final func StopSwipeAnims() -> Void {
    if IsDefined(this.m_swipeOutAnim) && this.m_swipeOutAnim.IsPlaying() {
      this.m_swipeOutAnim.UnregisterFromAllCallbacks(inkanimEventType.OnFinish);
      this.m_swipeOutAnim.GotoStartAndStop();
    };
    if IsDefined(this.m_swipeInAnim) && this.m_swipeInAnim.IsPlaying() {
      this.m_swipeInAnim.UnregisterFromAllCallbacks(inkanimEventType.OnFinish);
      this.m_swipeInAnim.GotoEndAndStop();
    };
  }

  private final func GetRecordString() -> String {
    switch this.m_currentEntry {
      case NewPerksCyberwareDetailsMenu.MantisBlades:
        return "Espionage_Central_Milestone_MantisBlades";
      case NewPerksCyberwareDetailsMenu.GorillaArms:
        return "Espionage_Central_Milestone_GorillaArms";
      case NewPerksCyberwareDetailsMenu.ProjectileLauncher:
        return "Espionage_Central_Milestone_ProjectileLauncher";
      case NewPerksCyberwareDetailsMenu.Monowire:
        return "Espionage_Central_Milestone_Monowire";
    };
    return "";
  }

  private final func GetTitle() -> String {
    let record: ref<NewPerk_Record>;
    let recordString: String = this.GetRecordString();
    if Equals(recordString, "") {
      return "";
    };
    record = TweakDBInterface.GetNewPerkRecord(TDBID.Create("NewPerks." + this.GetRecordString()));
    return record.Loc_name_key();
  }

  private final func GetDescription() -> String {
    let record: ref<NewPerk_Record>;
    let recordString: String = this.GetRecordString();
    if Equals(recordString, "") {
      return "";
    };
    record = TweakDBInterface.GetNewPerkRecord(TDBID.Create("NewPerks." + this.GetRecordString()));
    return record.Loc_desc_key();
  }

  private final func GetVideo() -> ResRef {
    let record: ref<NewPerk_Record>;
    let video: ResRef;
    let recordString: String = this.GetRecordString();
    if Equals(recordString, "") {
      return video;
    };
    record = TweakDBInterface.GetNewPerkRecord(TDBID.Create("NewPerks." + this.GetRecordString()));
    video = record.BinkPath();
    return video;
  }

  private final func UpdateState(perkData: ref<NewPerkDisplayData>) -> Void {
    this.m_Root.SetState(perkData.m_level == 0 ? n"Locked" : n"Purchased");
    inkWidgetRef.SetVisible(this.m_cornerContainer, perkData.m_level == 0 ? false : true);
    inkWidgetRef.SetVisible(this.m_relicCost, perkData.m_level == 0 ? true : false);
  }

  private final func UpdateInputHints(data: ref<BasePerksMenuTooltipData>, perkData: ref<BasePerkDisplayData>) -> Void {
    let upgradeable: Bool = data.manager.IsPerkUpgradeable(perkData);
    let refundable: Bool = data.manager.IsNewPerkRefundable(perkData as NewPerkDisplayData);
    inkWidgetRef.SetVisible(this.m_inputHints, upgradeable || refundable);
    inkWidgetRef.SetVisible(this.m_buyHint, upgradeable);
    inkWidgetRef.SetVisible(this.m_sellHint, refundable);
  }

  private final func UpdateData() -> Void {
    let dataPackage: ref<UILocalizationDataPackage>;
    let i: Int32;
    let record: wref<NewPerkLevelUIData_Record>;
    let videoRef: ResRef;
    inkTextRef.SetText(this.m_title, this.m_data.perkData.m_localizedName);
    inkTextRef.SetText(this.m_subTitle, this.GetTitle());
    inkTextRef.SetText(this.m_description, this.m_data.perkData.m_localizedDescription);
    record = TweakDBInterface.GetNewPerkRecord(TDBID.Create("NewPerks." + this.GetRecordString())).UiData();
    if record != null {
      inkTextRef.SetText(this.m_subDescription, GetLocalizedText(this.GetDescription()) + "{__empty__}");
      dataPackage = UILocalizationDataPackage.FromNewPerkUIDataPackage(record);
      dataPackage.EnableNotReplacedWorkaround();
      if dataPackage.GetParamsCount() > 0 {
        inkTextRef.SetTextParameters(this.m_subDescription, dataPackage.GetTextParams());
      };
    } else {
      inkTextRef.SetText(this.m_subDescription, this.GetDescription());
    };
    i = 0;
    while i < 4 {
      inkWidgetRef.SetState(this.m_bars[i], EnumInt(this.m_currentEntry) == i ? this.m_data.perkData.m_level == 0 ? n"Selected" : n"SelectedBought" : n"Default");
      i += 1;
    };
    videoRef = this.GetVideo();
    if ResRef.IsValid(videoRef) {
      inkVideoRef.Stop(this.m_videoWidget);
      inkVideoRef.SetVideoPath(this.m_videoWidget, videoRef);
      inkVideoRef.SetLoop(this.m_videoWidget, true);
      inkVideoRef.Play(this.m_videoWidget);
      inkWidgetRef.SetVisible(this.m_videoWidget, true);
    } else {
      inkWidgetRef.SetVisible(this.m_videoWidget, false);
    };
  }

  public final func OnVarModified(groupPath: CName, varName: CName, varType: ConfigVarType, reason: ConfigChangeReason) -> Void {
    switch varName {
      case n"BigFont":
        this.UpdateTooltipSize();
        break;
      default:
    };
  }

  private final func UpdateTooltipSize() -> Void {
    let configVar: ref<ConfigVarBool> = this.m_settings.GetVar(this.m_groupPath, n"BigFont") as ConfigVarBool;
    this.SetTooltipSize(configVar.GetValue());
  }

  protected func SetTooltipSize(value: Bool) -> Void {
    if Equals(value, true) {
      inkWidgetRef.SetSize(this.m_wrapper, 1205.00, 0.00);
      inkTextRef.SetWrappingAtPosition(this.m_title, 980.00);
      inkTextRef.SetWrappingAtPosition(this.m_subTitle, 1020.00);
      inkTextRef.SetWrappingAtPosition(this.m_description, 1100.00);
      inkTextRef.SetWrappingAtPosition(this.m_subDescription, 1100.00);
      this.m_bigFontEnabled = true;
    } else {
      inkWidgetRef.SetSize(this.m_wrapper, 905.00, 0.00);
      inkTextRef.SetWrappingAtPosition(this.m_title, 680.00);
      inkTextRef.SetWrappingAtPosition(this.m_subTitle, 720.00);
      inkTextRef.SetWrappingAtPosition(this.m_description, 800.00);
      inkTextRef.SetWrappingAtPosition(this.m_subDescription, 800.00);
      this.m_bigFontEnabled = false;
    };
  }
}

public class EspionageTooltipSettingsListener extends ConfigVarListener {

  private let m_ctrl: wref<NewPerksCyberwareTooltipController>;

  public final func RegisterController(ctrl: ref<NewPerksCyberwareTooltipController>) -> Void {
    this.m_ctrl = ctrl;
  }

  public func OnVarModified(groupPath: CName, varName: CName, varType: ConfigVarType, reason: ConfigChangeReason) -> Void {
    this.m_ctrl.OnVarModified(groupPath, varName, varType, reason);
  }
}
