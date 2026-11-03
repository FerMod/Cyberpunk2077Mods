
public class SimpleMessengerContactDataView extends ScriptableDataView {

  private let m_compareBuilder: ref<CompareBuilder>;

  public final func Setup() -> Void {
    this.m_compareBuilder = CompareBuilder.Make();
  }

  public func SortItem(left: ref<IScriptable>, right: ref<IScriptable>) -> Bool {
    let leftData: ref<ContactData> = left as ContactData;
    let rightData: ref<ContactData> = right as ContactData;
    this.m_compareBuilder.Reset();
    return this.m_compareBuilder.BoolTrue(leftData.questRelated, rightData.questRelated).BoolTrue(ArraySize(leftData.unreadMessages) > 0, ArraySize(rightData.unreadMessages) > 0).GameTimeDesc(leftData.timeStamp, rightData.timeStamp).GetBool();
  }
}

public class SimpleMessengerContactsVirtualListController extends inkVirtualListController {

  private let m_dataView: ref<SimpleMessengerContactDataView>;

  protected let m_dataSource: ref<ScriptableDataSource>;

  protected let m_classifier: ref<QuestListVirtualTemplateClassifier>;

  protected cb func OnInitialize() -> Bool {
    this.m_dataView = new SimpleMessengerContactDataView();
    this.m_dataSource = new ScriptableDataSource();
    this.m_classifier = new QuestListVirtualTemplateClassifier();
    this.m_dataView.Setup();
    this.m_dataView.SetSource(this.m_dataSource);
    this.SetSource(this.m_dataView);
    this.SetClassifier(this.m_classifier);
  }

  protected cb func OnUninitialize() -> Bool {
    this.m_dataView.SetSource(null);
    this.SetSource(null);
    this.SetClassifier(null);
    this.m_dataSource = null;
  }

  public final func GetDataView() -> ref<ScriptableDataView> {
    let view: ref<SimpleMessengerContactDataView> = new SimpleMessengerContactDataView();
    this.m_dataView = view;
    return view;
  }

  public final func GetIndexByJournalHash(hash: Int32) -> Int32 {
    let currentContactData: wref<ContactData>;
    let dataSize: Int32;
    let i: Int32;
    if this.m_dataView == null {
      return -1;
    };
    dataSize = Cast<Int32>(this.m_dataView.Size());
    i = 0;
    while i < dataSize {
      currentContactData = this.m_dataView.GetItem(Cast<Uint32>(i)) as ContactData;
      if currentContactData.hash == hash {
        return i;
      };
      i = i + 1;
    };
    return -1;
  }

  public func EnableSorting() -> Void {
    this.m_dataView.EnableSorting();
  }

  public func DisableSorting() -> Void {
    this.m_dataView.DisableSorting();
  }

  public func SetData(const data: script_ref<[ref<IScriptable>]>, opt sortOnce: Bool) -> Void {
    this.m_dataSource.Reset(Deref(data));
    this.EnableSorting();
    if sortOnce {
      this.DisableSorting();
    };
  }

  public func GetDataSize() -> Int32 {
    return Cast<Int32>(this.m_dataView.Size());
  }
}

public class MessengerGameController extends gameuiMenuGameController {

  private edit let m_buttonHintsManagerRef: inkWidgetRef;

  private edit let m_contactsRef: inkWidgetRef;

  private edit let m_dialogRef: inkWidgetRef;

  private let m_buttonHintsController: wref<ButtonHints>;

  private let m_dialogController: wref<MessengerDialogViewController>;

  private let m_listController: wref<SimpleMessengerContactsVirtualListController>;

  private let m_journalManager: wref<JournalManager>;

  private let m_menuEventDispatcher: wref<inkMenuEventDispatcher>;

  private let m_activeData: ref<MessengerContactSyncData>;

  protected cb func OnInitialize() -> Bool {
    let hintsWidget: wref<inkWidget> = this.SpawnFromExternal(inkWidgetRef.Get(this.m_buttonHintsManagerRef), r"base\\gameplay\\gui\\common\\buttonhints.inkwidget", n"Root");
    this.m_buttonHintsController = hintsWidget.GetController() as ButtonHints;
    this.m_buttonHintsController.AddButtonHint(n"back", GetLocalizedText("Common-Access-Close"));
    this.m_dialogController = inkWidgetRef.GetController(this.m_dialogRef) as MessengerDialogViewController;
    this.m_listController = inkWidgetRef.GetController(this.m_contactsRef) as SimpleMessengerContactsVirtualListController;
    this.m_activeData = new MessengerContactSyncData();
    this.PlayLibraryAnimation(n"contacts_intro");
  }

  protected cb func OnUninitialize() -> Bool {
    this.m_menuEventDispatcher.UnregisterFromEvent(n"OnBack", this, n"OnBack");
  }

  protected cb func OnPlayerAttach(playerPuppet: ref<GameObject>) -> Bool {
    this.m_journalManager = GameInstance.GetJournalManager(this.GetPlayerControlledObject().GetGame());
    this.m_dialogController.AttachJournalManager(this.m_journalManager);
    this.m_dialogController.InitDelaySystem(this.GetPlayerControlledObject());
    this.PopulateData();
    this.m_journalManager.RegisterScriptCallback(this, n"OnJournalUpdate", gameJournalListenerType.Visited);
  }

  protected cb func OnPlayerDetach(playerPuppet: ref<GameObject>) -> Bool {
    this.m_dialogController.DetachJournalManager();
    this.m_journalManager.UnregisterScriptCallback(this, n"OnJournalUpdate");
  }

  protected cb func OnSetMenuEventDispatcher(menuEventDispatcher: wref<inkMenuEventDispatcher>) -> Bool {
    this.m_menuEventDispatcher = menuEventDispatcher;
    this.m_menuEventDispatcher.RegisterToEvent(n"OnBack", this, n"OnBack");
  }

  protected cb func OnJournalUpdate(entryHash: Uint32, className: CName, notifyOption: JournalNotifyOption, changeType: JournalChangeType) -> Bool {
    let cashSelectedIdx: Uint32;
    let selectedEvent: ref<MessengerThreadSelectedEvent>;
    if Equals(className, n"gameJournalPhoneMessage") || Equals(className, n"gameJournalPhoneChoiceGroup") || Equals(className, n"gameJournalPhoneChoiceEntry") {
      cashSelectedIdx = this.m_listController.GetToggledIndex();
      this.m_listController.SelectItem(cashSelectedIdx);
      this.m_listController.ToggleItem(cashSelectedIdx);
      this.ForceSelectIndex(cashSelectedIdx);
      selectedEvent = new MessengerThreadSelectedEvent();
      selectedEvent.m_hash = entryHash;
      this.QueueEvent(selectedEvent);
    };
  }

  protected cb func OnBack(userData: ref<IScriptable>) -> Bool {
    if !StatusEffectSystem.ObjectHasStatusEffectWithTag(this.GetPlayerControlledObject(), n"LockInHubMenu") {
      this.m_menuEventDispatcher.SpawnEvent(n"OnCloseHubMenu");
    };
  }

  protected cb func OnMessengerGameControllerDelayInit(evt: ref<MessengerForceSelectionEvent>) -> Bool {
    let contactEntry: wref<JournalContact>;
    let entry: wref<JournalEntry>;
    let locatedIndex: Int32;
    let threadEntry: wref<JournalPhoneConversation>;
    let contactHash: Int32 = -1;
    let newIndex: Uint32 = 0u;
    if evt.m_selectionIndex != -1 {
      newIndex = Cast<Uint32>(evt.m_selectionIndex);
    } else {
      entry = this.m_journalManager.GetEntry(Cast<Uint32>(evt.m_hash));
      threadEntry = entry as JournalPhoneConversation;
      if threadEntry != null {
        contactEntry = this.m_journalManager.GetParentEntry(threadEntry) as JournalContact;
        contactHash = this.m_journalManager.GetEntryHash(contactEntry);
      };
      locatedIndex = this.m_listController.GetIndexByJournalHash(evt.m_hash);
      if locatedIndex == -1 && contactHash != -1 {
        locatedIndex = this.m_listController.GetIndexByJournalHash(contactHash);
      };
      if locatedIndex != -1 {
        newIndex = Cast<Uint32>(locatedIndex);
      };
    };
    this.m_listController.SelectItem(newIndex);
    if evt.m_toggle {
      this.m_listController.ToggleItem(newIndex);
    };
  }

  protected cb func OnSetUserData(userData: ref<IScriptable>) -> Bool {
    let linkData: ref<MessageMenuAttachmentData> = userData as MessageMenuAttachmentData;
    if IsDefined(linkData) {
      this.ForceSelectEntry(linkData.m_entryHash);
    } else {
      this.ForceSelectIndex(0u, true);
    };
  }

  private final func ForceSelectIndex(idx: Uint32, opt dontToggle: Bool) -> Void {
    let initEvent: ref<MessengerForceSelectionEvent> = new MessengerForceSelectionEvent();
    initEvent.m_selectionIndex = Cast<Int32>(idx);
    initEvent.m_toggle = !dontToggle;
    this.QueueEvent(initEvent);
  }

  private final func ForceSelectEntry(hash: Int32, opt dontToggle: Bool) -> Void {
    let initEvent: ref<MessengerForceSelectionEvent> = new MessengerForceSelectionEvent();
    initEvent.m_selectionIndex = -1;
    initEvent.m_hash = hash;
    initEvent.m_toggle = !dontToggle;
    this.QueueEvent(initEvent);
  }

  private final func PopulateData() -> Void {
    let data: array<ref<IScriptable>> = MessengerUtils.GetSimpleContactDataArray(this.m_journalManager, true, true, true, this.m_activeData);
    this.m_listController.SetData(data, true);
  }

  protected cb func OnContactActivated(evt: ref<MessengerContactSelectedEvent>) -> Bool {
    switch evt.m_type {
      case MessengerContactType.SingleThread:
        this.SyncActiveData(evt);
        this.m_dialogController.ShowDialog(this.m_journalManager.GetEntry(Cast<Uint32>(evt.m_entryHash)));
        break;
      case MessengerContactType.MultiThread:
        this.SyncActiveData(evt);
        this.m_dialogController.ShowThread(this.m_journalManager.GetEntry(Cast<Uint32>(evt.m_entryHash)));
        break;
      default:
    };
  }

  private final func SyncActiveData(evt: ref<MessengerContactSelectedEvent>) -> Void {
    this.m_activeData.m_type = evt.m_type;
    this.m_activeData.m_entryHash = evt.m_entryHash;
    this.m_activeData.m_level = evt.m_level;
    let syncEvent: ref<MessengerContactSyncBackEvent> = new MessengerContactSyncBackEvent();
    this.QueueEvent(syncEvent);
  }
}
