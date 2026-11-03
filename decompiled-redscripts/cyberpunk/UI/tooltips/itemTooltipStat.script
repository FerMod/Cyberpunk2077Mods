
public class ItemTooltipStatController extends inkLogicController {

  protected edit let m_statName: inkTextRef;

  protected edit let m_statValue: inkTextRef;

  protected edit let m_statComparedContainer: inkWidgetRef;

  protected edit let m_statComparedValue: inkTextRef;

  protected edit let m_arrow: inkImageRef;

  private let m_measurementUnit: EMeasurementUnit;

  protected let m_settings: ref<UserSettings>;

  protected let m_settingsListener: ref<ItemTooltipStatSettingsListener>;

  @default(ItemTooltipStatController, /accessibility/interface)
  protected let m_groupPath: CName;

  protected let m_bigFontEnabled: Bool;

  protected let m_inCrafting: Bool;

  public final func SetData(const data: script_ref<InventoryTooltipData_StatData>) -> Void {
    let absoluteValue: Float;
    let damageMax: Float;
    let damageMin: Float;
    let isNegative: Bool;
    let statFinalValue: String;
    let statText: String;
    let statsTweakID: TweakDBID = TDBID.Create("BaseStats." + EnumValueToString("gamedataStatType", Cast<Int64>(EnumInt(Deref(data).statType))));
    let decimalPlaces: Int32 = TweakDBInterface.GetInt(statsTweakID + t".decimalPlaces", 2);
    let displayPercent: Bool = TweakDBInterface.GetBool(statsTweakID + t".displayPercent", false);
    let displayPlus: Bool = TweakDBInterface.GetBool(statsTweakID + t".displayPlus", false);
    let inMeters: Bool = TweakDBInterface.GetBool(statsTweakID + t".inMeters", false);
    let inSeconds: Bool = TweakDBInterface.GetBool(statsTweakID + t".inSeconds", false);
    let inSpeed: Bool = TweakDBInterface.GetBool(statsTweakID + t".inSpeed", false);
    let multiplyBy100InText: Bool = TweakDBInterface.GetBool(statsTweakID + t".multiplyBy100InText", false);
    let roundValue: Bool = TweakDBInterface.GetBool(statsTweakID + t".roundValue", false);
    let flipNegative: Bool = TweakDBInterface.GetBool(statsTweakID + t".shouldFlipNegativeValue", false);
    let currentValue: Float = Deref(data).currentValueF;
    this.m_measurementUnit = UILocalizationHelper.GetSystemBaseUnit();
    if multiplyBy100InText {
      currentValue = currentValue * 100.00;
    };
    if flipNegative {
      currentValue = AbsF(currentValue);
    };
    absoluteValue = AbsF(currentValue);
    isNegative = currentValue < 0.00;
    if AbsF(currentValue) > 0.00 {
      if !roundValue {
        statText += NoTrailZeros(FloatToStringPrec(displayPlus ? absoluteValue : currentValue, decimalPlaces));
      } else {
        statText += IntToString(RoundF(displayPlus ? absoluteValue : currentValue));
      };
    };
    if RPGManager.IsDamageStat(Deref(data).statType) {
      damageMin = currentValue * 0.90;
      damageMax = currentValue * 1.10;
      statText = FloatToStringPrec(damageMin, 0) + "-" + FloatToStringPrec(damageMax, 0);
    };
    inkTextRef.SetText(this.m_statName, Deref(data).statName);
    if displayPlus {
      statFinalValue += isNegative ? "-" : "+";
    };
    statFinalValue += statText;
    if displayPercent {
      statFinalValue += "%";
    };
    if inMeters {
      currentValue = MeasurementUtils.ValueUnitToUnit(currentValue, EMeasurementUnit.Meter, this.m_measurementUnit);
      statFinalValue += " " + GetLocalizedText(NameToString(MeasurementUtils.GetUnitLocalizationKey(this.m_measurementUnit)));
    };
    if inSeconds {
      statFinalValue += " " + GetLocalizedText("UI-Quickhacks-Seconds");
    };
    if inSpeed {
      currentValue = MeasurementUtils.ValueUnitToUnit(currentValue, EMeasurementUnit.Meter, this.m_measurementUnit);
      statFinalValue += " " + GetLocalizedText(NameToString(MeasurementUtils.GetUnitLocalizationKey(this.m_measurementUnit))) + "/" + GetLocalizedText("UI-Quickhacks-Seconds");
    };
    if Equals(Deref(data).statType, gamedataStatType.MaxDuration) {
      statFinalValue += " " + GetLocalizedText("UI-Quickhacks-Seconds");
    };
    inkTextRef.SetText(this.m_statValue, statFinalValue);
    this.UpdateComparedValue(Deref(data).diffValue, displayPercent, displayPlus, inMeters, inSeconds, inSpeed);
    this.m_settings = new UserSettings();
    this.m_settingsListener = new ItemTooltipStatSettingsListener();
    this.m_settingsListener.RegisterController(this);
    this.m_settingsListener.Register(this.m_groupPath);
    this.NewUpdateTooltipSize();
  }

  public final func SetZeroData() -> Void {
    inkTextRef.SetText(this.m_statValue, "0");
  }

  public final func SetData(data: ref<MinimalItemTooltipStatData>, opt disableComparison: Bool) -> Void {
    let absoluteValue: Float;
    let damageMax: Float;
    let damageMin: Float;
    let isNegative: Bool;
    let statFinalValue: String;
    let statText: String;
    let currentValue: Float = data.value;
    this.m_measurementUnit = UILocalizationHelper.GetSystemBaseUnit();
    if data.multiplyBy100InText {
      currentValue = currentValue * 100.00;
    };
    if data.flipNegative {
      currentValue = AbsF(currentValue);
    };
    absoluteValue = AbsF(currentValue);
    isNegative = currentValue < 0.00;
    if AbsF(currentValue) >= 0.00 {
      if !data.roundValue {
        statText += NoTrailZeros(FloatToStringPrec(data.displayPlus ? absoluteValue : currentValue, data.decimalPlaces));
      } else {
        statText += IntToString(RoundF(data.displayPlus ? absoluteValue : currentValue));
      };
    };
    if RPGManager.IsDamageStat(data.type) {
      damageMin = currentValue * 0.90;
      damageMax = currentValue * 1.10;
      statText = FloatToStringPrec(damageMin, 0) + "-" + FloatToStringPrec(damageMax, 0);
    };
    inkTextRef.SetText(this.m_statName, data.statName);
    if data.displayPlus {
      statFinalValue += isNegative ? "-" : "+";
    };
    statFinalValue += statText;
    if data.displayPercent {
      statFinalValue += "%";
    };
    if data.inMeters {
      currentValue = MeasurementUtils.ValueUnitToUnit(currentValue, EMeasurementUnit.Meter, this.m_measurementUnit);
      statFinalValue += GetLocalizedText(NameToString(MeasurementUtils.GetUnitLocalizationKey(this.m_measurementUnit)));
    };
    if data.inSeconds {
      statFinalValue += " " + GetLocalizedText("UI-Quickhacks-Seconds");
    };
    if data.inSpeed {
      currentValue = MeasurementUtils.ValueUnitToUnit(currentValue, EMeasurementUnit.Meter, this.m_measurementUnit);
      statFinalValue += " " + GetLocalizedText(NameToString(MeasurementUtils.GetUnitLocalizationKey(this.m_measurementUnit))) + "/" + GetLocalizedText("UI-Quickhacks-Seconds");
    };
    if Equals(data.type, gamedataStatType.MaxDuration) {
      statFinalValue += " " + GetLocalizedText("UI-Quickhacks-Seconds");
    };
    inkTextRef.SetText(this.m_statValue, statFinalValue);
    if !disableComparison {
      this.UpdateComparedValue(Cast<Int32>(data.diff), data.displayPercent, data.displayPlus, data.inMeters, data.inSeconds, data.inSpeed);
    };
    this.m_settings = new UserSettings();
    this.m_settingsListener = new ItemTooltipStatSettingsListener();
    this.m_settingsListener.RegisterController(this);
    this.m_settingsListener.Register(this.m_groupPath);
    this.NewUpdateTooltipSize();
  }

  public final func SetTextState(newState: CName) -> Void {
    inkWidgetRef.SetState(this.m_statValue, newState);
    inkWidgetRef.SetState(this.m_statName, newState);
  }

  public final func SetData(data: wref<UIInventoryItemStat>) -> Void {
    let absoluteValue: Float;
    let damageMax: Float;
    let damageMin: Float;
    let isNegative: Bool;
    let statFinalValue: String;
    let statText: String;
    let currentValue: Float = data.Value;
    this.m_measurementUnit = UILocalizationHelper.GetSystemBaseUnit();
    let properties: wref<UIItemStatProperties> = data.GetProperties();
    if properties.MultiplyBy100InText() {
      currentValue = currentValue * 100.00;
    };
    if properties.FlipNegative() {
      currentValue = AbsF(currentValue);
    };
    absoluteValue = AbsF(currentValue);
    isNegative = currentValue < 0.00;
    if AbsF(currentValue) >= 0.00 {
      if !properties.RoundValue() {
        statText += NoTrailZeros(FloatToStringPrec(properties.DisplayPlus() ? absoluteValue : currentValue, properties.DecimalPlaces()));
      } else {
        statText += IntToString(RoundF(properties.DisplayPlus() ? absoluteValue : currentValue));
      };
    };
    if RPGManager.IsDamageStat(data.Type) {
      damageMin = currentValue * 0.90;
      damageMax = currentValue * 1.10;
      statText = FloatToStringPrec(damageMin, 0) + "-" + FloatToStringPrec(damageMax, 0);
    };
    inkTextRef.SetText(this.m_statName, properties.GetName());
    if properties.DisplayPlus() {
      statFinalValue += isNegative ? "-" : "+";
    };
    statFinalValue += statText;
    if properties.DisplayPercent() {
      statFinalValue += "%";
    };
    if properties.InMeters() {
      currentValue = MeasurementUtils.ValueUnitToUnit(currentValue, EMeasurementUnit.Meter, this.m_measurementUnit);
      statFinalValue += GetLocalizedText(NameToString(MeasurementUtils.GetUnitLocalizationKey(this.m_measurementUnit)));
    };
    if properties.InSeconds() {
      statFinalValue += " " + GetLocalizedText("UI-Quickhacks-Seconds");
    };
    if Equals(data.Type, gamedataStatType.MaxDuration) {
      statFinalValue += " " + GetLocalizedText("UI-Quickhacks-Seconds");
    };
    inkTextRef.SetText(this.m_statValue, statFinalValue);
    this.m_settings = new UserSettings();
    this.m_settingsListener = new ItemTooltipStatSettingsListener();
    this.m_settingsListener.RegisterController(this);
    this.m_settingsListener.Register(this.m_groupPath);
    this.NewUpdateTooltipSize();
  }

  public final func SetData(data: wref<UIInventoryItemStat>, comparisonData: wref<UIInventoryItemStatComparison>) -> Void {
    let properties: wref<UIItemStatProperties>;
    this.SetData(data);
    if IsDefined(comparisonData) {
      properties = data.GetProperties();
      this.UpdateComparedValue(RoundF(comparisonData.Value), properties.DisplayPercent(), properties.DisplayPlus(), properties.InMeters(), properties.InSeconds(), properties.InSpeed());
    };
    this.m_settings = new UserSettings();
    this.m_settingsListener = new ItemTooltipStatSettingsListener();
    this.m_settingsListener.RegisterController(this);
    this.m_settingsListener.Register(this.m_groupPath);
    this.NewUpdateTooltipSize();
  }

  private final func UpdateComparedValue(diff: Int32, displayPercent: Bool, displayPlus: Bool, inMeters: Bool, inSeconds: Bool, inSpeed: Bool) -> Void {
    let comaredStatText: String;
    this.m_measurementUnit = UILocalizationHelper.GetSystemBaseUnit();
    let isVisible: Bool = diff != 0;
    let statToSet: CName = diff > 0 ? n"Better" : n"Worse";
    if displayPlus {
      comaredStatText += diff > 0 ? "+" : "-";
    };
    comaredStatText += IntToString(Abs(diff));
    if displayPercent {
      comaredStatText += "%";
    };
    if inMeters {
      diff = FloorF(MeasurementUtils.ValueUnitToUnit(Cast<Float>(diff), EMeasurementUnit.Meter, this.m_measurementUnit));
      comaredStatText += GetLocalizedText(NameToString(MeasurementUtils.GetUnitLocalizationKey(this.m_measurementUnit)));
    };
    if inSeconds {
      comaredStatText += " " + GetLocalizedText("UI-Quickhacks-Seconds");
    };
    if inSpeed {
      diff = FloorF(MeasurementUtils.ValueUnitToUnit(Cast<Float>(diff), EMeasurementUnit.Meter, this.m_measurementUnit));
      comaredStatText += " " + GetLocalizedText(NameToString(MeasurementUtils.GetUnitLocalizationKey(this.m_measurementUnit))) + "/" + GetLocalizedText("UI-Quickhacks-Seconds");
    };
    inkTextRef.SetText(this.m_statComparedValue, comaredStatText);
    inkWidgetRef.SetVisible(this.m_arrow, false);
    inkWidgetRef.SetVisible(this.m_statComparedValue, isVisible);
    inkWidgetRef.SetState(this.m_arrow, statToSet);
    inkWidgetRef.SetState(this.m_statComparedValue, statToSet);
    inkImageRef.SetBrushMirrorType(this.m_arrow, diff > 0 ? inkBrushMirrorType.NoMirror : inkBrushMirrorType.Vertical);
  }

  public final func OnVarModified(groupPath: CName, varName: CName, varType: ConfigVarType, reason: ConfigChangeReason) -> Void {
    switch varName {
      case n"BigFont":
        this.NewUpdateTooltipSize();
        break;
      default:
    };
  }

  private final func NewUpdateTooltipSize() -> Void {
    let configVar: ref<ConfigVarBool> = this.m_settings.GetVar(this.m_groupPath, n"BigFont") as ConfigVarBool;
    this.NewSetTooltipSize(configVar.GetValue());
  }

  protected func NewSetTooltipSize(value: Bool) -> Void {
    if Equals(value, true) && !this.m_inCrafting {
      inkTextRef.SetWrappingAtPosition(this.m_statName, 687.00);
      this.m_bigFontEnabled = true;
    } else {
      inkTextRef.SetWrappingAtPosition(this.m_statName, 541.00);
      this.m_bigFontEnabled = false;
    };
  }

  public final func GetContext(isCrafting: Bool) -> Void {
    this.m_inCrafting = isCrafting;
  }
}

public class ItemTooltipStatSettingsListener extends ConfigVarListener {

  private let m_ctrl: wref<ItemTooltipStatController>;

  public final func RegisterController(ctrl: ref<ItemTooltipStatController>) -> Void {
    this.m_ctrl = ctrl;
  }

  public func OnVarModified(groupPath: CName, varName: CName, varType: ConfigVarType, reason: ConfigChangeReason) -> Void {
    this.m_ctrl.OnVarModified(groupPath, varName, varType, reason);
  }
}
