
public class BodyPartHitPrereqCondition extends BaseHitPrereqCondition {

  public let m_bodyPart: CName;

  public let m_attackSubtype: gamedataAttackSubtype;

  public func SetData(recordID: TweakDBID) -> Void {
    this.m_bodyPart = TweakDBInterface.GetCName(recordID + t".bodyPart", n"None");
    super.SetData(recordID);
  }

  public func Evaluate(hitEvent: ref<gameHitEvent>) -> Bool {
    let empty: HitShapeData;
    let result: Bool;
    let shape: HitShapeData = hitEvent.hitRepresentationResult.hitShapes[0];
    if NotEquals(shape, empty) {
      switch this.m_bodyPart {
        case n"Head":
          result = HitShapeUserDataBase.IsHitReactionZoneHead(shape.userData as HitShapeUserDataBase);
          break;
        case n"Torso":
          result = HitShapeUserDataBase.IsHitReactionZoneTorso(shape.userData as HitShapeUserDataBase);
          break;
        case n"Limb":
          result = HitShapeUserDataBase.IsHitReactionZoneLimb(shape.userData as HitShapeUserDataBase);
          break;
        case n"LeftArm":
          result = HitShapeUserDataBase.IsHitReactionZoneLeftArm(shape.userData as HitShapeUserDataBase);
          break;
        case n"RightArm":
          result = HitShapeUserDataBase.IsHitReactionZoneRightArm(shape.userData as HitShapeUserDataBase);
          break;
        case n"Arm":
          result = HitShapeUserDataBase.IsHitReactionZoneArm(shape.userData as HitShapeUserDataBase);
          break;
        case n"LeftLeg":
          result = HitShapeUserDataBase.IsHitReactionZoneLeftLeg(shape.userData as HitShapeUserDataBase);
          break;
        case n"RightLeg":
          result = HitShapeUserDataBase.IsHitReactionZoneRightLeg(shape.userData as HitShapeUserDataBase);
          break;
        case n"Leg":
          result = HitShapeUserDataBase.IsHitReactionZoneLeg(shape.userData as HitShapeUserDataBase);
          break;
        default:
          return false;
      };
      if result {
        result = this.CheckOnlyOncePerShot(hitEvent);
      };
      return this.m_invert ? !result : result;
    };
    return false;
  }
}
