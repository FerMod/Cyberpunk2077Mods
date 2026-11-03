
public native class inkTextParams extends IScriptable {

  public final func AddString(const value: script_ref<String>) -> Void {
    this.Internal_AddString(Deref(value));
  }

  public final func AddString(const key: script_ref<String>, const value: script_ref<String>) -> Void {
    this.Internal_AddString(Deref(value), Deref(key));
  }

  public final func UpdateString(index: Int32, const value: script_ref<String>) -> Void {
    this.Internal_UpdateString(index, Deref(value));
  }

  public final func UpdateString(const key: script_ref<String>, const value: script_ref<String>) -> Void {
    this.Internal_UpdateStringKey(Deref(key), Deref(value));
  }

  public final func AddLocalizedString(const valueLocKey: script_ref<String>) -> Void {
    this.Internal_AddLocalizedString(Deref(valueLocKey));
  }

  public final func AddLocalizedString(const key: script_ref<String>, const valueLocKey: script_ref<String>) -> Void {
    this.Internal_AddLocalizedString(Deref(valueLocKey), Deref(key));
  }

  public final func UpdateLocalizedString(index: Int32, const valueLocKey: script_ref<String>) -> Void {
    this.Internal_UpdateLocalizedString(index, Deref(valueLocKey));
  }

  public final func UpdateLocalizedString(const key: script_ref<String>, const valueLocKey: script_ref<String>) -> Void {
    this.Internal_UpdateLocalizedStringKey(Deref(key), Deref(valueLocKey));
  }

  public final func AddLocalizedName(valueLocKey: CName) -> Void {
    this.Internal_AddLocalizedName(valueLocKey);
  }

  public final func AddLocalizedName(const key: script_ref<String>, valueLocKey: CName) -> Void {
    this.Internal_AddLocalizedName(valueLocKey, Deref(key));
  }

  public final func UpdateLocalizedName(index: Int32, valueLocKey: CName) -> Void {
    this.Internal_UpdateLocalizedName(index, valueLocKey);
  }

  public final func UpdateLocalizedName(const key: script_ref<String>, valueLocKey: CName) -> Void {
    this.Internal_UpdateLocalizedNameKey(Deref(key), valueLocKey);
  }

  public final func AddNumber(value: Int32) -> Void {
    this.Internal_AddInteger(value);
  }

  public final func AddNumber(const key: script_ref<String>, value: Int32) -> Void {
    this.Internal_AddInteger(value, Deref(key));
  }

  public final func UpdateNumber(index: Int32, value: Int32) -> Void {
    this.Internal_UpdateInteger(index, value);
  }

  public final func UpdateNumber(const key: script_ref<String>, value: Int32) -> Void {
    this.Internal_UpdateIntegerKey(Deref(key), value);
  }

  public final func AddNumber(value: Float) -> Void {
    this.Internal_AddFloat(value);
  }

  public final func AddNumber(const key: script_ref<String>, value: Float) -> Void {
    this.Internal_AddFloat(value, Deref(key));
  }

  public final func UpdateNumber(index: Int32, value: Float) -> Void {
    this.Internal_UpdateFloat(index, value);
  }

  public final func UpdateNumber(const key: script_ref<String>, value: Float) -> Void {
    this.Internal_UpdateFloatKey(Deref(key), value);
  }

  public final func AddMeasurement(value: Float, valueUnit: EMeasurementUnit) -> Void {
    this.Internal_AddMeasurement(value, valueUnit);
  }

  public final func AddMeasurement(const key: script_ref<String>, value: Float, valueUnit: EMeasurementUnit) -> Void {
    this.Internal_AddMeasurement(value, valueUnit, Deref(key));
  }

  public final func UpdateMeasurement(index: Int32, value: Float, valueUnit: EMeasurementUnit) -> Void {
    this.Internal_UpdateMeasurement(index, value, valueUnit);
  }

  public final func UpdateMeasurement(const key: script_ref<String>, value: Float, valueUnit: EMeasurementUnit) -> Void {
    this.Internal_UpdateMeasurementKey(Deref(key), value, valueUnit);
  }

  public final func AddTime(valueSeconds: Int32) -> Void {
    this.Internal_AddTime(valueSeconds);
  }

  public final func AddTime(value: GameTime) -> Void {
    this.Internal_AddTime(GameTime.Seconds(value));
  }

  public final func AddTime(const key: script_ref<String>, valueSeconds: Int32) -> Void {
    this.Internal_AddTime(valueSeconds, Deref(key));
  }

  public final func AddTime(const key: script_ref<String>, value: GameTime) -> Void {
    this.Internal_AddTime(GameTime.GetSeconds(value), Deref(key));
  }

  public final func UpdateTime(index: Int32, valueSeconds: Int32) -> Void {
    this.Internal_UpdateTime(index, valueSeconds);
  }

  public final func UpdateTime(index: Int32, value: GameTime) -> Void {
    this.Internal_UpdateTime(index, GameTime.GetSeconds(value));
  }

  public final func UpdateTime(const key: script_ref<String>, valueSeconds: Int32) -> Void {
    this.Internal_UpdateTimeKey(Deref(key), valueSeconds);
  }

  public final func UpdateTime(const key: script_ref<String>, value: GameTime) -> Void {
    this.Internal_UpdateTimeKey(Deref(key), GameTime.GetSeconds(value));
  }

  public final func AddNCGameTime(value: GameTime) -> Void {
    this.Internal_AddNCGameTime(GameTime.Seconds(value));
  }

  public final func AddNCGameTime(const key: script_ref<String>, value: GameTime) -> Void {
    this.Internal_AddNCGameTime(GameTime.GetSeconds(value), Deref(key));
  }

  public final func AddCurrentDate() -> Void {
    this.Internal_AddCurrentDate();
  }

  public final func AddCurrentDate(const key: script_ref<String>) -> Void {
    this.Internal_AddCurrentDate(Deref(key));
  }

  public final func UpdateCurrentDate(index: Int32) -> Void {
    this.Internal_UpdateCurrentDate(index);
  }

  public final func UpdateCurrentDate(const key: script_ref<String>) -> Void {
    this.Internal_UpdateCurrentDateKey(Deref(key));
  }

  public final func SetAsyncFormat(value: Bool) -> Void {
    this.Internal_SetAsyncFormat(value);
  }

  private final native func Internal_AddString(value: String, opt key: String) -> Void;

  private final native func Internal_UpdateString(index: Int32, value: String) -> Void;

  private final native func Internal_UpdateStringKey(key: String, value: String) -> Void;

  private final native func Internal_AddLocalizedString(valueLocKey: String, opt key: String) -> Void;

  private final native func Internal_UpdateLocalizedString(index: Int32, valueLocKey: String) -> Void;

  private final native func Internal_UpdateLocalizedStringKey(key: String, valueLocKey: String) -> Void;

  private final native func Internal_AddLocalizedName(valueLocKey: CName, opt key: String) -> Void;

  private final native func Internal_UpdateLocalizedName(index: Int32, valueLocKey: CName) -> Void;

  private final native func Internal_UpdateLocalizedNameKey(key: String, valueLocKey: CName) -> Void;

  private final native func Internal_AddInteger(value: Int32, opt key: String) -> Void;

  private final native func Internal_UpdateInteger(index: Int32, value: Int32) -> Void;

  private final native func Internal_UpdateIntegerKey(key: String, value: Int32) -> Void;

  private final native func Internal_AddFloat(value: Float, opt key: String) -> Void;

  private final native func Internal_UpdateFloat(index: Int32, value: Float) -> Void;

  private final native func Internal_UpdateFloatKey(key: String, value: Float) -> Void;

  private final native func Internal_AddMeasurement(value: Float, valueUnit: EMeasurementUnit, opt key: String) -> Void;

  private final native func Internal_UpdateMeasurement(index: Int32, value: Float, valueUnit: EMeasurementUnit) -> Void;

  private final native func Internal_UpdateMeasurementKey(key: String, value: Float, valueUnit: EMeasurementUnit) -> Void;

  private final native func Internal_AddTime(valueSeconds: Int32, opt key: String) -> Void;

  private final native func Internal_UpdateTime(index: Int32, valueSeconds: Int32) -> Void;

  private final native func Internal_UpdateTimeKey(key: String, valueSeconds: Int32) -> Void;

  private final native func Internal_AddNCGameTime(valueSeconds: Int32, opt key: String) -> Void;

  private final native func Internal_AddCurrentDate(opt key: String) -> Void;

  private final native func Internal_UpdateCurrentDate(index: Int32) -> Void;

  private final native func Internal_UpdateCurrentDateKey(key: String) -> Void;

  private final native func Internal_SetAsyncFormat(value: Bool) -> Void;
}
