
public class RipperdocMetersArmor extends RipperdocMetersBase {

  @runtimeProperty("category", "Armor Bars")
  @default(RipperdocMetersArmor, 2.5f)
  private edit let m_barScale: Float;

  @runtimeProperty("category", "Armor Labels")
  private edit let m_currentArmorLabelContainer: inkWidgetRef;

  @runtimeProperty("category", "Armor Labels")
  private edit let m_currentArmorLabelBackground: inkWidgetRef;

  @runtimeProperty("category", "Armor Labels")
  private edit let m_costArmorLabelContainer: inkWidgetRef;

  @runtimeProperty("category", "Armor Labels")
  private edit let m_costArmorLabelBackground: inkWidgetRef;

  @runtimeProperty("category", "Armor Labels")
  private edit let m_costArmorLabelValue: inkTextRef;

  @runtimeProperty("category", "Armor Labels")
  private edit let m_maxArmorLabel: inkWidgetRef;

  @runtimeProperty("category", "Armor Labels")
  private edit let m_maxArmorLabelContainer: inkWidgetRef;

  @runtimeProperty("category", "Armor Labels")
  private edit let m_maxArmorLabelValue: inkTextRef;

  private let m_maxArmor: Float;

  private let m_curEquippedArmor: Float;

  private let m_newEquippedArmor: Float;

  private let m_maxArmorPossible: Float;

  private let m_maxDamageReduction: Float;

  private let m_currentArmorLabel: wref<RipperdocFillLabel>;

  private let m_currentArmorLabelAnimation: ref<inkAnimProxy>;

  private let m_costArmorLabelAnimation: ref<inkAnimProxy>;

  private let m_currentArmorLabelPulseAnimation: ref<PulseAnimation>;

  private let m_costArmorLabelPulseAnimation: ref<PulseAnimation>;

  private let m_maxBaseBar: Int32;

  private let m_currentBars: Int32;

  @default(RipperdocMetersArmor, false)
  private let m_barsSpawned: Bool;

  private let C_costLabelAnchorPoint_ADD: Vector2;

  private let C_costLabelAnchorPoint_SUBTRACT: Vector2;

  private let C_costLabelAnchorPoint_EQUIPPED: Vector2;

  protected cb func OnInitialize() -> Bool {
    let size: Vector2;
    this.C_costLabelAnchorPoint_EQUIPPED = new Vector2(-2.20, -0.20);
    this.C_costLabelAnchorPoint_ADD = inkWidgetRef.GetAnchorPoint(this.m_costArmorLabelContainer);
    this.C_costLabelAnchorPoint_SUBTRACT = new Vector2(1.00, -1.30);
    this.m_currentArmorLabelPulseAnimation = new PulseAnimation();
    this.m_costArmorLabelPulseAnimation = new PulseAnimation();
    this.m_tooltipData = new RipperdocBarTooltipTooltipData();
    this.m_tooltipData.barType = BarType.Armor;
    ArrayPush(this.m_barGaps, 10);
    ArrayPush(this.m_barGaps, 20);
    ArrayPush(this.m_barGaps, 30);
    ArrayPush(this.m_barGaps, 40);
    this.m_currentArmorLabel = inkWidgetRef.GetController(this.m_currentArmorLabelContainer) as RipperdocFillLabel;
    inkWidgetRef.SetVisible(this.m_costArmorLabelContainer, false);
    inkWidgetRef.SetVisible(this.m_maxArmorLabelContainer, false);
    inkWidgetRef.SetVisible(this.m_maxArmorLabel, false);
    inkWidgetRef.SetVisible(this.m_currentArmorLabelContainer, false);
    this.SetupBarIntroAnimation();
    this.SetupPulseAnimParams(this.m_pulseAnimtopOpacity, this.m_pulseAnimbottomOpacity, this.m_pulseAnimpulseRate, this.m_pulseAnimdelay);
    inkWidgetRef.RegisterToCallback(this.m_hoverArea, n"OnHoverOver", this, n"OnBarHoverOver");
    inkWidgetRef.RegisterToCallback(this.m_hoverArea, n"OnHoverOut", this, n"OnBarHoverOut");
    size = this.GetRootWidget().GetSize();
    this.m_currentArmorLabel.Configure(size.Y);
    inkWidgetRef.SetState(this.m_currentArmorLabelContainer, n"Armor_Mid");
  }

  protected cb func OnUninitialize() -> Bool {
    inkWidgetRef.UnregisterFromCallback(this.m_hoverArea, n"OnHoverOver", this, n"OnBarHoverOver");
    inkWidgetRef.UnregisterFromCallback(this.m_hoverArea, n"OnHoverOut", this, n"OnBarHoverOut");
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
    this.SetArmor();
    this.SetMaxBar();
    inkWidgetRef.SetVisible(this.m_currentArmorLabelContainer, true);
    this.m_barIntroAnimProxy.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnLastBarIntroFinished");
    this.m_barsSpawned = true;
  }

  private final func SetArmor() -> Void {
    let delay: Float;
    let i: Int32;
    let sizeOffset: Float;
    let percent: Float = this.m_newEquippedArmor / this.m_maxArmorPossible;
    let equipBars: Int32 = Min(RoundMath(Cast<Float>(this.BAR_COUNT) * percent), this.BAR_COUNT);
    let baseBars: Int32 = equipBars - this.BAR_SLOPE_COUNT;
    this.m_currentArmorLabel.AnimateLabel(RoundMath(this.m_newEquippedArmor), 0.20);
    delay = this.BAR_DELAY_OFFSET * Cast<Float>(equipBars - 1);
    i = 0;
    while i < this.BAR_COUNT {
      this.m_bars[i].StopPulse();
      if i < equipBars {
        this.m_bars[i].SetState(n"Armor_Mid");
      } else {
        this.m_bars[i].SetState(n"Default");
      };
      sizeOffset = 0.00;
      if i > baseBars && i < equipBars {
        sizeOffset = this.GetSlopeAnimOffset(i, baseBars);
      };
      if sizeOffset > 0.00 {
        this.m_bars[i].SetSizeAnimation(this.m_barScale + 0.50, sizeOffset, delay, this.BAR_ANIM_DURATION);
      } else {
        this.m_bars[i].SetSizeAnimation(this.m_barScale, 0.00, 0.00, this.BAR_ANIM_DURATION);
      };
      if i + 1 < equipBars {
        delay -= this.BAR_DELAY_OFFSET;
      } else {
        if i + 1 > equipBars {
          delay += this.BAR_DELAY_OFFSET;
        };
      };
      if i + 1 == equipBars {
        this.MoveLabelToBar(this.m_costArmorLabelContainer, this.m_bars[i], this.m_costArmorLabelAnimation, false, false);
        this.MoveLabelToBar(this.m_currentArmorLabelContainer, this.m_bars[i], this.m_currentArmorLabelAnimation, true, false);
      };
      i += 1;
    };
    this.m_currentBars = equipBars;
    this.m_curEquippedArmor = this.m_newEquippedArmor;
    this.m_tooltipData.totalValue = RoundMath(this.m_newEquippedArmor);
    this.m_tooltipData.maxValue = RoundMath(this.m_maxArmor);
    this.m_tooltipData.maxDamageReduction = RoundTo(this.m_maxDamageReduction * 100.00, 0);
    inkTextRef.SetText(this.m_maxArmorLabelValue, IntToString(RoundMath(this.m_maxArmor)));
    inkWidgetRef.SetVisible(this.m_costArmorLabelContainer, false);
    this.StopPulse(this.m_currentArmorLabelPulseAnimation);
    this.StopPulse(this.m_costArmorLabelPulseAnimation);
  }

  private final func SetArmorData(newEquippedArmor: Float, maxCurrentArmor: Float, maxArmorPossible: Float, maxDamageReduction: Float) -> Void {
    this.m_maxArmor = maxCurrentArmor;
    this.m_newEquippedArmor = newEquippedArmor;
    if this.m_curEquippedArmor == 0.00 {
      this.m_curEquippedArmor = this.m_newEquippedArmor;
    };
    this.m_maxArmorPossible = maxArmorPossible;
    this.m_maxDamageReduction = maxDamageReduction;
    this.m_maxBaseBar = RoundMath(Cast<Float>(this.BAR_COUNT) * this.m_maxArmor / this.m_maxArmorPossible);
  }

  private final func SetMaxBar() -> Void {
    let g: Int32;
    let oldMargin: inkMargin;
    let i: Int32 = this.m_maxBaseBar;
    let offset: Float = Cast<Float>(this.BAR_COUNT - i) * (this.m_barsHeigh + this.m_barsMargin);
    offset -= this.m_barsMargin;
    g = 0;
    while g < ArraySize(this.m_barGaps) {
      if this.m_barGaps[g] >= i {
        offset += this.m_barGapSize;
      };
      g += 1;
    };
    oldMargin = inkWidgetRef.GetMargin(this.m_maxArmorLabelContainer);
    inkWidgetRef.SetMargin(this.m_maxArmorLabelContainer, oldMargin.left, offset, oldMargin.right, oldMargin.bottom);
    inkWidgetRef.SetVisible(this.m_maxArmorLabelContainer, true);
  }

  private final func PreviewChange(change: Float, isHover: Bool, isCyberwareEquipped: Bool) -> Void {
    let i: Int32;
    let index: Int32;
    let sizeOffset: Float;
    let state: CName;
    let updateRange: Int32;
    let newBars: Int32 = RoundMath(change / this.m_maxArmorPossible * Cast<Float>(this.BAR_COUNT));
    let equipBars: Int32 = Min(this.m_currentBars + newBars, this.BAR_COUNT);
    let armorChange: Int32 = RoundMath(change);
    let currentArmor: Int32 = RoundMath(this.m_curEquippedArmor);
    let baseBars: Int32 = Min(this.m_currentBars - this.BAR_SLOPE_COUNT, this.BAR_COUNT - this.BAR_SLOPE_COUNT);
    let delay: Float = this.BAR_DELAY_OFFSET * Cast<Float>(this.BAR_SLOPE_COUNT);
    inkWidgetRef.SetState(this.m_costArmorLabelValue, n"Default");
    if !isHover || armorChange == 0 {
      inkWidgetRef.SetVisible(this.m_costArmorLabelContainer, false);
      this.m_currentArmorLabel.AnimateLabel(Abs(currentArmor), 0.20);
      this.StopPulse(this.m_currentArmorLabelPulseAnimation);
      this.StopPulse(this.m_costArmorLabelPulseAnimation);
    } else {
      if armorChange > 0 {
        inkWidgetRef.SetVisible(this.m_costArmorLabelContainer, true);
        inkWidgetRef.SetAnchorPoint(this.m_costArmorLabelContainer, this.C_costLabelAnchorPoint_ADD);
        inkWidgetRef.SetState(this.m_costArmorLabelContainer, n"Safe_Add");
        this.m_currentArmorLabel.AnimateLabel(Abs(currentArmor), 0.20);
        inkTextRef.SetText(this.m_costArmorLabelValue, "+" + IntToString(armorChange));
        this.StartPulse(this.m_costArmorLabelPulseAnimation, this.m_pulseAnimationParams, inkWidgetRef.Get(this.m_costArmorLabelContainer));
        this.StopPulse(this.m_currentArmorLabelPulseAnimation);
      } else {
        if isCyberwareEquipped {
          inkWidgetRef.SetVisible(this.m_costArmorLabelContainer, true);
          inkWidgetRef.SetAnchorPoint(this.m_costArmorLabelContainer, this.C_costLabelAnchorPoint_EQUIPPED);
          inkWidgetRef.SetState(this.m_costArmorLabelContainer, n"Hovering_Equipped_Cyberware");
          this.m_currentArmorLabel.AnimateLabel(Abs(currentArmor), 0.20);
          inkTextRef.SetText(this.m_costArmorLabelValue, IntToString(Abs(armorChange)));
          this.StartPulse(this.m_costArmorLabelPulseAnimation, this.m_pulseAnimationParams, inkWidgetRef.Get(this.m_costArmorLabelContainer));
          this.StopPulse(this.m_currentArmorLabelPulseAnimation);
        } else {
          if armorChange < 0 {
            inkWidgetRef.SetVisible(this.m_costArmorLabelContainer, true);
            inkWidgetRef.SetAnchorPoint(this.m_costArmorLabelContainer, this.C_costLabelAnchorPoint_SUBTRACT);
            inkWidgetRef.SetState(this.m_costArmorLabelContainer, n"Default");
            this.m_currentArmorLabel.AnimateLabel(Abs(currentArmor), 0.20);
            inkTextRef.SetText(this.m_costArmorLabelValue, IntToString(armorChange));
            this.StartPulse(this.m_costArmorLabelPulseAnimation, this.m_pulseAnimationParams, inkWidgetRef.Get(this.m_costArmorLabelContainer));
            this.StopPulse(this.m_currentArmorLabelPulseAnimation);
          };
        };
      };
    };
    updateRange = Abs(newBars) + this.BAR_SLOPE_COUNT;
    i = 0;
    while i <= updateRange {
      if armorChange >= 0 {
        index = equipBars - updateRange + i;
      } else {
        if armorChange < 0 {
          index = this.m_currentBars - updateRange + i;
        };
      };
      if isHover && newBars >= 0 && index >= this.m_currentBars && index < equipBars {
        state = n"Safe_Add";
        this.m_bars[index].StartPulse(this.m_pulseAnimationParams);
      } else {
        if isHover && newBars < 0 && index > equipBars && index < this.m_currentBars {
          state = n"Armor_Mid";
          this.m_bars[index].StartPulse(this.m_pulseAnimationParams);
        } else {
          if index < this.m_currentBars {
            state = n"Armor_Mid";
            this.m_bars[index].StopPulse();
          } else {
            state = n"Default";
            this.m_bars[index].StopPulse();
          };
        };
      };
      this.m_bars[index].SetState(state);
      sizeOffset = 0.00;
      if isHover && newBars > 0 && index >= this.m_currentBars && index < equipBars || isHover && newBars >= 0 && equipBars == 0 && index == 0 {
        sizeOffset = this.GetSlopeAnimOffset(this.BAR_SLOPE_COUNT, 1);
      } else {
        if index > baseBars && index < this.m_currentBars {
          sizeOffset = this.GetSlopeAnimOffset(index, baseBars);
        };
      };
      if sizeOffset > 0.00 {
        this.m_bars[index].SetSizeAnimation(this.m_barScale + 0.50, sizeOffset, delay, this.BAR_ANIM_DURATION);
      } else {
        if i < this.m_currentBars {
          this.m_bars[index].SetSizeAnimation(this.m_barScale, 0.00, delay, this.BAR_ANIM_DURATION);
        } else {
          this.m_bars[index].SetSizeAnimation(this.m_barScale, 0.00, 0.00, this.BAR_ANIM_DURATION);
        };
      };
      if index == this.m_currentBars {
        if i == 0 {
          this.MoveLabelToBar(this.m_costArmorLabelContainer, this.m_bars[index + 1], this.m_costArmorLabelAnimation, false, false);
        } else {
          this.MoveLabelToBar(this.m_costArmorLabelContainer, this.m_bars[index], this.m_costArmorLabelAnimation, false, false);
        };
      };
      i += 1;
    };
  }

  protected cb func OnIntroAnimationFinished_METER(proxy: ref<inkAnimProxy>) -> Bool {
    proxy.UnregisterFromCallback(inkanimEventType.OnStart, this, n"OnIntroAnimationFinished_METER");
    proxy = this.PlayLibraryAnimation(n"meter_intro_RIGHT");
    proxy.RegisterToCallback(inkanimEventType.OnFinish, this, n"OnMeterIntroFinished_RIGHT");
  }

  protected cb func OnMeterIntroFinished_RIGHT(proxy: ref<inkAnimProxy>) -> Bool {
    this.QueueEvent(new ArmorBarFinalizedEvent());
    proxy.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnMeterIntroFinished_RIGHT");
  }

  protected cb func OnApply(evt: ref<RipperdocMeterArmorApplyEvent>) -> Bool {
    this.SetArmorData(evt.ArmorData.CurrentArmor, evt.ArmorData.CurrentMaxArmor, evt.ArmorData.MaxArmorPossible, evt.ArmorData.MaxDamageReduction);
    if !this.m_barsSpawned {
      this.SpawnBars();
    } else {
      this.SetArmor();
      this.SetMaxBar();
    };
  }

  protected cb func OnHover(evt: ref<RipperdocMeterArmorHoverEvent>) -> Bool {
    let armorChange: Float;
    let currentFalt: Float;
    let equippedArmorCost: Float;
    if evt.EquippedArmorChange > 0.00 || evt.EquippedArmorMultiplier > 0.00 {
      equippedArmorCost = evt.EquippedArmorChange + (this.m_curEquippedArmor * evt.EquippedArmorMultiplier) / (1.00 + evt.EquippedArmorMultiplier);
      armorChange = evt.ArmorChange + (this.m_curEquippedArmor - equippedArmorCost + evt.ArmorChange) * evt.ArmorMultiplier;
      armorChange = armorChange - equippedArmorCost;
      if evt.EquippedArmorMultiplier == 0.00 {
        armorChange = armorChange + armorChange * evt.CurrentArmorMultiplier;
      };
    } else {
      currentFalt = this.m_curEquippedArmor / (1.00 + evt.CurrentArmorMultiplier);
      armorChange = (currentFalt + evt.ArmorChange) * (1.00 + evt.CurrentArmorMultiplier + evt.ArmorMultiplier) - this.m_curEquippedArmor;
    };
    this.PreviewChange(armorChange, evt.IsHover, evt.isCyberwareEquipped);
  }

  protected cb func OnBarHoverOver(evt: ref<inkPointerEvent>) -> Bool {
    super.OnBarHoverOver(evt);
    inkWidgetRef.SetVisible(this.m_maxArmorLabel, true);
  }

  protected cb func OnBarHoverOut(evt: ref<inkPointerEvent>) -> Bool {
    super.OnBarHoverOut(evt);
    inkWidgetRef.SetVisible(this.m_maxArmorLabel, false);
  }

  protected cb func OnRipperdocMeterArmorBarHoverEvent(evt: ref<RipperdocMeterArmorBarHoverEvent>) -> Bool {
    this.OnBarHoverOver(new inkPointerEvent());
  }
}
