
public native class MountEventData extends IScriptable {

  public native let slotName: CName;

  public native let mountParentEntityId: EntityID;

  public native let isInstant: Bool;

  public native let entryAnimName: CName;

  public native let entrySlotName: CName;

  public native let initialTransformLS: Transform;

  public native let mountEventOptions: ref<MountEventOptions>;

  public native let removePitchRollRotationOnDismount: Bool;

  public native let ignoreHLS: Bool;

  public final func IsTransitionForced() -> Bool {
    if Equals(this.slotName, n"trunk_body") {
      return true;
    };
    return false;
  }
}
