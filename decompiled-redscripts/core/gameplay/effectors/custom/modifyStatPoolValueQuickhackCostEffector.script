
public class ModifyStatPoolValueQuickhackCostEffector extends HitEventEffector {

  public let m_statPoolValue: Float;

  public let m_statPoolType: gamedataStatPoolType;

  public let m_recoverMemoryAmount: Float;

  public let m_skipLastCombatHack: Bool;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_statPoolValue = TDB.GetFloat(record + t".statPoolValue");
    this.m_statPoolType = IntEnum<gamedataStatPoolType>(Cast<Int32>(EnumValueFromString("gamedataStatPoolType", TweakDBInterface.GetString(record + t".statPoolType", ""))));
    this.m_recoverMemoryAmount = TweakDBInterface.GetFloat(record + t".recoverMemoryAmount", 1.00);
    this.m_skipLastCombatHack = TweakDBInterface.GetBool(record + t".skipLastCombatHack", false);
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    this.ProcessEffector(owner);
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    this.ProcessEffector(owner);
  }

  private final func ProcessEffector(owner: ref<GameObject>) -> Void {
    let actionEffects: array<wref<ObjectActionEffect_Record>>;
    let actionEffectsCost: array<Int32>;
    let actionEffectsOfEffects: array<array<wref<ObjectActionEffect_Record>>>;
    let actionRecord: ref<ObjectAction_Record>;
    let activeActionEffectTweakDBID: TweakDBID;
    let activeQH: ref<ScriptableDeviceAction>;
    let activeQHCost: Int32;
    let activeQHHistory: array<ref<ScriptableDeviceAction>>;
    let appliedEffectTweakDBID: TweakDBID;
    let appliedEffects: array<ref<StatusEffect>>;
    let foundAppliedEffect: Bool;
    let i: Int32;
    let j: Int32;
    let k: Int32;
    let poolSys: ref<StatPoolsSystem>;
    let statPoolValue: Float = this.m_recoverMemoryAmount;
    let hitEvent: ref<gameHitEvent> = this.GetHitEvent();
    if !IsDefined(hitEvent) {
      return;
    };
    poolSys = GameInstance.GetStatPoolsSystem(owner.GetGame());
    if !IsDefined(poolSys) {
      return;
    };
    GameInstance.GetStatusEffectSystem(owner.GetGame()).GetAppliedEffectsWithTag(hitEvent.target.GetEntityID(), n"Quickhack", appliedEffects);
    activeQHHistory = this.GetActiveQuickhackActionHistory(hitEvent.target);
    foundAppliedEffect = false;
    i = ArraySize(activeQHHistory) - 1;
    while i >= 0 {
      activeQH = activeQHHistory[i];
      activeQHCost = activeQH.GetCost();
      actionRecord = activeQH.GetObjectActionRecord();
      if IsDefined(actionRecord) {
        if this.m_skipLastCombatHack && !foundAppliedEffect && Equals(actionRecord.HackCategory().Type(), gamedataHackCategory.DamageHack) {
          foundAppliedEffect = true;
        } else {
          actionRecord.CompletionEffects(actionEffects);
          ArrayPush(actionEffectsOfEffects, actionEffects);
          ArrayPush(actionEffectsCost, activeQHCost);
          ArrayClear(actionEffects);
        };
      };
      i -= 1;
    };
    i = 0;
    while i < ArraySize(actionEffectsOfEffects) {
      actionEffects = actionEffectsOfEffects[i];
      activeQHCost = actionEffectsCost[i];
      foundAppliedEffect = false;
      j = 0;
      while j < ArraySize(actionEffects) {
        activeActionEffectTweakDBID = actionEffects[j].StatusEffect().GetID();
        if IsDefined(actionEffects[j].EffectorToTrigger()) && Equals(actionEffects[j].EffectorToTrigger().EffectorClassName(), n"ApplyLegendaryWhistleEffector") {
          activeActionEffectTweakDBID = t"BaseStatusEffect.WhistleLvl4";
        };
        k = 0;
        while k < ArraySize(appliedEffects) {
          appliedEffectTweakDBID = appliedEffects[k].GetRecord().GetID();
          if activeActionEffectTweakDBID == appliedEffectTweakDBID {
            statPoolValue += this.m_statPoolValue * Cast<Float>(activeQHCost);
            foundAppliedEffect = true;
            break;
          };
          k += 1;
        };
        activeActionEffectTweakDBID = TDBID.None();
        if foundAppliedEffect {
          break;
        };
        j += 1;
      };
      i += 1;
    };
    poolSys.RequestChangingStatPoolValue(Cast<StatsObjectID>(owner.GetEntityID()), this.m_statPoolType, statPoolValue, owner, false, false);
  }

  private final func GetActiveQuickhackActionHistory(target: wref<GameObject>) -> [ref<ScriptableDeviceAction>] {
    let scriptableDeviceActionArray: array<ref<ScriptableDeviceAction>>;
    if IsDefined(target as ScriptedPuppet) {
      scriptableDeviceActionArray = (target as ScriptedPuppet).GetActiveQuickhackActionHistory();
    };
    return scriptableDeviceActionArray;
  }
}
