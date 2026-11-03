
public abstract class EffectDataHelper extends IScriptable {

  public final static func FillMeleeEffectData(effectData: EffectData, colliderBoxSize: Vector4, duration: Float, position: Vector4, rotation: Quaternion, direction: Vector4, range: Float, initRange: Float, width: Float, axisConstraints: Vector4, coneHalfAngle: Float) -> Void {
    EffectData.SetVector(effectData, GetAllBlackboardDefs().EffectSharedData.box, colliderBoxSize);
    EffectData.SetFloat(effectData, GetAllBlackboardDefs().EffectSharedData.duration, duration);
    EffectData.SetVector(effectData, GetAllBlackboardDefs().EffectSharedData.position, position);
    EffectData.SetQuat(effectData, GetAllBlackboardDefs().EffectSharedData.rotation, rotation);
    EffectData.SetVector(effectData, GetAllBlackboardDefs().EffectSharedData.forward, direction);
    EffectData.SetFloat(effectData, GetAllBlackboardDefs().EffectSharedData.range, range);
    EffectData.SetFloat(effectData, GetAllBlackboardDefs().EffectSharedData.radius, range);
    EffectData.SetFloat(effectData, GetAllBlackboardDefs().EffectSharedData.initRange, initRange);
    EffectData.SetFloat(effectData, GetAllBlackboardDefs().EffectSharedData.width, width);
    EffectData.SetVector(effectData, GetAllBlackboardDefs().EffectSharedData.axisConstraints, axisConstraints);
    EffectData.SetFloat(effectData, GetAllBlackboardDefs().EffectSharedData.angle, coneHalfAngle);
  }
}
