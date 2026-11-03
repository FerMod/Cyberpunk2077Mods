
public class ShardsNestedListDataView extends VirtualNestedListDataView {

  protected func SortItems(compareBuilder: ref<CompareBuilder>, left: ref<VirutalNestedListData>, right: ref<VirutalNestedListData>) -> Void {
    let leftData: ref<ShardEntryData> = left.m_data as ShardEntryData;
    let rightData: ref<ShardEntryData> = right.m_data as ShardEntryData;
    if IsDefined(leftData) && IsDefined(rightData) {
      compareBuilder.BoolTrue(leftData.m_isNew, rightData.m_isNew).GameTimeDesc(leftData.m_timeStamp, rightData.m_timeStamp);
    };
  }
}

public class ShardsVirtualNestedListController extends VirtualNestedListController {

  private let m_currentDataView: wref<ShardsNestedListDataView>;

  protected func GetDataView() -> ref<VirtualNestedListDataView> {
    let view: ref<ShardsNestedListDataView> = new ShardsNestedListDataView();
    this.m_currentDataView = view;
    return view;
  }

  public final func GetIndexByJournalHash(hash: Int32) -> Int32 {
    let currentData: wref<ShardEntryData>;
    let dataSize: Int32;
    let i: Int32;
    let listData: wref<VirutalNestedListData>;
    if this.m_currentDataView == null {
      return -1;
    };
    dataSize = Cast<Int32>(this.m_currentDataView.Size());
    i = 0;
    while i < dataSize {
      listData = this.m_currentDataView.GetItem(Cast<Uint32>(i)) as VirutalNestedListData;
      currentData = listData.m_data as ShardEntryData;
      if currentData.m_hash == hash {
        return i;
      };
      i = i + 1;
    };
    return -1;
  }

  public final func FindDataIndex(hash: Int32) -> Int32 {
    let dataArray: array<ref<IScriptable>>;
    let dataSize: Int32;
    let i: Int32;
    let itemData: ref<VirutalNestedListData>;
    let shardData: ref<ShardEntryData>;
    if this.m_dataSource == null {
      return -1;
    };
    dataSize = Cast<Int32>(this.m_dataSource.GetArraySize());
    dataArray = this.m_dataSource.GetArray();
    i = 0;
    while i < dataSize {
      itemData = dataArray[i] as VirutalNestedListData;
      shardData = itemData.m_data as ShardEntryData;
      if shardData != null && hash == shardData.m_hash {
        return i;
      };
      i = i + 1;
    };
    return -1;
  }

  public final func ShowLevelForDataIndex(index: Int32) -> Void {
    let itemData: ref<VirutalNestedListData>;
    let data: array<ref<IScriptable>> = this.m_dataSource.GetArray();
    let dataSize: Int32 = Cast<Int32>(this.m_dataSource.GetArraySize());
    if dataSize <= index {
      return;
    };
    itemData = data[index] as VirutalNestedListData;
    if !this.IsLevelToggled(itemData.m_level) {
      this.ToggleLevel(itemData.m_level);
    };
  }
}

public class CodexUtils extends IScriptable {

  public final static func GetShardsDataArray(journal: ref<JournalManager>, activeDataSync: wref<CodexListSyncData>) -> [ref<VirutalNestedListData>] {
    let context: JournalRequestContext;
    let curGroup: wref<JournalOnscreensStructuredGroup>;
    let curShard: wref<JournalOnscreen>;
    let groupData: ref<ShardEntryData>;
    let groupVirtualListData: ref<VirutalNestedListData>;
    let groups: array<ref<JournalOnscreensStructuredGroup>>;
    let hasNewEntries: Bool;
    let i: Int32;
    let j: Int32;
    let newEntries: array<Int32>;
    let shardData: ref<ShardEntryData>;
    let shardVirtualListData: ref<VirutalNestedListData>;
    let shards: array<wref<JournalOnscreen>>;
    let virtualDataList: array<ref<VirutalNestedListData>>;
    context.stateFilter.active = true;
    journal.GetOnscreens(context, groups, n"others");
    i = 0;
    while i < ArraySize(groups) {
      curGroup = groups[i];
      shards = curGroup.GetEntries();
      hasNewEntries = false;
      ArrayClear(newEntries);
      j = 0;
      while j < ArraySize(shards) {
        curShard = shards[j];
        shardData = new ShardEntryData();
        shardData.m_title = curShard.GetTitle();
        shardData.m_description = curShard.GetDescription();
        shardData.m_imageId = curShard.GetIconID();
        shardData.m_hash = journal.GetEntryHash(curShard);
        shardData.m_timeStamp = journal.GetEntryTimestamp(curShard);
        shardData.m_activeDataSync = activeDataSync;
        shardData.m_isNew = !journal.IsEntryVisited(curShard);
        if shardData.m_isNew {
          ArrayPush(newEntries, shardData.m_hash);
          ArrayPush(shardData.m_newEntries, shardData.m_hash);
        };
        shardVirtualListData = new VirutalNestedListData();
        shardVirtualListData.m_level = i;
        shardVirtualListData.m_widgetType = 0u;
        shardVirtualListData.m_isHeader = false;
        shardVirtualListData.m_data = shardData;
        ArrayPush(virtualDataList, shardVirtualListData);
        if shardData.m_isNew {
          hasNewEntries = true;
        };
        j += 1;
      };
      groupData = new ShardEntryData();
      groupData.m_title = CodexUtils.GetLocalizedTag(curGroup.GetTag());
      groupData.m_activeDataSync = activeDataSync;
      groupData.m_counter = ArraySize(shards);
      groupData.m_isNew = hasNewEntries;
      groupData.m_newEntries = newEntries;
      groupVirtualListData = new VirutalNestedListData();
      groupVirtualListData.m_level = i;
      groupVirtualListData.m_widgetType = 1u;
      groupVirtualListData.m_isHeader = true;
      groupVirtualListData.m_data = groupData;
      ArrayPush(virtualDataList, groupVirtualListData);
      i += 1;
    };
    return virtualDataList;
  }

  public final static func GetCodexReplacementRecord(journal: ref<JournalManager>, currentEntry: wref<JournalEntry>) -> wref<JournalCodexEntry> {
    let codexEntry: wref<JournalCodexEntry>;
    let filter: JournalRequestStateFilter;
    let innerEntries: array<wref<JournalEntry>>;
    let l: Int32;
    filter.inactive = false;
    filter.active = true;
    journal.GetChildren(currentEntry, filter, innerEntries);
    l = 0;
    while l < ArraySize(innerEntries) {
      codexEntry = innerEntries[l] as JournalCodexEntry;
      if IsDefined(codexEntry) {
        return codexEntry;
      };
      l += 1;
    };
    return null;
  }

  public final static func ConvertToCodexData(journal: ref<JournalManager>, journalCodexEntry: wref<JournalCodexEntry>, currentCategoryIndex: Int32, stateFilter: JournalRequestStateFilter, newEntries: script_ref<[Int32]>, opt activeDataSync: wref<CodexListSyncData>, opt useFallbackImages: Bool) -> ref<CodexEntryData> {
    let descriptionStateFilter: JournalRequestStateFilter;
    let j: Int32;
    let journalCodexEntryData: ref<CodexEntryData>;
    let journalCodexSubEntry: wref<JournalCodexDescription>;
    let journalCodexSubEntryList: array<wref<JournalEntry>>;
    let replacementEntry: wref<JournalCodexEntry>;
    ArrayClear(journalCodexSubEntryList);
    descriptionStateFilter.inactive = true;
    descriptionStateFilter.active = true;
    descriptionStateFilter.succeeded = true;
    descriptionStateFilter.failed = true;
    journal.GetChildren(journalCodexEntry, descriptionStateFilter, journalCodexSubEntryList);
    replacementEntry = CodexUtils.GetCodexReplacementRecord(journal, journalCodexEntry);
    if IsDefined(replacementEntry) {
      journalCodexEntry = replacementEntry;
    };
    journalCodexEntryData = new CodexEntryData();
    journalCodexEntryData.m_hash = journal.GetEntryHash(journalCodexEntry);
    journalCodexEntryData.m_title = journalCodexEntry.GetTitle();
    journalCodexEntryData.m_imageId = journalCodexEntry.GetImageID();
    if !TDBID.IsValid(journalCodexEntryData.m_imageId) && useFallbackImages {
      journalCodexEntryData.m_imageId = Equals(journalCodexEntryData.m_imageType, CodexImageType.Default) ? t"UIJournalIcons.PlaceholderCodexImage" : t"UIJournalIcons.PlaceholderCodexCharacterImage";
    };
    journalCodexEntryData.m_timeStamp = journal.GetEntryTimestamp(journalCodexEntry);
    journalCodexEntryData.m_isNew = !journal.IsEntryVisited(journalCodexEntry);
    journalCodexEntryData.m_isEp1 = journal.IsEp1Entry(journalCodexEntry);
    journalCodexEntryData.m_activeDataSync = activeDataSync;
    journalCodexEntryData.m_category = currentCategoryIndex;
    journalCodexEntryData.m_imageType = currentCategoryIndex != 2 ? CodexImageType.Default : CodexImageType.Character;
    j = 0;
    while j < ArraySize(journalCodexSubEntryList) {
      journalCodexSubEntry = journalCodexSubEntryList[j] as JournalCodexDescription;
      if IsDefined(journalCodexSubEntry) {
        journalCodexEntryData.m_description = journalCodexSubEntry.GetTextContent();
        if journalCodexSubEntry.GetJournalEntryOverrideDataListCount() > 0 {
          ArrayClear(journalCodexEntryData.m_journalEntryOverrideDataList);
          journalCodexSubEntry.GetJournalEntryOverrideDataList(journalCodexEntryData.m_journalEntryOverrideDataList);
        };
      };
      j += 1;
    };
    if journalCodexEntryData.m_isNew {
      ArrayPush(Deref(newEntries), journalCodexEntryData.m_hash);
      ArrayPush(journalCodexEntryData.m_newEntries, journalCodexEntryData.m_hash);
    };
    return journalCodexEntryData;
  }

  public final static func IsImageValid(imageId: TweakDBID) -> Bool {
    let iconRecord: ref<UIIcon_Record>;
    let partName: CName;
    if TDBID.IsValid(imageId) {
      iconRecord = TweakDBInterface.GetUIIconRecord(imageId);
      partName = iconRecord.AtlasPartName();
      return NotEquals(partName, n"empty") && NotEquals(partName, n"empty2") && NotEquals(partName, n"c_empty");
    };
    return false;
  }

  public final static func GetGroupData(currentGroup: wref<JournalCodexGroup>, out groupsMap: [ref<VirutalNestedListData>]) -> wref<VirutalNestedListData> {
    let groupData: ref<CodexEntryData>;
    let groupIndex: Int32;
    let groupVirtualListData: ref<VirutalNestedListData>;
    let groupName: String = currentGroup.GetGroupName();
    let i: Int32 = 0;
    while i < ArraySize(groupsMap) {
      groupVirtualListData = groupsMap[i];
      groupData = groupVirtualListData.m_data as CodexEntryData;
      if Equals(groupData.m_title, groupName) {
        return groupVirtualListData;
      };
      i += 1;
    };
    groupIndex = ArraySize(groupsMap);
    groupData = new CodexEntryData();
    groupData.m_title = groupName;
    groupVirtualListData = new VirutalNestedListData();
    groupVirtualListData.m_level = groupIndex;
    groupVirtualListData.m_widgetType = 1u;
    groupVirtualListData.m_isHeader = true;
    groupVirtualListData.m_collapsable = true;
    groupVirtualListData.m_data = groupData;
    ArrayPush(groupsMap, groupVirtualListData);
    return groupVirtualListData;
  }

  public final static func GetCodexDataArray(journal: ref<JournalManager>, activeDataSync: wref<CodexListSyncData>, opt useFallbackImages: Bool) -> [ref<VirutalNestedListData>] {
    let categories: array<wref<JournalEntry>>;
    let context: JournalRequestContext;
    let currentCategory: wref<JournalCodexCategory>;
    let currentCategoryIndex: Int32;
    let currentEntry: wref<JournalCodexEntry>;
    let currentGroup: wref<JournalCodexGroup>;
    let currentGroupVirtualListData: ref<VirutalNestedListData>;
    let entries: array<wref<JournalEntry>>;
    let entryData: ref<CodexEntryData>;
    let entryVirtualListData: ref<VirutalNestedListData>;
    let groupEntryData: wref<CodexEntryData>;
    let groups: array<wref<JournalEntry>>;
    let hasNewEntries: Bool;
    let i: Int32;
    let isSorted: Bool;
    let j: Int32;
    let k: Int32;
    let newEntries: array<Int32>;
    let stateFilter: JournalRequestStateFilter;
    let virtualDataList: array<ref<VirutalNestedListData>>;
    context.stateFilter.inactive = false;
    context.stateFilter.failed = false;
    context.stateFilter.succeeded = false;
    context.stateFilter.active = true;
    stateFilter.inactive = false;
    stateFilter.failed = false;
    stateFilter.succeeded = false;
    stateFilter.active = true;
    journal.GetCodexCategories(context, categories);
    i = 0;
    while i < ArraySize(categories) {
      ArrayClear(groups);
      currentCategory = categories[i] as JournalCodexCategory;
      journal.GetChildren(currentCategory, stateFilter, groups);
      currentCategoryIndex = EnumInt(CodexUtils.GetCategoryTypeFromId(currentCategory.GetId()));
      j = 0;
      while j < ArraySize(groups) {
        hasNewEntries = false;
        ArrayClear(newEntries);
        ArrayClear(entries);
        currentGroup = groups[j] as JournalCodexGroup;
        currentGroupVirtualListData = CodexUtils.GetGroupData(currentGroup, virtualDataList);
        groupEntryData = currentGroupVirtualListData.m_data as CodexEntryData;
        journal.GetChildren(currentGroup, stateFilter, entries);
        isSorted = currentGroup.GetIsSorted();
        k = 0;
        while k < ArraySize(entries) {
          currentEntry = entries[k] as JournalCodexEntry;
          entryData = CodexUtils.ConvertToCodexData(journal, currentEntry, currentCategoryIndex, stateFilter, newEntries, activeDataSync, useFallbackImages);
          if CodexUtils.IsImageValid(currentEntry.GetImageID()) || currentCategoryIndex == 4 {
            entryVirtualListData = new VirutalNestedListData();
            entryVirtualListData.m_level = currentGroupVirtualListData.m_level;
            entryVirtualListData.m_widgetType = 0u;
            entryVirtualListData.m_isHeader = false;
            entryVirtualListData.m_data = entryData;
            entryVirtualListData.m_isSortable = isSorted;
            ArrayPush(virtualDataList, entryVirtualListData);
            if entryData.m_isNew {
              hasNewEntries = true;
            };
          };
          k += 1;
        };
        groupEntryData.m_isNew = hasNewEntries;
        groupEntryData.m_category = currentCategoryIndex;
        groupEntryData.m_activeDataSync = activeDataSync;
        groupEntryData.m_counter += ArraySize(entries);
        k = 0;
        while k < ArraySize(newEntries) {
          ArrayPush(groupEntryData.m_newEntries, newEntries[k]);
          k += 1;
        };
        j += 1;
      };
      i += 1;
    };
    return virtualDataList;
  }

  public final static func GetTutorialsData(journal: ref<JournalManager>, activeDataSync: wref<CodexListSyncData>, offset: Int32) -> [ref<VirutalNestedListData>] {
    let currentEntry: wref<JournalOnscreen>;
    let entries: array<wref<JournalEntry>>;
    let entryData: ref<CodexEntryData>;
    let entryVirtualListData: ref<VirutalNestedListData>;
    let groupData: ref<CodexEntryData>;
    let groupVirtualListData: ref<VirutalNestedListData>;
    let hasNewEntries: Bool;
    let i: Int32;
    let newEntries: array<Int32>;
    let result: array<ref<VirutalNestedListData>>;
    CodexUtils.AppendTutorialEntries(journal, "onscreens/tutorials", entries);
    CodexUtils.AppendTutorialEntries(journal, "onscreens/tutorials_new", entries);
    CodexUtils.AppendTutorialEntries(journal, "onscreens/tutorial_vr", entries);
    i = 0;
    while i < ArraySize(entries) {
      currentEntry = entries[i] as JournalOnscreen;
      entryData = new CodexEntryData();
      entryData.m_title = currentEntry.GetTitle();
      entryData.m_description = currentEntry.GetDescription();
      entryData.m_imageId = currentEntry.GetIconID();
      entryData.m_hash = journal.GetEntryHash(currentEntry);
      entryData.m_timeStamp = journal.GetEntryTimestamp(currentEntry);
      entryData.m_activeDataSync = activeDataSync;
      entryData.m_isNew = !journal.IsEntryVisited(currentEntry);
      if entryData.m_isNew {
        ArrayPush(newEntries, entryData.m_hash);
        ArrayPush(entryData.m_newEntries, entryData.m_hash);
      };
      if !TDBID.IsValid(entryData.m_imageId) {
        entryData.m_imageId = t"UIJournalIcons.PlaceholderCodexImage";
      };
      entryVirtualListData = new VirutalNestedListData();
      entryVirtualListData.m_level = 4;
      entryVirtualListData.m_widgetType = 0u;
      entryVirtualListData.m_isHeader = false;
      entryVirtualListData.m_data = entryData;
      ArrayPush(result, entryVirtualListData);
      if entryData.m_isNew {
        hasNewEntries = true;
      };
      i += 1;
    };
    groupData = new CodexEntryData();
    groupData.m_title = "Tutorials";
    groupData.m_activeDataSync = activeDataSync;
    groupData.m_counter = ArraySize(entries);
    groupData.m_isNew = hasNewEntries;
    groupData.m_newEntries = newEntries;
    groupVirtualListData = new VirutalNestedListData();
    groupVirtualListData.m_level = 4;
    groupVirtualListData.m_widgetType = 1u;
    groupVirtualListData.m_isHeader = true;
    groupVirtualListData.m_data = groupData;
    ArrayPush(result, groupVirtualListData);
    return result;
  }

  private final static func AppendTutorialEntries(journal: ref<JournalManager>, const path: script_ref<String>, output: script_ref<[wref<JournalEntry>]>) -> Bool {
    let i: Int32;
    let result: array<wref<JournalEntry>>;
    let stateFilter: JournalRequestStateFilter;
    stateFilter.inactive = false;
    stateFilter.failed = false;
    stateFilter.succeeded = false;
    stateFilter.active = true;
    let group: wref<JournalOnscreenGroup> = journal.GetEntryByString(Deref(path), "gameJournalOnscreenGroup") as JournalOnscreenGroup;
    journal.GetChildren(group, stateFilter, result);
    i = 0;
    while i < ArraySize(result) {
      ArrayPush(Deref(output), result[i]);
      i += 1;
    };
    return ArraySize(result) > 0;
  }

  public final static func JournalToRepresentationArray(journal: ref<JournalManager>, const entries: script_ref<[wref<JournalEntry>]>) -> [ref<JournalRepresentationData>] {
    let codexCategoryData: array<ref<JournalRepresentationData>>;
    let codexEntry: ref<JournalRepresentationData>;
    let i: Int32 = 0;
    while i < ArraySize(Deref(entries)) {
      codexEntry = new JournalRepresentationData();
      codexEntry.Data = Deref(entries)[i];
      codexEntry.IsNew = journal.IsEntryVisited(Deref(entries)[i]);
      ArrayPush(codexCategoryData, codexEntry);
      i += 1;
    };
    return codexCategoryData;
  }

  private final static func GetLocalizedTag(tag: CName) -> String {
    let res: String;
    switch tag {
      case n"literature_fiction":
        res = GetLocalizedText("UI-Shards-LiteratureFiction");
        break;
      case n"night_city_people":
        res = GetLocalizedText("UI-Shards-NightCityPeople");
        break;
      case n"world":
        res = GetLocalizedText("UI-Shards-World");
        break;
      case n"technology":
        res = GetLocalizedText("UI-Shards-Technology");
        break;
      case n"notes":
        res = GetLocalizedText("UI-Shards-Notes");
        break;
      case n"articles":
        res = GetLocalizedText("UI-Shards-Articles");
        break;
      case n"leaflets":
        res = GetLocalizedText("UI-Shards-Leaflets");
        break;
      case n"cyberpsycho":
        res = GetLocalizedText("LocKey#31788");
        break;
      case n"religion_philosophy":
        res = GetLocalizedText("UI-Shards-ReligionPhilosophy");
        break;
      case n"poetry":
        res = GetLocalizedText("UI-Shards-Poetry");
        break;
      default:
        res = GetLocalizedText("UI-Shards-Others");
    };
    return res;
  }

  public final static func GetShardTitleString(isCrypted: Bool, const titleString: script_ref<String>) -> String {
    if isCrypted {
      return GetLocalizedText(titleString) + " (" + GetLocalizedText("LocKey#42347") + ")";
    };
    return GetLocalizedText(titleString);
  }

  public final static func GetShardTextString(isCrypted: Bool, const textString: script_ref<String>) -> String {
    let lineLenght: Uint32 = 24u;
    if isCrypted {
      return StringToHex(GetLocalizedText(textString), lineLenght);
    };
    return GetLocalizedText(textString);
  }

  public final static func GetCategoryTypeFromId(const id: script_ref<String>) -> CodexCategoryType {
    switch Deref(id) {
      case "characters":
        return CodexCategoryType.Characters;
      case "glossary":
        return CodexCategoryType.Database;
      case "locations":
        return CodexCategoryType.Locations;
      case "tutorials_new":
      case "tutorial_vr":
      case "tutorials":
        return CodexCategoryType.Tutorials;
    };
    return CodexCategoryType.Invalid;
  }

  public final static func GetCodexFilterIcon(category: CodexCategoryType) -> String {
    switch category {
      case CodexCategoryType.Database:
        return "UIIcon.Filter_Codex_Database";
      case CodexCategoryType.Characters:
        return "UIIcon.Filter_Codex_Characters";
      case CodexCategoryType.Locations:
        return "UIIcon.Filter_Codex_Locations";
      case CodexCategoryType.Tutorials:
        return "UIIcon.Filter_Codex_Tutorials";
    };
    return "UIIcon.Filter_Codex_Default";
  }
}
