
public class CerberusRangedKillTask extends AIbehaviortaskScript {

  protected inline edit let m_inCommand: ref<AIArgumentMapping>;

  protected let m_currentCommand: wref<AIShootCommand>;

  protected let m_threatPersistenceSource: ref<AIThreatPersistenceSource_Record>;

  protected let m_activationTimeStamp: Float;

  protected let m_commandDuration: Float;

  protected let m_target: wref<GameObject>;

  protected let m_targetID: EntityID;

  public let m_playerPuppet: wref<PlayerPuppet>;

  private let fadeOutStarted: Bool;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let rotation: EulerAngles;
    let target: wref<GameObject> = ScriptExecutionContext.GetArgumentObject(context, n"CombatTarget");
    let testCoord: Vector4 = new Vector4(-2174.81, -2376.33, -192.68, 1.00);
    GameInstance.GetTeleportationFacility(AIBehaviorScriptBase.GetGame(context)).Teleport(target, testCoord, rotation);
  }

  private final func Deactivate(context: ScriptExecutionContext) -> Void;

  protected final func CancelCommand(context: ScriptExecutionContext) -> Void;
}
