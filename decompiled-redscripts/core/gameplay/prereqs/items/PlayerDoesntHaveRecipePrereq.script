
public class PlayerDoesntHaveRecipePrereq extends IScriptablePrereq {

  public let m_recipeID: TweakDBID;

  public let m_invert: Bool;

  protected func Initialize(recordID: TweakDBID) -> Void {
    this.m_recipeID = TDBID.Create(TweakDBInterface.GetString(recordID + t".recipe", ""));
    this.m_invert = TweakDBInterface.GetBool(recordID + t".invert", false);
  }

  protected const func OnApplied(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Void {
    let craftingSystem: ref<CraftingSystem> = CraftingSystem.GetInstance(game);
    let playerCraftBook: ref<CraftBook> = craftingSystem.GetPlayerCraftBook();
    let result: Bool = !craftingSystem.IsRecipeKnown(this.m_recipeID, playerCraftBook);
    (state as PlayerDoesntHaveRecipePrereqState).OnChanged(result);
  }

  public const func IsFulfilled(game: GameInstance, context: ref<IScriptable>) -> Bool {
    let craftingSystem: ref<CraftingSystem> = CraftingSystem.GetInstance(game);
    let playerCraftBook: ref<CraftBook> = craftingSystem.GetPlayerCraftBook();
    let result: Bool = !craftingSystem.IsRecipeKnown(this.m_recipeID, playerCraftBook);
    if this.m_invert {
      return !result;
    };
    return result;
  }
}
