
public static func OperatorEqual(goTarget: wref<GameObject>, target: ref<Target>) -> Bool {
  if goTarget == target.GetTarget() {
    return true;
  };
  return false;
}

public static func OperatorEqual(target: ref<Target>, goTarget: wref<GameObject>) -> Bool {
  if goTarget == target.GetTarget() {
    return true;
  };
  return false;
}

public class SimpleTargetManager extends ScriptableComponent {

  public final static func AddTarget(targetsList: script_ref<[ref<Target>]>, goTarget: wref<GameObject>, isInteresting: Bool, isVisible: Bool) -> Void {
    let newTarget: ref<Target>;
    let targetIndex: Int32 = SimpleTargetManager.IsTargetAlreadyAdded(targetsList, goTarget);
    if targetIndex >= 0 {
      Deref(targetsList)[targetIndex].SetIsVisible(isVisible);
      Deref(targetsList)[targetIndex].SetIsInteresting(isInteresting);
      if !IsFinal() {
      };
      return;
    };
    newTarget = new Target();
    newTarget.CreateTarget(goTarget, isInteresting, isVisible);
    if goTarget.IsPlayer() {
      ArrayInsert(Deref(targetsList), 0, newTarget);
    } else {
      ArrayPush(Deref(targetsList), newTarget);
    };
  }

  public final static func RemoveTarget(targetsList: script_ref<[ref<Target>]>, targetToRemove: wref<GameObject>) -> Bool {
    let foundTarget: ref<Target> = SimpleTargetManager.GetSpecificTarget(targetsList, targetToRemove);
    if !IsDefined(foundTarget) {
      if !IsFinal() {
      };
      return false;
    };
    ArrayRemove(Deref(targetsList), foundTarget);
    return true;
  }

  public final static func SetTargetVisible(const targetsList: script_ref<[ref<Target>]>, targetToRemove: wref<GameObject>, isVisible: Bool) -> Bool {
    let foundTarget: ref<Target> = SimpleTargetManager.GetSpecificTarget(targetsList, targetToRemove);
    if !IsDefined(foundTarget) {
      if !IsFinal() {
      };
      return false;
    };
    foundTarget.SetIsVisible(isVisible);
    return true;
  }

  public final static func RemoveAllTargets(targetsList: script_ref<[ref<Target>]>) -> Void {
    ArrayClear(Deref(targetsList));
  }

  public final static func GetFirstInterestingTargetObject(const targetsList: script_ref<[ref<Target>]>) -> wref<GameObject> {
    let goTarget: wref<GameObject>;
    let target: ref<Target> = SimpleTargetManager.GetFirstInterestingTarget(targetsList);
    if IsDefined(target) {
      goTarget = target.GetTarget();
      if IsDefined(goTarget) {
        return goTarget;
      };
      if !IsFinal() {
      };
      return null;
    };
    if !IsFinal() {
    };
    return null;
  }

  public final static func GetFirstInterestingTarget(const targetsList: script_ref<[ref<Target>]>) -> ref<Target> {
    let i: Int32 = 0;
    while i < ArraySize(Deref(targetsList)) {
      if Deref(targetsList)[i].IsInteresting() && Deref(targetsList)[i].IsVisible() {
        return Deref(targetsList)[i];
      };
      i += 1;
    };
    if !IsFinal() {
    };
    return null;
  }

  public final static func GetSpecificTarget(const targetsList: script_ref<[ref<Target>]>, target: wref<GameObject>) -> ref<Target> {
    let i: Int32 = 0;
    while i < ArraySize(Deref(targetsList)) {
      if target == Deref(targetsList)[i] {
        return Deref(targetsList)[i];
      };
      i += 1;
    };
    if !IsFinal() {
    };
    return null;
  }

  public final static func GetSpecificTarget(const targetsList: script_ref<[ref<Target>]>, targetID: EntityID) -> ref<Target> {
    let i: Int32 = 0;
    while i < ArraySize(Deref(targetsList)) {
      if targetID == Deref(targetsList)[i].GetTarget().GetEntityID() {
        return Deref(targetsList)[i];
      };
      i += 1;
    };
    if !IsFinal() {
    };
    return null;
  }

  public final static func GetSpecificTarget(const targetsList: script_ref<[ref<Target>]>, index: Int32) -> ref<Target> {
    if ArraySize(Deref(targetsList)) == 0 {
      if !IsFinal() {
      };
      return null;
    };
    if index >= 0 && index < ArraySize(Deref(targetsList)) {
      return Deref(targetsList)[index];
    };
    if !IsFinal() {
    };
    return null;
  }

  public final static func IsTargetAlreadyAdded(const targets: script_ref<[ref<Target>]>, targetToCheck: ref<Target>) -> Int32 {
    let i: Int32 = 0;
    while i < ArraySize(Deref(targets)) {
      if targetToCheck == Deref(targets)[i] {
        return i;
      };
      i += 1;
    };
    return -1;
  }

  public final static func IsTargetAlreadyAdded(const targetsList: script_ref<[ref<Target>]>, gameObject: wref<GameObject>) -> Int32 {
    let i: Int32 = 0;
    while i < ArraySize(Deref(targetsList)) {
      if gameObject == Deref(targetsList)[i].GetTarget() {
        return i;
      };
      i += 1;
    };
    return -1;
  }

  public final static func IsTargetVisible(const targetsList: script_ref<[ref<Target>]>, gameObject: wref<GameObject>) -> Bool {
    let i: Int32 = 0;
    while i < ArraySize(Deref(targetsList)) {
      if gameObject == Deref(targetsList)[i].GetTarget() {
        return Deref(targetsList)[i].IsVisible();
      };
      i += 1;
    };
    return false;
  }

  public final static func HasInterestingTargets(const targetsList: script_ref<[ref<Target>]>) -> Bool {
    let i: Int32 = 0;
    while i < ArraySize(Deref(targetsList)) {
      if Deref(targetsList)[i].IsInteresting() && Deref(targetsList)[i].IsVisible() {
        return true;
      };
      i += 1;
    };
    return false;
  }
}

public class Target extends IScriptable {

  private let target: wref<GameObject>;

  private let isInteresting: Bool;

  private let isVisible: Bool;

  public final func CreateTarget(currentTarget: wref<GameObject>, interesting: Bool, visible: Bool) -> Void {
    this.target = currentTarget;
    this.isInteresting = interesting;
    this.isVisible = visible;
  }

  public final func GetTarget() -> wref<GameObject> {
    return this.target;
  }

  public final func IsInteresting() -> Bool {
    return this.isInteresting;
  }

  public final func IsVisible() -> Bool {
    return this.isVisible;
  }

  public final func SetIsInteresting(interestingChange: Bool) -> Void {
    this.isInteresting = interestingChange;
  }

  public final func SetIsVisible(_isVisible: Bool) -> Void {
    this.isVisible = _isVisible;
  }
}
