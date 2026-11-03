
public class GameEffectExecutor_StimOnHit extends EffectExecutor_Scripted {

  public edit let stimType: gamedataStimType;

  public edit let silentStimType: gamedataStimType;

  public edit const let suppressedByStimTypes: [gamedataStimType];

  private final func CreateStim(ctx: EffectScriptContext, stimuliType: gamedataStimType, position: Vector4, opt radius: Float) -> Bool {
    let stimInfo: StimuliMergeInfo;
    let stimSystem: ref<StimuliSystem> = GameInstance.GetStimuliSystem(EffectScriptContext.GetGameInstance(ctx));
    let stimRecord: ref<Stim_Record> = stimSystem.GetStimRecord(stimuliType);
    if radius <= 0.00 {
      radius = stimRecord.Radius();
    };
    stimInfo.position = position;
    stimInfo.instigator = EffectScriptContext.GetInstigator(ctx) as GameObject;
    stimInfo.radius = radius;
    stimInfo.type = stimuliType;
    stimInfo.propagationType = gamedataStimPropagation.Audio;
    stimInfo.targets = stimRecord.Targets().Type();
    stimSystem.BroadcastMergeableStimuli(stimInfo, this.suppressedByStimTypes);
    return true;
  }

  public final func Process(ctx: EffectScriptContext, applierCtx: EffectExecutionScriptContext) -> Bool {
    let sniperNestOverride: Bool;
    let weapon: ref<WeaponObject>;
    let silentStimRadius: Float = 0.00;
    let position: Vector4 = EffectExecutionScriptContext.GetHitPosition(applierCtx);
    if Vector4.IsZero(position) {
      return false;
    };
    if GameInstance.GetStatusEffectSystem(EffectScriptContext.GetGameInstance(ctx)).HasStatusEffect(EffectScriptContext.GetSource(ctx).GetEntityID(), t"BaseStatusEffect.PersonalSoundSilencerPlayerBuff") {
      return false;
    };
    if GameInstance.GetStatsSystem(EffectScriptContext.GetGameInstance(ctx)).GetStatValue(Cast<StatsObjectID>(EffectScriptContext.GetWeapon(ctx).GetEntityID()), gamedataStatType.CanSilentKill) > 0.00 {
      if IsDefined(EffectExecutionScriptContext.GetTarget(applierCtx) as ScriptedPuppet) && RPGManager.HasStatFlag(EffectScriptContext.GetInstigator(ctx) as GameObject, gamedataStatType.CanPlayerGagOnDetection) {
        silentStimRadius = 3.00;
      };
      weapon = EffectScriptContext.GetWeapon(ctx) as WeaponObject;
      if IsDefined(weapon) && Equals(WeaponObject.GetWeaponType(weapon.GetItemID()), gamedataItemType.Wea_SniperRifle) {
        sniperNestOverride = GameInstance.GetBlackboardSystem(EffectScriptContext.GetGameInstance(ctx)).Get(GetAllBlackboardDefs().SniperNestDeviceBlackboard).GetBool(GetAllBlackboardDefs().SniperNestDeviceBlackboard.IsInTheSniperNest);
        if !sniperNestOverride && !this.CreateStim(ctx, this.stimType, position, 5.00) {
          return false;
        };
      };
    } else {
      if !this.CreateStim(ctx, this.stimType, position) {
        return false;
      };
      silentStimRadius = 20.00;
    };
    return this.CreateStim(ctx, this.silentStimType, position, silentStimRadius);
  }
}
