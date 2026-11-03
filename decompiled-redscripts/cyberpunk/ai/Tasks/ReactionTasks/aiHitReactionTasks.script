
public abstract class AIHitReactionTask extends AIbehaviortaskScript {

  protected let m_activationTimeStamp: Float;

  private let m_reactionDuration: Float;

  private let m_hitReactionAction: ref<ActionHitReactionScriptProxy>;

  private let m_hitReactionType: animHitReactionType;

  public final func Dispose() -> Void {
    this.m_hitReactionAction = null;
  }

  private func OnActivate(context: ScriptExecutionContext) -> Void;

  private func OnUpdate(context: ScriptExecutionContext, aiTime: Float) -> Void;

  private func OnDeactivate(context: ScriptExecutionContext) -> Void;

  private func GetHitReactionType() -> animHitReactionType {
    return animHitReactionType.None;
  }

  private func GetDesiredHitReactionDuration(context: ScriptExecutionContext) -> Float {
    return -1.00;
  }

  private func GetHitReactionDurationWithInterrupt(context: ScriptExecutionContext) -> Float {
    let aiComponent: ref<AIHumanComponent>;
    let hitCountInCombo: Int32;
    let hitReaction: ref<AnimFeature_HitReactionsData>;
    let hitReactionComponent: ref<HitReactionComponent>;
    let hitReactionType: Int32;
    let meleeHitChainBeforeBreaking: Int32;
    let rangedHitChainBeforeBreaking: Int32;
    let weapon: wref<WeaponObject>;
    if AIBehaviorScriptBase.GetPuppet(context).IsCrowd() {
      return this.GetDesiredHitReactionDuration(context);
    };
    hitReactionComponent = AIBehaviorScriptBase.GetHitReactionComponent(context);
    hitReactionType = hitReactionComponent.GetHitReactionType();
    if hitReactionType == 9 {
      return this.GetDesiredHitReactionDuration(context);
    };
    weapon = GameObject.GetActiveWeapon(ScriptExecutionContext.GetOwner(context));
    if !IsDefined(weapon) {
      return this.GetDesiredHitReactionDuration(context);
    };
    if hitReactionType == 5 {
      if weapon.IsMelee() {
        hitReaction = hitReactionComponent.GetLastHitReactionData();
        if hitReaction.hitBodyPart == 5 || hitReaction.hitBodyPart == 6 {
          ScriptExecutionContext.GetOwner(context).SetIndividualTimeDilation(n"MeleeLegKnockdown", 1.60, 0.50, n"None", n"None");
        };
      };
      return this.GetDesiredHitReactionDuration(context);
    };
    hitCountInCombo = hitReactionComponent.GetHitCountInCombo();
    meleeHitChainBeforeBreaking = hitReactionComponent.GetMeleeMaxHitChain();
    if meleeHitChainBeforeBreaking > -1 && weapon.IsMelee() && hitCountInCombo < meleeHitChainBeforeBreaking {
      return this.GetDesiredHitReactionDuration(context);
    };
    rangedHitChainBeforeBreaking = hitReactionComponent.GetRangedMaxHitChain();
    if rangedHitChainBeforeBreaking > -1 && weapon.IsRanged() && hitCountInCombo < rangedHitChainBeforeBreaking {
      return this.GetDesiredHitReactionDuration(context);
    };
    if hitReactionComponent.GetHitReactionData().hitSource != 0 && hitReactionType != 8 && hitReactionType != 10 {
      aiComponent = AIBehaviorScriptBase.GetPuppet(context).GetAIControllerComponent();
      if NotEquals(aiComponent.GetCombatMode(), AIbehaviorCombatModes.Default) && aiComponent.CheckTweakCondition("DodgeAfterHitReactionCondition") {
        hitReactionComponent.ResetHitCount();
        hitReaction = hitReactionComponent.GetLastHitReactionData();
        if weapon.IsRanged() {
          if hitReactionType == 3 {
            if !this.IsTumbleStagger(hitReaction) {
              return 2.10;
            };
            return 2.40;
          };
          return 0.30;
        };
        if hitReactionType == 3 && !this.IsTumbleStagger(hitReaction) {
          return 0.45;
        };
        return 0.30;
      };
    };
    return this.GetDesiredHitReactionDuration(context);
  }

  protected final func IsTumbleStagger(hitReaction: ref<AnimFeature_HitReactionsData>) -> Bool {
    if !IsDefined(hitReaction) {
      return false;
    };
    if hitReaction.hitBodyPart == 1 {
      if hitReaction.hitDirection == 2 {
        return true;
      };
      switch hitReaction.animVariation {
        case 0:
          return true;
        case 1:
          return true;
        case 2:
          return true;
        case 3:
          return true;
        case 4:
          return true;
        case 5:
          return true;
        case 6:
          return true;
        case 7:
          return true;
        case 8:
          return true;
        case 9:
          return true;
        case 10:
          return true;
        case 11:
          return true;
        case 12:
          return true;
        case 13:
          return true;
        case 14:
          return true;
        case 15:
          return true;
        case 16:
          return true;
        case 20:
          return true;
        case 21:
          return true;
        case 22:
          return true;
        case 24:
          return true;
        case 25:
          return true;
        default:
          return false;
      };
    };
    if hitReaction.hitBodyPart == 2 {
      switch hitReaction.animVariation {
        case 1:
          return true;
        case 2:
          return true;
        case 5:
          return true;
        case 10:
          return true;
        case 11:
          return true;
        case 13:
          return true;
        case 14:
          return true;
        case 16:
          return true;
        case 17:
          return true;
        case 19:
          return true;
        case 20:
          return true;
        case 22:
          return true;
        case 23:
          return true;
        case 25:
          return true;
        case 26:
          return true;
        default:
          return false;
      };
    };
    if hitReaction.hitBodyPart == 3 {
      switch hitReaction.animVariation {
        case 2:
          return true;
        case 5:
          return true;
        case 8:
          return true;
        case 11:
          return true;
        case 12:
          return true;
        case 13:
          return true;
        case 17:
          return true;
        case 20:
          return true;
        case 21:
          return true;
        case 22:
          return true;
        case 24:
          return true;
        case 25:
          return true;
        case 26:
          return true;
        default:
          return false;
      };
    };
    if hitReaction.hitBodyPart == 5 {
      return true;
    };
    if hitReaction.hitBodyPart == 6 {
      return true;
    };
    return false;
  }

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let clearFearEvent: ref<ClearFearOnHitEvent>;
    let puppet: ref<ScriptedPuppet> = AIBehaviorScriptBase.GetPuppet(context);
    this.m_hitReactionAction = AIBehaviorScriptBase.GetHitReactionComponent(context).GetHitReactionProxyAction();
    this.m_reactionDuration = this.GetHitReactionDurationWithInterrupt(context);
    NPCPuppet.ChangeUpperBodyState(ScriptExecutionContext.GetOwner(context), gamedataNPCUpperBodyState.ChargedAttack);
    if puppet.IsCrowd() {
      puppet.GetCrowdMemberComponent().TryStopTrafficMovement();
      clearFearEvent = new ClearFearOnHitEvent();
      puppet.QueueEvent(clearFearEvent);
    };
    this.InitialiseReaction(context);
  }

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let aiTime: Float;
    if this.CheckForReevaluation(context) {
      this.InitialiseReaction(context);
    };
    aiTime = EngineTime.ToFloat(ScriptExecutionContext.GetAITime(context));
    this.OnUpdate(context, aiTime);
    if aiTime < this.m_activationTimeStamp + this.m_reactionDuration {
      return AIbehaviorUpdateOutcome.IN_PROGRESS;
    };
    return AIbehaviorUpdateOutcome.SUCCESS;
  }

  protected func Deactivate(context: ScriptExecutionContext) -> Void {
    this.OnDeactivate(context);
    NPCPuppet.ChangeUpperBodyState(ScriptExecutionContext.GetOwner(context), gamedataNPCUpperBodyState.Normal);
    if IsDefined(this.m_hitReactionAction) {
      this.m_hitReactionAction.Stop();
    };
  }

  private final func CheckForReevaluation(context: ScriptExecutionContext) -> Bool {
    if !this.IsThisFrameActivationFrame(context) && AIBehaviorScriptBase.GetPuppet(context).GetHitReactionComponent().GetHitStimEvent() != null {
      if AIBehaviorScriptBase.GetPuppet(context).GetHitReactionComponent().GetHitStimEvent().hitType == 8 || AIBehaviorScriptBase.GetPuppet(context).GetHitReactionComponent().GetHitStimEvent().hitType == 10 {
        return true;
      };
      if AIBehaviorScriptBase.GetPuppet(context).GetHitReactionComponent().GetHitStimEvent().hitSource == 1 {
        return true;
      };
    };
    return false;
  }

  private final func AngleToAttackSource(context: ScriptExecutionContext, hitData: ref<AnimFeature_HitReactionsData>) -> Float {
    let finalAngleToAttackSource: Float;
    let finalHitDirection: Int32;
    if hitData.hitSource == 0 {
      switch (ScriptExecutionContext.GetOwner(context) as NPCPuppet).GetHitReactionComponent().GetHitReactionData().hitDirection {
        case 4:
          finalAngleToAttackSource = 180.00;
          break;
        case 1:
          finalAngleToAttackSource = 270.00;
          break;
        case 2:
          finalAngleToAttackSource = 0.00;
          break;
        case 3:
          finalAngleToAttackSource = 90.00;
          break;
        default:
      };
    } else {
      finalHitDirection = GameObject.GetTargetAngleInInt(AIBehaviorScriptBase.GetPuppet(context).GetHitReactionComponent().GetHitInstigator(), AIBehaviorScriptBase.GetPuppet(context));
      if finalHitDirection == 0 {
        finalHitDirection = 4;
      };
      switch finalHitDirection {
        case 2:
          finalAngleToAttackSource = 0.00;
          break;
        case 3:
          finalAngleToAttackSource = 90.00;
          break;
        case 4:
          finalAngleToAttackSource = 180.00;
          break;
        case 1:
          finalAngleToAttackSource = 270.00;
          break;
        default:
      };
    };
    return finalAngleToAttackSource;
  }

  private final func IsThisFrameActivationFrame(context: ScriptExecutionContext) -> Bool {
    if this.m_activationTimeStamp == EngineTime.ToFloat(ScriptExecutionContext.GetAITime(context)) {
      return true;
    };
    return false;
  }

  private final func InitialiseReaction(context: ScriptExecutionContext) -> Void {
    HitReactionComponent.ClearHitStim(ScriptExecutionContext.GetOwner(context));
    this.m_activationTimeStamp = EngineTime.ToFloat(ScriptExecutionContext.GetAITime(context));
    this.SendDataToAnimationGraph(context);
    this.SendDataToHitReactionComponent(context);
    this.OnActivate(context);
  }

  private final func SendDataToHitReactionComponent(context: ScriptExecutionContext) -> Void {
    let hitReactionBehaviorData: ref<HitReactionBehaviorData> = new HitReactionBehaviorData();
    hitReactionBehaviorData.m_hitReactionType = this.GetHitReactionType();
    hitReactionBehaviorData.m_hitReactionActivationTimeStamp = this.m_activationTimeStamp;
    hitReactionBehaviorData.m_hitReactionDuration = this.m_reactionDuration;
    let setLastHitDataEvent: ref<LastHitDataEvent> = new LastHitDataEvent();
    setLastHitDataEvent.hitReactionBehaviorData = hitReactionBehaviorData;
    AIBehaviorScriptBase.GetPuppet(context).QueueEvent(setLastHitDataEvent);
  }

  private final func SendDataToAnimationGraph(context: ScriptExecutionContext) -> Void {
    let instigatorYaw: Float;
    let victimYaw: Float;
    let weapon: ref<WeaponObject>;
    let owner: ref<NPCPuppet> = ScriptExecutionContext.GetOwner(context) as NPCPuppet;
    let hitData: ref<AnimFeature_HitReactionsData> = new AnimFeature_HitReactionsData();
    hitData = AIBehaviorScriptBase.GetHitReactionComponent(context).GetHitReactionData();
    hitData.angleToAttack = this.AngleToAttackSource(context, hitData);
    if hitData.hitSource != 0 {
      instigatorYaw = Vector4.Heading(owner.GetHitReactionComponent().GetHitInstigator().GetWorldForward());
      victimYaw = Vector4.Heading(owner.GetWorldForward());
      hitData.hitDirectionWs = Vector4.RotByAngleXY(owner.GetWorldForward(), victimYaw - instigatorYaw);
    } else {
      hitData.hitDirectionWs = owner.GetLastHitAttackDirection();
    };
    if owner.GetBoolFromCharacterTweak("Hit_Initial_Rotation_Disabled") || Vector4.IsZero(hitData.hitDirectionWs) {
      hitData.useInitialRotation = false;
    } else {
      hitData.useInitialRotation = true;
    };
    hitData.initialRotationDuration = 0.10;
    if hitData.hitType == 8 {
      AnimationControllerComponent.ApplyFeatureToReplicate(owner, n"hit", hitData);
      AnimationControllerComponent.PushEventToReplicate(owner, n"PlayBlock");
    } else {
      if hitData.hitType == 10 {
        AnimationControllerComponent.ApplyFeatureToReplicate(owner, n"hit", hitData);
        AnimationControllerComponent.PushEventToReplicate(owner, n"PlayParry");
      } else {
        if IsDefined(this.m_hitReactionAction) {
          if hitData.hitType == 4 {
            if hitData.hitBodyPart == 2 || hitData.hitBodyPart == 3 {
              if owner.GetAIControllerComponent().CheckTweakCondition("WoundedArmHandgunCondition") {
                hitData.animVariation = 0;
              } else {
                if owner.GetAIControllerComponent().CheckTweakCondition("WoundedArmKnifeCondition") {
                  hitData.animVariation = 1;
                } else {
                  hitData.animVariation = 2;
                };
              };
            } else {
              weapon = GameInstance.GetTransactionSystem(owner.GetGame()).GetItemInSlot(owner, t"AttachmentSlots.WeaponRight") as WeaponObject;
              if !IsDefined(weapon) {
                weapon = GameInstance.GetTransactionSystem(owner.GetGame()).GetItemInSlot(owner, t"AttachmentSlots.WeaponLeft") as WeaponObject;
              };
              if !this.HasDismemberedLeg(context) && (Equals(TweakDBInterface.GetWeaponItemRecord(ItemID.GetTDBID(weapon.GetItemID())).ItemType().Type(), gamedataItemType.Wea_Handgun) || Equals(TweakDBInterface.GetWeaponItemRecord(ItemID.GetTDBID(weapon.GetItemID())).ItemType().Type(), gamedataItemType.Wea_Revolver)) {
                hitData.animVariation = 0;
              } else {
                if !this.HasDismemberedLeg(context) && Equals(TweakDBInterface.GetWeaponItemRecord(ItemID.GetTDBID(weapon.GetItemID())).ItemType().Type(), gamedataItemType.Wea_Knife) {
                  hitData.animVariation = 1;
                } else {
                  if !this.HasDismemberedLeg(context) && (Equals(TweakDBInterface.GetWeaponItemRecord(ItemID.GetTDBID(weapon.GetItemID())).ItemType().Type(), gamedataItemType.Wea_Fists) || Equals(TweakDBInterface.GetWeaponItemRecord(ItemID.GetTDBID(weapon.GetItemID())).ItemType().Type(), gamedataItemType.Cyb_StrongArms)) || !this.HasDismemberedLeg(context) && !IsDefined(weapon) {
                    hitData.animVariation = 2;
                  } else {
                    hitData.animVariation = 3;
                  };
                };
              };
            };
          };
          this.m_hitReactionAction.Stop();
          this.m_hitReactionAction.Setup(hitData);
          this.m_hitReactionAction.Launch();
          AnimationControllerComponent.ApplyFeatureToReplicate(owner, n"hit", hitData);
        };
      };
    };
  }

  protected final func SpawnAttackGameEffect(context: ScriptExecutionContext, gameEffect: EffectRef, startPosition: Vector4, endPosition: Vector4, duration: Float, colliderBoxSize: Vector4, const statusEffect: script_ref<String>) -> Void {
    let attackDirectionWorld: Vector4;
    let attackEndPositionWorld: Vector4;
    let attackStartPositionWorld: Vector4;
    let puppetWorldForward: Vector4;
    let puppetWorldTransform: Transform;
    let storedEffect: ref<EffectInstance>;
    let npcPuppet: ref<NPCPuppet> = ScriptExecutionContext.GetOwner(context) as NPCPuppet;
    let puppetWorldPosition: Vector4 = npcPuppet.GetWorldPosition();
    puppetWorldPosition.Z += 1.50;
    puppetWorldForward = npcPuppet.GetWorldForward();
    Transform.SetPosition(puppetWorldTransform, puppetWorldPosition);
    Transform.SetOrientationFromDir(puppetWorldTransform, puppetWorldForward);
    attackStartPositionWorld = Transform.TransformPoint(puppetWorldTransform, startPosition);
    attackEndPositionWorld = Transform.TransformPoint(puppetWorldTransform, endPosition);
    attackDirectionWorld = attackEndPositionWorld - attackStartPositionWorld;
    storedEffect = GameInstance.GetGameEffectSystem(ScriptExecutionContext.GetOwner(context).GetGame()).CreateEffect(gameEffect, npcPuppet, npcPuppet);
    EffectData.SetVector(storedEffect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.box, colliderBoxSize);
    EffectData.SetFloat(storedEffect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.duration, duration);
    EffectData.SetVector(storedEffect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.position, attackStartPositionWorld);
    EffectData.SetQuat(storedEffect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.rotation, Transform.GetOrientation(puppetWorldTransform));
    EffectData.SetVector(storedEffect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.forward, Vector4.Normalize(attackDirectionWorld));
    EffectData.SetFloat(storedEffect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.range, Vector4.Length(attackDirectionWorld));
    if NotEquals(statusEffect, "") {
      EffectData.SetString(storedEffect.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.effectName, Deref(statusEffect));
    };
    storedEffect.Run();
  }

  private final func HasDismemberedLeg(context: ScriptExecutionContext) -> Bool {
    if StatusEffectSystem.ObjectHasStatusEffect(AIBehaviorScriptBase.GetPuppet(context), t"BaseStatusEffect.DismemberedLegLeft") || StatusEffectSystem.ObjectHasStatusEffect(AIBehaviorScriptBase.GetPuppet(context), t"BaseStatusEffect.DismemberedLegRight") {
      return true;
    };
    return false;
  }

  private final func GetBCVOName(context: ScriptExecutionContext) -> CName {
    let damage: Float = AIBehaviorScriptBase.GetHitReactionComponent(context).GetCumulatedDamage();
    let ownerHealth: Float = GameInstance.GetStatPoolsSystem(ScriptExecutionContext.GetOwner(context).GetGame()).GetStatPoolMaxPointValue(Cast<StatsObjectID>(ScriptExecutionContext.GetOwner(context).GetEntityID()), gamedataStatPoolType.Health);
    if damage > ownerHealth * TweakDBInterface.GetFloat(t"AIGeneralSettings.damageThresholdBattleCry", 0.00) {
      return n"battlecry_curse";
    };
    return n"battlecry_morale";
  }
}

public class ImpactReactionTask extends AIHitReactionTask {

  public let m_tweakDBPackage: TweakDBID;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let broadcaster: ref<StimBroadcasterComponent>;
    let hitData: ref<AnimFeature_HitReactionsData> = new AnimFeature_HitReactionsData();
    hitData = AIBehaviorScriptBase.GetHitReactionComponent(context).GetHitReactionData();
    if hitData.hitSource != 0 && ScriptedPuppet.CanRagdoll(ScriptExecutionContext.GetOwner(context)) {
      StatusEffectHelper.ApplyStatusEffect(ScriptExecutionContext.GetOwner(context), t"BaseStatusEffect.UncontrolledMovement_RagdollOffLedge");
    };
    GameObject.PlayVoiceOver(ScriptExecutionContext.GetOwner(context), n"hit_reaction_light", n"Scripts:ImpactReactionTask");
    broadcaster = ScriptExecutionContext.GetOwner(context).GetStimBroadcasterComponent();
    if IsDefined(broadcaster) {
      broadcaster.TriggerSingleBroadcast(ScriptExecutionContext.GetOwner(context), gamedataStimType.Attention);
    };
    super.Activate(context);
  }

  private func GetHitReactionType() -> animHitReactionType {
    return animHitReactionType.Impact;
  }

  private func GetDesiredHitReactionDuration(context: ScriptExecutionContext) -> Float {
    let duration: Float;
    this.m_tweakDBPackage = t"AIGeneralSettings";
    if AIBehaviorScriptBase.GetPuppet(context).GetHitReactionComponent().GetHitStimEvent().hitSource == 1 || AIBehaviorScriptBase.GetPuppet(context).GetHitReactionComponent().GetHitStimEvent().hitSource == 2 || AIBehaviorScriptBase.GetPuppet(context).GetHitReactionComponent().GetHitStimEvent().hitSource == 3 {
      duration = AITweakParams.GetFloatFromTweak(this.m_tweakDBPackage, "impact_melee_duration");
    } else {
      duration = AITweakParams.GetFloatFromTweak(this.m_tweakDBPackage, "impact_ranged_duration");
    };
    if duration > 0.00 {
      return duration;
    };
    return 0.60;
  }
}

public class StaggerReactionTask extends AIHitReactionTask {

  public let m_tweakDBPackage: TweakDBID;

  public let m_tumble: Bool;

  public let m_onUpdateCompleted: Bool;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    GameObject.PlayVoiceOver(ScriptExecutionContext.GetOwner(context), n"hit_reaction_heavy", n"Scripts:StaggerReactionTask");
    StatusEffectHelper.ApplyStatusEffect(ScriptExecutionContext.GetOwner(context), t"BaseStatusEffect.HitReactionStagger");
    if ScriptedPuppet.IsPlayerCompanion(ScriptExecutionContext.GetOwner(context)) {
      GameObject.PlayVoiceOver(ScriptExecutionContext.GetOwner(context), n"battlecry_curse", n"Scripts:CompanionStaggerReactionTask");
    };
    if ScriptedPuppet.CanRagdoll(ScriptExecutionContext.GetOwner(context)) {
      StatusEffectHelper.ApplyStatusEffect(ScriptExecutionContext.GetOwner(context), t"BaseStatusEffect.UncontrolledMovement_RagdollOffLedge");
    };
    super.Activate(context);
  }

  private func GetHitReactionType() -> animHitReactionType {
    return animHitReactionType.Stagger;
  }

  private func GetDesiredHitReactionDuration(context: ScriptExecutionContext) -> Float {
    let duration: Float;
    this.m_tweakDBPackage = t"AIGeneralSettings";
    let puppet: ref<ScriptedPuppet> = AIBehaviorScriptBase.GetPuppet(context);
    let valid: Bool = IsDefined(puppet.GetHitReactionComponent()) && IsDefined(puppet.GetHitReactionComponent().GetHitStimEvent());
    if valid && (puppet.GetHitReactionComponent().GetHitStimEvent().hitSource == 1 || puppet.GetHitReactionComponent().GetHitStimEvent().hitSource == 2) {
      duration = AITweakParams.GetFloatFromTweak(this.m_tweakDBPackage, "stagger_melee_duration");
    } else {
      if valid && puppet.GetHitReactionComponent().GetHitStimEvent().hitSource == 3 && puppet.GetHitReactionComponent().GetHitStimEvent().hitDirection == 4 {
        duration = AITweakParams.GetFloatFromTweak(this.m_tweakDBPackage, "quickMelee_duration");
      } else {
        duration = AITweakParams.GetFloatFromTweak(this.m_tweakDBPackage, "stagger_ranged_duration");
      };
    };
    if duration > 0.00 {
      return duration;
    };
    return 1.50;
  }

  private func OnUpdate(context: ScriptExecutionContext, aiTime: Float) -> Void {
    if !this.m_onUpdateCompleted && this.IsTumbleStagger(AIBehaviorScriptBase.GetHitReactionComponent(context).GetLastHitReactionData()) {
      if !this.m_tumble && aiTime > this.m_activationTimeStamp + 0.40 {
        (ScriptExecutionContext.GetOwner(context) as ScriptedPuppet).GetPuppetStateBlackboard().SetBool(GetAllBlackboardDefs().AIAction.ownerInTumble, true);
        this.m_tumble = true;
      } else {
        if this.m_tumble && aiTime > this.m_activationTimeStamp + 2.10 {
          (ScriptExecutionContext.GetOwner(context) as ScriptedPuppet).GetPuppetStateBlackboard().SetBool(GetAllBlackboardDefs().AIAction.ownerInTumble, false);
          this.m_onUpdateCompleted = true;
          this.m_tumble = false;
        };
      };
    };
  }

  private func OnDeactivate(context: ScriptExecutionContext) -> Void {
    if this.m_tumble {
      (ScriptExecutionContext.GetOwner(context) as ScriptedPuppet).GetPuppetStateBlackboard().SetBool(GetAllBlackboardDefs().AIAction.ownerInTumble, false);
      this.m_tumble = false;
    };
  }
}

public class KnockdownReactionTask extends AIHitReactionTask {

  public let m_tweakDBPackage: TweakDBID;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    StatusEffectHelper.ApplyStatusEffect(ScriptExecutionContext.GetOwner(context), t"BaseStatusEffect.HitReactionKnockdown");
    if ScriptedPuppet.CanRagdoll(ScriptExecutionContext.GetOwner(context)) {
      StatusEffectHelper.ApplyStatusEffect(ScriptExecutionContext.GetOwner(context), t"BaseStatusEffect.UncontrolledMovement_Default");
    };
    GameObject.PlayVoiceOver(ScriptExecutionContext.GetOwner(context), n"hit_reaction_heavy", n"Scripts:KnockdownReactionTask");
    super.Activate(context);
  }

  private func GetHitReactionType() -> animHitReactionType {
    return animHitReactionType.Knockdown;
  }

  private func GetDesiredHitReactionDuration(context: ScriptExecutionContext) -> Float {
    this.m_tweakDBPackage = t"AIGeneralSettings";
    let duration: Float = AITweakParams.GetFloatFromTweak(this.m_tweakDBPackage, "knockdown_duration");
    if duration > 0.00 {
      return duration;
    };
    return 4.00;
  }
}

public class PainReactionTask extends AIHitReactionTask {

  protected let m_weaponOverride: ref<AnimFeature_WeaponOverride>;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    this.m_weaponOverride = new AnimFeature_WeaponOverride();
    this.m_weaponOverride.state = 1;
    AnimationControllerComponent.ApplyFeatureToReplicate(ScriptExecutionContext.GetOwner(context), n"weaponOverride", this.m_weaponOverride);
    if ScriptedPuppet.CanRagdoll(ScriptExecutionContext.GetOwner(context)) {
      StatusEffectHelper.ApplyStatusEffect(ScriptExecutionContext.GetOwner(context), t"BaseStatusEffect.UncontrolledMovement_RagdollOffLedge");
    };
    super.Activate(context);
  }

  protected func Deactivate(context: ScriptExecutionContext) -> Void {
    this.m_weaponOverride.state = 0;
    AnimationControllerComponent.ApplyFeatureToReplicate(ScriptExecutionContext.GetOwner(context), n"weaponOverride", this.m_weaponOverride);
    super.Deactivate(context);
  }

  private func GetHitReactionType() -> animHitReactionType {
    return animHitReactionType.Pain;
  }

  private func GetDesiredHitReactionDuration(context: ScriptExecutionContext) -> Float {
    return 2.20;
  }
}

public class GuardbreakReactionTask extends AIHitReactionTask {

  public let m_tweakDBPackage: TweakDBID;

  private func GetHitReactionType() -> animHitReactionType {
    return animHitReactionType.GuardBreak;
  }

  private func GetDesiredHitReactionDuration(context: ScriptExecutionContext) -> Float {
    this.m_tweakDBPackage = t"AIGeneralSettings";
    let duration: Float = AITweakParams.GetFloatFromTweak(this.m_tweakDBPackage, "guardbreak_duration");
    if duration > 0.00 {
      return duration;
    };
    return 1.00;
  }
}

public class BlockReactionTask extends AIbehaviortaskScript {

  protected func Deactivate(context: ScriptExecutionContext) -> Void {
    AIBehaviorScriptBase.GetPuppet(context).GetHitReactionComponent().UpdateBlockCount();
  }
}

public class ParryReactionTask extends AIbehaviortaskScript {

  protected func Deactivate(context: ScriptExecutionContext) -> Void {
    AIBehaviorScriptBase.GetPuppet(context).GetHitReactionComponent().UpdateParryCount();
  }
}

public class DodgeReactionTask extends AIbehaviortaskScript {

  protected func Deactivate(context: ScriptExecutionContext) -> Void {
    AIBehaviorScriptBase.GetPuppet(context).GetHitReactionComponent().UpdateDodgeCount();
  }
}

public class BlockReactionFlag extends AIbehaviortaskScript {

  public let target: wref<GameObject>;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIBehaviorScriptBase.GetPuppet(context).GetStimReactionComponent().GetPuppetReactionBlackboard().SetBool(GetAllBlackboardDefs().PuppetReaction.blockReactionFlag, true);
  }

  protected func Deactivate(context: ScriptExecutionContext) -> Void {
    AIBehaviorScriptBase.GetPuppet(context).GetStimReactionComponent().GetPuppetReactionBlackboard().SetBool(GetAllBlackboardDefs().PuppetReaction.blockReactionFlag, false);
  }
}

public class BroadcastCombatHitStim extends AIbehaviortaskScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let investigateData: stimInvestigateData;
    let target: wref<GameObject> = AIBehaviorScriptBase.GetPuppet(context).GetHitReactionComponent().GetHitSource();
    let broadcaster: ref<StimBroadcasterComponent> = target.GetStimBroadcasterComponent();
    if !IsDefined(broadcaster) {
      target = AIBehaviorScriptBase.GetPuppet(context).GetHitReactionComponent().GetHitInstigator();
      broadcaster = target.GetStimBroadcasterComponent();
    };
    if IsDefined(broadcaster) {
      investigateData.skipReactionDelay = true;
      investigateData.skipInitialAnimation = true;
      broadcaster.SendDrirectStimuliToTarget(ScriptExecutionContext.GetOwner(context), gamedataStimType.CombatHit, AIBehaviorScriptBase.GetPuppet(context), investigateData);
    };
  }
}
