
public class VisualTooltipController extends ItemTooltipCommonController {

  protected func UpdateLayout() -> Void {
    this.UpdateHeaderModule();
    this.UpdateClothingInfoModule();
    this.UpdateDetailsModule();
    this.UpdateTransmogModule();
    if IsStringValid(this.m_data.description) {
      inkWidgetRef.SetVisible(this.m_descriptionWrapper, true);
      inkTextRef.SetText(this.m_descriptionText, GetLocalizedText(this.m_data.description));
    } else {
      inkWidgetRef.SetVisible(this.m_descriptionWrapper, false);
    };
  }

  protected func UpdateTransmogModule() -> Void {
    if ItemID.IsValid(this.m_data.transmogItem) {
      this.RequestModule(this.m_itemActionContainer, n"itemTransmog", n"OnTransmogModuleSpawned");
      inkWidgetRef.SetVisible(this.m_itemActionContainer, true);
    } else {
      inkWidgetRef.SetVisible(this.m_itemActionContainer, false);
    };
  }

  protected cb func OnTransmogModuleSpawned(widget: ref<inkWidget>, userData: ref<IScriptable>) -> Bool {
    this.HandleModuleSpawned(widget, userData as ItemTooltipModuleSpawnedCallbackData);
  }
}

public class ItemTooltipTransmogModule extends ItemTooltipModuleController {

  private edit let m_buttonHintWidgetRef: inkWidgetRef;

  private edit let m_labelRef: inkTextRef;

  private let m_buttonHint: wref<LabelInputDisplayController>;

  protected cb func OnInitialize() -> Bool {
    this.m_buttonHint = inkWidgetRef.GetController(this.m_buttonHintWidgetRef) as LabelInputDisplayController;
  }

  public func Update(data: ref<MinimalItemTooltipData>) -> Void {
    this.m_buttonHint.SetInputAction(n"click");
    inkTextRef.SetLocalizedText(this.m_labelRef, n"UI-UserActions-UnequipVisuals");
  }

  public func NEW_Update(data: wref<UIInventoryItem>) -> Void {
    this.m_buttonHint.SetInputAction(n"click");
    inkTextRef.SetLocalizedText(this.m_labelRef, n"UI-UserActions-UnequipVisuals");
  }
}
