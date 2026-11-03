
public class RipperdocCategoryTooltip extends AGenericTooltipController {

  private edit let m_desc: inkTextRef;

  private edit let m_availableLabelCounter: inkTextRef;

  private edit let m_ownedLabelCounter: inkTextRef;

  private edit let m_ownedLabel: inkWidgetRef;

  private edit let m_availableLabel: inkWidgetRef;

  private edit let m_NALabel: inkWidgetRef;

  public func SetData(tooltipData: ref<ATooltipData>) -> Void {
    let data: ref<RipperdocCategoryTooltipData> = tooltipData as RipperdocCategoryTooltipData;
    inkWidgetRef.SetVisible(this.m_ownedLabel, data.ownedItems > 0 && Equals(data.screenType, CyberwareScreenType.Inventory));
    inkWidgetRef.SetVisible(this.m_availableLabel, data.availableItems > 0 && Equals(data.screenType, CyberwareScreenType.Ripperdoc));
    inkWidgetRef.SetVisible(this.m_NALabel, data.availableItems == 0 && data.ownedItems == 0);
    inkTextRef.SetText(this.m_availableLabelCounter, IntToString(data.availableItems));
    inkTextRef.SetText(this.m_ownedLabelCounter, IntToString(data.ownedItems));
    inkTextRef.SetText(this.m_desc, GetLocalizedText(this.GetCategoryLockey(data.category)));
  }

  private final func GetCategoryLockey(category: gamedataEquipmentArea) -> String {
    switch category {
      case gamedataEquipmentArea.EyesCW:
        return "LocKey#93189";
      case gamedataEquipmentArea.SystemReplacementCW:
        return "LocKey#93196";
      case gamedataEquipmentArea.ArmsCW:
        return "LocKey#93187";
      case gamedataEquipmentArea.HandsCW:
        return "LocKey#93191";
      case gamedataEquipmentArea.LegsCW:
        return "LocKey#93194";
      case gamedataEquipmentArea.FrontalCortexCW:
        return "LocKey#93190";
      case gamedataEquipmentArea.NervousSystemCW:
        return "LocKey#93195";
      case gamedataEquipmentArea.IntegumentarySystemCW:
        return "LocKey#93192";
      case gamedataEquipmentArea.MusculoskeletalSystemCW:
        return "LocKey#93193";
      case gamedataEquipmentArea.CardiovascularSystemCW:
        return "LocKey#93188";
      default:
        return "LocKey#93188";
    };
  }
}
