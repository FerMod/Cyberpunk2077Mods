
public class ApplyShaderEffector extends Effector {

  private let m_overrideMaterialName: CName;

  private let m_overrideMaterialTag: CName;

  private let m_applyToOwner: Bool;

  private let m_applyToWeapon: Bool;

  private let m_owner: wref<GameObject>;

  private let m_ownerWeapons: [wref<ItemObject>];

  @default(ApplyShaderEffector, false)
  private let m_isEnabled: Bool;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_overrideMaterialName = TweakDBInterface.GetCName(record + t".overrideMaterialName", n"None");
    this.m_overrideMaterialTag = TweakDBInterface.GetCName(record + t".overrideMaterialTag", n"None");
    this.m_applyToOwner = TweakDBInterface.GetBool(record + t".applyToOwner", false);
    this.m_applyToWeapon = TweakDBInterface.GetBool(record + t".applyToWeapon", false);
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    let effectInstance: ref<EffectInstance>;
    let effectInstanceWeapon: ref<EffectInstance>;
    let i: Int32;
    if this.m_applyToOwner {
      this.m_owner = owner;
    };
    if this.m_applyToWeapon {
      AIActionHelper.GetItemsFromWeaponSlots(owner, this.m_ownerWeapons);
    };
    if !this.m_isEnabled && IsNameValid(this.m_overrideMaterialName) {
      effectInstance = GameInstance.GetGameEffectSystem(this.m_owner.GetGame()).CreateEffectStatic(this.m_overrideMaterialName, this.m_overrideMaterialTag, this.m_owner);
      effectInstanceWeapon = GameInstance.GetGameEffectSystem(this.m_owner.GetGame()).CreateEffectStatic(this.m_overrideMaterialName, this.m_overrideMaterialTag, this.m_owner);
      if this.m_applyToOwner && IsDefined(effectInstance) {
        EffectData.SetBool(effectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.enable, true);
        EffectData.SetEntity(effectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.entity, this.m_owner);
        effectInstance.Run();
      };
      if this.m_applyToWeapon && IsDefined(effectInstanceWeapon) {
        EffectData.SetBool(effectInstanceWeapon.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.enable, true);
        i = 0;
        while i < ArraySize(this.m_ownerWeapons) {
          EffectData.SetEntity(effectInstanceWeapon.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.entity, this.m_ownerWeapons[i]);
          i += 1;
        };
        effectInstanceWeapon.Run();
      };
      this.m_isEnabled = true;
    };
  }

  protected func Uninitialize(game: GameInstance) -> Void {
    let effectInstance: ref<EffectInstance>;
    let effectInstanceWeapon: ref<EffectInstance>;
    let i: Int32;
    if this.m_isEnabled && IsNameValid(this.m_overrideMaterialName) {
      effectInstance = GameInstance.GetGameEffectSystem(game).CreateEffectStatic(this.m_overrideMaterialName, this.m_overrideMaterialTag, this.m_owner);
      effectInstanceWeapon = GameInstance.GetGameEffectSystem(this.m_owner.GetGame()).CreateEffectStatic(this.m_overrideMaterialName, this.m_overrideMaterialTag, this.m_owner);
      if IsDefined(effectInstance) {
        EffectData.SetBool(effectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.enable, false);
        EffectData.SetEntity(effectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.entity, this.m_owner);
        EffectData.SetEntity(effectInstanceWeapon.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.entity, this.m_owner);
        effectInstance.Run();
        this.m_isEnabled = false;
      };
      if IsDefined(effectInstanceWeapon) {
        EffectData.SetBool(effectInstanceWeapon.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.enable, false);
        EffectData.SetEntity(effectInstanceWeapon.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.entity, this.m_owner);
        i = 0;
        while i < ArraySize(this.m_ownerWeapons) {
          EffectData.SetEntity(effectInstance.GetSharedData(), GetAllBlackboardDefs().EffectSharedData.entity, this.m_ownerWeapons[i]);
          i += 1;
        };
        effectInstanceWeapon.Run();
        this.m_isEnabled = false;
      };
    };
  }
}
