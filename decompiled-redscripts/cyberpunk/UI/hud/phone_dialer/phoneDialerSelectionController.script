
public class PhoneDialerSelectionController extends SelectorController {

  protected edit let m_leftArrowWidget: inkWidgetRef;

  protected edit let m_rightArrowWidget: inkWidgetRef;

  protected edit let m_container: inkCompoundRef;

  protected edit let m_line: inkWidgetRef;

  protected let m_leftArrowController: wref<inkInputDisplayController>;

  protected let m_rightArrowController: wref<inkInputDisplayController>;

  protected let m_widgetsControllers: [wref<HubMenuLabelContentContainer>];

  private let m_lineTranslationAnimProxy: ref<inkAnimProxy>;

  private let m_lineSizeAnimProxy: ref<inkAnimProxy>;

  private let m_animationsRetryDiv: Float;

  private let m_highlightInitialized: Bool;

  private let m_currentIndex: Int32;

  protected cb func OnInitialize() -> Bool {
    this.m_leftArrowController = inkWidgetRef.GetController(this.m_leftArrowWidget) as inkInputDisplayController;
    this.m_rightArrowController = inkWidgetRef.GetController(this.m_rightArrowWidget) as inkInputDisplayController;
    this.m_currentIndex = -1;
    this.m_highlightInitialized = false;
    this.SetupWidgets();
  }

  public final func SetupWidgets() -> Void {
    let controller: ref<HubMenuLabelContentContainer>;
    let widget: wref<inkWidget>;
    let i: Int32 = 0;
    while i < inkCompoundRef.GetNumChildren(this.m_container) {
      widget = inkCompoundRef.GetWidget(this.m_container, i);
      controller = widget.GetController() as HubMenuLabelContentContainer;
      ArrayPush(this.m_widgetsControllers, controller);
      i += 1;
    };
    this.UpdateArrowsVisibility();
  }

  public final func HideTab(index: Int32) -> Void {
    inkCompoundRef.GetWidget(this.m_container, index).SetVisible(false);
    this.QueueEvent(new DelayedHighlightUpdateEvent());
  }

  private final func UpdateArrowsVisibility() -> Void {
    this.m_leftArrowController.SetVisible(inkCompoundRef.GetNumChildren(this.m_container) > 1);
    this.m_rightArrowController.SetVisible(inkCompoundRef.GetNumChildren(this.m_container) > 1);
  }

  public final func ScrollTo(index: Int32, opt instant: Bool) -> Void {
    this.m_currentIndex = index;
    this.QueueEvent(new DelayedHighlightUpdateEvent());
  }

  protected func UpdateHightlight(index: Int32, opt instant: Bool) -> Void {
    let position: Vector2;
    let time: Float;
    let width: Float = this.m_widgetsControllers[index].GetWidth() + 2.00;
    if !this.m_highlightInitialized && width > 2.00 {
      this.m_highlightInitialized = true;
    };
    position = inkWidgetRef.Get(this.m_container) as inkCompoundWidget.GetChildPosition(this.m_widgetsControllers[index].GetRootWidget());
    this.UpdateLabelsStates(index);
    if instant {
      this.m_animationsRetryDiv = 0.00;
      this.m_lineTranslationAnimProxy.Stop();
      this.m_lineSizeAnimProxy.Stop();
      inkWidgetRef.SetTranslation(this.m_line, new Vector2(position.X, 0.00));
      inkWidgetRef.SetSize(this.m_line, new Vector2(width, inkWidgetRef.GetHeight(this.m_line)));
    } else {
      this.m_animationsRetryDiv += 0.50;
      time = 0.45 / MaxF(this.m_animationsRetryDiv, 1.00);
      time = MaxF(time, 0.20);
      this.AnimateLineTranslation(inkWidgetRef.Get(this.m_line), position.X, time);
      this.AnimateLineSize(inkWidgetRef.Get(this.m_line), width, time);
    };
  }

  protected func UpdateLabelsStates(currentIndex: Int32) -> Void {
    let i: Int32 = 0;
    let limit: Int32 = ArraySize(this.m_widgetsControllers);
    while i < limit {
      this.m_widgetsControllers[i].SetTextState(i == currentIndex ? n"Selected" : n"Default");
      i += 1;
    };
  }

  protected func AnimateLineTranslation(targetWidget: wref<inkWidget>, targetX: Float, time: Float) -> Void {
    let currentTranslation: Vector2;
    let translationInterpolator: ref<inkAnimTranslation>;
    let translationsAnimDef: ref<inkAnimDef>;
    this.m_lineTranslationAnimProxy.Stop();
    currentTranslation = targetWidget.GetTranslation();
    translationsAnimDef = new inkAnimDef();
    translationInterpolator = new inkAnimTranslation();
    translationInterpolator.SetType(inkanimInterpolationType.Quartic);
    translationInterpolator.SetMode(inkanimInterpolationMode.EasyInOut);
    translationInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
    translationInterpolator.SetStartTranslation(targetWidget.GetTranslation());
    translationInterpolator.SetEndTranslation(new Vector2(targetX, currentTranslation.Y));
    translationInterpolator.SetDuration(time);
    translationsAnimDef.AddInterpolator(translationInterpolator);
    this.m_lineTranslationAnimProxy = targetWidget.PlayAnimation(translationsAnimDef);
    this.m_lineTranslationAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnLineAnimationFinished");
  }

  protected func AnimateLineSize(targetWidget: wref<inkWidget>, targetWidth: Float, time: Float) -> Void {
    let currentSize: Vector2;
    let sizeAnimDef: ref<inkAnimDef>;
    let sizeInterpolator: ref<inkAnimSize>;
    this.m_lineSizeAnimProxy.Stop();
    currentSize = targetWidget.GetSize();
    sizeAnimDef = new inkAnimDef();
    sizeInterpolator = new inkAnimSize();
    sizeInterpolator.SetType(inkanimInterpolationType.Quartic);
    sizeInterpolator.SetMode(inkanimInterpolationMode.EasyInOut);
    sizeInterpolator.SetDirection(inkanimInterpolationDirection.FromTo);
    sizeInterpolator.SetStartSize(targetWidget.GetSize());
    sizeInterpolator.SetEndSize(new Vector2(targetWidth, currentSize.Y));
    sizeInterpolator.SetDuration(time);
    sizeAnimDef.AddInterpolator(sizeInterpolator);
    this.m_lineSizeAnimProxy = targetWidget.PlayAnimation(sizeAnimDef);
  }

  protected cb func OnLineAnimationFinished(anim: ref<inkAnimProxy>) -> Bool {
    this.m_animationsRetryDiv = 0.00;
  }

  protected cb func OnArrangeChildrenComplete() -> Bool {
    if !this.m_highlightInitialized && this.m_currentIndex != -1 {
      this.UpdateHightlight(this.m_currentIndex, true);
    };
  }

  protected cb func OnDelayedHighlightUpdate(evt: ref<DelayedHighlightUpdateEvent>) -> Bool {
    this.UpdateHightlight(this.m_currentIndex, false);
    this.UpdateArrowsVisibility();
  }
}
