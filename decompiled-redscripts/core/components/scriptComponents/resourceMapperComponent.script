
public class OptionalAreaEffectData extends IScriptable {

  private let m_includeInAoeData: Bool;

  private inline edit let m_aoeData: ref<AreaEffectData>;

  public final func GetAoeData() -> ref<AreaEffectData> {
    return this.m_aoeData;
  }

  public final func ShouldIncludeInAoeData() -> Bool {
    return this.m_includeInAoeData;
  }
}

public class AreaEffectData extends IScriptable {

  public inline let action: ref<ScriptableDeviceAction>;

  @runtimeProperty("customEditor", "TweakDBGroupInheritance;ObjectAction")
  public inline let actionRecordID: TweakDBID;

  public let areaEffectID: CName;

  @runtimeProperty("category", "VFX Data")
  @default(AreaEffectData, focus_10m)
  public let indicatorEffectName: CName;

  @runtimeProperty("category", "VFX Data")
  @default(AreaEffectData, false)
  public let useIndicatorEffect: Bool;

  @runtimeProperty("rangeMax", "1.f")
  @runtimeProperty("category", "VFX Data")
  @runtimeProperty("rangeMin", "0.f")
  @default(AreaEffectData, 1.f)
  public let indicatorEffectSize: Float;

  @runtimeProperty("category", "Stim Data")
  @default(AreaEffectData, 10.f)
  public let stimRange: Float;

  @runtimeProperty("category", "Stim Data")
  @default(AreaEffectData, 5.f)
  public let stimLifetime: Float;

  @runtimeProperty("category", "Stim Data")
  @default(AreaEffectData, DeviceStimType.Distract)
  public let stimType: DeviceStimType;

  @runtimeProperty("category", "Stim Data")
  public let stimSource: NodeRef;

  @runtimeProperty("category", "Stim Data")
  public let additionaStimSources: [NodeRef];

  @runtimeProperty("category", "Stim Data")
  public let investigateSpot: NodeRef;

  @runtimeProperty("category", "Stim Data")
  public let investigateController: Bool;

  @runtimeProperty("category", "Stim Data")
  public let controllerSource: NodeRef;

  @runtimeProperty("category", "Highlight Data")
  @default(AreaEffectData, true)
  public let highlightTargets: Bool;

  @runtimeProperty("category", "Highlight Data")
  @default(AreaEffectData, EFocusForcedHighlightType.INVALID)
  public let highlightType: EFocusForcedHighlightType;

  @runtimeProperty("category", "Highlight Data")
  @default(AreaEffectData, EFocusOutlineType.DISTRACTION)
  public let outlineType: EFocusOutlineType;

  @runtimeProperty("category", "Highlight Data")
  @default(AreaEffectData, EPriority.High)
  public let highlightPriority: EPriority;

  public let effectInstance: ref<EffectInstance>;

  public let gameEffectOverrideName: CName;

  public final func EffectInstanceClear() -> Void {
    this.effectInstance = null;
  }

  public final func SetEffectInstance(effect: ref<EffectInstance>) -> Void {
    this.effectInstance = effect;
  }

  public final const func GetActionRecord() -> wref<ObjectAction_Record> {
    return TweakDBInterface.GetObjectActionRecord(this.actionRecordID);
  }

  private final const func GetActionNameFromRecord(record: wref<ObjectAction_Record>) -> CName {
    if record != null {
      return record.ActionName();
    };
    return n"None";
  }

  public final const func GetActionNameFromRecord() -> CName {
    return this.GetActionNameFromRecord(this.GetActionRecord());
  }

  public final const func IsMatching(_action: ref<BaseScriptableAction>) -> Bool {
    if !IsDefined(_action) {
      return false;
    };
    if TDBID.IsValid(this.actionRecordID) && _action.GetObjectActionID() == this.actionRecordID {
      return true;
    };
    if IsDefined(this.action) && Equals(this.action.GetClassName(), _action.GetClassName()) {
      return true;
    };
    if Equals(this.areaEffectID, _action.GetClassName()) {
      return true;
    };
    if TDBID.IsValid(this.actionRecordID) && Equals(this.areaEffectID, _action.GetObjectActionRecord().ActionName()) {
      return true;
    };
    return false;
  }

  public final func CopyData(const areaEffectDataToCopy: ref<AreaEffectData>) -> Void {
    let data: SAreaEffectData = areaEffectDataToCopy.GetData();
    this.CopyData(data);
  }

  public final func CopyData(const sAreaEffectDataToCopy: SAreaEffectData) -> Void {
    this.action = sAreaEffectDataToCopy.action;
    this.areaEffectID = sAreaEffectDataToCopy.areaEffectID;
    this.indicatorEffectName = sAreaEffectDataToCopy.indicatorEffectName;
    this.useIndicatorEffect = sAreaEffectDataToCopy.useIndicatorEffect;
    this.indicatorEffectSize = sAreaEffectDataToCopy.indicatorEffectSize;
    this.stimRange = sAreaEffectDataToCopy.stimRange;
    this.stimLifetime = sAreaEffectDataToCopy.stimLifetime;
    this.stimType = sAreaEffectDataToCopy.stimType;
    this.stimSource = sAreaEffectDataToCopy.stimSource;
    let i: Int32 = 0;
    while i < ArraySize(sAreaEffectDataToCopy.additionaStimSources) {
      ArrayPush(this.additionaStimSources, sAreaEffectDataToCopy.additionaStimSources[i]);
      i += 1;
    };
    this.investigateSpot = sAreaEffectDataToCopy.investigateSpot;
    this.investigateController = sAreaEffectDataToCopy.investigateController;
    this.controllerSource = sAreaEffectDataToCopy.controllerSource;
    this.highlightTargets = sAreaEffectDataToCopy.highlightTargets;
    this.highlightType = sAreaEffectDataToCopy.highlightType;
    this.highlightPriority = sAreaEffectDataToCopy.highlightPriority;
    this.effectInstance = sAreaEffectDataToCopy.effectInstance;
  }

  public final const func GetData() -> SAreaEffectData {
    let data: SAreaEffectData;
    data.action = this.action;
    data.areaEffectID = this.areaEffectID;
    data.indicatorEffectName = this.indicatorEffectName;
    data.useIndicatorEffect = this.useIndicatorEffect;
    data.indicatorEffectSize = this.indicatorEffectSize;
    data.stimRange = this.stimRange;
    data.stimLifetime = this.stimLifetime;
    data.stimType = this.stimType;
    data.stimSource = this.stimSource;
    let i: Int32 = 0;
    while i < ArraySize(this.additionaStimSources) {
      ArrayPush(data.additionaStimSources, this.additionaStimSources[i]);
      i += 1;
    };
    data.investigateSpot = this.investigateSpot;
    data.investigateController = this.investigateController;
    data.controllerSource = this.controllerSource;
    data.highlightTargets = this.highlightTargets;
    data.highlightType = this.highlightType;
    data.highlightPriority = this.highlightPriority;
    data.effectInstance = this.effectInstance;
    return data;
  }
}

public class FxResourceMapperComponent extends ScriptableComponent {

  @runtimeProperty("category", "Area effects - DEFINE NEW EFFECTS HERE")
  protected inline let m_areaEffectData: [ref<AreaEffectData>];

  @runtimeProperty("category", "Area effects - DEFINE NEW EFFECTS HERE")
  @default(FxResourceMapperComponent, 1.0f)
  protected inline let m_investigationSlotOffsetMultiplier: Float;

  @runtimeProperty("category", "Area effects - DEFINE NEW EFFECTS HERE")
  protected inline let m_areaEffectInFocusMode: [ref<AreaEffectTargetData>];

  @runtimeProperty("category", "Area effects - DEFINE NEW EFFECTS HERE")
  @runtimeProperty("tooltip", "Do NOT add/remove any data locally. Check/Uncheck a flag instead.")
  protected inline edit const let m_optionalAreaEffectData: [ref<OptionalAreaEffectData>];

  private let DEBUG_copiedDataFromEntity: Bool;

  private let DEBUG_copiedDataFromFXStruct: Bool;

  private let m_isInitialized: Bool;

  private final func OnGameAttach() -> Void {
    this.TryInitialize();
  }

  private final func TryInitialize() -> Void {
    if !this.m_isInitialized {
      this.Initialize();
    };
  }

  private final func Initialize() -> Void {
    this.TryAddOptionalAoeData();
    this.m_isInitialized = true;
  }

  private final func TryAddOptionalAoeData() -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_optionalAreaEffectData) {
      if this.m_optionalAreaEffectData[i].ShouldIncludeInAoeData() {
        ArrayPush(this.m_areaEffectData, this.m_optionalAreaEffectData[i].GetAoeData());
      };
      i += 1;
    };
  }

  public final func CopyDataToFxMapClass(const areaEffectsData: script_ref<[SAreaEffectData]>, DEBUG_entityCopy: Bool, DEBUG_fxCopy: Bool) -> Void {
    let areaEffectDataClass: ref<AreaEffectData>;
    let i: Int32;
    if ArraySize(this.m_areaEffectData) > 0 {
      return;
    };
    i = 0;
    while i < ArraySize(Deref(areaEffectsData)) {
      areaEffectDataClass = new AreaEffectData();
      areaEffectDataClass.CopyData(Deref(areaEffectsData)[i]);
      ArrayPush(this.m_areaEffectData, areaEffectDataClass);
      if DEBUG_entityCopy {
        this.DEBUG_copiedDataFromEntity = DEBUG_entityCopy;
      };
      if DEBUG_fxCopy {
        this.DEBUG_copiedDataFromFXStruct = DEBUG_fxCopy;
      };
      i += 1;
    };
  }

  public final func CopyEffectToFxMapClass(const areaEffectsInFocusMode: script_ref<[SAreaEffectTargetData]>) -> Void {
    let effctDataClass: ref<AreaEffectTargetData>;
    let i: Int32;
    if ArraySize(this.m_areaEffectInFocusMode) > 0 {
      return;
    };
    i = 0;
    while i < ArraySize(Deref(areaEffectsInFocusMode)) {
      effctDataClass = new AreaEffectTargetData();
      effctDataClass.areaEffectID = Deref(areaEffectsInFocusMode)[i].areaEffectID;
      effctDataClass.onSelf = Deref(areaEffectsInFocusMode)[i].onSelf;
      effctDataClass.onSlaves = Deref(areaEffectsInFocusMode)[i].onSlaves;
      ArrayPush(this.m_areaEffectInFocusMode, effctDataClass);
      i += 1;
    };
  }

  public final const func GetInvestigationSlotOffset() -> Float {
    return this.m_investigationSlotOffsetMultiplier;
  }

  public final const func GetAreaEffectData() -> [ref<AreaEffectData>] {
    return this.m_areaEffectData;
  }

  public final const func GetAreaEffectDataByIndex(index: Int32) -> ref<AreaEffectData> {
    return this.m_areaEffectData[index];
  }

  public final const func GetAreaEffectDataSize() -> Int32 {
    return ArraySize(this.m_areaEffectData);
  }

  public final const func GetAreaEffectInFocusMode() -> [ref<AreaEffectTargetData>] {
    return this.m_areaEffectInFocusMode;
  }

  public final const func GetAreaEffectInFocusModeByIndex(index: Int32) -> ref<AreaEffectTargetData> {
    return this.m_areaEffectInFocusMode[index];
  }

  public final const func GetAreaEffectInFocusSize() -> Int32 {
    return ArraySize(this.m_areaEffectInFocusMode);
  }

  public final const func HasAnyDistractions() -> Bool {
    let i: Int32 = 0;
    while i < ArraySize(this.m_areaEffectData) {
      if Equals(this.m_areaEffectData[i].stimType, DeviceStimType.Distract) || Equals(this.m_areaEffectData[i].stimType, DeviceStimType.VisualDistract) {
        return true;
      };
      i += 1;
    };
    return false;
  }

  public final func CreateEffectStructDataFromAttack(attackTDBID: TweakDBID, index: Int32, opt gameEffectNameOverride: CName, opt dontHighlightOnLookat: Bool) -> Void {
    this.CreateData(attackTDBID, index, gameEffectNameOverride, dontHighlightOnLookat);
  }

  private final func CreateData(attackTDBID: TweakDBID, index: Int32, opt gameEffectNameOverride: CName, opt dontHighlightOnLookat: Bool) -> Void {
    let effectData: ref<AreaEffectData> = new AreaEffectData();
    let distractForEffectData: ref<AreaEffectData> = new AreaEffectData();
    let effectRange: Float = TweakDBInterface.GetAttackRecord(attackTDBID).Range();
    effectData.areaEffectID = StringToName("hardCodeDoNotRemove" + index);
    effectData.stimRange = effectRange;
    effectData.highlightTargets = true;
    effectData.highlightType = EFocusForcedHighlightType.INVALID;
    effectData.outlineType = EFocusOutlineType.AOE;
    effectData.highlightPriority = EPriority.Medium;
    effectData.stimType = DeviceStimType.None;
    effectData.indicatorEffectName = n"None";
    effectData.gameEffectOverrideName = gameEffectNameOverride;
    ArrayPush(this.m_areaEffectData, effectData);
    if !dontHighlightOnLookat {
      this.CreateAreaEffectTargetData(effectData);
    };
    distractForEffectData.areaEffectID = StringToName("hardCodeDoNotRemoveExplosion" + index);
    this.CalculateRangeSphere(effectRange * 3.00, distractForEffectData.indicatorEffectName, distractForEffectData.indicatorEffectSize);
    distractForEffectData.stimRange = effectRange * 3.00;
    distractForEffectData.highlightTargets = false;
    distractForEffectData.stimType = DeviceStimType.Explosion;
    ArrayPush(this.m_areaEffectData, distractForEffectData);
    if !dontHighlightOnLookat {
      this.CreateAreaEffectTargetData(distractForEffectData);
    };
  }

  private final func CalculateRangeSphere(desiredRange: Float, out effectName: CName, out effectSize: Float) -> Void {
    if desiredRange <= 5.00 {
      effectName = n"focus_5m";
      effectSize = desiredRange / 5.00;
    } else {
      if desiredRange <= 10.00 {
        effectName = n"focus_10m";
        effectSize = desiredRange / 10.00;
      } else {
        if desiredRange <= 20.00 {
          effectName = n"focus_20m";
          effectSize = desiredRange / 20.00;
        } else {
          if desiredRange <= 30.00 {
            effectName = n"focus_30m";
            effectSize = desiredRange / 30.00;
          };
        };
      };
    };
  }

  protected final func CreateAreaEffectTargetData(mainEffect: ref<AreaEffectData>) -> Void {
    let data: ref<AreaEffectTargetData> = new AreaEffectTargetData();
    data.areaEffectID = mainEffect.areaEffectID;
    data.onSelf = true;
    ArrayPush(this.m_areaEffectInFocusMode, data);
  }

  public final const func GetAreaEffectDataIndexByName(effectName: CName) -> Int32 {
    let i: Int32 = 0;
    while i < ArraySize(this.m_areaEffectData) {
      if this.m_areaEffectData[i].action != null && Equals(this.m_areaEffectData[i].action.GetClassName(), effectName) {
        return i;
      };
      if IsNameValid(effectName) && Equals(this.m_areaEffectData[i].areaEffectID, effectName) {
        return i;
      };
      i += 1;
    };
    return -1;
  }

  public final const func GetAreaEffectDataIndexByAction(action: ref<BaseScriptableAction>) -> Int32 {
    let i: Int32;
    if !IsDefined(action) {
      return -1;
    };
    i = 0;
    while i < ArraySize(this.m_areaEffectData) {
      if this.m_areaEffectData[i].IsMatching(action) {
        return i;
      };
      i += 1;
    };
    return -1;
  }

  public final const func GetAreaEffectDataNameByIndex(effectIndex: Int32) -> CName {
    if effectIndex < 0 || effectIndex >= ArraySize(this.m_areaEffectData) {
      return n"None";
    };
    if TDBID.IsValid(this.m_areaEffectData[effectIndex].actionRecordID) {
      return this.m_areaEffectData[effectIndex].GetActionNameFromRecord();
    };
    if this.m_areaEffectData[effectIndex].action != null {
      return this.m_areaEffectData[effectIndex].action.GetClassName();
    };
    return this.m_areaEffectData[effectIndex].areaEffectID;
  }

  public final const func GetDistractionRange(type: DeviceStimType) -> Float {
    let currentRange: Float;
    let i: Int32 = 0;
    while i < ArraySize(this.m_areaEffectData) {
      if this.CanCompareRanges(type, this.m_areaEffectData[i].stimType) && this.m_areaEffectData[i].stimRange > currentRange {
        currentRange = this.m_areaEffectData[i].stimRange;
      };
      i += 1;
    };
    return currentRange;
  }

  public final const func GetSmallestDistractionRange(type: DeviceStimType) -> Float {
    let foundAnyRange: Bool;
    let currentRange: Float = 999999.00;
    let i: Int32 = 0;
    while i < ArraySize(this.m_areaEffectData) {
      if this.CanCompareRanges(type, this.m_areaEffectData[i].stimType) && this.m_areaEffectData[i].stimRange < currentRange {
        currentRange = this.m_areaEffectData[i].stimRange;
        foundAnyRange = true;
      };
      i += 1;
    };
    return foundAnyRange ? currentRange : 0.00;
  }

  private final const func CanCompareRanges(type: DeviceStimType, currentType: DeviceStimType) -> Bool {
    return Equals(type, currentType) || (Equals(type, DeviceStimType.Distract) || Equals(type, DeviceStimType.VisualDistract)) && (Equals(currentType, DeviceStimType.Distract) || Equals(currentType, DeviceStimType.VisualDistract));
  }

  public final func TryGetAreaEffectByAction(action: ref<ScriptableDeviceAction>, out areaEffectData: ref<AreaEffectData>) -> Bool {
    let actionIndex: Int32;
    if this.TryGetActionIndex(action, actionIndex) {
      areaEffectData = this.GetAreaEffectDataByIndex(actionIndex);
      return true;
    };
    return false;
  }

  public final const func TryGetActionIndex(action: ref<ScriptableDeviceAction>, out actionIndex: Int32) -> Bool {
    actionIndex = this.GetAreaEffectDataIndexByAction(action);
    return actionIndex >= 0;
  }
}
