
public class GrenadeChangedCallback extends AttachmentSlotsScriptCallback {

  public let grenadeChangeEntity: wref<GameObject>;

  public let grenadeChangeListener: ref<AttachmentSlotsScriptListener>;

  public func OnItemEquippedVisual(slot: TweakDBID, item: ItemID) -> Void {
    let itemObject: ref<ItemObject> = GameInstance.GetTransactionSystem(this.grenadeChangeEntity.GetGame()).GetItemInSlot(this.grenadeChangeEntity, t"AttachmentSlots.WeaponLeft");
    if !IsDefined(itemObject) {
      return;
    };
    this.TriggerItemActivation(this.grenadeChangeEntity as gamePuppet, t"AttachmentSlots.WeaponLeft");
    if IsDefined(this.grenadeChangeListener) && IsDefined(this.grenadeChangeEntity) {
      GameInstance.GetTransactionSystem(this.grenadeChangeEntity.GetGame()).UnregisterAttachmentSlotListener(this.grenadeChangeEntity, this.grenadeChangeListener);
    };
  }

  private final func TriggerItemActivation(puppet: ref<gamePuppet>, attachmentSlotID: TweakDBID) -> Void {
    let forceActivationEvent: ref<gameprojectileForceActivationEvent>;
    let item: wref<ItemObject>;
    let launchEvent: ref<gameprojectileSetUpAndLaunchEvent>;
    let orientation: Quaternion;
    let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(puppet.GetGame());
    if !IsDefined(transactionSystem) {
      return;
    };
    item = transactionSystem.GetItemInSlot(puppet, attachmentSlotID);
    if !IsDefined(item) {
      return;
    };
    launchEvent = new gameprojectileSetUpAndLaunchEvent();
    forceActivationEvent = new gameprojectileForceActivationEvent();
    transactionSystem.RemoveItemFromSlot(puppet, attachmentSlotID, false);
    launchEvent.launchParams.logicalPositionProvider = IPositionProvider.CreateEntityPositionProvider(item);
    launchEvent.launchParams.logicalOrientationProvider = IOrientationProvider.CreateEntityOrientationProvider(null, n"None", puppet);
    launchEvent.launchParams.visualPositionProvider = IPositionProvider.CreateEntityPositionProvider(item);
    Quaternion.SetIdentity(orientation);
    launchEvent.launchParams.visualOrientationProvider = IOrientationProvider.CreateStaticOrientationProvider(orientation);
    launchEvent.launchParams.ownerVelocityProvider = MoveComponentVelocityProvider.CreateMoveComponentVelocityProvider(puppet);
    launchEvent.owner = puppet;
    item.QueueEvent(launchEvent);
    item.QueueEvent(forceActivationEvent);
  }
}

public class GrenadeLvl4HackEffector extends Effector {

  private let m_grenadeChangeEntity: wref<GameObject>;

  private let m_grenadeChangedListener: ref<AttachmentSlotsScriptListener>;

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    let grenadeChangedCallback: ref<GrenadeChangedCallback>;
    if !IsDefined(this.m_grenadeChangedListener) {
      this.m_grenadeChangeEntity = owner;
      grenadeChangedCallback = new GrenadeChangedCallback();
      grenadeChangedCallback.grenadeChangeEntity = this.m_grenadeChangeEntity;
      grenadeChangedCallback.slotID = t"AttachmentSlots.WeaponLeft";
      this.m_grenadeChangedListener = GameInstance.GetTransactionSystem(owner.GetGame()).RegisterAttachmentSlotListener(this.m_grenadeChangeEntity, grenadeChangedCallback);
      grenadeChangedCallback.grenadeChangeListener = this.m_grenadeChangedListener;
    };
    this.ProcessEffector(owner);
  }

  protected func RepeatedAction(owner: ref<GameObject>) -> Void {
    this.ProcessEffector(owner);
  }

  private final func ProcessEffector(owner: ref<GameObject>) -> Void {
    let highPriority: Bool;
    let item: TweakDBID;
    let itemID: ItemID;
    let puppet: ref<gamePuppet> = owner as gamePuppet;
    let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(puppet.GetGame());
    let statSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(puppet.GetGame());
    let hasFrag: Bool = statSystem.GetStatValue(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatType.CanUseFragGrenades) > 0.00;
    let hasFire: Bool = statSystem.GetStatValue(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatType.CanUseIncendiaryGrenades) > 0.00;
    let hasBio: Bool = statSystem.GetStatValue(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatType.CanUseBiohazardGrenades) > 0.00;
    let hasEMP: Bool = statSystem.GetStatValue(Cast<StatsObjectID>(owner.GetEntityID()), gamedataStatType.CanUseEMPGrenades) > 0.00;
    let inventoryManager: ref<InventoryDataManagerV2> = new InventoryDataManagerV2();
    inventoryManager.Initialize(owner as PlayerPuppet);
    if !IsDefined(puppet) {
      return;
    };
    if hasFrag {
      item = t"Items.GrenadeFragRegularHack";
    } else {
      if hasFire {
        item = t"Items.GrenadeIncendiaryRegularHack";
      } else {
        if hasBio {
          item = t"Items.GrenadeBiohazardRegularHack";
        } else {
          if hasEMP {
            item = t"Items.GrenadeEMPRegularHack";
          } else {
            item = t"Items.GrenadeFragRegularHack";
          };
        };
      };
    };
    itemID = ItemID.CreateQuery(item);
    if !ItemID.IsValid(itemID) {
      return;
    };
    if !IsDefined(transactionSystem) {
      return;
    };
    if transactionSystem.HasItemInAnySlot(owner, itemID) {
      if !transactionSystem.HasItem(owner, itemID) {
        if !transactionSystem.GiveItem(owner, itemID, 1) {
          return;
        };
      };
      if !transactionSystem.ChangeItemToSlot(owner, t"AttachmentSlots.WeaponLeft", itemID) {
        return;
      };
    } else {
      if !transactionSystem.HasItem(owner, itemID) {
        if !transactionSystem.GiveItem(owner, itemID, 1) {
          return;
        };
      };
      highPriority = NotEquals(WeaponObject.GetWeaponType(itemID), gamedataItemType.Invalid);
      if !transactionSystem.AddItemToSlot(owner, t"AttachmentSlots.WeaponLeft", itemID, highPriority) {
        return;
      };
    };
    AIActionHelper.ClearItemsToEquip(owner as ScriptedPuppet);
  }
}
