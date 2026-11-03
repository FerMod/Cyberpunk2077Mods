
public native class TargetShootComponent extends IComponent {

  public let m_weaponRecord: ref<WeaponItem_Record>;

  public let m_weaponTDBID: TweakDBID;

  public let m_characterRecord: ref<Character_Record>;

  public let m_characterTDBID: TweakDBID;

  private final native const func IsTimeBetweenHitsEnabled() -> Bool;

  private final native const func IsDebugEnabled() -> Bool;

  public final native const func GetPackageName() -> String;

  private final native const func CalculateMissOffset(weaponOwner: wref<GameObject>, weapon: wref<WeaponObject>, shootAtPointWS: Vector4, maxSpread: Float, useForcedMissZOffset: Bool, forcedMissZOffset: Float, isInLowCover: Bool) -> Vector4;

  private final native func SetLastHitTime(value: Float) -> Void;

  private final native const func GetLastHitTime() -> Float;

  private final native func GetBasicGroupCoefficient(weaponOwner: wref<GameObject>) -> Float;

  private final native func InsertRecentHitter(weaponOwner: wref<GameObject>) -> Void;

  private final const func GetValueFromCurve(curveName: CName, lookupValue: Float) -> Float {
    let statsDataSystem: ref<StatsDataSystem> = GameInstance.GetStatsDataSystem(this.GetGameObject().GetGame());
    return statsDataSystem.GetValueFromCurve(n"time_between_hits", lookupValue, curveName);
  }

  private final const func GetDistanceCoefficientFromCurve(curveName: CName, lookupValue: Float) -> Float {
    let statsDataSystem: ref<StatsDataSystem> = GameInstance.GetStatsDataSystem(this.GetGameObject().GetGame());
    return statsDataSystem.GetValueFromCurve(n"tbh_weapon_type_distance_mults", lookupValue, curveName);
  }

  private final const func GetVisibilityCoefficientFromCurve(curveName: CName, lookupValue: Float) -> Float {
    let statsDataSystem: ref<StatsDataSystem> = GameInstance.GetStatsDataSystem(this.GetGameObject().GetGame());
    return statsDataSystem.GetValueFromCurve(n"tbh_weapon_type_visibility_mults", lookupValue, curveName);
  }

  private final const func GetGameObject() -> ref<GameObject> {
    return this.GetEntity() as GameObject;
  }

  public final func HandleBeingShot(weaponOwner: wref<GameObject>, weapon: wref<WeaponObject>, shootAtPoint: Vector4, maxSpread: Float, coefficientMultiplier: Float, out miss: Bool) -> Vector4 {
    let weaponTDBID: TweakDBID;
    let gameInstance: GameInstance = this.GetGameObject().GetGame();
    let result: Vector4 = new Vector4(0.00, 0.00, 0.00, 0.00);
    if !this.IsTimeBetweenHitsEnabled() {
      return result;
    };
    miss = false;
    weaponTDBID = ItemID.GetTDBID(weapon.GetItemID());
    if this.m_weaponTDBID != weaponTDBID {
      this.m_weaponRecord = TweakDBInterface.GetWeaponItemRecord(weaponTDBID);
      this.m_weaponTDBID = weaponTDBID;
    };
    if this.ShouldBeHit(weaponOwner, weapon, this.m_weaponRecord, coefficientMultiplier) {
      this.SetLastHitTime(EngineTime.ToFloat(GameInstance.GetSimTime(gameInstance)));
      if this.GetGameObject().IsPlayer() {
        this.InsertRecentHitter(weaponOwner);
      };
      if this.IsDebugEnabled() {
        GameInstance.GetDebugVisualizerSystem(gameInstance).DrawWireSphere(shootAtPoint + result, 0.04, new Color(252u, 3u, 3u, 255u), 3.00);
      };
    } else {
      result = this.HandleMissed(weaponOwner, weapon, shootAtPoint, maxSpread);
      miss = true;
    };
    return result;
  }

  public final func HandleBeingShot(weaponOwner: wref<GameObject>, weapon: wref<WeaponObject>, shootAtPoint: Vector4, maxSpread: Float, coefficientMultiplier: Float) -> Vector4 {
    let tmp: Bool;
    return this.HandleBeingShot(weaponOwner, weapon, shootAtPoint, maxSpread, coefficientMultiplier, tmp);
  }

  private final func HandleMissed(weaponOwner: wref<GameObject>, weapon: wref<WeaponObject>, shootAtPoint: Vector4, maxSpread: Float) -> Vector4 {
    let characterTDBID: TweakDBID;
    let useForcedMissZOffset: Bool = false;
    let forcedMissZOffset: Float = 0.00;
    let isInLowCover: Bool = false;
    let result: Vector4 = new Vector4(0.00, 0.00, 0.00, 0.00);
    let scriptedPuppetOwner: ref<ScriptedPuppet> = weaponOwner as ScriptedPuppet;
    if IsDefined(scriptedPuppetOwner) {
      characterTDBID = scriptedPuppetOwner.GetRecordID();
      if this.m_characterTDBID != characterTDBID {
        this.m_characterRecord = TweakDBInterface.GetCharacterRecord(characterTDBID);
        this.m_characterTDBID = characterTDBID;
      };
      useForcedMissZOffset = this.m_weaponRecord.UseForcedTBHZOffset() && this.m_characterRecord.UseForcedTBHZOffset();
      forcedMissZOffset = this.m_characterRecord.ForcedTBHZOffset();
      isInLowCover = Equals(AICoverHelper.GetCurrentCoverStance(scriptedPuppetOwner), n"Low");
    };
    result = this.CalculateMissOffset(weaponOwner, weapon, shootAtPoint, maxSpread, useForcedMissZOffset, forcedMissZOffset, isInLowCover);
    if this.IsDebugEnabled() {
      GameInstance.GetDebugVisualizerSystem(this.GetGameObject().GetGame()).DrawWireSphere(shootAtPoint + result, 0.04, new Color(50u, 168u, 82u, 255u), 3.00);
    };
    return result;
  }

  private final const func GetDifficultyLevelCoefficient() -> Float {
    let fieldName: String;
    let statsDataSys: ref<StatsDataSystem> = GameInstance.GetStatsDataSystem(this.GetGameObject().GetGame());
    let difficulty: gameDifficulty = statsDataSys.GetDifficulty();
    switch difficulty {
      case gameDifficulty.Story:
        fieldName = ".storyModeMultiplier";
        break;
      case gameDifficulty.Easy:
        fieldName = ".easyModeMultiplier";
        break;
      case gameDifficulty.Hard:
        fieldName = ".normalModeMultiplier";
        break;
      case gameDifficulty.VeryHard:
        fieldName = ".hardModeMultiplier";
        break;
      default:
        fieldName = ".normalModeMultiplier";
    };
    return TweakDBInterface.GetFloat(TDBID.Create(this.GetPackageName() + fieldName), 1.00);
  }

  private final const func GetHMGGroupMultiplier() -> Float {
    return TweakDBInterface.GetFloat(TDBID.Create(this.GetPackageName() + ".HMGGroupMultiplier"), 1.00);
  }

  private final func GetGroupCoefficient(weaponOwner: ref<GameObject>) -> Float {
    return this.GetValueFromCurve(n"rescaled_group_coefficient", this.GetBasicGroupCoefficient(weaponOwner));
  }

  private final const func GetPlayersNumCoefficient(weaponOwner: ref<GameObject>) -> Float {
    let outPlayerGameObjects: array<ref<GameObject>>;
    let playersCount: Uint32 = 1u;
    if IsMultiplayer() && (IsDefined(this.GetGameObject() as Muppet) || IsDefined(this.GetGameObject() as PlayerPuppet)) {
      playersCount = GameInstance.GetPlayerSystem(weaponOwner.GetGame()).FindPlayerControlledObjects(weaponOwner.GetWorldPosition(), 0.00, true, true, outPlayerGameObjects);
      return this.GetValueFromCurve(n"players_count_coefficient", Cast<Float>(playersCount));
    };
    return 1.00;
  }

  private final const func GetDistanceCoefficient(weapon: wref<WeaponObject>, targetPosition: Vector4) -> Float {
    let distance: Float = Vector4.Distance(weapon.GetWorldPosition(), targetPosition);
    let heldItemType: gamedataItemType = RPGManager.GetItemType(weapon.GetItemID());
    switch heldItemType {
      case gamedataItemType.Wea_AssaultRifle:
        return this.GetDistanceCoefficientFromCurve(n"assault_rifle_distance_coefficient", distance);
      case gamedataItemType.Wea_ShotgunDual:
        return this.GetDistanceCoefficientFromCurve(n"dual_shotgun_distance_coefficient", distance);
      case gamedataItemType.Wea_Handgun:
        return this.GetDistanceCoefficientFromCurve(n"handgun_distance_coefficient", distance);
      case gamedataItemType.Wea_HeavyMachineGun:
        return this.GetDistanceCoefficientFromCurve(n"hmg_distance_coefficient", distance);
      case gamedataItemType.Wea_LightMachineGun:
        return this.GetDistanceCoefficientFromCurve(n"lmg_distance_coefficient", distance);
      case gamedataItemType.Wea_PrecisionRifle:
        return this.GetDistanceCoefficientFromCurve(n"precision_rifle_distance_coefficient", distance);
      case gamedataItemType.Wea_Revolver:
        return this.GetDistanceCoefficientFromCurve(n"revolver_distance_coefficient", distance);
      case gamedataItemType.Wea_Shotgun:
        return this.GetDistanceCoefficientFromCurve(n"shotgun_distance_coefficient", distance);
      case gamedataItemType.Wea_SubmachineGun:
        return this.GetDistanceCoefficientFromCurve(n"smg_distance_coefficient", distance);
      case gamedataItemType.Wea_SniperRifle:
        return this.GetDistanceCoefficientFromCurve(n"sniper_rifle_distance_coefficient", distance);
      default:
        return this.GetDistanceCoefficientFromCurve(n"assault_rifle_distance_coefficient", distance);
    };
  }

  private final const func GetVisibilityCoefficient(weaponOwner: ref<GameObject>, weapon: ref<WeaponObject>, target: ref<GameObject>, visibilityThresholdCoefficient: Float) -> Float {
    let heldItemType: gamedataItemType;
    let continuousLineOfSight: Float = 0.00;
    weaponOwner.GetSourceShootComponent().GetContinuousLineOfSightToTarget(target, continuousLineOfSight);
    continuousLineOfSight *= visibilityThresholdCoefficient;
    if continuousLineOfSight == 0.00 {
      return 0.00;
    };
    heldItemType = RPGManager.GetItemType(weapon.GetItemID());
    switch heldItemType {
      case gamedataItemType.Wea_AssaultRifle:
        return this.GetVisibilityCoefficientFromCurve(n"assault_rifle_visibility_coefficient", continuousLineOfSight);
      case gamedataItemType.Wea_ShotgunDual:
        return this.GetVisibilityCoefficientFromCurve(n"dual_shotgun_visibility_coefficient", continuousLineOfSight);
      case gamedataItemType.Wea_Handgun:
        return this.GetVisibilityCoefficientFromCurve(n"handgun_visibility_coefficient", continuousLineOfSight);
      case gamedataItemType.Wea_HeavyMachineGun:
        return this.GetVisibilityCoefficientFromCurve(n"hmg_visibility_coefficient", continuousLineOfSight);
      case gamedataItemType.Wea_LightMachineGun:
        return this.GetVisibilityCoefficientFromCurve(n"lmg_visibility_coefficient", continuousLineOfSight);
      case gamedataItemType.Wea_PrecisionRifle:
        return this.GetVisibilityCoefficientFromCurve(n"precision_rifle_visibility_coefficient", continuousLineOfSight);
      case gamedataItemType.Wea_Revolver:
        return this.GetVisibilityCoefficientFromCurve(n"revolver_visibility_coefficient", continuousLineOfSight);
      case gamedataItemType.Wea_Shotgun:
        return this.GetVisibilityCoefficientFromCurve(n"shotgun_visibility_coefficient", continuousLineOfSight);
      case gamedataItemType.Wea_SubmachineGun:
        return this.GetVisibilityCoefficientFromCurve(n"smg_visibility_coefficient", continuousLineOfSight);
      case gamedataItemType.Wea_SniperRifle:
        return this.GetVisibilityCoefficientFromCurve(n"sniper_rifle_visibility_coefficient", continuousLineOfSight);
      default:
        return this.GetVisibilityCoefficientFromCurve(n"assault_rifle_visibility_coefficient", continuousLineOfSight);
    };
  }

  private final const func GetCoverCoefficient(weaponOwner: ref<GameObject>, weaponRecord: ref<WeaponItem_Record>, target: ref<GameObject>) -> Float {
    let fieldName: String;
    if weaponOwner.GetSourceShootComponent().CanSeeSecondaryPointOfTarget(target) {
      return 1.00;
    };
    if Equals(weaponRecord.Evolution().Type(), gamedataWeaponEvolution.Smart) {
      fieldName = ".coverVsSmartWeaponsMultiplier";
    } else {
      fieldName = ".coverVsNormalWeaponsMultiplier";
    };
    return TweakDBInterface.GetFloat(TDBID.Create(this.GetPackageName() + fieldName), 1.00);
  }

  private final const func GetVisionBlockersCoefficient(weaponOwner: ref<GameObject>, target: ref<GameObject>) -> Float {
    return weaponOwner.GetSourceShootComponent().GetLineOfSightTBHModifier(target);
  }

  private final func CalculateTimeBetweenHits(const params: script_ref<TimeBetweenHitsParameters>) -> Float {
    return Deref(params).difficultyLevelCoefficient * Deref(params).baseCoefficient * Deref(params).baseSourceCoefficient * Deref(params).accuracyCoefficient * Deref(params).distanceCoefficient * Deref(params).visibilityCoefficient * Deref(params).playersCountCoefficient * Deref(params).groupCoefficient * Deref(params).coverCoefficient * Deref(params).visionBlockerCoefficient;
  }

  private final func ShouldBeHit(weaponOwner: ref<GameObject>, weapon: wref<WeaponObject>, weaponRecord: ref<WeaponItem_Record>, visibilityThresholdCoefficient: Float) -> Bool {
    let accuracy: Float;
    let heldItemType: gamedataItemType;
    let params: TimeBetweenHitsParameters;
    let shouldBeHit: Bool;
    let timeBetweenHits: Float;
    let timeSinceLastHit: Float;
    let visibilityCollisionToTargetDist: Float;
    let target: ref<GameObject> = this.GetGameObject();
    let gameInstance: GameInstance = target.GetGame();
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(gameInstance);
    if !IsDefined(weaponOwner.GetSourceShootComponent()) {
      return true;
    };
    if target.IsPlayer() && RPGManager.IsTechPierceEnabled(weaponOwner.GetGame(), weaponOwner, weapon.GetItemID()) {
      visibilityCollisionToTargetDist = (weaponOwner as ScriptedPuppet).GetSenses().GetVisibilityTraceEndToAgentDist(target);
      if visibilityCollisionToTargetDist > 0.00 && visibilityCollisionToTargetDist < 1000000000.00 {
        return false;
      };
    };
    params.visibilityCoefficient = this.GetVisibilityCoefficient(weaponOwner, weapon, target, visibilityThresholdCoefficient);
    if visibilityThresholdCoefficient > 0.00 && params.visibilityCoefficient <= 0.00 {
      if this.IsDebugEnabled() {
        GameInstance.GetDebugVisualizerSystem(gameInstance).DrawText3D(weapon.GetWorldPosition(), FloatToString(-1.00), new Color(41u, 191u, 31u, 255u), 0.70);
      };
      return false;
    };
    accuracy = statsSystem.GetStatValue(Cast<StatsObjectID>(weaponOwner.GetEntityID()), gamedataStatType.Accuracy);
    if accuracy == 0.00 {
      return false;
    };
    params.accuracyCoefficient = 1.00 / accuracy;
    params.baseCoefficient = statsSystem.GetStatValue(Cast<StatsObjectID>(target.GetEntityID()), gamedataStatType.TBHsBaseCoefficient);
    params.baseSourceCoefficient = statsSystem.GetStatValue(Cast<StatsObjectID>(weaponOwner.GetEntityID()), gamedataStatType.TBHsBaseSourceMultiplierCoefficient);
    params.difficultyLevelCoefficient = this.GetDifficultyLevelCoefficient();
    params.distanceCoefficient = this.GetDistanceCoefficient(weapon, target.GetWorldPosition());
    if params.distanceCoefficient == 0.00 {
      return false;
    };
    params.playersCountCoefficient = this.GetPlayersNumCoefficient(weaponOwner);
    params.groupCoefficient = target.IsPlayer() ? this.GetGroupCoefficient(weaponOwner) : 1.00;
    params.coverCoefficient = target.IsPlayer() ? this.GetCoverCoefficient(weaponOwner, weaponRecord, target) : 1.00;
    params.visionBlockerCoefficient = this.GetVisionBlockersCoefficient(weaponOwner, target);
    heldItemType = RPGManager.GetItemType(weapon.GetItemID());
    if Equals(heldItemType, gamedataItemType.Wea_HeavyMachineGun) {
      params.groupCoefficient = LerpF(this.GetHMGGroupMultiplier(), 1.00, params.groupCoefficient);
    };
    timeBetweenHits = this.CalculateTimeBetweenHits(params);
    if !IsFinal() {
      weaponOwner.GetSourceShootComponent().SetDebugParameters(params);
    };
    timeSinceLastHit = EngineTime.ToFloat(GameInstance.GetSimTime(gameInstance)) - this.GetLastHitTime();
    shouldBeHit = timeSinceLastHit >= timeBetweenHits;
    if this.IsDebugEnabled() {
      if shouldBeHit {
        GameInstance.GetDebugVisualizerSystem(gameInstance).DrawText3D(weapon.GetWorldPosition(), FloatToString(timeBetweenHits), new Color(245u, 22u, 49u, 255u), 0.70);
        GameInstance.GetDebugVisualizerSystem(gameInstance).DrawText3D(target.GetWorldPosition() + new Vector4(0.00, 0.00, 1.80, 0.00), FloatToString(timeSinceLastHit), new Color(245u, 22u, 49u, 255u), MinF(0.70, timeSinceLastHit));
      } else {
        GameInstance.GetDebugVisualizerSystem(gameInstance).DrawText3D(weapon.GetWorldPosition(), FloatToString(timeBetweenHits), new Color(41u, 191u, 31u, 255u), 0.70);
      };
    };
    return shouldBeHit;
  }
}
