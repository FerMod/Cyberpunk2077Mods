
public class DlcDescriptionController extends inkLogicController {

  private edit let m_titleRef: inkTextRef;

  private edit let m_descriptionRef: inkTextRef;

  private edit let m_guideRef: inkTextRef;

  private edit let m_imageRef: inkImageRef;

  private edit let m_settingSelectorRef: inkWidgetRef;

  private let m_settingSelector: wref<SettingsSelectorController>;

  private let m_settingsListener: ref<DLCSettingsVarListener>;

  private let m_settingVar: ref<ConfigVar>;

  private let m_isPreGame: Bool;

  public final func SetData(userData: ref<DlcDescriptionData>) -> Void {
    inkTextRef.SetLocalizedText(this.m_titleRef, userData.m_title);
    inkTextRef.SetLocalizedText(this.m_descriptionRef, userData.m_description);
    inkImageRef.SetTexturePart(this.m_imageRef, userData.m_imagePart);
    this.m_settingVar = userData.m_settingVar;
    this.m_isPreGame = userData.m_isPreGame;
    if NotEquals(userData.m_guide, n"None") {
      inkTextRef.SetLocalizedText(this.m_guideRef, userData.m_guide);
    } else {
      inkWidgetRef.SetVisible(this.m_guideRef, false);
    };
    if NotEquals(this.m_settingVar.GetName(), n"None") {
      this.SetupSetting();
    };
  }

  public final func OnVarModified(groupPath: CName, varName: CName, varType: ConfigVarType, reason: ConfigChangeReason) -> Void {
    this.m_settingSelector.Refresh();
  }

  private final func SetupSetting() -> Void {
    if inkWidgetRef.IsValid(this.m_settingSelectorRef) {
      this.m_settingSelector = this.SpawnFromLocal(inkWidgetRef.Get(this.m_settingSelectorRef), n"settingsSelectorIntList").GetController() as SettingsSelectorControllerListInt;
      this.m_settingSelector.Setup(this.m_settingVar, this.m_isPreGame);
      if this.m_isPreGame {
        this.m_settingVar.SetEnabled(true);
        this.m_settingsListener = new DLCSettingsVarListener();
        this.m_settingsListener.RegisterController(this);
        this.m_settingsListener.Register(this.m_settingVar.GetGroupPath());
      } else {
        this.m_settingVar.SetEnabled(false);
        this.m_settingSelector.GetRootWidget().SetState(n"Disabled");
      };
      this.m_settingSelector.Refresh();
    };
  }
}

public class DLCSettingsVarListener extends ConfigVarListener {

  private let m_ctrl: wref<DlcDescriptionController>;

  public final func RegisterController(ctrl: ref<DlcDescriptionController>) -> Void {
    this.m_ctrl = ctrl;
  }

  public func OnVarModified(groupPath: CName, varName: CName, varType: ConfigVarType, reason: ConfigChangeReason) -> Void {
    this.m_ctrl.OnVarModified(groupPath, varName, varType, reason);
  }
}

public class DlcMenuGameController extends gameuiMenuGameController {

  private edit let m_buttonHintsRef: inkWidgetRef;

  private edit let m_containersRef: inkCompoundRef;

  private let m_settings: ref<UserSettings>;

  private let dlcSettingsGroup: ref<ConfigGroup>;

  protected cb func OnInitialize() -> Bool {
    this.m_settings = this.GetSystemRequestsHandler().GetUserSettings();
    if this.m_settings.HasGroup(n"/gameplay/dlcContent") {
      this.dlcSettingsGroup = this.m_settings.GetGroup(n"/gameplay/dlcContent");
    };
    super.OnInitialize();
    this.SpawnInputHints();
    this.SpawnDescriptions(n"UI-DLC-ContentPack1600-Edgerunners_Title", n"UI-DLC-ContentPack1600-Edgerunners_Description", n"UI-DLC-ContentPack1600-Edgerunners_Guide", n"dlc4_5_edgerunners");
    this.SpawnDescriptions(n"UI-DLC-ContentPack1600-Gigs_Title", n"UI-DLC-ContentPack1600-Gigs_Description", n"UI-DLC-ContentPack1600-Gigs_Guide", n"dlc4_5_sts");
    this.SpawnDescriptions(n"UI-DLC-ContentPack1600-Wardrobe_Title", n"UI-DLC-ContentPack1600-Wardrobe_Description", n"UI-DLC-ContentPack1600-Wardrobe_Guide", n"dlc4_5_wardrobe");
    this.SpawnDescriptions(n"UI-DLC-ContentPack1600-Guns_Title", n"UI-DLC-ContentPack1600-Guns_Description", n"UI-DLC-ContentPack1600-Guns_Guide", n"dlc4_5_guns");
    this.SpawnDescriptions(n"UI-DLC-ContentPack1600-Melee_Title", n"UI-DLC-ContentPack1600-Melee_Description", n"UI-DLC-ContentPack1600-Melee_Guide", n"dlc4_5_melee_weapons");
    this.SpawnDescriptions(n"UI-DLC-ContentPack1600-RoachRace_Title", n"UI-DLC-ContentPack1600-RoachRace_Description", n"UI-DLC-ContentPack1600-RoachRace_Guide", n"dlc4_5_roachrace");
    this.SpawnDescriptions(n"UI-DLC-ContentPack1600-Nibbles_Title", n"UI-DLC-ContentPack1600-Nibbles_Description", n"UI-DLC-ContentPack1600-Nibbles_Guide", n"dlc4_5_nibbles_photomode");
    this.SpawnDescriptions(n"UI-DLC-ContentPack1600-Rims_Title", n"UI-DLC-ContentPack1600-Rims_Description", n"UI-DLC-ContentPack1600-Rims_Guide", n"dlc4_5_neon_rims");
    this.SpawnDescriptions(n"UI-DLC-Apartments_Title", n"UI-DLC-Apartments_Description", n"UI-DLC-Apartments_Guide", n"dlc3_apartments");
    this.SpawnDescriptions(n"UI-DLC-Hairdresser_Title", n"UI-DLC-Hairdresser_Description", n"UI-DLC-Hairdresser_Guide", n"dlc3_hairdresser");
    this.SpawnDescriptions(n"UI-DLC-WeaponScopes_Title", n"UI-DLC-WeaponScopes_Description", n"UI-DLC-WeaponScopes_Guide", n"dlc2_scopes");
    this.SpawnDescriptions(n"UI-DLC-MuzzleBrakes_Title", n"UI-DLC-MuzzleBrakes_Description", n"UI-DLC-MuzzleBrakes_Guide", n"dlc2_muzzle");
    this.SpawnDescriptions(n"UI-DLC-UMBRA_Title", n"UI-DLC-UMBRA_Description", n"UI-DLC-UMBRA_Guide", n"dlc2_darra");
    this.SpawnDescriptions(n"UI-DLC-Guillotine_Title", n"UI-DLC-Guillotine_Description", n"UI-DLC-Guillotine_Guide", n"dlc2_guillotine");
    this.SpawnDescriptions(n"UI-DLC-JohnnyPhotoMode_Title", n"UI-DLC-JohnnyPhotoMode_Description", n"UI-DLC-JohnnyPhotoMode_Guide", n"dlc2_johnny_photomode");
    this.SpawnDescriptions(n"UI-DLC-JohnnyAltApp_Title", n"UI-DLC-JohnnyAltApp_Description", n"UI-DLC-JohnnyAltApp_Guide", n"dlc_johnny", n"JohnnySilverhandAltApp");
    this.SpawnDescriptions(n"UI-DLC-Jackets_Title", n"UI-DLC-Jackets_Description", n"UI-DLC-Jackets_Guide", n"dlc_jackets");
    this.SpawnDescriptions(n"UI-DLC-Archer_Title", n"UI-DLC-Archer_Description", n"UI-DLC-Archer_Guide", n"dlc_archer");
  }

  private final func SpawnInputHints() -> Void {
    let buttonHintsController: wref<ButtonHints>;
    let path: ResRef;
    let widget: wref<inkWidget>;
    if inkWidgetRef.IsValid(this.m_buttonHintsRef) {
      path = r"base\\gameplay\\gui\\common\\buttonhints.inkwidget";
      widget = this.SpawnFromExternal(inkWidgetRef.Get(this.m_buttonHintsRef), path, n"Root");
      buttonHintsController = widget.GetController() as ButtonHints;
      buttonHintsController.AddButtonHint(n"back", "Common-Access-Close");
    };
  }

  private final func SpawnDescriptions(title: CName, description: CName, guide: CName, imagePart: CName, opt settingVarName: CName) -> Void {
    let data: ref<DlcDescriptionData> = new DlcDescriptionData();
    data.m_title = title;
    data.m_description = description;
    data.m_guide = guide;
    data.m_imagePart = imagePart;
    if NotEquals(settingVarName, n"None") && !this.dlcSettingsGroup.IsEmpty(true) {
      if this.dlcSettingsGroup.HasVar(settingVarName) {
        data.m_settingVar = this.dlcSettingsGroup.GetVar(settingVarName);
        data.m_isPreGame = this.GetSystemRequestsHandler().IsPreGame();
      };
    };
    this.AsyncSpawnFromLocal(inkWidgetRef.Get(this.m_containersRef), n"dlcDescription", this, n"OnDescriptionSpawned", data);
  }

  protected cb func OnDescriptionSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
    let itemCtrl: wref<DlcDescriptionController>;
    if IsDefined(widget) {
      itemCtrl = widget.GetController() as DlcDescriptionController;
      itemCtrl.SetData(userData as DlcDescriptionData);
    };
  }
}
