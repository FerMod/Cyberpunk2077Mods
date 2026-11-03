
public class QuickHackMappinController extends BaseInteractionMappinController {

  private edit let m_bar: inkWidgetRef;

  private edit let m_header: inkTextRef;

  private edit let m_iconWidgetActive: inkImageRef;

  private let m_rootWidget: wref<inkWidget>;

  private let m_mappin: wref<IMappin>;

  private let m_data: ref<GameplayRoleMappinData>;

  private edit const let m_queueQuickHackWidgets: [inkWidgetRef];

  private let m_queueQuickHackControllers: [wref<QuickHackQueueItem>];

  private let m_mappinDataQueue: [ref<GameplayRoleMappinData>];

  private let m_animUpload: ref<inkAnimProxy>;

  private let m_animQueue: ref<inkAnimProxy>;

  protected cb func OnInitialize() -> Bool {
    this.m_rootWidget = this.GetRootWidget();
    let i: Int32 = 0;
    while i < ArraySize(this.m_queueQuickHackWidgets) {
      ArrayPush(this.m_queueQuickHackControllers, inkWidgetRef.GetController(this.m_queueQuickHackWidgets[i]) as QuickHackQueueItem);
      this.m_queueQuickHackControllers[i].Hide();
      i += 1;
    };
  }

  protected cb func OnIntro() -> Bool {
    let localizedText: String;
    let translationAnimationCtrl: wref<inkTextReplaceController>;
    this.m_mappin = this.GetMappin();
    this.m_data = this.GetVisualData();
    this.HelperSetIcon(this.iconWidget, this.m_data.m_textureID);
    this.HelperSetIcon(this.m_iconWidgetActive, this.m_data.m_textureID);
    this.UpdateView();
    this.m_animUpload = this.PlayLibraryAnimation(n"upload");
    localizedText = GetLocalizedText("LocKey#11047");
    translationAnimationCtrl = inkWidgetRef.GetController(this.m_header) as inkTextReplaceController;
    translationAnimationCtrl.SetBaseText("...");
    translationAnimationCtrl.SetTargetText(localizedText);
    translationAnimationCtrl.PlaySetAnimation();
  }

  public final func UploadComplete() -> Void {
    this.m_animUpload = this.PlayLibraryAnimation(n"upload_complete");
    this.m_animUpload.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnUploadCompleteFinished");
  }

  protected cb func OnUploadCompleteFinished(anim: ref<inkAnimProxy>) -> Bool {
    this.UpdateQueue();
  }

  public final func UpdateQueue() -> Void {
    this.m_animQueue = this.PlayLibraryAnimation(n"queue_move_up");
    this.m_animQueue.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnQueueMovedUp");
  }

  protected cb func OnQueueMovedUp(anim: ref<inkAnimProxy>) -> Bool {
    let i: Int32;
    this.m_animUpload = this.PlayLibraryAnimation(n"upload");
    this.m_animUpload.GotoEndAndStop();
    this.m_animQueue = this.PlayLibraryAnimation(n"queue_move_up");
    this.m_animQueue.GotoStartAndStop();
    this.m_data = this.m_mappinDataQueue[0];
    this.HelperSetIcon(this.iconWidget, this.m_data.m_textureID);
    this.HelperSetIcon(this.m_iconWidgetActive, this.m_data.m_textureID);
    this.UpdateView();
    i = 0;
    while i < ArraySize(this.m_mappinDataQueue) - 1 {
      this.m_queueQuickHackControllers[i].Setup(this.m_mappinDataQueue[i + 1]);
      i += 1;
    };
    this.m_queueQuickHackControllers[ArraySize(this.m_mappinDataQueue) - 1].Hide();
    ArrayErase(this.m_mappinDataQueue, 0);
  }

  protected cb func OnNameplate(isNameplateVisible: Bool, nameplateController: wref<NpcNameplateGameController>) -> Bool {
    if isNameplateVisible {
      this.SetProjectToScreenSpace(false);
    } else {
      this.SetProjectToScreenSpace(true);
    };
  }

  protected cb func OnQueueQuickHackEvent(evt: ref<QueueQuickHackEvent>) -> Bool {
    let queueController: wref<QuickHackQueueItem>;
    if NotEquals(evt.mappinID, this.m_mappin.GetNewMappinID()) {
      return false;
    };
    if Equals(this.m_data.m_progressBarType, EProgressBarType.DURATION) {
      return false;
    };
    ArrayPush(this.m_mappinDataQueue, evt.data);
    queueController = this.m_queueQuickHackControllers[ArraySize(this.m_mappinDataQueue) - 1];
    queueController.Setup(evt.data);
    queueController.Upload();
  }

  protected cb func OnDequeueQuickHackEvent(evt: ref<DequeueQuickHackEvent>) -> Bool {
    if NotEquals(evt.mappinID, this.m_mappin.GetNewMappinID()) {
      return false;
    };
    if Equals(this.m_data.m_progressBarType, EProgressBarType.DURATION) {
      return false;
    };
    this.UploadComplete();
  }

  private final func OnStatsDataUpdated(progress: Float) -> Void {
    this.m_data = this.GetVisualData();
    if Equals(this.m_data.m_progressBarType, EProgressBarType.UPLOAD) {
      inkWidgetRef.SetScale(this.m_bar, new Vector2(2.00, progress));
    } else {
      if Equals(this.m_data.m_progressBarType, EProgressBarType.DURATION) {
        inkWidgetRef.SetScale(this.m_bar, new Vector2(2.00, 1.00 - progress));
      };
    };
    this.UpdateView();
  }

  private final func UpdateView() -> Void {
    if Equals(this.m_data.m_progressBarContext, EProgressBarContext.QuickHack) {
      if Equals(this.m_data.m_progressBarType, EProgressBarType.UPLOAD) {
        inkWidgetRef.SetVisible(this.m_header, false);
        this.m_rootWidget.SetState(this.m_data.m_action.m_IsAppliedByMonowire ? n"Relic" : n"Upload");
      } else {
        if Equals(this.m_data.m_progressBarType, EProgressBarType.DURATION) {
          this.m_rootWidget.SetState(n"Default");
        };
      };
    } else {
      if Equals(this.m_data.m_progressBarContext, EProgressBarContext.PhoneCall) {
        inkTextRef.SetText(this.m_header, "LocKey#2142");
        this.m_rootWidget.SetState(n"Default");
      };
    };
  }

  public const func GetVisualData() -> ref<GameplayRoleMappinData> {
    let data: ref<GameplayRoleMappinData> = this.m_mappin.GetScriptData() as GameplayRoleMappinData;
    return data;
  }

  public final func Fold() -> Void {
    let animOptions: inkAnimOptions;
    animOptions.playReversed = true;
    this.PlayLibraryAnimation(n"unfold", animOptions);
  }

  public final func Unfold() -> Void {
    this.PlayLibraryAnimation(n"unfold");
  }

  private final func HelperSetIcon(currImage: inkImageRef, iconID: TweakDBID) -> Void {
    if TDBID.IsValid(iconID) {
      this.SetTexture(currImage, iconID);
    };
  }
}

public class QuickHackQueueItem extends inkLogicController {

  private edit let m_icon: inkImageRef;

  private let m_data: ref<GameplayRoleMappinData>;

  private let m_anim: ref<inkAnimProxy>;

  public final func Setup(data: ref<GameplayRoleMappinData>) -> Void {
    this.m_data = data;
    this.SetTexture(this.m_icon, this.m_data.m_textureID);
  }

  public final func Upload() -> Void {
    this.Show();
    this.m_anim = this.PlayLibraryAnimation(n"upload_queue");
  }

  public final func Show() -> Void {
    this.GetRootWidget().SetVisible(true);
  }

  public final func Hide() -> Void {
    this.GetRootWidget().SetVisible(false);
  }
}
