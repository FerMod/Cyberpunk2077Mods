
public class HoloTable extends InteractiveDevice {

  public edit let componentCounter: Int32;

  public let m_meshTable: [ref<MeshComponent>];

  public let m_currentMesh: Int32;

  public let m_glitchMesh: ref<MeshComponent>;

  public const func GetDevicePS() -> ref<HoloTableControllerPS> {
    return this.GetController().GetPS();
  }

  protected const func GetController() -> ref<HoloTableController> {
    return this.m_controller as HoloTableController;
  }

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    let compName: String;
    let i: Int32 = 0;
    while i < this.componentCounter {
      compName = "mesh" + i;
      EntityRequestComponentsInterface.RequestComponent(ri, StringToName(compName), n"MeshComponent", false);
      i += 1;
    };
    EntityRequestComponentsInterface.RequestComponent(ri, n"GlitchMesh", n"MeshComponent", false);
    super.OnRequestComponents(ri);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    let compName: String;
    let i: Int32 = 0;
    while i < this.componentCounter {
      compName = "mesh" + i;
      ArrayPush(this.m_meshTable, EntityResolveComponentsInterface.GetComponent(ri, StringToName(compName)) as MeshComponent);
      i += 1;
    };
    this.m_glitchMesh = EntityResolveComponentsInterface.GetComponent(ri, n"GlitchMesh") as MeshComponent;
    super.OnTakeControl(ri);
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as HoloTableController;
  }

  protected func ResolveGameplayState() -> Void {
    super.ResolveGameplayState();
    this.GetDevicePS().SetMeshesAmount(this.componentCounter);
    this.SetActiveMesh();
  }

  protected final func SetActiveMesh() -> Void {
    if Equals(this.GetDeviceState(), EDeviceStatus.ON) {
      this.m_meshTable[this.m_currentMesh].Toggle(false);
      this.m_meshTable[this.GetDevicePS().GetActiveStationIndex()].Toggle(true);
      this.m_currentMesh = this.GetDevicePS().GetActiveStationIndex();
    } else {
      this.TurnOffMeshes();
    };
  }

  protected final func TurnOffMeshes() -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_meshTable) {
      this.m_meshTable[this.GetDevicePS().GetActiveStationIndex()].Toggle(false);
      i += 1;
    };
    GameObjectEffectHelper.StopEffectEvent(this, n"light_cone_dust");
  }

  protected cb func OnNextStation(evt: ref<NextStation>) -> Bool {
    this.SetActiveMesh();
    this.UpdateDeviceState();
  }

  protected cb func OnPreviousStation(evt: ref<PreviousStation>) -> Bool {
    this.SetActiveMesh();
    this.UpdateDeviceState();
  }

  protected func TurnOnDevice() -> Void {
    GameObjectEffectHelper.StartEffectEvent(this, n"light_cone_dust");
    this.SetActiveMesh();
    this.UpdateDeviceState();
  }

  protected func TurnOffDevice() -> Void {
    super.TurnOffDevice();
    this.TurnOffMeshes();
    this.UpdateDeviceState();
  }

  protected func CutPower() -> Void {
    super.CutPower();
    this.TurnOffMeshes();
    this.UpdateDeviceState();
  }

  protected func DeactivateDevice() -> Void {
    super.DeactivateDevice();
    this.TurnOffMeshes();
  }

  protected const func DeterminGameplayRole() -> EGameplayRole {
    return EGameplayRole.Distract;
  }

  protected func StartGlitching(glitchState: EGlitchState, opt intensity: Float) -> Void {
    this.TurnOffMeshes();
    if IsDefined(this.m_glitchMesh) {
      this.m_glitchMesh.Toggle(true);
    };
  }

  protected func StopGlitching() -> Void {
    if IsDefined(this.m_glitchMesh) {
      this.m_glitchMesh.Toggle(false);
    };
    if this.GetDevicePS().IsON() {
      this.SetActiveMesh();
    };
  }
}
