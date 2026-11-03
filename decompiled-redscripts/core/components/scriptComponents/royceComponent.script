
public class RoyceComponent extends ScriptableComponent {

  private let m_owner: wref<NPCPuppet>;

  private let m_owner_id: EntityID;

  private let m_npcCollisionComponent: ref<SimpleColliderComponent>;

  private let m_npcDeathCollisionComponent: ref<SimpleColliderComponent>;

  private let m_npcHitRepresentationComponent: ref<IComponent>;

  private let m_statPoolSystem: ref<StatPoolsSystem>;

  private let m_hitData: ref<AnimFeature_HitReactionsData>;

  private let m_weakspotDestroyed: Bool;

  public final func OnGameAttach() -> Void {
    this.m_owner = this.GetOwner() as NPCPuppet;
    this.m_owner_id = this.m_owner.GetEntityID();
    this.m_statPoolSystem = GameInstance.GetStatPoolsSystem(this.m_owner.GetGame());
    this.m_npcDeathCollisionComponent.Toggle(false);
    this.m_weakspotDestroyed = false;
    StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"Royce.Phase1", this.m_owner.GetEntityID());
  }

  protected cb func OnStatusEffectApplied(evt: ref<ApplyStatusEffectEvent>) -> Bool {
    let enableColliderEvent: ref<EnableColliderDelayEvent> = new EnableColliderDelayEvent();
    let tags: array<CName> = evt.staticData.GameplayTags();
    if StatusEffectSystem.ObjectHasStatusEffect(this.m_owner, t"BaseStatusEffect.Defeated") {
      if IsDefined(this.m_npcCollisionComponent) {
        GameInstance.GetDelaySystem(this.m_owner.GetGame()).DelayEvent(this.m_owner, enableColliderEvent, 0.10);
      };
    };
    if ArrayContains(tags, n"BossSuicide") {
      this.SetPercentLifeForPhase(0.00);
    };
    if ArrayContains(tags, n"BossGrenadeHackEffect") {
      StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"BaseStatusEffect.WeakspotDestructionStatusEffect", this.m_owner_id);
    };
  }

  protected cb func OnStatusEffectRemoved(evt: ref<RemoveStatusEffect>) -> Bool {
    let tags: array<CName> = evt.staticData.GameplayTags();
    if ArrayContains(tags, n"Madness") {
      StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"BaseStatusEffect.BossSuicide", this.m_owner.GetEntityID());
    };
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

  private final func DestroyMainWeakspots() -> Void {
    let scriptWeakspot: ref<ScriptedWeakspotObject>;
    let weakspots: array<wref<WeakspotObject>>;
    this.m_owner.GetWeakspotComponent().GetWeakspots(weakspots);
    scriptWeakspot = weakspots[0] as ScriptedWeakspotObject;
    scriptWeakspot.DestroyWeakspot(this.m_owner);
    ScriptedWeakspotObject.Kill(weakspots[0]);
  }

  public final func SetPercentLifeForPhase(value: Float) -> Void {
    this.m_statPoolSystem = GameInstance.GetStatPoolsSystem(this.m_owner.GetGame());
    this.m_statPoolSystem.RequestChangingStatPoolValue(Cast<StatsObjectID>(this.m_owner.GetEntityID()), gamedataStatPoolType.Health, 100.00, this.m_owner, true);
    value = 100.00 - value;
    this.m_statPoolSystem.RequestChangingStatPoolValue(Cast<StatsObjectID>(this.m_owner.GetEntityID()), gamedataStatPoolType.Health, -value, this.m_owner, true);
  }

  protected cb func OnDeathAfterDefeatedRoyce(evt: ref<gameDeathEvent>) -> Bool {
    this.m_npcDeathCollisionComponent.Toggle(true);
  }

  protected cb func OnDefeated(evt: ref<DefeatedEvent>) -> Bool {
    StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"AdamSmasher.InvulnerableDefeated", this.m_owner_id);
  }

  protected cb func OnEnableColliderDelayEvent(enableColliderEvent: ref<EnableColliderDelayEvent>) -> Bool {
    this.m_npcDeathCollisionComponent.Toggle(true);
  }

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    EntityRequestComponentsInterface.RequestComponent(ri, n"npcCollision", n"SimpleColliderComponent", true);
    EntityRequestComponentsInterface.RequestComponent(ri, n"deathCollision", n"SimpleColliderComponent", true);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    this.m_npcCollisionComponent = EntityResolveComponentsInterface.GetComponent(ri, n"npcCollision") as SimpleColliderComponent;
    this.m_npcDeathCollisionComponent = EntityResolveComponentsInterface.GetComponent(ri, n"deathCollision") as SimpleColliderComponent;
  }

  protected cb func OnAudioEvent(evt: ref<AudioEvent>) -> Bool {
    let evtFootstep: ref<HeavyFootstepEvent> = new HeavyFootstepEvent();
    let player: wref<PlayerPuppet> = this.GetPlayerSystem().GetLocalPlayerControlledGameObject() as PlayerPuppet;
    if !IsDefined(player) {
      return false;
    };
    if Equals(evt.eventName, n"lcm_npc_exo_") {
      evtFootstep.instigator = this.m_owner;
      evtFootstep.audioEventName = evt.eventName;
      player.QueueEvent(evtFootstep);
    };
  }

  protected cb func OnDeath(evt: ref<gameDeathEvent>) -> Bool {
    if (this.GetOwner() as ScriptedPuppet).GetHitReactionComponent().GetHitStimEvent().hitBodyPart == 1 {
      this.StartEffect(n"death_head_explode");
      StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"Royce.HeadExploded", this.m_owner.GetEntityID());
    };
  }

  private final func StartEffect(effectName: CName) -> Void {
    let spawnEffectEvent: ref<entSpawnEffectEvent> = new entSpawnEffectEvent();
    spawnEffectEvent.effectName = effectName;
    this.m_owner.QueueEvent(spawnEffectEvent);
  }

  protected cb func OnShotOnShield(hitEvent: ref<gameHitEvent>) -> Bool {
    let empty: HitShapeData;
    let hitShapeData: HitShapeData = hitEvent.hitRepresentationResult.hitShapes[0];
    if NotEquals(hitShapeData, empty) && Equals(HitShapeUserDataBase.GetHitReactionZone(hitShapeData.userData as HitShapeUserDataBase), EHitReactionZone.Special) {
      this.StartEffect(n"weakspot_compensating");
    };
  }
}

public class RoyceHealthChangeListener extends CustomValueStatPoolsListener {

  public let m_owner: wref<NPCPuppet>;

  private let m_royceComponent: ref<RoyceComponent>;

  private let m_weakspots: [wref<WeakspotObject>];

  public func OnStatPoolValueChanged(oldValue: Float, newValue: Float, percToPoints: Float) -> Void;
}
