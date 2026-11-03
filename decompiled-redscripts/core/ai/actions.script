
public static func GetActionAnimationSlideParams(slideRecord: ref<AIActionSlideData_Record>) -> ActionAnimationSlideParams {
  let resultParams: ActionAnimationSlideParams;
  resultParams.distance = slideRecord.Distance();
  resultParams.directionAngle = slideRecord.DirectionAngle();
  resultParams.finalRotationAngle = slideRecord.FinalRotationAngle();
  resultParams.offsetToTarget = slideRecord.OffsetToTarget();
  resultParams.offsetAroundTarget = slideRecord.OffsetAroundTarget();
  resultParams.slideToTarget = IsDefined(slideRecord.Target());
  resultParams.duration = slideRecord.Duration();
  resultParams.positionSpeed = slideRecord.PositionSpeed();
  resultParams.rotationSpeed = slideRecord.RotationSpeed();
  resultParams.slideStartDelay = slideRecord.SlideStartDelay();
  resultParams.usePositionSlide = slideRecord.UsePositionSlide();
  resultParams.useRotationSlide = slideRecord.UseRotationSlide();
  resultParams.maxSlidePositionDistance = slideRecord.Distance();
  resultParams.zAlignmentThreshold = slideRecord.ZAlignmentCollisionThreshold();
  resultParams.maxTargetVelocity = 0.00;
  resultParams.maxSlideRotationAngle = 135.00;
  return resultParams;
}
