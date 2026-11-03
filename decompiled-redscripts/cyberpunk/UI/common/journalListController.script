
public class JournalEntryListItemController extends ListItemController {

  protected cb func OnDataChanged(value: ref<IScriptable>) -> Bool {
    let data: ref<JournalEntryListItemData> = value as JournalEntryListItemData;
    if IsDefined(data) {
      this.OnJournalEntryUpdated(data.m_entry, data.m_extraData);
    };
  }

  protected func OnJournalEntryUpdated(entry: wref<JournalEntry>, extraData: ref<IScriptable>) -> Void;
}

public class JournalEntriesListController extends ListController {

  public final func PushEntries(const data: script_ref<[wref<JournalEntry>]>) -> Void {
    let scriptableList: array<ref<IScriptable>>;
    let scriptableObj: ref<JournalEntryListItemData>;
    let count: Int32 = ArraySize(Deref(data));
    let i: Int32 = 0;
    while i < count {
      scriptableObj = new JournalEntryListItemData();
      scriptableObj.m_entry = Deref(data)[i];
      ArrayPush(scriptableList, scriptableObj);
      i += 1;
    };
    this.PushDataList(scriptableList, true);
  }

  public final func PushEntriesEx(const data: script_ref<[wref<JournalEntry>]>, const extraData: script_ref<[ref<IScriptable>]>) -> Void {
    let scriptableList: array<ref<IScriptable>>;
    let scriptableObj: ref<JournalEntryListItemData>;
    let count: Int32 = ArraySize(Deref(data));
    let i: Int32 = 0;
    while i < count {
      scriptableObj = new JournalEntryListItemData();
      scriptableObj.m_entry = Deref(data)[i];
      scriptableObj.m_extraData = Deref(extraData)[i];
      ArrayPush(scriptableList, scriptableObj);
      i += 1;
    };
    this.PushDataList(scriptableList, true);
  }
}
