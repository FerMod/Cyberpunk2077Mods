
public class ArmsCWInSlotPrereqState extends PrereqState {

  public let m_listener: ref<ArmsCWInSlotCallback>;

  public let m_owner: wref<GameObject>;

  public final func AreaChanged(itemID: ItemID) -> Void {
    let checkPassed: Bool;
    let prereq: ref<ArmsCWInSlotPrereq> = this.GetPrereq() as ArmsCWInSlotPrereq;
    if IsDefined(prereq) {
      checkPassed = prereq.EvaluateAll(this.m_owner);
      this.OnChanged(checkPassed);
    };
  }
}

public class ArmsCWInSlotPrereq extends IScriptablePrereq {

  @default(ArmsCWInSlotPrereq, gamedataEquipmentArea.ArmsCW)
  public let m_equipmentArea: gamedataEquipmentArea;

  public let m_slotCheckType: gamedataCheckType;

  public let m_itemType: gamedataItemType;

  public let m_itemTag: CName;

  public let m_invert: Bool;

  protected const func OnRegister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Bool {
    let owner: ref<GameObject> = context as GameObject;
    let castedState: ref<ArmsCWInSlotPrereqState> = state as ArmsCWInSlotPrereqState;
    castedState.m_listener = new ArmsCWInSlotCallback();
    castedState.m_owner = owner;
    castedState.m_listener.RegisterState(castedState);
    GameInstance.GetTransactionSystem(game).RegisterAttachmentSlotListener(owner, castedState.m_listener);
    return false;
  }

  protected const func OnUnregister(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Void {
    let castedState: ref<ArmsCWInSlotPrereqState> = state as ArmsCWInSlotPrereqState;
    if IsDefined(castedState) {
      castedState.m_listener = null;
    };
  }

  protected const func OnApplied(state: ref<PrereqState>, game: GameInstance, context: ref<IScriptable>) -> Void {
    let castedState: ref<ArmsCWInSlotPrereqState> = state as ArmsCWInSlotPrereqState;
    castedState.OnChanged(this.IsFulfilled(game, context));
  }

  public const func IsFulfilled(game: GameInstance, context: ref<IScriptable>) -> Bool {
    return this.EvaluateAll(context as GameObject);
  }

  public final const func EvaluateAll(owner: wref<GameObject>) -> Bool {
    let item: ItemID;
    let result: Bool;
    let eqSystem: wref<EquipmentSystem> = GameInstance.GetScriptableSystemsContainer(owner.GetGame()).Get(n"EquipmentSystem") as EquipmentSystem;
    let playerData: ref<EquipmentSystemPlayerData> = eqSystem.GetPlayerData(owner);
    let slots: Int32 = playerData.GetNumberOfSlots(this.m_equipmentArea);
    let i: Int32 = 0;
    while i < slots {
      item = playerData.GetItemInEquipSlot(this.m_equipmentArea, i);
      if ItemID.IsValid(item) {
        result = this.Evaluate(item);
        if result {
          break;
        };
      };
      i += 1;
    };
    return this.m_invert ? !result : result;
  }

  public final const func Evaluate(itemID: ItemID) -> Bool {
    let result: Bool;
    switch this.m_slotCheckType {
      case gamedataCheckType.Tag:
        result = this.EvaluateTag(itemID, this.m_itemTag);
        break;
      case gamedataCheckType.Type:
        result = this.EvaluateType(RPGManager.GetItemType(itemID));
        break;
      default:
        result = false;
    };
    return result;
  }

  public final const func EvaluateTag(itemID: ItemID, tag: CName) -> Bool {
    let tags: array<CName> = RPGManager.GetItemRecord(itemID).Tags();
    return ArrayContains(tags, tag);
  }

  public final const func EvaluateType(itemType: gamedataItemType) -> Bool {
    return Equals(itemType, this.m_itemType);
  }

  protected func Initialize(recordID: TweakDBID) -> Void {
    this.m_slotCheckType = TweakDBInterface.GetCheckTypeRecord(TweakDBInterface.GetForeignKeyDefault(recordID + t".checkType")).Type();
    this.m_itemType = TweakDBInterface.GetItemTypeRecord(TweakDBInterface.GetForeignKeyDefault(recordID + t".itemType")).Type();
    this.m_itemTag = TweakDBInterface.GetCName(recordID + t".itemTag", n"None");
    this.m_invert = TweakDBInterface.GetBool(recordID + t".inverted", false);
  }
}

public class ArmsCWInSlotCallback extends AttachmentSlotsScriptCallback {

  protected let m_state: wref<ArmsCWInSlotPrereqState>;

  public func OnItemEquipped(slot: TweakDBID, item: ItemID) -> Void {
    if Equals(EquipmentSystem.GetEquipAreaType(item), gamedataEquipmentArea.RightArm) {
      this.m_state.AreaChanged(item);
    };
  }

  public func OnItemUnequipped(slot: TweakDBID, item: ItemID) -> Void {
    if Equals(EquipmentSystem.GetEquipAreaType(item), gamedataEquipmentArea.RightArm) {
      this.m_state.AreaChanged(item);
    };
  }

  public func OnAttachmentRefreshed(slot: TweakDBID, item: ItemID) -> Void {
    if Equals(EquipmentSystem.GetEquipAreaType(item), gamedataEquipmentArea.RightArm) {
      this.m_state.AreaChanged(item);
    };
  }

  public final func RegisterState(state: ref<PrereqState>) -> Void {
    this.m_state = state as ArmsCWInSlotPrereqState;
  }
}
