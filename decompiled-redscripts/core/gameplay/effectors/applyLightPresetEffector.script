
public class ApplyLightPresetEffector extends Effector {

  public let m_lightPreset: wref<LightPreset_Record>;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    this.m_lightPreset = TweakDBInterface.GetApplyLightPresetEffectorRecord(record).LightPreset();
  }

  protected func ActionOn(owner: ref<GameObject>) -> Void {
    let lightPreset: wref<LightPreset_Record>;
    let toggleLightEvent: ref<ToggleLightEvent> = new ToggleLightEvent();
    toggleLightEvent.toggle = this.m_lightPreset.On();
    owner.QueueEvent(toggleLightEvent);
    lightPreset = this.m_lightPreset;
    if this.m_lightPreset.OverrideColorMin() {
      this.SendChangeLightEvent(owner, lightPreset.ColorMin(), 1.00, 0.00, n"None", false);
    };
    this.SendChangeLightEvent(owner, lightPreset.ColorMax(), lightPreset.Strength(), lightPreset.Time(), lightPreset.Curve(), lightPreset.Loop());
  }

  protected final func SendChangeLightEvent(owner: wref<GameObject>, const colorValues: script_ref<[Int32]>, strength: Float, time: Float, curve: CName, loop: Bool) -> Void {
    let lightSettings: ScriptLightSettings;
    lightSettings.color = new Color(Cast<Uint8>(Deref(colorValues)[0]), Cast<Uint8>(Deref(colorValues)[1]), Cast<Uint8>(Deref(colorValues)[2]), Cast<Uint8>(Deref(colorValues)[3]));
    lightSettings.strength = strength;
    let changeLightEvent: ref<ChangeLightEvent> = new ChangeLightEvent();
    changeLightEvent.time = time;
    changeLightEvent.curve = curve;
    changeLightEvent.loop = loop;
    changeLightEvent.settings = lightSettings;
    owner.QueueEvent(changeLightEvent);
  }
}
