
public class PerksPointsDisplayController extends inkLogicController {

  protected edit let m_desc1Text: inkTextRef;

  protected edit let m_value1Text: inkTextRef;

  protected edit let m_icon1: inkImageRef;

  protected edit let m_desc2Text: inkTextRef;

  protected edit let m_value2Text: inkTextRef;

  protected edit let m_icon2: inkImageRef;

  protected edit let m_desc3Text: inkTextRef;

  protected edit let m_value3Text: inkTextRef;

  protected edit let m_icon3: inkImageRef;

  private let m_screenType: CharacterScreenType;

  public final func Setup(type: CharacterScreenType) -> Void {
    this.m_screenType = type;
    switch type {
      case CharacterScreenType.Attributes:
        this.SetDescriptions(GetLocalizedText("LocKey#40622"), GetLocalizedText("LocKey#40623"));
        this.SetIcons(n"ico_points_attribs", n"ico_points_perks");
        this.GetRootWidget().SetState(n"Default");
        break;
      case CharacterScreenType.Perks:
        this.SetDescriptions(GetLocalizedText("LocKey#40624"), GetLocalizedText("LocKey#40623"));
        this.SetIcons(n"ico_points_perks", n"ico_points_perks");
    };
    inkWidgetRef.SetVisible(this.m_desc1Text, Equals(type, CharacterScreenType.Attributes));
    inkWidgetRef.SetVisible(this.m_value1Text, Equals(type, CharacterScreenType.Attributes));
    inkWidgetRef.SetVisible(this.m_icon1, Equals(type, CharacterScreenType.Attributes));
  }

  public final func SetValues(value1: Int32, value2: Int32, value3: Int32) -> Void {
    this.SetValues(value1, value2);
    inkTextRef.SetText(this.m_value3Text, IntToString(value3));
  }

  public final func SetValues(value1: Int32, value2: Int32) -> Void {
    inkTextRef.SetText(this.m_value1Text, IntToString(value1));
    inkTextRef.SetText(this.m_value2Text, IntToString(value2));
  }

  private final func SetDescriptions(const desc1: script_ref<String>, const desc2: script_ref<String>) -> Void {
    inkTextRef.SetText(this.m_desc1Text, Deref(desc1));
    inkTextRef.SetText(this.m_desc2Text, Deref(desc2));
  }

  private final func SetIcons(part1: CName, part2: CName) -> Void {
    inkImageRef.SetTexturePart(this.m_icon1, part1);
    inkImageRef.SetTexturePart(this.m_icon2, part2);
  }
}
