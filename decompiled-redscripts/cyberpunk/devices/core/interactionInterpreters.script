
public class BasicInteractionInterpreter extends IScriptable {

  public final static func Evaluate(isSecured: Bool, actions: [ref<DeviceAction>], allApplicableChoices: script_ref<[InteractionChoice]>, onlyInteractableChoices: script_ref<[InteractionChoice]>) -> Void {
    let choices: array<InteractionChoice>;
    let currentChoiceMetaData: ChoiceTypeWrapper;
    let i: Int32 = 0;
    while i < ArraySize(actions) {
      if IsDefined(actions[i] as TogglePersonalLink) {
        ArrayPush(choices, (actions[i] as TogglePersonalLink).GetInteractionChoice());
        ArrayErase(actions, i);
        break;
      };
      i += 1;
    };
    i = 0;
    while i < ArraySize(actions) {
      if (actions[i] as ScriptableDeviceAction).IsQuickHack() || !(actions[i] as ScriptableDeviceAction).IsInteractionChoiceValid() {
      } else {
        ArrayPush(choices, (actions[i] as ScriptableDeviceAction).GetInteractionChoice());
      };
      i += 1;
    };
    allApplicableChoices = choices;
    i = 0;
    while i < ArraySize(Deref(allApplicableChoices)) {
      currentChoiceMetaData = Deref(allApplicableChoices)[i].choiceMetaData.type;
      if ChoiceTypeWrapper.IsType(currentChoiceMetaData, gameinteractionsChoiceType.Inactive) || ArraySize(Deref(allApplicableChoices)[i].data) == 0 {
      } else {
        if NotEquals(Deref(allApplicableChoices)[i].choiceMetaData.tweakDBName, "") || TDBID.IsValid(Deref(allApplicableChoices)[i].choiceMetaData.tweakDBID) {
          ArrayPush(Deref(onlyInteractableChoices), Deref(allApplicableChoices)[i]);
        };
      };
      i += 1;
    };
  }
}
