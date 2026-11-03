
public class InteractiveAd extends InteractiveDevice {

  protected let m_triggerComponent: ref<TriggerComponent>;

  protected let m_triggerExitComponent: ref<TriggerComponent>;

  protected let m_aduiComponent: ref<worlduiWidgetComponent>;

  protected let m_showAd: Bool;

  protected let m_showVendor: Bool;

  protected cb func OnRequestComponents(ri: EntityRequestComponentsInterface) -> Bool {
    super.OnRequestComponents(ri);
    EntityRequestComponentsInterface.RequestComponent(ri, n"trigger", n"gameStaticTriggerAreaComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"triggerExit", n"gameStaticTriggerAreaComponent", false);
    EntityRequestComponentsInterface.RequestComponent(ri, n"ui", n"worlduiWidgetComponent", false);
  }

  protected cb func OnTakeControl(ri: EntityResolveComponentsInterface) -> Bool {
    super.OnTakeControl(ri);
    this.m_triggerComponent = EntityResolveComponentsInterface.GetComponent(ri, n"trigger") as TriggerComponent;
    this.m_triggerExitComponent = EntityResolveComponentsInterface.GetComponent(ri, n"triggerExit") as TriggerComponent;
    this.m_uiComponent = EntityResolveComponentsInterface.GetComponent(ri, n"ui") as worlduiWidgetComponent;
    this.m_controller = EntityResolveComponentsInterface.GetComponent(ri, n"controller") as InteractiveAdController;
  }

  public const func GetBlackboardDef() -> ref<InteractiveDeviceBlackboardDef> {
    return this.GetDevicePS().GetBlackboardDef();
  }

  protected func CreateBlackboard() -> Void {
    this.m_blackboard = IBlackboard.Create(GetAllBlackboardDefs().InteractiveDeviceBlackboard);
  }

  private const func GetController() -> ref<InteractiveAdController> {
    return this.m_controller as InteractiveAdController;
  }

  public const func GetDevicePS() -> ref<InteractiveAdControllerPS> {
    return this.GetController().GetPS();
  }

  protected func ResolveGameplayState() -> Void {
    super.ResolveGameplayState();
    if this.IsUIdirty() && this.m_isInsideLogicArea {
      this.RefreshUI();
    };
  }

  protected cb func OnGameAttached() -> Bool {
    super.OnGameAttached();
  }

  protected cb func OnDetach() -> Bool {
    super.OnDetach();
  }

  protected func PushPersistentData() -> Void {
    super.PushPersistentData();
  }

  protected final func DelayInteractiveAdEvent() -> Void {
    let evt: ref<InteractiveAdFinishedEvent> = new InteractiveAdFinishedEvent();
    GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(this, evt, 1.00);
  }

  protected cb func OnInteractiveAdFinishedEvent(evt: ref<InteractiveAdFinishedEvent>) -> Bool {
    this.GetDevicePS().SetIsReady(this.m_showAd);
    this.GetBlackboard().SetBool(this.GetBlackboardDef().showVendor, false);
    this.GetBlackboard().FireCallbacks();
    this.RefreshUI();
  }

  protected cb func OnCloseAd(evt: ref<CloseAd>) -> Bool {
    this.m_showAd = false;
    this.GetBlackboard().SetBool(this.GetBlackboardDef().showAd, false);
    this.GetBlackboard().FireCallbacks();
    this.RefreshUI();
  }

  protected cb func OnShowVendor(evt: ref<ShowVendor>) -> Bool {
    this.m_showAd = false;
    this.GetBlackboard().SetBool(this.GetBlackboardDef().showVendor, true);
    this.GetBlackboard().FireCallbacks();
    this.GetDevicePS().AddLocation(true);
    SetFactValue(this.GetGame(), n"q001_show_vendingmachine_mappin", 1);
    GameObject.PlaySoundEvent(this, n"amb_int_custom_megabuilding_01_adverts_interactive_nicola_01_select");
    this.DelayInteractiveAdEvent();
    this.DetermineInteractionStateByTask(this.GetDevicePS().GenerateContext(gamedeviceRequestType.Direct, Device.GetInteractionClearance(), GameInstance.GetPlayerSystem(this.GetGame()).GetLocalPlayerMainGameObject(), this.GetEntityID()));
    this.RefreshUI();
  }

  protected cb func OnAreaEnter(evt: ref<AreaEnteredEvent>) -> Bool {
    if Equals(evt.componentName, n"trigger") && IsDefined(EntityGameInterface.GetEntity(evt.activator) as PlayerPuppet) {
      GameObject.PlaySoundEvent(this, n"amb_int_custom_megabuilding_01_adverts_interactive_nicola_01_approach");
      this.m_showAd = true;
      this.GetBlackboard().SetBool(this.GetBlackboardDef().showAd, true);
      this.GetBlackboard().FireCallbacks();
      this.GetDevicePS().SetIsReady(this.m_showAd);
      this.RefreshUI();
    };
  }

  protected cb func OnAreaExit(evt: ref<AreaExitedEvent>) -> Bool {
    if Equals(evt.componentName, n"trigger") && IsDefined(EntityGameInterface.GetEntity(evt.activator) as PlayerPuppet) {
      GameObject.PlaySoundEvent(this, n"amb_int_custom_megabuilding_01_adverts_interactive_nicola_01_stop");
      this.m_showAd = false;
      this.GetBlackboard().SetBool(this.GetBlackboardDef().showAd, false);
      this.GetBlackboard().FireCallbacks();
      this.GetDevicePS().SetIsReady(this.m_showAd);
      this.RefreshUI();
    };
  }
}
