
public class DetectionMeterEffector extends Effector {

  private let m_statusEffectID: TweakDBID;

  private let m_detectionStep: Float;

  private let m_maxStacks: Int32;

  private let m_onlyHostileDetection: Bool;

  private let m_dontRemoveStacks: Bool;

  private let m_detectionListener: ref<CallbackHandle>;

  private let m_currentStacks: Int32;

  private let m_gameInstance: GameInstance;

  private let m_ownerID: EntityID;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_gameInstance = game;
    this.m_statusEffectID = TDB.GetForeignKey(record + t".statusEffect");
    this.m_detectionStep = TDB.GetFloat(record + t".detectionStep");
    this.m_maxStacks = TDB.GetInt(record + t".maxStacks");
    this.m_onlyHostileDetection = TDB.GetBool(record + t".onlyHostileDetection");
    this.m_dontRemoveStacks = TDB.GetBool(record + t".dontRemoveStacks");
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    this.m_ownerID = owner.GetEntityID();
    let blackboard: ref<IBlackboard> = GameInstance.GetBlackboardSystem(owner.GetGame()).Get(GetAllBlackboardDefs().UI_Stealth);
    if IsDefined(blackboard) {
      if this.m_onlyHostileDetection {
        this.m_detectionListener = blackboard.RegisterListenerFloat(GetAllBlackboardDefs().UI_Stealth.highestHostileDetectionOnPlayer, this, n"OnDetectionChanged");
        this.UpdateWithDetection(blackboard.GetFloat(GetAllBlackboardDefs().UI_Stealth.highestHostileDetectionOnPlayer));
      } else {
        this.m_detectionListener = blackboard.RegisterListenerFloat(GetAllBlackboardDefs().UI_Stealth.highestDetectionOnPlayer, this, n"OnDetectionChanged");
        this.UpdateWithDetection(blackboard.GetFloat(GetAllBlackboardDefs().UI_Stealth.highestDetectionOnPlayer));
      };
    };
  }

  protected cb func OnDetectionChanged(newDetection: Float) -> Bool {
    this.UpdateWithDetection(newDetection);
  }

  protected func ActionOff(owner: ref<GameObject>) -> Void {
    let blackboard: ref<IBlackboard>;
    if IsDefined(this.m_detectionListener) {
      blackboard = GameInstance.GetBlackboardSystem(owner.GetGame()).Get(GetAllBlackboardDefs().UI_Stealth);
      if IsDefined(blackboard) {
        if this.m_onlyHostileDetection {
          blackboard.UnregisterListenerFloat(GetAllBlackboardDefs().UI_Stealth.highestHostileDetectionOnPlayer, this.m_detectionListener);
        } else {
          blackboard.UnregisterListenerFloat(GetAllBlackboardDefs().UI_Stealth.highestDetectionOnPlayer, this.m_detectionListener);
        };
      };
    };
    this.ProcessStacksChange(-this.m_currentStacks);
    this.m_currentStacks = 0;
  }

  private final func UpdateWithDetection(newDetection: Float) -> Void {
    let newStacks: Int32;
    let stacksChange: Int32;
    if this.m_detectionStep <= 0.00 || !TDBID.IsValid(this.m_statusEffectID) {
      return;
    };
    newStacks = FloorF(newDetection / this.m_detectionStep);
    if this.m_maxStacks > 0 {
      newStacks = Min(newStacks, this.m_maxStacks);
    };
    stacksChange = newStacks - this.m_currentStacks;
    if stacksChange == 0 {
      return;
    };
    this.m_currentStacks = newStacks;
    this.ProcessStacksChange(stacksChange);
  }

  private final func ProcessStacksChange(stacksChange: Int32) -> Void {
    if stacksChange > 0 {
      GameInstance.GetStatusEffectSystem(this.m_gameInstance).ApplyStatusEffect(this.m_ownerID, this.m_statusEffectID, TDBID.None(), this.m_ownerID, Cast<Uint32>(stacksChange));
    } else {
      if !this.m_dontRemoveStacks {
        GameInstance.GetStatusEffectSystem(this.m_gameInstance).RemoveStatusEffect(this.m_ownerID, this.m_statusEffectID, Cast<Uint32>(Abs(stacksChange)));
      };
    };
  }
}
