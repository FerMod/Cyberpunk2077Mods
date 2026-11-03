
public class District extends IScriptable {

  private let m_districtID: TweakDBID;

  private let m_presetID: TweakDBID;

  private let m_districtRecord: ref<District_Record>;

  public final const func GetDistrictID() -> TweakDBID {
    return this.m_districtID;
  }

  public final const func GetDistrictRecord() -> ref<District_Record> {
    return this.m_districtRecord;
  }

  public final const func GetPresetID() -> TweakDBID {
    return this.m_presetID;
  }

  public final const func GetGunshotStimRange() -> Float {
    return this.m_districtRecord.GunShotStimRange();
  }

  public final const func GetCrimeMultiplier() -> Float {
    return this.m_districtRecord.CrimeMultiplier();
  }

  public final const func GetExplosiveDeviceStimRange() -> Float {
    return this.m_districtRecord.ExplosiveDeviceStimRangeMultiplier();
  }

  public final const func GetRadioEntryName() -> CName {
    let record: wref<District_Record> = this.m_districtRecord;
    let entry: CName = record.PoliceRadioSceneEntryPoint();
    if IsNameValid(entry) {
      return entry;
    };
    record = record.ParentDistrict();
    if !IsDefined(record) {
      return entry;
    };
    entry = record.PoliceRadioSceneEntryPoint();
    if IsNameValid(entry) {
      return entry;
    };
    record = record.ParentDistrict();
    if !IsDefined(record) {
      return entry;
    };
    entry = record.PoliceRadioSceneEntryPoint();
    return entry;
  }

  public final const func IsDogTown() -> Bool {
    if IsDefined(this.m_districtRecord) {
      if Equals(this.m_districtRecord.Type(), gamedataDistrict.Dogtown) {
        return true;
      };
      if IsDefined(this.m_districtRecord.ParentDistrictHandle()) {
        return Equals(this.m_districtRecord.ParentDistrictHandle().Type(), gamedataDistrict.Dogtown);
      };
    };
    return false;
  }

  public final const func IsBadlands() -> Bool {
    if IsDefined(this.m_districtRecord) {
      if Equals(this.m_districtRecord.Type(), gamedataDistrict.Badlands) {
        return true;
      };
      if IsDefined(this.m_districtRecord.ParentDistrictHandle()) {
        return Equals(this.m_districtRecord.ParentDistrictHandle().Type(), gamedataDistrict.Badlands);
      };
    };
    return false;
  }

  public final func Initialize(district: TweakDBID) -> Void {
    this.m_districtID = district;
    this.m_districtRecord = TweakDBInterface.GetDistrictRecord(this.m_districtID);
    if !IsDefined(this.m_districtRecord) {
      this.m_presetID = t"PreventionData.NCPD";
      return;
    };
    if TDBID.IsValid(this.m_districtRecord.PreventionPreset().GetID()) {
      this.m_presetID = this.m_districtRecord.PreventionPreset().GetID();
    } else {
      if TDBID.IsValid(this.m_districtRecord.ParentDistrict().PreventionPreset().GetID()) {
        this.m_presetID = this.m_districtRecord.ParentDistrict().PreventionPreset().GetID();
      } else {
        this.m_presetID = t"PreventionData.NCPD";
      };
    };
  }
}

public class DistrictManager extends IScriptable {

  private let m_system: wref<PreventionSystem>;

  private let m_stack: [ref<District>];

  private persistent let m_visitedDistricts: [TweakDBID];

  public final func Initialize(system: ref<PreventionSystem>) -> Void {
    this.m_system = system;
  }

  public final func Update(evt: ref<DistrictEnteredEvent>) -> Void {
    this.ManageDistrictStack(evt);
  }

  private final func ManageDistrictStack(request: ref<DistrictEnteredEvent>) -> Void {
    if request.entered {
      this.PushDistrict(request);
    } else {
      this.PopDistrict(request);
    };
    this.Refresh();
    this.NotifySystem();
  }

  private final func PushDistrict(request: ref<DistrictEnteredEvent>) -> Void {
    let d: ref<District>;
    let i: Int32;
    let playerNotification: ref<PlayerEnteredNewDistrictEvent>;
    if !TDBID.IsValid(request.district) {
      return;
    };
    i = 0;
    while i < ArraySize(this.m_stack) {
      if this.m_stack[i].GetDistrictID() == request.district {
        ArrayErase(this.m_stack, i);
        break;
      };
      i += 1;
    };
    d = new District();
    d.Initialize(request.district);
    ArrayPush(this.m_stack, d);
    playerNotification = new PlayerEnteredNewDistrictEvent();
    playerNotification.gunshotRange = d.GetGunshotStimRange();
    playerNotification.explosionRange = d.GetExplosiveDeviceStimRange();
    GameInstance.GetPlayerSystem(this.m_system.GetGame()).GetLocalPlayerMainGameObject().QueueEvent(playerNotification);
  }

  private final func PopDistrict(request: ref<DistrictEnteredEvent>) -> Void {
    let i: Int32 = ArraySize(this.m_stack) - 1;
    while i >= 0 {
      if this.m_stack[i].GetDistrictID() == request.district {
        ArrayErase(this.m_stack, i);
        return;
      };
      i -= 1;
    };
  }

  private final func Refresh() -> Void {
    let blackboard: ref<IBlackboard>;
    let districtRecord: wref<District_Record>;
    let isNew: Bool;
    let d: wref<District> = this.GetCurrentDistrict();
    if !IsDefined(d) {
      return;
    };
    if !ArrayContains(this.m_visitedDistricts, d.GetDistrictID()) {
      ArrayPush(this.m_visitedDistricts, d.GetDistrictID());
      isNew = true;
    };
    districtRecord = d.GetDistrictRecord();
    blackboard = GameInstance.GetBlackboardSystem(this.m_system.GetGame()).Get(GetAllBlackboardDefs().UI_Map);
    if IsDefined(blackboard) {
      blackboard.SetString(GetAllBlackboardDefs().UI_Map.currentLocationEnumName, districtRecord.EnumName(), true);
      blackboard.SetString(GetAllBlackboardDefs().UI_Map.currentLocation, districtRecord.LocalizedName(), true);
      blackboard.SetBool(GetAllBlackboardDefs().UI_Map.newLocationDiscovered, isNew, true);
    };
    GameInstance.GetTelemetrySystem(this.m_system.GetGame()).LogDistrictChanged(districtRecord.EnumName(), isNew);
  }

  private final func NotifySystem() -> Void {
    let request: ref<RefreshDistrictRequest> = new RefreshDistrictRequest();
    request.preventionPreset = TweakDBInterface.GetDistrictPreventionDataRecord(this.GetCurrentDistrict().GetPresetID());
    this.m_system.QueueRequest(request);
  }

  public final const func GetCurrentDistrict() -> wref<District> {
    let size: Int32 = ArraySize(this.m_stack);
    if size == 0 {
      return null;
    };
    return this.m_stack[size - 1];
  }
}
