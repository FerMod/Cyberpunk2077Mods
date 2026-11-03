
public class SimpleCoverBehaviorCondition extends AIbehaviorconditionScript {

  private let m_initialized: Bool;

  private let m_isShotgunner: Bool;

  private let m_isHeavyRanged: Bool;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    if !this.m_initialized {
      if AICondition.CheckAbility(context, TweakDBInterface.GetGameplayAbilityRecord(t"Ability.IsShotgunnerArchetype")) {
        this.m_isShotgunner = true;
      } else {
        if AICondition.CheckAbility(context, TweakDBInterface.GetGameplayAbilityRecord(t"Ability.IsHeavyRangedArchetype")) {
          this.m_isHeavyRanged = true;
        };
      };
      this.m_initialized = true;
    };
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    if this.m_isShotgunner {
      return AIbehaviorConditionOutcomes.True;
    };
    if this.m_isHeavyRanged {
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.True;
  }
}

public class SimpleCanUseAvoidLOSMovement extends AIbehaviorconditionScript {

  private let m_initialized: Bool;

  private let m_result: Bool;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    if !this.m_initialized {
      this.m_result = true;
      if AICondition.CheckAbility(context, TweakDBInterface.GetGameplayAbilityRecord(t"Ability.IsShotgunnerArchetype")) {
      } else {
        if AICondition.CheckAbility(context, TweakDBInterface.GetGameplayAbilityRecord(t"Ability.IsHeavyRangedArchetype")) {
        } else {
          if AICondition.CheckAbility(context, TweakDBInterface.GetGameplayAbilityRecord(t"Ability.IsReckless")) {
            this.m_result = false;
          } else {
            if AICondition.CheckAbility(context, TweakDBInterface.GetGameplayAbilityRecord(t"Ability.IsAggressive")) {
              this.m_result = false;
            } else {
              if Equals(AIBehaviorScriptBase.GetPuppet(context).GetNPCType(), gamedataNPCType.Android) {
                this.m_result = false;
              };
            };
          };
        };
      };
      this.m_initialized = true;
    };
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(this.m_result);
  }
}

public class SimpleCanUseCover extends AIbehaviorconditionScript {

  private let m_ability: wref<GameplayAbility_Record>;

  private let m_prereqs: [ref<IPrereq>];

  private let m_prereqCount: Int32;

  private let m_game: GameInstance;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let i: Int32;
    let prereq: ref<IPrereq>;
    let record: ref<IPrereq_Record>;
    if !IsDefined(this.m_ability) {
      this.m_ability = TweakDBInterface.GetGameplayAbilityRecord(t"Ability.CanUseCovers");
      if IsDefined(this.m_ability) {
        this.m_game = ScriptExecutionContext.GetOwner(context).GetGame();
        this.m_prereqCount = this.m_ability.GetPrereqsForUseCount();
        ArrayResize(this.m_prereqs, this.m_prereqCount);
        i = 0;
        while i < this.m_prereqCount {
          record = this.m_ability.GetPrereqsForUseItem(i);
          prereq = IPrereq.CreatePrereq(record.GetID());
          ArrayPush(this.m_prereqs, prereq);
          i += 1;
        };
      };
    };
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    if !IsDefined(this.m_ability) {
      return AIbehaviorConditionOutcomes.False;
    };
    if this.CheckAbility(context) {
      return AIbehaviorConditionOutcomes.True;
    };
    return AIbehaviorConditionOutcomes.False;
  }

  private final func CheckAbility(const context: ScriptExecutionContext) -> Bool {
    let i: Int32 = 0;
    while i < this.m_prereqCount {
      if !this.m_prereqs[i].IsFulfilled(this.m_game, ScriptExecutionContext.GetOwner(context)) {
        return false;
      };
      i += 1;
    };
    return true;
  }
}

public class SimpleCanSwapWeapons extends AIbehaviorconditionScript {

  private let m_initialized: Bool;

  private let m_result: Bool;

  private let m_items: [wref<NPCEquipmentItem_Record>];

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let characterRecord: wref<Character_Record>;
    let conditions: array<wref<AIActionCondition_Record>>;
    let equipmentGroup: wref<NPCEquipmentGroup_Record>;
    let i: Int32;
    this.m_result = false;
    if ScriptExecutionContext.GetArgumentBool(context, n"EquipCommandWasActivated") {
      this.m_result = true;
      return;
    };
    if !this.m_initialized {
      characterRecord = TweakDBInterface.GetCharacterRecord(ScriptExecutionContext.GetOwner(context).GetRecordID());
      if !IsDefined(characterRecord) {
        return;
      };
      equipmentGroup = characterRecord.PrimaryEquipment();
      AIActionTransactionSystem.CalculateEquipmentItems(AIBehaviorScriptBase.GetPuppet(context), equipmentGroup, this.m_items, -1);
    };
    this.m_initialized = true;
    i = 0;
    while i < ArraySize(this.m_items) {
      ArrayClear(conditions);
      this.m_items[i].UnequipCondition(conditions);
      if ArraySize(conditions) > 0 {
        this.m_result = true;
        return;
      };
      i += 1;
    };
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(this.m_result);
  }
}

public class SimpleSandevistanHarassCondition extends AIbehaviorconditionScript {

  private let m_initialized: Bool;

  private let m_result: Bool;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    if this.m_initialized {
      return;
    };
    this.m_initialized = true;
    this.m_result = true;
    if !AIActionHelper.CheckAbility(ScriptExecutionContext.GetOwner(context), TweakDBInterface.GetGameplayAbilityRecord(t"Ability.CanSprintHarass")) {
      this.m_result = false;
      return;
    };
    if !AIActionHelper.CheckAbility(ScriptExecutionContext.GetOwner(context), TweakDBInterface.GetGameplayAbilityRecord(t"Ability.SandevistanDashShoot")) {
      this.m_result = false;
    };
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(this.m_result);
  }
}

public class SimpleSandevistanDashShootCondition extends AIbehaviorconditionScript {

  private let m_initialized: Bool;

  private let m_result: Bool;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    if this.m_initialized {
      return;
    };
    this.m_initialized = true;
    if AIActionHelper.CheckAbility(ScriptExecutionContext.GetOwner(context), TweakDBInterface.GetGameplayAbilityRecord(t"Ability.SandevistanDashShoot")) {
      this.m_result = true;
    };
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(this.m_result);
  }
}

public class SimpleSprintHarassCondition extends AIbehaviorconditionScript {

  private let m_initialized: Bool;

  private let m_result: Bool;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    if this.m_initialized {
      return;
    };
    this.m_initialized = true;
    if AIActionHelper.CheckAbility(ScriptExecutionContext.GetOwner(context), TweakDBInterface.GetGameplayAbilityRecord(t"Ability.CanSprintHarass")) {
      this.m_result = true;
    };
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(this.m_result);
  }
}

public class SimpleSetUnequipWeapons extends AIbehaviortaskScript {

  private let m_puppet: wref<ScriptedPuppet>;

  private let m_game: GameInstance;

  private let m_transactionSystem: ref<TransactionSystem>;

  private let m_primaryItems: [wref<NPCEquipmentItem_Record>];

  private let m_secondaryItems: [wref<NPCEquipmentItem_Record>];

  private let m_secondaryEquipmentDuplicatesPrimary: Bool;

  private let m_initialized: Bool;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    if !this.m_initialized {
      this.m_initialized = true;
      this.Init(context);
    };
  }

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let itemsList: array<NPCItemToEquip>;
    if this.GetItemsToUnequip(context, itemsList) {
      AIActionHelper.SetItemsUnequipData(this.m_puppet, itemsList, false);
      return AIbehaviorUpdateOutcome.SUCCESS;
    };
    return AIbehaviorUpdateOutcome.FAILURE;
  }

  private final func Init(context: ScriptExecutionContext) -> Void {
    let characterRecord: wref<Character_Record>;
    let equipmentGroup: wref<NPCEquipmentGroup_Record>;
    let i: Int32;
    this.m_puppet = AIBehaviorScriptBase.GetPuppet(context);
    if !IsDefined(this.m_puppet) {
      return;
    };
    characterRecord = TweakDBInterface.GetCharacterRecord(this.m_puppet.GetRecordID());
    if !IsDefined(characterRecord) {
      return;
    };
    this.m_game = this.m_puppet.GetGame();
    this.m_transactionSystem = GameInstance.GetTransactionSystem(this.m_game);
    equipmentGroup = characterRecord.PrimaryEquipment();
    AIActionTransactionSystem.CalculateEquipmentItems(this.m_puppet, equipmentGroup, this.m_primaryItems, -1);
    equipmentGroup = characterRecord.SecondaryEquipment();
    AIActionTransactionSystem.CalculateEquipmentItems(this.m_puppet, equipmentGroup, this.m_secondaryItems, -1);
    i = 0;
    while i < ArraySize(this.m_secondaryItems) {
      if ArrayContains(this.m_primaryItems, this.m_secondaryItems[i]) {
        this.m_secondaryEquipmentDuplicatesPrimary = true;
      };
      i += 1;
    };
  }

  private final func GetItemsToUnequip(context: ScriptExecutionContext, itemsList: script_ref<[NPCItemToEquip]>) -> Bool {
    let bodySlotId: TweakDBID;
    let conditions: array<wref<AIActionCondition_Record>>;
    let currentItem: ref<NPCEquipmentItem_Record>;
    let defaultID: TweakDBID;
    let hasFistsWoundedEquipped: Bool;
    let i: Int32;
    let item: NPCItemToEquip;
    let itemID: ItemID;
    let itemsToEquip: array<NPCItemToEquip>;
    let j: Int32;
    let primaryItemID: ItemID;
    if !IsDefined(this.m_puppet) {
      return false;
    };
    if ItemID.GetTDBID(this.m_transactionSystem.GetItemInSlot(this.m_puppet, t"AttachmentSlots.WeaponRight").GetItemID()) == t"Items.Npc_fists_wounded" {
      hasFistsWoundedEquipped = true;
    };
    i = 0;
    while i < ArraySize(this.m_primaryItems) {
      currentItem = this.m_primaryItems[i];
      if !IsDefined(currentItem.Item()) {
      } else {
        if !IsDefined(currentItem.EquipSlot()) {
        } else {
          if IsDefined(currentItem.OnBodySlot()) {
            bodySlotId = currentItem.OnBodySlot().GetID();
          };
          if AIActionTransactionSystem.GetItemID(this.m_puppet, currentItem.Item(), bodySlotId, itemID) {
            ArrayClear(conditions);
            if !hasFistsWoundedEquipped && !this.m_transactionSystem.HasItemInSlot(this.m_puppet, currentItem.EquipSlot().GetID(), itemID) {
            } else {
              currentItem.UnequipCondition(conditions);
              if ArraySize(conditions) == 0 && !hasFistsWoundedEquipped {
              } else {
                if ArraySize(conditions) > 0 && !AICondition.CheckActionConditions(context, conditions) {
                } else {
                  item.itemID = itemID;
                  item.slotID = currentItem.EquipSlot().GetID();
                  item.bodySlotID = bodySlotId;
                  ArrayPush(Deref(itemsList), item);
                };
              };
            };
          };
        };
      };
      i += 1;
    };
    if ArraySize(Deref(itemsList)) > 0 {
      return true;
    };
    i = 0;
    while i < ArraySize(this.m_secondaryItems) {
      currentItem = this.m_secondaryItems[i];
      if !IsDefined(currentItem.Item()) {
      } else {
        if !IsDefined(currentItem.EquipSlot()) {
        } else {
          if IsDefined(currentItem.OnBodySlot()) {
            bodySlotId = currentItem.OnBodySlot().GetID();
          };
          if AIActionTransactionSystem.GetItemID(this.m_puppet, currentItem.Item(), bodySlotId, itemID) {
            ArrayClear(conditions);
            if !hasFistsWoundedEquipped && !this.m_transactionSystem.HasItemInSlot(this.m_puppet, currentItem.EquipSlot().GetID(), itemID) {
            } else {
              currentItem.UnequipCondition(conditions);
              if ArraySize(conditions) > 0 && !AICondition.CheckActionConditions(context, conditions) {
              } else {
                this.GetItemsToEquip(context, itemsToEquip);
                if ArraySize(itemsToEquip) == 0 {
                } else {
                  if this.m_transactionSystem.HasItemInSlot(this.m_puppet, itemsToEquip[0].slotID, itemsToEquip[0].itemID) {
                  } else {
                    if this.m_secondaryEquipmentDuplicatesPrimary {
                      j = 0;
                      while j < ArraySize(this.m_primaryItems) {
                        AIActionTransactionSystem.GetItemID(this.m_puppet, this.m_primaryItems[j].Item(), IsDefined(this.m_primaryItems[j].OnBodySlot()) ? this.m_primaryItems[j].OnBodySlot().GetID() : defaultID, primaryItemID);
                        if itemID == primaryItemID {
                          ArrayClear(conditions);
                          this.m_primaryItems[j].EquipCondition(conditions);
                          if AICondition.CheckActionConditions(context, conditions) {
                          };
                        };
                        j += 1;
                      };
                    };
                    item.itemID = itemID;
                    item.slotID = currentItem.EquipSlot().GetID();
                    item.bodySlotID = bodySlotId;
                    ArrayPush(Deref(itemsList), item);
                  };
                };
              };
            };
          };
        };
      };
      i += 1;
    };
    return ArraySize(Deref(itemsList)) > 0;
  }

  private final func GetItemsToEquip(const context: ScriptExecutionContext, itemsList: script_ref<[NPCItemToEquip]>) -> Bool {
    itemsList = this.IterateOverEquipItems(context, this.m_primaryItems);
    if ArraySize(Deref(itemsList)) > 0 {
      return true;
    };
    itemsList = this.IterateOverEquipItems(context, this.m_secondaryItems);
    return ArraySize(Deref(itemsList)) > 0;
  }

  private final func IterateOverEquipItems(const context: ScriptExecutionContext, const itemsToCheck: script_ref<[wref<NPCEquipmentItem_Record>]>) -> [NPCItemToEquip] {
    let bodySlotId: TweakDBID;
    let conditions: array<wref<AIActionCondition_Record>>;
    let currentItem: ref<NPCEquipmentItem_Record>;
    let item: NPCItemToEquip;
    let itemID: ItemID;
    let itemsList: array<NPCItemToEquip>;
    let j: Int32;
    let i: Int32 = 0;
    while i < ArraySize(Deref(itemsToCheck)) {
      currentItem = Deref(itemsToCheck)[i];
      if !IsDefined(currentItem.Item()) {
      } else {
        if !IsDefined(currentItem.EquipSlot()) {
        } else {
          if IsDefined(currentItem.OnBodySlot()) {
            bodySlotId = currentItem.OnBodySlot().GetID();
          };
          if AIActionTransactionSystem.GetItemID(this.m_puppet, currentItem.Item(), bodySlotId, itemID) {
            if this.m_transactionSystem.HasItemInSlot(this.m_puppet, currentItem.EquipSlot().GetID(), itemID) {
            } else {
              if !this.m_transactionSystem.HasItem(this.m_puppet, itemID) {
              } else {
                ArrayClear(conditions);
                currentItem.EquipCondition(conditions);
                if ArraySize(conditions) > 0 && !AICondition.CheckActionConditions(context, conditions) {
                } else {
                  if ArraySize(conditions) == 0 && ArraySize(itemsList) > 0 {
                    j = 0;
                    while j < ArraySize(itemsList) {
                      if itemsList[j].slotID == currentItem.EquipSlot().GetID() {
                      };
                      j += 1;
                    };
                  };
                  item.itemID = itemID;
                  item.slotID = currentItem.EquipSlot().GetID();
                  item.bodySlotID = bodySlotId;
                  ArrayPush(itemsList, item);
                };
              };
            };
          };
        };
      };
      i += 1;
    };
    return itemsList;
  }
}

public class SimpleSetEquipWeapons extends AIbehaviortaskScript {

  @default(SimpleSetEquipWeapons, true)
  public edit let m_primary: Bool;

  @default(SimpleSetEquipWeapons, true)
  public edit let m_secondary: Bool;

  private let m_puppet: wref<ScriptedPuppet>;

  private let m_game: GameInstance;

  private let m_transactionSystem: ref<TransactionSystem>;

  private let m_primaryItems: [wref<NPCEquipmentItem_Record>];

  private let m_secondaryItems: [wref<NPCEquipmentItem_Record>];

  private let m_initialized: Bool;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    if !this.m_initialized {
      this.m_initialized = true;
      this.Init(context);
    };
  }

  protected func Update(context: ScriptExecutionContext) -> AIbehaviorUpdateOutcome {
    let itemsList: array<NPCItemToEquip>;
    if this.GetItemsToEquip(context, itemsList) {
      AIActionHelper.SetItemsEquipData(this.m_puppet, itemsList);
      return AIbehaviorUpdateOutcome.SUCCESS;
    };
    return AIbehaviorUpdateOutcome.FAILURE;
  }

  private final func Init(context: ScriptExecutionContext) -> Void {
    let characterRecord: wref<Character_Record>;
    let equipmentGroup: wref<NPCEquipmentGroup_Record>;
    this.m_puppet = AIBehaviorScriptBase.GetPuppet(context);
    if !IsDefined(this.m_puppet) {
      return;
    };
    characterRecord = TweakDBInterface.GetCharacterRecord(this.m_puppet.GetRecordID());
    if !IsDefined(characterRecord) {
      return;
    };
    this.m_game = this.m_puppet.GetGame();
    this.m_transactionSystem = GameInstance.GetTransactionSystem(this.m_game);
    equipmentGroup = characterRecord.PrimaryEquipment();
    AIActionTransactionSystem.CalculateEquipmentItems(this.m_puppet, equipmentGroup, this.m_primaryItems, -1);
    equipmentGroup = characterRecord.SecondaryEquipment();
    AIActionTransactionSystem.CalculateEquipmentItems(this.m_puppet, equipmentGroup, this.m_secondaryItems, -1);
  }

  private final func GetItemsToEquip(const context: ScriptExecutionContext, itemsList: script_ref<[NPCItemToEquip]>) -> Bool {
    if !IsDefined(this.m_puppet) {
      return false;
    };
    if this.m_primary {
      itemsList = this.IterateOverEquipItems(context, this.m_primaryItems);
      if ArraySize(Deref(itemsList)) > 0 {
        return true;
      };
    };
    if this.m_secondary {
      itemsList = this.IterateOverEquipItems(context, this.m_secondaryItems);
      if ArraySize(Deref(itemsList)) > 0 {
        return true;
      };
    };
    return false;
  }

  private final func IterateOverEquipItems(const context: ScriptExecutionContext, const itemsToCheck: script_ref<[wref<NPCEquipmentItem_Record>]>) -> [NPCItemToEquip] {
    let bodySlotId: TweakDBID;
    let conditions: array<wref<AIActionCondition_Record>>;
    let currentItem: ref<NPCEquipmentItem_Record>;
    let item: NPCItemToEquip;
    let itemID: ItemID;
    let itemsList: array<NPCItemToEquip>;
    let j: Int32;
    let i: Int32 = 0;
    while i < ArraySize(Deref(itemsToCheck)) {
      currentItem = Deref(itemsToCheck)[i];
      if !IsDefined(currentItem.Item()) {
      } else {
        if !IsDefined(currentItem.EquipSlot()) {
        } else {
          if IsDefined(currentItem.OnBodySlot()) {
            bodySlotId = currentItem.OnBodySlot().GetID();
          };
          if AIActionTransactionSystem.GetItemID(this.m_puppet, currentItem.Item(), bodySlotId, itemID) {
            if this.m_transactionSystem.HasItemInSlot(this.m_puppet, currentItem.EquipSlot().GetID(), itemID) {
            } else {
              if !this.m_transactionSystem.HasItem(this.m_puppet, itemID) {
              } else {
                ArrayClear(conditions);
                currentItem.EquipCondition(conditions);
                if ArraySize(conditions) > 0 && !AICondition.CheckActionConditions(context, conditions) {
                } else {
                  if ArraySize(conditions) == 0 && ArraySize(itemsList) > 0 {
                    j = 0;
                    while j < ArraySize(itemsList) {
                      if itemsList[j].slotID == currentItem.EquipSlot().GetID() {
                      };
                      j += 1;
                    };
                  };
                  item.itemID = itemID;
                  item.slotID = currentItem.EquipSlot().GetID();
                  item.bodySlotID = bodySlotId;
                  ArrayPush(itemsList, item);
                };
              };
            };
          };
        };
      };
      i += 1;
    };
    return itemsList;
  }
}

public class SimpleShouldEvadeCondition extends AIbehaviorconditionScript {

  private let m_hitReactionComponent: ref<HitReactionComponent>;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    if !IsDefined(this.m_hitReactionComponent) {
      this.m_hitReactionComponent = AIBehaviorScriptBase.GetPuppet(context).GetHitReactionComponent();
    };
  }

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    if this.m_hitReactionComponent.GetHasKerenzikov() {
      if !this.m_hitReactionComponent.GetCanBlock() {
        return AIbehaviorConditionOutcomes.True;
      };
      if this.m_hitReactionComponent.GetShouldEvade() {
        return AIbehaviorConditionOutcomes.True;
      };
    };
    return AIbehaviorConditionOutcomes.False;
  }
}
