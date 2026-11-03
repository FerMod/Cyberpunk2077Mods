
public class CerberusComponent extends ScriptableComponent {

  protected let m_laserGameEffectUp: ref<EffectInstance>;

  protected edit let m_laserGameEffectRefUp: EffectRef;

  protected let m_laserGameEffectUp2: ref<EffectInstance>;

  protected edit let m_laserGameEffectRefUp2: EffectRef;

  protected let m_laserGameEffectBeam: ref<EffectInstance>;

  protected edit let m_laserGameEffectRefBeam: EffectRef;

  protected let m_laserGameEffectBottom: ref<EffectInstance>;

  protected edit let m_laserGameEffectRefBottom: EffectRef;

  protected let m_laserGameEffectBottom2: ref<EffectInstance>;

  protected edit let m_laserGameEffectRefBottom2: EffectRef;

  private let m_gameObject: wref<GameObject>;

  private final func OnGameAttach() -> Void {
    this.m_gameObject = this.GetOwner() as NPCPuppet;
  }

  protected final func RunGameEffect(out effectInstance: ref<EffectInstance>, effectRef: EffectRef, slotName: CName, range: Float) -> Void {
    this.TerminateGameEffect(effectInstance);
    effectInstance = GameInstance.GetGameEffectSystem(this.m_gameObject.GetGame()).CreateEffect(effectRef, this.m_gameObject);
    EffectData.SetVector(effectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.position, this.m_gameObject.GetWorldPosition());
    EffectData.SetVector(effectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.forward, this.m_gameObject.GetWorldForward());
    EffectData.SetFloat(effectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.range, range);
    effectInstance.AttachToSlot(this.m_gameObject, slotName, GetAllBlackboardDefs().EffectSharedData.position, GetAllBlackboardDefs().EffectSharedData.forward);
    effectInstance.Run();
  }

  protected final func TerminateGameEffect(out effectInstance: ref<EffectInstance>) -> Void {
    if IsDefined(effectInstance) {
      effectInstance.Terminate();
      effectInstance = null;
    };
  }

  protected cb func OnAIEvent(aiEvent: ref<AIEvent>) -> Bool {
    switch aiEvent.name {
      case n"CerberusScan":
        this.RunGameEffect(this.m_laserGameEffectUp, this.m_laserGameEffectRefUp, n"ScannerRoot_Up", 10.00);
        this.RunGameEffect(this.m_laserGameEffectUp2, this.m_laserGameEffectRefUp2, n"ScannerRoot_Up2", 10.00);
        this.RunGameEffect(this.m_laserGameEffectBeam, this.m_laserGameEffectRefBeam, n"ScannerRoot_beam", 10.00);
        this.RunGameEffect(this.m_laserGameEffectBottom, this.m_laserGameEffectRefBottom, n"ScannerRoot_Bottom", 10.00);
        this.RunGameEffect(this.m_laserGameEffectBottom2, this.m_laserGameEffectRefBottom2, n"ScannerRoot_Bottom2", 10.00);
        break;
      case n"CerberusStopScan":
        this.TerminateGameEffect(this.m_laserGameEffectUp);
        this.TerminateGameEffect(this.m_laserGameEffectUp2);
        this.TerminateGameEffect(this.m_laserGameEffectBeam);
        this.TerminateGameEffect(this.m_laserGameEffectBottom);
        this.TerminateGameEffect(this.m_laserGameEffectBottom2);
        break;
      case n"eye_flare_red":
        GameObject.StartReplicatedEffectEvent(this.GetOwner(), n"big_eye_flare");
        GameObject.StartReplicatedEffectEvent(this.GetOwner(), n"eyes_flare");
        break;
      case n"stop_eye_flare_red":
        GameObject.BreakReplicatedEffectLoopEvent(this.GetOwner(), n"big_eye_flare");
        GameObject.BreakReplicatedEffectLoopEvent(this.GetOwner(), n"eyes_flare");
        break;
      case n"eye_flare_yellow":
        GameObject.StartReplicatedEffectEvent(this.GetOwner(), n"big_eye_flare_yellow");
        GameObject.StartReplicatedEffectEvent(this.GetOwner(), n"eyes_flare_yellow");
        break;
      case n"stop_eye_flare_yellow":
        GameObject.BreakReplicatedEffectLoopEvent(this.GetOwner(), n"big_eye_flare_yellow");
        GameObject.BreakReplicatedEffectLoopEvent(this.GetOwner(), n"eyes_flare_yellow");
    };
  }

  private final func OnGameDetach() -> Void {
    this.TerminateGameEffect(this.m_laserGameEffectUp);
    this.TerminateGameEffect(this.m_laserGameEffectUp2);
    this.TerminateGameEffect(this.m_laserGameEffectBeam);
    this.TerminateGameEffect(this.m_laserGameEffectBottom);
    this.TerminateGameEffect(this.m_laserGameEffectBottom2);
    StatusEffectHelper.RemoveStatusEffect(this.GetOwner(), t"WorkspotStatus.Braindance");
  }

  protected cb func OnPreUninitialize(evt: ref<entPreUninitializeEvent>) -> Bool {
    this.TerminateGameEffect(this.m_laserGameEffectUp);
    this.TerminateGameEffect(this.m_laserGameEffectUp2);
    this.TerminateGameEffect(this.m_laserGameEffectBeam);
    this.TerminateGameEffect(this.m_laserGameEffectBottom);
    this.TerminateGameEffect(this.m_laserGameEffectBottom2);
  }

  protected cb func OnHit(evt: ref<gameHitEvent>) -> Bool {
    if !StatusEffectSystem.ObjectHasStatusEffect(this.GetOwner(), t"BaseStatusEffect.CerberusSkipPreAlerted") {
      StatusEffectHelper.ApplyStatusEffect(this.GetOwner(), t"BaseStatusEffect.CerberusSkipPreAlerted");
    };
  }
}

public class CerberusDetectionCombat extends AIbehaviorconditionScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let senseComponent: ref<SenseComponent> = AIBehaviorScriptBase.GetPuppet(context).GetSensesComponent();
    let target: wref<GameObject> = GameInstance.GetPlayerSystem(ScriptExecutionContext.GetOwner(context).GetGame()).GetLocalPlayerControlledGameObject();
    if AIBehaviorScriptBase.GetPuppet(context).IsCerberus() {
      if IsDefined(target) && target.IsPlayer() {
        if senseComponent.GetDetection(target.GetEntityID()) <= 99.90 {
          return AIbehaviorConditionOutcomes.True;
        };
      };
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class CerberusDetectionOpticalCamo extends AIbehaviorconditionScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let senseComponent: ref<SenseComponent> = AIBehaviorScriptBase.GetPuppet(context).GetSensesComponent();
    let target: wref<GameObject> = GameInstance.GetPlayerSystem(ScriptExecutionContext.GetOwner(context).GetGame()).GetLocalPlayerControlledGameObject();
    let hasOpticalCamo: Bool = StatusEffectSystem.ObjectHasStatusEffectWithTag(target, n"Cloak");
    if AIBehaviorScriptBase.GetPuppet(context).IsCerberus() {
      if IsDefined(target) && target.IsPlayer() {
        if senseComponent.GetDetection(target.GetEntityID()) >= 1.00 && hasOpticalCamo {
          return AIbehaviorConditionOutcomes.True;
        };
      };
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class CerberusSensePresetChange extends AIbehaviortaskScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    SenseComponent.RequestPresetChange(ScriptExecutionContext.GetOwner(context), t"Senses.Alerted", true);
  }
}

public class CerberusAbsoluteSensePresetChange extends AIbehaviortaskScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    SenseComponent.RequestPresetChange(ScriptExecutionContext.GetOwner(context), t"Senses.AbsoluteInstant", true);
  }
}

public class CerberusOpticalCamoVisibilityChange extends AIbehaviortaskScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let senseComponent: ref<SenseComponent> = AIBehaviorScriptBase.GetPuppet(context).GetSensesComponent();
    RPGManager.RemoveAbility(ScriptExecutionContext.GetOwner(context), TweakDBInterface.GetGameplayAbilityRecord(t"Ability.CanSeeThroughOpticalCamos"));
    senseComponent.UpdateVisionBlockersIgnoredBySensor();
  }
}

public class IsCerberus extends AIbehaviorconditionScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    if AIBehaviorScriptBase.GetPuppet(context).IsCerberus() {
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }
}
