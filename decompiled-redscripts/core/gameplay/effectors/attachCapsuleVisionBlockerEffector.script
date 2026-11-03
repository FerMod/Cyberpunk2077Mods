
public class AttachCapsuleVisionBlockerEffector extends Effector {

  private let m_visionBlockerRegistrar: ref<VisionBlockersRegistrar>;

  private let m_visionBlockerType: EVisionBlockerType;

  private let m_visionBlockerId: Uint32;

  private let m_visionBlockerOffset: Vector3;

  private let m_visionBlockerRadius: Float;

  private let m_visionBlockerHeight: Float;

  private let m_visionBlockerDetectionModifier: Float;

  private let m_visionBlockerTBHModifier: Float;

  private let m_isBlockingCompletely: Bool;

  private let m_blocksParent: Bool;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    let visionBlockerTypeName: CName = TweakDBInterface.GetCName(record + t".visionBlockerTypeName", n"None");
    this.m_visionBlockerType = IntEnum<EVisionBlockerType>(Cast<Int32>(EnumValueFromName(n"EVisionBlockerType", visionBlockerTypeName)));
    this.m_visionBlockerOffset = TweakDBInterface.GetVector3(record + t".visionBlockerOffset", new Vector3());
    this.m_visionBlockerRadius = TweakDBInterface.GetFloat(record + t".visionBlockerRadius", 0.00);
    this.m_visionBlockerHeight = TweakDBInterface.GetFloat(record + t".visionBlockerHeight", 0.00);
    this.m_visionBlockerDetectionModifier = TweakDBInterface.GetFloat(record + t".visionBlockerDetectionModifier", 1.00);
    this.m_visionBlockerTBHModifier = TweakDBInterface.GetFloat(record + t".visionBlockerTBHModifier", 1.00);
    this.m_isBlockingCompletely = TweakDBInterface.GetBool(record + t".isBlockingCompletely", false);
    this.m_blocksParent = TweakDBInterface.GetBool(record + t".blocksParent", true);
    this.m_visionBlockerId = 0u;
    this.m_visionBlockerRegistrar = GameInstance.GetSenseManager(game).GetVisionBlockersRegistrar();
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    let visionBlockerShape: ref<VisionBlockerShape_BasicCapsule> = VisionBlockerShape_BasicCapsule.Create(owner.GetWorldPosition(), this.m_visionBlockerRadius, this.m_visionBlockerHeight);
    this.m_visionBlockerId = this.m_visionBlockerRegistrar.RegisterVisionBlocker(visionBlockerShape, this.m_visionBlockerType, this.m_visionBlockerDetectionModifier, this.m_visionBlockerTBHModifier, this.m_isBlockingCompletely, this.m_blocksParent);
    this.m_visionBlockerRegistrar.AttachToParent(this.m_visionBlockerId, owner, Vector4.Vector3To4(this.m_visionBlockerOffset));
  }

  protected func ActionOff(owner: ref<GameObject>) -> Void {
    this.UnregisterVisionBlocker();
  }

  protected func Uninitialize(game: GameInstance) -> Void {
    this.UnregisterVisionBlocker();
  }

  private final func UnregisterVisionBlocker() -> Void {
    this.m_visionBlockerRegistrar.UnregisterVisionBlocker(this.m_visionBlockerId);
  }

  public final func SetBlockingCompletely(blockingCompletely: Bool) -> Void {
    this.m_isBlockingCompletely = blockingCompletely;
    this.m_visionBlockerRegistrar.SetIsBlockingCompletely(this.m_visionBlockerId, blockingCompletely);
  }
}
