
public class RelicPerkSystem extends ScriptableSystem {

  private persistent let m_registeredPerkDevices: [ref<PerkDeviceMappinData>];

  private func OnRestored(saveVersion: Int32, gameVersion: Int32) -> Void {
    this.RegisterMappins();
  }

  private final func RegisterMappins() -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_registeredPerkDevices) {
      if !this.m_registeredPerkDevices[i].IsUsed() {
        this.RegisterMappinInMappinSystem(this.m_registeredPerkDevices[i]);
      };
      i += 1;
    };
  }

  protected final func OnRegisterPerkDeviceMappinRequest(request: ref<RegisterPerkDeviceMappinRequest>) -> Void {
    let perkDeviceMappinData: ref<PerkDeviceMappinData>;
    if !this.TryGetPerkDeviceMappinData(request.m_ownerID, perkDeviceMappinData) {
      perkDeviceMappinData = this.CreatePerkDeviceMappinData(request);
      this.RegisterMappinInMappinSystem(perkDeviceMappinData);
    } else {
      if NotEquals(perkDeviceMappinData.GetPosition(), request.m_position) {
        perkDeviceMappinData.SetPosition(request.m_position);
        GameInstance.GetMappinSystem(this.GetGameInstance()).SetMappinPosition(perkDeviceMappinData.GetMappinID(), request.m_position);
      };
    };
  }

  private final func CreatePerkDeviceMappinData(request: ref<RegisterPerkDeviceMappinRequest>) -> ref<PerkDeviceMappinData> {
    let perkDeviceMappinData: ref<PerkDeviceMappinData> = new PerkDeviceMappinData();
    perkDeviceMappinData.SetOwnerID(request.m_ownerID);
    perkDeviceMappinData.SetPosition(request.m_position);
    ArrayPush(this.m_registeredPerkDevices, perkDeviceMappinData);
    return perkDeviceMappinData;
  }

  private final func IsOwnerRegistered(ownerID: EntityID) -> Bool {
    let i: Int32 = 0;
    while i < ArraySize(this.m_registeredPerkDevices) {
      if this.m_registeredPerkDevices[i].GetOwnerID() == ownerID {
        return true;
      };
      i += 1;
    };
    return false;
  }

  private final func IsMappinRegistered(perkDeviceMappinData: ref<PerkDeviceMappinData>) -> Bool {
    let mappinID: NewMappinID;
    return NotEquals(perkDeviceMappinData.GetMappinID(), mappinID);
  }

  private final func RegisterMappinInMappinSystem(perkDeviceMappinData: ref<PerkDeviceMappinData>) -> Void {
    let mappinID: NewMappinID = GameInstance.GetMappinSystem(this.GetGameInstance()).RegisterMappin(this.GetMappinData(), perkDeviceMappinData.GetPosition());
    perkDeviceMappinData.SetMappinID(mappinID);
  }

  private final func GetMappinData() -> MappinData {
    let mappinData: MappinData;
    mappinData.mappinType = t"Mappins.PerkDeviceMappinDefinition";
    mappinData.variant = gamedataMappinVariant.Zzz16_RelicDeviceBasicVariant;
    mappinData.active = true;
    mappinData.visibleThroughWalls = true;
    return mappinData;
  }

  protected final func OnSetPerkDeviceAsUsedRequest(request: ref<SetPerkDeviceAsUsedRequest>) -> Void {
    let perkDeviceMappinData: ref<PerkDeviceMappinData>;
    if this.TryGetPerkDeviceMappinData(request.m_ownerID, perkDeviceMappinData) && !perkDeviceMappinData.IsUsed() && this.IsMappinRegistered(perkDeviceMappinData) {
      perkDeviceMappinData.SetAsUsed();
      GameInstance.GetMappinSystem(this.GetGameInstance()).UnregisterMappin(perkDeviceMappinData.GetMappinID());
    };
  }

  private final func TryGetPerkDeviceMappinData(ownerID: EntityID, out perkDeviceMappinData: ref<PerkDeviceMappinData>) -> Bool {
    let i: Int32 = 0;
    while i < ArraySize(this.m_registeredPerkDevices) {
      if this.m_registeredPerkDevices[i].GetOwnerID() == ownerID {
        perkDeviceMappinData = this.m_registeredPerkDevices[i];
        return true;
      };
      i += 1;
    };
    return false;
  }
}

public class PerkDeviceMappinData extends IScriptable {

  private persistent let m_ownerID: EntityID;

  @default(PerkDeviceMappinData, false)
  private persistent let m_isUsed: Bool;

  private persistent let m_position: Vector4;

  private let m_mappinID: NewMappinID;

  public final func SetOwnerID(ownerID: EntityID) -> Void {
    this.m_ownerID = ownerID;
  }

  public final func GetOwnerID() -> EntityID {
    return this.m_ownerID;
  }

  public final func SetPosition(position: Vector4) -> Void {
    this.m_position = position;
  }

  public final func GetPosition() -> Vector4 {
    return this.m_position;
  }

  public final func SetMappinID(mappinID: NewMappinID) -> Void {
    this.m_mappinID = mappinID;
  }

  public final func GetMappinID() -> NewMappinID {
    return this.m_mappinID;
  }

  public final func IsUsed() -> Bool {
    return this.m_isUsed;
  }

  public final func SetAsUsed() -> Void {
    this.m_isUsed = true;
  }
}
