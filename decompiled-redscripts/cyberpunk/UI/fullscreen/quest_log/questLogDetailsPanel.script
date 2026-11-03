
public class QuestDetailsPanelController extends inkLogicController {

  private edit let m_questTitle: inkTextRef;

  private edit let m_questDescription: inkTextRef;

  private edit let m_questLevel: inkTextRef;

  private edit let m_activeObjectives: inkCompoundRef;

  private edit let m_optionalObjectives: inkCompoundRef;

  private edit let m_completedObjectives: inkCompoundRef;

  private edit let m_codexLinksContainer: inkCompoundRef;

  private edit let m_missionLinksContainer: inkCompoundRef;

  private edit let m_fluffLinksContainer: inkCompoundRef;

  private edit let m_mapLinksContainer: inkCompoundRef;

  private edit let m_missionLinkLine: inkCompoundRef;

  private edit let m_fluffShardLinkLine: inkCompoundRef;

  private edit let m_codexLinkLine: inkCompoundRef;

  private edit let m_contentContainer: inkWidgetRef;

  private edit let m_scrollContainer: inkWidgetRef;

  private edit let m_noSelectedQuestContainer: inkWidgetRef;

  private edit let m_ep1Marker: inkWidgetRef;

  private let m_scrollContainerCtrl: wref<inkScrollController>;

  private let m_currentQuestData: wref<JournalQuest>;

  private let m_journalManager: wref<JournalManager>;

  private let m_shardEntry: wref<JournalOnscreen>;

  private let m_phoneSystem: wref<PhoneSystem>;

  private let m_mappinSystem: wref<MappinSystem>;

  private let m_uiSystem: wref<UISystem>;

  private let m_trackedObjective: wref<JournalQuestObjective>;

  private let m_canUsePhone: Bool;

  @default(QuestDetailsPanelController, 20)
  private let m_objectiveOffset: Float;

  @default(QuestDetailsPanelController, 124)
  private let m_objectiveActionOffset: Float;

  private let m_objectiveActionsCount: Int32;

  protected cb func OnInitialize() -> Bool {
    inkWidgetRef.SetVisible(this.m_noSelectedQuestContainer, true);
    inkWidgetRef.SetVisible(this.m_contentContainer, false);
    this.m_scrollContainerCtrl = inkWidgetRef.GetControllerByType(this.m_scrollContainer, n"inkScrollController") as inkScrollController;
  }

  public final func Setup(questData: wref<JournalQuest>, journalManager: wref<JournalManager>, phoneSystem: wref<PhoneSystem>, mappinSystem: wref<MappinSystem>, uiSystem: wref<UISystem>, game: GameInstance, opt skipAnimation: Bool) -> Void {
    let playerLevel: Float;
    let recommendedLevel: Int32;
    if this.m_currentQuestData == questData {
      return;
    };
    this.m_scrollContainerCtrl.SetScrollPosition(0.00);
    playerLevel = GameInstance.GetStatsSystem(game).GetStatValue(Cast<StatsObjectID>(GameInstance.GetPlayerSystem(game).GetLocalPlayerMainGameObject().GetEntityID()), gamedataStatType.Level);
    recommendedLevel = GameInstance.GetLevelAssignmentSystem(game).GetLevelAssignment(questData.GetRecommendedLevelID());
    this.m_currentQuestData = questData;
    this.m_journalManager = journalManager;
    this.m_phoneSystem = phoneSystem;
    this.m_mappinSystem = mappinSystem;
    this.m_uiSystem = uiSystem;
    inkWidgetRef.SetVisible(this.m_noSelectedQuestContainer, false);
    inkWidgetRef.SetVisible(this.m_contentContainer, true);
    inkTextRef.SetText(this.m_questTitle, questData.GetTitle(journalManager));
    inkWidgetRef.SetState(this.m_questLevel, QuestLogUtils.GetLevelState(RoundMath(playerLevel), recommendedLevel));
    inkTextRef.SetText(this.m_questLevel, QuestLogUtils.GetThreatText(RoundMath(playerLevel), recommendedLevel));
    inkWidgetRef.SetVisible(this.m_ep1Marker, journalManager.IsEp1Entry(this.m_currentQuestData));
    inkTextRef.SetText(this.m_questDescription, "");
    this.m_trackedObjective = journalManager.GetTrackedEntry() as JournalQuestObjective;
    inkCompoundRef.RemoveAllChildren(this.m_codexLinksContainer);
    inkCompoundRef.RemoveAllChildren(this.m_missionLinksContainer);
    inkCompoundRef.RemoveAllChildren(this.m_fluffLinksContainer);
    this.PopulateObjectives();
  }

  public final func HasMultipleActionLinks() -> Bool {
    return this.m_objectiveActionsCount > 1;
  }

  public final func SetPhoneAvailable(value: Bool) -> Void {
    this.m_canUsePhone = value;
  }

  private final func PopulateObjectives() -> Void {
    let childEntries: array<wref<JournalEntry>>;
    let childEntryState: gameJournalEntryState;
    let codexLink: wref<JournalQuestCodexLink>;
    let codexLinksObjectiveEntry: wref<JournalQuestObjective>;
    let contextFilter: JournalRequestStateFilter;
    let controller: ref<QuestDetailsObjectiveController>;
    let currentCounter: Int32;
    let currentEntry: wref<JournalEntry>;
    let description: String;
    let descriptionEntries: array<wref<JournalQuestDescription>>;
    let i: Int32;
    let isObjectiveTracked: Bool;
    let objectiveEntry: wref<JournalQuestObjective>;
    let totalCounter: Int32;
    let uniqueQuestDescriptions: array<String>;
    let widget: wref<inkWidget>;
    let nextLine: Bool = false;
    contextFilter.active = true;
    contextFilter.inactive = true;
    contextFilter.succeeded = true;
    contextFilter.failed = true;
    inkCompoundRef.RemoveAllChildren(this.m_activeObjectives);
    inkCompoundRef.RemoveAllChildren(this.m_optionalObjectives);
    inkCompoundRef.RemoveAllChildren(this.m_fluffLinksContainer);
    inkWidgetRef.SetVisible(this.m_fluffShardLinkLine, false);
    this.m_objectiveActionsCount = this.CalcObjectiveActionsCount(this.m_currentQuestData);
    this.m_journalManager.GetChildren(this.m_currentQuestData, contextFilter, childEntries);
    i = 0;
    while i < ArraySize(childEntries) {
      codexLink = childEntries[i] as JournalQuestCodexLink;
      if IsDefined(codexLink) {
        currentEntry = this.m_journalManager.GetEntry(codexLink.GetLinkPathHash());
        childEntryState = this.m_journalManager.GetEntryState(currentEntry);
        if IsDefined(currentEntry as JournalOnscreen) && Equals(childEntryState, gameJournalEntryState.Active) {
          this.SpawnFluffShardLink(currentEntry as JournalOnscreen);
          inkWidgetRef.SetVisible(this.m_fluffShardLinkLine, true);
        };
      };
      i += 1;
    };
    QuestLogUtils.UnpackRecursive(this.m_journalManager, this.m_currentQuestData, childEntries);
    i = 0;
    while i < ArraySize(childEntries) {
      currentEntry = childEntries[i];
      objectiveEntry = currentEntry as JournalQuestObjective;
      if IsDefined(objectiveEntry) {
        isObjectiveTracked = this.m_trackedObjective == objectiveEntry;
        widget = this.SpawnFromLocal(inkWidgetRef.Get(this.m_activeObjectives), n"questObjective");
        widget.SetHAlign(inkEHorizontalAlign.Left);
        widget.SetVAlign(inkEVerticalAlign.Top);
        currentCounter = this.m_journalManager.GetObjectiveCurrentCounter(objectiveEntry);
        totalCounter = this.m_journalManager.GetObjectiveTotalCounter(objectiveEntry);
        controller = widget.GetController() as QuestDetailsObjectiveController;
        controller.Setup(objectiveEntry, this.m_journalManager, currentCounter, totalCounter, isObjectiveTracked);
        this.PopulateObjectiveActionLinks(objectiveEntry, this.m_activeObjectives);
        if isObjectiveTracked || !IsDefined(codexLinksObjectiveEntry) {
          codexLinksObjectiveEntry = objectiveEntry;
        };
      };
      i += 1;
    };
    if IsDefined(codexLinksObjectiveEntry) {
      this.PopulateCodexLinks(codexLinksObjectiveEntry);
    };
    descriptionEntries = QuestLogUtils.GetDescriptions(this.m_journalManager, this.m_currentQuestData);
    description = "";
    i = 0;
    while i < ArraySize(descriptionEntries) {
      if ArrayContains(uniqueQuestDescriptions, GetLocalizedText(descriptionEntries[i].GetDescription())) {
      } else {
        ArrayPush(uniqueQuestDescriptions, GetLocalizedText(descriptionEntries[i].GetDescription()));
        description = nextLine ? description + " " + GetLocalizedText(descriptionEntries[i].GetDescription()) : description + GetLocalizedText(descriptionEntries[i].GetDescription());
        if i < ArraySize(descriptionEntries) - 1 {
          description + "\\n";
        };
        nextLine = true;
      };
      i += 1;
    };
    inkTextRef.SetText(this.m_questDescription, description);
  }

  protected cb func OnUpdateTrackedObjectiveEvent(e: ref<UpdateTrackedObjectiveEvent>) -> Bool {
    this.m_trackedObjective = e.m_trackedObjective;
    if IsDefined(this.m_trackedObjective) {
      this.PopulateCodexLinks(this.m_trackedObjective);
    };
  }

  public final func PopulateCodexLinks(objective: ref<JournalQuestObjective>) -> Void {
    let childEntries: array<wref<JournalEntry>>;
    let childEntriesSorted: array<wref<JournalEntry>>;
    let childEntry: wref<JournalEntry>;
    let childEntryHash: Int32;
    let childEntryState: gameJournalEntryState;
    let codexLink: wref<JournalQuestCodexLink>;
    let codexLinksSpawned: Int32;
    let i: Int32;
    let mappinLinkAdded: Bool;
    let mappinPosition: Vector3;
    let replacerEntry: wref<JournalCodexEntry>;
    let unpackFilter: JournalRequestStateFilter;
    unpackFilter.active = true;
    unpackFilter.inactive = true;
    QuestLogUtils.UnpackRecursiveWithFilter(this.m_journalManager, objective, unpackFilter, childEntries, true);
    inkCompoundRef.RemoveAllChildren(this.m_codexLinksContainer);
    inkCompoundRef.RemoveAllChildren(this.m_missionLinksContainer);
    inkCompoundRef.RemoveAllChildren(this.m_mapLinksContainer);
    inkWidgetRef.SetVisible(this.m_codexLinkLine, false);
    inkWidgetRef.SetVisible(this.m_missionLinkLine, false);
    i = 0;
    while i < ArraySize(childEntries) {
      if IsDefined(childEntries[i] as JournalQuestMapPinBase) {
        if !mappinLinkAdded {
          ArrayInsert(childEntriesSorted, 0, childEntries[i]);
          mappinLinkAdded = true;
        };
      } else {
        codexLink = childEntries[i] as JournalQuestCodexLink;
        childEntry = this.m_journalManager.GetEntry(codexLink.GetLinkPathHash());
        childEntryState = this.m_journalManager.GetEntryState(childEntry);
        if Equals(childEntryState, gameJournalEntryState.Succeeded) || Equals(childEntryState, gameJournalEntryState.Failed) {
          ArrayPush(childEntriesSorted, childEntries[i]);
        } else {
          ArrayInsert(childEntriesSorted, 0, childEntries[i]);
        };
      };
      i += 1;
    };
    i = 0;
    while i < ArraySize(childEntriesSorted) {
      codexLink = childEntriesSorted[i] as JournalQuestCodexLink;
      if IsDefined(codexLink) {
        childEntry = this.m_journalManager.GetEntry(codexLink.GetLinkPathHash());
        childEntryState = this.m_journalManager.GetEntryState(childEntry);
        if Equals(childEntryState, gameJournalEntryState.Inactive) && !IsDefined(childEntry as JournalPhoneMessage) && !IsDefined(childEntry as JournalOnscreen) && !IsDefined(childEntry as JournalQuest) {
          childEntryHash = this.m_journalManager.GetEntryHash(childEntry);
          this.m_journalManager.ChangeEntryStateByHash(Cast<Uint32>(childEntryHash), gameJournalEntryState.Active, JournalNotifyOption.DoNotNotify);
        };
        if IsDefined(childEntry as JournalCodexEntry) && codexLinksSpawned < 4 {
          replacerEntry = CodexUtils.GetCodexReplacementRecord(this.m_journalManager, childEntry as JournalCodexEntry);
          this.SpawnCodexLink(childEntry, replacerEntry);
          inkWidgetRef.SetVisible(this.m_codexLinkLine, true);
          codexLinksSpawned += 1;
        } else {
          if IsDefined(childEntry as JournalQuest) && NotEquals(childEntryState, gameJournalEntryState.Inactive) {
            this.SpawnQuestLink(childEntry as JournalQuest);
            inkWidgetRef.SetVisible(this.m_missionLinkLine, true);
          };
        };
      } else {
        if IsDefined(childEntriesSorted[i] as JournalImageEntry) && codexLinksSpawned < 4 {
          this.SpawnCodexLink(childEntriesSorted[i]);
          codexLinksSpawned += 1;
        } else {
          if IsDefined(childEntriesSorted[i] as JournalQuestMapPinBase) {
            this.m_mappinSystem.GetQuestMappinPosition(Cast<Uint32>(this.m_journalManager.GetEntryHash(childEntriesSorted[i])), mappinPosition);
            this.SpawnMappinLink(childEntriesSorted[i] as JournalQuestMapPinBase, mappinPosition, this.m_trackedObjective == objective);
          };
        };
      };
      i += 1;
    };
  }

  public final func CalcObjectiveActionsCount(entry: wref<JournalContainerEntry>) -> Int32 {
    let childEntries: array<wref<JournalEntry>>;
    let childEntry: wref<JournalEntry>;
    let codexLink: wref<JournalQuestCodexLink>;
    let i: Int32;
    let unpackFilter: JournalRequestStateFilter;
    unpackFilter.active = true;
    unpackFilter.inactive = false;
    let objectiveActionsCount: Int32 = 0;
    QuestLogUtils.UnpackRecursiveWithFilter(this.m_journalManager, entry, unpackFilter, childEntries, true);
    i = 0;
    while i < ArraySize(childEntries) {
      codexLink = childEntries[i] as JournalQuestCodexLink;
      if IsDefined(codexLink) {
        childEntry = this.m_journalManager.GetEntry(codexLink.GetLinkPathHash());
        if IsDefined(childEntry as JournalContact) && this.m_canUsePhone {
          objectiveActionsCount += 1;
        } else {
          if IsDefined(childEntry as JournalPhoneMessage) || IsDefined(childEntry as JournalPhoneChoiceGroup) || IsDefined(childEntry as JournalPhoneConversation) {
            objectiveActionsCount += 1;
          } else {
            if IsDefined(childEntry as JournalOnscreen) {
              objectiveActionsCount += 1;
            };
          };
        };
      };
      i += 1;
    };
    return objectiveActionsCount;
  }

  public final func PopulateObjectiveActionLinks(trackedObjective: ref<JournalQuestObjective>, container: inkCompoundRef) -> Void {
    let childEntries: array<wref<JournalEntry>>;
    let childEntry: wref<JournalEntry>;
    let codexLink: wref<JournalQuestCodexLink>;
    let enableInput: Bool;
    let i: Int32;
    let unpackFilter: JournalRequestStateFilter;
    unpackFilter.active = true;
    unpackFilter.inactive = true;
    QuestLogUtils.UnpackRecursiveWithFilter(this.m_journalManager, trackedObjective, unpackFilter, childEntries, true);
    enableInput = this.m_objectiveActionsCount < 2;
    i = 0;
    while i < ArraySize(childEntries) {
      codexLink = childEntries[i] as JournalQuestCodexLink;
      if IsDefined(codexLink) {
        childEntry = this.m_journalManager.GetEntry(codexLink.GetLinkPathHash());
        if IsDefined(childEntry as JournalContact) && this.m_canUsePhone {
          this.SpawnContactLink(childEntry as JournalContact, container, enableInput);
        } else {
          if IsDefined(childEntry as JournalPhoneMessage) || IsDefined(childEntry as JournalPhoneChoiceGroup) || IsDefined(childEntry as JournalPhoneConversation) {
            this.SpawnMessageLink(childEntry, container, enableInput);
          } else {
            if IsDefined(childEntry as JournalOnscreen) {
              this.SpawnShardLink(childEntry as JournalOnscreen, container, enableInput);
            };
          };
        };
      };
      i += 1;
    };
  }

  private final func SpawnMappinLink(mappinEntry: ref<JournalQuestMapPinBase>, jumpTo: Vector3, isTracked: Bool) -> Void {
    let widget: wref<inkWidget> = this.SpawnFromLocal(inkWidgetRef.Get(this.m_mapLinksContainer), n"linkMappin");
    let controller: ref<QuestMappinLinkController> = widget.GetController() as QuestMappinLinkController;
    controller.Setup(mappinEntry, this.m_journalManager.GetEntryHash(mappinEntry), jumpTo, isTracked);
  }

  private final func SpawnCodexLink(journalEntry: ref<JournalEntry>, opt journalEntryReplacer: ref<JournalEntry>) -> Void {
    let widget: wref<inkWidget> = this.SpawnFromLocal(inkWidgetRef.Get(this.m_codexLinksContainer), n"linkCodex");
    let controller: ref<QuestCodexLinkController> = widget.GetController() as QuestCodexLinkController;
    controller.Setup(journalEntry, journalEntryReplacer);
  }

  private final func SpawnQuestLink(journalEntry: ref<JournalQuest>) -> Void {
    let controller: ref<QuestMissionLinkController>;
    let widget: wref<inkWidget> = this.SpawnFromLocal(inkWidgetRef.Get(this.m_missionLinksContainer), n"linkQuest");
    widget.SetHAlign(inkEHorizontalAlign.Right);
    widget.SetVAlign(inkEVerticalAlign.Top);
    controller = widget.GetController() as QuestMissionLinkController;
    controller.Setup(journalEntry, this.m_journalManager);
  }

  private final func SpawnContactLink(contactEntry: ref<JournalContact>, container: inkCompoundRef, inputEnabled: Bool) -> Void {
    let controller: ref<QuestContactLinkController>;
    let widget: wref<inkWidget> = this.SpawnFromLocal(inkWidgetRef.Get(container), n"linkPhoneContact");
    widget.SetHAlign(inkEHorizontalAlign.Right);
    widget.SetVAlign(inkEVerticalAlign.Top);
    controller = widget.GetController() as QuestContactLinkController;
    controller.Setup(contactEntry, this.m_journalManager, this.m_phoneSystem, this.m_uiSystem);
    controller.EnableInputHint(inputEnabled);
  }

  private final func SpawnMessageLink(childEntry: wref<JournalEntry>, container: inkCompoundRef, inputEnabled: Bool) -> Void {
    let controller: ref<QuestMessageLinkController>;
    let widget: wref<inkWidget> = this.SpawnFromLocal(inkWidgetRef.Get(container), n"linkMessageEntry");
    widget.SetHAlign(inkEHorizontalAlign.Left);
    widget.SetVAlign(inkEVerticalAlign.Top);
    widget.SetMargin(this.m_objectiveActionOffset, 0.00, 0.00, 0.00);
    controller = widget.GetController() as QuestMessageLinkController;
    controller.Setup(childEntry, this.m_journalManager, this.m_phoneSystem);
    controller.EnableInputHint(inputEnabled);
  }

  private final func SpawnShardLink(journalEntry: ref<JournalOnscreen>, container: inkCompoundRef, inputEnabled: Bool) -> Void {
    let controller: ref<QuestShardLinkController>;
    let widget: wref<inkWidget> = this.SpawnFromLocal(inkWidgetRef.Get(container), n"linkShardEntry");
    widget.SetHAlign(inkEHorizontalAlign.Left);
    widget.SetVAlign(inkEVerticalAlign.Top);
    widget.SetMargin(this.m_objectiveActionOffset, 0.00, 0.00, 0.00);
    controller = widget.GetController() as QuestShardLinkController;
    controller.Setup(journalEntry, this.m_journalManager);
    controller.EnableInputHint(inputEnabled);
  }

  private final func SpawnFluffShardLink(journalEntry: ref<JournalOnscreen>) -> Void {
    let widget: wref<inkWidget> = this.SpawnFromLocal(inkWidgetRef.Get(this.m_fluffLinksContainer), n"linkFluffShard");
    let controller: ref<QuestShardLinkController> = widget.GetController() as QuestShardLinkController;
    controller.Setup(journalEntry, this.m_journalManager);
  }
}
