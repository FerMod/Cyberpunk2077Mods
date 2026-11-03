
public class SceneForceWeaponAim extends Event {

  public final func GetFriendlyDescription() -> String {
    return "Force V to aim weapon";
  }
}

public class SceneFirstEquipState extends Event {

  public edit let prevented: Bool;

  public final func GetFriendlyDescription() -> String {
    return "Prevet weapon first equip animation";
  }
}

public class SceneForceWeaponSafe extends Event {

  public edit let weaponLoweringSpeedOverride: Float;

  public final func GetFriendlyDescription() -> String {
    return "Force V to equip/lower weapon";
  }
}

public class ManagePersonalLinkChangeEvent extends Event {

  public edit let shouldEquip: Bool;

  public final func GetFriendlyDescription() -> String {
    return "Manager Personal Link Visualisation";
  }
}

public class EnableBraindanceActions extends Event {

  public edit let actionMask: SBraindanceInputMask;

  public final func GetFriendlyDescription() -> String {
    return "Enables all actions that are set to true in the actionMask struct";
  }
}

public class BraindanceInputChangeEvent extends Event {

  public let bdSystem: ref<BraindanceSystem>;

  public final func GetFriendlyDescription() -> String {
    return "signals that braindance controls changed and need a UI refresh";
  }
}

public class DisableBraindanceActions extends Event {

  public edit let actionMask: SBraindanceInputMask;

  public final func GetFriendlyDescription() -> String {
    return "Disables all actions that are set to true in the actionMask struct";
  }
}

public class ForceBraindanceCameraToggle extends Event {

  public edit let editorState: Bool;

  public final func GetFriendlyDescription() -> String {
    return "Setting editorState will force enable the Editor (view from braindance replacer)";
  }
}

public class PauseBraindance extends Event {

  public final func GetFriendlyDescription() -> String {
    return "Forces pause in braindance";
  }
}

public class FelledEvent extends Event {

  public edit let m_active: Bool;

  public final func GetFriendlyDescription() -> String {
    return "Force V to be in felled state.";
  }
}
