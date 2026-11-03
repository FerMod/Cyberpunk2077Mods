
public class DelamainTaxiSystem extends ScriptableSystem {

  private let m_isDelamainTaxiEnabledOnMap: Bool;

  private let m_delamainMappinID: NewMappinID;

  private let m_currentTravelCost: Int32;

  @default(DelamainTaxiSystem, false)
  private let m_HUDHidden: Bool;

  private let m_delamainTaxi: wref<DelamainTaxiComponent>;

  public final const func IsDelamainTaxiEnabledOnMap() -> Bool {
    return this.m_isDelamainTaxiEnabledOnMap;
  }

  public final const func HasActiveDestination() -> Bool {
    return this.m_delamainMappinID.value != 0u;
  }

  public final const func GetTravelCost() -> Int32 {
    return this.m_currentTravelCost;
  }

  private final func OnSetTravelDestinationRequest(request: ref<SetTravelDestinationRequest>) -> Void {
    this.m_delamainMappinID = request.mappinID;
    this.m_currentTravelCost = request.cost;
  }

  private final func OnRegisterDelamainTaxiRequest(request: ref<RegisterDelamainTaxiRequest>) -> Void {
    this.m_delamainTaxi = request.delamainTaxi;
  }

  private final func OnDelamainTaxiArrivedRequest(request: ref<DelamainTaxiArrivedRequest>) -> Void {
    this.m_delamainMappinID.value = 0u;
    this.m_delamainTaxi.OnDelamainTaxiArrivedEvent();
  }

  private final func OnStartDelamainTaxiRequest(request: ref<StartDelamainTaxiRequest>) -> Void {
    this.m_delamainTaxi.StartAutoDrive();
    this.m_currentTravelCost = request.m_price;
  }

  private final func OnCancelDelamainRideRequest(request: ref<CancelDelamainRideRequest>) -> Void {
    this.m_delamainTaxi.CancelRide(request.forceExit);
  }

  private final func OnDelamainTaxiCancelledRequest(request: ref<DelamainTaxiCancelledRequest>) -> Void {
    GameInstance.GetMappinSystem(this.GetGameInstance()).UnregisterMappin(this.m_delamainMappinID);
    this.m_delamainMappinID.value = 0u;
  }

  private final func OnDelamainTaxiMenuToggledRequest(evt: ref<DelamainTaxiMenuToggledEvent>) -> Void {
    this.m_isDelamainTaxiEnabledOnMap = evt.isEnabled;
  }

  private final func OnUnregisterCurrentTaxiRequest(evt: ref<UnregisterCurrentTaxiRequest>) -> Void {
    let vehicle: ref<VehicleObject> = this.m_delamainTaxi.GetOwner() as VehicleObject;
    GameInstance.GetVehicleSystem(this.GetGameInstance()).UnregisterPlayerVehicle(Cast<GarageVehicleID>(vehicle.GetRecordID()));
    this.m_delamainTaxi = null;
  }

  private final func OnSetHUDHiddenRequest(request: ref<SetHUDHiddenRequest>) -> Void {
    if Equals(this.m_HUDHidden, request.hidden) {
      return;
    };
    this.m_HUDHidden = request.hidden;
    if this.m_HUDHidden {
      GameInstance.GetUISystem(this.GetGameInstance()).PushGameContext(UIGameContext.DelamainTaxi);
    } else {
      GameInstance.GetUISystem(this.GetGameInstance()).PopGameContext(UIGameContext.DelamainTaxi);
    };
  }

  private final func OnPayTravelRequest(request: ref<PayTravelRequest>) -> Void {
    let player: ref<GameObject> = GetPlayer(this.GetGameInstance());
    let transactionSystem: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGameInstance());
    transactionSystem.RemoveItem(player, MarketSystem.Money(), this.m_currentTravelCost);
  }

  private final func OnCancelDriveIfNecessaryRequest(request: ref<CancelDriveIfNecessaryRequest>) -> Void {
    if IsDefined(this.m_delamainTaxi) && this.m_delamainMappinID.value != 0u {
      this.m_delamainTaxi.CancelRide(false);
    };
  }
}
