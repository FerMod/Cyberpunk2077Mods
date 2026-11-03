
public abstract class AIEvents extends IScriptable {

  public final static func ExitVehicleEvent() -> ref<AIEvent> {
    let evt: ref<AIEvent> = new AIEvent();
    evt.name = n"ExitVehicle";
    return evt;
  }
}

public final native class StimuliEvent extends BaseStimuliEvent {

  public native let sourcePosition: Vector4;

  public native let sourceObject: wref<GameObject>;

  public native let stimRecord: wref<Stim_Record>;

  public native let radius: Float;

  public native let detection: Float;

  public native let data: ref<StimuliData>;

  public native let stimPropagation: gamedataStimPropagation;

  public native let stimInvestigateData: stimInvestigateData;

  public native let movePositions: [Vector4];

  private native let stimType: gamedataStimType;

  private native let purelyDirect: Bool;

  public edit let id: Uint32;

  public final func SetStimType(newStimType: gamedataStimType) -> Void {
    this.name = EnumValueToName(n"gamedataStimType", Cast<Int64>(EnumInt(newStimType)));
    this.stimType = newStimType;
  }

  public final const func GetStimType() -> gamedataStimType {
    return this.stimType;
  }

  public final func SetPurelyDirect(pureDirect: Bool) -> Void {
    this.purelyDirect = pureDirect;
  }

  public final const func IsPurelyDirect() -> Bool {
    return this.purelyDirect;
  }

  public final native const func IsTagInStimuli(tag: CName) -> Bool;

  public final const func GetStimInterval() -> Float {
    let interval: Float = this.stimRecord.Interval();
    if interval <= 0.00 {
      return 1.00;
    };
    return interval;
  }

  public final func IsVisual() -> Bool {
    return Equals(this.stimPropagation, gamedataStimPropagation.Visual);
  }

  public final func IsAudio() -> Bool {
    return Equals(this.stimPropagation, gamedataStimPropagation.Audio);
  }

  public final func IsCategory(category: CName) -> Bool {
    return Equals(this.stimRecord.Category(), category);
  }
}

public class SendAIBheaviorReactionStim extends AIbehaviortaskScript {

  public edit let stimToSend: gamedataStimType;

  protected func Activate(context: ScriptExecutionContext) -> Void {
    let broadcaster: ref<StimBroadcasterComponent> = ScriptExecutionContext.GetOwner(context).GetStimBroadcasterComponent();
    if IsDefined(broadcaster) {
      broadcaster.TriggerSingleBroadcast(ScriptExecutionContext.GetOwner(context), this.stimToSend);
    };
  }
}

public class StimuliSquadActionEvent extends BaseStimuliEvent {

  public edit let squadActionName: CName;

  public edit let squadVerb: EAISquadVerb;

  public final func GetDescription() -> String {
    return NameToString(this.squadActionName) + " " + ToString(this.squadVerb);
  }
}
