
public class buffListGameController extends inkHUDGameController {

  private edit let m_buffsList: inkHorizontalPanelRef;

  private let m_bbBuffList: ref<CallbackHandle>;

  private let m_bbDeBuffList: ref<CallbackHandle>;

  private let m_uiBlackboard: wref<IBlackboard>;

  private let m_buffDataList: [BuffInfo];

  private let m_debuffDataList: [BuffInfo];

  private let m_buffWidgets: [wref<inkWidget>];

  private let m_UISystem: wref<UISystem>;

  private let m_pendingRequests: Int32;

  protected cb func OnInitialize() -> Bool {
    this.m_uiBlackboard = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().UI_PlayerBioMonitor);
    if IsDefined(this.m_uiBlackboard) {
      this.m_bbBuffList = this.m_uiBlackboard.RegisterListenerVariant(GetAllBlackboardDefs().UI_PlayerBioMonitor.BuffsList, this, n"OnBuffDataChanged");
      this.m_bbDeBuffList = this.m_uiBlackboard.RegisterListenerVariant(GetAllBlackboardDefs().UI_PlayerBioMonitor.DebuffsList, this, n"OnDeBuffDataChanged");
      this.m_uiBlackboard.SignalVariant(GetAllBlackboardDefs().UI_PlayerBioMonitor.BuffsList);
      this.m_uiBlackboard.SignalVariant(GetAllBlackboardDefs().UI_PlayerBioMonitor.DebuffsList);
    };
    inkWidgetRef.SetVisible(this.m_buffsList, false);
  }

  protected cb func OnUninitialize() -> Bool {
    if IsDefined(this.m_uiBlackboard) {
      this.m_uiBlackboard.UnregisterListenerVariant(GetAllBlackboardDefs().UI_PlayerBioMonitor.BuffsList, this.m_bbBuffList);
      this.m_uiBlackboard.UnregisterListenerVariant(GetAllBlackboardDefs().UI_PlayerBioMonitor.DebuffsList, this.m_bbDeBuffList);
    };
  }

  protected cb func OnPlayerAttach(playerGameObject: ref<GameObject>) -> Bool {
    this.m_UISystem = GameInstance.GetUISystem(playerGameObject.GetGame());
  }

  protected cb func OnBuffDataChanged(value: Variant) -> Bool {
    this.m_buffDataList = FromVariant<array<BuffInfo>>(value);
    this.UpdateBuffs();
  }

  protected cb func OnDeBuffDataChanged(value: Variant) -> Bool {
    this.m_debuffDataList = FromVariant<array<BuffInfo>>(value);
    this.MergeKnockdowns();
    this.UpdateBuffs();
  }

  private final func UpdateBuffs() -> Void {
    let i: Int32;
    let requestsToSpawn: Int32;
    let incomingBuffsCount: Int32 = ArraySize(this.m_debuffDataList) + ArraySize(this.m_buffDataList);
    let currentBuffsAndRequests: Int32 = inkCompoundRef.GetNumChildren(this.m_buffsList) + this.m_pendingRequests;
    if currentBuffsAndRequests < incomingBuffsCount {
      this.m_pendingRequests = incomingBuffsCount - currentBuffsAndRequests;
      requestsToSpawn = this.m_pendingRequests;
      i = 0;
      while i < requestsToSpawn {
        this.AsyncSpawnFromLocal(inkWidgetRef.Get(this.m_buffsList), n"Buff", this, n"OnBuffSpawned");
        i = i + 1;
      };
    };
    if this.m_pendingRequests <= 0 {
      this.UpdateBuffDebuffList();
      this.UpdateVisibility();
    };
  }

  private final func MergeKnockdowns() -> Void {
    let effectType: gamedataStatusEffectType;
    let toRemain: Int32;
    let toRemove: array<Int32>;
    let biggestTimeRemaining: Float = 0.00;
    let i: Int32 = 0;
    while i < ArraySize(this.m_debuffDataList) {
      effectType = TweakDBInterface.GetStatusEffectRecord(this.m_debuffDataList[i].buffID).StatusEffectType().Type();
      if Equals(effectType, gamedataStatusEffectType.Knockdown) || Equals(effectType, gamedataStatusEffectType.VehicleKnockdown) {
        if biggestTimeRemaining > 0.00 {
          ArrayPush(toRemove, i);
        } else {
          toRemain = i;
        };
        biggestTimeRemaining = MaxF(biggestTimeRemaining, this.m_debuffDataList[i].timeRemaining);
      };
      i = i + 1;
    };
    if ArraySize(toRemove) == 0 {
      return;
    };
    i = 0;
    while i < ArraySize(toRemove) {
      ArrayErase(this.m_debuffDataList, toRemove[i] - i);
      i = i + 1;
    };
    this.m_debuffDataList[toRemain].timeRemaining = biggestTimeRemaining;
  }

  protected cb func OnBuffSpawned(newItem: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
    newItem.SetVisible(false);
    ArrayPush(this.m_buffWidgets, newItem);
    this.m_pendingRequests -= 1;
    if this.m_pendingRequests <= 0 {
      this.UpdateBuffDebuffList();
      this.UpdateVisibility();
    };
  }

  private final func UpdateVisibility() -> Void {
    this.GetRootWidget().SetVisible(false);
    this.GetRootWidget().SetVisible(true);
    this.GetRootWidget().SetVisible(inkWidgetRef.IsVisible(this.m_buffsList));
  }

  private final func UpdateBuffDebuffList() -> Void {
    let buffList: array<BuffInfo>;
    let buffTimeRemaining: Float;
    let buffTimeTotal: Float;
    let currBuffLoc: wref<buffListItemLogicController>;
    let currBuffWidget: wref<inkWidget>;
    let data: ref<StatusEffect_Record>;
    let incomingBuffsCount: Int32;
    let onScreenBuffsCount: Int32;
    let visibleIncomingBuffsCount: Int32;
    let i: Int32 = 0;
    while i < ArraySize(this.m_buffDataList) {
      ArrayPush(buffList, this.m_buffDataList[i]);
      i = i + 1;
    };
    i = 0;
    while i < ArraySize(this.m_debuffDataList) {
      ArrayPush(buffList, this.m_debuffDataList[i]);
      i = i + 1;
    };
    incomingBuffsCount = ArraySize(buffList);
    onScreenBuffsCount = inkCompoundRef.GetNumChildren(this.m_buffsList);
    i = 0;
    while i < onScreenBuffsCount {
      currBuffWidget = this.m_buffWidgets[i];
      currBuffLoc = currBuffWidget.GetController() as buffListItemLogicController;
      if i >= incomingBuffsCount {
        currBuffWidget.SetVisible(false);
        currBuffLoc.SetStatusEffectRecord(null);
      } else {
        data = TweakDBInterface.GetStatusEffectRecord(buffList[i].buffID);
        buffTimeRemaining = buffList[i].timeRemaining;
        buffTimeTotal = buffList[i].timeTotal;
        if !IsDefined(data) || !IsDefined(data.UiData()) || Equals(data.UiData().IconPath(), "") {
          currBuffWidget.SetVisible(false);
          currBuffLoc.SetStatusEffectRecord(null);
        } else {
          if data != currBuffLoc.GetStatusEffectRecord() {
            currBuffLoc.SetStatusEffectRecord(data);
            currBuffLoc.PlayLibraryAnimation(n"intro");
          };
          currBuffLoc.SetData(StringToName(data.UiData().IconPath()), buffTimeRemaining, buffTimeTotal, Cast<Int32>(buffList[i].stackCount));
          currBuffWidget.SetVisible(true);
          visibleIncomingBuffsCount += 1;
        };
      };
      i = i + 1;
    };
    this.SendVisibilityUpdate(inkWidgetRef.IsVisible(this.m_buffsList), visibleIncomingBuffsCount > 0);
    inkWidgetRef.SetVisible(this.m_buffsList, visibleIncomingBuffsCount > 0);
  }

  private final func SendVisibilityUpdate(oldVisible: Bool, nowVisible: Bool) -> Void {
    let evt: ref<BuffListVisibilityChangedEvent>;
    if NotEquals(oldVisible, nowVisible) {
      evt = new BuffListVisibilityChangedEvent();
      evt.m_hasBuffs = nowVisible;
      this.m_UISystem.QueueEvent(evt);
    };
  }
}

public class buffListItemLogicController extends inkLogicController {

  private edit let m_icon: inkImageRef;

  private edit let m_iconBg: inkImageRef;

  private edit let m_fill: inkWidgetRef;

  private let m_fillWidget: wref<inkWidget>;

  private edit let m_timeLabel: inkTextRef;

  private edit let m_stackCounter: inkTextRef;

  private edit let m_stackCounterContainer: inkWidgetRef;

  private edit let m_statusEffectRecord: wref<StatusEffect_Record>;

  protected cb func OnInitialize() -> Bool {
    this.m_fillWidget = inkWidgetRef.Get(this.m_fill);
  }

  public final func SetData(icon: CName, time: Float, totalTime: Float, opt stackCount: Int32) -> Void {
    if stackCount > 1 {
      inkWidgetRef.SetVisible(this.m_stackCounterContainer, true);
      inkTextRef.SetText(this.m_stackCounter, "x" + IntToString(stackCount));
    } else {
      inkWidgetRef.SetVisible(this.m_stackCounterContainer, false);
    };
    this.SetTimeFill(time, totalTime);
    this.SetTimeText(time);
    InkImageUtils.RequestSetImage(this, this.m_icon, "UIIcon." + NameToString(icon));
    InkImageUtils.RequestSetImage(this, this.m_iconBg, "UIIcon." + NameToString(icon));
  }

  private final func SetTimeFill(time: Float, totalTime: Float) -> Void {
    this.m_fillWidget.SetEffectParamValue(inkEffectType.RadialWipe, n"RadialWipe", n"transition", time / totalTime);
  }

  private final func SetTimeText(f: Float) -> Void {
    let textParams: ref<inkTextParams> = new inkTextParams();
    let time: GameTime = GameTime.MakeGameTime(0, 0, 0, Cast<Int32>(f));
    let minutes: Int32 = GameTime.Minutes(time);
    let seconds: Int32 = GameTime.Seconds(time);
    if f >= 0.00 {
      inkWidgetRef.SetVisible(this.m_timeLabel, true);
      if minutes > 0 {
        inkTextRef.SetText(this.m_timeLabel, "{TIME,time,mm:ss}");
        textParams.AddTime("TIME", time);
        inkTextRef.SetTextParameters(this.m_timeLabel, textParams);
      } else {
        inkTextRef.SetText(this.m_timeLabel, ToString(seconds));
      };
    } else {
      inkWidgetRef.SetVisible(this.m_timeLabel, false);
    };
  }

  public final func SetData(icon: TweakDBID, time: Float, totalTime: Float) -> Void {
    this.SetTimeText(time);
    this.SetTimeFill(time, totalTime);
    InkImageUtils.RequestSetImage(this, this.m_icon, icon);
    InkImageUtils.RequestSetImage(this, this.m_iconBg, icon);
  }

  public final func SetData(icon: CName, stackCount: Int32) -> Void {
    if stackCount > 1 {
      inkWidgetRef.SetVisible(this.m_stackCounterContainer, true);
      inkTextRef.SetText(this.m_stackCounter, "x" + ToString(stackCount));
    } else {
      inkWidgetRef.SetVisible(this.m_stackCounterContainer, false);
    };
    InkImageUtils.RequestSetImage(this, this.m_icon, "UIIcon." + NameToString(icon));
    InkImageUtils.RequestSetImage(this, this.m_iconBg, "UIIcon." + NameToString(icon));
  }

  public final func GetStatusEffectRecord() -> ref<StatusEffect_Record> {
    return this.m_statusEffectRecord;
  }

  public final func SetStatusEffectRecord(record: wref<StatusEffect_Record>) -> Void {
    this.m_statusEffectRecord = record;
  }
}
