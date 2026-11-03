
public class RipperdocPerkController extends inkLogicController {

  private edit let m_icon: inkImageRef;

  private let m_perkData: ref<RipperdocPerkData>;

  private let m_hoverEvent: ref<RipperdocPerkHoverEvent>;

  protected cb func OnInitialize() -> Bool {
    inkWidgetRef.RegisterToCallback(this.m_icon, n"OnHoverOver", this, n"OnPerkHover");
    inkWidgetRef.RegisterToCallback(this.m_icon, n"OnHoverOut", this, n"OnPerkUnhover");
    this.m_hoverEvent = new RipperdocPerkHoverEvent();
  }

  protected cb func OnPerkHover(evt: ref<inkPointerEvent>) -> Bool {
    this.m_hoverEvent.IsHover = true;
    this.QueueEvent(this.m_hoverEvent);
    inkWidgetRef.SetOpacity(this.m_icon, 1.00);
  }

  protected cb func OnPerkUnhover(evt: ref<inkPointerEvent>) -> Bool {
    this.m_hoverEvent.IsHover = false;
    this.QueueEvent(this.m_hoverEvent);
    inkWidgetRef.SetOpacity(this.m_icon, 0.50);
  }

  public final func Configure(data: ref<RipperdocPerkData>) -> Void {
    this.m_perkData = data;
    let perkRecord: ref<NewPerk_Record> = TweakDBInterface.GetNewPerkRecord(data.Perk);
    let iconRecord: ref<UIIcon_Record> = perkRecord.PerkIconHandle();
    inkImageRef.SetAtlasResource(this.m_icon, iconRecord.AtlasResourcePath());
    inkImageRef.SetTexturePart(this.m_icon, iconRecord.AtlasPartName());
    inkWidgetRef.SetState(this.m_icon, data.Level == 0 ? n"NotActive" : n"Active");
    inkWidgetRef.SetOpacity(this.m_icon, 0.50);
    this.m_hoverEvent.Area = data.Area;
    this.m_hoverEvent.Type = perkRecord.Type();
    this.m_hoverEvent.AttributeID = perkRecord.Attribute().GetID();
  }
}
