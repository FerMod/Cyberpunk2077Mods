
public class ServerNode extends InteractiveDevice {

  @runtimeProperty("category", "Tech weapon charge properties")
  @runtimeProperty("tooltip", "minimal charge value to damage the node when it's closed")
  private let m_minWeaponCharge: Float;

  @runtimeProperty("category", "Tech weapon charge properties")
  @runtimeProperty("tooltip", "above the max value the node will explode (set it above 1 if you don't want any explosion)")
  private let m_maxWeaponCharge: Float;

  private let m_livePinMeshes: [ref<MeshComponent>];

  private let m_deadPinMeshes: [ref<MeshComponent>];

  private let m_closedFrontPlates: [ref<MeshComponent>];

  private let m_animatedFrontPlates: [ref<MeshComponent>];

  @default(ServerNode, 12)
  private let m_numOfPins: Int32;

  @default(ServerNode, 12)
  private let m_alivePins: Int32;

  protected let m_pinIndices: [Int32];

  @default(ServerNode, q303_03_server_nodes_destroyed)
  protected edit let m_nodesDestroyedInTotalQuestFactName: CName;

  private let m_animFeatureServer: ref<AnimFeatureServer>;

  private let m_statPoolSystem: ref<StatPoolsSystem>;

  private let m_healthListener: ref<ServerNodeHealthChangeListener>;

  @default(ServerNode, venting)
  private const let m_ventingFX: CName;

  @default(ServerNode, damage_state_01)
  private const let m_damagedFX: CName;

  protected let m_destroyedMesh: ref<PhysicalMeshComponent>;

  protected cb func OnGameAttached() -> Bool {
    super.OnGameAttached();
    this.m_healthListener = ServerNodeHealthChangeListener.Create(this);
    GameInstance.GetStatPoolsSystem(this.GetGame()).RequestRegisteringListener(Cast<StatsObjectID>(this.GetEntityID()), gamedataStatPoolType.Health, this.m_healthListener);
  }

  protected cb func OnDetach() -> Bool {
    GameInstance.GetStatPoolsSystem(this.GetGame()).RequestUnregisteringListener(Cast<StatsObjectID>(this.GetEntityID()), gamedataStatPoolType.Health, this.m_healthListener);
    super.OnDetach();
  }

  protected func ResolveGameplayState() -> Void {
    let numberOfDestroyedPins: Int32;
    this.m_animFeatureServer = new AnimFeatureServer();
    let i: Int32 = 0;
    while i < this.m_numOfPins {
      if this.GetDevicePS().IsPinDestroyed(i) {
        numberOfDestroyedPins += 1;
        this.m_livePinMeshes[i].Toggle(false);
        this.m_deadPinMeshes[i].Toggle(true);
      };
      i += 1;
    };
    if numberOfDestroyedPins == this.m_numOfPins {
      this.GetDevicePS().SetServerState(ServerState.Destroyed);
    };
    this.UpdateVisuals();
    super.ResolveGameplayState();
  }

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    let pinComponentName: String;
    let i: Int32 = 1;
    while i <= this.m_numOfPins {
      pinComponentName = "q303_server_core_a" + i;
      EntityRequestComponentsInterface.RequestComponent(ri, StringToName(pinComponentName), n"MeshComponent", true);
      pinComponentName = "q303_server_core_destroyed_" + i;
      EntityRequestComponentsInterface.RequestComponent(ri, StringToName(pinComponentName), n"MeshComponent", true);
      i += 1;
    };
    EntityRequestComponentsInterface.RequestComponent(ri, n"q303_server_cores_shutter_a0", n"MeshComponent", true);
    EntityRequestComponentsInterface.RequestComponent(ri, n"q303_server_cores_shutter_b0", n"MeshComponent", true);
    EntityRequestComponentsInterface.RequestComponent(ri, n"q303_server_cores_shutter_c0", n"MeshComponent", true);
    EntityRequestComponentsInterface.RequestComponent(ri, n"q303_server_cores_shutter_d0", n"MeshComponent", true);
    EntityRequestComponentsInterface.RequestComponent(ri, n"q303_server_cores_shutter_a", n"MeshComponent", true);
    EntityRequestComponentsInterface.RequestComponent(ri, n"q303_server_cores_shutter_b", n"MeshComponent", true);
    EntityRequestComponentsInterface.RequestComponent(ri, n"q303_server_cores_shutter_c", n"MeshComponent", true);
    EntityRequestComponentsInterface.RequestComponent(ri, n"q303_server_cores_shutter_d", n"MeshComponent", true);
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    let pinComponentName: String;
    let i: Int32 = 1;
    while i <= this.m_numOfPins {
      pinComponentName = "q303_server_core_a" + i;
      ArrayPush(this.m_livePinMeshes, EntityResolveComponentsInterface.GetComponent(ri, StringToName(pinComponentName)) as MeshComponent);
      pinComponentName = "q303_server_core_destroyed_" + i;
      ArrayPush(this.m_deadPinMeshes, EntityResolveComponentsInterface.GetComponent(ri, StringToName(pinComponentName)) as MeshComponent);
      i += 1;
    };
    ArrayPush(this.m_closedFrontPlates, EntityResolveComponentsInterface.GetComponent(ri, n"q303_server_cores_shutter_a0") as MeshComponent);
    ArrayPush(this.m_closedFrontPlates, EntityResolveComponentsInterface.GetComponent(ri, n"q303_server_cores_shutter_b0") as MeshComponent);
    ArrayPush(this.m_closedFrontPlates, EntityResolveComponentsInterface.GetComponent(ri, n"q303_server_cores_shutter_c0") as MeshComponent);
    ArrayPush(this.m_closedFrontPlates, EntityResolveComponentsInterface.GetComponent(ri, n"q303_server_cores_shutter_d0") as MeshComponent);
    ArrayPush(this.m_animatedFrontPlates, EntityResolveComponentsInterface.GetComponent(ri, n"q303_server_cores_shutter_a") as MeshComponent);
    ArrayPush(this.m_animatedFrontPlates, EntityResolveComponentsInterface.GetComponent(ri, n"q303_server_cores_shutter_b") as MeshComponent);
    ArrayPush(this.m_animatedFrontPlates, EntityResolveComponentsInterface.GetComponent(ri, n"q303_server_cores_shutter_c") as MeshComponent);
    ArrayPush(this.m_animatedFrontPlates, EntityResolveComponentsInterface.GetComponent(ri, n"q303_server_cores_shutter_d") as MeshComponent);
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as ServerNodeController;
  }

  protected func UpdateDeviceState(opt isDelayed: Bool) -> Bool {
    return super.UpdateDeviceState(isDelayed);
  }

  private final func UpdateAnimation() -> Void {
    this.m_animFeatureServer.m_coverState = EnumInt(this.GetDevicePS().GetCoverState());
    this.m_animFeatureServer.m_serverState = EnumInt(this.GetDevicePS().GetServerState());
    AnimationControllerComponent.ApplyFeature(this, n"server", this.m_animFeatureServer);
  }

  private final func UpdateFX() -> Void {
    let serverState: ServerState = this.GetDevicePS().GetServerState();
    if Equals(serverState, ServerState.Active) {
      this.StartHackingFX();
    } else {
      if Equals(serverState, ServerState.Destroyed) {
        this.DestroyFX();
      } else {
        if Equals(serverState, ServerState.Damaged) {
          this.DamageFX();
        } else {
          if Equals(serverState, ServerState.Inactive) {
            this.StopHackingFX();
          };
        };
      };
    };
  }

  private final func StartHackingFX() -> Void {
    this.SetLineVisibleState(true);
    GameObjectEffectHelper.StartEffectEvent(this, this.m_ventingFX);
  }

  private final func SetLineVisibleState(isVisible: Bool) -> Void {
    this.GetDevicePS().DrawBetweenEntities(isVisible, false, this.GetFxResourceByKey(n"pingNetworkLink"), GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerControlledGameObject().GetEntityID(), this.GetEntityID(), false, false, false, false, true);
  }

  private final func StopHackingFX() -> Void {
    this.SetLineVisibleState(false);
    GameObjectEffectHelper.BreakEffectLoopEvent(this, this.m_ventingFX);
  }

  private final func DamageFX() -> Void {
    GameObjectEffectHelper.StartEffectEvent(this, this.m_damagedFX);
  }

  private final func DestroyFX() -> Void {
    let coverState: CoverState = this.GetDevicePS().GetCoverState();
    if Equals(coverState, CoverState.Closed) {
      this.DestroyedClosed();
    };
    this.SetLineVisibleState(false);
    GameObjectEffectHelper.BreakEffectLoopEvent(this, this.m_damagedFX);
    GameObjectEffectHelper.BreakEffectLoopEvent(this, this.m_ventingFX);
    GameObjectEffectHelper.StartEffectEvent(this, n"destroyed");
  }

  private final func DestroyedClosed() -> Void {
    let i: Int32 = 0;
    while i < 4 {
      this.m_animatedFrontPlates[i].Toggle(false);
      this.m_closedFrontPlates[i].Toggle(true);
      i += 1;
    };
  }

  private final func UpdateVisuals() -> Void {
    this.UpdateAnimation();
    this.UpdateFX();
  }

  protected cb func OnQuestOpen(evt: ref<QuestOpen>) -> Bool {
    this.UpdateAnimation();
  }

  protected cb func OnQuestStartHacking(evt: ref<QuestStartHacking>) -> Bool {
    this.UpdateVisuals();
  }

  protected cb func OnQuestClose(evt: ref<QuestClose>) -> Bool {
    this.UpdateVisuals();
  }

  protected cb func OnQuestStopHacking(evt: ref<QuestStopHacking>) -> Bool {
    this.UpdateVisuals();
  }

  protected cb func OnOverloadDevice(evt: ref<OverloadDevice>) -> Bool {
    this.Explode();
  }

  protected cb func OnQuestExplode(evt: ref<QuestExplode>) -> Bool {
    this.Explode();
  }

  protected cb func OnDeath(evt: ref<gameDeathEvent>) -> Bool {
    if NotEquals(this.GetDevicePS().GetServerState(), ServerState.Destroyed) {
      this.GetDevicePS().TryExplode();
      this.UpdateVisuals();
      this.SetPinMeshes(0);
      SetFactValue(this.GetGame(), this.m_nodesDestroyedInTotalQuestFactName, GetFact(this.GetGame(), this.m_nodesDestroyedInTotalQuestFactName) + 1);
      super.OnDeath(evt);
    };
  }

  private final func Explode() -> Void {
    let deathEvent: ref<gameDeathEvent> = new gameDeathEvent();
    this.QueueEvent(deathEvent);
  }

  protected func ProcessDamagePipeline(evt: ref<gameHitEvent>) -> Void {
    let isPiercingHit: Bool;
    if Equals(this.GetDevicePS().GetServerState(), ServerState.Destroyed) || !this.IsPlayerHitting(evt.attackData) {
      return;
    };
    isPiercingHit = this.IsPiercingHit(evt.attackData);
    if isPiercingHit && this.IsExplosionChargeMet(evt.attackData) {
      this.Explode();
    } else {
      if Equals(this.GetDevicePS().GetCoverState(), CoverState.Open) || Equals(this.GetDevicePS().GetServerState(), ServerState.Active) || Equals(this.GetDevicePS().GetServerState(), ServerState.Damaged) || isPiercingHit && this.IsPiercingChargeMet(evt.attackData) {
        super.ProcessDamagePipeline(evt);
      };
    };
  }

  private final func IsPlayerHitting(attackData: ref<AttackData>) -> Bool {
    let instigator: wref<GameObject> = attackData.GetInstigator();
    return instigator.GetEntityID() == GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerControlledGameObject().GetEntityID();
  }

  private final func IsPiercingHit(attackData: ref<AttackData>) -> Bool {
    let weapon: wref<WeaponObject> = attackData.GetWeapon();
    let instigator: wref<GameObject> = attackData.GetInstigator();
    return Equals(RPGManager.GetWeaponEvolution(weapon.GetItemID()), gamedataWeaponEvolution.Tech) || RPGManager.IsTechPierceEnabled(instigator.GetGame(), instigator, weapon.GetItemID());
  }

  private final func IsExplosionChargeMet(attackData: ref<AttackData>) -> Bool {
    let chargeValue: Float = attackData.GetWeaponCharge();
    return chargeValue >= this.m_maxWeaponCharge;
  }

  private final func IsPiercingChargeMet(attackData: ref<AttackData>) -> Bool {
    let chargeValue: Float = attackData.GetWeaponCharge();
    return chargeValue >= this.m_minWeaponCharge && chargeValue < this.m_maxWeaponCharge;
  }

  private final func SetPinMeshes(numOfPinsToKeepOn: Int32) -> Void {
    let i: Int32;
    let pinToDisable: Int32;
    let random: Int32 = this.SetRandom();
    if numOfPinsToKeepOn < this.m_alivePins {
      pinToDisable = this.m_alivePins - numOfPinsToKeepOn;
      i = 0;
      while i < pinToDisable {
        this.m_livePinMeshes[this.m_pinIndices[random]].Toggle(false);
        this.m_deadPinMeshes[this.m_pinIndices[random]].Toggle(true);
        ArrayErase(this.m_pinIndices, random);
        this.m_alivePins -= 1;
        this.GetDevicePS().SetDestroyedPin(i);
        random = this.SetRandom();
        i += 1;
      };
    };
  }

  private final func SetRandom() -> Int32 {
    if ArraySize(this.m_pinIndices) > 1 {
      return RandRange(0, ArraySize(this.m_pinIndices));
    };
    return 0;
  }

  public final func OnHealthChanged(currentHealthPercentage: Float) -> Void {
    let numOfPins: Float = Cast<Float>(this.m_numOfPins) - 1.00;
    this.SetPinMeshes(CeilF((numOfPins * currentHealthPercentage) / 100.00));
    if currentHealthPercentage < 70.00 {
      this.GetDevicePS().SetServerState(ServerState.Damaged);
      this.UpdateFX();
    };
  }

  public const func GetDevicePS() -> ref<ServerNodeControllerPS> {
    return this.GetController().GetPS();
  }

  private const func GetController() -> ref<ServerNodeController> {
    return this.m_controller as ServerNodeController;
  }
}
