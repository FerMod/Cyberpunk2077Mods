
public abstract class QuestLogUtils extends IScriptable {

  public final static func GetFixerData(journalManager: ref<JournalManager>, firstObjective: wref<JournalQuestObjective>) -> TweakDBID {
    let childEntries: array<wref<JournalEntry>>;
    let childEntry: wref<JournalEntry>;
    let codexLink: wref<JournalQuestCodexLink>;
    let currentCategory: wref<JournalCodexCategory>;
    let currentGroup: wref<JournalCodexGroup>;
    let currentType: CodexCategoryType;
    let i: Int32;
    let id: TweakDBID;
    let journalCodexEntry: ref<JournalCodexEntry>;
    let replacementEntry: wref<JournalCodexEntry>;
    let size: Int32;
    let unpackFilter: JournalRequestStateFilter;
    unpackFilter.active = true;
    unpackFilter.inactive = true;
    QuestLogUtils.UnpackRecursiveWithFilter(journalManager, firstObjective, unpackFilter, childEntries, true);
    size = ArraySize(childEntries);
    i = 0;
    while i < size {
      codexLink = childEntries[i] as JournalQuestCodexLink;
      if IsDefined(codexLink) {
        childEntry = journalManager.GetEntry(codexLink.GetLinkPathHash());
        if IsDefined(childEntry as JournalCodexEntry) {
          currentGroup = journalManager.GetParentEntry(childEntry) as JournalCodexGroup;
          currentCategory = journalManager.GetParentEntry(currentGroup) as JournalCodexCategory;
          currentType = CodexUtils.GetCategoryTypeFromId(currentCategory.GetId());
          if Equals(currentType, CodexCategoryType.Characters) && Equals(currentGroup.GetId(), "fixers") {
            replacementEntry = CodexUtils.GetCodexReplacementRecord(journalManager, childEntry);
            if IsDefined(replacementEntry) {
              childEntry = replacementEntry;
            };
            journalCodexEntry = childEntry as JournalCodexEntry;
            return journalCodexEntry.GetLinkImageID();
          };
        };
      };
      i += 1;
    };
    return id;
  }

  public final static func GetDefaultFilter() -> JournalRequestStateFilter {
    let contextFilter: JournalRequestStateFilter;
    contextFilter.active = true;
    contextFilter.inactive = true;
    contextFilter.succeeded = false;
    contextFilter.failed = false;
    return contextFilter;
  }

  public final static func GetObjectiveFilter() -> JournalRequestStateFilter {
    let contextFilter: JournalRequestStateFilter;
    contextFilter.active = false;
    contextFilter.inactive = true;
    contextFilter.succeeded = false;
    contextFilter.failed = false;
    return contextFilter;
  }

  public final static func GetSuccessFilter() -> JournalRequestStateFilter {
    let contextFilter: JournalRequestStateFilter;
    contextFilter.active = false;
    contextFilter.inactive = false;
    contextFilter.succeeded = true;
    contextFilter.failed = false;
    return contextFilter;
  }

  public final static func GetFailedFilter() -> JournalRequestStateFilter {
    let contextFilter: JournalRequestStateFilter;
    contextFilter.active = false;
    contextFilter.inactive = false;
    contextFilter.succeeded = false;
    contextFilter.failed = true;
    return contextFilter;
  }

  public final static func UnpackRecursiveWithFilter(journalManager: ref<JournalManager>, entry: wref<JournalContainerEntry>, filter: JournalRequestStateFilter, result: script_ref<[wref<JournalEntry>]>, opt includeInactive: Bool) -> Void {
    let containerEntry: ref<JournalContainerEntry>;
    let currentEntry: wref<JournalEntry>;
    let childEntries: array<wref<JournalEntry>> = QuestLogUtils.Unpack(journalManager, entry, filter);
    let i: Int32 = 0;
    while i < ArraySize(childEntries) {
      currentEntry = childEntries[i];
      if !includeInactive && Equals(journalManager.GetEntryState(currentEntry), gameJournalEntryState.Inactive) && (currentEntry as JournalQuestMapPinBase) == null {
      } else {
        ArrayPush(Deref(result), currentEntry);
        containerEntry = currentEntry as JournalContainerEntry;
        if IsDefined(containerEntry) {
          if IsDefined(containerEntry as JournalQuestObjective) {
            QuestLogUtils.UnpackRecursiveWithFilter(journalManager, containerEntry, QuestLogUtils.GetDefaultFilter(), result, includeInactive);
            QuestLogUtils.UnpackRecursiveWithFilter(journalManager, containerEntry, QuestLogUtils.GetObjectiveFilter(), result, includeInactive);
          } else {
            QuestLogUtils.UnpackRecursiveWithFilter(journalManager, containerEntry, filter, result, includeInactive);
          };
        };
      };
      i += 1;
    };
  }

  public final static func UnpackRecursive(journalManager: ref<JournalManager>, entry: wref<JournalContainerEntry>, result: script_ref<[wref<JournalEntry>]>) -> Void {
    QuestLogUtils.UnpackRecursiveWithFilter(journalManager, entry, QuestLogUtils.GetDefaultFilter(), result);
  }

  public final static func Unpack(journalManager: ref<JournalManager>, entry: wref<JournalContainerEntry>, filter: JournalRequestStateFilter) -> [wref<JournalEntry>] {
    let childEntries: array<wref<JournalEntry>>;
    journalManager.GetChildren(entry, filter, childEntries);
    return childEntries;
  }

  public final static func GetDescriptions(journalManager: ref<JournalManager>, entry: wref<JournalContainerEntry>) -> [wref<JournalQuestDescription>] {
    let contextFilter: JournalRequestStateFilter;
    let i: Int32;
    let objects: array<wref<JournalEntry>>;
    let results: array<wref<JournalQuestDescription>>;
    contextFilter.active = true;
    contextFilter.inactive = false;
    contextFilter.succeeded = true;
    contextFilter.failed = true;
    QuestLogUtils.UnpackRecursiveWithFilter(journalManager, entry, contextFilter, objects);
    i = 0;
    while i < ArraySize(objects) {
      if IsDefined(objects[i] as JournalQuestDescription) {
        ArrayPush(results, objects[i] as JournalQuestDescription);
      };
      i += 1;
    };
    return results;
  }

  public final static func GetLevelState(playerLevel: Int32, targetLevel: Int32) -> CName {
    let difference: Int32 = playerLevel - targetLevel;
    if difference <= -6 {
      return n"ThreatVeryHigh";
    };
    if difference <= -3 {
      return n"ThreatHigh";
    };
    if difference <= 2 {
      return n"ThreatMedium";
    };
    if difference <= 4 {
      return n"ThreatLow";
    };
    if difference <= 5 {
      return n"ThreatVeryLow";
    };
    return n"ThreatVeryLow";
  }

  public final static func GetThreatText(playerLevel: Int32, targetLevel: Int32) -> String {
    let result: String = GetLocalizedText("UI-ResourceExports-Threat") + ": ";
    switch QuestLogUtils.GetLevelState(playerLevel, targetLevel) {
      case n"ThreatVeryLow":
        result += GetLocalizedText("UI-Tooltips-ThreatVeryLow");
        break;
      case n"ThreatLow":
        result += GetLocalizedText("UI-Tooltips-Low");
        break;
      case n"ThreatMedium":
        result += GetLocalizedText("UI-Tooltips-ThreatMedium");
        break;
      case n"ThreatHigh":
        result += GetLocalizedText("UI-Tooltips-ThreatHigh");
        break;
      case n"ThreatVeryHigh":
        result += GetLocalizedText("UI-Tooltips-ThreatVeryHigh");
    };
    return result;
  }
}

public abstract final class QuestTypeIconUtils extends IScriptable {

  public final static func GetIcon(filterType: QuestListItemType) -> CName {
    switch filterType {
      case QuestListItemType.All:
        return n"journal_all";
      case QuestListItemType.MainQuest:
        return n"quest";
      case QuestListItemType.SideQuest:
        return n"minor_quest";
      case QuestListItemType.Gig:
        return n"gigs";
      case QuestListItemType.Cyberpsycho:
        return n"hunt_for_psycho";
      case QuestListItemType.NCPDQuest:
        return n"map_bounty";
      case QuestListItemType.Apartment:
        return n"apartment_to_buy";
      case QuestListItemType.Courier:
        return n"courier";
      case QuestListItemType.Finished:
        return n"completed";
    };
    return n"invalid";
  }

  public final static func GetFilterIcon(filterType: QuestListItemType) -> CName {
    switch filterType {
      case QuestListItemType.All:
        return n"journal_all";
      case QuestListItemType.SideQuest:
      case QuestListItemType.MainQuest:
        return n"quest_filter";
      case QuestListItemType.Courier:
      case QuestListItemType.Apartment:
      case QuestListItemType.NCPDQuest:
      case QuestListItemType.Cyberpsycho:
      case QuestListItemType.Gig:
        return n"world_activities";
      case QuestListItemType.Finished:
        return n"completed";
    };
    return n"invalid";
  }

  public final static func GetIconState(filterType: QuestListItemType) -> CName {
    switch filterType {
      case QuestListItemType.All:
        return n"All";
      case QuestListItemType.MainQuest:
        return n"MainQuest";
      case QuestListItemType.SideQuest:
        return n"MainQuest";
      case QuestListItemType.Gig:
        return n"Gig";
      case QuestListItemType.Cyberpsycho:
        return n"Cyberpsycho";
      case QuestListItemType.NCPDQuest:
        return n"Cyberpsycho";
      case QuestListItemType.Apartment:
        return n"Apartment";
      case QuestListItemType.Courier:
        return n"Gig";
      case QuestListItemType.Finished:
        return n"Finished";
    };
    return n"Default";
  }
}
