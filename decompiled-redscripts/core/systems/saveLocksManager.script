
public class SaveLocksManager extends ScriptableSystem {

  private let m_saveLocks: [CName];

  private func IsSavingLocked() -> Bool {
    return ArraySize(this.m_saveLocks) > 0;
  }

  protected final func OnSaveLockRequest(request: ref<SaveLockRequest>) -> Void {
    if Equals(request.operation, EItemOperationType.ADD) {
      this.AddSaveLock(request.reason);
    } else {
      if Equals(request.operation, EItemOperationType.REMOVE) {
        this.RemoveSaveLock(request.reason);
      };
    };
  }

  private final func AddSaveLock(reason: CName) -> Void {
    if IsNameValid(reason) && !ArrayContains(this.m_saveLocks, reason) {
      ArrayPush(this.m_saveLocks, reason);
    };
  }

  private final func RemoveSaveLock(reason: CName) -> Void {
    ArrayRemove(this.m_saveLocks, reason);
  }

  public final static func RequestSaveLockAdd(game: GameInstance, reason: CName) -> Void {
    let request: ref<SaveLockRequest>;
    if GameInstance.IsValid(game) {
      request = new SaveLockRequest();
      request.operation = EItemOperationType.ADD;
      request.reason = reason;
      GameInstance.QueueScriptableSystemRequest(game, n"SaveLocksManager", request);
    };
  }

  public final static func RequestSaveLockRemove(game: GameInstance, reason: CName) -> Void {
    let request: ref<SaveLockRequest>;
    if GameInstance.IsValid(game) {
      request = new SaveLockRequest();
      request.operation = EItemOperationType.REMOVE;
      request.reason = reason;
      GameInstance.QueueScriptableSystemRequest(game, n"SaveLocksManager", request);
    };
  }
}
