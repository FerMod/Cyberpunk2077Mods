
public class CreditsGameController extends gameuiCreditsController {

  private edit let m_videoContainer: inkCompoundRef;

  private edit let m_sceneTexture: inkImageRef;

  private edit let m_backgroundVideo: inkVideoRef;

  private edit let m_binkVideo: inkVideoRef;

  private edit const let m_binkVideos: [BinkResource];

  private edit let m_fastForward: inkTextRef;

  private edit let m_timerUntilFadeEp1: Float;

  private edit let m_musicVideoEp1: inkVideoRef;

  private edit let m_creditsAnimEp1: inkCompoundRef;

  private let m_currentBinkVideo: Int32;

  private let m_videoSummary: VideoWidgetSummary;

  private let m_isDataSet: Bool;

  private let m_accumulatedTime: Float;

  private let m_isCounting: Bool;

  protected cb func OnInitialize() -> Bool {
    this.InitializeCredits();
  }

  protected cb func OnUpdate(timeDelta: Float) -> Bool {
    if this.isInFinalBoardsMode && this.isEp1CreditsImplementation && this.m_isCounting {
      this.m_accumulatedTime += timeDelta;
      if this.m_accumulatedTime > this.m_timerUntilFadeEp1 {
        this.m_isCounting = false;
        this.FinishVideo();
      };
    };
  }

  protected cb func OnUninitialize() -> Bool {
    inkVideoRef.Stop(this.m_backgroundVideo);
    inkVideoRef.Stop(this.m_binkVideo);
    inkWidgetRef.UnregisterFromCallback(this.m_musicVideoEp1, n"OnVideoFinished", this, n"OnVideoFinished");
  }

  protected cb func OnSetUserData(data: ref<IScriptable>) -> Bool {
    let creditsData: ref<CreditsData> = data as CreditsData;
    if creditsData.isFinalBoards {
      inkWidgetRef.SetVisible(this.m_sceneTexture, true);
      inkWidgetRef.SetVisible(this.m_binkVideo, false);
    } else {
      inkWidgetRef.SetVisible(this.m_sceneTexture, false);
      inkWidgetRef.SetVisible(this.m_binkVideo, true);
    };
    this.isInFinalBoardsMode = creditsData.isFinalBoards;
    this.shouldShowRewardPrompt = creditsData.showRewardPrompt;
    this.m_isDataSet = true;
  }

  protected cb func OnVideoFinished(target: wref<inkVideo>) -> Bool {
    let isMusicVideo: Bool = Equals(target.GetName(), inkWidgetRef.GetName(this.m_musicVideoEp1));
    if isMusicVideo {
      this.FinishVideo();
    };
  }

  private final func FinishVideo() -> Void {
    if this.isEp1CreditsImplementation {
      inkWidgetRef.SetVisible(this.m_musicVideoEp1, false);
      inkWidgetRef.SetVisible(this.m_fastForward, true);
      this.PlayCredits();
    };
  }

  private final func InitializeCredits() -> Void {
    if this.isEp1CreditsImplementation && this.isInFinalBoardsMode {
      this.m_isCounting = true;
      this.m_accumulatedTime = 0.00;
      this.isPreVideoFinished = false;
      inkWidgetRef.SetVisible(this.exitTooltipContainer, false);
      inkWidgetRef.SetVisible(this.m_fastForward, false);
      inkWidgetRef.SetVisible(this.m_creditsAnimEp1, true);
      inkWidgetRef.SetVisible(this.m_musicVideoEp1, true);
      inkVideoRef.Play(this.m_musicVideoEp1);
      inkWidgetRef.RegisterToCallback(this.m_musicVideoEp1, n"OnVideoFinished", this, n"OnVideoFinished");
    } else {
      this.PlayCredits();
      inkWidgetRef.SetVisible(this.m_creditsAnimEp1, false);
      inkWidgetRef.SetVisible(this.m_musicVideoEp1, false);
      inkVideoRef.Stop(this.m_musicVideoEp1);
    };
  }

  private final func PlayCredits() -> Void {
    if !this.m_isDataSet {
      inkWidgetRef.SetVisible(this.m_sceneTexture, false);
      inkWidgetRef.SetVisible(this.m_binkVideo, true);
    };
    inkVideoRef.Play(this.m_backgroundVideo);
    this.isPreVideoFinished = true;
    inkWidgetRef.SetTranslation(this.m_binkVideo, -400.00, 0.00);
    inkWidgetRef.SetVisible(this.exitTooltipContainer, true);
  }

  private final func PlayNextVideo() -> Void {
    let ratio: Float;
    let videoContainerSize: Vector2;
    if this.m_currentBinkVideo >= ArraySize(this.m_binkVideos) {
      return;
    };
    videoContainerSize = inkWidgetRef.GetSize(this.m_videoContainer);
    inkVideoRef.SetVideoPath(this.m_binkVideo, BinkResource.GetPath(this.m_binkVideos[this.m_currentBinkVideo]));
    if !inkVideoRef.IsPlayingVideo(this.m_binkVideo) {
      inkVideoRef.Play(this.m_binkVideo);
      this.m_videoSummary = inkVideoRef.GetVideoWidgetSummary(this.m_binkVideo);
      ratio = Cast<Float>(this.m_videoSummary.width) / Cast<Float>(this.m_videoSummary.height);
      inkWidgetRef.SetSize(this.m_binkVideo, videoContainerSize.X, videoContainerSize.X / ratio);
    };
    this.m_currentBinkVideo += 1;
  }
}
