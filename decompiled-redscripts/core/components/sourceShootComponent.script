
public native class SourceShootComponent extends IComponent {

  public final native func GetContinuousLineOfSightToTarget(target: ref<GameObject>, out continuousLineOfSight: Float) -> Bool;

  public final native func CanSeeSecondaryPointOfTarget(target: ref<GameObject>) -> Bool;

  public final native func GetLineOfSightTBHModifier(target: ref<GameObject>) -> Float;

  public final native func ClearDebugInformation() -> Void;

  public final native func AppendDebugInformation(lineToAppend: String) -> Void;

  public final func SetDebugParameters(const params: script_ref<TimeBetweenHitsParameters>) -> Void {
    this.ClearDebugInformation();
    this.AppendDebugInformation("DIFFICULTY: " + FloatToString(Deref(params).difficultyLevelCoefficient));
    this.AppendDebugInformation("TARGET: " + FloatToString(Deref(params).baseCoefficient));
    this.AppendDebugInformation("SOURCE: " + FloatToString(Deref(params).baseSourceCoefficient));
    this.AppendDebugInformation("ACCURACY: " + FloatToString(Deref(params).accuracyCoefficient));
    this.AppendDebugInformation("DISTANCE: " + FloatToString(Deref(params).distanceCoefficient));
    this.AppendDebugInformation("VISIBILITY: " + FloatToString(Deref(params).visibilityCoefficient));
    this.AppendDebugInformation("PLAYERS: " + FloatToString(Deref(params).playersCountCoefficient));
    this.AppendDebugInformation("GROUP: " + FloatToString(Deref(params).groupCoefficient));
    this.AppendDebugInformation("COVER: " + FloatToString(Deref(params).coverCoefficient));
    this.AppendDebugInformation("VISION BLOCKERS: " + FloatToString(Deref(params).visionBlockerCoefficient));
  }
}
