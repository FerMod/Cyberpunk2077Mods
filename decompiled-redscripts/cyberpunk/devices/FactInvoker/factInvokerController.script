
public class FactInvokerController extends MasterController {

  public const func GetPS() -> ref<FactInvokerControllerPS> {
    return this.GetBasePS() as FactInvokerControllerPS;
  }
}

public class FactInvokerDataEntry extends IScriptable {

  private let m_fact: CName;

  private let m_password: CName;

  public final func GetFact() -> CName {
    return this.m_fact;
  }

  public final func GetPassword() -> CName {
    return this.m_password;
  }
}

public class FactInvokerControllerPS extends MasterControllerPS {

  private inline const let m_factDataEntries: [ref<FactInvokerDataEntry>];

  private let m_passwords: [CName];

  private let m_arePasswordsInitialized: Bool;

  protected func GameAttached() -> Void {
    this.EnsurePasswordsPresence();
  }

  public const func GetPasswords() -> [CName] {
    return this.m_passwords;
  }

  public const quest func IsDeviceSecured() -> Bool {
    return ArraySize(this.m_passwords) > 0;
  }

  private final func EnsurePasswordsPresence() -> Void {
    let i: Int32;
    if !this.m_arePasswordsInitialized {
      i = 0;
      while i < ArraySize(this.m_factDataEntries) {
        ArrayPush(this.m_passwords, this.m_factDataEntries[i].GetPassword());
        i += 1;
      };
      this.m_arePasswordsInitialized = true;
    };
  }

  public func OnAuthorizeUser(evt: ref<AuthorizeUser>) -> EntityNotificationType {
    let notifier: ref<ActionNotifier> = new ActionNotifier();
    notifier.SetAll();
    this.TryInvokeFact(evt);
    this.Notify(notifier, evt);
    return EntityNotificationType.DoNotNotifyEntity;
  }

  private final func TryInvokeFact(evt: ref<AuthorizeUser>) -> Void {
    let fact: CName;
    let enteredPassword: CName = evt.GetEnteredPassword();
    let questSystem: ref<QuestsSystem> = GameInstance.GetQuestsSystem(this.GetGameInstance());
    if this.UserAuthorizationAttempt(evt.GetExecutor().GetEntityID(), enteredPassword) && this.TryGetFact(enteredPassword, fact) {
      questSystem.SetFact(fact, 1);
    };
  }

  private final func TryGetFact(password: CName, out fact: CName) -> Bool {
    let i: Int32 = 0;
    while i < ArraySize(this.m_factDataEntries) {
      if Equals(this.m_factDataEntries[i].GetPassword(), password) {
        fact = this.m_factDataEntries[i].GetFact();
        return true;
      };
      i += 1;
    };
    return false;
  }

  protected func GetInkWidgetTweakDBID(const context: script_ref<GetActionsContext>) -> TweakDBID {
    return t"DevicesUIDefinitions.KeypadWithAuthorizationButtonWidget";
  }

  public func GetActions(out outActions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    ArrayPush(outActions, this.ActionAuthorizeUser(this.ShouldForceAuthorizeUser(context)));
    if this.ShouldShowExamineIntaraction() && !this.IsPlayerPerformingTakedown() {
      ArrayPush(outActions, this.ActionToggleZoomInteraction());
    };
    return false;
  }

  protected func IgnoreDisallowedAction(name: String) -> Bool {
    if Equals(name, "ToggleZoomInteraction") {
      return true;
    };
    return false;
  }
}
