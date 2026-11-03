
public class UseAction extends BaseItemAction {

  public func IsPossible(target: wref<GameObject>, opt actionRecord: wref<ObjectAction_Record>, opt objectActionsCallbackController: wref<gameObjectActionsCallbackController>) -> Bool {
    let targetPrereqs: array<wref<IPrereq_Record>>;
    if !IsDefined(actionRecord) {
      actionRecord = this.GetObjectActionRecord();
    };
    if IsDefined(objectActionsCallbackController) && objectActionsCallbackController.HasObjectAction(actionRecord) {
      return objectActionsCallbackController.IsObjectActionInstigatorPrereqFulfilled(actionRecord);
    };
    actionRecord.InstigatorPrereqs(targetPrereqs);
    return RPGManager.CheckPrereqs(targetPrereqs, target);
  }

  public func StartAction(gameInstance: GameInstance) -> Void {
    let itemData: ref<gameItemData> = this.GetItemData();
    super.StartAction(gameInstance);
    if !IsDefined(itemData) || !this.m_executor.IsPlayer() {
      return;
    };
    if this.m_objectActionID == t"CyberwareAction.UseOpticalCamoRare" || this.m_objectActionID == t"CyberwareAction.UseOpticalCamoEpic" || this.m_objectActionID == t"CyberwareAction.UseOpticalCamoLegendary" || this.m_objectActionID == t"CyberwareAction.UseBloodPumpCommon" || this.m_objectActionID == t"CyberwareAction.UseBloodPumpUncommon" || this.m_objectActionID == t"CyberwareAction.UseBloodPumpRare" || this.m_objectActionID == t"CyberwareAction.UseBloodPumpEpic" || this.m_objectActionID == t"CyberwareAction.UseBloodPumpLegendary" {
      GameInstance.GetTelemetrySystem(gameInstance).LogActiveCyberwareUsed(this.m_executor, itemData.GetID());
    };
  }
}
