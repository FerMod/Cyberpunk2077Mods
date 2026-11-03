
public class RipperdocPerkTooltip extends AGenericTooltipController {

  private edit let m_perkName: inkTextRef;

  private edit let m_perkIcon: inkImageRef;

  private edit let m_skeletonPerkLocKey: CName;

  private edit let m_handsPerkLocKey: CName;

  private edit let m_skeletonPerkIconName: CName;

  private edit let m_handsPerkIconName: CName;

  public func SetData(tooltipData: ref<ATooltipData>) -> Void {
    let data: ref<RipperdocPerkTooltipData> = tooltipData as RipperdocPerkTooltipData;
    if Equals(data.ripperdocHoverState, RipperdocHoverState.SlotSkeleton) {
      inkTextRef.SetText(this.m_perkName, GetLocalizedItemNameByCName(this.m_skeletonPerkLocKey) + " (" + GetLocalizedItemNameByCName(n"Gameplay-RPG-Skills-LevelName") + " " + IntToString(3) + ")");
      inkImageRef.SetTexturePart(this.m_perkIcon, this.m_skeletonPerkIconName);
    };
    if Equals(data.ripperdocHoverState, RipperdocHoverState.SlotHands) {
      inkTextRef.SetLocalizedText(this.m_perkName, this.m_handsPerkLocKey);
      inkImageRef.SetTexturePart(this.m_perkIcon, this.m_handsPerkIconName);
    };
  }
}
