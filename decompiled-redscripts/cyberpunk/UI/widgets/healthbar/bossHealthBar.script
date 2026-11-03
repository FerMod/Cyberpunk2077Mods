
public class BossHealthBarGameController extends inkHUDGameController {

  private edit let m_healthControllerRef: inkWidgetRef;

  private edit let m_healthPercentage: inkTextRef;

  private edit let m_bossName: inkTextRef;

  private edit let m_dividerContainerRef: inkCompoundRef;

  private let m_statListener: ref<BossHealthStatListener>;

  private let m_boss: wref<NPCPuppet>;

  private let m_healthController: wref<NameplateBarLogicController>;

  private let m_thresholds: [Float];

  private let m_root: wref<inkWidget>;

  private let m_unfoldAnimation: ref<inkAnimProxy>;

  private let m_foldAnimation: ref<inkAnimProxy>;

  private let m_fastTravelCallbackID: ref<CallbackHandle>;

  private let m_bossPuppets: [wref<NPCPuppet>];

  protected cb func OnInitialize() -> Bool {
    this.m_healthController = inkWidgetRef.GetController(this.m_healthControllerRef) as NameplateBarLogicController;
    this.m_statListener = new BossHealthStatListener();
    this.m_statListener.BindHealthbar(this);
    this.m_root = this.GetRootWidget();
    this.m_root.SetVisible(false);
    IBlackboard.Create(GetAllBlackboardDefs().PuppetState);
    this.m_boss = null;
    ArrayClear(this.m_bossPuppets);
    this.RegisterFastTravelCallback();
    this.ReevaluatePlayerInBossCombat();
  }

  protected cb func OnUninitialize() -> Bool {
    this.UnregisterFastTravelCallback();
  }

  public final func UpdateHealthValue(newValue: Float, opt silent: Bool) -> Void {
    this.m_healthController.SetNameplateBarProgress(newValue / 100.00, silent);
    inkTextRef.SetText(this.m_healthPercentage, IntToString(CeilF(newValue)));
  }

  protected cb func OnBossCombatNotifier(evt: ref<BossCombatNotifier>) -> Bool {
    if evt.combatEnded {
      this.ReevaluateBossArray();
    } else {
      if !StatusEffectSystem.ObjectHasStatusEffect(evt.bossEntity as NPCPuppet, t"Chimera.HideBossHealthBar") {
        this.AddBoss(evt.bossEntity as NPCPuppet);
      };
    };
  }

  protected cb func OnThreatDefeated(evt: ref<ThreatDefeated>) -> Bool {
    if IsDefined(evt.threat) {
      this.RemoveBoss(evt.threat as NPCPuppet);
    } else {
      this.ReevaluateBossArray();
    };
  }

  protected cb func OnThreatUnconscious(evt: ref<ThreatUnconscious>) -> Bool {
    if IsDefined(evt.threat) {
      this.RemoveBoss(evt.threat as NPCPuppet);
    } else {
      this.ReevaluateBossArray();
    };
  }

  protected cb func OnThreatKilled(evt: ref<ThreatDeath>) -> Bool {
    if IsDefined(evt.threat) {
      this.RemoveBoss(evt.threat as NPCPuppet);
    } else {
      this.ReevaluateBossArray();
    };
  }

  protected cb func OnThreatRemoved(evt: ref<ThreatRemoved>) -> Bool {
    if IsDefined(evt.threat) {
      this.RemoveBoss(evt.threat as NPCPuppet);
    } else {
      this.ReevaluateBossArray();
    };
  }

  protected cb func OnThreatInvalid(evt: ref<ThreatInvalid>) -> Bool {
    if IsDefined(evt.threat) {
      this.RemoveBoss(evt.threat as NPCPuppet);
    } else {
      this.ReevaluateBossArray();
    };
  }

  protected cb func OnAnimationEnd(e: ref<inkAnimProxy>) -> Bool {
    this.m_root.SetVisible(false);
  }

  protected cb func OnDamageDealt(evt: ref<gameTargetDamageEvent>) -> Bool {
    let puppet: ref<NPCPuppet> = evt.target as NPCPuppet;
    let canHaveBossHealthbar: Bool = puppet.IsBoss() || Equals(puppet.GetNPCRarity(), gamedataNPCRarity.MaxTac);
    let isDeadOrDefeated: Bool = ScriptedPuppet.IsDefeated(puppet) || puppet.IsDead();
    let isHealthbarHidden: Bool = StatusEffectSystem.ObjectHasStatusEffect(puppet, t"Chimera.HideBossHealthBar");
    if canHaveBossHealthbar && !isDeadOrDefeated && !isHealthbarHidden {
      this.AddBoss(puppet);
    };
  }

  private final func AddBoss(boss: ref<NPCPuppet>) -> Void {
    if !IsDefined(boss) || !boss.IsBoss() && NotEquals(boss.GetNPCRarity(), gamedataNPCRarity.MaxTac) {
      return;
    };
    if ArrayContains(this.m_bossPuppets, boss) {
      if boss != this.m_boss {
        this.ShowBossHealthBar(boss, true);
      };
      return;
    };
    ArrayPush(this.m_bossPuppets, boss);
    this.ShowBossHealthBar(boss, false);
  }

  private final func RemoveBoss(boss: ref<NPCPuppet>) -> Void {
    if !IsDefined(boss) || !ArrayContains(this.m_bossPuppets, boss) {
      return;
    };
    ArrayRemove(this.m_bossPuppets, boss);
    if ArraySize(this.m_bossPuppets) > 0 && IsDefined(this.m_bossPuppets[0]) {
      this.ShowBossHealthBar(this.m_bossPuppets[0], true);
    } else {
      this.HideBossHealthBar();
    };
  }

  private final func ReevaluateBossArray() -> Void {
    let i: Int32 = ArraySize(this.m_bossPuppets) - 1;
    while i >= 0 {
      if !IsDefined(this.m_bossPuppets[i]) || !ScriptedPuppet.IsActive(this.m_bossPuppets[i]) || GameObject.IsFriendlyTowardsPlayer(this.m_bossPuppets[i]) {
        ArrayErase(this.m_bossPuppets, i);
      };
      i -= 1;
    };
    if ArraySize(this.m_bossPuppets) == 0 {
      this.HideBossHealthBar();
    };
  }

  private final func ShowBossHealthBar(puppet: ref<NPCPuppet>, useSilentUpdate: Bool) -> Void {
    let playUnfoldAnim: Bool;
    if !IsDefined(puppet) || !puppet.IsBoss() && NotEquals(puppet.GetNPCRarity(), gamedataNPCRarity.MaxTac) || !ScriptedPuppet.IsAlive(puppet) {
      return;
    };
    playUnfoldAnim = !IsDefined(this.m_boss);
    this.UnregisterPreviousBoss();
    this.RegisterToNewBoss(puppet, useSilentUpdate);
    this.m_root.SetVisible(true);
    if playUnfoldAnim {
      if IsDefined(this.m_foldAnimation) && this.m_foldAnimation.IsPlaying() {
        this.m_foldAnimation.UnregisterFromAllCallbacks(inkanimEventType.OnFinish);
        this.m_foldAnimation.Stop();
      };
      if !IsDefined(this.m_unfoldAnimation) || !this.m_unfoldAnimation.IsPlaying() {
        this.m_unfoldAnimation = this.PlayLibraryAnimation(n"unfold");
      };
    };
  }

  private final func HideBossHealthBar() -> Void {
    this.UnregisterPreviousBoss();
    if !IsDefined(this.m_foldAnimation) || !this.m_foldAnimation.IsPlaying() {
      if IsDefined(this.m_unfoldAnimation) && this.m_unfoldAnimation.IsPlaying() {
        this.m_unfoldAnimation.Stop();
      };
      this.m_foldAnimation = this.PlayLibraryAnimation(n"fold");
      this.m_foldAnimation.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnAnimationEnd");
    };
  }

  private final func RegisterToNewBoss(boss: ref<NPCPuppet>, useSilentUpdate: Bool) -> Void {
    let NPCName: String;
    let characterRecord: ref<Character_Record>;
    this.m_boss = boss;
    this.UpdateHealthValue(GameInstance.GetStatPoolsSystem(this.m_boss.GetGame()).GetStatPoolValue(Cast<StatsObjectID>(this.m_boss.GetEntityID()), gamedataStatPoolType.Health), useSilentUpdate);
    GameInstance.GetStatPoolsSystem(this.m_boss.GetGame()).RequestRegisteringListener(Cast<StatsObjectID>(this.m_boss.GetEntityID()), gamedataStatPoolType.Health, this.m_statListener);
    characterRecord = TweakDBInterface.GetCharacterRecord(this.m_boss.GetRecordID());
    this.SetUpThresholds(characterRecord);
    if IsNameValid(characterRecord.FullDisplayName()) {
      NPCName = LocKeyToString(characterRecord.FullDisplayName());
    } else {
      NPCName = this.m_boss.GetDisplayName();
    };
    inkTextRef.SetText(this.m_bossName, NPCName);
  }

  private final func UnregisterPreviousBoss() -> Void {
    if !IsDefined(this.m_boss) {
      return;
    };
    GameInstance.GetStatPoolsSystem(this.m_boss.GetGame()).RequestUnregisteringListener(Cast<StatsObjectID>(this.m_boss.GetEntityID()), gamedataStatPoolType.Health, this.m_statListener);
    this.m_boss = null;
  }

  public final static func ReevaluateBossHealthBar(puppet: wref<NPCPuppet>, target: wref<GameObject>, opt combatEnded: Bool) -> Void {
    let bossCombatEvent: ref<BossCombatNotifier>;
    if !IsDefined(puppet) || !puppet.IsBoss() && NotEquals(puppet.GetNPCRarity(), gamedataNPCRarity.MaxTac) || !IsDefined(target) || !target.IsPlayer() {
      return;
    };
    bossCombatEvent = new BossCombatNotifier();
    bossCombatEvent.bossEntity = puppet;
    bossCombatEvent.combatEnded = combatEnded;
    target.QueueEvent(bossCombatEvent);
  }

  public final static func ReevaluateBossHealthBar(puppet: wref<NPCPuppet>, targetTracker: wref<TargetTrackingExtension>, opt combatEnded: Bool) -> Void {
    let bossCombatEvent: ref<BossCombatNotifier>;
    let hostileThreats: array<TrackedLocation>;
    let target: wref<GameObject>;
    if !IsDefined(puppet) || !puppet.IsBoss() && NotEquals(puppet.GetNPCRarity(), gamedataNPCRarity.MaxTac) || !IsDefined(targetTracker) {
      return;
    };
    hostileThreats = targetTracker.GetHostileThreats(false);
    if ArraySize(hostileThreats) > 0 && TargetTrackingExtension.GetPlayerFromThreats(hostileThreats, target) {
      bossCombatEvent = new BossCombatNotifier();
      bossCombatEvent.bossEntity = puppet;
      bossCombatEvent.combatEnded = combatEnded;
      target.QueueEvent(bossCombatEvent);
    };
  }

  private final func ReevaluatePlayerInBossCombat() -> Void {
    let i: Int32;
    let threatPuppet: wref<NPCPuppet>;
    let threatsArray: array<TrackedLocation>;
    let player: wref<PlayerPuppet> = this.GetOwnerEntity() as PlayerPuppet;
    if IsDefined(player) {
      threatsArray = player.GetTargetTrackerComponent().GetThreats(false);
      i = 0;
      while i < ArraySize(threatsArray) {
        threatPuppet = threatsArray[i].entity as NPCPuppet;
        if IsDefined(threatPuppet) && (threatPuppet.IsBoss() || Equals(threatPuppet.GetNPCRarity(), gamedataNPCRarity.MaxTac)) {
          BossHealthBarGameController.ReevaluateBossHealthBar(threatPuppet, player);
        };
        i += 1;
      };
    };
  }

  private final func SetUpThresholds(boss: ref<Character_Record>) -> Void {
    let i: Int32;
    ArrayClear(this.m_thresholds);
    i = 0;
    while i < boss.GetBossHealthBarThresholdsCount() {
      ArrayPush(this.m_thresholds, boss.GetBossHealthBarThresholdsItem(i));
      i += 1;
    };
    this.SortThresholds();
    this.MoveDividers();
  }

  private final func SortThresholds() -> Void {
    let j: Int32;
    let tempVar: Float;
    let i: Int32 = 0;
    while i < ArraySize(this.m_thresholds) - 1 {
      j = i + 1;
      while j < ArraySize(this.m_thresholds) {
        if this.m_thresholds[i] > this.m_thresholds[j] {
          tempVar = this.m_thresholds[j];
          this.m_thresholds[j] = this.m_thresholds[i];
          this.m_thresholds[i] = tempVar;
        };
        j += 1;
      };
      i += 1;
    };
  }

  private final func MoveDividers() -> Void {
    let gapWidth: Float;
    let i: Int32;
    let j: Int32;
    let leftThreshold: Float;
    let rightThreshold: Float;
    let tempSize: Vector2;
    let totalWidth: Float;
    let widget: wref<inkWidget>;
    inkCompoundRef.RemoveAllChildren(this.m_dividerContainerRef);
    tempSize = inkWidgetRef.GetSize(this.m_dividerContainerRef);
    totalWidth = tempSize.X;
    i = 0;
    while i < ArraySize(this.m_thresholds) {
      j = i - 1;
      leftThreshold = j >= 0 ? this.m_thresholds[j] : 0.00;
      rightThreshold = i < ArraySize(this.m_thresholds) ? this.m_thresholds[i] : 100.00;
      gapWidth = (rightThreshold - leftThreshold) / 100.00 * totalWidth;
      widget = this.SpawnFromLocal(inkWidgetRef.Get(this.m_dividerContainerRef), n"divider");
      if i != 0 {
        tempSize = widget.GetSize();
        gapWidth -= tempSize.X;
      };
      widget.SetMargin(gapWidth, 0.00, 0.00, 0.00);
      i += 1;
    };
  }

  private final func ScaleBetween(value: Float, inMin: Float, inMax: Float, outMin: Float, outMax: Float) -> Float {
    let dividend: Float = (outMax - outMin) * (value - inMin);
    let divisor: Float = inMax - inMin;
    return dividend / divisor + outMin;
  }

  private final func RegisterFastTravelCallback() -> Void {
    let blackboard: ref<IBlackboard> = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().FastTRavelSystem);
    if IsDefined(blackboard) && !IsDefined(this.m_fastTravelCallbackID) {
      this.m_fastTravelCallbackID = blackboard.RegisterListenerBool(GetAllBlackboardDefs().FastTRavelSystem.FastTravelLoadingScreenFinished, this, n"OnFastTravelFinished");
    };
  }

  private final func UnregisterFastTravelCallback() -> Void {
    let blackboard: ref<IBlackboard> = this.GetBlackboardSystem().Get(GetAllBlackboardDefs().FastTRavelSystem);
    if blackboard != null && IsDefined(this.m_fastTravelCallbackID) {
      blackboard.UnregisterListenerBool(GetAllBlackboardDefs().FastTRavelSystem.FastTravelLoadingScreenFinished, this.m_fastTravelCallbackID);
    };
  }

  private final func OnFastTravelFinished(value: Bool) -> Void {
    if value {
      this.ReevaluateBossArray();
    };
  }
}

public class BossHealthStatListener extends ScriptStatPoolsListener {

  private let m_healthbar: wref<BossHealthBarGameController>;

  public final func BindHealthbar(bar: wref<BossHealthBarGameController>) -> Void {
    this.m_healthbar = bar;
  }

  public func OnStatPoolValueChanged(oldValue: Float, newValue: Float, percToPoints: Float) -> Void {
    this.m_healthbar.UpdateHealthValue(newValue);
  }
}
