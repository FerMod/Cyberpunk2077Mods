
public class ClearQuickhackQueueEffector extends Effector {

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    let player: wref<GameObject> = GameInstance.GetPlayerSystem(owner.GetGame()).GetLocalPlayerMainGameObject();
    this.ClearQuickhackQueue(owner as ScriptedPuppet, player);
  }

  public final func ClearQuickhackQueue(scriptedPuppet: ref<ScriptedPuppet>, player: wref<GameObject>) -> Void {
    let action: ref<ScriptableDeviceAction>;
    let currentAction: ref<ScriptableDeviceAction>;
    let deviceActionQueue: ref<DeviceActionQueue>;
    if !IsDefined(scriptedPuppet) {
      return;
    };
    currentAction = scriptedPuppet.GetCurrentlyUploadingAction();
    if !IsDefined(currentAction) {
      return;
    };
    deviceActionQueue = currentAction.m_deviceActionQueue;
    if !IsDefined(deviceActionQueue) {
      return;
    };
    while deviceActionQueue.HasActionInQueue() {
      action = deviceActionQueue.PopActionInQueue() as ScriptableDeviceAction;
      if IsDefined(action) && action.GetExecutor() == player {
        RPGManager.DecrementQuickHackBlackboard(scriptedPuppet.GetGame(), action.GetObjectActionID());
        QuickHackableQueueHelper.DecreaseQuickHackQueueCount(action.GetExecutor() as PlayerPuppet);
      };
    };
    scriptedPuppet.QueueEvent(new DeactivateQuickHackIndicatorEvent());
    QuickhackModule.RequestRefreshQuickhackMenu(player.GetGame(), currentAction.GetRequesterID());
  }
}
