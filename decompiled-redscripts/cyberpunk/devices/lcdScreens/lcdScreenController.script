
public class SetMessageRecordEvent extends Event {

  @runtimeProperty("customEditor", "TweakDBGroupInheritance;ScreenMessageData")
  public edit let m_messageRecordID: TweakDBID;

  public edit let m_replaceTextWithCustomNumber: Bool;

  public edit let m_customNumber: Int32;

  public final func GetFriendlyDescription() -> String {
    return "Set Message Record";
  }
}

public class LcdScreenController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<LcdScreenControllerPS> {
    return this.GetBasePS() as LcdScreenControllerPS;
  }
}

public class LcdScreenControllerPS extends ScriptableDeviceComponentPS {

  @runtimeProperty("category", "UI")
  @runtimeProperty("customEditor", "TweakDBGroupInheritance;ScreenMessageData")
  private persistent let m_messageRecordID: TweakDBID;

  @runtimeProperty("category", "UI")
  private persistent let m_replaceTextWithCustomNumber: Bool;

  @runtimeProperty("category", "UI")
  private persistent let m_customNumber: Int32;

  @runtimeProperty("category", "UI")
  private inline persistent let m_messageRecordSelector: ref<ScreenMessageSelector>;

  protected cb func OnInstantiated() -> Bool {
    super.OnInstantiated();
    if !IsStringValid(this.m_deviceName) {
      this.m_deviceName = "Gameplay-Devices-DisplayNames-Screen";
    };
  }

  private final func OnSetMessageRecord(evt: ref<SetMessageRecordEvent>) -> EntityNotificationType {
    this.m_messageRecordID = evt.m_messageRecordID;
    this.m_replaceTextWithCustomNumber = evt.m_replaceTextWithCustomNumber;
    this.m_customNumber = evt.m_customNumber;
    if IsDefined(this.m_messageRecordSelector) {
      this.m_messageRecordSelector.SetRecordID(evt.m_messageRecordID);
      this.m_messageRecordSelector.SetReplaceTextWithCustomNumber(evt.m_replaceTextWithCustomNumber);
      this.m_messageRecordSelector.SetCustomNumber(evt.m_customNumber);
    };
    return EntityNotificationType.SendThisEventToEntity;
  }

  protected const func CanCreateAnyQuickHackActions() -> Bool {
    return true;
  }

  protected func GetQuickHackActions(out outActions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    let currentAction: ref<ScriptableDeviceAction> = this.ActionGlitchScreen(t"DeviceAction.GlitchScreenSuicide", t"QuickHack.SuicideHackBase");
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    ArrayPush(outActions, currentAction);
    currentAction = this.ActionGlitchScreen(t"DeviceAction.GlitchScreenBlind", t"QuickHack.BlindHack");
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    ArrayPush(outActions, currentAction);
    currentAction = this.ActionGlitchScreen(t"DeviceAction.GlitchScreenGrenade", t"QuickHack.GrenadeHackBase");
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    ArrayPush(outActions, currentAction);
    if !GlitchScreen.IsDefaultConditionMet(this, context) {
      ScriptableDeviceComponentPS.SetActionsInactiveAll(outActions, "LocKey#7003");
    };
    currentAction = this.ActionQuickHackDistraction();
    currentAction.SetObjectActionID(t"DeviceAction.MalfunctionClassHack");
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    currentAction.SetInactiveWithReason(ScriptableDeviceAction.IsDefaultConditionMet(this, context), "LocKey#7003");
    ArrayPush(outActions, currentAction);
    if this.IsGlitching() || this.IsDistracting() {
      ScriptableDeviceComponentPS.SetActionsInactiveAll(outActions, "LocKey#7004");
    };
    this.FinalizeGetQuickHackActions(outActions, context);
  }

  public func GetQuestActions(out outActions: [ref<DeviceAction>], const context: script_ref<GetActionsContext>) -> Void {
    super.GetQuestActions(outActions, context);
  }

  public const func GetBlackboardDef() -> ref<LcdScreenBlackBoardDef> {
    return GetAllBlackboardDefs().LcdScreenBlackBoard;
  }

  public final const func HasCustomNumber() -> Bool {
    return this.m_replaceTextWithCustomNumber;
  }

  public final const func GetCustomNumber() -> Int32 {
    return this.m_customNumber;
  }

  public final const func GetMessageRecordID() -> TweakDBID {
    let id: TweakDBID;
    if IsDefined(this.m_messageRecordSelector) {
      id = this.m_messageRecordSelector.GetRecordID();
    };
    if !TDBID.IsValid(id) {
      id = this.m_messageRecordID;
    };
    return id;
  }

  protected final func SetMessageRecordID(id: TweakDBID) -> Void {
    this.m_messageRecordID = id;
    if IsDefined(this.m_messageRecordSelector) {
      this.m_messageRecordSelector.SetRecordID(id);
    };
  }

  protected func GetDeviceIconTweakDBID() -> TweakDBID {
    return t"DeviceIcons.ScreenDeviceIcon";
  }

  protected func GetBackgroundTextureTweakDBID() -> TweakDBID {
    return t"DeviceIcons.ScreenDeviceBackground";
  }
}
