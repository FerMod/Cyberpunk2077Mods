
public class NewPerksPerkContainerLogicController extends inkLogicController {

  private edit let m_slotIdentifier: gamedataNewPerkSlotType;

  private edit let m_perkWidget: inkWidgetRef;

  private edit const let m_wiresConnections: [NewPerksWireConnection];

  protected cb func OnInitialize() -> Bool {
    this.ClearLines();
  }

  public final func GetSlotIdentifier() -> gamedataNewPerkSlotType {
    return this.m_slotIdentifier;
  }

  public final func GetPerkWidget() -> inkWidgetRef {
    return this.m_perkWidget;
  }

  public final func GetPerkWidgetController() -> wref<NewPerksPerkItemLogicController> {
    return inkWidgetRef.GetController(this.m_perkWidget) as NewPerksPerkItemLogicController;
  }

  public final func SetEnabled(value: Bool) -> Void {
    inkWidgetRef.SetVisible(this.m_perkWidget, value);
  }

  public final func SetLinesState(perk: gamedataNewPerkSlotType) -> Void {
    this.SetLinesState(perk, NewPerksWireState.All);
  }

  public final func SetLinesState(slot: gamedataNewPerkSlotType, state: NewPerksWireState) -> Void {
    let i: Int32;
    let iLimit: Int32;
    let j: Int32;
    let jLimit: Int32;
    let styleState: CName;
    switch state {
      case NewPerksWireState.Default:
        styleState = n"Default";
        break;
      case NewPerksWireState.Available:
        styleState = n"Available";
        break;
      case NewPerksWireState.Bought:
        styleState = n"Bought";
    };
    i = 0;
    iLimit = ArraySize(this.m_wiresConnections);
    while i < iLimit {
      if Equals(this.m_wiresConnections[i].m_targetSlot, slot) || Equals(state, NewPerksWireState.All) {
        j = 0;
        jLimit = ArraySize(this.m_wiresConnections[i].m_wires);
        while j < jLimit {
          inkWidgetRef.SetState(this.m_wiresConnections[i].m_wires[j], styleState);
          j += 1;
        };
      };
      i += 1;
    };
  }

  public final func ClearLines() -> Void {
    let j: Int32;
    let jLimit: Int32;
    let i: Int32 = 0;
    let iLimit: Int32 = ArraySize(this.m_wiresConnections);
    while i < iLimit {
      j = 0;
      jLimit = ArraySize(this.m_wiresConnections[i].m_wires);
      while j < jLimit {
        inkWidgetRef.SetVisible(this.m_wiresConnections[i].m_wires[j], false);
        j += 1;
      };
      i += 1;
    };
  }

  public final func AddLine(lineTarget: gamedataNewPerkSlotType, perks: script_ref<[wref<NewPerk_Record>]>) -> Void {
    let dependanciesMet: Bool;
    let j: Int32;
    let jLimit: Int32;
    let i: Int32 = 0;
    let iLimit: Int32 = ArraySize(this.m_wiresConnections);
    while i < iLimit {
      if NotEquals(this.m_wiresConnections[i].m_targetSlot, lineTarget) {
      } else {
        j = 0;
        jLimit = ArraySize(this.m_wiresConnections[i].m_wires);
        while j < jLimit {
          dependanciesMet = this.ConnectionDependanciesMet(this.m_wiresConnections[i], perks);
          inkWidgetRef.SetVisible(this.m_wiresConnections[i].m_wires[j], dependanciesMet);
          j += 1;
        };
      };
      i += 1;
    };
  }

  private final func ConnectionDependanciesMet(connection: script_ref<NewPerksWireConnection>, perks: script_ref<[wref<NewPerk_Record>]>) -> Bool {
    let dependancyPresent: Bool;
    let perkRecord: wref<NewPerk_Record>;
    let requiredPerks: array<wref<NewPerk_Record>>;
    let slotType: gamedataNewPerkSlotType;
    let result: Bool = true;
    let i: Int32 = 0;
    while i < ArraySize(Deref(connection).m_connectionDependancies) {
      slotType = Deref(connection).m_connectionDependancies[i];
      perkRecord = this.GetPerkBySlotType(slotType, perks);
      if perkRecord == null {
        result = result && !Deref(connection).m_dependanciesPresenceToggle;
      } else {
        perkRecord.RequiresPerks(requiredPerks);
        dependancyPresent = ArrayContains(requiredPerks, this.GetPerkWidgetController().GetPerkRecord());
        result = result && Equals(dependancyPresent, Deref(connection).m_dependanciesPresenceToggle);
      };
      i += 1;
    };
    return result;
  }

  private final func GetPerkBySlotType(slotType: gamedataNewPerkSlotType, perks: script_ref<[wref<NewPerk_Record>]>) -> wref<NewPerk_Record> {
    let i: Int32 = 0;
    while i < ArraySize(Deref(perks)) {
      if Equals(Deref(perks)[i].Slot().Type(), slotType) {
        return Deref(perks)[i];
      };
      i += 1;
    };
    return null;
  }

  public final func GetWires(target: gamedataNewPerkSlotType) -> [inkWidgetRef] {
    let emptyResult: array<inkWidgetRef>;
    let i: Int32 = 0;
    let limit: Int32 = ArraySize(this.m_wiresConnections);
    while i < limit {
      if Equals(this.m_wiresConnections[i].m_targetSlot, target) {
        if this.AreConnectionWiresVisible(this.m_wiresConnections[i]) {
          return this.m_wiresConnections[i].m_wires;
        };
      };
      i += 1;
    };
    return emptyResult;
  }

  public final func GetWiresWithTargetBlacklist(targetBlacklist: script_ref<[gamedataNewPerkSlotType]>) -> [inkWidgetRef] {
    let j: Int32;
    let resultArray: array<inkWidgetRef>;
    let i: Int32 = 0;
    while i < ArraySize(this.m_wiresConnections) {
      if this.AreConnectionWiresVisible(this.m_wiresConnections[i]) {
        if !ArrayContains(Deref(targetBlacklist), this.m_wiresConnections[i].m_targetSlot) {
          j = 0;
          while j < ArraySize(this.m_wiresConnections[i].m_wires) {
            ArrayPush(resultArray, this.m_wiresConnections[i].m_wires[j]);
            j += 1;
          };
        };
      };
      i += 1;
    };
    return resultArray;
  }

  public final func AreAnyWiresActive() -> Bool {
    let j: Int32;
    let widget: inkWidgetRef;
    let i: Int32 = 0;
    while i < ArraySize(this.m_wiresConnections) {
      j = 0;
      while j < ArraySize(this.m_wiresConnections[i].m_wires) {
        widget = this.m_wiresConnections[i].m_wires[j];
        if inkWidgetRef.IsVisible(widget) && Equals(inkWidgetRef.GetState(widget), n"Bought") {
          return true;
        };
        j += 1;
      };
      i += 1;
    };
    return false;
  }

  private final func AreConnectionWiresVisible(connection: script_ref<NewPerksWireConnection>) -> Bool {
    return ArraySize(Deref(connection).m_wires) > 0 && inkWidgetRef.IsVisible(Deref(connection).m_wires[0]);
  }
}
