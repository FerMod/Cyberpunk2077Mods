
public class ChimeraHealthChangeListener extends CustomValueStatPoolsListener {

  private let m_owner: wref<NPCPuppet>;

  public final func SetOwner(owner: wref<NPCPuppet>) -> Void {
    this.m_owner = owner;
  }

  public func OnStatPoolValueChanged(oldValue: Float, newValue: Float, percToPoints: Float) -> Void {
    this.CheckPhase(oldValue, newValue, percToPoints);
  }

  public final func CheckPhase(oldValue: Float, newValue: Float, percToPoints: Float) -> Void {
    let phase2evt: ref<ChangeToPhase2DelayedEvent> = new ChangeToPhase2DelayedEvent();
    let gascloudevt: ref<EnableGasCloudDelayedEvent> = new EnableGasCloudDelayedEvent();
    let phase3evt: ref<ChangeToPhase3DelayedEvent> = new ChangeToPhase3DelayedEvent();
    if oldValue > 70.00 && newValue <= 70.00 && StatusEffectSystem.ObjectHasStatusEffect(this.m_owner, t"Chimera.Phase1") && !StatusEffectSystem.ObjectHasStatusEffect(this.m_owner, t"Chimera.ChimeraForcePhase2") {
      StatusEffectHelper.RemoveStatusEffect(this.m_owner, t"Chimera.ChimeraFocusMyers");
      StatusEffectHelper.RemoveStatusEffect(this.m_owner, t"Chimera.ChimeraWaitForMyers");
      this.m_owner.ScheduleAppearanceChange(n"mch_004__militech_chimera__basic_01_destroyed");
      GameInstance.GetDelaySystem(this.m_owner.GetGame()).DelayEvent(this.m_owner, phase2evt, 0.10);
    } else {
      if StatusEffectSystem.ObjectHasStatusEffect(this.m_owner, t"Chimera.ChimeraForcePhase2") && StatusEffectSystem.ObjectHasStatusEffect(this.m_owner, t"Chimera.Phase1") {
        StatusEffectHelper.RemoveStatusEffect(this.m_owner, t"Chimera.ChimeraFocusMyers");
        StatusEffectHelper.RemoveStatusEffect(this.m_owner, t"Chimera.ChimeraWaitForMyers");
        GameInstance.GetDelaySystem(this.m_owner.GetGame()).DelayEvent(this.m_owner, phase2evt, 0.10);
      } else {
        if oldValue > 1.00 && newValue <= 1.00 && StatusEffectSystem.ObjectHasStatusEffect(this.m_owner, t"Chimera.Phase2") && !StatusEffectSystem.ObjectHasStatusEffect(this.m_owner, t"Chimera.ChimeraForcePhase3") {
          StatusEffectHelper.RemoveStatusEffect(this.m_owner, t"Chimera.ChimeraFocusMyers");
          StatusEffectHelper.RemoveStatusEffect(this.m_owner, t"Chimera.ChimeraWaitForMyers");
          GameInstance.GetDelaySystem(this.m_owner.GetGame()).DelayEvent(this.m_owner, phase3evt, 0.00);
        } else {
          if oldValue > 40.00 && newValue <= 40.00 && StatusEffectSystem.ObjectHasStatusEffect(this.m_owner, t"Chimera.Phase2") {
            GameInstance.GetDelaySystem(this.m_owner.GetGame()).DelayEvent(this.m_owner, gascloudevt, 0.00);
          } else {
            if StatusEffectSystem.ObjectHasStatusEffect(this.m_owner, t"Chimera.ChimeraForcePhase3") && StatusEffectSystem.ObjectHasStatusEffect(this.m_owner, t"Chimera.Phase2") {
              GameInstance.GetDelaySystem(this.m_owner.GetGame()).DelayEvent(this.m_owner, phase3evt, 0.00);
            } else {
              if oldValue > 0.00 && newValue <= 0.00 && StatusEffectSystem.ObjectHasStatusEffect(this.m_owner, t"Chimera.Phase3") {
                GameObject.StartReplicatedEffectEvent(this.m_owner, n"explode_Death");
              };
            };
          };
        };
      };
    };
  }
}

public class ChimeraComponent extends ScriptableComponent {

  private let m_owner: wref<NPCPuppet>;

  private let m_ownerId: EntityID;

  private let m_player: wref<PlayerPuppet>;

  private let m_statPoolSystem: ref<StatPoolsSystem>;

  private let m_npcDeathCollisionComponent: ref<SimpleColliderComponent>;

  private let m_targetingBody: ref<TargetingComponent>;

  private let m_healthListener: ref<ChimeraHealthChangeListener>;

  private let m_defeatedOnAttach: Bool;

  private let m_weakspotComponent: ref<WeakspotComponent>;

  private let m_weakspots: [wref<WeakspotObject>];

  private let m_weakspotsInvulnerable: Bool;

  private let m_weakspotsDelay: DelayID;

  private let m_targetTrackerComponent: ref<TargetTrackerComponent>;

  public final func OnGameAttach() -> Void {
    this.m_owner = this.GetOwner() as NPCPuppet;
    this.m_ownerId = this.m_owner.GetEntityID();
    this.m_player = this.GetPlayerSystem().GetLocalPlayerControlledGameObject() as PlayerPuppet;
    this.m_targetTrackerComponent = this.m_owner.GetTargetTrackerComponent();
    this.m_statPoolSystem = GameInstance.GetStatPoolsSystem(this.m_owner.GetGame());
    this.m_defeatedOnAttach = GetFact(this.m_owner.GetGame(), n"chimera_defeated") != 0;
    if this.m_defeatedOnAttach {
      StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"Chimera.Phase3", this.m_ownerId);
      this.DisableAllHitShapes();
      this.EnablePhase2HitShapes();
      this.m_owner.ScheduleAppearanceChange(n"mch_004__militech_chimera__basic_01_burnt");
      if IsDefined(this.m_npcDeathCollisionComponent) {
        this.m_npcDeathCollisionComponent.Toggle(true);
      };
    } else {
      this.m_healthListener = new ChimeraHealthChangeListener();
      this.m_healthListener.SetValue(80.00);
      this.m_healthListener.SetOwner(this.m_owner);
      this.m_statPoolSystem.RequestRegisteringListener(Cast<StatsObjectID>(this.m_ownerId), gamedataStatPoolType.Health, this.m_healthListener);
      StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"Chimera.Phase1", this.m_ownerId);
      this.DisableAllHitShapes();
      this.EnablePhase1HitShapes();
    };
    this.m_weakspotComponent = this.m_owner.GetWeakspotComponent();
    this.m_weakspotsInvulnerable = false;
    if this.m_defeatedOnAttach {
      this.SetWeakspotsInvulnerable();
    } else {
      if StatusEffectSystem.ObjectHasStatusEffect(this.m_owner, t"Chimera.ChimeraWeakSpotToggle") {
        this.SetWeakspotsInvulnerable();
        AnimationControllerComponent.SetAnimWrapperWeight(this.m_owner, n"section1Locomotion", 1.00);
      };
    };
    GameInstance.GetGodModeSystem(this.m_owner.GetGame()).AddGodMode(this.m_ownerId, gameGodModeType.Immortal, n"Default");
  }

  public final func OnGameDetach() -> Void {
    if !this.m_defeatedOnAttach {
      this.m_statPoolSystem.RequestUnregisteringListener(Cast<StatsObjectID>(this.m_ownerId), gamedataStatPoolType.Health, this.m_healthListener);
      this.m_healthListener = null;
    };
  }

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    EntityRequestComponentsInterface.RequestComponent(ri, n"npcCollision", n"SimpleColliderComponent", true);
    EntityRequestComponentsInterface.RequestComponent(ri, n"TargetingChimeraBody", n"gameTargetingComponent", true);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    this.m_npcDeathCollisionComponent = EntityResolveComponentsInterface.GetComponent(ri, n"npcCollision") as SimpleColliderComponent;
    this.m_targetingBody = EntityResolveComponentsInterface.GetComponent(ri, n"TargetingChimeraBody") as TargetingComponent;
    this.m_targetingBody.Toggle(false);
  }

  protected cb func OnDeath(evt: ref<gameDeathEvent>) -> Bool {
    StatusEffectHelper.RemoveStatusEffect(this.m_owner, t"Effectors.ChimeraSelfDestructPhase1");
    StatusEffectHelper.RemoveStatusEffect(this.m_owner, t"Effectors.ChimeraSelfDestructPhase2");
    StatusEffectHelper.RemoveStatusEffect(this.m_owner, t"Effectors.ChimeraSelfDestructPhase3");
    StatusEffectHelper.RemoveStatusEffect(this.m_owner, t"Chimera.ChimeraSelfDestructCountdown");
    StatusEffectHelper.RemoveStatusEffect(this.m_owner, t"Chimera.ChimeraBlackWallVFXStatusEffect");
    GameObject.StopReplicatedEffectEvent(this.m_owner, n"self_destruction_stage_1");
    GameObject.StopReplicatedEffectEvent(this.m_owner, n"self_destruction_stage_2");
    GameObject.StopReplicatedEffectEvent(this.m_owner, n"self_destruction_stage_3");
  }

  public final func SetPercentLifeForPhase(value: Float) -> Void {
    this.m_statPoolSystem = GameInstance.GetStatPoolsSystem(this.m_owner.GetGame());
    this.m_statPoolSystem.RequestSettingStatPoolValue(Cast<StatsObjectID>(this.m_ownerId), gamedataStatPoolType.Health, value, this.m_owner, true);
  }

  protected cb func OnStatusEffectApplied(evt: ref<ApplyStatusEffectEvent>) -> Bool {
    let tags: array<CName> = evt.staticData.GameplayTags();
    if ArrayContains(tags, n"ChimeraArenaMode") {
      AnimationControllerComponent.SetAnimWrapperWeight(this.m_owner, n"section3DamagedLocomotion", 1.00);
      if !this.m_defeatedOnAttach {
        this.SetPercentLifeForPhase(90.00);
        this.m_owner.ScheduleAppearanceChange(n"mch_004__militech_chimera__basic_01_fall_damage");
      };
    };
    if ArrayContains(tags, n"ChimeraWeakSpotDestroyed") && StatusEffectSystem.ObjectHasStatusEffect(this.m_owner, t"Chimera.Phase1") {
      this.WithdrawHealthPercentage(this.m_owner, 2.00);
    };
    if ArrayContains(tags, n"ChimeraWeakSpotDestroyed") && StatusEffectSystem.ObjectHasStatusEffect(this.m_owner, t"Chimera.Phase2") {
      this.WithdrawHealthPercentage(this.m_owner, 5.00);
    };
    if StatusEffectSystem.ObjectHasStatusEffect(this.m_owner, t"Minotaur.DefeatedMinotaur") {
      if IsDefined(this.m_npcDeathCollisionComponent) {
        this.m_npcDeathCollisionComponent.Toggle(true);
      };
      this.EnablePhase2HeadVulnerable();
    };
    if StatusEffectSystem.ObjectHasStatusEffect(this.m_owner, t"BaseStatusEffect.SuicideWithGrenade") {
      StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"Chimera.ChimeraDetonateWeakspot", this.m_ownerId);
    };
    if ArrayContains(tags, n"ChimeraWeakSpotToggle") {
      this.SetWeakspotsInvulnerable();
      AnimationControllerComponent.SetAnimWrapperWeight(this.m_owner, n"section1Locomotion", 1.00);
    };
    if ArrayContains(tags, n"Blind") {
      StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"Chimera.ChimeraBlinded", this.m_ownerId);
    };
    if ArrayContains(tags, n"ChimeraCameraHeavyShake") {
      StatusEffectHelper.ApplyStatusEffect(this.m_player, t"BaseStatusEffect.ChimeraStompShake");
    };
    if ArrayContains(tags, n"ChimeraSuicide") && StatusEffectSystem.ObjectHasStatusEffect(this.m_owner, t"Chimera.Phase1") {
      this.SetPercentLifeForPhase(69.90);
    };
    if ArrayContains(tags, n"ChimeraSuicide") && StatusEffectSystem.ObjectHasStatusEffect(this.m_owner, t"Chimera.Phase2") {
      this.SetPercentLifeForPhase(1.00);
    };
    if ArrayContains(tags, n"MemoryWipe") && IsDefined(this.m_targetTrackerComponent) {
      this.m_targetTrackerComponent.ClearThreats();
    };
    if StatusEffectSystem.ObjectHasStatusEffect(this.m_owner, t"Chimera.ChimeraForcePhase2") {
      this.SetPercentLifeForPhase(69.90);
    };
    if StatusEffectSystem.ObjectHasStatusEffect(this.m_owner, t"Chimera.ChimeraForcePhase3") {
      this.SetPercentLifeForPhase(1.00);
    };
  }

  protected cb func OnStatusEffectRemoved(evt: ref<RemoveStatusEffect>) -> Bool {
    let tags: array<CName> = evt.staticData.GameplayTags();
    if ArrayContains(tags, n"ChimeraRepairing") && StatusEffectSystem.ObjectHasStatusEffect(this.m_owner, t"Chimera.Phase2") {
      StatusEffectHelper.RemoveStatusEffect(this.m_owner, t"BaseStatusEffect.BossNoInterrupt");
      this.EnablePhase2HeadVulnerable();
    };
    if ArrayContains(tags, n"ChimeraWeakSpotToggle") {
      this.RemoveWeakspotsInvulnerable();
      AnimationControllerComponent.SetAnimWrapperWeight(this.m_owner, n"section1Locomotion", 0.00);
    };
  }

  protected cb func OnChimeraWeakspotDelayedEvent(evt: ref<ChimeraWeakspotDelayedEvent>) -> Bool {
    this.EnsureWeakspotsInitialized();
  }

  public final func EnsureWeakspotsInitialized() -> Bool {
    let i: Int32;
    let request: ref<ChimeraWeakspotDelayedEvent>;
    let weakspotAttributesEvent: ref<WeakspotRequestAttributeChangeEvent>;
    if !IsDefined(this.m_weakspotComponent) {
      return false;
    };
    if ArraySize(this.m_weakspots) > 0 {
      return true;
    };
    this.m_weakspotComponent.GetWeakspots(this.m_weakspots);
    if ArraySize(this.m_weakspots) == 0 {
      request = new ChimeraWeakspotDelayedEvent();
      this.m_weakspotsDelay = GameInstance.GetDelaySystem(this.m_owner.GetGame()).DelayEvent(this.m_owner, request, 0.10, true);
      return false;
    };
    i = 0;
    while i < ArraySize(this.m_weakspots) {
      if !this.m_weakspots[i].IsDead() {
        weakspotAttributesEvent = new WeakspotRequestAttributeChangeEvent();
        weakspotAttributesEvent.blockDamage = this.m_weakspotsInvulnerable;
        weakspotAttributesEvent.blockHighlight = this.m_weakspotsInvulnerable;
        this.m_weakspots[i].QueueEvent(weakspotAttributesEvent);
      };
      i += 1;
    };
    return true;
  }

  public final func SetWeakspotsInvulnerable() -> Void {
    let i: Int32;
    let weakspotAttributesEvent: ref<WeakspotRequestAttributeChangeEvent>;
    this.m_weakspotsInvulnerable = true;
    if !this.EnsureWeakspotsInitialized() {
      return;
    };
    i = 0;
    while i < ArraySize(this.m_weakspots) {
      if !this.m_weakspots[i].IsDead() {
        weakspotAttributesEvent = new WeakspotRequestAttributeChangeEvent();
        weakspotAttributesEvent.blockDamage = true;
        weakspotAttributesEvent.blockHighlight = true;
        this.m_weakspots[i].QueueEvent(weakspotAttributesEvent);
      };
      i += 1;
    };
  }

  public final func RemoveWeakspotsInvulnerable() -> Void {
    let i: Int32;
    let weakspotAttributesEvent: ref<WeakspotRequestAttributeChangeEvent>;
    this.m_weakspotsInvulnerable = false;
    if !this.EnsureWeakspotsInitialized() {
      return;
    };
    i = 0;
    while i < ArraySize(this.m_weakspots) {
      if !this.m_weakspots[i].IsDead() {
        weakspotAttributesEvent = new WeakspotRequestAttributeChangeEvent();
        weakspotAttributesEvent.blockDamage = false;
        weakspotAttributesEvent.blockHighlight = false;
        this.m_weakspots[i].QueueEvent(weakspotAttributesEvent);
      };
      i += 1;
    };
  }

  private final func WithdrawHealthPercentage(target: ref<NPCPuppet>, valueToSet: Float) -> Void {
    let value: Float = valueToSet;
    this.m_statPoolSystem.RequestChangingStatPoolValue(Cast<StatsObjectID>(this.m_ownerId), gamedataStatPoolType.Health, -value, this.m_owner, false);
  }

  protected cb func OnChangeToPhase2(evt: ref<ChangeToPhase2DelayedEvent>) -> Bool {
    this.ApplyPhase2();
    this.DisablePhase1HitShapes();
    this.EnablePhase2HitShapes();
    this.m_targetingBody.Toggle(true);
  }

  public final func ApplyPhase2() -> Void {
    let ChimeraPhase2EnableDestrutionEvent: ref<ToggleImpulseDestruction> = new ToggleImpulseDestruction();
    ChimeraPhase2EnableDestrutionEvent.enable = true;
    this.m_owner.QueueEvent(ChimeraPhase2EnableDestrutionEvent);
    GameObject.StartReplicatedEffectEvent(this.m_owner, n"explode_phase2");
    StatusEffectHelper.RemoveStatusEffect(this.m_owner, t"Chimera.Phase1");
    StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"Chimera.Phase2", this.m_ownerId);
    StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"Chimera.ChimeraRepairing", this.m_ownerId);
    StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"Chimera.ChimeraHealing", 10.00);
    StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"BaseStatusEffect.BossNoInterrupt", this.m_ownerId);
    GameObject.StartReplicatedEffectEvent(this.m_owner, n"explode_phase2");
    this.SetPercentLifeForPhase(70.00);
  }

  protected cb func OnEnableGasCloud(evt: ref<EnableGasCloudDelayedEvent>) -> Bool {
    this.EnableGasCloud();
  }

  public final func EnableGasCloud() -> Void {
    StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"Chimera.UnlockGasCloud", this.m_ownerId);
  }

  private final func DestroyAllWeakspots() -> Void {
    let i: Int32;
    let scriptWeakspot: ref<ScriptedWeakspotObject>;
    let weakspots: array<wref<WeakspotObject>>;
    this.m_owner.GetWeakspotComponent().GetWeakspots(weakspots);
    if ArraySize(weakspots) > 0 {
      i = 0;
      while i < ArraySize(weakspots) {
        scriptWeakspot = weakspots[i] as ScriptedWeakspotObject;
        scriptWeakspot.DestroyWeakspot(this.m_owner);
        ScriptedWeakspotObject.Kill(weakspots[i]);
        i += 1;
      };
    };
  }

  protected cb func OnChangeToPhase3(evt: ref<ChangeToPhase3DelayedEvent>) -> Bool {
    this.ApplyPhase3();
  }

  public final func ApplyPhase3() -> Void {
    StatusEffectHelper.RemoveStatusEffect(this.m_owner, t"Chimera.Phase2");
    StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"Chimera.Phase3", this.m_ownerId);
    StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"Chimera.InvulnerablePhase3", this.m_ownerId);
    GameObject.StartReplicatedEffectEvent(this.m_owner, n"explode_phase3");
    StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"BaseStatusEffect.BossNoInterrupt", this.m_ownerId);
    this.SetPercentLifeForPhase(1.20);
    this.DestroyAllWeakspots();
  }

  protected final func DisableAllHitShapes() -> Void {
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"Head", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"Front", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"MetalstormRepresentation", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"Head_Vulnerable", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"Front_Vulnerable", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"MetalstormRepresentation_Vulnerable", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"Head_Transition", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"Front_Transition", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"MetalstormRepresentation_Transition", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"LeftFrontLeg", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"LeftLeg", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"LeftBackLeg", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"RightFrontLeg", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"RightBackLeg", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"RightLeg", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"LeftFrontLeg_Vulnerable", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"RightBackLeg_Vulnerable", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"RightLeg_Vulnerable", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"RightFrontLeg_Vulnerable", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"LeftLeg_Vulnerable", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"LeftBackLeg_Vulnerable", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"LeftFrontLeg_b", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"LeftLeg_b", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"LeftBackLeg_b", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"RightFrontLeg_b", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"RightBackLeg_b", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"RightLeg_b", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"LeftFrontLeg_b_Vulnerable", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"RightBackLeg_b_Vulnerable", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"RightLeg_b_Vulnerable", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"RightFrontLeg_b_Vulnerable", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"LeftLeg_b_Vulnerable", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"LeftBackLeg_b_Vulnerable", false);
  }

  protected final func DisablePhase1HitShapes() -> Void {
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"Head", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"Front", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"MetalstormRepresentation", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"LeftFrontLeg", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"LeftLeg", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"LeftBackLeg", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"RightFrontLeg", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"RightBackLeg", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"RightLeg", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"LeftFrontLeg_b", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"LeftLeg_b", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"LeftBackLeg_b", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"RightFrontLeg_b", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"RightBackLeg_b", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"RightLeg_b", false);
  }

  protected final func EnablePhase2HeadVulnerable() -> Void {
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"Head_Transition", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"Head_Vulnerable", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"Front_Transition", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"Front_Vulnerable", false);
    HitShapeUserDataBase.DisableHitShape(this.m_owner, n"MetalstormRepresentation_Transition", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"MetalstormRepresentation_Vulnerable", false);
  }

  protected final func EnablePhase1HitShapes() -> Void {
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"Head", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"Front", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"MetalstormRepresentation", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"LeftFrontLeg", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"LeftLeg", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"LeftBackLeg", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"RightFrontLeg", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"RightBackLeg", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"RightLeg", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"LeftFrontLeg_b", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"LeftLeg_b", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"LeftBackLeg_b", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"RightFrontLeg_b", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"RightBackLeg_b", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"RightLeg_b", false);
  }

  protected final func EnablePhase2HitShapes() -> Void {
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"Head_Transition", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"Front_Transition", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"MetalstormRepresentation_Transition", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"LeftFrontLeg_Vulnerable", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"RightBackLeg_Vulnerable", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"RightLeg_Vulnerable", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"RightFrontLeg_Vulnerable", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"LeftLeg_Vulnerable", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"LeftBackLeg_Vulnerable", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"LeftFrontLeg_b_Vulnerable", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"RightBackLeg_b_Vulnerable", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"RightLeg_b_Vulnerable", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"RightFrontLeg_b_Vulnerable", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"LeftLeg_b_Vulnerable", false);
    HitShapeUserDataBase.EnableHitShape(this.m_owner, n"LeftBackLeg_b_Vulnerable", false);
  }

  protected cb func OnAudioEvent(evt: ref<AudioEvent>) -> Bool {
    let evtFootstep: ref<HeavyFootstepEvent> = new HeavyFootstepEvent();
    let player: wref<PlayerPuppet> = this.GetPlayerSystem().GetLocalPlayerControlledGameObject() as PlayerPuppet;
    if !IsDefined(player) {
      return false;
    };
    if Equals(evt.eventName, n"q302_sc_02_chimera_melee_stomp") || Equals(evt.eventName, n"q302_sc_02_chimera_melee_front_stomp") || Equals(evt.eventName, n"q302_sc_02_chimera_attack_land") {
      evtFootstep.instigator = this.m_owner;
      evtFootstep.audioEventName = evt.eventName;
      player.QueueEvent(evtFootstep);
    };
  }
}
