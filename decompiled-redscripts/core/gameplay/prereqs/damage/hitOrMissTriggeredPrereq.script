
public class HitOrMissTriggeredPrereqState extends GenericHitPrereqState {

  public func OnMissTriggered(missEvent: ref<gameMissEvent>) -> Void {
    let checkPassed: Bool;
    let hitEvent: ref<gameHitEvent>;
    if Vector4.IsXYZZero(missEvent.hitPosition) {
      return;
    };
    super.OnMissTriggered(missEvent);
    hitEvent = new gameHitEvent();
    hitEvent.attackData = missEvent.attackData;
    hitEvent.hitPosition = missEvent.hitPosition;
    hitEvent.hitDirection = missEvent.hitDirection;
    hitEvent.attackPentration = missEvent.attackPentration;
    hitEvent.hasPiercedTechSurface = missEvent.hasPiercedTechSurface;
    hitEvent.attackComputed = missEvent.attackComputed;
    this.SetHitEvent(hitEvent);
    checkPassed = this.Evaluate(hitEvent);
    if checkPassed {
      this.OnChangedRepeated(false);
    };
  }
}
