
public class PhotoModeListController extends inkLogicController {

  private edit let m_Panel: inkVerticalPanelRef;

  private edit let m_sliderWidget: inkWidgetRef;

  private edit let m_scrollArea: inkScrollAreaRef;

  private let m_menuController: wref<gameuiMenuGameController>;

  private let m_scrollController: wref<inkScrollController>;

  private let m_listController: wref<ListController>;

  private let m_fadeAnim: ref<inkAnimProxy>;

  private let m_isAnimating: Bool;

  private let m_animationTime: Float;

  private let m_animationTarget: Float;

  private let m_elementsAnimationTime: Float;

  private let m_elementsAnimationDelay: Float;

  private let m_currentElementAnimation: Int32;

  protected cb func OnInitialize() -> Bool {
    this.m_scrollController = this.GetControllerByType(n"inkScrollController") as inkScrollController;
    this.m_listController = inkWidgetRef.GetController(this.m_Panel) as ListController;
    inkWidgetRef.RegisterToCallback(this.m_Panel, n"OnRelease", this, n"OnRelease");
  }

  protected cb func OnUninitialize() -> Bool {
    inkWidgetRef.UnregisterFromCallback(this.m_Panel, n"OnRelease", this, n"OnRelease");
  }

  protected cb func OnRelease(e: ref<inkPointerEvent>) -> Bool {
    if e.IsAction(n"PhotoMode_ScrollUp") {
      this.m_scrollController.Scroll(1.00, true);
    } else {
      if e.IsAction(n"PhotoMode_ScrollDown") {
        this.m_scrollController.Scroll(-1.00, true);
      };
    };
  }

  public final func SetMenuController(controller: wref<gameuiMenuGameController>) -> Void {
    this.m_menuController = controller;
  }

  public final const func GetList() -> wref<ListController> {
    return this.m_listController;
  }

  public final func SetReversedUI(isReversed: Bool) -> Void {
    let listElement: wref<inkWidget>;
    let photoModeListItem: ref<PhotoModeMenuListItem>;
    let i: Int32 = 0;
    while i < this.m_listController.Size() {
      listElement = this.m_listController.GetItemAt(i);
      photoModeListItem = listElement.GetControllerByType(n"PhotoModeMenuListItem") as PhotoModeMenuListItem;
      photoModeListItem.SetReversedUI(isReversed);
      i += 1;
    };
  }

  private final func OnVisbilityChanged(visible: Bool) -> Void {
    let controller: ref<PhotoModeMenuListItem>;
    let listElement: wref<inkWidget>;
    let i: Int32 = 0;
    while i < this.m_listController.Size() {
      listElement = this.m_listController.GetItemAt(i);
      if IsDefined(listElement) {
        controller = listElement.GetControllerByType(n"PhotoModeMenuListItem") as PhotoModeMenuListItem;
        if IsDefined(controller) {
          controller.OnVisbilityChanged(visible);
        };
      };
      i += 1;
    };
  }

  private final func PlayFadeAnimation(fadeIn: Bool) -> Void {
    this.m_elementsAnimationTime = 0.00;
    this.m_currentElementAnimation = 0;
    if fadeIn {
      this.GetRootWidget().SetVisible(true);
      this.SetAllItemsOpacity(0.00);
      this.PlayLibraryAnimation(n"list_container_in");
      this.OnVisbilityChanged(true);
    } else {
      this.PlayLibraryAnimation(n"list_container_out");
    };
  }

  private final func PlayFadeElementAnimation(fadeIn: Bool) -> Void {
    let listElement: wref<inkWidget> = this.m_listController.GetItemAt(this.m_currentElementAnimation);
    let photoModeListItem: ref<PhotoModeMenuListItem> = listElement.GetControllerByType(n"PhotoModeMenuListItem") as PhotoModeMenuListItem;
    if fadeIn {
      listElement.SetOpacity(1.00);
      photoModeListItem.PlayLibraryAnimation(n"option_in");
    } else {
      photoModeListItem.PlayLibraryAnimation(n"option_out");
    };
    this.m_elementsAnimationTime = this.m_elementsAnimationDelay;
    this.m_currentElementAnimation += 1;
    if this.m_currentElementAnimation >= this.m_listController.Size() {
      this.m_currentElementAnimation = -1;
      if !fadeIn {
        this.GetRootWidget().SetVisible(false);
        this.OnVisbilityChanged(false);
      };
    };
  }

  private final func SetAllItemsOpacity(opacity: Float) -> Void {
    let listElement: wref<inkWidget>;
    let i: Int32 = 0;
    while i < this.m_listController.Size() {
      listElement = this.m_listController.GetItemAt(i);
      listElement.SetOpacity(opacity);
      i += 1;
    };
  }

  public final func ShowAnimated(delay: Float) -> Void {
    this.m_animationTime = -delay;
    this.m_animationTarget = 1.00;
    this.m_isAnimating = true;
    this.m_currentElementAnimation = -1;
  }

  public final func HideAnimated(delay: Float) -> Void {
    this.m_animationTime = -delay;
    this.m_animationTarget = 0.00;
    this.m_isAnimating = true;
    this.m_currentElementAnimation = -1;
  }

  public final func Update(timeDelta: Float) -> Void {
    if this.m_isAnimating {
      this.m_animationTime += timeDelta;
      if this.m_animationTime >= 0.00 {
        this.PlayFadeAnimation(this.m_animationTarget == 1.00);
        this.m_isAnimating = false;
      };
    };
    if this.m_currentElementAnimation >= 0 {
      this.m_elementsAnimationTime -= timeDelta;
      if this.m_elementsAnimationTime <= 0.00 {
        this.PlayFadeElementAnimation(this.m_animationTarget == 1.00);
      };
    };
  }

  public final func PostInitItems() -> Void {
    this.m_elementsAnimationTime = 0.00;
    this.m_elementsAnimationDelay = 0.03;
    this.m_currentElementAnimation = -1;
    this.m_listController.Refresh();
    this.GetRootWidget().SetVisible(false);
  }

  public final func HandleInputWithVisibilityCheck(e: ref<inkPointerEvent>, opt gameCtrl: wref<inkGameController>) -> Void {
    let widgetHStack: ref<inkHorizontalPanel> = this.GetRootWidget() as inkHorizontalPanel;
    let listElement: wref<inkWidget> = this.m_listController.GetItemAt(this.m_listController.GetSelectedIndex());
    let photoModeListItem: ref<PhotoModeMenuListItem> = listElement.GetControllerByType(n"PhotoModeMenuListItem") as PhotoModeMenuListItem;
    let gridSelector: wref<PhotoModeGridList> = photoModeListItem.GetGridSelector();
    if IsDefined(widgetHStack) {
      if e.IsAction(n"left_button") {
        this.SelectPriorVisible(this.m_listController.GetSelectedIndex());
      } else {
        if e.IsAction(n"right_button") {
          this.SelectNextVisible(this.m_listController.GetSelectedIndex());
        };
      };
    } else {
      if e.IsAction(n"up_button") {
        if gridSelector == null || Equals(gridSelector.TrySelectUp(), false) {
          this.SelectPriorVisible(this.m_listController.GetSelectedIndex());
        };
      } else {
        if e.IsAction(n"down_button") {
          if gridSelector == null || Equals(gridSelector.TrySelectDown(), false) {
            this.SelectNextVisible(this.m_listController.GetSelectedIndex());
          };
        } else {
          if e.IsAction(n"PhotoMode_Left_Button") {
            gridSelector.TrySelectLeft();
          } else {
            if e.IsAction(n"PhotoMode_Right_Button") {
              gridSelector.TrySelectRight();
            };
          };
        };
      };
    };
    this.m_scrollController.EnsureVisible(this.m_listController.GetItemAt(this.m_listController.GetSelectedIndex()));
  }

  public final func GetFirstVisibleIndex() -> Int32 {
    let listElement: wref<inkWidget>;
    let i: Int32 = 0;
    while i < this.m_listController.Size() {
      listElement = this.m_listController.GetItemAt(i);
      if listElement.IsVisible() {
        return i;
      };
      i += 1;
    };
    return 0;
  }

  protected final func SelectPriorVisible(currentIndex: Int32) -> Bool {
    let listElement: wref<inkWidget>;
    let indexToSet: Int32 = currentIndex - 1;
    if indexToSet >= 0 {
      listElement = this.m_listController.GetItemAt(indexToSet);
      if !listElement.IsVisible() {
        if this.SelectPriorVisible(indexToSet) {
          this.m_listController.Prior();
          return true;
        };
        return false;
      };
      this.m_listController.Prior();
      return true;
    };
    return false;
  }

  protected final func SelectNextVisible(currentIndex: Int32) -> Bool {
    let listElement: wref<inkWidget>;
    let indexToSet: Int32 = currentIndex + 1;
    if indexToSet < this.m_listController.Size() {
      listElement = this.m_listController.GetItemAt(indexToSet);
      if !listElement.IsVisible() {
        if this.SelectNextVisible(indexToSet) {
          this.m_listController.Next();
          return true;
        };
        return false;
      };
      this.m_listController.Next();
      return true;
    };
    return false;
  }
}
