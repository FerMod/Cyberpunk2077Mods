
public class MeleeHitAnimEventExecutor extends EffectExecutor_Scripted {

  @default(MeleeHitAnimEventExecutor, false)
  private edit let m_ignoreWaterImpacts: Bool;

  private final func SpawnBlockEffects(instigatorWeapon: wref<WeaponObject>, targetWeapon: wref<WeaponObject>) -> Void {
    let instigatorWeaponType: gamedataItemType = instigatorWeapon.GetWeaponRecord().ItemType().Type();
    let targetWeaponType: gamedataItemType = targetWeapon.GetWeaponRecord().ItemType().Type();
    if NotEquals(targetWeaponType, gamedataItemType.Cyb_StrongArms) {
      WeaponObject.TriggerWeaponEffects(targetWeapon, gamedataFxAction.MeleeBlock);
      return;
    };
    if Equals(instigatorWeaponType, gamedataItemType.Wea_Fists) {
      return;
    };
    WeaponObject.TriggerWeaponEffects(instigatorWeapon, gamedataFxAction.MeleeBlock);
  }

  public final func Process(ctx: EffectScriptContext, applierCtx: EffectExecutionScriptContext) -> Bool {
    let aiComponent: ref<AIHumanComponent>;
    let canAttackGuardBreak: Bool;
    let game: GameInstance;
    let hitComponent: ref<HitReactionComponent>;
    let instigatorWeapon: wref<WeaponObject>;
    let isCleavingHit: Bool;
    let meleeHitEvent: ref<MeleeHitEvent>;
    let resetBlockEvent: ref<ResetAttackBlockedBlackBoardValue>;
    let targetPuppet: ref<ScriptedPuppet>;
    let targetWeapon: wref<WeaponObject>;
    let isNPCOrDeviceHit: Bool = false;
    let shouldSendEvents: Bool = true;
    let target: ref<Entity> = EffectExecutionScriptContext.GetTarget(applierCtx);
    let instigatorEntity: ref<Entity> = EffectScriptContext.GetInstigator(ctx);
    let instigatorEntityID: EntityID = instigatorEntity.GetEntityID();
    EffectData.GetBool(EffectScriptContext.GetSharedData(ctx), GetAllBlackboardDefs().EffectSharedData.meleeCleave, isCleavingHit);
    meleeHitEvent = new MeleeHitEvent();
    meleeHitEvent.instigator = instigatorEntity as GameObject;
    meleeHitEvent.target = target as GameObject;
    meleeHitEvent.isStrongAttack = isCleavingHit;
    if IsDefined(target as WeakspotObject) {
      target = (target as WeakspotObject).GetOwner();
    };
    targetPuppet = target as ScriptedPuppet;
    instigatorWeapon = EffectScriptContext.GetWeapon(ctx) as WeaponObject;
    targetWeapon = this.GetTargetWeapon(targetPuppet);
    if IsDefined(targetPuppet) {
      aiComponent = targetPuppet.GetAIControllerComponent();
      hitComponent = targetPuppet.GetHitReactionComponent();
      game = GetGameInstance();
      if this.CanAttackGuardBreak(instigatorEntity, target, instigatorWeapon, targetWeapon, isCleavingHit) {
        canAttackGuardBreak = true;
        AIActionHelper.StartCooldown(targetPuppet, n"ParryStateCooldown", 2.00);
      };
      if !canAttackGuardBreak {
        if GameInstance.GetStatsSystem(game).GetStatValue(Cast<StatsObjectID>(target.GetEntityID()), gamedataStatType.IsDeflecting) == 1.00 && aiComponent.CheckTweakCondition("MeleeParryCondition") {
          aiComponent.GetActionBlackboard().SetBool(GetAllBlackboardDefs().AIAction.attackParried, true);
          resetBlockEvent = new ResetAttackBlockedBlackBoardValue();
          GameInstance.GetDelaySystem(game).DelayEvent(target, resetBlockEvent, 0.10);
          this.SpawnBlockEffects(instigatorWeapon, targetWeapon);
          meleeHitEvent.hitBlocked = true;
        } else {
          if !hitComponent.GetHitAnimationInProgress() && aiComponent.CheckTweakCondition("MeleeBlockCondition") {
            aiComponent.GetActionBlackboard().SetBool(GetAllBlackboardDefs().AIAction.attackBlocked, true);
            resetBlockEvent = new ResetAttackBlockedBlackBoardValue();
            GameInstance.GetDelaySystem(game).DelayEvent(target, resetBlockEvent, 0.10);
            if !hitComponent.GetShouldEvade() && hitComponent.GetCanBlock() {
              this.SpawnBlockEffects(instigatorWeapon, targetWeapon);
              meleeHitEvent.hitBlocked = true;
            } else {
              return true;
            };
          } else {
            isNPCOrDeviceHit = true;
          };
        };
      } else {
        isNPCOrDeviceHit = true;
      };
    } else {
      if IsDefined(target as SensorDevice) {
        isNPCOrDeviceHit = true;
      } else {
        if this.m_ignoreWaterImpacts {
          shouldSendEvents = !EffectExecutionScriptContext.IsTargetWater(applierCtx);
        };
      };
    };
    if shouldSendEvents {
      if isNPCOrDeviceHit {
        AnimationControllerComponent.PushEvent(EffectScriptContext.GetInstigator(ctx) as GameObject, n"MeleeHitNPC");
        AnimationControllerComponent.PushEvent(instigatorWeapon, n"MeleeHitNPC");
      } else {
        AnimationControllerComponent.PushEvent(EffectScriptContext.GetInstigator(ctx) as GameObject, n"MeleeHitStatic");
        AnimationControllerComponent.PushEvent(instigatorWeapon, n"MeleeHitStatic");
      };
      instigatorEntity.QueueEventForEntityID(instigatorEntityID, meleeHitEvent);
      instigatorEntity.QueueEventForEntityID(instigatorWeapon.GetEntityID(), meleeHitEvent);
      this.TriggerSingleStimuliOnHit(ctx, applierCtx, gamedataStimType.SoundDistraction);
    };
    return true;
  }

  private final func GetTargetWeapon(target: wref<ScriptedPuppet>) -> wref<WeaponObject> {
    let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(target.GetGame());
    let item: wref<ItemObject> = transactionSystem.GetItemInSlot(target, t"AttachmentSlots.WeaponRight");
    if !IsDefined(item) {
      item = transactionSystem.GetItemInSlot(target, t"AttachmentSlots.WeaponLeft");
    };
    return item as WeaponObject;
  }

  private final func CanAttackGuardBreak(instigator: wref<Entity>, target: wref<Entity>, instigatorWeapon: wref<WeaponObject>, targetWeapon: wref<WeaponObject>, strongAttack: Bool) -> Bool {
    let attackSpeed: Float;
    let canBlock: Bool;
    let currentWeaponState: Int32;
    let hasKerenzikov: Bool;
    let instigatorEvadeBreakImpulse: Float;
    let instigatorEvadeImpulse: Float;
    let instigatorEvadeImpulseCumulation: Float;
    let instigatorGuardBreakImpulse: Float;
    let instigatorWeaponType: gamedataItemType;
    let stamina: Float;
    let targetEvadeImpulse: Float;
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem((instigator as ScriptedPuppet).GetGame());
    let playerPuppet: ref<PlayerPuppet> = instigator as PlayerPuppet;
    let targetPuppet: ref<ScriptedPuppet> = target as ScriptedPuppet;
    if IsDefined(playerPuppet) && IsDefined(targetPuppet) {
      if !targetPuppet.IsBoss() && playerPuppet.GetIsInFastFinisher() && targetPuppet.IsInFinisherHealthThreshold(playerPuppet) {
        return true;
      };
    };
    if IsDefined(playerPuppet) && statsSystem.GetStatValue(Cast<StatsObjectID>(target.GetEntityID()), gamedataStatType.CounterattackGuardbreakImmunity) == 0.00 {
      currentWeaponState = playerPuppet.GetPlayerStateMachineBlackboard().GetInt(GetAllBlackboardDefs().PlayerStateMachine.MeleeWeapon);
      if currentWeaponState == 20 {
        return true;
      };
    };
    instigatorGuardBreakImpulse = statsSystem.GetStatValue(Cast<StatsObjectID>(instigatorWeapon.GetEntityID()), gamedataStatType.KnockdownImpulse);
    if strongAttack {
      instigatorGuardBreakImpulse *= 2.67;
    };
    instigatorEvadeImpulse = statsSystem.GetStatValue(Cast<StatsObjectID>(instigatorWeapon.GetEntityID()), gamedataStatType.BaseKnockdownImpulse);
    attackSpeed = statsSystem.GetStatValue(Cast<StatsObjectID>(instigatorWeapon.GetEntityID()), gamedataStatType.AttackSpeed);
    if attackSpeed == 0.00 {
      attackSpeed = 1.00;
    };
    instigatorEvadeImpulseCumulation = statsSystem.GetStatValue(Cast<StatsObjectID>(instigatorWeapon.GetEntityID()), gamedataStatType.EvadeImpulse);
    instigatorEvadeImpulseCumulation *= 1.00 / attackSpeed;
    instigatorEvadeBreakImpulse = 100.00 / instigatorEvadeImpulseCumulation;
    targetEvadeImpulse = statsSystem.GetStatValue(Cast<StatsObjectID>(targetWeapon.GetEntityID()), gamedataStatType.BaseKnockdownImpulse);
    instigatorWeaponType = instigatorWeapon.GetWeaponRecord().ItemType().Type();
    canBlock = statsSystem.GetStatValue(Cast<StatsObjectID>(target.GetEntityID()), gamedataStatType.CanBlock) >= 1.00;
    hasKerenzikov = statsSystem.GetStatValue(Cast<StatsObjectID>(target.GetEntityID()), gamedataStatType.HasKerenzikov) >= 1.00;
    stamina = statsSystem.GetStatValue(Cast<StatsObjectID>(target.GetEntityID()), gamedataStatType.Stamina);
    if instigatorEvadeImpulse > targetEvadeImpulse || Equals(targetWeapon.GetWeaponRecord().ItemType().Type(), gamedataItemType.Wea_Fists) && NotEquals(instigatorWeaponType, gamedataItemType.Wea_Fists) && NotEquals(instigatorWeaponType, gamedataItemType.Cyb_StrongArms) {
      if hasKerenzikov {
        if instigatorEvadeBreakImpulse >= stamina / 2.00 {
          return true;
        };
        return false;
      };
      return true;
    };
    if !canBlock && hasKerenzikov {
      if instigatorEvadeBreakImpulse >= stamina / 2.00 {
        return true;
      };
      return false;
    };
    if instigatorGuardBreakImpulse >= stamina {
      if hasKerenzikov {
        if instigatorEvadeBreakImpulse >= stamina / 2.00 {
          return true;
        };
        return false;
      };
      return true;
    };
    return false;
  }

  private final func TriggerSingleStimuliOnHit(ctx: EffectScriptContext, applierCtx: EffectExecutionScriptContext, stimToSend: gamedataStimType) -> Void {
    let effect: ref<EffectInstance>;
    let stimuliEvent: ref<StimuliEvent>;
    let position: Vector4 = EffectExecutionScriptContext.GetHitPosition(applierCtx);
    if !Vector4.IsZero(position) && !this.IsMuted(ctx, applierCtx) {
      stimuliEvent = new StimuliEvent();
      stimuliEvent.sourcePosition = position;
      stimuliEvent.sourceObject = EffectScriptContext.GetInstigator(ctx) as GameObject;
      stimuliEvent.SetStimType(stimToSend);
      this.GetStimuliData("stims." + EnumValueToString("gamedataStimType", Cast<Int64>(EnumInt(stimToSend))) + "Stimuli", stimuliEvent);
      effect = GameInstance.GetGameEffectSystem(GetGameInstance()).CreateEffectStatic(n"stimuli", n"stimuli_range", EffectScriptContext.GetSource(ctx));
      EffectData.SetVariant(effect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.stimuliEvent, ToVariant(stimuliEvent));
      EffectData.SetVector(effect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.position, position);
      EffectData.SetBool(effect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.stimuliRaycastTest, false);
      EffectData.SetFloat(effect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.radius, stimuliEvent.radius);
      GameInstance.GetStimuliSystem(GetGameInstance()).BroadcastStimuli(effect);
    };
  }

  private final func GetStimuliData(const path: script_ref<String>, out stimToProcess: ref<StimuliEvent>) -> Void {
    let sid: TweakDBID = TDBID.Create(Deref(path));
    let stimRecord: ref<Stim_Record> = TweakDBInterface.GetStimRecord(sid);
    stimToProcess.stimRecord = stimRecord;
    stimToProcess.radius = stimRecord.Radius();
    stimToProcess.stimPropagation = stimRecord.Propagation().Type();
  }

  private final func IsMuted(ctx: EffectScriptContext, applierCtx: EffectExecutionScriptContext) -> Bool {
    let sourceMuted: Bool = GameInstance.GetStatusEffectSystem(EffectScriptContext.GetGameInstance(ctx)).HasStatusEffect(EffectScriptContext.GetSource(ctx).GetEntityID(), t"BaseStatusEffect.MuteAudioStims");
    return sourceMuted;
  }
}

public class MeleeHitTerminateGameEffectExecutor extends EffectExecutor_Scripted {

  @default(MeleeHitTerminateGameEffectExecutor, false)
  private edit let m_ignoreWaterImpacts: Bool;

  public final func Process(ctx: EffectScriptContext, applierCtx: EffectExecutionScriptContext) -> Bool {
    let isCleavingHit: Bool = false;
    let continueProcessing: Bool = true;
    if IsDefined(EffectScriptContext.GetInstigator(ctx) as PlayerPuppet) {
      if this.m_ignoreWaterImpacts && (EffectExecutionScriptContext.IsTargetWater(applierCtx) || EffectExecutionScriptContext.GetHitThroughWaterSurface(applierCtx)) {
        return continueProcessing;
      };
      EffectData.GetBool(EffectScriptContext.GetSharedData(ctx), GetAllBlackboardDefs().EffectSharedData.meleeCleave, isCleavingHit);
      continueProcessing = isCleavingHit;
    };
    return continueProcessing;
  }
}
