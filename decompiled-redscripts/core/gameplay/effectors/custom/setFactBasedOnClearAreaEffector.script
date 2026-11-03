
public class SetFactBasedOnClearAreaEffector extends Effector {

  public let m_fact: CName;

  public let m_factSuffixes: [CName];

  public let m_vectorRotations: [Float];

  public let m_value: Int32;

  public let m_distance: Float;

  public let m_width: Float;

  public let m_fromHeight: Float;

  public let m_height: Float;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_fact = TDB.GetCName(record + t".fact");
    this.m_factSuffixes = TDB.GetCNameArray(record + t".factSuffixes");
    this.m_vectorRotations = TDB.GetFloatArray(record + t".vectorRotations");
    this.m_fact = TDB.GetCName(record + t".fact");
    this.m_value = TDB.GetInt(record + t".value");
    this.m_distance = TDB.GetFloat(record + t".distance");
    this.m_width = TDB.GetFloat(record + t".width");
    this.m_fromHeight = TDB.GetFloat(record + t".fromHeight");
    this.m_height = TDB.GetFloat(record + t".height");
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    let factName: String;
    let i: Int32 = 0;
    while i < ArraySize(this.m_factSuffixes) && i < ArraySize(this.m_vectorRotations) {
      factName = NameToString(this.m_fact) + NameToString(this.m_factSuffixes[i]);
      GameInstance.GetQuestsSystem(owner.GetGame()).SetFactStr(factName, 0);
      i += 1;
    };
    if owner.IsPlayer() {
      i = 0;
      while i < ArraySize(this.m_factSuffixes) && i < ArraySize(this.m_vectorRotations) {
        factName = NameToString(this.m_fact) + NameToString(this.m_factSuffixes[i]);
        if this.HasSpaceInFront(owner, this.m_vectorRotations[i]) {
          GameInstance.GetQuestsSystem(owner.GetGame()).SetFactStr(factName, this.m_value);
          return;
        };
        i += 1;
      };
    } else {
      this.SetFactBasedOnObjectAndPlayerRelation(owner);
    };
  }

  private final func HasSpaceInFront(owner: ref<GameObject>, rotation: Float) -> Bool {
    let currentDirection: Vector4 = owner.GetWorldForward();
    currentDirection = Vector4.RotByAngleXY(currentDirection, rotation);
    return SpatialQueriesHelper.HasSpaceInFront(owner, currentDirection, this.m_fromHeight, this.m_width, this.m_distance, this.m_height);
  }

  private final func SetFactBasedOnObjectAndPlayerRelation(owner: ref<GameObject>) -> Void {
    let angleBetweenObjects: Float;
    let angleIdx: Int32;
    let angleResolution: Float;
    let crossProd: Vector4;
    let dirToTarget: Vector4;
    let factName: String;
    let ownerCurrentPos: Vector4;
    let playerCurrentDir: Vector4;
    let playerCurrentPos: Vector4;
    let playerPuppet: ref<PlayerPuppet> = GameInstance.GetPlayerSystem(owner.GetGame()).GetLocalPlayerMainGameObject() as PlayerPuppet;
    if !IsDefined(playerPuppet) || ArraySize(this.m_vectorRotations) < 2 || ArraySize(this.m_vectorRotations) != ArraySize(this.m_factSuffixes) {
      return;
    };
    playerCurrentDir = playerPuppet.GetWorldForward();
    playerCurrentPos = playerPuppet.GetWorldPosition();
    playerCurrentPos.Z = 0.00;
    ownerCurrentPos = owner.GetWorldPosition();
    ownerCurrentPos.Z = 0.00;
    dirToTarget = ownerCurrentPos - playerCurrentPos;
    angleBetweenObjects = Vector4.GetAngleBetween(playerCurrentDir, dirToTarget);
    crossProd = Vector4.Cross(playerCurrentDir, dirToTarget);
    if crossProd.Z > 0.00 {
      angleBetweenObjects = 360.00 - angleBetweenObjects;
    };
    angleResolution = this.m_vectorRotations[1] - this.m_vectorRotations[0];
    angleIdx = RoundF(angleBetweenObjects / angleResolution) % ArraySize(this.m_factSuffixes);
    if angleIdx < ArraySize(this.m_factSuffixes) {
      factName = NameToString(this.m_fact) + NameToString(this.m_factSuffixes[angleIdx]);
      GameInstance.GetQuestsSystem(playerPuppet.GetGame()).SetFactStr(factName, this.m_value);
    };
  }
}
