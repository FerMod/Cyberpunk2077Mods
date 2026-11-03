
public class ToggleMaterialOverlayEffector extends Effector {

  private let m_effectPath: String;

  private let m_effectTag: CName;

  private let m_owner: wref<GameObject>;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_effectPath = TweakDBInterface.GetString(record + t".effectPath", "");
    this.m_effectTag = TweakDBInterface.GetCName(record + t".effectTag", n"None");
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    this.m_owner = owner;
    this.ToggleEffect(true);
  }

  protected func ActionOff(owner: ref<GameObject>) -> Void {
    this.ToggleEffect(false);
  }

  protected func Uninitialize(game: GameInstance) -> Void {
    this.ToggleEffect(false);
  }

  private final func ToggleEffect(enable: Bool) -> Void {
    let effectInstance: ref<EffectInstance>;
    if IsDefined(this.m_owner) {
      effectInstance = GameInstance.GetGameEffectSystem(this.m_owner.GetGame()).CreateEffectStatic(StringToName(this.m_effectPath), this.m_effectTag, this.m_owner);
      EffectData.SetEntity(effectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.entity, this.m_owner);
      EffectData.SetBool(effectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.renderMaterialOverride, false);
      EffectData.SetBool(effectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.enable, enable);
      effectInstance.Run();
    };
  }
}
