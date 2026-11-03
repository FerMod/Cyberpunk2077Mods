
public class IsPlayerReachablePrereq extends IScriptablePrereq {

  public let m_invert: Bool;

  public let m_checkRMA: Bool;

  public let m_checkOnlyRMA: Bool;

  public let m_minRMADistance: Float;

  public let m_canCheckProxy: Bool;

  public let m_horTolerance: Float;

  public let m_verTolerance: Float;

  protected func Initialize(recordID: TweakDBID) -> Void {
    this.m_invert = TweakDBInterface.GetBool(recordID + t".invert", false);
    this.m_checkRMA = TweakDBInterface.GetBool(recordID + t".checkForRMA", false);
    this.m_checkOnlyRMA = TweakDBInterface.GetBool(recordID + t".checkOnlyRMA", false);
    this.m_minRMADistance = TweakDBInterface.GetFloat(recordID + t".minDistanceWithinRMA", 0.00);
    this.m_canCheckProxy = TweakDBInterface.GetBool(recordID + t".canCheckProxy", false);
    this.m_horTolerance = TweakDBInterface.GetFloat(recordID + t".horizontalTolerance", 0.00);
    this.m_verTolerance = TweakDBInterface.GetFloat(recordID + t".verticalTolerance", 0.00);
  }

  public const func IsFulfilled(game: GameInstance, context: ref<IScriptable>) -> Bool {
    let navResult: AINavigationSystemResult;
    let navigationSystem: ref<AINavigationSystem>;
    let position: Vector4;
    let proxy: wref<GameObject>;
    let query: AINavigationSystemQuery;
    let queryId: Uint32;
    let result: Bool;
    let rmaPosition: Vector4;
    let toPosition: Vector4;
    let unreachableDistance: Vector4;
    let worldPosition: WorldPosition;
    let player: wref<ScriptedPuppet> = GetPlayer(game);
    let owner: wref<ScriptedPuppet> = context as ScriptedPuppet;
    if !IsDefined(owner) || !IsDefined(player) {
      return false;
    };
    position = player.GetWorldPosition();
    if this.m_canCheckProxy {
      proxy = player.TryGetControlledProxy();
      if IsDefined(proxy) {
        position = proxy.GetWorldPosition();
      };
    };
    if this.m_checkRMA {
      if this.m_minRMADistance <= 0.00 {
        rmaPosition = position;
      } else {
        toPosition = position - owner.GetWorldPosition();
        toPosition.Z = 0.00;
        toPosition = Vector4.Normalize(toPosition);
        rmaPosition = owner.GetWorldPosition() + toPosition * this.m_minRMADistance;
      };
      if !AIActionHelper.IsPointInRestrictedMovementArea(owner, rmaPosition) {
        return this.GetFinalResult(false);
      };
      if this.m_checkOnlyRMA {
        return this.GetFinalResult(true);
      };
    };
    if this.m_horTolerance <= 0.00 && this.m_verTolerance <= 0.00 {
      result = AINavigationSystem.HasPathFromAtoB(owner, game, owner.GetWorldPosition(), position);
      return this.GetFinalResult(result);
    };
    navigationSystem = GameInstance.GetAINavigationSystem(owner.GetGame());
    AIPositionSpec.SetEntity(query.source, owner);
    WorldPosition.SetVector4(worldPosition, position);
    AIPositionSpec.SetWorldPosition(query.target, worldPosition);
    queryId = navigationSystem.StartPathfinding(query);
    navigationSystem.GetResult(queryId, navResult);
    navigationSystem.StopPathfinding(queryId);
    if !navResult.hasClosestReachablePoint {
      return this.GetFinalResult(false);
    };
    unreachableDistance = position - WorldPosition.ToVector4(navResult.closestReachablePoint);
    result = unreachableDistance.Z <= this.m_verTolerance && unreachableDistance.X * unreachableDistance.X + unreachableDistance.Y * unreachableDistance.Y <= this.m_horTolerance * this.m_horTolerance;
    return this.GetFinalResult(result);
  }

  private final const func GetFinalResult(result: Bool) -> Bool {
    if this.m_invert {
      return !result;
    };
    return result;
  }
}
