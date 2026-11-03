
public native class gamevehicleVehicleMountableComponent extends MountableComponent {

  protected cb func OnInteractionChoice(choiceEvent: ref<InteractionChoiceEvent>) -> Bool {
    let record: wref<InteractionMountBase_Record>;
    let slotName: CName;
    let activator: wref<GameObject> = choiceEvent.activator;
    if MountableComponent.IsInteractionAcceptable(choiceEvent) && this.DoStatusEffectsAllowMounting(activator) {
      record = InteractionChoiceMetaData.GetTweakData(choiceEvent.choice.choiceMetaData) as InteractionMountBase_Record;
      slotName = record.VehicleMountSlot();
      this.MountEntityToSlot(choiceEvent.hotspot.GetEntityID(), activator.GetEntityID(), slotName, MountType.Regular);
    };
  }

  protected cb func OnActionDemolition(evt: ref<ActionDemolition>) -> Bool {
    let executor: wref<GameObject> = evt.GetExecutor();
    if this.DoStatusEffectsAllowMounting(executor) {
      this.MountEntityToSlot(evt.GetRequesterID(), executor.GetEntityID(), evt.prop.name, MountType.Hijack);
    };
  }

  protected cb func OnActionEngineering(evt: ref<ActionEngineering>) -> Bool {
    let executor: wref<GameObject> = evt.GetExecutor();
    if this.DoStatusEffectsAllowMounting(executor) {
      this.MountEntityToSlot(evt.GetRequesterID(), executor.GetEntityID(), evt.prop.name, MountType.Hijack);
    };
  }

  private final func DoStatusEffectsAllowMounting(executor: wref<GameObject>) -> Bool {
    if StatusEffectSystem.ObjectHasStatusEffect(executor, t"BaseStatusEffect.VehicleKnockdown") || StatusEffectSystem.ObjectHasStatusEffect(executor, t"BaseStatusEffect.BikeKnockdown") {
      return false;
    };
    return true;
  }

  protected final func MountEntityToSlot(parentID: EntityID, childId: EntityID, slot: CName, mountType: MountType) -> Void {
    let attitude: EAIAttitude;
    let i: Int32;
    let isNPCAlive: Bool;
    let isNPCInactive: Bool;
    let isOccupiedByNonFriendly: Bool;
    let lowLevelMountingInfo: MountingInfo;
    let scriptedPuppet: wref<GameObject>;
    let vehObject: wref<VehicleObject>;
    let mountingRequest: ref<MountingRequest> = new MountingRequest();
    let mountData: ref<MountEventData> = new MountEventData();
    let mountOptions: ref<MountEventOptions> = new MountEventOptions();
    lowLevelMountingInfo.parentId = parentID;
    lowLevelMountingInfo.childId = childId;
    lowLevelMountingInfo.slotId.id = slot;
    let npcMountInfo: MountingInfo = GameInstance.GetMountingFacility(this.GetEntity() as GameObject.GetGame()).GetMountingInfoSingleWithIds(lowLevelMountingInfo.parentId, lowLevelMountingInfo.slotId);
    let npcMountInfos: array<MountingInfo> = GameInstance.GetMountingFacility(this.GetEntity() as GameObject.GetGame()).GetMountingInfoMultipleWithIds(lowLevelMountingInfo.parentId);
    if EntityID.IsDefined(npcMountInfo.childId) {
      scriptedPuppet = GameInstance.FindEntityByID(this.GetEntity() as GameObject.GetGame(), npcMountInfo.childId) as GameObject;
      isNPCAlive = ScriptedPuppet.IsActive(scriptedPuppet);
      isNPCInactive = !isNPCAlive;
    };
    if Equals(mountType, MountType.Hijack) || isNPCInactive {
      vehObject = this.GetEntity() as VehicleObject;
      vehObject.PreHijackPrepareDriverSlot();
    };
    i = 0;
    while i < ArraySize(npcMountInfos) {
      if EntityID.IsDefined(npcMountInfos[i].childId) {
        VehicleComponent.GetAttitudeOfPassenger(this.GetEntity() as GameObject.GetGame(), npcMountInfos[i].parentId, npcMountInfos[i].slotId, attitude);
        if NotEquals(attitude, EAIAttitude.AIA_Friendly) {
          isOccupiedByNonFriendly = true;
        };
      };
      i += 1;
    };
    mountingRequest.lowLevelMountingInfo = lowLevelMountingInfo;
    mountingRequest.preservePositionAfterMounting = true;
    mountingRequest.mountData = mountData;
    mountOptions.entityID = npcMountInfo.childId;
    mountOptions.alive = isNPCAlive;
    mountOptions.occupiedByNonFriendly = isOccupiedByNonFriendly;
    mountingRequest.mountData.mountEventOptions = mountOptions;
    GameInstance.GetMountingFacility(this.GetEntity() as GameObject.GetGame()).Mount(mountingRequest);
  }
}
