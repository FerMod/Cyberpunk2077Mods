
public class KiroshiHighlightEffectorCallback extends AttachmentSlotsScriptCallback {

  public let m_effector: ref<KiroshiHighlightEffector>;

  public func OnItemEquipped(slot: TweakDBID, item: ItemID) -> Void {
    let weaponRecord: ref<WeaponItem_Record> = TweakDBInterface.GetWeaponItemRecord(ItemID.GetTDBID(item));
    let weaponEvolution: gamedataWeaponEvolution = RPGManager.GetWeaponEvolution(item);
    let isMeleeWeapon: Bool = weaponRecord.TagsContains(n"MeleeWeapon");
    this.m_effector.m_isTechWeaponEquipped = Equals(weaponEvolution, gamedataWeaponEvolution.Tech);
    this.m_effector.m_isMeleeWeaponEquipped = isMeleeWeapon;
  }

  public func OnItemUnequipped(slot: TweakDBID, item: ItemID) -> Void {
    this.m_effector.m_isMeleeWeaponEquipped = false;
    this.m_effector.m_isTechWeaponEquipped = false;
  }
}

public class KiroshiEffectorIsAimingStatListener extends ScriptStatsListener {

  public let m_effector: wref<KiroshiHighlightEffector>;

  public func OnStatChanged(ownerID: StatsObjectID, statType: gamedataStatType, diff: Float, total: Float) -> Void {
    this.m_effector.m_IsAiming = total == 1.00;
  }
}

public class KiroshiEffectorTechPreviewStatListener extends ScriptStatsListener {

  public let m_effector: wref<KiroshiHighlightEffector>;

  public func OnStatChanged(ownerID: StatsObjectID, statType: gamedataStatType, diff: Float, total: Float) -> Void {
    this.m_effector.m_isTechPreviewEnabled = total == 1.00;
  }
}

public class KiroshiHighlightEffector extends HighlightEffector {

  private let m_onlyWhileAiming: Bool;

  private let m_onlyClosestToCrosshair: Bool;

  private let m_onlyClosestByDistance: Bool;

  private let m_aimingStatListener: ref<KiroshiEffectorIsAimingStatListener>;

  private let m_techPreviewStatListener: ref<KiroshiEffectorTechPreviewStatListener>;

  private let m_slotCallback: ref<KiroshiHighlightEffectorCallback>;

  private let m_slotListener: ref<AttachmentSlotsScriptListener>;

  public let m_IsAiming: Bool;

  public let m_isTechWeaponEquipped: Bool;

  public let m_isMeleeWeaponEquipped: Bool;

  public let m_isTechPreviewEnabled: Bool;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    super.Initialize(record, game, parentRecord);
    this.m_onlyWhileAiming = TDB.GetBool(record + t".onlyWhileAiming");
    this.m_onlyClosestToCrosshair = TDB.GetBool(record + t".onlyClosestToCrosshair");
    this.m_onlyClosestByDistance = TDB.GetBool(record + t".onlyClosestByDistance");
  }

  protected func Uninitialize(game: GameInstance) -> Void {
    if IsDefined(this.m_slotListener) {
      GameInstance.GetTransactionSystem(game).UnregisterAttachmentSlotListener(this.m_owner, this.m_slotListener);
      this.m_slotListener = null;
      this.m_slotCallback = null;
    };
    if IsDefined(this.m_aimingStatListener) {
      GameInstance.GetStatsSystem(game).UnregisterListener(Cast<StatsObjectID>(this.m_owner.GetEntityID()), this.m_aimingStatListener);
      this.m_aimingStatListener = null;
    };
    if IsDefined(this.m_techPreviewStatListener) {
      GameInstance.GetStatsSystem(game).UnregisterListener(Cast<StatsObjectID>(this.m_owner.GetEntityID()), this.m_techPreviewStatListener);
      this.m_techPreviewStatListener = null;
    };
  }

  private final func InitializeListeners() -> Void {
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.m_owner.GetGame());
    if !IsDefined(this.m_aimingStatListener) {
      this.m_aimingStatListener = new KiroshiEffectorIsAimingStatListener();
      this.m_aimingStatListener.m_effector = this;
      this.m_aimingStatListener.SetStatType(gamedataStatType.IsAimingWithWeapon);
      statsSystem.RegisterListener(Cast<StatsObjectID>(this.m_owner.GetEntityID()), this.m_aimingStatListener);
      this.m_IsAiming = statsSystem.GetStatValue(Cast<StatsObjectID>(this.m_owner.GetEntityID()), gamedataStatType.IsAimingWithWeapon) == 1.00;
    };
    if !IsDefined(this.m_techPreviewStatListener) {
      this.m_techPreviewStatListener = new KiroshiEffectorTechPreviewStatListener();
      this.m_techPreviewStatListener.m_effector = this;
      this.m_techPreviewStatListener.SetStatType(gamedataStatType.TechPierceHighlightsEnabled);
      statsSystem.RegisterListener(Cast<StatsObjectID>(this.m_owner.GetEntityID()), this.m_techPreviewStatListener);
      this.m_isTechPreviewEnabled = statsSystem.GetStatValue(Cast<StatsObjectID>(this.m_owner.GetEntityID()), gamedataStatType.TechPierceHighlightsEnabled) == 1.00;
    };
    if !IsDefined(this.m_slotListener) {
      this.m_slotCallback = new KiroshiHighlightEffectorCallback();
      this.m_slotCallback.slotID = t"AttachmentSlots.WeaponRight";
      this.m_slotCallback.m_effector = this;
      this.m_slotListener = GameInstance.GetTransactionSystem(this.m_owner.GetGame()).RegisterAttachmentSlotListener(this.m_owner, this.m_slotCallback);
    };
  }

  protected func ContinuousAction(owner: ref<GameObject>, instigator: ref<GameObject>) -> Void {
    this.m_owner = owner;
    this.InitializeListeners();
    if this.m_isTechWeaponEquipped && this.m_IsAiming && this.m_isTechPreviewEnabled {
      return;
    };
    if this.m_onlyWhileAiming && (!this.m_IsAiming || this.m_isMeleeWeaponEquipped) {
      return;
    };
    this.ProcessEffector();
  }

  private func ProcessHighlight(searchQuery: TargetSearchQuery) -> Void {
    if this.m_onlyClosestToCrosshair {
      this.RevealClosestToCrosshair(this.m_owner, searchQuery);
      return;
    };
    if this.m_onlyClosestByDistance {
      this.RevealClosestByDistance(this.m_owner, searchQuery);
      return;
    };
    this.RevealAllObjects(this.m_owner, searchQuery);
  }

  private final func RevealClosestToCrosshair(owner: ref<GameObject>, query: TargetSearchQuery) -> Void {
    let angleDistance: EulerAngles;
    let closestTarget: ref<GameObject> = GameInstance.GetTargetingSystem(owner.GetGame()).GetObjectClosestToCrosshair(owner, angleDistance, query);
    if !IsDefined(closestTarget) {
      return;
    };
    if this.m_highlightVisible || !GameInstance.GetTargetingSystem(owner.GetGame()).IsVisibleTarget(owner, closestTarget) {
      this.RevealObject(owner, closestTarget, true, this.m_effectDuraton);
    };
  }

  private final func RevealClosestByDistance(owner: ref<GameObject>, query: TargetSearchQuery) -> Void {
    let closestTarget: TS_TargetPartInfo;
    let targetObject: ref<GameObject>;
    GameInstance.GetTargetingSystem(owner.GetGame()).GetTargetClosestByDistance(owner, query, owner.GetWorldPosition(), closestTarget);
    targetObject = TS_TargetPartInfo.GetComponent(closestTarget).GetEntity() as GameObject;
    if IsDefined(targetObject) && (this.m_highlightVisible || !GameInstance.GetTargetingSystem(owner.GetGame()).IsVisibleTarget(owner, targetObject)) {
      this.RevealObject(owner, targetObject, true, this.m_effectDuraton);
    };
  }
}
