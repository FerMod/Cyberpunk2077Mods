
public class InputContextSystem extends ScriptableSystem {

  private let activeContext: inputContextType;

  private final func OnPlayerAttach(request: ref<PlayerAttachRequest>) -> Void {
    this.activeContext = inputContextType.RPG;
  }

  public final const func GetActiveContext() -> inputContextType {
    return this.activeContext;
  }

  public final const func IsActiveContextAction() -> Bool {
    return Equals(this.activeContext, inputContextType.Action);
  }

  public final const func IsActiveContextRPG() -> Bool {
    return Equals(this.activeContext, inputContextType.RPG);
  }

  private final func OnChangeActiveContextRequest(request: ref<ChangeActiveContextRequest>) -> Void {
    this.activeContext = request.newContext;
  }
}
