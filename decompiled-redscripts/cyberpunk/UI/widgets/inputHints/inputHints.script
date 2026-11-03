
public static func SendInputHintData(context: GameInstance, show: Bool, const data: script_ref<InputHintData>, opt targetHintContainer: CName) -> Void {
  let evt: ref<UpdateInputHintEvent> = new UpdateInputHintEvent();
  evt.data = Deref(data);
  evt.show = show;
  if IsNameValid(targetHintContainer) {
    evt.targetHintContainer = targetHintContainer;
  };
  evt.targetHintContainer = n"GameplayInputHelper";
  GameInstance.GetUISystem(context).QueueEvent(evt);
}
