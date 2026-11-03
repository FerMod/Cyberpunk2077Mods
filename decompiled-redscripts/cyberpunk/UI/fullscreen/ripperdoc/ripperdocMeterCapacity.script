
public class RipperdocMetersCapacity extends RipperdocMetersBase {

  @runtimeProperty("category", "Capacity Bars")
  @default(RipperdocMetersCapacity, 1.f)
  private edit let m_defaultRightBarScale: Float;

  @runtimeProperty("category", "Capacity Bars")
  @default(RipperdocMetersCapacity, 9.f)
  private edit let m_overchargeGapSize: Float;

  @runtimeProperty("category", "Capacity Labels")
  private edit let m_curCapacityLabelContainer: inkWidgetRef;

  @runtimeProperty("category", "Capacity Labels")
  private edit let m_curCapacityLabelBackground: inkWidgetRef;

  @runtimeProperty("category", "Capacity Labels")
  private edit let m_costLabelContainer: inkWidgetRef;

  @runtimeProperty("category", "Capacity Labels")
  private edit let m_costLabelText: inkTextRef;

  @runtimeProperty("category", "Capacity Labels")
  private edit let m_maxCapacityLabelContainer: inkWidgetRef;

  @runtimeProperty("category", "Capacity Labels")
  private edit let m_maxCapacityLabelText: inkTextRef;

  @runtimeProperty("category", "Overcharge Box")
  private edit let m_overchargeBox: inkWidgetRef;

  @runtimeProperty("category", "Overcharge Box")
  private edit let m_thresholdLine: inkWidgetRef;

  @runtimeProperty("category", "Overcharge Box")
  private edit let m_edgrunnerLock: inkWidgetRef;

  @runtimeProperty("category", "Overcharge Box")
  private edit let m_overchargeGlow: inkWidgetRef;

  @runtimeProperty("category", "Overcharge Box")
  @default(RipperdocMetersCapacity, overchargeGlow_pulse)
  private edit let m_overchargeGlowAnimName: CName;

  @runtimeProperty("category", "Overcharge Box")
  @runtimeProperty("tooltip", "Percent value of Max Possible Capacity below which Overcharge Box won't be Visible")
  @default(RipperdocMetersCapacity, 0.20f)
  private edit let m_overchargeVisibilityThreshold: Float;

  private let m_currentCapacity: Int32;

  private let m_maxCapacity: Int32;

  private let m_maxCapacityPossible: Float;

  private let m_overchargeMaxCapacity: Int32;

  @default(RipperdocMetersCapacity, 50)
  private let m_overchargeValue: Int32;

  private let m_isEdgerunner: Bool;

  private let m_curCapacityLabel: wref<RipperdocFillLabel>;

  private let m_capacityLabelAnimation: ref<inkAnimProxy>;

  private let m_costLabelAnimation: ref<inkAnimProxy>;

  private let m_capacityPulseAnimation: ref<PulseAnimation>;

  private let m_costLabelPulseAnimation: ref<PulseAnimation>;

  private let m_overchargeGlowAnimProxy: ref<inkAnimProxy>;

  private let m_overchargeGlowAnimOptions: inkAnimOptions;

  private let m_overchargeBoxState: CName;

  private let m_maxBaseBar: Int32;

  private let m_overBars: Int32;

  @default(RipperdocMetersCapacity, false)
  private let m_barsSpawned: Bool;

  private let m_showOverchargeBox: Bool;

  private let m_isHoverdCyberwareEquipped: Bool;

  private let C_costLabelAnchorPoint_ADD: Vector2;

  private let C_costLabelAnchorPoint_SUBTRACT: Vector2;

  private let C_costLabelAnchorPoint_EQUIPPED: Vector2;

  private let C_costLabelAnchorPoint_EQUIPPED_EDGRUNNER: Vector2;

  protected cb func OnInitialize() -> Bool {
    let size: Vector2;
    this.C_costLabelAnchorPoint_EQUIPPED = new Vector2(4.30, -0.20);
    this.C_costLabelAnchorPoint_EQUIPPED_EDGRUNNER = new Vector2(4.50, -0.20);
    this.C_costLabelAnchorPoint_ADD = inkWidgetRef.GetAnchorPoint(this.m_costLabelContainer);
    this.C_costLabelAnchorPoint_SUBTRACT = new Vector2(0.00, -1.25);
    this.m_capacityPulseAnimation = new PulseAnimation();
    this.m_costLabelPulseAnimation = new PulseAnimation();
    this.m_tooltipData = new RipperdocBarTooltipTooltipData();
    this.m_tooltipData.barType = BarType.CurrentCapacity;
    this.m_curCapacityLabel = inkWidgetRef.GetController(this.m_curCapacityLabelContainer) as RipperdocFillLabel;
    this.m_overchargeGlowAnimOptions.loopType = inkanimLoopType.Cycle;
    this.m_overchargeGlowAnimOptions.loopInfinite = true;
    this.m_overchargeGlowAnimOptions.dependsOnTimeDilation = false;
    ArrayPush(this.m_barGaps, 10);
    ArrayPush(this.m_barGaps, 20);
    ArrayPush(this.m_barGaps, 30);
    ArrayPush(this.m_barGaps, 40);
    inkWidgetRef.SetVisible(this.m_maxCapacityLabelContainer, false);
    inkWidgetRef.SetVisible(this.m_overchargeBox, false);
    inkWidgetRef.SetVisible(this.m_thresholdLine, false);
    inkWidgetRef.SetVisible(this.m_costLabelContainer, false);
    inkWidgetRef.SetVisible(this.m_curCapacityLabelContainer, false);
    this.SetupBarIntroAnimation();
    this.SetupPulseAnimParams(this.m_pulseAnimtopOpacity, this.m_pulseAnimbottomOpacity, this.m_pulseAnimpulseRate, this.m_pulseAnimdelay);
    inkWidgetRef.RegisterToCallback(this.m_hoverArea, n"OnEnter", this, n"OnBarHoverOver");
    inkWidgetRef.RegisterToCallback(this.m_hoverArea, n"OnLeave", this, n"OnBarHoverOut");
    inkWidgetRef.RegisterToCallback(this.m_overchargeBox, n"OnEnter", this, n"OnOverchargeHoverOver");
    inkWidgetRef.RegisterToCallback(this.m_overchargeBox, n"OnLeave", this, n"OnOverchargeHoverOut");
    size = this.GetRootWidget().GetSize();
    this.m_curCapacityLabel.Configure(size.Y);
    inkWidgetRef.SetState(this.m_costLabelContainer, n"Default");
  }

  protected cb func OnUninitialize() -> Bool {
    inkWidgetRef.UnregisterFromCallback(this.m_hoverArea, n"OnEnter", this, n"OnBarHoverOver");
    inkWidgetRef.UnregisterFromCallback(this.m_hoverArea, n"OnLeave", this, n"OnBarHoverOut");
    inkWidgetRef.UnregisterFromCallback(this.m_overchargeBox, n"OnEnter", this, n"OnOverchargeHoverOver");
    inkWidgetRef.UnregisterFromCallback(this.m_overchargeBox, n"OnLeave", this, n"OnOverchargeHoverOut");
  }

  protected cb func OnOverchargeHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    this.m_tooltipData.barType = BarType.Edgerunner;
    this.m_overchargeBoxState = inkWidgetRef.GetState(this.m_overchargeBox);
    inkWidgetRef.SetState(this.m_overchargeBox, n"Hover");
    this.OnBarHoverOver(evt);
  }

  protected cb func OnOverchargeHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    this.m_tooltipData.barType = BarType.CurrentCapacity;
    inkWidgetRef.SetState(this.m_overchargeBox, this.m_overchargeBoxState);
    this.OnBarHoverOut(evt);
  }

  private final func SpawnBars() -> Void {
    let i: Int32 = 0;
    while i < this.BAR_COUNT {
      this.AsyncSpawnFromLocal(inkWidgetRef.Get(this.m_barAnchor), this.m_barWidgetLibraryName, this, n"OnBarSpawned", null);
      i += 1;
    };
  }

  protected cb func OnBarSpawned(widget: ref<inkWidget>, data: ref<IScriptable>) -> Bool {
    let g: Int32;
    let controller: ref<RipperdocNewMeterBar> = widget.GetController() as RipperdocNewMeterBar;
    ArrayPush(this.m_bars, controller);
    g = 0;
    while g < ArraySize(this.m_barGaps) {
      if ArraySize(this.m_bars) == this.m_barGaps[g] {
        controller.GetRootWidget().UpdateMargin(0.00, this.m_barGapSize, 0.00, 0.00);
      };
      g += 1;
    };
    this.m_barIntroAnimProxy = widget.PlayAnimation(this.m_barIntroAnimDef);
    if ArraySize(this.m_bars) == this.BAR_COUNT {
      this.m_barIntroAnimProxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnLastBarIntroFinished");
    };
  }

  protected cb func OnLastBarIntroFinished(animProxy: ref<inkAnimProxy>) -> Bool {
    inkWidgetRef.SetVisible(this.m_maxCapacityLabelContainer, true);
    inkWidgetRef.SetVisible(this.m_overchargeBox, true);
    if this.m_isEdgerunner {
      this.SetMaxZone(this.m_thresholdLine, this.m_maxCapacityLabelContainer);
      inkWidgetRef.SetState(this.m_overchargeGlow, n"Available");
      inkWidgetRef.SetVisible(this.m_overchargeGlow, true);
    } else {
      this.SetMaxZone(this.m_maxCapacityLabelContainer, this.m_thresholdLine);
      inkWidgetRef.SetState(this.m_overchargeGlow, n"Default");
      inkWidgetRef.SetVisible(this.m_overchargeGlow, false);
    };
    this.m_barsSpawned = true;
    this.ConfigureBar(this.m_currentCapacity, 0, this.m_maxCapacity, this.m_overchargeMaxCapacity, true);
    inkWidgetRef.SetVisible(this.m_curCapacityLabelContainer, true);
    this.m_barIntroAnimProxy.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnLastBarIntroFinished");
  }

  private final func ConfigureBar(curEquippedCapacity: Int32, newEquippedCapacity: Int32, maxCapacity: Int32, overclockCapacity: Int32, isChange: Bool) -> Void {
    let delay: Float;
    let i: Int32;
    let isSafe: Bool;
    let sizeOffset: Float;
    let state: CName;
    let percent: Float = Cast<Float>(curEquippedCapacity) / this.m_maxCapacityPossible;
    let newPercent: Float = Cast<Float>(newEquippedCapacity + curEquippedCapacity) / this.m_maxCapacityPossible;
    let equipBars: Int32 = Min(RoundMath(Cast<Float>(this.BAR_COUNT) * newPercent), this.BAR_COUNT);
    let currentBars: Int32 = Min(RoundMath(Cast<Float>(this.BAR_COUNT) * percent), this.BAR_COUNT);
    let newBars: Int32 = equipBars - currentBars;
    let baseBars: Int32 = currentBars - this.BAR_SLOPE_COUNT;
    inkWidgetRef.SetOpacity(this.m_maxCapacityLabelContainer, 1.00);
    if newEquippedCapacity > 0 {
      inkWidgetRef.SetAnchorPoint(this.m_costLabelContainer, this.C_costLabelAnchorPoint_ADD);
      inkWidgetRef.SetVisible(this.m_costLabelContainer, true);
      inkTextRef.SetText(this.m_costLabelText, "+" + IntToString(Abs(newEquippedCapacity)));
      this.StartPulse(this.m_costLabelPulseAnimation, this.m_pulseAnimationParams, inkWidgetRef.Get(this.m_costLabelContainer));
      this.StopPulse(this.m_capacityPulseAnimation);
    } else {
      if this.m_isHoverdCyberwareEquipped && newEquippedCapacity != 0 {
        inkWidgetRef.SetAnchorPoint(this.m_costLabelContainer, currentBars > this.m_maxBaseBar ? this.C_costLabelAnchorPoint_EQUIPPED_EDGRUNNER : this.C_costLabelAnchorPoint_EQUIPPED);
        inkWidgetRef.SetVisible(this.m_costLabelContainer, true);
        this.m_curCapacityLabel.AnimateLabel(curEquippedCapacity, 0.20);
        inkTextRef.SetText(this.m_costLabelText, IntToString(Abs(newEquippedCapacity)));
        inkWidgetRef.SetOpacity(this.m_maxCapacityLabelContainer, 0.20);
        this.StartPulse(this.m_costLabelPulseAnimation, this.m_pulseAnimationParams, inkWidgetRef.Get(this.m_costLabelContainer));
        this.StopPulse(this.m_capacityPulseAnimation);
      } else {
        if newEquippedCapacity < 0 {
          inkWidgetRef.SetAnchorPoint(this.m_costLabelContainer, this.C_costLabelAnchorPoint_SUBTRACT);
          inkWidgetRef.SetVisible(this.m_costLabelContainer, true);
          inkTextRef.SetText(this.m_costLabelText, "-" + IntToString(Abs(newEquippedCapacity)));
          this.StartPulse(this.m_costLabelPulseAnimation, this.m_pulseAnimationParams, inkWidgetRef.Get(this.m_costLabelContainer));
          this.StopPulse(this.m_capacityPulseAnimation);
        } else {
          inkWidgetRef.SetVisible(this.m_costLabelContainer, false);
          this.m_curCapacityLabel.AnimateLabel(curEquippedCapacity, 0.20);
          this.StopPulse(this.m_costLabelPulseAnimation);
        };
      };
    };
    inkTextRef.SetText(this.m_maxCapacityLabelText, IntToString(overclockCapacity));
    delay = this.BAR_DELAY_OFFSET * Cast<Float>(equipBars - 1);
    if inkWidgetRef.IsVisible(this.m_overchargeGlow) {
      if this.m_isHoverdCyberwareEquipped {
        this.m_overchargeGlowAnimProxy.GotoStartAndStop();
      } else {
        if equipBars <= this.m_maxBaseBar {
          this.m_overchargeGlowAnimProxy.GotoStartAndStop();
          inkWidgetRef.SetState(this.m_overchargeGlow, n"Available");
          inkWidgetRef.SetVisible(this.m_thresholdLine, newBars >= 0 && currentBars != this.m_maxBaseBar && this.m_showOverchargeBox);
        } else {
          inkWidgetRef.SetState(this.m_overchargeGlow, n"Used");
          if !this.m_overchargeGlowAnimProxy.IsPlaying() {
            this.m_overchargeGlowAnimProxy = this.PlayLibraryAnimation(this.m_overchargeGlowAnimName, this.m_overchargeGlowAnimOptions);
          };
          inkWidgetRef.SetVisible(this.m_thresholdLine, false);
        };
      };
    } else {
      inkWidgetRef.SetVisible(this.m_thresholdLine, this.m_showOverchargeBox);
    };
    i = 0;
    while i < this.BAR_COUNT {
      if i == 0 && equipBars == 0 && newBars == 0 {
        state = n"Safe_Default";
      } else {
        isSafe = i < this.m_maxBaseBar || i >= this.m_maxBaseBar + this.m_overBars;
        state = this.GetState(isSafe, this.m_isEdgerunner, i, currentBars, newBars);
      };
      if Equals(state, n"Safe_Add") || Equals(state, n"Safe_Remove") || Equals(state, n"Unsafe_Add") || Equals(state, n"Unsafe_Remove") {
        this.m_bars[i].StartPulse(this.m_pulseAnimationParams);
      } else {
        this.m_bars[i].StopPulse();
      };
      this.m_bars[i].SetState(state);
      sizeOffset = 0.00;
      if newBars > 0 && i >= currentBars && i < equipBars || newBars >= 0 && equipBars == 0 && i == 0 {
        sizeOffset = this.GetSlopeAnimOffset(this.BAR_SLOPE_COUNT, 1);
      } else {
        if i > baseBars && i < currentBars {
          sizeOffset = this.GetSlopeAnimOffset(i, baseBars);
        };
      };
      if sizeOffset > 0.00 {
        this.m_bars[i].SetSizeAnimation(1.50, sizeOffset, delay, this.BAR_ANIM_DURATION);
      } else {
        if i < currentBars {
          this.m_bars[i].SetSizeAnimation(this.m_defaultRightBarScale, 0.00, delay, this.BAR_ANIM_DURATION);
        } else {
          this.m_bars[i].SetSizeAnimation(this.m_defaultRightBarScale, 0.00, 0.00, this.BAR_ANIM_DURATION);
        };
      };
      if i + 1 < currentBars + Abs(newBars) {
        delay -= this.BAR_DELAY_OFFSET;
      } else {
        if i + 1 > currentBars + Abs(newBars) {
          delay += this.BAR_DELAY_OFFSET;
        };
      };
      if i == currentBars - 1 || currentBars == 0 && i == 0 {
        this.MoveLabelToBar(this.m_curCapacityLabelContainer, this.m_bars[i], this.m_capacityLabelAnimation, true, false);
        if Equals(state, n"Safe_Default") || Equals(state, n"Unsafe_Default") || Equals(state, n"Safe_Remove") || Equals(state, n"Unsafe_Remove") {
          inkWidgetRef.SetState(this.m_curCapacityLabelContainer, state);
        };
      };
      if i == currentBars {
        if curEquippedCapacity + newEquippedCapacity > overclockCapacity {
          inkWidgetRef.SetState(this.m_costLabelContainer, n"Unsafe_Add");
        } else {
          if newEquippedCapacity > 0 {
            inkWidgetRef.SetState(this.m_costLabelContainer, n"Safe_Add");
          } else {
            if this.m_isHoverdCyberwareEquipped {
              inkWidgetRef.SetState(this.m_costLabelContainer, n"Hovering_Equipped_Cyberware");
            } else {
              inkWidgetRef.SetState(this.m_costLabelContainer, n"Default");
            };
          };
        };
        if i == 0 {
          this.MoveLabelToBar(this.m_costLabelContainer, this.m_bars[i + 1], this.m_costLabelAnimation, false, false);
        } else {
          this.MoveLabelToBar(this.m_costLabelContainer, this.m_bars[i], this.m_costLabelAnimation, false, false);
        };
      };
      i += 1;
    };
  }

  private final func GetState(isSafe: Bool, isEdgerunner: Bool, cur: Int32, start: Int32, dif: Int32) -> CName {
    let result: CName;
    let state: CName;
    if !isSafe && !isEdgerunner && this.m_showOverchargeBox {
      state = n"Unsafe_Locked";
      return state;
    };
    if isSafe || !this.m_showOverchargeBox {
      state = n"Default";
    } else {
      state = n"Unsafe_Unlocekd";
    };
    result = isSafe ? n"Safe_" : n"Unsafe_";
    if dif >= 0 {
      if cur < start {
        state = result + n"Default";
      } else {
        if cur >= start && cur < start + dif {
          state = result + n"Add";
        };
      };
    } else {
      if dif < 0 {
        if cur < start + dif {
          state = result + n"Default";
        } else {
          if cur >= start + dif && cur < start {
            state = result + n"Remove";
          };
        };
      };
    };
    return state;
  }

  private final func SetCapacity(cur: Int32, max: Int32, over: Int32, maxPossible: Float) -> Void {
    this.m_currentCapacity = cur;
    this.m_maxCapacity = max;
    this.m_overchargeMaxCapacity = max + over;
    if max > RoundMath(maxPossible) {
      this.m_maxCapacityPossible = Cast<Float>(max + this.m_overchargeValue);
    } else {
      this.m_maxCapacityPossible = MaxF(maxPossible, Cast<Float>(this.m_overchargeMaxCapacity));
    };
    this.m_maxBaseBar = RoundMath(Cast<Float>(this.BAR_COUNT) * Cast<Float>(this.m_maxCapacity) / this.m_maxCapacityPossible);
    this.m_overBars = RoundMath(Cast<Float>(this.BAR_COUNT) * Cast<Float>(this.m_overchargeValue) / this.m_maxCapacityPossible);
    this.m_showOverchargeBox = Cast<Float>(this.m_maxCapacity) >= this.m_maxCapacityPossible * this.m_overchargeVisibilityThreshold;
  }

  private final func SetMaxZone(downLine: inkWidgetRef, upperLine: inkWidgetRef) -> Void {
    let boxMargin: inkMargin;
    let g: Int32;
    let oldDownMargin: inkMargin;
    let oldUpperMargin: inkMargin;
    let verticalDelta: Float;
    let upperBarIndex: Int32 = Min(this.m_maxBaseBar + this.m_overBars, this.BAR_COUNT);
    let downBarIndex: Int32 = Min(this.m_maxBaseBar, this.BAR_COUNT - 1);
    let upperOffset: Float = Cast<Float>(this.BAR_COUNT - upperBarIndex) * (this.m_barsHeigh + this.m_barsMargin);
    let downOffset: Float = Cast<Float>(this.BAR_COUNT - downBarIndex) * (this.m_barsHeigh + this.m_barsMargin);
    upperOffset -= this.m_barsMargin;
    downOffset -= this.m_barsMargin;
    g = 0;
    while g < ArraySize(this.m_barGaps) {
      if this.m_barGaps[g] >= upperBarIndex {
        upperOffset += this.m_barGapSize;
      };
      if this.m_barGaps[g] >= downBarIndex {
        downOffset += this.m_barGapSize;
      };
      g += 1;
    };
    oldUpperMargin = inkWidgetRef.GetMargin(upperLine);
    oldDownMargin = inkWidgetRef.GetMargin(downLine);
    inkWidgetRef.SetMargin(upperLine, oldUpperMargin.left, upperOffset, oldUpperMargin.right, oldUpperMargin.bottom);
    inkWidgetRef.SetMargin(downLine, oldDownMargin.left, downOffset, oldDownMargin.right, oldDownMargin.bottom);
    verticalDelta = downOffset - upperOffset;
    boxMargin = inkWidgetRef.GetMargin(this.m_overchargeBox);
    inkWidgetRef.SetMargin(this.m_overchargeBox, boxMargin.left, upperOffset, boxMargin.right, boxMargin.bottom);
    inkWidgetRef.SetHeight(this.m_overchargeBox, verticalDelta);
    if !this.m_showOverchargeBox && !this.m_isEdgerunner {
      inkWidgetRef.SetVisible(this.m_thresholdLine, false);
      inkWidgetRef.SetVisible(this.m_overchargeBox, false);
      inkWidgetRef.SetVisible(this.m_overchargeGlow, false);
    };
  }

  protected cb func OnIntroAnimationFinished_METER(proxy: ref<inkAnimProxy>) -> Bool {
    proxy.UnregisterFromCallback(inkanimEventType.OnStart, this, n"OnIntroAnimationFinished_METER");
    proxy = this.PlayLibraryAnimation(n"meter_intro_LEFT");
    proxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnMeterIntroFinished_LEFT");
  }

  protected cb func OnMeterIntroFinished_LEFT(proxy: ref<inkAnimProxy>) -> Bool {
    this.QueueEvent(new CapacityBarFinalizedEvent());
    proxy.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnMeterIntroFinished_LEFT");
  }

  protected cb func OnApply(evt: ref<RipperdocMeterCapacityApplyEvent>) -> Bool {
    this.SetCapacity(evt.CurrentCapacity, evt.MaxCapacity, evt.OverchargeCapacity, evt.MaxCapacityPossible);
    if !this.m_barsSpawned {
      this.SpawnBars();
    } else {
      this.ConfigureBar(this.m_currentCapacity, 0, this.m_maxCapacity, this.m_overchargeMaxCapacity, evt.IsPurchase);
    };
    if this.m_isEdgerunner {
      this.SetMaxZone(this.m_thresholdLine, this.m_maxCapacityLabelContainer);
    } else {
      this.SetMaxZone(this.m_maxCapacityLabelContainer, this.m_thresholdLine);
    };
    this.m_tooltipData.totalValue = evt.CurrentCapacity;
    this.m_tooltipData.maxValue = evt.MaxCapacity;
  }

  protected cb func OnEdgrunnerPerkEvent(evt: ref<EdgrunnerPerkEvent>) -> Bool {
    inkWidgetRef.SetVisible(this.m_edgrunnerLock, !evt.isPurchased);
    this.m_isEdgerunner = evt.isPurchased;
  }

  protected cb func OnHover(evt: ref<RipperdocMeterCapacityHoverEvent>) -> Bool {
    if evt.IsHover {
      this.m_isHoverdCyberwareEquipped = evt.isCyberwareEquipped;
      this.ConfigureBar(this.m_currentCapacity, evt.CapacityChange, this.m_maxCapacity, this.m_overchargeMaxCapacity, true);
    } else {
      this.m_isHoverdCyberwareEquipped = false;
      this.ConfigureBar(this.m_currentCapacity, 0, this.m_maxCapacity, this.m_overchargeMaxCapacity, true);
    };
  }

  protected cb func OnRipperdocMeterCapacityBarHoverEvent(evt: ref<RipperdocMeterCapacityBarHoverEvent>) -> Bool {
    this.OnBarHoverOver(new inkPointerEvent());
  }
}
