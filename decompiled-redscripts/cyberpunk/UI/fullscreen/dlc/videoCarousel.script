
public class VideoCarouselController extends inkLogicController {

  @runtimeProperty("category", "Video")
  private edit let m_videoTitleRef: inkTextRef;

  @runtimeProperty("category", "Video")
  private edit let m_videoDescriptionRef: inkTextRef;

  @runtimeProperty("category", "Video")
  private edit let m_videoWidgetRef: inkVideoRef;

  @runtimeProperty("category", "Controls")
  private edit let m_switchLeftArrow: inkWidgetRef;

  @runtimeProperty("category", "Controls")
  private edit let m_switchRightArrow: inkWidgetRef;

  @runtimeProperty("category", "Controls")
  private edit const let m_switchDotIndicators: [inkWidgetRef];

  private let m_videoWidget: wref<inkVideo>;

  private let m_videoSwitchLeftArrow: wref<inkButtonController>;

  private let m_videoSwitchRightArrow: wref<inkButtonController>;

  private let m_videos: [VideoCarouselData];

  private let m_currentVideo: Int32;

  @default(VideoCarouselController, false)
  private let m_isPaused: Bool;

  protected cb func OnInitialize() -> Bool {
    this.RegisterToGlobalInputCallback(n"OnPostOnRelease", this, n"OnGlobalRelease");
    this.m_videoSwitchLeftArrow = inkWidgetRef.GetControllerByType(this.m_switchLeftArrow, n"inkButtonController") as inkButtonController;
    this.m_videoSwitchRightArrow = inkWidgetRef.GetControllerByType(this.m_switchRightArrow, n"inkButtonController") as inkButtonController;
    this.m_videoSwitchLeftArrow.RegisterToCallback(n"OnButtonStateChanged", this, n"OnSwitchLeftArrowClicked");
    this.m_videoSwitchRightArrow.RegisterToCallback(n"OnButtonStateChanged", this, n"OnSwitchRightArrowClicked");
    this.m_videoWidget = inkWidgetRef.Get(this.m_videoWidgetRef) as inkVideo;
    this.m_videoWidget.RegisterToCallback(n"OnVideoFinished", this, n"OnVideoFinished");
  }

  protected cb func OnUninitialize() -> Bool {
    this.UnregisterFromGlobalInputCallback(n"OnPostOnRelease", this, n"OnGlobalRelease");
    this.UnregisterFromCallback(n"OnButtonStateChanged", this, n"OnSwitchLeftArrowClicked");
    this.UnregisterFromCallback(n"OnButtonStateChanged", this, n"OnSwitchRightArrowClicked");
    this.m_videoWidget.UnregisterFromCallback(n"OnVideoFinished", this, n"OnVideoFinished");
  }

  private final func OnSwitchLeftArrowClicked(controller: wref<inkButtonController>, oldState: inkEButtonState, newState: inkEButtonState) -> Void {
    if Equals(newState, inkEButtonState.Press) {
      this.PlaySound(n"Button", n"OnPress");
      this.SwapVideo(ECustomFilterDPadNavigationOption.SelectPrev);
    };
  }

  private final func OnSwitchRightArrowClicked(controller: wref<inkButtonController>, oldState: inkEButtonState, newState: inkEButtonState) -> Void {
    if Equals(newState, inkEButtonState.Press) {
      this.PlaySound(n"Button", n"OnPress");
      this.SwapVideo(ECustomFilterDPadNavigationOption.SelectNext);
    };
  }

  protected cb func OnGlobalRelease(evt: ref<inkPointerEvent>) -> Bool {
    if evt.IsAction(n"video_next") {
      this.PlaySound(n"Button", n"OnPress");
      this.SwapVideo(ECustomFilterDPadNavigationOption.SelectNext);
    } else {
      if evt.IsAction(n"video_prior") {
        this.PlaySound(n"Button", n"OnPress");
        this.SwapVideo(ECustomFilterDPadNavigationOption.SelectPrev);
      };
    };
  }

  public final func PopulateVideos(videos: [VideoCarouselData]) -> Void {
    this.m_videos = videos;
    this.m_currentVideo = 0;
    this.SetSwitchDotIndicators(this.m_currentVideo);
    inkTextRef.SetLocalizedText(this.m_videoTitleRef, this.m_videos[this.m_currentVideo].videoTitleKey);
    inkTextRef.SetLocalizedText(this.m_videoDescriptionRef, this.m_videos[this.m_currentVideo].videoDescriptionKey);
    this.m_videoWidget.SetVideoPath(this.m_videos[this.m_currentVideo].videoResPath);
    this.m_videoWidget.SetLoop(false);
    this.m_videoWidget.Play();
  }

  protected cb func OnVideoFinished(target: wref<inkVideo>) -> Bool {
    this.SwapVideo(ECustomFilterDPadNavigationOption.SelectNext);
  }

  private final func SetSwitchDotIndicators(index: Int32) -> Void {
    let arraySize: Int32 = ArraySize(this.m_switchDotIndicators);
    let i: Int32 = 0;
    while i < arraySize {
      inkWidgetRef.SetState(this.m_switchDotIndicators[i], n"Default");
      i += 1;
    };
    inkWidgetRef.SetState(this.m_switchDotIndicators[index], n"Selected");
  }

  private final func SwapVideo(option: ECustomFilterDPadNavigationOption) -> Void {
    this.m_videoWidget.Stop();
    switch option {
      case ECustomFilterDPadNavigationOption.SelectNext:
        this.m_currentVideo = this.m_currentVideo < ArraySize(this.m_videos) - 1 ? this.m_currentVideo + 1 : 0;
        break;
      case ECustomFilterDPadNavigationOption.SelectPrev:
        this.m_currentVideo = this.m_currentVideo > 0 ? this.m_currentVideo - 1 : ArraySize(this.m_videos) - 1;
    };
    this.SetSwitchDotIndicators(this.m_currentVideo);
    inkTextRef.SetLocalizedText(this.m_videoTitleRef, this.m_videos[this.m_currentVideo].videoTitleKey);
    inkTextRef.SetLocalizedText(this.m_videoDescriptionRef, this.m_videos[this.m_currentVideo].videoDescriptionKey);
    this.m_videoWidget.SetVideoPath(this.m_videos[this.m_currentVideo].videoResPath);
    this.m_videoWidget.Play();
  }

  public final func PauseVideo(pause: Bool) -> Void {
    this.m_isPaused = pause;
    if pause {
      this.m_videoWidget.Pause();
    } else {
      if !pause && this.m_videoWidget.IsPaused() {
        this.m_videoWidget.Resume();
      } else {
        if !pause && !this.m_videoWidget.IsPaused() && !this.m_videoWidget.IsPlayingVideo() {
          this.m_videoWidget.Play();
        };
      };
    };
  }
}
