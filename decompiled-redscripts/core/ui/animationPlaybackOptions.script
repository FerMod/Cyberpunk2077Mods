
public static func GetAnimOptionsInfiniteLoop(loopType: inkanimLoopType) -> inkAnimOptions {
  let animOptions: inkAnimOptions;
  animOptions.loopType = loopType;
  animOptions.loopInfinite = true;
  return animOptions;
}

public class WidgetAnimationManager extends IScriptable {

  private let m_animations: [SWidgetAnimationData];

  public final func Initialize(const animations: script_ref<[SWidgetAnimationData]>) -> Void {
    this.m_animations = Deref(animations);
  }

  public final const func GetAnimations() -> [SWidgetAnimationData] {
    return this.m_animations;
  }

  public final func UpdateAnimationsList(animName: CName, updateData: ref<PlaybackOptionsUpdateData>) -> Void {
    let animationData: SWidgetAnimationData;
    if !IsDefined(updateData) {
      return;
    };
    if !this.HasAnimation(animName) {
      animationData.m_animationName = animName;
      animationData.m_playbackOptions = updateData.m_playbackOptions;
      ArrayPush(this.m_animations, animationData);
    };
  }

  public final const func HasAnimation(animName: CName) -> Bool {
    let i: Int32 = 0;
    while i < ArraySize(this.m_animations) {
      if Equals(this.m_animations[i].m_animationName, animName) {
        return true;
      };
      i += 1;
    };
    return false;
  }

  public final func CleanAllAnimationsChachedData() -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_animations) {
      if this.m_animations[i].m_animProxy != null {
        this.UnregisterAllCallbacks(this.m_animations[i]);
      };
      i += 1;
    };
  }

  public final func TriggerAnimations(owner: ref<inkLogicController>) -> Void {
    let currentProxy: ref<inkAnimProxy>;
    let i: Int32 = 0;
    while i < ArraySize(this.m_animations) {
      if !IsNameValid(this.m_animations[i].m_animationName) {
      } else {
        if this.m_animations[i].m_animProxy == null || !this.m_animations[i].m_lockWhenActive || this.m_animations[i].m_animProxy.IsFinished() || !this.m_animations[i].m_animProxy.IsPaused() && !this.m_animations[i].m_animProxy.IsPlaying() {
          if this.m_animations[i].m_animProxy != null {
            this.UnregisterAllCallbacks(this.m_animations[i]);
          };
          currentProxy = owner.PlayLibraryAnimation(this.m_animations[i].m_animationName, this.m_animations[i].m_playbackOptions);
          this.m_animations[i].m_animProxy = currentProxy;
          this.RegisterAllCallbacks(owner, this.m_animations[i]);
        };
      };
      i += 1;
    };
  }

  public final func TriggerAnimations(owner: ref<inkGameController>) -> Void {
    let currentProxy: ref<inkAnimProxy>;
    let i: Int32 = 0;
    while i < ArraySize(this.m_animations) {
      if !IsNameValid(this.m_animations[i].m_animationName) {
      } else {
        if this.m_animations[i].m_animProxy == null || !this.m_animations[i].m_lockWhenActive || this.m_animations[i].m_animProxy.IsFinished() || !this.m_animations[i].m_animProxy.IsPaused() && !this.m_animations[i].m_animProxy.IsPlaying() {
          if this.m_animations[i].m_animProxy != null {
            this.UnregisterAllCallbacks(this.m_animations[i]);
          };
          currentProxy = owner.PlayLibraryAnimation(this.m_animations[i].m_animationName, this.m_animations[i].m_playbackOptions);
          this.m_animations[i].m_animProxy = currentProxy;
          this.RegisterAllCallbacks(owner, this.m_animations[i]);
        };
      };
      i += 1;
    };
  }

  public final func TriggerAnimationByName(owner: ref<inkLogicController>, animName: CName, playbackOption: EInkAnimationPlaybackOption, opt targetWidget: ref<inkWidget>, opt playbackOptionsOverrideData: ref<PlaybackOptionsUpdateData>) -> Void {
    let animData: SWidgetAnimationData;
    let currentProxy: ref<inkAnimProxy>;
    let playbackOptionsData: inkAnimOptions;
    let i: Int32 = 0;
    while i < ArraySize(this.m_animations) {
      if !IsNameValid(this.m_animations[i].m_animationName) {
      } else {
        if Equals(this.m_animations[i].m_animationName, animName) {
          if Equals(playbackOption, EInkAnimationPlaybackOption.PLAY) {
            if this.m_animations[i].m_animProxy == null || !this.m_animations[i].m_lockWhenActive || this.m_animations[i].m_animProxy.IsFinished() || !this.m_animations[i].m_animProxy.IsPaused() && !this.m_animations[i].m_animProxy.IsPlaying() {
              if IsDefined(playbackOptionsOverrideData) {
                playbackOptionsData = playbackOptionsOverrideData.m_playbackOptions;
              } else {
                playbackOptionsData = this.m_animations[i].m_playbackOptions;
              };
              if this.m_animations[i].m_animProxy != null {
                this.ResolveActiveAnimDataPlaybackState(this.m_animations[i], EInkAnimationPlaybackOption.STOP);
              };
              if IsDefined(targetWidget) {
                currentProxy = owner.PlayLibraryAnimationOnAutoSelectedTargets(this.m_animations[i].m_animationName, targetWidget, playbackOptionsData);
              } else {
                currentProxy = owner.PlayLibraryAnimation(this.m_animations[i].m_animationName, playbackOptionsData);
              };
              this.m_animations[i].m_animProxy = currentProxy;
              this.RegisterAllCallbacks(owner, this.m_animations[i]);
            };
          } else {
            if this.m_animations[i].m_animProxy != null {
              animData = this.m_animations[i];
              if IsDefined(playbackOptionsOverrideData) {
                animData.m_playbackOptions = playbackOptionsOverrideData.m_playbackOptions;
              };
              this.ResolveActiveAnimDataPlaybackState(animData, playbackOption);
            };
          };
          break;
        };
      };
      i += 1;
    };
  }

  public final func TriggerAnimationByName(owner: ref<inkGameController>, animName: CName, playbackOption: EInkAnimationPlaybackOption, opt targetWidget: ref<inkWidget>, opt playbackOptionsOverrideData: ref<PlaybackOptionsUpdateData>) -> Void {
    let animData: SWidgetAnimationData;
    let currentProxy: ref<inkAnimProxy>;
    let playbackOptionsData: inkAnimOptions;
    let i: Int32 = 0;
    while i < ArraySize(this.m_animations) {
      if !IsNameValid(this.m_animations[i].m_animationName) {
      } else {
        if Equals(this.m_animations[i].m_animationName, animName) {
          if Equals(playbackOption, EInkAnimationPlaybackOption.PLAY) {
            if this.m_animations[i].m_animProxy == null || !this.m_animations[i].m_lockWhenActive || this.m_animations[i].m_animProxy.IsFinished() || !this.m_animations[i].m_animProxy.IsPaused() && !this.m_animations[i].m_animProxy.IsPlaying() {
              if IsDefined(playbackOptionsOverrideData) {
                playbackOptionsData = playbackOptionsOverrideData.m_playbackOptions;
              } else {
                playbackOptionsData = this.m_animations[i].m_playbackOptions;
              };
              if this.m_animations[i].m_animProxy != null {
                this.ResolveActiveAnimDataPlaybackState(this.m_animations[i], EInkAnimationPlaybackOption.STOP);
              };
              if IsDefined(targetWidget) {
                currentProxy = owner.PlayLibraryAnimationOnAutoSelectedTargets(this.m_animations[i].m_animationName, targetWidget, playbackOptionsData);
              } else {
                currentProxy = owner.PlayLibraryAnimation(this.m_animations[i].m_animationName, playbackOptionsData);
              };
              this.m_animations[i].m_animProxy = currentProxy;
              this.RegisterAllCallbacks(owner, this.m_animations[i]);
            };
          } else {
            if this.m_animations[i].m_animProxy != null {
              animData = this.m_animations[i];
              if IsDefined(playbackOptionsOverrideData) {
                animData.m_playbackOptions = playbackOptionsOverrideData.m_playbackOptions;
              };
              this.ResolveActiveAnimDataPlaybackState(animData, playbackOption);
            };
          };
          break;
        };
      };
      i += 1;
    };
  }

  private final func ResolveActiveAnimDataPlaybackState(const animData: script_ref<SWidgetAnimationData>, requestedState: EInkAnimationPlaybackOption) -> Void {
    if Deref(animData).m_animProxy == null {
      return;
    };
    if Equals(requestedState, EInkAnimationPlaybackOption.STOP) {
      Deref(animData).m_animProxy.Stop(false);
      this.UnregisterAllCallbacks(animData);
    } else {
      if Equals(requestedState, EInkAnimationPlaybackOption.PAUSE) {
        Deref(animData).m_animProxy.Pause();
      } else {
        if Equals(requestedState, EInkAnimationPlaybackOption.RESUME) {
          Deref(animData).m_animProxy.Resume();
        } else {
          if Equals(requestedState, EInkAnimationPlaybackOption.CONTINUE) {
            Deref(animData).m_animProxy.Continue(Deref(animData).m_playbackOptions);
          } else {
            if Equals(requestedState, EInkAnimationPlaybackOption.GO_TO_START) {
              Deref(animData).m_animProxy.GotoStartAndStop(false);
              this.UnregisterAllCallbacks(animData);
            } else {
              if Equals(requestedState, EInkAnimationPlaybackOption.GO_TO_END) {
                Deref(animData).m_animProxy.GotoEndAndStop(false);
                this.UnregisterAllCallbacks(animData);
              };
            };
          };
        };
      };
    };
  }

  public final func UnregisterAllCallbacks(const animData: script_ref<SWidgetAnimationData>) -> Void {
    if Deref(animData).m_animProxy != null {
      if IsNameValid(Deref(animData).m_onFinish) {
        Deref(animData).m_animProxy.UnregisterFromAllCallbacks(inkanimEventType.OnFinish);
      };
      if IsNameValid(Deref(animData).m_onStart) {
        Deref(animData).m_animProxy.UnregisterFromAllCallbacks(inkanimEventType.OnStart);
      };
      if IsNameValid(Deref(animData).m_onPasue) {
        Deref(animData).m_animProxy.UnregisterFromAllCallbacks(inkanimEventType.OnPause);
      };
      if IsNameValid(Deref(animData).m_onResume) {
        Deref(animData).m_animProxy.UnregisterFromAllCallbacks(inkanimEventType.OnResume);
      };
      if IsNameValid(Deref(animData).m_onStartLoop) {
        Deref(animData).m_animProxy.UnregisterFromAllCallbacks(inkanimEventType.OnStartLoop);
      };
      if IsNameValid(Deref(animData).m_onEndLoop) {
        Deref(animData).m_animProxy.UnregisterFromAllCallbacks(inkanimEventType.OnEndLoop);
      };
    };
    this.CleanProxyData(animData);
  }

  public final func RegisterAllCallbacks(owner: ref<IScriptable>, const animData: script_ref<SWidgetAnimationData>) -> Void {
    if Deref(animData).m_animProxy != null {
      if IsNameValid(Deref(animData).m_onFinish) {
        Deref(animData).m_animProxy.RegisterToCallback(inkanimEventType.OnFinish, owner, Deref(animData).m_onFinish);
      };
      if IsNameValid(Deref(animData).m_onStart) {
        Deref(animData).m_animProxy.RegisterToCallback(inkanimEventType.OnStart, owner, Deref(animData).m_onStart);
      };
      if IsNameValid(Deref(animData).m_onPasue) {
        Deref(animData).m_animProxy.RegisterToCallback(inkanimEventType.OnPause, owner, Deref(animData).m_onPasue);
      };
      if IsNameValid(Deref(animData).m_onResume) {
        Deref(animData).m_animProxy.RegisterToCallback(inkanimEventType.OnResume, owner, Deref(animData).m_onResume);
      };
      if IsNameValid(Deref(animData).m_onStartLoop) {
        Deref(animData).m_animProxy.RegisterToCallback(inkanimEventType.OnStartLoop, owner, Deref(animData).m_onStartLoop);
      };
      if IsNameValid(Deref(animData).m_onEndLoop) {
        Deref(animData).m_animProxy.RegisterToCallback(inkanimEventType.OnEndLoop, owner, Deref(animData).m_onEndLoop);
      };
    };
  }

  public final func ResolveCallback(owner: ref<IScriptable>, animProxy: ref<inkAnimProxy>, eventType: inkanimEventType) -> Void {
    let i: Int32;
    if animProxy == null {
      return;
    };
    i = 0;
    while i < ArraySize(this.m_animations) {
      if this.m_animations[i].m_animProxy == animProxy {
        if Equals(eventType, inkanimEventType.OnFinish) {
          this.UnregisterAllCallbacks(this.m_animations[i]);
          this.m_animations[i].m_animProxy = null;
        } else {
          animProxy.UnregisterFromCallback(eventType, owner, this.GetAnimationCallbackName(this.m_animations[i], eventType));
        };
      };
      i += 1;
    };
  }

  private final func GetAnimationCallbackName(const animData: script_ref<SWidgetAnimationData>, eventType: inkanimEventType) -> CName {
    let returnValue: CName;
    if Equals(eventType, inkanimEventType.OnStart) {
      Deref(animData).m_onStart;
    } else {
      if Equals(eventType, inkanimEventType.OnFinish) {
        Deref(animData).m_onFinish;
      } else {
        if Equals(eventType, inkanimEventType.OnPause) {
          Deref(animData).m_onPasue;
        } else {
          if Equals(eventType, inkanimEventType.OnResume) {
            Deref(animData).m_onResume;
          } else {
            if Equals(eventType, inkanimEventType.OnStartLoop) {
              Deref(animData).m_onStartLoop;
            } else {
              if Equals(eventType, inkanimEventType.OnEndLoop) {
                Deref(animData).m_onEndLoop;
              };
            };
          };
        };
      };
    };
    return returnValue;
  }

  private final func CleanProxyData(const animData: script_ref<SWidgetAnimationData>) -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_animations) {
      if this.m_animations[i].m_animProxy == Deref(animData).m_animProxy {
        this.m_animations[i].m_animProxy = null;
        break;
      };
      i += 1;
    };
  }
}
