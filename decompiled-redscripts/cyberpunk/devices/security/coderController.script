
public class CoderController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<CoderControllerPS> {
    return this.GetBasePS() as CoderControllerPS;
  }
}

public class CoderControllerPS extends BasicDistractionDeviceControllerPS {

  @runtimeProperty("tooltip", "Whoever uses this device is granted provided security access level")
  @default(CoderControllerPS, ESecurityAccessLevel.ESL_4)
  private let m_providedAuthorizationLevel: ESecurityAccessLevel;

  protected func ActionAuthorizeUser(opt isForced: Bool) -> ref<AuthorizeUser> {
    let action: ref<AuthorizeUser> = super.ActionAuthorizeUser(isForced);
    action.CreateInteraction();
    return action;
  }

  public func OnAuthorizeUser(evt: ref<AuthorizeUser>) -> EntityNotificationType {
    let secSys: ref<SecuritySystemControllerPS> = this.GetSecuritySystem();
    if IsDefined(secSys) {
      secSys.AuthorizeUser(evt.GetExecutor().GetEntityID(), this.m_providedAuthorizationLevel);
      return EntityNotificationType.SendThisEventToEntity;
    };
    return EntityNotificationType.DoNotNotifyEntity;
  }

  public func GetActions(out outActions: [ref<DeviceAction>], context: GetActionsContext) -> Bool {
    let secSys: ref<SecuritySystemControllerPS> = this.GetSecuritySystem();
    if !IsDefined(secSys) {
      return false;
    };
    if !secSys.IsUserAuthorized(context.processInitiatorObject.GetEntityID(), this.m_providedAuthorizationLevel) {
      if !secSys.IsEntityBlacklistedForAtLeast(context.processInitiatorObject.GetEntityID(), BlacklistReason.COMBAT) {
        ArrayPush(outActions, this.ActionAuthorizeUser(this.ShouldForceAuthorizeUser(context)));
      };
    };
    return true;
  }

  protected func GetDeviceIconTweakDBID() -> TweakDBID {
    return t"DeviceIcons.SecuritySystemDeviceIcon";
  }

  protected func GetBackgroundTextureTweakDBID() -> TweakDBID {
    return t"DeviceIcons.SecuritySystemDeviceBackground";
  }
}
