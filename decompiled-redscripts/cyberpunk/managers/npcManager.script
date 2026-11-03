
public class NPCManager extends IScriptable {

  private let m_owner: wref<NPCPuppet>;

  public final func Init(owner: ref<GameObject>) -> Void {
    let record: wref<Character_Record>;
    if !IsDefined(owner) {
      return;
    };
    this.m_owner = owner as NPCPuppet;
    record = TweakDBInterface.GetCharacterRecord(this.m_owner.GetRecordID());
    if record.GetTagsCount() > 0 {
      this.SetNPCImmortalityMode(record);
    };
    if record.GetOnSpawnGLPsCount() > 0 {
      this.ApplySpawnGLPs(record, false);
    };
    if record.GetAbilitiesCount() > 0 {
      this.SetNPCAbilities(record);
    };
    this.SetNPCVisualTagsStats(record);
    this.SetNPCArchetypeData(record);
  }

  public final func ApplySpawnAnimWrappers() -> Void {
    let record: wref<Character_Record>;
    if !IsDefined(this.m_owner) {
      return;
    };
    record = TweakDBInterface.GetCharacterRecord(this.m_owner.GetRecordID());
    if record.GetOnSpawnGLPsCount() > 0 {
      this.ApplySpawnGLPs(record, true);
    };
  }

  public final func UnInit(owner: ref<GameObject>) -> Void {
    this.ClearNPCImmortalityMode();
  }

  private final func ApplySpawnGLPs(record: wref<Character_Record>, applyAnimWrappers: Bool) -> Void {
    let spawnGLPs: array<wref<GameplayLogicPackage_Record>>;
    record.OnSpawnGLPs(spawnGLPs);
    RPGManager.ApplyGLPArray(this.m_owner, spawnGLPs, true, applyAnimWrappers ? 1 : -1);
  }

  private final func SetNPCAbilities(record: wref<Character_Record>) -> Void {
    let abilities: array<wref<GameplayAbility_Record>>;
    record.Abilities(abilities);
    RPGManager.ApplyAbilityArray(this.m_owner, abilities);
  }

  private final func SetNPCVisualTagsStats(record: wref<Character_Record>) -> Void {
    let modifier: ref<gameStatModifierData>;
    let statSys: ref<StatsSystem>;
    if this.m_owner.IsMassive() {
      statSys = GameInstance.GetStatsSystem(this.m_owner.GetGame());
      modifier = RPGManager.CreateStatModifier(gamedataStatType.IsManMassive, gameStatModifierType.Additive, 1.00);
      statSys.AddModifier(Cast<StatsObjectID>(this.m_owner.GetEntityID()), modifier);
    };
    if NPCManager.HasVisualTag(this.m_owner, n"Big") {
      statSys = GameInstance.GetStatsSystem(this.m_owner.GetGame());
      modifier = RPGManager.CreateStatModifier(gamedataStatType.IsManBig, gameStatModifierType.Additive, 1.00);
      statSys.AddModifier(Cast<StatsObjectID>(this.m_owner.GetEntityID()), modifier);
    };
  }

  private final func SetNPCArchetypeData(record: wref<Character_Record>) -> Void {
    let abilityGroups: array<wref<GameplayAbilityGroup_Record>>;
    let i: Int32;
    let statGroups: array<wref<StatModifierGroup_Record>>;
    let archetypeData: wref<ArchetypeData_Record> = record.ArchetypeData();
    if !IsDefined(archetypeData) {
      return;
    };
    if archetypeData.GetStatModifierGroupsCount() > 0 {
      archetypeData.StatModifierGroups(statGroups);
      RPGManager.ApplyStatModifierGroups(this.m_owner, statGroups);
    };
    if archetypeData.GetAbilityGroupsCount() > 0 {
      archetypeData.AbilityGroups(abilityGroups);
      i = 0;
      while i < ArraySize(abilityGroups) {
        RPGManager.ApplyAbilityGroup(this.m_owner, abilityGroups[i]);
        i += 1;
      };
    };
  }

  private final func ScaleToPlayer() -> Void {
    let modifier: ref<gameStatModifierData>;
    let playerLevel: Float;
    let playerPL: Float;
    let statSys: ref<StatsSystem> = GameInstance.GetStatsSystem(this.m_owner.GetGame());
    statSys.RemoveAllModifiers(Cast<StatsObjectID>(this.m_owner.GetEntityID()), gamedataStatType.PowerLevel);
    playerPL = statSys.GetStatValue(Cast<StatsObjectID>(GameInstance.GetPlayerSystem(this.m_owner.GetGame()).GetLocalPlayerControlledGameObject().GetEntityID()), gamedataStatType.PowerLevel);
    playerLevel = statSys.GetStatValue(Cast<StatsObjectID>(GameInstance.GetPlayerSystem(this.m_owner.GetGame()).GetLocalPlayerControlledGameObject().GetEntityID()), gamedataStatType.Level);
    modifier = RPGManager.CreateStatModifier(gamedataStatType.PowerLevel, gameStatModifierType.Additive, playerPL);
    statSys.AddModifier(Cast<StatsObjectID>(this.m_owner.GetEntityID()), modifier);
    modifier = RPGManager.CreateStatModifier(gamedataStatType.Level, gameStatModifierType.Additive, playerLevel);
    statSys.AddModifier(Cast<StatsObjectID>(this.m_owner.GetEntityID()), modifier);
  }

  private final func SetNPCImmortalityMode(record: wref<Character_Record>) -> Void {
    let tags: array<CName> = record.Tags();
    if ArrayContains(tags, EnumValueToName(n"gameGodModeType", 0l)) {
      GameInstance.GetGodModeSystem(this.m_owner.GetGame()).AddGodMode(this.m_owner.GetEntityID(), gameGodModeType.Invulnerable, n"Default");
    } else {
      if ArrayContains(tags, EnumValueToName(n"gameGodModeType", 1l)) {
        GameInstance.GetGodModeSystem(this.m_owner.GetGame()).AddGodMode(this.m_owner.GetEntityID(), gameGodModeType.Immortal, n"Default");
      };
    };
  }

  private final func ClearNPCImmortalityMode() -> Void {
    GameInstance.GetGodModeSystem(this.m_owner.GetGame()).ClearGodMode(this.m_owner.GetEntityID(), n"Default");
  }

  public final static func HasTag(recordID: TweakDBID, tag: CName) -> Bool {
    let tags: array<CName> = TweakDBInterface.GetCharacterRecord(recordID).Tags();
    if ArrayContains(tags, tag) {
      return true;
    };
    return false;
  }

  public final static func HasAnyTags(recordID: TweakDBID, const tags: script_ref<[CName]>) -> Bool {
    let i: Int32;
    if ArraySize(Deref(tags)) <= 0 {
      return false;
    };
    i = 0;
    while i < ArraySize(Deref(tags)) {
      if NPCManager.HasTag(recordID, Deref(tags)[i]) {
        return true;
      };
      i += 1;
    };
    return false;
  }

  public final static func HasAllTags(recordID: TweakDBID, const tags: script_ref<[CName]>) -> Bool {
    let i: Int32;
    if ArraySize(Deref(tags)) <= 0 {
      return false;
    };
    i = 0;
    while i < ArraySize(Deref(tags)) {
      if !NPCManager.HasTag(recordID, Deref(tags)[i]) {
        return false;
      };
      i += 1;
    };
    return true;
  }

  public final static func HasVisualTag(puppet: wref<ScriptedPuppet>, visualTag: CName) -> Bool {
    if !IsDefined(puppet) || !IsNameValid(visualTag) {
      return false;
    };
    if puppet.MatchVisualTag(visualTag) {
      return true;
    };
    return false;
  }

  public final static func HasAllVisualTags(puppet: wref<ScriptedPuppet>, const visualTags: script_ref<[CName]>) -> Bool {
    if !IsDefined(puppet) || ArraySize(Deref(visualTags)) <= 0 {
      return false;
    };
    return puppet.MatchVisualTags(Deref(visualTags));
  }

  public final static func HasAnyVisualTags(puppet: wref<ScriptedPuppet>, const visualTags: script_ref<[CName]>) -> Bool {
    let i: Int32;
    if !IsDefined(puppet) || ArraySize(Deref(visualTags)) <= 0 {
      return false;
    };
    i = 0;
    while i < ArraySize(Deref(visualTags)) {
      if puppet.MatchVisualTag(Deref(visualTags)[i]) {
        return true;
      };
      i += 1;
    };
    return false;
  }
}
