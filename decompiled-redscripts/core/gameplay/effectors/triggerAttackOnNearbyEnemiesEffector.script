
public class TriggerAttackOnNearbyEnemiesEffector extends Effector {

  public let m_owner: wref<GameObject>;

  public let m_attackRecord: wref<Attack_Record>;

  public let m_targetHowManyEnemies: Int32;

  public let m_targetMaxDistance: Float;

  public let m_targetMinDistance: Float;

  public let m_ignoreCivilians: Bool;

  public let m_gameInstance: GameInstance;

  public let m_playVFXOnHitTargets: CName;

  public let m_statusEffectRecord: wref<StatusEffect_Record>;

  @default(TriggerAttackOnNearbyEnemiesEffector, Chest)
  public let m_enemySlotTransform: CName;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_gameInstance = game;
    this.m_attackRecord = TweakDBInterface.GetAttackRecord(TweakDBInterface.GetForeignKeyDefault(record + t".attackRecord"));
    this.m_targetHowManyEnemies = TDB.GetInt(record + t".targetHowManyEnemies");
    this.m_targetMaxDistance = TDB.GetFloat(record + t".targetMaxDistance");
    this.m_targetMinDistance = TDB.GetFloat(record + t".targetMinDistance");
    this.m_ignoreCivilians = TDB.GetBool(record + t".ignoreCivilians");
    this.m_playVFXOnHitTargets = TDB.GetCName(record + t".playVFXOnHitTargets");
    this.m_statusEffectRecord = TweakDBInterface.GetStatusEffectRecord(TweakDBInterface.GetForeignKeyDefault(record + t".statusEffectRecord"));
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    this.ActionOn(owner);
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    let effectAndDamageEventData: ref<EffectAndDamageEventData>;
    let entity: ref<GameObject>;
    let hitevent: ref<gameHitEvent>;
    let i: Int32;
    let puppet: ref<NPCPuppet>;
    let searchQuery: TargetSearchQuery;
    let targetDistance: Float;
    let targetingComponent: ref<TargetingComponent>;
    let targets: array<TS_TargetPartInfo>;
    let threats: array<wref<Entity>>;
    let hitPrereqState: ref<GenericHitPrereqState> = this.GetPrereqState() as GenericHitPrereqState;
    if !IsDefined(hitPrereqState) {
      return;
    };
    hitevent = hitPrereqState.GetHitEvent();
    this.m_owner = owner;
    if !IsDefined(hitevent.target as ScriptedPuppet) || hitevent.target.IsDead() {
      return;
    };
    searchQuery.testedSet = TargetingSet.Complete;
    searchQuery.searchFilter = TSF_NPC();
    targetDistance = Vector4.Distance(hitevent.target.GetWorldPosition(), this.m_owner.GetWorldPosition());
    searchQuery.maxDistance = targetDistance + this.m_targetMaxDistance;
    searchQuery.filterObjectByDistance = true;
    searchQuery.includeSecondaryTargets = false;
    searchQuery.ignoreInstigator = true;
    GameInstance.GetTargetingSystem(this.m_gameInstance).GetTargetParts(this.m_owner, searchQuery, targets);
    i = 0;
    while i < ArraySize(targets) {
      targetingComponent = TS_TargetPartInfo.GetComponent(targets[i]);
      if !IsDefined(targetingComponent) {
      } else {
        entity = targetingComponent.GetEntity() as GameObject;
        if !IsDefined(entity) || ArrayContains(threats, entity) {
        } else {
          if !this.m_ignoreCivilians {
            ArrayPush(threats, entity);
          } else {
            puppet = entity as NPCPuppet;
            if IsDefined(puppet) && TDBID.IsValid(puppet.GetRecord().ContentAssignmentHandle().GetID()) || entity.IsDevice() {
              ArrayPush(threats, entity);
            };
          };
        };
      };
      i += 1;
    };
    effectAndDamageEventData = new EffectAndDamageEventData();
    effectAndDamageEventData.hitevent = hitevent;
    effectAndDamageEventData.threats = threats;
    effectAndDamageEventData.effectorInstance = this;
    GameInstance.GetDelaySystem(this.m_gameInstance).QueueTask(hitevent.target, effectAndDamageEventData, n"HandleChainLightningEffectAndDamageTask", gameScriptTaskExecutionStage.PostPhysics);
  }

  public final const func GetClosestEnemies(hitevent: ref<gameHitEvent>, threats: [wref<Entity>], out closestEnemies: [ref<ScriptedPuppet>]) -> Void {
    let canRaycastBetweenTwoObjects: Bool;
    let closestEnemiesDistances: array<Float>;
    let distance: Float;
    let enemy: ref<NPCPuppet>;
    let enemyChestWorldPosition: Vector4;
    let enemyChestWorldTransform: WorldTransform;
    let hitOffset: Vector4;
    let hitPosition: Vector4;
    let j: Int32;
    let targetEnemies: array<ref<NPCPuppet>>;
    let targetEnemiesDistances: array<Float>;
    let sqs: ref<SpatialQueriesSystem> = GameInstance.GetSpatialQueriesSystem(this.m_gameInstance);
    let i: Int32 = 0;
    while i < ArraySize(threats) {
      enemy = threats[i] as NPCPuppet;
      if !IsDefined(enemy) || !enemy.IsActive() || enemy.GetEntityID() == this.m_owner.GetEntityID() {
      } else {
        distance = Vector4.Distance(hitevent.target.GetWorldPosition(), enemy.GetWorldPosition());
        if !ArrayContains(targetEnemies, enemy) && distance > this.m_targetMinDistance && distance < this.m_targetMaxDistance {
          ArrayPush(targetEnemies, enemy);
          ArrayPush(targetEnemiesDistances, distance);
        };
      };
      i += 1;
    };
    i = 0;
    while i < ArraySize(targetEnemiesDistances) - 1 {
      j = 0;
      while j < ArraySize(targetEnemiesDistances) - i - 1 {
        if targetEnemiesDistances[j] > targetEnemiesDistances[j + 1] {
          distance = targetEnemiesDistances[j];
          enemy = targetEnemies[j];
          targetEnemiesDistances[j] = targetEnemiesDistances[j + 1];
          targetEnemies[j] = targetEnemies[j + 1];
          targetEnemiesDistances[j + 1] = distance;
          targetEnemies[j + 1] = enemy;
        };
        j += 1;
      };
      i += 1;
    };
    i = 0;
    while i < ArraySize(targetEnemiesDistances) {
      enemy = targetEnemies[i];
      if ArraySize(closestEnemiesDistances) < this.m_targetHowManyEnemies && enemy.GetSlotComponent().GetSlotTransform(this.m_enemySlotTransform, enemyChestWorldTransform) {
        hitOffset = Vector4.Normalize(enemy.GetWorldPosition() - hitevent.target.GetWorldPosition()) * 0.50;
        hitPosition = hitevent.hitPosition + hitOffset;
        enemyChestWorldPosition = WorldPosition.ToVector4(WorldTransform.GetWorldPosition(enemyChestWorldTransform)) - hitOffset;
        canRaycastBetweenTwoObjects = this.CanRaycastBetweenTwoPositions(sqs, hitPosition, enemyChestWorldPosition);
        if canRaycastBetweenTwoObjects {
          ArrayPush(closestEnemiesDistances, targetEnemiesDistances[i]);
          ArrayPush(closestEnemies, targetEnemies[i]);
        };
      } else {
        break;
      };
      i += 1;
    };
  }

  public final const func SendEffectAndDamageToEnemies(hitevent: ref<gameHitEvent>, closestEnemies: [ref<ScriptedPuppet>]) -> Void {
    let attack: ref<Attack_GameEffect>;
    let attackContext: AttackInitContext;
    let distance: Float;
    let effect: ref<EffectInstance>;
    let enemy: ref<ScriptedPuppet>;
    let enemyChestWorldPosition: Vector4;
    let enemyChestWorldTransform: WorldTransform;
    let forwardDir: Vector4;
    let hitPosition: Vector4;
    let i: Int32;
    GameObjectEffectHelper.StartEffectEvent(hitevent.target, this.m_playVFXOnHitTargets);
    StatusEffectHelper.ApplyStatusEffect(hitevent.target, this.m_statusEffectRecord.GetID(), GameObject.GetTDBID(this.m_owner));
    i = 0;
    while i < ArraySize(closestEnemies) {
      enemy = closestEnemies[i];
      attackContext.source = this.m_owner;
      attackContext.record = this.m_attackRecord;
      attackContext.instigator = this.m_owner;
      attack = IAttack.Create(attackContext) as Attack_GameEffect;
      effect = attack.PrepareAttack(this.m_owner);
      enemy.GetSlotComponent().GetSlotTransform(this.m_enemySlotTransform, enemyChestWorldTransform);
      enemyChestWorldPosition = WorldPosition.ToVector4(WorldTransform.GetWorldPosition(enemyChestWorldTransform));
      hitPosition = hitevent.hitPosition + Vector4.Normalize(enemy.GetWorldPosition() - hitevent.target.GetWorldPosition()) * 0.50;
      forwardDir = enemyChestWorldPosition - hitPosition;
      distance = Vector4.Length(forwardDir);
      forwardDir = Vector4.Normalize(forwardDir);
      EffectData.SetVector(effect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.position, hitPosition);
      EffectData.SetVector(effect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.forward, forwardDir);
      EffectData.SetFloat(effect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.range, distance);
      EffectData.SetVector(effect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.raycastEnd, enemyChestWorldPosition);
      effect.Run();
      GameObjectEffectHelper.StartEffectEvent(enemy, this.m_playVFXOnHitTargets);
      StatusEffectHelper.ApplyStatusEffect(enemy, this.m_statusEffectRecord.GetID(), GameObject.GetTDBID(this.m_owner));
      this.SendHitEvent(hitevent, enemy, enemyChestWorldPosition);
      i += 1;
    };
  }

  private final const func SendHitEvent(hitevent: ref<gameHitEvent>, enemy: ref<ScriptedPuppet>, enemyHitWorldPosition: Vector4) -> Void {
    let attackContext: AttackInitContext;
    let hitShapeData: HitShapeData;
    let newhitEvent: ref<gameHitEvent> = new gameHitEvent();
    newhitEvent.attackData = new AttackData();
    newhitEvent.target = enemy;
    attackContext.record = this.m_attackRecord;
    attackContext.instigator = this.m_owner;
    attackContext.source = this.m_owner;
    attackContext.weapon = hitevent.attackData.GetWeapon();
    let attack: ref<IAttack> = IAttack.Create(attackContext);
    newhitEvent.attackData.SetAttackDefinition(attack);
    newhitEvent.attackData.SetInstigator(this.m_owner);
    newhitEvent.attackData.SetSource(this.m_owner);
    newhitEvent.attackData.SetWeapon(hitevent.attackData.GetWeapon());
    newhitEvent.attackData.SetAttackTime(hitevent.attackData.GetAttackTime());
    newhitEvent.attackData.SetAttackType(this.m_attackRecord.AttackType().Type());
    this.AddHitFlags(newhitEvent.attackData);
    hitShapeData.result.hitPositionEnter = enemyHitWorldPosition;
    hitShapeData.result.hitPositionExit = enemyHitWorldPosition;
    ArrayPush(newhitEvent.hitRepresentationResult.hitShapes, hitShapeData);
    GameInstance.GetDamageSystem(this.m_gameInstance).QueueHitEvent(newhitEvent, enemy);
  }

  private final const func AddHitFlags(attackData: ref<AttackData>) -> Void {
    let flag: hitFlag;
    let hitFlags: array<String> = this.m_attackRecord.HitFlags();
    let i: Int32 = 0;
    while i < ArraySize(hitFlags) {
      flag = IntEnum<hitFlag>(Cast<Int32>(EnumValueFromString("hitFlag", hitFlags[i])));
      attackData.AddFlag(flag, n"ChainLightning");
      i += 1;
    };
  }

  private final const func CanRaycastBetweenTwoPositions(spatialQueriesSystem: ref<SpatialQueriesSystem>, hitPosition1: Vector4, hitPosition2: Vector4) -> Bool {
    let raycastResult: TraceResult;
    let hitWorldStatic: Bool = spatialQueriesSystem.SyncRaycastByCollisionPreset(hitPosition1, hitPosition2, n"World Static", raycastResult, true);
    let hitWorldDynamic: Bool = spatialQueriesSystem.SyncRaycastByCollisionPreset(hitPosition1, hitPosition2, n"World Dynamic", raycastResult, true);
    return !hitWorldStatic && !hitWorldDynamic;
  }
}
