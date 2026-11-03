
public native class BaseStrategyRequest extends IScriptable {

  private native let strategy: vehiclePoliceStrategy;

  public native let distanceRange: Vector2;

  public native let minDirectDistance: Float;

  public final const func GetStrategy() -> vehiclePoliceStrategy {
    return this.strategy;
  }
}

public native class DriveTowardsPlayerStrategyRequest extends BaseStrategyRequest {

  public final static func Create(spawnDistanceRange: Vector2, minDirectDist: Float) -> ref<DriveTowardsPlayerStrategyRequest> {
    let request: ref<DriveTowardsPlayerStrategyRequest> = new DriveTowardsPlayerStrategyRequest();
    request.distanceRange = spawnDistanceRange;
    request.minDirectDistance = minDirectDist;
    return request;
  }
}

public native class DriveAwayFromPlayerStrategyRequest extends BaseStrategyRequest {

  public final static func Create(spawnDistanceRange: Vector2, minDirectDist: Float) -> ref<DriveAwayFromPlayerStrategyRequest> {
    let request: ref<DriveAwayFromPlayerStrategyRequest> = new DriveAwayFromPlayerStrategyRequest();
    request.distanceRange = spawnDistanceRange;
    request.minDirectDistance = minDirectDist;
    return request;
  }
}

public native class PatrolNearbyStrategyRequest extends BaseStrategyRequest {

  public native let angleRange: Vector2;

  public final static func Create(spawnDistanceRange: Vector2, spawnAngleRange: Vector2) -> ref<PatrolNearbyStrategyRequest> {
    let request: ref<PatrolNearbyStrategyRequest> = new PatrolNearbyStrategyRequest();
    request.distanceRange = spawnDistanceRange;
    request.angleRange = spawnAngleRange;
    return request;
  }
}

public native class InterceptAtNextIntersectionStrategyRequest extends BaseStrategyRequest {

  public native let distancesToIntersectionRatio: Float;

  public final static func Create(spawnDistanceRange: Vector2, minDirectDist: Float) -> ref<InterceptAtNextIntersectionStrategyRequest> {
    let request: ref<InterceptAtNextIntersectionStrategyRequest> = new InterceptAtNextIntersectionStrategyRequest();
    request.distanceRange.X = 100.00;
    request.distanceRange.Y = 200.00;
    request.distancesToIntersectionRatio = 0.50;
    request.minDirectDistance = minDirectDist;
    return request;
  }
}

public native class GetToPlayerFromAnywhereStrategyRequest extends BaseStrategyRequest {

  public final static func Create(spawnDistanceRange: Vector2, minDirectDist: Float) -> ref<GetToPlayerFromAnywhereStrategyRequest> {
    let request: ref<GetToPlayerFromAnywhereStrategyRequest> = new GetToPlayerFromAnywhereStrategyRequest();
    request.distanceRange = spawnDistanceRange;
    request.minDirectDistance = minDirectDist;
    return request;
  }
}

public native class InitialSearchStrategyRequest extends BaseStrategyRequest {

  public final static func Create(spawnDistanceRange: Vector2, minDirectDist: Float) -> ref<InitialSearchStrategyRequest> {
    let request: ref<InitialSearchStrategyRequest> = new InitialSearchStrategyRequest();
    request.distanceRange = spawnDistanceRange;
    request.minDirectDistance = minDirectDist;
    return request;
  }
}

public native class SearchFromAnywhereStrategyRequest extends BaseStrategyRequest {

  public native let angleRange: Vector2;

  public final static func Create(spawnDistanceRange: Vector2, spawnAngleRange: Vector2) -> ref<SearchFromAnywhereStrategyRequest> {
    let request: ref<SearchFromAnywhereStrategyRequest> = new SearchFromAnywhereStrategyRequest();
    request.distanceRange = spawnDistanceRange;
    request.angleRange = spawnAngleRange;
    return request;
  }
}
