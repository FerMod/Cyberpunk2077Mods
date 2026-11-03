
public class EntityAttachementComponentPS extends GameComponentPS {

  private persistent let m_pendingChildAttachements: [EntityAttachementData];

  private final const func GetMyEntityID() -> EntityID {
    return PersistentID.ExtractEntityID(this.GetID());
  }

  private final const func GetOwnerEntityWeak() -> wref<Entity> {
    return GameInstance.FindEntityByID(this.GetGameInstance(), this.GetMyEntityID());
  }

  public final const func GetPendingChildAttachementsData() -> [EntityAttachementData] {
    return this.m_pendingChildAttachements;
  }

  private final func OnChildAttachementRequest(evt: ref<EntityAttachementRequestEvent>) -> EntityNotificationType {
    if this.GetOwnerEntityWeak() == null {
      this.AddPendingChildAttachementRequest(evt.attachementData);
      return EntityNotificationType.DoNotNotifyEntity;
    };
    return EntityNotificationType.SendThisEventToEntity;
  }

  private final func AddPendingChildAttachementRequest(const data: script_ref<EntityAttachementData>) -> Void {
    if !this.HasPendingChildAttachementRequest(data) {
      ArrayPush(this.m_pendingChildAttachements, Deref(data));
    };
  }

  private final func HasPendingChildAttachementRequest(const data: script_ref<EntityAttachementData>) -> Bool {
    let i: Int32 = 0;
    while i < ArraySize(this.m_pendingChildAttachements) {
      if Deref(data).ownerID == this.m_pendingChildAttachements[i].ownerID {
        return true;
      };
      i += 1;
    };
    return false;
  }

  public final func ClearPendingChildAttachementRequests() -> Void {
    ArrayClear(this.m_pendingChildAttachements);
  }
}

public class EntityAttachementComponent extends ScriptableComponent {

  public let m_parentAttachementData: EntityAttachementData;

  protected final func OnGameAttach() -> Void {
    this.RestoreAttachements();
  }

  private final func GetMyPS() -> ref<EntityAttachementComponentPS> {
    return this.GetPS() as EntityAttachementComponentPS;
  }

  private final func RestoreAttachements() -> Void {
    this.AttachToParent(this.GetParentAttachementData());
    this.RestoreChildAttachements();
  }

  private final func RestoreChildAttachements() -> Void {
    let pendingChildAttachements: array<EntityAttachementData> = this.GetMyPS().GetPendingChildAttachementsData();
    let i: Int32 = 0;
    while i < ArraySize(pendingChildAttachements) {
      this.AttachChild(pendingChildAttachements[i]);
      i += 1;
    };
    if ArraySize(pendingChildAttachements) > 0 {
      this.GetMyPS().ClearPendingChildAttachementRequests();
    };
  }

  public final const func GetParentAttachementData() -> EntityAttachementData {
    return this.m_parentAttachementData;
  }

  private final func AttachToParent(data: EntityAttachementData) -> Void {
    let evt: ref<EntityAttachementRequestEvent>;
    let globalRef: GlobalNodeRef;
    let parentID: PersistentID;
    if !IsNameValid(data.slotComponentName) && !IsNameValid(data.slotName) {
      return;
    };
    globalRef = ResolveNodeRefWithEntityID(data.nodeRef, this.GetOwner().GetEntityID());
    parentID = CreatePersistentID(Cast<EntityID>(globalRef), data.attachementComponentName);
    if PersistentID.IsDefined(parentID) {
      evt = new EntityAttachementRequestEvent();
      data.ownerID = this.GetOwner().GetEntityID();
      evt.attachementData = data;
      GameInstance.GetPersistencySystem(this.GetOwner().GetGame()).QueuePSEvent(parentID, n"EntityAttachementComponentPS", evt);
    };
  }

  private final func AttachChild(const data: script_ref<EntityAttachementData>) -> Void {
    let childEntity: wref<GameObject>;
    if EntityID.IsDefined(Deref(data).ownerID) {
      childEntity = GameInstance.FindEntityByID(this.GetOwner().GetGame(), Deref(data).ownerID) as GameObject;
    };
    if childEntity != null {
      EntityGameInterface.BindToComponent(childEntity.GetEntity(), this.GetOwner().GetEntity(), Deref(data).slotComponentName, Deref(data).slotName, true);
    };
  }

  protected cb func OnChildAttachementRequest(evt: ref<EntityAttachementRequestEvent>) -> Bool {
    this.AttachChild(evt.attachementData);
  }
}
