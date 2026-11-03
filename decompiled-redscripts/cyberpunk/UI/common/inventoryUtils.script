
public class InventoryUtils extends IScriptable {

  public final static func IsPart(attachmentSlotID: TweakDBID) -> Bool {
    return attachmentSlotID == t"AttachmentSlots.PowerModule" || attachmentSlotID == t"AttachmentSlots.Magazine" || attachmentSlotID == t"AttachmentSlots.Scope";
  }

  public final static func GetMods(const itemData: script_ref<InventoryItemData>, opt onlyGeneric: Bool) -> [ref<InventoryItemAttachments>] {
    let attachments: ref<InventoryItemAttachments>;
    let resultMods: array<ref<InventoryItemAttachments>>;
    let allModsSize: Int32 = InventoryItemData.GetAttachmentsSize(itemData);
    let i: Int32 = 0;
    while i < allModsSize {
      attachments = InventoryItemData.GetAttachment(itemData, i);
      if !InventoryUtils.IsPart(attachments.SlotID) {
        if onlyGeneric {
          if NotEquals(attachments.SlotType, InventoryItemAttachmentType.Generic) {
          } else {
            ArrayPush(resultMods, attachments);
          };
        };
        ArrayPush(resultMods, attachments);
      };
      i += 1;
    };
    return resultMods;
  }

  public final static func GetParts(const itemData: script_ref<InventoryItemData>) -> [ref<InventoryItemAttachments>] {
    let attachments: ref<InventoryItemAttachments>;
    let resultParts: array<ref<InventoryItemAttachments>>;
    let allModsSize: Int32 = InventoryItemData.GetAttachmentsSize(itemData);
    let i: Int32 = 0;
    while i < allModsSize {
      attachments = InventoryItemData.GetAttachment(itemData, i);
      if InventoryUtils.IsPart(attachments.SlotID) {
        ArrayPush(resultParts, attachments);
      };
      i += 1;
    };
    return resultParts;
  }

  public final static func GetPartType(attachmentData: ref<InventoryItemAttachments>) -> WeaponPartType {
    switch attachmentData.SlotID {
      case t"AttachmentSlots.PowerModule":
        return WeaponPartType.Silencer;
      case t"AttachmentSlots.Magazine":
        return WeaponPartType.Magazine;
      case t"AttachmentSlots.Scope":
        return WeaponPartType.Scope;
    };
    return WeaponPartType.Scope;
  }

  public final static func GetInnerItemStatValueByType(item: ref<gameItemData>, slot: TweakDBID, stat: gamedataStatType) -> Float {
    let part: InnerItemData;
    item.GetItemPart(part, slot);
    return InnerItemData.GetStatValueByType(part, stat);
  }
}
