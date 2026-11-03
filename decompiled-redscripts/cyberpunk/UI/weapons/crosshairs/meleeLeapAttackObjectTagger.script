
public class MeleeLeapAttackObjectTagger extends IScriptable {

  private let m_game: GameInstance;

  private let m_playerPuppet: wref<GameObject>;

  private let m_playerDevelopmentData: wref<PlayerDevelopmentData>;

  private let m_visionModeSystem: wref<VisionModeSystem>;

  private let m_target: wref<GameObject>;

  @default(MeleeLeapAttackObjectTagger, 2.f)
  private let m_minDistanceToTarget: Float;

  public final func SetUp(playerPuppet: ref<GameObject>) -> Void {
    this.m_game = playerPuppet.GetGame();
    this.m_playerPuppet = playerPuppet;
    this.m_playerDevelopmentData = PlayerDevelopmentSystem.GetData(playerPuppet);
    this.m_visionModeSystem = GameInstance.GetVisionModeSystem(this.m_game);
  }

  public final func SetVisionOnTargetObj(targetEntity: ref<Entity>, distanceToTarget: Float) -> Void {
    let isValidTurret: Bool;
    let leapAttackPerkIsBought: Bool;
    let gameObject: ref<GameObject> = targetEntity as GameObject;
    if !IsDefined(gameObject) {
      return;
    };
    if IsDefined(this.m_playerDevelopmentData) {
      leapAttackPerkIsBought = this.m_playerDevelopmentData.IsNewPerkBoughtAnyLevel(gamedataNewPerkType.Reflexes_Inbetween_Right_2);
    };
    if gameObject.IsTurret() && IsDefined(gameObject as Device) {
      isValidTurret = !StrContains((gameObject as Device).GetDeviceName(), "Ceiling");
    };
    if leapAttackPerkIsBought && gameObject.IsActive() && (gameObject.IsNPC() || isValidTurret) {
      if this.m_minDistanceToTarget < distanceToTarget && this.GetTargetMaxRange() > distanceToTarget {
        if this.m_target.GetEntityID() != gameObject.GetEntityID() {
          this.ResetVisionOnTargetObj();
          this.m_target = gameObject;
          this.m_visionModeSystem.GetScanningController().TagObject(this.m_target);
        };
      } else {
        this.ResetVisionOnTargetObj();
      };
    };
  }

  public final func ResetVisionOnTargetObj() -> Void {
    if IsDefined(this.m_target) {
      this.m_visionModeSystem.GetScanningController().UntagObject(this.m_target);
      this.m_target = null;
    };
  }

  protected final const func CanPerformRelicLeap(equippedWeapon: ref<WeaponObject>) -> Bool {
    if !equippedWeapon.IsMantisBlades() || !equippedWeapon.IsCharged() {
      return false;
    };
    return RPGManager.HasStatFlag(this.m_playerPuppet, gamedataStatType.CanUseNewMeleewareAttackSpyTree);
  }

  private final func GetTargetMaxRange() -> Float {
    let equippedWeapon: ref<WeaponObject> = GameObject.GetActiveWeapon(this.m_playerPuppet);
    if this.CanPerformRelicLeap(equippedWeapon) {
      return TDB.GetFloat(t"playerStateMachineMelee.meleeLeap.maxDistToTargetMantisBladesRelic");
    };
    return TDB.GetFloat(t"playerStateMachineMelee.meleeLeap.maxDistToTarget");
  }
}
