
public class NcartStationMarker extends GameObject {

  protected let m_station: ENcartStations;

  @default(NcartStationMarker, true)
  protected let m_callBackOnlyIfMatchesDestination: Bool;

  @default(NcartStationMarker, true)
  protected let m_setAsNewActive: Bool;

  @default(NcartStationMarker, ue_metro_arriving_at_station)
  protected let m_onTrainApproachingFact: CName;

  protected let m_TrainGlobalRef: CName;

  protected cb func OnAreaEnter(trigger: ref<AreaEnteredEvent>) -> Bool {
    let nextStation: Int32;
    let vehicle: wref<VehicleObject> = EntityGameInterface.GetEntity(trigger.activator) as VehicleObject;
    if vehicle == (vehicle as ncartMetroObject) {
      nextStation = GameInstance.GetQuestsSystem(this.GetGame()).GetFact(n"ue_metro_next_station");
      if this.GetMetroStationNumber(this.m_station) != nextStation && this.m_callBackOnlyIfMatchesDestination {
        return false;
      };
      if this.m_setAsNewActive {
        GameInstance.GetQuestsSystem(this.GetGame()).SetFact(n"ue_metro_active_station", this.GetMetroStationNumber(this.m_station));
      };
      GameInstance.GetQuestsSystem(this.GetGame()).SetFact(this.m_onTrainApproachingFact, 1);
    };
  }

  protected cb func OnAreaExit(trigger: ref<AreaExitedEvent>) -> Bool;

  private final const func GetMetroStationNumber(stationName: ENcartStations) -> Int32 {
    switch stationName {
      case ENcartStations.ARASAKA_WATERFRONT:
        return 1;
      case ENcartStations.LITTLE_CHINA_HOSPITAL:
        return 2;
      case ENcartStations.LITTLE_CHINA_NORTH:
        return 3;
      case ENcartStations.LITTLE_CHINA_SOUTH:
        return 4;
      case ENcartStations.JAPAN_TOWN_NORTH:
        return 5;
      case ENcartStations.JAPAN_TOWN_SOUTH:
        return 6;
      case ENcartStations.DOWNTOWN_NORTH:
        return 7;
      case ENcartStations.ARROYO:
        return 8;
      case ENcartStations.CITY_CENTER:
        return 9;
      case ENcartStations.ARASAKA_TOWER:
        return 10;
      case ENcartStations.WELLSPRINGS:
        return 11;
      case ENcartStations.GLEN_NORTH:
        return 12;
      case ENcartStations.GLEN_SOUTH:
        return 13;
      case ENcartStations.VISTA_DEL_REY:
        return 14;
      case ENcartStations.RANCHO_CORONADO:
        return 15;
      case ENcartStations.LITTLE_CHINA_MEGABUILDING:
        return 16;
      case ENcartStations.CHARTER_HILL:
        return 17;
      case ENcartStations.GLEN_EBUNIKE:
        return 18;
      case ENcartStations.PACIFICA_STADIUM:
        return 19;
    };
    return 0;
  }
}
