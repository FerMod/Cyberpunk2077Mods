
public class PhoneDialerLogicController extends inkLogicController {

  public edit let m_tabsContainer: inkWidgetRef;

  public edit let m_titleContainer: inkWidgetRef;

  public edit let m_titleTextWidget: inkTextRef;

  public edit let m_acceptButtonLabel: inkTextRef;

  public edit let m_action2ButtonLabel: inkTextRef;

  public edit let m_inputHintsPanel: inkWidgetRef;

  public edit let m_threadPanel: inkWidgetRef;

  public edit let m_threadList: inkWidgetRef;

  public edit let m_callsQuestFlag: inkWidgetRef;

  public edit let m_arrow: inkWidgetRef;

  public edit let m_threadTab: inkWidgetRef;

  public edit let m_unreadTab: inkWidgetRef;

  public edit let m_threadTabLabel: inkTextRef;

  public edit let m_contactsList: inkWidgetRef;

  public edit let m_avatarImage: inkImageRef;

  public edit let m_contactAvatarsFluff: inkWidgetRef;

  public edit let m_scrollArea: inkScrollAreaRef;

  public edit let m_scrollControllerWidget: inkWidgetRef;

  public edit let m_acceptButtonWidget: inkWidgetRef;

  public edit let m_action2ButtonWidget: inkWidgetRef;

  public edit let m_showAllButtonWidget: inkWidgetRef;

  public edit let m_showAllLabel: inkTextRef;

  public edit let m_nothingToReadMessageWidget: inkWidgetRef;

  public edit let m_scrollBarWidget: inkWidgetRef;

  public let m_listController: wref<inkVirtualListController>;

  public let m_dataSource: ref<ScriptableDataSource>;

  public let m_dataView: ref<DialerContactDataView>;

  public let m_templateClassifier: ref<DialerContactTemplateClassifier>;

  public let m_scrollController: wref<inkScrollController>;

  public let m_switchAnimProxy: ref<inkAnimProxy>;

  public let m_transitionAnimProxy: ref<inkAnimProxy>;

  public let m_horizontalMoveAnimProxy: ref<inkAnimProxy>;

  public let m_threadsController: wref<inkVirtualListController>;

  public let m_dataSourceCache: ref<ScriptableDataSource>;

  public let m_dataViewCache: ref<DialerContactDataView>;

  public let m_moveBehindAnimProxy: ref<inkAnimProxy>;

  public let m_hideContactAnimProxy: ref<inkAnimProxy>;

  @default(PhoneDialerLogicController, 0)
  public let m_contactIndexCache: Uint32;

  public let m_menuSelectorCtrl: wref<PhoneDialerSelectionController>;

  public let m_firstInit: Bool;

  @default(PhoneDialerLogicController, 0)
  public let m_indexToSelect: Uint32;

  public let m_hidingIndex: Uint32;

  public let m_pulseAnim: ref<PulseAnimation>;

  public let m_leftMargin: inkMargin;

  public let m_rightMargin: inkMargin;

  public let m_currentTab: PhoneDialerTabs;

  public let m_callingEnabled: Bool;

  protected cb func OnInitialize() -> Bool {
    this.GetRootWidget().SetVisible(false);
    this.InitVirtualList();
    inkWidgetRef.RegisterToCallback(this.m_scrollArea, n"OnScrollChanged", this, n"OnScrollChanged");
    this.m_scrollController = inkWidgetRef.GetControllerByType(this.m_scrollControllerWidget, n"inkScrollController") as inkScrollController;
    this.m_menuSelectorCtrl = inkWidgetRef.GetController(this.m_tabsContainer) as PhoneDialerSelectionController;
    this.m_leftMargin = new inkMargin(35.00, 10.00, 0.00, 0.00);
    this.m_rightMargin = new inkMargin(1400.00, 10.00, 0.00, 0.00);
    this.m_pulseAnim = new PulseAnimation();
    this.m_pulseAnim.Configure(inkWidgetRef.Get(this.m_callsQuestFlag), 1.00, 0.20, 0.60);
  }

  protected cb func OnUninitialize() -> Bool {
    this.CleanVirtualList();
    this.CloseContactList();
  }

  protected cb func OnScrollChanged(value: Vector2) -> Bool {
    this.m_scrollController.UpdateScrollPositionFromScrollArea();
  }

  public final func ShowInputHints(show: Bool) -> Void {
    inkWidgetRef.SetVisible(this.m_inputHintsPanel, show);
  }

  public final func ShowCallsQuestIndicator(visible: Bool) -> Void {
    inkWidgetRef.SetVisible(this.m_callsQuestFlag, visible);
  }

  public final func SetCallingEnabled(enabled: Bool) -> Void {
    this.m_callingEnabled = enabled;
  }

  public final func SwtichTabs(tab: PhoneDialerTabs) -> Void {
    this.m_currentTab = tab;
    inkWidgetRef.SetVisible(this.m_acceptButtonWidget, false);
    inkWidgetRef.SetVisible(this.m_action2ButtonWidget, false);
    inkWidgetRef.SetVisible(this.m_showAllButtonWidget, false);
    switch tab {
      case PhoneDialerTabs.Unread:
        this.m_menuSelectorCtrl.ScrollTo(0);
        inkWidgetRef.SetVisible(this.m_nothingToReadMessageWidget, this.IsEmpty());
        break;
      case PhoneDialerTabs.Contacts:
        this.m_menuSelectorCtrl.ScrollTo(1);
        inkWidgetRef.SetVisible(this.m_nothingToReadMessageWidget, false);
    };
  }

  public final func IsEmpty() -> Bool {
    return this.m_dataSource.Size() == Cast<Uint32>(Equals(this.m_currentTab, PhoneDialerTabs.Unread) ? 1 : 0);
  }

  public final func InitVirtualList() -> Void {
    this.m_templateClassifier = new DialerContactTemplateClassifier();
    this.m_dataView = new DialerContactDataView();
    this.m_dataSource = new ScriptableDataSource();
    this.m_dataView.Setup();
    this.m_dataView.SetSource(this.m_dataSource);
    this.m_listController = inkWidgetRef.GetControllerByType(this.m_contactsList, n"inkVirtualListController") as inkVirtualListController;
    this.m_listController.SetClassifier(this.m_templateClassifier);
    this.m_listController.SetSource(this.m_dataView);
    this.m_listController.RegisterToCallback(n"OnItemSelected", this, n"OnItemSelected");
    this.m_listController.RegisterToCallback(n"OnAllElementsSpawned", this, n"OnAllElementsSpawned");
    this.m_dataViewCache = new DialerContactDataView();
    this.m_dataSourceCache = new ScriptableDataSource();
    this.m_dataViewCache.Setup();
    this.m_dataViewCache.SetSource(this.m_dataSourceCache);
    this.m_threadsController = inkWidgetRef.GetControllerByType(this.m_threadList, n"inkVirtualListController") as inkVirtualListController;
    this.m_threadsController.SetClassifier(this.m_templateClassifier);
    this.m_threadsController.SetSource(this.m_dataViewCache);
  }

  public final func SetSortMethod(sortMethod: ContactsSortMethod) -> Void {
    this.m_dataView.m_sortMethod = sortMethod;
  }

  public final func HideTab(tab: PhoneDialerTabs) -> Void {
    this.m_menuSelectorCtrl.HideTab(EnumInt(tab));
  }

  public final func ShowTitle(visible: Bool) -> Void {
    inkWidgetRef.SetVisible(this.m_arrow, visible);
    inkWidgetRef.SetVisible(this.m_threadTab, visible);
    inkWidgetRef.SetVisible(this.m_unreadTab, !visible);
  }

  public final func SetTitle(title: String) -> Void {
    inkTextRef.SetText(this.m_threadTabLabel, title);
  }

  public final func UpdateShowAllButton(showAll: Bool) -> Void {
    if showAll {
      inkTextRef.SetLocalizedTextScript(this.m_showAllLabel, "LocKey#93929");
    } else {
      inkTextRef.SetLocalizedTextScript(this.m_showAllLabel, "LocKey#93930");
    };
  }

  public final func CleanVirtualList() -> Void {
    this.m_listController.SetSource(null);
    this.m_listController.SetClassifier(null);
    this.m_dataView.SetSource(null);
    this.m_threadsController.SetSource(null);
    this.m_threadsController.SetClassifier(null);
    this.m_dataViewCache.SetSource(null);
    this.m_dataViewCache = null;
    this.m_dataSourceCache = null;
    this.m_dataView = null;
    this.m_dataSource = null;
    this.m_templateClassifier = null;
  }

  protected cb func OnItemSelected(previous: ref<inkVirtualCompoundItemController>, next: ref<inkVirtualCompoundItemController>) -> Bool {
    let selectionChangeEvent: ref<ContactSelectionChangedEvent>;
    let contactData: ref<ContactData> = FromVariant<ref<IScriptable>>(next.GetData()) as ContactData;
    InkImageUtils.RequestAvatarOrUnknown(this, this.m_avatarImage, contactData.avatarID);
    if IsDefined(this.m_switchAnimProxy) {
      this.m_switchAnimProxy.Stop();
      this.m_switchAnimProxy = null;
    };
    this.m_switchAnimProxy = this.PlayLibraryAnimation(n"switchContact");
    this.RefreshInputHints(contactData);
    this.RefreshCallingEnabled(next);
    selectionChangeEvent = new ContactSelectionChangedEvent();
    selectionChangeEvent.ContactData = contactData;
    this.QueueEvent(selectionChangeEvent);
  }

  private final func RefreshCallingEnabled(item: ref<inkVirtualCompoundItemController>) -> Void {
    (item as PhoneContactItemVirtualController).SetCallingEnabled(this.m_callingEnabled);
  }

  private final func RefreshInputHints(contactData: wref<ContactData>) -> Void {
    if Equals(this.m_currentTab, PhoneDialerTabs.Unread) {
      inkWidgetRef.SetVisible(this.m_acceptButtonWidget, false);
      inkWidgetRef.SetVisible(this.m_action2ButtonWidget, false);
      inkWidgetRef.SetVisible(this.m_showAllButtonWidget, true);
      inkTextRef.SetLocalizedTextScript(this.m_acceptButtonLabel, "LocKey#92248");
    } else {
      inkWidgetRef.SetVisible(this.m_acceptButtonWidget, contactData.isCallable);
      inkWidgetRef.SetVisible(this.m_action2ButtonWidget, Equals(contactData.type, MessengerContactType.Contact) ? contactData.hasMessages : true);
      inkWidgetRef.SetVisible(this.m_showAllButtonWidget, false);
      inkTextRef.SetLocalizedTextScript(this.m_acceptButtonLabel, "LocKey#22196");
      inkTextRef.SetLocalizedTextScript(this.m_action2ButtonLabel, "LocKey#92247");
      inkWidgetRef.SetVisible(this.m_acceptButtonWidget, false);
      inkWidgetRef.SetVisible(this.m_action2ButtonWidget, false);
      inkWidgetRef.SetVisible(this.m_showAllButtonWidget, false);
    };
  }

  public final func Show() -> Void {
    this.GetRootWidget().SetVisible(true);
    this.m_pulseAnim.Start();
    if IsDefined(this.m_transitionAnimProxy) {
      this.m_transitionAnimProxy.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnHideAnimFinished");
      this.m_transitionAnimProxy.Stop();
      this.m_transitionAnimProxy = null;
    };
    this.m_transitionAnimProxy = this.PlayLibraryAnimation(n"fadeIn");
  }

  public final func Hide() -> Void {
    this.GetRootWidget().SetVisible(false);
    this.m_pulseAnim.Stop();
  }

  protected cb func OnHideAnimFinished(proxy: ref<inkAnimProxy>) -> Bool {
    this.GetRootWidget().SetVisible(false);
  }

  protected cb func OnAllElementsSpawned() -> Bool {
    if this.m_firstInit {
      this.m_firstInit = false;
      this.m_listController.SelectItem(this.m_indexToSelect);
      this.m_indexToSelect = 0u;
    };
  }

  public final func PopulateListData(const contactDataArray: script_ref<[ref<IScriptable>]>, opt selectIndex: Uint32, opt itemHash: Int32) -> Void {
    this.m_dataView.EnableSorting();
    this.m_dataSource.Reset(Deref(contactDataArray));
    this.m_dataView.DisableSorting();
    this.m_firstInit = true;
    this.m_indexToSelect = itemHash != 0 ? ContactDataHelper.IndexOfOrZero(this.m_dataView, itemHash) : selectIndex;
  }

  public final func PushList(const contactDataArray: script_ref<[ref<IScriptable>]>, sortMethod: ContactsSortMethod) -> Void {
    this.m_contactIndexCache = this.m_listController.GetSelectedIndex();
    this.m_dataViewCache.m_sortMethod = this.m_dataView.m_sortMethod;
    this.m_dataViewCache.EnableSorting();
    this.m_dataSourceCache.Reset(this.m_dataSource.GetArray());
    this.m_dataViewCache.DisableSorting();
    this.m_dataView.m_sortMethod = sortMethod;
    this.PopulateListData(contactDataArray, 0u);
    inkWidgetRef.SetVisible(this.m_contactsList, false);
    inkWidgetRef.SetVisible(this.m_threadPanel, true);
    if IsDefined(this.m_moveBehindAnimProxy) {
      this.m_moveBehindAnimProxy.UnregisterFromAllCallbacks(inkanimEventType.OnFinish);
      this.m_moveBehindAnimProxy.Stop();
      this.m_moveBehindAnimProxy = null;
    };
    this.m_moveBehindAnimProxy = this.PlayLibraryAnimation(n"moveBehind");
    this.m_moveBehindAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnMoveBehindAnimFinished");
  }

  protected cb func OnMoveBehindAnimFinished(proxy: ref<inkAnimProxy>) -> Bool {
    inkWidgetRef.SetVisible(this.m_contactsList, true);
    this.m_moveBehindAnimProxy = null;
  }

  public final func PopList() -> Void {
    let options: inkAnimOptions;
    inkWidgetRef.SetVisible(this.m_contactsList, false);
    this.m_dataView.m_sortMethod = this.m_dataViewCache.m_sortMethod;
    this.PopulateListData(this.m_dataSourceCache.GetArray(), this.m_contactIndexCache);
    this.m_contactIndexCache = 0u;
    if IsDefined(this.m_moveBehindAnimProxy) {
      this.m_moveBehindAnimProxy.UnregisterFromAllCallbacks(inkanimEventType.OnFinish);
      this.m_moveBehindAnimProxy.Stop();
      this.m_moveBehindAnimProxy = null;
    };
    options.playReversed = true;
    this.m_moveBehindAnimProxy = this.PlayLibraryAnimation(n"moveBehind", options);
    this.m_moveBehindAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnMoveBehindReversedAnimFinished");
  }

  protected cb func OnMoveBehindReversedAnimFinished(proxy: ref<inkAnimProxy>) -> Bool {
    this.m_dataSourceCache.Clear();
    inkWidgetRef.SetVisible(this.m_contactsList, true);
    inkWidgetRef.SetVisible(this.m_threadPanel, false);
    this.m_moveBehindAnimProxy = null;
  }

  public final func GetSelectedContactData() -> wref<ContactData> {
    let item: ref<PhoneContactItemVirtualController> = this.m_listController.GetSelectedItem() as PhoneContactItemVirtualController;
    return item.GetContactData();
  }

  public final func GetSelectedContactHash() -> Int32 {
    let contact: wref<ContactData> = this.GetSelectedContactData();
    return ContactDataHelper.FetchContactHash(contact);
  }

  public final func GetContactWithUnreadHash() -> Int32 {
    let selectedContact: ref<ContactData>;
    let selectedIndex: Int32 = Cast<Int32>(this.GetSelectedContactIndex());
    if selectedIndex == -1 {
      return 0;
    };
    selectedContact = this.m_dataView.GetItem(Cast<Uint32>(selectedIndex)) as ContactData;
    if ArraySize(selectedContact.unreadMessages) > 0 || Equals(selectedContact.type, MessengerContactType.Fake_ShowAll) || selectedContact.hasQuestImportantReply || selectedContact.playerCanReply {
      return ContactDataHelper.FetchContactHash(selectedContact);
    };
    selectedContact = ContactDataHelper.FindClosestContactWithUnread(this.m_dataView, selectedIndex);
    return ContactDataHelper.FetchContactHash(selectedContact);
  }

  public final func GetSelectedContactIndex() -> Uint32 {
    return this.m_listController.GetSelectedIndex();
  }

  public final func HideSelectedItem() -> Void {
    (this.m_listController.GetSelectedItem() as PhoneContactItemVirtualController).Hide();
  }

  public final func OpenSelectedItem() -> Void {
    (this.m_listController.GetSelectedItem() as PhoneContactItemVirtualController).OpenInChat();
  }

  public final func RefreshSelectedContact() -> Void {
    (this.m_listController.GetSelectedItem() as PhoneContactItemVirtualController).Refresh(true);
  }

  protected cb func OnItemHidden(evt: ref<PhoneContactHiddenEvent>) -> Bool {
    this.GetRootWidget().CallCustomCallback(n"OnContactHidden");
    evt.HiddenItem.GetRootWidget().SetVisible(true);
  }

  protected cb func OnGotFocus(evt: ref<FocusSmsMessagerEvent>) -> Bool {
    this.PlayLibraryAnimation(n"unfocus_left");
  }

  protected cb func OnLostFocus(evt: ref<UnfocusSmsMessagerEvent>) -> Bool {
    let playbackOptions: inkAnimOptions;
    playbackOptions.playReversed = true;
    this.PlayLibraryAnimation(n"unfocus_left", playbackOptions);
  }

  public final func GotoMessengerMenu() -> Void {
    let evt: ref<StartHubMenuEvent>;
    let userData: ref<MessageMenuAttachmentData>;
    let item: ref<PhoneContactItemVirtualController> = this.m_listController.GetSelectedItem() as PhoneContactItemVirtualController;
    let contactData: ref<ContactData> = item.GetContactData();
    if contactData.playerCanReply || contactData.hasMessages {
      userData = new MessageMenuAttachmentData();
      userData.m_entryHash = contactData.hash;
      evt = new StartHubMenuEvent();
      evt.SetStartMenu(n"phone", userData);
      this.QueueBroadcastEvent(evt);
    };
    this.CloseContactList();
  }

  public final func NavigateDown() -> Void {
    this.m_listController.Navigate(inkDiscreteNavigationDirection.Down);
    this.PlaySound(n"Holocall", n"Navigation");
  }

  public final func NavigateUp() -> Void {
    this.m_listController.Navigate(inkDiscreteNavigationDirection.Up);
    this.PlaySound(n"Holocall", n"Navigation");
  }

  public final func MoveContactPictures(moveToRight: Bool) -> Void {
    let horizantalMove: ref<inkAnimDef> = new inkAnimDef();
    let marginInterpolator: ref<inkAnimMargin> = new inkAnimMargin();
    marginInterpolator.SetDuration(0.50);
    if moveToRight {
      marginInterpolator.SetStartMargin(this.m_leftMargin);
      marginInterpolator.SetEndMargin(this.m_rightMargin);
    } else {
      marginInterpolator.SetStartMargin(this.m_rightMargin);
      marginInterpolator.SetEndMargin(this.m_leftMargin);
    };
    marginInterpolator.SetType(inkanimInterpolationType.Quintic);
    marginInterpolator.SetMode(inkanimInterpolationMode.EasyInOut);
    horizantalMove.AddInterpolator(marginInterpolator);
    this.m_horizontalMoveAnimProxy = inkWidgetRef.PlayAnimation(this.m_contactAvatarsFluff, horizantalMove);
  }

  public final func CloseContactList() -> Void {
    this.GetRootWidget().CallCustomCallback(n"OnCloseContactList");
  }
}
