
public static func DebugGiveHotkeys(gameInstance: GameInstance) -> Void {
  AddFact(gameInstance, n"dpad_hints_visibility_enabled");
  AddFact(gameInstance, n"unlock_phone_hud_dpad");
  AddFact(gameInstance, n"unlock_car_hud_dpad");
  AddFact(gameInstance, n"initial_gadget_picked");
}

public static func AddFact(game: GameInstance, factName: CName, opt factCount: Int32) -> Bool {
  let currentFactCount: Int32;
  if !GameInstance.IsValid(game) {
    return false;
  };
  if !IsNameValid(factName) {
    return false;
  };
  if factCount == 0 {
    factCount = 1;
  };
  currentFactCount = GameInstance.GetQuestsSystem(game).GetFact(factName) + factCount;
  GameInstance.GetQuestsSystem(game).SetFact(factName, currentFactCount);
  return true;
}

public static func SetFactValue(game: GameInstance, factName: CName, factCount: Int32) -> Bool {
  if !GameInstance.IsValid(game) {
    return false;
  };
  if !IsNameValid(factName) {
    return false;
  };
  GameInstance.GetQuestsSystem(game).SetFact(factName, factCount);
  return true;
}

public static func GetFact(game: GameInstance, factName: CName) -> Int32 {
  if !IsNameValid(factName) {
    return 0;
  };
  if !GameInstance.IsValid(game) {
    return 0;
  };
  return GameInstance.GetQuestsSystem(game).GetFact(factName);
}
