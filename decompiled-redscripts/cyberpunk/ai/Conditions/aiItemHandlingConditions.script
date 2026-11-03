
public class CheckUnregisteredWeapon extends AIItemHandlingCondition {

  private let m_primaryItemArrayRecordTweakDBID: [TweakDBID];

  private let m_secondaryItemArrayRecordTweakDBID: [TweakDBID];

  private let m_transactionSystem: ref<TransactionSystem>;

  private let m_puppet: wref<ScriptedPuppet>;

  private let m_initialized: Bool;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let characterRecord: wref<Character_Record>;
    let emptyItemID: ItemID;
    let emptyTweakDBID: TweakDBID;
    let i: Int32;
    let itemInRecordItemID: ItemID;
    let itemInRecordTweakDBID: TweakDBID;
    let itemsCount: Int32;
    let itemsRecordArray: array<wref<NPCEquipmentItem_Record>>;
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(3.00));
    if this.m_initialized {
      return;
    };
    this.m_initialized = true;
    this.m_puppet = AIBehaviorScriptBase.GetPuppet(context);
    if !IsDefined(this.m_puppet) {
      return;
    };
    characterRecord = TweakDBInterface.GetCharacterRecord(this.m_puppet.GetRecordID());
    AIActionTransactionSystem.CalculateEquipmentItems(this.m_puppet, characterRecord.PrimaryEquipment(), itemsRecordArray, -1);
    itemsCount = ArraySize(itemsRecordArray);
    ArrayResize(this.m_primaryItemArrayRecordTweakDBID, itemsCount);
    if itemsCount > 0 {
      i = 0;
      while i < itemsCount {
        AIActionTransactionSystem.GetItemID(this.m_puppet, itemsRecordArray[i].Item(), itemsRecordArray[i].OnBodySlot().GetID(), itemInRecordItemID);
        itemInRecordTweakDBID = ItemID.GetTDBID(itemInRecordItemID);
        this.m_primaryItemArrayRecordTweakDBID[i] = itemInRecordTweakDBID;
        itemInRecordItemID = emptyItemID;
        itemInRecordTweakDBID = emptyTweakDBID;
        i += 1;
      };
      ArrayClear(itemsRecordArray);
    };
    AIActionTransactionSystem.CalculateEquipmentItems(this.m_puppet, characterRecord.SecondaryEquipment(), itemsRecordArray, -1);
    itemsCount = ArraySize(itemsRecordArray);
    ArrayResize(this.m_secondaryItemArrayRecordTweakDBID, itemsCount);
    if itemsCount > 0 {
      i = 0;
      while i < itemsCount {
        AIActionTransactionSystem.GetItemID(this.m_puppet, itemsRecordArray[i].Item(), itemsRecordArray[i].OnBodySlot().GetID(), itemInRecordItemID);
        itemInRecordTweakDBID = ItemID.GetTDBID(itemInRecordItemID);
        this.m_secondaryItemArrayRecordTweakDBID[i] = itemInRecordTweakDBID;
        itemInRecordItemID = emptyItemID;
        itemInRecordTweakDBID = emptyTweakDBID;
        i += 1;
      };
    };
    this.m_transactionSystem = GameInstance.GetTransactionSystem(AIBehaviorScriptBase.GetPuppet(context).GetGame());
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let emptyTweakDBID: TweakDBID;
    let i: Int32;
    let itemInCurrentLeftSlotTweakDBID: TweakDBID;
    let itemInCurrentRightSlotTweakDBID: TweakDBID;
    let itemsCount: Int32;
    let itemInCurrentRightSlot: wref<ItemObject> = this.m_transactionSystem.GetItemInSlot(this.m_puppet, t"AttachmentSlots.WeaponRight");
    let itemInCurrentLeftSlot: wref<ItemObject> = this.m_transactionSystem.GetItemInSlot(this.m_puppet, t"AttachmentSlots.WeaponLeft");
    if !IsDefined(itemInCurrentRightSlot) && !IsDefined(itemInCurrentLeftSlot) {
      return AIbehaviorConditionOutcomes.False;
    };
    itemInCurrentRightSlotTweakDBID = ItemID.GetTDBID(itemInCurrentRightSlot.GetItemID());
    itemInCurrentLeftSlotTweakDBID = ItemID.GetTDBID(itemInCurrentLeftSlot.GetItemID());
    itemsCount = ArraySize(this.m_primaryItemArrayRecordTweakDBID);
    if itemsCount > 0 {
      i = 0;
      while i < itemsCount {
        if this.m_primaryItemArrayRecordTweakDBID[i] == emptyTweakDBID {
          return AIbehaviorConditionOutcomes.False;
        };
        if this.m_primaryItemArrayRecordTweakDBID[i] == itemInCurrentLeftSlotTweakDBID {
          return AIbehaviorConditionOutcomes.False;
        };
        if this.m_primaryItemArrayRecordTweakDBID[i] == itemInCurrentRightSlotTweakDBID {
          return AIbehaviorConditionOutcomes.False;
        };
        i += 1;
      };
    };
    itemsCount = ArraySize(this.m_secondaryItemArrayRecordTweakDBID);
    if itemsCount > 0 {
      i = 0;
      while i < itemsCount {
        if this.m_secondaryItemArrayRecordTweakDBID[i] == emptyTweakDBID {
          return AIbehaviorConditionOutcomes.False;
        };
        if this.m_secondaryItemArrayRecordTweakDBID[i] == itemInCurrentLeftSlotTweakDBID {
          return AIbehaviorConditionOutcomes.False;
        };
        if this.m_secondaryItemArrayRecordTweakDBID[i] == itemInCurrentRightSlotTweakDBID {
          return AIbehaviorConditionOutcomes.False;
        };
        i += 1;
      };
    };
    return AIbehaviorConditionOutcomes.True;
  }
}

public class CheckEquippedWeapon extends AIItemHandlingCondition {

  public inline edit let m_slotID: ref<AIArgumentMapping>;

  public inline edit let m_itemID: ref<AIArgumentMapping>;

  protected let m_slotIDName: TweakDBID;

  protected let m_itemIDName: TweakDBID;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let owner: ref<GameObject> = AIBehaviorScriptBase.GetPuppet(context);
    if IsDefined(owner) {
      if IsDefined(this.m_slotID) && !TDBID.IsValid(this.m_slotIDName) {
        this.m_slotIDName = ScriptExecutionContext.GetTweakDBIDMappingValue(context, this.m_slotID);
      };
      if IsDefined(this.m_itemID) && !TDBID.IsValid(this.m_itemIDName) {
        this.m_itemIDName = ScriptExecutionContext.GetTweakDBIDMappingValue(context, this.m_itemID);
      };
      ScriptExecutionContext.DebugLog(context, n"script", "SLOT ID: " + TDBID.ToStringDEBUG(this.m_slotIDName) + ",  ITEM ID: " + TDBID.ToStringDEBUG(this.m_itemIDName));
      return Cast<AIbehaviorConditionOutcomes>(GameInstance.GetTransactionSystem(owner.GetGame()).HasItemInSlot(owner, this.m_slotIDName, ItemID.CreateQuery(this.m_itemIDName)));
    };
    return AIbehaviorConditionOutcomes.False;
  }
}

public class CheckEquippedWeaponType extends AIItemHandlingCondition {

  public edit let m_weaponTypeToCheck: CName;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    AIbehaviorconditionScript.SetUpdateInterval(context, AIBehaviorScriptBase.RandomizeOffsetForUpdateInterval(0.20));
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    let item: ref<ItemObject>;
    let itemTypeRecordData: CName;
    let owner: ref<GameObject> = AIBehaviorScriptBase.GetPuppet(context);
    if IsDefined(owner) {
      item = GameInstance.GetTransactionSystem(owner.GetGame()).GetItemInSlot(owner, t"AttachmentSlots.WeaponRight");
      itemTypeRecordData = TweakDBInterface.GetItemRecord(ItemID.GetTDBID(item.GetItemID())).ItemType().Name();
      return Cast<AIbehaviorConditionOutcomes>(Equals(this.m_weaponTypeToCheck, itemTypeRecordData));
    };
    return AIbehaviorConditionOutcomes.False;
  }
}
