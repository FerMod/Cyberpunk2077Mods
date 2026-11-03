
public class NewPerkSkillsLogicController extends inkLogicController {

  private edit let m_virtualGridContainer: inkVirtualCompoundRef;

  private edit let m_scrollBarContainer: inkWidgetRef;

  private let m_virtualGrid: wref<inkVirtualGridController>;

  private let m_dataSource: ref<ScriptableDataSource>;

  private let m_itemsClassifier: ref<inkVirtualItemTemplateClassifier>;

  private let m_scrollBar: wref<inkScrollController>;

  private let m_dataManager: wref<PlayerDevelopmentDataManager>;

  private let m_isActiveScreen: Bool;

  private let m_initialized: Bool;

  private let virtualItems: [ref<IScriptable>];

  protected cb func OnUninitialize() -> Bool {
    let controller: wref<NewPerksSkillBarLogicController>;
    let i: Int32;
    this.UnregisterData();
    i = 0;
    while i < inkCompoundRef.GetNumChildren(this.m_virtualGridContainer) {
      controller = inkCompoundRef.GetWidgetByIndex(this.m_virtualGridContainer, i).GetController() as NewPerksSkillBarLogicController;
      controller.UnregisterAllCallbacks();
      i += 1;
    };
  }

  public final func UnregisterData() -> Void {
    this.m_virtualGrid.SetClassifier(null);
    this.m_virtualGrid.SetSource(null);
    this.m_itemsClassifier = null;
    this.m_dataSource = null;
  }

  public final func Initialize(dataManager: wref<PlayerDevelopmentDataManager>) -> Void {
    let i: Int32;
    let limit: Int32;
    let proficiencyDisplayData: ref<ProficiencyDisplayData>;
    if !this.m_initialized {
      this.m_dataManager = dataManager;
      this.m_virtualGrid = inkWidgetRef.GetControllerByType(this.m_virtualGridContainer, n"inkVirtualGridController") as inkVirtualGridController;
      this.m_dataSource = new ScriptableDataSource();
      this.m_itemsClassifier = new inkVirtualItemTemplateClassifier();
      this.m_virtualGrid.SetClassifier(this.m_itemsClassifier);
      this.m_virtualGrid.SetSource(this.m_dataSource);
      i = 0;
      limit = 20;
      while i < limit {
        if PlayerDevelopmentData.IsProfficiencyObsolete(IntEnum<gamedataProficiencyType>(i)) {
        } else {
          proficiencyDisplayData = dataManager.GetProficiencyDisplayData(IntEnum<gamedataProficiencyType>(i));
          if IsDefined(proficiencyDisplayData) {
            ArrayPush(this.virtualItems, proficiencyDisplayData);
          };
        };
        i += 1;
      };
      this.m_dataSource.Reset(this.virtualItems);
    };
    this.m_initialized = true;
  }

  public final func SetActive(value: Bool) -> Void {
    this.m_isActiveScreen = value;
  }
}

public class NewPerksSkillBarLogicController extends inkVirtualCompoundItemController {

  private edit let m_statsProgressWidget: inkWidgetRef;

  private edit let m_levelsContainer: inkCompoundRef;

  private let m_data: ref<ProficiencyDisplayData>;

  private let m_requestedSkills: Int32;

  private let m_statsProgressController: wref<StatsProgressController>;

  private let m_levelsControllers: [wref<NewPerksSkillLevelLogicController>];

  protected cb func OnInitialize() -> Bool {
    this.m_statsProgressController = inkWidgetRef.GetController(this.m_statsProgressWidget) as StatsProgressController;
    inkWidgetRef.RegisterToCallback(this.m_statsProgressWidget, n"OnHoverOver", this, n"OnSkillOverOver");
    inkWidgetRef.RegisterToCallback(this.m_statsProgressWidget, n"OnHoverOut", this, n"OnSkillHoverOut");
  }

  protected cb func OnDataChanged(value: Variant) -> Bool {
    this.m_data = FromVariant<ref<IScriptable>>(value) as ProficiencyDisplayData;
    if IsDefined(this.m_data) {
      this.m_statsProgressController.SetProfiencyLevel(this.m_data);
      this.UpdateSkillsCount();
    };
  }

  public final func UnregisterAllCallbacks() -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_levelsControllers) {
      this.m_levelsControllers[i].UnregisterFromCallback(n"OnHoverOver", this, n"OnHoverOver");
      this.m_levelsControllers[i].UnregisterFromCallback(n"OnHoverOut", this, n"OnHoverOut");
      i += 1;
    };
    inkWidgetRef.UnregisterFromCallback(this.m_statsProgressWidget, n"OnHoverOver", this, n"OnSkillOverOver");
    inkWidgetRef.UnregisterFromCallback(this.m_statsProgressWidget, n"OnHoverOut", this, n"OnSkillHoverOut");
  }

  private final func UpdateSkillsCount() -> Void {
    let i: Int32 = 3;
    let counter: Int32 = 0;
    let limit: Int32 = this.m_requestedSkills;
    while i < limit {
      this.SetSkillLevelData(this.m_levelsControllers[counter], this.m_data.m_passiveBonusesData[i]);
      counter += 1;
      i += 5;
    };
    limit = ArraySize(this.m_data.m_passiveBonusesData);
    while this.m_requestedSkills < limit {
      this.AsyncSpawnFromLocal(inkWidgetRef.Get(this.m_levelsContainer), n"SkillLevel", this, n"OnSkillLevelSpawned");
      this.m_requestedSkills += 5;
    };
  }

  protected cb func OnSkillLevelSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
    let index: Int32;
    ArrayPush(this.m_levelsControllers, widget.GetController() as NewPerksSkillLevelLogicController);
    index = ArraySize(this.m_levelsControllers) - 1;
    this.SetSkillLevelData(this.m_levelsControllers[index], this.m_data.m_passiveBonusesData[3 + index * 5]);
    this.m_levelsControllers[index].RegisterToCallback(n"OnHoverOver", this, n"OnHoverOver");
    this.m_levelsControllers[index].RegisterToCallback(n"OnHoverOut", this, n"OnHoverOut");
  }

  private final func SetSkillLevelData(controller: wref<NewPerksSkillLevelLogicController>, levelData: wref<LevelRewardDisplayData>) -> Void {
    let active: Bool;
    if levelData.level <= this.m_data.m_level {
      levelData.isLock = false;
      active = true;
    } else {
      levelData.isLock = true;
      active = false;
    };
    controller.SetData(levelData, active);
  }

  private final func GetSkillDesciption(proficiency: gamedataProficiencyType) -> String {
    switch proficiency {
      case gamedataProficiencyType.CoolSkill:
        return "Gameplay-RPG-Skills-CoolSkillSources";
      case gamedataProficiencyType.IntelligenceSkill:
        return "Gameplay-RPG-Skills-IntelligenceSkillSources";
      case gamedataProficiencyType.ReflexesSkill:
        return "Gameplay-RPG-Skills-ReflexesSkillSources";
      case gamedataProficiencyType.StrengthSkill:
        return "Gameplay-RPG-Skills-BodySkillSources";
      case gamedataProficiencyType.TechnicalAbilitySkill:
        return "Gameplay-RPG-Skills-TechSkillSources";
    };
    return "";
  }

  protected cb func OnSkillOverOver(e: ref<inkPointerEvent>) -> Bool {
    let evt: ref<SkillHoverOver> = new SkillHoverOver();
    evt.widget = e.GetCurrentTarget();
    evt.title = this.m_data.m_localizedName;
    evt.description = this.GetSkillDesciption(this.m_data.m_proficiency);
    this.QueueEvent(evt);
  }

  protected cb func OnSkillHoverOut(e: ref<inkPointerEvent>) -> Bool {
    this.QueueEvent(new SkillHoverOut());
  }

  protected cb func OnHoverOver(e: ref<inkPointerEvent>) -> Bool {
    let evt: ref<SkillRewardHoverOver> = new SkillRewardHoverOver();
    evt.widget = e.GetCurrentTarget();
    let controller: wref<NewPerksSkillLevelLogicController> = evt.widget.GetController() as NewPerksSkillLevelLogicController;
    evt.data = controller.GetRewardData();
    controller.HoverOver();
    this.QueueEvent(evt);
  }

  protected cb func OnHoverOut(e: ref<inkPointerEvent>) -> Bool {
    let controller: wref<NewPerksSkillLevelLogicController> = e.GetCurrentTarget().GetController() as NewPerksSkillLevelLogicController;
    controller.HoverOut();
    this.QueueEvent(new SkillRewardHoverOut());
  }
}

public class NewPerksSkillLevelLogicController extends inkLogicController {

  private edit let m_levelText: inkTextRef;

  private let m_levelData: ref<LevelRewardDisplayData>;

  private let m_active: Bool;

  private let m_hovered: Bool;

  public final func HoverOver() -> Void {
    this.m_hovered = true;
    this.UpdateState();
  }

  public final func HoverOut() -> Void {
    this.m_hovered = false;
    this.UpdateState();
  }

  public final func SetData(levelData: ref<LevelRewardDisplayData>, active: Bool) -> Void {
    this.m_levelData = levelData;
    this.m_active = active;
    this.UpdateState();
    inkTextRef.SetText(this.m_levelText, IntToString(this.m_levelData.level));
  }

  private final func UpdateState() -> Void {
    if this.m_hovered {
      if this.m_active {
        this.GetRootWidget().SetState(n"DefaultHover");
      } else {
        this.GetRootWidget().SetState(n"UnavailableHover");
      };
    } else {
      if this.m_active {
        this.GetRootWidget().SetState(n"Default");
      } else {
        this.GetRootWidget().SetState(n"Unavailable");
      };
    };
  }

  public final func GetRewardData() -> ref<LevelRewardDisplayData> {
    return this.m_levelData;
  }
}
