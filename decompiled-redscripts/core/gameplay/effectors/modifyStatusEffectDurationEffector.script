
public class OnStatusEffectAppliedListener extends ScriptStatusEffectListener {

  public let m_effector: wref<ModifyStatusEffectDurationEffector>;

  public let m_tags: [CName];

  public let m_owner: wref<GameObject>;

  public func OnStatusEffectApplied(statusEffect: wref<StatusEffect_Record>) -> Void {
    let j: Int32 = 0;
    while j < ArraySize(this.m_tags) {
      if StatusEffectHelper.HasTag(statusEffect, this.m_tags[j]) {
        this.m_effector.ProcessAction(this.m_owner);
      };
      j += 1;
    };
  }
}

public class ModifyStatusEffectDurationEffector extends Effector {

  private let m_statusEffectListener: ref<OnStatusEffectAppliedListener>;

  public let m_tags: [CName];

  public let m_change: Float;

  public let m_isPercentage: Bool;

  public let m_listenConstantly: Bool;

  public let m_canGoOverInitialDuration: Bool;

  public let m_gameInstance: GameInstance;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_tags = TweakDBInterface.GetCNameArray(record + t".gameplayTags");
    this.m_change = TweakDBInterface.GetFloat(record + t".change", 0.00);
    this.m_isPercentage = TweakDBInterface.GetBool(record + t".isPercentage", false);
    this.m_listenConstantly = TweakDBInterface.GetBool(record + t".listenConstantly", false);
    this.m_canGoOverInitialDuration = TweakDBInterface.GetBool(record + t".canGoOverInitialDuration", true);
    this.m_gameInstance = game;
  }

  public final func ProcessAction(owner: ref<GameObject>) -> Void {
    let appliedStatusEffects: array<ref<StatusEffect>>;
    let duration: wref<StatModifierGroup_Record>;
    let i: Int32;
    let remainingDuration: Float;
    let statModifiers: array<wref<StatModifier_Record>>;
    let durationValue: Float = 1.00;
    let finalChange: Float = this.m_change;
    let j: Int32 = 0;
    while j < ArraySize(this.m_tags) {
      if StatusEffectHelper.GetAppliedEffectsWithTag(owner, this.m_tags[j], appliedStatusEffects) {
        i = 0;
        while i < ArraySize(appliedStatusEffects) {
          remainingDuration = appliedStatusEffects[i].GetRemainingDuration();
          if remainingDuration <= 0.00 {
          } else {
            duration = appliedStatusEffects[i].GetRecord().Duration();
            duration.StatModifiers(statModifiers);
            durationValue = RPGManager.CalculateStatModifiers(statModifiers, this.m_gameInstance, owner, Cast<StatsObjectID>(owner.GetEntityID()));
            if this.m_isPercentage {
              finalChange = durationValue * this.m_change / 100.00;
            };
            remainingDuration = MaxF(0.00, remainingDuration + finalChange);
            if !this.m_canGoOverInitialDuration && remainingDuration > durationValue {
              remainingDuration = durationValue;
            };
            GameInstance.GetStatusEffectSystem(this.m_gameInstance).SetStatusEffectRemainingDuration(owner.GetEntityID(), appliedStatusEffects[i].GetRecord().GetID(), remainingDuration);
          };
          i += 1;
        };
      };
      j += 1;
    };
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
    if this.m_listenConstantly {
      this.m_statusEffectListener = new OnStatusEffectAppliedListener();
      this.m_statusEffectListener.m_owner = owner;
      this.m_statusEffectListener.m_tags = this.m_tags;
      this.m_statusEffectListener.m_effector = this;
      GameInstance.GetStatusEffectSystem(this.m_gameInstance).RegisterListener(owner.GetEntityID(), this.m_statusEffectListener);
    };
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }

  protected func ActionOff(owner: ref<GameObject>) -> Void {
    this.m_statusEffectListener = null;
  }
}

public class ModifyStatusEffectDurationOnAttackEffector extends ModifyAttackEffector {

  public let m_tags: [CName];

  public let m_change: Float;

  public let m_isPercentage: Bool;

  public let m_listenConstantly: Bool;

  public let m_gameInstance: GameInstance;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_tags = TweakDBInterface.GetCNameArray(record + t".gameplayTags");
    this.m_change = TweakDBInterface.GetFloat(record + t".change", 0.00);
    this.m_isPercentage = TweakDBInterface.GetBool(record + t".isPercentage", false);
    this.m_gameInstance = game;
  }

  public final func ProcessAction(owner: ref<GameObject>) -> Void {
    let appliedStatusEffects: array<ref<StatusEffect>>;
    let duration: wref<StatModifierGroup_Record>;
    let i: Int32;
    let remainingDuration: Float;
    let statModifiers: array<wref<StatModifier_Record>>;
    let hitEvent: ref<gameHitEvent> = this.GetHitEvent();
    let durationValue: Float = 1.00;
    let finalChange: Float = this.m_change;
    let j: Int32 = 0;
    while j < ArraySize(this.m_tags) {
      if StatusEffectHelper.GetAppliedEffectsWithTag(hitEvent.target, this.m_tags[j], appliedStatusEffects) {
        i = 0;
        while i < ArraySize(appliedStatusEffects) {
          remainingDuration = appliedStatusEffects[i].GetRemainingDuration();
          if remainingDuration <= 0.00 {
          } else {
            if this.m_isPercentage {
              duration = appliedStatusEffects[i].GetRecord().Duration();
              duration.StatModifiers(statModifiers);
              durationValue = RPGManager.CalculateStatModifiers(statModifiers, this.m_gameInstance, owner, Cast<StatsObjectID>(owner.GetEntityID()));
              finalChange = durationValue * this.m_change / 100.00;
            };
            remainingDuration = MaxF(0.00, remainingDuration + finalChange);
            GameInstance.GetStatusEffectSystem(this.m_gameInstance).SetStatusEffectRemainingDuration(hitEvent.target.GetEntityID(), appliedStatusEffects[i].GetRecord().GetID(), remainingDuration);
          };
          i += 1;
        };
      };
      j += 1;
    };
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    this.ProcessAction(owner);
  }
}
