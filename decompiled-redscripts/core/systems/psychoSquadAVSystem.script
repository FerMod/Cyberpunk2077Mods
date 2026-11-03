
public class PsychoSquadAvHelperClass extends ScriptableSystem {

  public final static func TurnOffPsychoSquadAvCammoEventDelayed(instance: GameInstance, go: ref<GameObject>, delay: Float) -> Void {
    let evt: ref<TurnOffPsychoSquadAvCammoEvent> = new TurnOffPsychoSquadAvCammoEvent();
    evt.go = go;
    GameInstance.GetDelaySystem(instance).DelayScriptableSystemRequest(n"PsychoSquadAvHelperClass", evt, delay);
  }

  public final static func TurnOnPsychoSquadAvCammoEventDelayed(instance: GameInstance, go: ref<GameObject>, delay: Float) -> Void {
    let evt: ref<TurnOnPsychoSquadAvCammoEvent> = new TurnOnPsychoSquadAvCammoEvent();
    evt.go = go;
    GameInstance.GetDelaySystem(instance).DelayScriptableSystemRequest(n"PsychoSquadAvHelperClass", evt, delay);
  }

  public final static func GetOffAV(go: ref<GameObject>) -> Void {
    let biggestDelay: Float;
    let evt: ref<PushAnimEventDelayed>;
    let i: Int32;
    let jumpDelay: Float;
    let numberOfLMGs: Int32;
    let numberOfMantisBlades: Int32;
    let numberOfSnipers: Int32;
    let passenger: wref<ScriptedPuppet>;
    let passengers: array<wref<GameObject>>;
    let gi: GameInstance = go.GetGame();
    let id: EntityID = go.GetEntityID();
    VehicleComponent.GetAllPassengers(gi, id, false, passengers);
    i = 0;
    while i < ArraySize(passengers) {
      jumpDelay = 0.00;
      passenger = passengers[i] as ScriptedPuppet;
      switch passenger.GetRecordID() {
        case t"Character.maxtac_av_mantis_wa_2nd_wave":
        case t"Character.maxtac_av_mantis_wa":
          jumpDelay = 2.00 + Cast<Float>(numberOfMantisBlades) / 4.00;
          numberOfMantisBlades += 1;
          break;
        case t"Character.maxtac_av_riffle_ma_2nd_wave":
        case t"Character.maxtac_av_riffle_ma":
        case t"Character.maxtac_av_LMG_mb_2nd_wave":
        case t"Character.maxtac_av_LMG_mb":
          jumpDelay = 0.50 + Cast<Float>(numberOfLMGs) / 4.00;
          numberOfLMGs += 1;
          break;
        case t"Character.maxtac_av_sniper_wa_elite_2nd_wave":
        case t"Character.maxtac_av_sniper_wa_elite":
        case t"Character.maxtac_av_netrunner_ma_2nd_wave":
        case t"Character.maxtac_av_netrunner_ma":
          jumpDelay = 1.20 + Cast<Float>(numberOfSnipers) / 4.00;
          numberOfSnipers += 1;
          break;
        default:
          jumpDelay = Cast<Float>(i);
      };
      if jumpDelay > biggestDelay {
        biggestDelay = jumpDelay;
      };
      StatusEffectHelper.ApplyStatusEffect(passenger, t"BaseStatusEffect.MaxtacFightStartHelperStatus", jumpDelay);
      GameInstance.GetDelaySystem(gi).DelayEvent(passenger, AIEvents.ExitVehicleEvent(), jumpDelay);
      if i == 0 {
        StatusEffectHelper.ApplyStatusEffect(GetPlayer(gi), t"StatusEffect.HackReveal", passenger.GetEntityID());
      };
      i += 1;
    };
    if ArraySize(passengers) > 0 {
      biggestDelay += 2.00;
      evt = new PushAnimEventDelayed();
      evt.go = go;
      evt.eventName = n"close_door_event";
      GameInstance.GetDelaySystem(gi).DelayScriptableSystemRequest(n"PsychoSquadAvHelperClass", evt, biggestDelay);
    };
  }

  private final func OnTurnOffPsychoSquadAvCammoEventDelayed(evt: ref<TurnOffPsychoSquadAvCammoEvent>) -> Void {
    let gi: GameInstance = evt.go.GetGame();
    let id: EntityID = evt.go.GetEntityID();
    let mountInfos: array<MountingInfo> = GameInstance.GetMountingFacility(gi).GetMountingInfoMultipleWithIds(id);
    let i: Int32 = 0;
    while i < ArraySize(mountInfos) {
      StatusEffectHelper.RemoveAllStatusEffectsByType(gi, mountInfos[i].childId, gamedataStatusEffectType.Cloaked);
      i += 1;
    };
  }

  private final func OnTurnOnPsychoSquadAvCammoEventDelayed(evt: ref<TurnOnPsychoSquadAvCammoEvent>) -> Void {
    GameObjectEffectHelper.StartEffectEvent(evt.go, n"cloak_on");
    GameObjectEffectHelper.BreakEffectLoopEvent(evt.go, n"flare_light_maxtac_prevention_system");
    (evt.go as AVObject).TurnOffThrusters();
  }

  private final func OnMaxTacFearEventDelayed(evt: ref<MaxTacFearEvent>) -> Void {
    StimBroadcasterComponent.BroadcastStim(evt.player, gamedataStimType.VehicleHit, 100.00);
    StimBroadcasterComponent.BroadcastStim(evt.player, gamedataStimType.Terror, 100.00);
    GameObject.PlaySound(evt.av, n"av_maxtac_descent_horn", n"vehicle_general_emitter");
  }

  private final func OnPushAnimEventDelayed(evt: ref<PushAnimEventDelayed>) -> Void {
    if IsDefined(evt.go) {
      AnimationControllerComponent.PushEvent(evt.go, evt.eventName);
    };
  }
}

public class IsPsychoSquadAvWithoutPassangers extends PreventionConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let vehicle: wref<VehicleObject>;
    let go: ref<GameObject> = ScriptExecutionContext.GetOwner(context);
    let gi: GameInstance = go.GetGame();
    let id: EntityID = go.GetEntityID();
    VehicleComponent.GetVehicleFromID(gi, id, vehicle);
    return Cast<AIbehaviorConditionOutcomes>(IsDefined(vehicle) && !vehicle.IsDestroyed() && !VehicleComponent.HasAnyPreventionPassengers(vehicle));
  }
}

public class TurnOnPsychoSquadAvCammo extends AIbehaviortaskScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let go: wref<GameObject> = ScriptExecutionContext.GetOwner(context);
    PsychoSquadAvHelperClass.TurnOnPsychoSquadAvCammoEventDelayed(go.GetGame(), go, 3.00);
  }
}

public class TurnOnPsychoSquadAvCammoImmediatly extends AIbehaviortaskScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let go: wref<GameObject> = ScriptExecutionContext.GetOwner(context);
    let gi: GameInstance = go.GetGame();
    let id: EntityID = go.GetEntityID();
    let mountInfos: array<MountingInfo> = GameInstance.GetMountingFacility(gi).GetMountingInfoMultipleWithIds(id);
    let i: Int32 = 0;
    while i < ArraySize(mountInfos) {
      StatusEffectHelper.ApplyStatusEffectOnSelf(gi, t"BaseStatusEffect.MaxtacCloaked", mountInfos[i].childId);
      i += 1;
    };
    GameObjectEffectHelper.StopEffectEvent(go, n"thrusters");
    GameObjectEffectHelper.StopEffectEvent(go, n"flare_light_maxtac_prevention_system");
    GameObjectEffectHelper.StartEffectEvent(go, n"cloak_on_instant");
  }
}

public class TurnOffPsychoSquadAvCammo extends AIbehaviortaskScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let go: wref<GameObject> = ScriptExecutionContext.GetOwner(context);
    (go as AVObject).TurnOnThrusters();
    GameObjectEffectHelper.StartEffectEvent(go, n"cloak_off");
    GameObjectEffectHelper.StartEffectEvent(go, n"flare_light_maxtac_prevention_system");
    PsychoSquadAvHelperClass.TurnOffPsychoSquadAvCammoEventDelayed(go.GetGame(), go, 3.00);
  }
}

public class TurnOffPsychoSquadAvCammoImmediatly extends AIbehaviortaskScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let go: wref<GameObject> = ScriptExecutionContext.GetOwner(context);
    (go as AVObject).TurnOnThrusters();
    GameObjectEffectHelper.StartEffectEvent(go, n"cloak_off_instant");
  }
}

public class RegisterPsychoSquadPassengers extends AIbehaviortaskScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let i: Int32;
    let passenger: wref<ScriptedPuppet>;
    let passengers: array<wref<GameObject>>;
    let evt: ref<MaxTacFearEvent> = new MaxTacFearEvent();
    let go: ref<GameObject> = ScriptExecutionContext.GetOwner(context);
    let gi: GameInstance = go.GetGame();
    let id: EntityID = go.GetEntityID();
    VehicleComponent.GetAllPassengers(gi, id, false, passengers);
    i = 0;
    while i < ArraySize(passengers) {
      passenger = passengers[i] as ScriptedPuppet;
      passenger.TryRegisterToPrevention();
      i += 1;
    };
    evt.player = GetPlayer(gi);
    evt.av = go;
    GameInstance.GetDelaySystem(gi).DelayScriptableSystemRequest(n"PsychoSquadAvHelperClass", evt, 2.50);
  }
}

public class GetOffThePsychoSquadAV extends AIbehaviortaskScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let go: ref<GameObject> = ScriptExecutionContext.GetOwner(context);
    PsychoSquadAvHelperClass.GetOffAV(go);
  }
}

public class DetectPlayerFromAV extends AIbehaviortaskScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let i: Int32;
    let passengers: array<wref<GameObject>>;
    let puppet: ref<ScriptedPuppet>;
    let go: ref<GameObject> = ScriptExecutionContext.GetOwner(context);
    let gi: GameInstance = go.GetGame();
    let id: EntityID = go.GetEntityID();
    VehicleComponent.GetAllPassengers(gi, id, false, passengers);
    i = 0;
    while i < ArraySize(passengers) {
      puppet = passengers[i] as ScriptedPuppet;
      if AIActionHelper.TryChangingAttitudeToHostile(puppet, GetPlayer(gi)) {
        TargetTrackingExtension.InjectThreat(puppet, GetPlayer(gi), 1.00, -1.00);
        NPCPuppet.ChangeHighLevelState(puppet, gamedataNPCHighLevelState.Combat);
      };
      i += 1;
    };
  }
}

public class AvStartDescentSFXBehaviour extends AIbehaviortaskScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let go: ref<GameObject> = ScriptExecutionContext.GetOwner(context);
    GameObject.PlaySound(go, n"av_maxtac_start_descent", n"vehicle_general_emitter");
  }
}

public class AvHoverIdleSFXBehaviour extends AIbehaviortaskScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let go: ref<GameObject> = ScriptExecutionContext.GetOwner(context);
    GameObject.PlaySound(go, n"av_maxtac_hover_idle", n"vehicle_general_emitter");
  }
}

public class AvStartAscentSFXBehaviour extends AIbehaviortaskScript {

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let go: ref<GameObject> = ScriptExecutionContext.GetOwner(context);
    GameObject.PlaySound(go, n"av_maxtac_start_ascent", n"vehicle_general_emitter");
  }
}

public class IsPreventionMaxtacCondition extends PreventionConditionAbstract {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let owner: ref<gamePuppet> = ScriptExecutionContext.GetOwner(context);
    let gameInstance: GameInstance = owner.GetGame();
    return Cast<AIbehaviorConditionOutcomes>(PreventionSystem.IsPreventionMaxTac(gameInstance, owner));
  }
}
