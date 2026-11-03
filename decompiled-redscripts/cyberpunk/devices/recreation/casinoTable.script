
public class CasinoChipsInventoryCallback extends InventoryScriptCallback {

  public let m_casinoTableGameController: wref<CasinoTableGameController>;

  public let m_slot: CasinoTableSlot;

  public func OnItemQuantityChanged(item: ItemID, diff: Int32, total: Uint32, flaggedAsSilent: Bool) -> Void {
    this.m_casinoTableGameController.SetItemQuantity(this.m_slot, item, total);
  }
}

public class CasinoTableGameController extends inkGameController {

  @runtimeProperty("customEditor", "TweakDBGroupInheritance;Items.money;Items.QuestItem")
  @default(CasinoTableGameController, Items.q303_casino_chip)
  public edit let m_casinoChipTDBID: TweakDBID;

  @default(CasinoTableGameController, 1000)
  public edit let m_multiplier: Uint32;

  public edit let m_slots: [CasinoTableSlotData; 5];

  public let m_casinoChipID: ItemID;

  public let m_player: wref<GameObject>;

  public let m_transactionSystem: ref<TransactionSystem>;

  public final func SetItemQuantity(slot: CasinoTableSlot, item: ItemID, total: Uint32) -> Void {
    if ItemID.IsOfTDBID(item, this.m_casinoChipTDBID) {
      this.m_slots[EnumInt(slot)].m_controller.UpdateChipsAmount(total * this.m_multiplier);
    };
  }

  protected cb func OnInitialize() -> Bool {
    let controller: wref<CasinoTableSlotLogicController>;
    let count: Int32;
    let i: Int32;
    let playbackOptions: inkAnimOptions;
    this.m_casinoChipID = ItemID.FromTDBID(this.m_casinoChipTDBID);
    this.m_player = this.GetPlayerControlledObject();
    this.m_transactionSystem = GameInstance.GetTransactionSystem(this.m_player.GetGame());
    playbackOptions.loopType = inkanimLoopType.Cycle;
    playbackOptions.loopInfinite = true;
    this.PlayLibraryAnimation(n"do_not_delete", playbackOptions);
    count = ArraySize(this.m_slots);
    i = 0;
    while i < count {
      controller = inkWidgetRef.GetController(this.m_slots[i].m_widget) as CasinoTableSlotLogicController;
      controller.InitState();
      this.m_slots[i].m_controller = controller;
      i = i + 1;
    };
  }

  protected cb func OnUninitialize() -> Bool {
    let count: Int32 = ArraySize(this.m_slots);
    let i: Int32 = 0;
    while i < count {
      this.UnregisterInventoryListener(this.m_slots[i]);
      i = i + 1;
    };
  }

  protected cb func OnChangeCasinoTableState(evt: ref<ChangeCasinoTableStateEvent>) -> Bool {
    this.ChangeCasinoTableState(this.m_slots[EnumInt(evt.m_slot)], evt);
  }

  public final func ChangeCasinoTableState(slotData: script_ref<CasinoTableSlotData>, evt: ref<ChangeCasinoTableStateEvent>) -> Void {
    let casinoChipsCallback: ref<CasinoChipsInventoryCallback>;
    let slotUser: wref<GameObject>;
    if GetGameObjectFromEntityReference(evt.m_slotUser, this.m_player.GetGame(), slotUser) {
      if Deref(slotData).m_slotUser != slotUser {
        this.UnregisterInventoryListener(slotData);
        casinoChipsCallback = new CasinoChipsInventoryCallback();
        casinoChipsCallback.m_casinoTableGameController = this;
        casinoChipsCallback.m_slot = evt.m_slot;
        Deref(slotData).m_slotUser = slotUser;
        Deref(slotData).m_casinoChipsListener = this.m_transactionSystem.RegisterInventoryListener(Deref(slotData).m_slotUser, casinoChipsCallback);
      };
      evt.m_betData.m_chipsAmount = Cast<Uint32>(this.m_transactionSystem.GetItemQuantity(Deref(slotData).m_slotUser, this.m_casinoChipID)) * this.m_multiplier;
    } else {
      this.UnregisterInventoryListener(slotData);
    };
    Deref(slotData).m_controller.GotoState(evt.m_state, evt.m_betData);
  }

  public final func UnregisterInventoryListener(slotData: script_ref<CasinoTableSlotData>) -> Void {
    this.m_transactionSystem.UnregisterInventoryListener(Deref(slotData).m_slotUser, Deref(slotData).m_casinoChipsListener);
    Deref(slotData).m_slotUser = null;
    Deref(slotData).m_casinoChipsListener = null;
  }
}

public class CasinoTableSlotLogicController extends inkLogicController {

  public let m_state: CasinoTableState;

  public let m_betData: BetData;

  public let m_spawnRequest: wref<inkAsyncSpawnRequest>;

  public let m_page: wref<inkWidget>;

  public final func InitState() -> Void {
    this.GotoStateInternal(CasinoTableState.Idle, true);
  }

  public final func GotoState(state: CasinoTableState, betData: BetData) -> Void {
    this.m_betData = betData;
    if Equals(this.m_state, state) {
      this.PlaceBet();
    } else {
      this.GotoStateInternal(state);
    };
  }

  public final func PlaceBet() -> Void {
    let controller: wref<CasinoTableGamePageLogicController>;
    if Equals(this.m_state, CasinoTableState.Game) {
      controller = this.m_page.GetController() as CasinoTableGamePageLogicController;
      controller.PlaceBet(this.m_betData);
    };
  }

  public final func UpdateChipsAmount(chipsAmount: Uint32) -> Void {
    let controller: wref<CasinoTableGamePageLogicController>;
    if Equals(this.m_state, CasinoTableState.Game) {
      controller = this.m_page.GetController() as CasinoTableGamePageLogicController;
      controller.UpdateChipsAmount(chipsAmount);
    };
  }

  public final func GotoStateInternal(state: CasinoTableState, opt force: Bool) -> Void {
    let libraryID: CName;
    if !force && Equals(this.m_state, state) {
      return;
    };
    this.m_state = state;
    if this.m_spawnRequest != null {
      this.m_spawnRequest.Cancel();
    };
    switch state {
      case CasinoTableState.Idle:
        libraryID = n"table_screen_idle";
        break;
      case CasinoTableState.Game:
        libraryID = n"table_screen_active";
    };
    if Equals(libraryID, n"None") {
      this.OnStateChanged(null, null);
      return;
    };
    this.m_spawnRequest = this.AsyncSpawnFromLocal(this.GetRootCompoundWidget(), libraryID, this, n"OnStateChanged");
  }

  protected cb func OnStateChanged(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
    this.m_spawnRequest = null;
    if IsDefined(this.m_page) {
      this.GetRootCompoundWidget().RemoveChild(this.m_page);
    };
    this.m_page = widget;
    this.PlaceBet();
  }
}

public class CasinoTableIdlePageLogicController extends inkLogicController {

  protected cb func OnInitialize() -> Bool {
    let playbackOptions: inkAnimOptions;
    playbackOptions.loopType = inkanimLoopType.Cycle;
    playbackOptions.loopInfinite = true;
    this.PlayLibraryAnimation(n"idle_loop", playbackOptions);
  }
}

public class CasinoTableGamePageLogicController extends inkLogicController {

  public edit let m_cash: inkTextRef;

  public edit let m_bet: inkTextRef;

  public edit const let m_marks: [BetOnMark];

  public final func PlaceBet(betData: BetData) -> Void {
    let count: Int32;
    let i: Int32;
    let targets: ref<inkWidgetsSet>;
    inkTextRef.SetText(this.m_cash, IntToString(Cast<Int32>(betData.m_chipsAmount)));
    inkTextRef.SetText(this.m_bet, IntToString(Cast<Int32>(betData.m_betAmount)));
    count = ArraySize(this.m_marks);
    i = 0;
    while i < count {
      inkWidgetRef.SetOpacity(this.m_marks[i].m_mark, 0.00);
      if Equals(this.m_marks[i].m_betOn, betData.m_betOn) {
        targets = new inkWidgetsSet();
        targets.Select(inkWidgetRef.Get(this.m_marks[i].m_mark));
        this.PlayLibraryAnimationOnTargets(n"active_selection_proxy", targets);
      };
      i = i + 1;
    };
  }

  public final func UpdateChipsAmount(chipsAmount: Uint32) -> Void {
    inkTextRef.SetText(this.m_cash, IntToString(Cast<Int32>(chipsAmount)));
  }
}

public class CasinoTableObject extends GameObject {

  protected cb func OnChangeCasinoTableState(evt: ref<ChangeCasinoTableStateEvent>) -> Bool {
    GameInstance.GetUISystem(this.GetGame()).QueueEvent(evt);
  }
}
