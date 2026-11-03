
public class RipperdocShardController extends inkLogicController {

  private edit let m_icon: inkImageRef;

  private edit let m_text: inkTextRef;

  private let m_data: ref<RipperdocShardData>;

  private let m_pulse: ref<PulseAnimation>;

  private let m_RootWidget: wref<inkWidget>;

  public final func GetQuality() -> gamedataQuality {
    return this.m_data.Quality;
  }

  public final func GetCount() -> Int32 {
    return this.m_data.Count;
  }

  public final func SetCount(count: Int32) -> Void {
    this.m_data.Count = count;
    inkTextRef.SetText(this.m_text, IntToString(this.m_data.Count));
    this.m_RootWidget.SetVisible(count > 0);
  }

  public final func Highlight(active: Bool) -> Void {
    active ? this.m_pulse.Start() : this.m_pulse.Stop();
  }

  public final func SetVisible(isVisible: Bool) -> Void {
    this.m_RootWidget.SetVisible(isVisible);
  }

  public final func Configure(data: ref<RipperdocShardData>) -> Void {
    this.m_data = data;
    this.m_RootWidget = this.GetRootWidget();
    inkWidgetRef.SetState(this.m_icon, EnumValueToName(n"gamedataQuality", Cast<Int64>(EnumInt(data.Quality))));
    this.SetCount(data.Count);
    this.m_pulse = new PulseAnimation();
    this.m_pulse.Configure(this.m_RootWidget, 1.00, 0.10, 0.50);
  }
}
