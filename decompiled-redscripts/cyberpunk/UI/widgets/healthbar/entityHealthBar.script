
public class EntityHealthStatListener extends ScriptStatPoolsListener {

  private let m_healthbar: wref<EntityHealthBarGameController>;

  public final func BindHealthbar(bar: ref<EntityHealthBarGameController>) -> Void {
    this.m_healthbar = bar;
  }

  public func OnStatPoolValueChanged(oldValue: Float, newValue: Float, percToPoints: Float) -> Void {
    this.m_healthbar.UpdateHealthValue(newValue);
  }
}

public class EntityHealthBarGameController extends inkGameController {

  private edit let m_healthControllerRef: inkWidgetRef;

  private edit let m_healthPercentageRef: inkTextRef;

  private edit let m_targetEntityRef: EntityReference;

  private let m_healthStatListener: ref<EntityHealthStatListener>;

  private let m_healthController: wref<NameplateBarLogicController>;

  private let m_gameInstance: GameInstance;

  private let m_targetEntityID: EntityID;

  protected cb func OnInitialize() -> Bool {
    this.m_gameInstance = (this.GetOwnerEntity() as PlayerPuppet).GetGame();
    this.m_healthController = inkWidgetRef.GetController(this.m_healthControllerRef) as NameplateBarLogicController;
    this.RegisterHealthStatListener();
  }

  protected cb func OnUninitialize() -> Bool {
    GameInstance.GetStatPoolsSystem(this.m_gameInstance).RequestUnregisteringListener(Cast<StatsObjectID>(this.m_targetEntityID), gamedataStatPoolType.Health, this.m_healthStatListener);
  }

  private final func RegisterHealthStatListener() -> Void {
    let entityIds: array<EntityID>;
    this.m_healthStatListener = new EntityHealthStatListener();
    this.m_healthStatListener.BindHealthbar(this);
    GetFixedEntityIdsFromEntityReference(this.m_targetEntityRef, this.m_gameInstance, entityIds);
    this.m_targetEntityID = entityIds[0];
    GameInstance.GetStatPoolsSystem(this.m_gameInstance).RequestRegisteringListener(Cast<StatsObjectID>(this.m_targetEntityID), gamedataStatPoolType.Health, this.m_healthStatListener);
  }

  public final func UpdateHealthValue(newValue: Float) -> Void {
    this.m_healthController.SetNameplateBarProgress(newValue / 100.00, false);
    inkTextRef.SetText(this.m_healthPercentageRef, IntToString(Cast<Int32>(newValue)));
  }

  protected cb func OnUpdateEntityHealthListenersEvent(evt: ref<questUpdateEntityHealthListenersEvent>) -> Bool {
    if Equals(this.m_targetEntityRef, evt.entityRef) {
      GameInstance.GetStatPoolsSystem(this.m_gameInstance).RequestUnregisteringListener(Cast<StatsObjectID>(this.m_targetEntityID), gamedataStatPoolType.Health, this.m_healthStatListener);
      this.RegisterHealthStatListener();
    };
  }
}
