
public class WardrobeControllerPS extends ScriptableDeviceComponentPS {

  protected persistent let m_clothingSets: [ref<ClothingSet>];

  @default(WardrobeControllerPS, false)
  protected let m_hasInteraction: Bool;

  protected func GameAttached() -> Void;

  protected func LogicReady() -> Void {
    super.LogicReady();
  }

  public func GetActions(out actions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    let baseTestsPassed: Bool = super.GetActions(actions, context);
    this.FirstInit();
    if !baseTestsPassed || NotEquals(context.requestType, gamedeviceRequestType.Direct) {
      return false;
    };
    if this.m_hasInteraction {
      ArrayPush(actions, this.ActionOpenWardrobeUI(context.processInitiatorObject));
    };
    this.SetActionIllegality(actions, this.m_illegalActions.regularActions);
    return true;
  }

  public final const func HasInteraction() -> Bool {
    return this.m_hasInteraction;
  }

  protected final func ActionOpenWardrobeUI(executor: ref<GameObject>) -> ref<OpenWardrobeUI> {
    let action: ref<OpenWardrobeUI> = new OpenWardrobeUI();
    action.clearanceLevel = 2;
    action.SetUp(this);
    action.SetProperties();
    action.SetExecutor(executor);
    action.AddDeviceName(this.m_deviceName);
    action.CreateInteraction();
    return action;
  }

  protected final func OnOpenWardrobeUI(evt: ref<OpenWardrobeUI>) -> EntityNotificationType {
    let userData: ref<WardrobeUserData>;
    let menuEvent: ref<inkMenuInstance_SpawnEvent> = new inkMenuInstance_SpawnEvent();
    let uiSystem: ref<UISystem> = GameInstance.GetUISystem(this.GetGameInstance());
    if IsDefined(uiSystem) {
      userData = new WardrobeUserData();
      menuEvent.Init(n"OnOpenWardrobeMenu", userData);
      uiSystem.QueueEvent(menuEvent);
    };
    this.UseNotifier(evt);
    return EntityNotificationType.DoNotNotifyEntity;
  }

  protected final func FirstInit() -> Void {
    let factVal: Int32 = GetFact(this.GetGameInstance(), n"WardrobeInitFromStash");
    if factVal <= 0 && true {
      this.InitializeWardrobeFromStash();
      SetFactValue(this.GetGameInstance(), n"WardrobeInitFromStash", 1);
    };
  }

  protected final func InitializeWardrobeFromStash() -> Void {
    let i: Int32;
    let storageItems: array<ref<gameItemData>>;
    let wardrobeSystem: ref<WardrobeSystem> = GameInstance.GetWardrobeSystem(this.GetGameInstance());
    let dataManager: ref<VendorDataManager> = new VendorDataManager();
    dataManager.Initialize(GetPlayer(this.GetGameInstance()), PersistentID.ExtractEntityID(this.GetID()));
    storageItems = dataManager.GetStorageItems();
    i = 0;
    while i < ArraySize(storageItems) {
      if RPGManager.IsItemClothing(storageItems[i].GetID()) {
        wardrobeSystem.StoreUniqueItemIDAndMarkNew(this.GetGameInstance(), storageItems[i].GetID());
      };
      i += 1;
    };
  }
}

public class OpenWardrobeUI extends ActionBool {

  public final func SetProperties() -> Void {
    this.actionName = n"OpenWardrobeUI";
    this.prop = DeviceActionPropertyFunctions.SetUpProperty_Bool(this.actionName, true, n"LocKey#79193", n"LocKey#79193");
  }

  public func GetTweakDBChoiceRecord() -> String {
    return "OpenWardrobeUI";
  }
}

public class DisableVisualOverride extends Event {

  @default(DisableVisualOverride, true)
  public edit let blockReequipping: Bool;

  public final func GetFriendlyDescription() -> String {
    return "Unequip Wardrobe Set";
  }
}

public class RestoreVisualOverride extends Event {

  public final func GetFriendlyDescription() -> String {
    return "Reequip Last Wardrobe Set";
  }
}

public class EnableVisualOverride extends Event {

  public final func GetFriendlyDescription() -> String {
    return "Enable Equipping Wardrobe Set";
  }
}

public class HideVisualSlot extends Event {

  public edit let slot: TransmogSlots;

  public final func GetFriendlyDescription() -> String {
    return "Hide Item In Slot";
  }
}

public class RestoreVisualSlot extends Event {

  public edit let slot: TransmogSlots;

  public final func GetFriendlyDescription() -> String {
    return "Restore Item In Slot";
  }
}
