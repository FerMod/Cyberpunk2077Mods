
public class CrosshairWeaponStatsListener extends ScriptStatsListener {

  private let m_controller: wref<BaseTechCrosshairController>;

  public final func Init(controller: ref<BaseTechCrosshairController>, stat: gamedataStatType) -> Void {
    this.m_controller = controller;
    this.SetStatType(stat);
  }

  public func OnStatChanged(ownerID: StatsObjectID, statType: gamedataStatType, diff: Float, total: Float) -> Void {
    this.m_controller.OnCrosshairWeaponStatChanged(ownerID, statType, diff, total);
  }
}

public class BaseTechCrosshairController extends gameuiCrosshairBaseGameController {

  private let m_player: wref<GameObject>;

  private let m_statsSystem: ref<StatsSystem>;

  private let m_fullChargeAvailable: Bool;

  private let m_overChargeAvailable: Bool;

  private let m_fullChargeListener: ref<CrosshairWeaponStatsListener>;

  private let m_overChargeListener: ref<CrosshairWeaponStatsListener>;

  protected cb func OnInitialize() -> Bool {
    this.m_player = this.GetPlayerControlledObject();
    this.m_statsSystem = GameInstance.GetStatsSystem(this.m_player.GetGame());
    this.m_fullChargeAvailable = this.m_statsSystem.GetStatBoolValue(Cast<StatsObjectID>(this.m_player.GetEntityID()), gamedataStatType.CanFullyChargeWeapon);
    this.m_overChargeAvailable = this.m_statsSystem.GetStatBoolValue(Cast<StatsObjectID>(this.m_player.GetEntityID()), gamedataStatType.CanOverchargeWeapon);
    this.m_fullChargeListener = new CrosshairWeaponStatsListener();
    this.m_fullChargeListener.Init(this, gamedataStatType.CanFullyChargeWeapon);
    this.m_statsSystem.RegisterListener(Cast<StatsObjectID>(this.m_player.GetEntityID()), this.m_fullChargeListener);
    this.m_overChargeListener = new CrosshairWeaponStatsListener();
    this.m_overChargeListener.Init(this, gamedataStatType.CanOverchargeWeapon);
    this.m_statsSystem.RegisterListener(Cast<StatsObjectID>(this.m_player.GetEntityID()), this.m_overChargeListener);
    inkWidgetRef.SetVisible(this.m_deadEyeWidget, false);
  }

  protected cb func OnUnitialize() -> Bool {
    if IsDefined(this.m_player) {
      this.m_statsSystem.UnregisterListener(Cast<StatsObjectID>(this.m_player.GetEntityID()), this.m_fullChargeListener);
      this.m_statsSystem.UnregisterListener(Cast<StatsObjectID>(this.m_player.GetEntityID()), this.m_overChargeListener);
    };
  }

  public final func OnCrosshairWeaponStatChanged(ownerID: StatsObjectID, statType: gamedataStatType, diff: Float, total: Float) -> Void {
    switch statType {
      case gamedataStatType.CanFullyChargeWeapon:
        this.m_fullChargeAvailable = total > 0.00;
        this.OnWeaponChargingStatChanged();
        break;
      case gamedataStatType.CanOverchargeWeapon:
        this.m_overChargeAvailable = total > 0.00;
        this.OnWeaponChargingStatChanged();
    };
  }

  protected final func IsFullChargeAvailable() -> Bool {
    return this.m_fullChargeAvailable;
  }

  protected final func IsOverChargeAvailable() -> Bool {
    return this.m_overChargeAvailable;
  }

  protected final func GetCurrentChargeLimit() -> Float {
    let weaponObject: ref<WeaponObject> = this.GetWeaponItemObject() as WeaponObject;
    if this.IsOverChargeAvailable() {
      return WeaponObject.GetOverchargeThreshold(weaponObject);
    };
    if this.IsFullChargeAvailable() {
      return WeaponObject.GetFullyChargedThreshold(weaponObject);
    };
    return WeaponObject.GetBaseMaxChargeThreshold(weaponObject);
  }

  protected func OnWeaponChargingStatChanged() -> Void;
}
