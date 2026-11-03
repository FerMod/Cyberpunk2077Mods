
public class CrouchIndicatorGameController extends inkHUDGameController {

  private edit let m_crouchIcon: inkImageRef;

  private let m_genderName: CName;

  private let m_psmLocomotionStateChangedCallback: ref<CallbackHandle>;

  protected cb func OnPlayerAttach(player: ref<GameObject>) -> Bool {
    let psmBlackboard: wref<IBlackboard> = this.GetPSMBlackboard(player);
    this.m_genderName = (player as PlayerPuppet).GetResolvedGenderName();
    if player.IsControlledByLocalPeer() {
      this.m_psmLocomotionStateChangedCallback = psmBlackboard.RegisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Locomotion, this, n"OnPSMLocomotionStateChanged");
      this.OnPSMLocomotionStateChanged(psmBlackboard.GetInt(GetAllBlackboardDefs().PlayerStateMachine.Locomotion));
    };
  }

  protected cb func OnPlayerDetach(player: ref<GameObject>) -> Bool {
    this.GetPSMBlackboard(player).UnregisterListenerInt(GetAllBlackboardDefs().PlayerStateMachine.Locomotion, this.m_psmLocomotionStateChangedCallback);
  }

  protected cb func OnPSMLocomotionStateChanged(value: Int32) -> Bool {
    if Equals(IntEnum<gamePSMLocomotionStates>(value), gamePSMLocomotionStates.Crouch) || Equals(IntEnum<gamePSMLocomotionStates>(value), gamePSMLocomotionStates.CrouchDodge) || Equals(IntEnum<gamePSMLocomotionStates>(value), gamePSMLocomotionStates.Slide) {
      if Equals(this.m_genderName, n"Female") {
        inkImageRef.SetTexturePart(this.m_crouchIcon, n"crouch_female");
      } else {
        inkImageRef.SetTexturePart(this.m_crouchIcon, n"crouch");
      };
    } else {
      if Equals(this.m_genderName, n"Female") {
        inkImageRef.SetTexturePart(this.m_crouchIcon, n"stand_female");
      } else {
        inkImageRef.SetTexturePart(this.m_crouchIcon, n"stand");
      };
    };
  }
}
