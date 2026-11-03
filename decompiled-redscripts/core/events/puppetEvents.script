
public class ApplyNewStatusEffectEvent extends Event {

  public let effectID: TweakDBID;

  public let instigatorID: TweakDBID;

  public final func SetEffectID(const effectName: script_ref<String>) -> Void {
    this.effectID = TDBID.Create(Deref(effectName));
  }
}

public class RemoveStatusEffectEvent extends Event {

  public let effectID: TweakDBID;

  public let removeCount: Uint32;

  public final func SetEffectID(const effectName: script_ref<String>) -> Void {
    this.effectID = TDBID.Create(Deref(effectName));
  }
}
