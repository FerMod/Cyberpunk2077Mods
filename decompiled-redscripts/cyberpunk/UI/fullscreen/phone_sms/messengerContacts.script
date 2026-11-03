
public class SimpleMessengerItemVirtualController extends inkVirtualCompoundItemController {

  private edit let m_label: inkTextRef;

  private edit let m_msgPreview: inkTextRef;

  private edit let m_msgIndicator: inkWidgetRef;

  private edit let m_replyAlertIcon: inkWidgetRef;

  private edit let m_collapseIcon: inkWidgetRef;

  private edit let m_image: inkImageRef;

  private let m_type: MessengerContactType;

  private let m_contactData: ref<ContactData>;

  private let m_activeItemSync: wref<MessengerContactSyncData>;

  private let m_isContactActive: Bool;

  private let m_isItemHovered: Bool;

  private let m_isItemToggled: Bool;

  protected cb func OnInitialize() -> Bool {
    this.RegisterToCallback(n"OnToggledOn", this, n"OnToggledOn");
    this.RegisterToCallback(n"OnToggledOff", this, n"OnToggledOff");
    this.RegisterToCallback(n"OnSelected", this, n"OnSelected");
    this.RegisterToCallback(n"OnDeselected", this, n"OnDeselected");
  }

  protected cb func OnDataChanged(value: Variant) -> Bool {
    this.m_contactData = FromVariant<ref<IScriptable>>(value) as ContactData;
    this.m_activeItemSync = this.m_contactData.activeDataSync;
    this.m_type = this.m_contactData.type;
    if ArraySize(this.m_contactData.unreadMessages) > 0 {
      inkWidgetRef.SetState(this.m_msgPreview, n"isNew");
      inkWidgetRef.SetState(this.m_label, n"isNew");
    } else {
      inkWidgetRef.SetState(this.m_msgPreview, n"Default");
      inkWidgetRef.SetState(this.m_label, n"Default");
    };
    inkWidgetRef.SetVisible(this.m_replyAlertIcon, this.m_contactData.playerCanReply);
    inkTextRef.SetText(this.m_label, this.m_contactData.localizedName);
    if !this.m_contactData.hasValidTitle {
      if this.m_contactData.playerIsLastSender {
        inkTextRef.SetText(this.m_msgPreview, GetLocalizedTextByKey(n"UI-Phone-LabelYou") + GetLocalizedText(this.m_contactData.lastMesssagePreview));
      } else {
        inkTextRef.SetText(this.m_msgPreview, this.m_contactData.lastMesssagePreview);
      };
    } else {
      inkTextRef.SetText(this.m_msgPreview, this.m_contactData.localizedPreview);
    };
    if TDBID.IsValid(this.m_contactData.avatarID) {
      inkWidgetRef.SetVisible(this.m_image, true);
      InkImageUtils.RequestSetImage(this, this.m_image, this.m_contactData.avatarID);
    };
    this.UpdateState();
  }

  protected cb func OnContactSyncData(evt: ref<MessengerContactSyncBackEvent>) -> Bool {
    this.UpdateState();
  }

  protected cb func OnMessengerThreadSelectedEvent(evt: ref<MessengerThreadSelectedEvent>) -> Bool {
    ArrayRemove(this.m_contactData.unreadMessages, Cast<Int32>(evt.m_hash));
    if ArraySize(this.m_contactData.unreadMessages) > 0 {
      inkWidgetRef.SetVisible(this.m_msgIndicator, true);
      inkWidgetRef.SetState(this.m_msgPreview, n"isNew");
      inkWidgetRef.SetState(this.m_label, n"isNew");
    } else {
      inkWidgetRef.SetVisible(this.m_msgIndicator, false);
      inkWidgetRef.SetState(this.m_msgPreview, n"Default");
      inkWidgetRef.SetState(this.m_label, n"Default");
    };
  }

  protected cb func OnToggledOn(itemController: wref<inkVirtualCompoundItemController>) -> Bool {
    let evt: ref<MessengerContactSelectedEvent> = new MessengerContactSelectedEvent();
    evt.m_type = this.m_type;
    evt.m_entryHash = this.m_contactData.hash;
    this.QueueEvent(evt);
    this.m_isItemToggled = true;
  }

  protected cb func OnToggledOff(itemController: wref<inkVirtualCompoundItemController>) -> Bool {
    this.m_isItemToggled = false;
    this.UpdateState();
  }

  protected cb func OnSelected(itemController: wref<inkVirtualCompoundItemController>, discreteNav: Bool) -> Bool {
    this.m_isItemHovered = true;
    this.UpdateState();
    if discreteNav {
      this.SetCursorOverWidget(this.GetRootWidget());
    };
  }

  protected cb func OnDeselected(itemController: wref<inkVirtualCompoundItemController>) -> Bool {
    this.m_isItemHovered = false;
    this.UpdateState();
  }

  private final func UpdateState() -> Void {
    if this.m_activeItemSync.m_entryHash == this.m_contactData.hash {
      this.GetRootWidget().SetState(n"Active");
    } else {
      if this.m_isItemHovered {
        this.GetRootWidget().SetState(n"Hover");
      } else {
        this.GetRootWidget().SetState(n"Default");
      };
    };
  }
}
