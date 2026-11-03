
public class MemoryListener extends CustomValueStatPoolsListener {

  public let m_player: wref<PlayerPuppet>;

  public func OnStatPoolValueChanged(oldValue: Float, newValue: Float, percToPoints: Float) -> Void {
    let diff: Float;
    let maxHealth: Float;
    let uiBlackboard: ref<IBlackboard> = GameInstance.GetBlackboardSystem(this.m_player.GetGame()).Get(GetAllBlackboardDefs().UI_PlayerBioMonitor);
    uiBlackboard.SetFloat(GetAllBlackboardDefs().UI_PlayerBioMonitor.MemoryPercent, newValue);
    if GameInstance.GetStatsSystem(this.m_player.GetGame()).GetStatValue(Cast<StatsObjectID>(this.m_player.GetEntityID()), gamedataStatType.AutomaticReplenishment) != 0.00 {
      if FloorF(newValue) == 0 {
        GameInstance.GetStatPoolsSystem(this.m_player.GetGame()).RequestSettingStatPoolValue(Cast<StatsObjectID>(this.m_player.GetEntityID()), gamedataStatPoolType.Memory, 100.00, this.m_player);
      };
    };
    if PlayerDevelopmentSystem.GetData(this.m_player).IsNewPerkBoughtAnyLevel(gamedataNewPerkType.Intelligence_Central_Perk_3_2) && QuickHackableHelper.IsOverclockedStateActive(this.m_player) {
      diff = newValue - oldValue;
      if diff > 1.00 {
        maxHealth = GameInstance.GetStatsSystem(this.m_player.GetGame()).GetStatValue(Cast<StatsObjectID>(this.m_player.GetEntityID()), gamedataStatType.Health);
        if (maxHealth * diff) / 100.00 > 30.00 {
          diff = 30.00 / maxHealth * 100.00;
        };
        GameInstance.GetStatPoolsSystem(this.m_player.GetGame()).RequestChangingStatPoolValue(Cast<StatsObjectID>(this.m_player.GetEntityID()), gamedataStatPoolType.Health, diff, this.m_player, true);
      };
    };
  }
}

public class DelayedEhxautionSoundClue extends DelayCallback {

  private let m_puppet: wref<GameObject>;

  private let m_audioEventName: CName;

  public final static func Create(puppet: ref<GameObject>, audioEventName: CName) -> ref<DelayedEhxautionSoundClue> {
    let callback: ref<DelayedEhxautionSoundClue> = new DelayedEhxautionSoundClue();
    callback.m_puppet = puppet;
    callback.m_audioEventName = audioEventName;
    return callback;
  }

  public func Call() -> Void {
    GameObject.PlaySound(this.m_puppet, this.m_audioEventName);
  }
}

public class StaminaListener extends CustomValueStatPoolsListener {

  private let m_player: wref<PlayerPuppet>;

  private let m_psmAdded: Bool;

  private let m_staminaValue: Float;

  private let m_staminPerc: Float;

  private let m_sfxThreshold: Float;

  private let m_sfxDelay: Float;

  private let m_sfxName: CName;

  private let m_delayID: DelayID;

  public final func Init(player: wref<PlayerPuppet>) -> Void {
    this.m_psmAdded = false;
    this.m_player = player;
    this.m_staminaValue = 100.00;
    this.m_staminPerc = 100.00;
    this.m_sfxThreshold = TweakDBInterface.GetFloat(t"player.staminaSFXEvent.threshold", 0.00);
    this.m_sfxDelay = TweakDBInterface.GetFloat(t"player.staminaSFXEvent.delay", 0.00);
    this.m_sfxName = TweakDBInterface.GetCName(t"player.staminaSFXEvent.sfxName", n"None");
  }

  public func OnStatPoolValueChanged(oldValue: Float, newValue: Float, percToPoints: Float) -> Void {
    let addEvent: ref<PSMAddOnDemandStateMachine>;
    let removeEvent: ref<PSMRemoveOnDemandStateMachine>;
    let soundClue: ref<DelayedEhxautionSoundClue>;
    let stateMachineIdentifier: StateMachineIdentifier;
    let newValueNormalised: Float = newValue / 100.00;
    let oldValueNormalised: Float = oldValue / 100.00;
    this.m_staminPerc = newValue;
    this.m_staminaValue = newValue * percToPoints;
    let updateHandlingEvent: ref<UpdateEquippedWeaponsHandlingEvent> = new UpdateEquippedWeaponsHandlingEvent();
    updateHandlingEvent.currentStaminaValue = newValue / 100.00;
    this.m_player.QueueEvent(updateHandlingEvent);
    if !this.m_psmAdded && newValue < 100.00 {
      addEvent = new PSMAddOnDemandStateMachine();
      addEvent.stateMachineName = n"Stamina";
      this.m_player.QueueEvent(addEvent);
      this.m_psmAdded = true;
    } else {
      if this.m_psmAdded && newValue >= 100.00 {
        stateMachineIdentifier.definitionName = n"Stamina";
        removeEvent = new PSMRemoveOnDemandStateMachine();
        removeEvent.stateMachineIdentifier = stateMachineIdentifier;
        this.m_player.QueueEvent(removeEvent);
        this.m_psmAdded = false;
      };
    };
    if newValueNormalised < this.m_sfxThreshold && oldValueNormalised >= this.m_sfxThreshold {
      soundClue = DelayedEhxautionSoundClue.Create(this.m_player, this.m_sfxName);
      this.m_delayID = GameInstance.GetDelaySystem(this.m_player.GetGame()).DelayCallback(soundClue, this.m_sfxDelay, false);
    } else {
      if newValueNormalised >= this.m_sfxThreshold && oldValueNormalised < this.m_sfxThreshold {
        if this.m_delayID != GetInvalidDelayID() {
          GameInstance.GetDelaySystem(this.m_player.GetGame()).CancelCallback(this.m_delayID);
          this.m_delayID = GetInvalidDelayID();
        };
      };
    };
  }

  protected cb func OnStatPoolMinValueReached(value: Float) -> Bool {
    StatusEffectHelper.RemoveStatusEffect(this.m_player, t"BaseStatusEffect.OpticalCamoCoolPerkShort");
  }

  public final func GetStaminaValue() -> Float {
    return this.m_staminaValue;
  }

  public final func GetStaminaPerc() -> Float {
    return this.m_staminPerc;
  }
}

public class OxygenStatListener extends CustomValueStatPoolsListener {

  public let m_ownerPuppet: wref<PlayerPuppet>;

  public let m_oxygenVfxBlackboard: ref<worldEffectBlackboard>;

  protected cb func OnStatPoolValueReached(oldValue: Float, newValue: Float, percToPoints: Float) -> Bool {
    this.TestOxygenLevel(oldValue, newValue, percToPoints);
  }

  protected cb func OnStatPoolMinValueReached(value: Float) -> Bool {
    this.IsOutOfOxygen(true);
  }

  public func OnStatPoolValueChanged(oldValue: Float, newValue: Float, percToPoints: Float) -> Void {
    if newValue > 0.00 && oldValue <= 0.00 {
      this.IsOutOfOxygen(false);
    };
  }

  public final func IsOutOfOxygen(b: Bool) -> Void {
    let statusEffectSystem: ref<StatusEffectSystem> = GameInstance.GetStatusEffectSystem(this.m_ownerPuppet.GetGame());
    let statusEffectID: TweakDBID = t"BaseStatusEffect.OutOfOxygen";
    if Equals(b, true) && !statusEffectSystem.HasStatusEffect(this.m_ownerPuppet.GetEntityID(), statusEffectID) {
      statusEffectSystem.ApplyStatusEffect(this.m_ownerPuppet.GetEntityID(), statusEffectID, this.m_ownerPuppet.GetRecordID(), this.m_ownerPuppet.GetEntityID());
    } else {
      if Equals(b, false) && statusEffectSystem.HasStatusEffect(this.m_ownerPuppet.GetEntityID(), statusEffectID) {
        statusEffectSystem.RemoveStatusEffect(this.m_ownerPuppet.GetEntityID(), statusEffectID);
      };
    };
  }

  public final func TestOxygenLevel(oldValue: Float, newValue: Float, percToPoints: Float) -> Void {
    let critOxygenThreshold: Float = TweakDBInterface.GetFloat(t"player.oxygenThresholds.critOxygenThreshold", 10.00);
    if oldValue > critOxygenThreshold && newValue <= critOxygenThreshold {
      this.CriticalOxygenLevel(true);
    } else {
      if newValue >= critOxygenThreshold && oldValue <= critOxygenThreshold {
        this.CriticalOxygenLevel(false);
      };
    };
  }

  public final func CriticalOxygenLevel(b: Bool) -> Void {
    if Equals(b, true) {
      GameObject.PlaySound(this.m_ownerPuppet, n"oxygen_critical_start");
      GameObjectEffectHelper.StartEffectEvent(this.m_ownerPuppet, n"fx_oxygen_critical", false, this.m_oxygenVfxBlackboard);
    } else {
      GameObject.PlaySound(this.m_ownerPuppet, n"oxygen_critical_stop");
      GameObjectEffectHelper.BreakEffectLoopEvent(this.m_ownerPuppet, n"fx_oxygen_critical");
    };
  }
}

public class BaseChargesStatListener extends CustomValueStatPoolsListener {

  public let m_player: wref<PlayerPuppet>;

  public let m_playedCueAlready: Bool;

  public let m_currentCharges: Int32;

  public let m_currentStatPoolValue: Int32;

  public let m_rechargeSoundCue: CName;

  public let m_statSystem: ref<StatsSystem>;

  public let m_finalString: String;

  public func Init(player: wref<PlayerPuppet>) -> Void {
    this.m_player = player;
    this.m_playedCueAlready = false;
    this.m_currentCharges = -1;
    this.m_statSystem = GameInstance.GetStatsSystem(this.m_player.GetGame());
  }

  public func MaxStatPoolValue() -> Int32 {
    return Cast<Int32>(GameInstance.GetStatPoolsSystem(this.m_player.GetGame()).GetStatPoolMaxPointValue(Cast<StatsObjectID>(this.m_player.GetEntityID()), gamedataStatPoolType.HealingItemsCharges));
  }

  public func OnStatPoolValueChanged(oldValue: Float, newValue: Float, percToPoints: Float) -> Void {
    this.m_currentStatPoolValue = RoundMath(newValue * percToPoints);
    let charges: Int32 = this.m_currentStatPoolValue / this.GetRechargeDuration();
    if this.m_currentCharges == -1 {
      this.m_currentCharges = charges;
    };
    if charges != this.m_currentCharges {
      ConsumablesChargesHelper.HotkeyRefresh(this.m_player.GetGame());
      if charges > this.m_currentCharges {
        this.Recharged();
      };
      this.m_currentCharges = charges;
    };
  }

  protected func GetActiveItem(hotkey: EHotkey) -> ref<Item_Record> {
    let equipmentSystem: ref<EquipmentSystem> = EquipmentSystem.GetInstance(this.m_player);
    let activeItem: ItemID = equipmentSystem.GetItemIDFromHotkey(this.m_player, hotkey);
    return TweakDBInterface.GetItemRecord(ItemID.GetTDBID(activeItem));
  }

  public func GetCharges() -> Int32 {
    return this.m_currentCharges;
  }

  private func Recharged() -> Void;

  protected func PlayRechagedSoundEvent() -> Void {
    let audioEvent: ref<SoundPlayEvent> = new SoundPlayEvent();
    audioEvent.soundName = this.m_rechargeSoundCue;
    this.m_player.QueueEvent(audioEvent);
  }

  public func GetRechargeDuration() -> Int32 {
    return Cast<Int32>(this.m_statSystem.GetStatValue(Cast<StatsObjectID>(this.m_player.GetEntityID()), gamedataStatType.HealingItemsRechargeDuration));
  }
}

public class AimAssistSettingsListener extends ConfigVarListener {

  private let m_ctrl: wref<PlayerPuppet>;

  private let m_settings: ref<UserSettings>;

  private let m_settingsGroup: ref<ConfigGroup>;

  private let m_aimAssistLevel: EAimAssistLevel;

  private let m_aimAssistMeleeLevel: EAimAssistLevel;

  private let m_aimAssistDriverCombatEnabled: Bool;

  private let m_aimAssistSnapEnabled: Bool;

  @default(AimAssistSettingsListener, /accessibility/difficulty)
  private let m_difficultySettingsPath: CName;

  public let m_currentConfig: AimAssistSettingConfig;

  public let m_settingsRecords: [wref<AimAssistSettings_Record>];

  public final func Initialize(ctrl: wref<PlayerPuppet>) -> Void {
    this.m_ctrl = ctrl;
    this.m_settings = GameInstance.GetSettingsSystem(this.m_ctrl.GetGame());
    this.m_settingsGroup = this.m_settings.GetGroup(this.m_difficultySettingsPath);
    let aimAssistVar: ref<ConfigVarListInt> = this.m_settingsGroup.GetVar(n"AimAssistanceMelee") as ConfigVarListInt;
    this.m_aimAssistMeleeLevel = IntEnum<EAimAssistLevel>(aimAssistVar.GetValue());
    let aimAssistBoolVar: ref<ConfigVarBool> = this.m_settingsGroup.GetVar(n"AimAssistanceDriverCombatOnOff") as ConfigVarBool;
    this.m_aimAssistDriverCombatEnabled = aimAssistBoolVar.GetValue();
    aimAssistVar = this.m_settingsGroup.GetVar(n"AimAssistance") as ConfigVarListInt;
    this.m_aimAssistLevel = IntEnum<EAimAssistLevel>(aimAssistVar.GetValue());
    aimAssistBoolVar = this.m_settingsGroup.GetVar(n"AimSnap") as ConfigVarBool;
    this.m_aimAssistSnapEnabled = aimAssistBoolVar.GetValue();
    ArrayResize(this.m_settingsRecords, 25);
    this.m_settingsRecords[0] = TweakDBInterface.GetAimAssistSettingsRecord(t"AimAssist.Settings_Default");
    this.m_settingsRecords[1] = TweakDBInterface.GetAimAssistSettingsRecord(t"AimAssist.Settings_Scanning");
    this.m_settingsRecords[2] = TweakDBInterface.GetAimAssistSettingsRecord(t"AimAssist.Settings_LeftHandCyberwareCharge");
    this.m_settingsRecords[3] = TweakDBInterface.GetAimAssistSettingsRecord(t"AimAssist.Settings_LeftHandCyberware");
    this.m_settingsRecords[4] = TweakDBInterface.GetAimAssistSettingsRecord(t"AimAssist.Settings_MeleeCombat");
    this.m_settingsRecords[5] = TweakDBInterface.GetAimAssistSettingsRecord(t"AimAssist.Settings_MeleeCombatIdle");
    this.m_settingsRecords[6] = TweakDBInterface.GetAimAssistSettingsRecord(t"AimAssist.Settings_AimingLimbCyber");
    this.m_settingsRecords[7] = TweakDBInterface.GetAimAssistSettingsRecord(t"AimAssist.Settings_AimingLimbCyberZoomLevel1");
    this.m_settingsRecords[8] = TweakDBInterface.GetAimAssistSettingsRecord(t"AimAssist.Settings_AimingLimbCyberZoomLevel2");
    this.m_settingsRecords[9] = TweakDBInterface.GetAimAssistSettingsRecord(t"AimAssist.Settings_Aiming");
    this.m_settingsRecords[10] = TweakDBInterface.GetAimAssistSettingsRecord(t"AimAssist.Settings_QuickMelee");
    this.m_settingsRecords[11] = TweakDBInterface.GetAimAssistSettingsRecord(t"AimAssist.Settings_VehicleCombat");
    this.m_settingsRecords[12] = TweakDBInterface.GetAimAssistSettingsRecord(t"AimAssist.Settings_Sprinting");
    this.m_settingsRecords[13] = TweakDBInterface.GetAimAssistSettingsRecord(t"AimAssist.Settings_LimbCyber");
    this.m_settingsRecords[14] = TweakDBInterface.GetAimAssistSettingsRecord(t"AimAssist.Settings_Vehicle");
    this.m_settingsRecords[15] = TweakDBInterface.GetAimAssistSettingsRecord(t"AimAssist.Settings_DriverCombat");
    this.m_settingsRecords[16] = TweakDBInterface.GetAimAssistSettingsRecord(t"AimAssist.Settings_DriverCombatAiming");
    this.m_settingsRecords[17] = TweakDBInterface.GetAimAssistSettingsRecord(t"AimAssist.Settings_DriverCombatTPP");
    this.m_settingsRecords[18] = TweakDBInterface.GetAimAssistSettingsRecord(t"AimAssist.Settings_DriverCombatMissiles");
    this.m_settingsRecords[19] = TweakDBInterface.GetAimAssistSettingsRecord(t"AimAssist.Settings_DriverCombatMissilesAiming");
    this.m_settingsRecords[20] = TweakDBInterface.GetAimAssistSettingsRecord(t"AimAssist.Settings_DriverCombatMeleeTPP");
    this.m_settingsRecords[21] = TweakDBInterface.GetAimAssistSettingsRecord(t"AimAssist.Settings_ZoomLevel1");
    this.m_settingsRecords[22] = TweakDBInterface.GetAimAssistSettingsRecord(t"AimAssist.Settings_ZoomLevel2");
    this.m_settingsRecords[23] = TweakDBInterface.GetAimAssistSettingsRecord(t"AimAssist.Settings_Exhausted");
    this.m_settingsRecords[24] = TweakDBInterface.GetAimAssistSettingsRecord(t"AimAssist.Settings_AimAssistOff");
    this.Register(this.m_difficultySettingsPath);
  }

  public func OnVarModified(groupPath: CName, varName: CName, varType: ConfigVarType, reason: ConfigChangeReason) -> Void {
    let aimAssistBoolVar: ref<ConfigVarBool>;
    let aimAssistVar: ref<ConfigVarListInt>;
    if NotEquals(reason, ConfigChangeReason.Accepted) {
      return;
    };
    if Equals(n"AimAssistanceMelee", varName) {
      aimAssistVar = this.m_settingsGroup.GetVar(n"AimAssistanceMelee") as ConfigVarListInt;
      this.m_aimAssistMeleeLevel = IntEnum<EAimAssistLevel>(aimAssistVar.GetValue());
      this.m_ctrl.ApplyAimAssistSettings(AimAssistSettingConfig.Count);
    } else {
      if Equals(n"AimAssistanceDriverCombatOnOff", varName) {
        aimAssistBoolVar = this.m_settingsGroup.GetVar(n"AimAssistanceDriverCombatOnOff") as ConfigVarBool;
        this.m_aimAssistDriverCombatEnabled = aimAssistBoolVar.GetValue();
        this.m_ctrl.ApplyAimAssistSettings(AimAssistSettingConfig.Count);
      } else {
        if Equals(n"AimAssistance", varName) {
          aimAssistVar = this.m_settingsGroup.GetVar(n"AimAssistance") as ConfigVarListInt;
          this.m_aimAssistLevel = IntEnum<EAimAssistLevel>(aimAssistVar.GetValue());
          this.m_ctrl.ApplyAimAssistSettings(AimAssistSettingConfig.Count);
        } else {
          if Equals(n"AimSnap", varName) {
            aimAssistBoolVar = this.m_settingsGroup.GetVar(n"AimSnap") as ConfigVarBool;
            this.m_aimAssistSnapEnabled = aimAssistBoolVar.GetValue();
          };
        };
      };
    };
  }

  public final const func GetAimAssistLevel() -> EAimAssistLevel {
    return this.m_aimAssistLevel;
  }

  public final const func GetAimAssistMeleeLevel() -> EAimAssistLevel {
    return this.m_aimAssistMeleeLevel;
  }

  public final const func GetAimAssistDriverCombatEnabled() -> Bool {
    return this.m_aimAssistDriverCombatEnabled;
  }

  public final const func GetAimSnapEnabled() -> Bool {
    return this.m_aimAssistSnapEnabled;
  }
}

public class AccessibilityControlsListener extends ConfigVarListener {

  private let m_ctrl: wref<PlayerPuppet>;

  private let m_settings: ref<UserSettings>;

  private let m_settingsGroup: ref<ConfigGroup>;

  private let m_allowCycleToFistCyberware: Bool;

  @default(AccessibilityControlsListener, /accessibility/controls)
  private let m_accessibilityControlsPath: CName;

  public final func Initialize(ctrl: wref<PlayerPuppet>) -> Void {
    this.m_ctrl = ctrl;
    this.m_settings = GameInstance.GetSettingsSystem(this.m_ctrl.GetGame());
    this.m_settingsGroup = this.m_settings.GetGroup(this.m_accessibilityControlsPath);
    let configBool: ref<ConfigVarBool> = this.m_settingsGroup.GetVar(n"AllowCycleToFistCyberware") as ConfigVarBool;
    this.m_allowCycleToFistCyberware = configBool.GetValue();
    this.Register(this.m_accessibilityControlsPath);
  }

  public func OnVarModified(groupPath: CName, varName: CName, varType: ConfigVarType, reason: ConfigChangeReason) -> Void {
    let configBool: ref<ConfigVarBool>;
    if NotEquals(reason, ConfigChangeReason.Accepted) {
      return;
    };
    if Equals(varName, n"AllowCycleToFistCyberware") {
      configBool = this.m_settingsGroup.GetVar(varName) as ConfigVarBool;
      this.m_allowCycleToFistCyberware = configBool.GetValue();
    };
  }

  public final const func GetAllowCycleToFistCyberware() -> Bool {
    return this.m_allowCycleToFistCyberware;
  }
}

public class AimToggleListener extends ConfigVarListener {

  private let m_settings: ref<UserSettings>;

  private let m_settingsGroup: ref<ConfigGroup>;

  private let m_toggleAim: Bool;

  private let m_isADS: Bool;

  @default(AimToggleListener, /controls)
  private let m_accessibilityControlsPath: CName;

  public final func Initialize(const scriptInterface: ref<StateGameScriptInterface>) -> Void {
    this.m_settings = GameInstance.GetSettingsSystem(scriptInterface.GetGame());
    this.m_settingsGroup = this.m_settings.GetGroup(this.m_accessibilityControlsPath);
    let configBool: ref<ConfigVarBool> = this.m_settingsGroup.GetVar(n"ToggleAim") as ConfigVarBool;
    this.m_toggleAim = configBool.GetValue();
    this.Register(this.m_accessibilityControlsPath);
  }

  public func OnVarModified(groupPath: CName, varName: CName, varType: ConfigVarType, reason: ConfigChangeReason) -> Void {
    let configBool: ref<ConfigVarBool>;
    if NotEquals(reason, ConfigChangeReason.Accepted) {
      return;
    };
    if Equals(varName, n"ToggleAim") {
      configBool = this.m_settingsGroup.GetVar(varName) as ConfigVarBool;
      this.m_toggleAim = configBool.GetValue();
      this.m_isADS = false;
    };
  }

  public final func OnAction(action: ListenerAction, consumer: ListenerActionConsumer) -> Void {
    if this.m_toggleAim {
      if ListenerAction.IsButtonJustPressed(action) {
        this.m_isADS = !this.m_isADS;
      };
    } else {
      this.m_isADS = ListenerAction.GetValue(action) > 0.00;
    };
  }

  public final func ADSForcedOff() -> Void {
    if this.m_isADS && this.m_toggleAim {
      this.m_isADS = false;
    };
  }

  public final const func GetADS() -> Bool {
    return this.m_isADS;
  }
}

public class RadioportSettingsListener extends ConfigVarListener {

  private let m_player: wref<PlayerPuppet>;

  private let m_settings: ref<UserSettings>;

  private let m_settingsGroup: ref<ConfigGroup>;

  private let m_syncToCarRadio: Bool;

  private let m_cycleOnButtonPress: Bool;

  private let m_saveStation: Bool;

  private let m_syncToCarRadioName: CName;

  private let m_cycleOnButtonPressName: CName;

  private let m_saveStationName: CName;

  private let m_radioportSettingsPath: CName;

  public final func Initialize(player: wref<PlayerPuppet>) -> Void {
    this.m_radioportSettingsPath = n"/gameplay/radioport";
    this.m_syncToCarRadioName = n"radioport_sync_to_car";
    this.m_cycleOnButtonPressName = n"radioport_enable_cycling";
    this.m_saveStationName = n"radioport_save_station";
    this.m_player = player;
    this.m_settings = GameInstance.GetSettingsSystem(this.m_player.GetGame());
    this.m_settingsGroup = this.m_settings.GetGroup(this.m_radioportSettingsPath);
    let configBool: ref<ConfigVarBool> = this.m_settingsGroup.GetVar(this.m_syncToCarRadioName) as ConfigVarBool;
    this.m_syncToCarRadio = configBool.GetValue();
    configBool = this.m_settingsGroup.GetVar(this.m_cycleOnButtonPressName) as ConfigVarBool;
    this.m_cycleOnButtonPress = configBool.GetValue();
    configBool = this.m_settingsGroup.GetVar(this.m_saveStationName) as ConfigVarBool;
    this.m_saveStation = configBool.GetValue();
    this.Register(this.m_radioportSettingsPath);
  }

  public func OnVarModified(groupPath: CName, varName: CName, varType: ConfigVarType, reason: ConfigChangeReason) -> Void {
    let configBool: ref<ConfigVarBool>;
    if NotEquals(reason, ConfigChangeReason.Accepted) {
      return;
    };
    if Equals(varName, this.m_syncToCarRadioName) {
      configBool = this.m_settingsGroup.GetVar(varName) as ConfigVarBool;
      this.m_syncToCarRadio = configBool.GetValue();
    };
    if Equals(varName, this.m_cycleOnButtonPressName) {
      configBool = this.m_settingsGroup.GetVar(varName) as ConfigVarBool;
      this.m_cycleOnButtonPress = configBool.GetValue();
    };
    if Equals(varName, this.m_saveStationName) {
      configBool = this.m_settingsGroup.GetVar(varName) as ConfigVarBool;
      this.m_saveStation = configBool.GetValue();
      this.m_player.PSSetPocketRadioStation(this.m_player.GetPocketRadio().GetStation());
    };
  }

  public final const func GetSyncToCarRadio() -> Bool {
    return this.m_syncToCarRadio;
  }

  public final const func GetCycleButtonPress() -> Bool {
    return this.m_cycleOnButtonPress;
  }

  public final const func GetSaveStation() -> Bool {
    return this.m_saveStation;
  }
}

public class PlayerPuppetAllStatListener extends ScriptStatsListener {

  public let player: wref<PlayerPuppet>;

  public func OnStatChanged(ownerID: StatsObjectID, statType: gamedataStatType, diff: Float, total: Float) -> Void {
    this.player.OnStatChanged(ownerID, statType, diff, total);
  }
}

public class AutoRevealStatListener extends ScriptStatsListener {

  public let m_owner: wref<GameObject>;

  public func OnStatChanged(ownerID: StatsObjectID, statType: gamedataStatType, diff: Float, total: Float) -> Void {
    let updateRequest: ref<UpdateAutoRevealStatEvent>;
    if Equals(statType, gamedataStatType.AutoReveal) && IsDefined(this.m_owner as PlayerPuppet) {
      updateRequest = new UpdateAutoRevealStatEvent();
      updateRequest.hasAutoReveal = total > 0.00;
      this.m_owner.QueueEvent(updateRequest);
    };
  }
}

public class VisibilityStatListener extends ScriptStatsListener {

  public let m_owner: wref<GameObject>;

  public func OnStatChanged(ownerID: StatsObjectID, statType: gamedataStatType, diff: Float, total: Float) -> Void {
    let updateRequest: ref<UpdateVisibilityModifierEvent>;
    if Equals(statType, gamedataStatType.Visibility) && IsDefined(this.m_owner as PlayerPuppet) {
      updateRequest = new UpdateVisibilityModifierEvent();
      this.m_owner.QueueEvent(updateRequest);
    };
  }
}

public class SecondHeartStatListener extends ScriptStatsListener {

  public let m_player: wref<PlayerPuppet>;

  public func OnStatChanged(ownerID: StatsObjectID, statType: gamedataStatType, diff: Float, total: Float) -> Void {
    if !IsDefined(this.m_player) {
      return;
    };
    if total > 0.00 {
      GameInstance.GetGodModeSystem(this.m_player.GetGame()).EnableOverride(this.m_player.GetEntityID(), gameGodModeType.Immortal, n"SecondHeart");
    } else {
      GameInstance.GetGodModeSystem(this.m_player.GetGame()).DisableOverride(this.m_player.GetEntityID(), n"SecondHeart");
    };
  }
}

public class PlayerPuppetAttachmentSlotsCallback extends AttachmentSlotsScriptCallback {

  public let m_player: wref<PlayerPuppet>;

  public func OnItemEquipped(slot: TweakDBID, item: ItemID) -> Void {
    this.m_player.OnItemEquipped(slot, item);
  }

  public func OnItemUnequipped(slot: TweakDBID, item: ItemID) -> Void {
    this.m_player.OnItemUnequipped(slot, item);
  }
}

public class ArmorStatListener extends ScriptStatPoolsListener {

  public let m_ownerPuppet: wref<PlayerPuppet>;

  public func OnStatPoolValueChanged(oldValue: Float, newValue: Float, percToPoints: Float) -> Void {
    this.m_ownerPuppet.m_CPOMissionDataState.OnDamage(this.m_ownerPuppet, false);
  }
}

public class HealthStatListener extends ScriptStatPoolsListener {

  public let m_ownerPuppet: wref<PlayerPuppet>;

  private let healthEvent: ref<HealthUpdateEvent>;

  public func OnStatPoolValueChanged(oldValue: Float, newValue: Float, percToPoints: Float) -> Void {
    if this.m_ownerPuppet.IsControlledByLocalPeer() {
      this.m_ownerPuppet.m_CPOMissionDataState.OnDamage(this.m_ownerPuppet, true);
    };
    this.healthEvent = new HealthUpdateEvent();
    this.healthEvent.value = newValue;
    this.healthEvent.healthDifference = newValue - oldValue;
    this.m_ownerPuppet.QueueEvent(this.healthEvent);
  }
}

public class HealingItemsChargeStatListener extends BaseChargesStatListener {

  public func Init(player: wref<PlayerPuppet>) -> Void {
    super.Init(player);
    this.m_rechargeSoundCue = n"ui_inhaler_injector_recharged";
  }

  private func Recharged() -> Void {
    this.PlayRechagedSoundEvent();
  }
}

public class GrenadesChargeStatListener extends BaseChargesStatListener {

  public func Init(player: wref<PlayerPuppet>) -> Void {
    super.Init(player);
    this.m_rechargeSoundCue = n"ui_grenade_recharged";
    this.m_finalString = GetLocalizedText("LocKey#91660") + " " + GetLocalizedText("LocKey#35671");
  }

  public func MaxStatPoolValue() -> Int32 {
    return Cast<Int32>(GameInstance.GetStatPoolsSystem(this.m_player.GetGame()).GetStatPoolMaxPointValue(Cast<StatsObjectID>(this.m_player.GetEntityID()), gamedataStatPoolType.GrenadesCharges));
  }

  public func GetRechargeDuration() -> Int32 {
    let grenadeID: ItemID = EquipmentSystem.GetData(this.m_player).GetActiveGadget();
    let grenadeRecord: ref<Grenade_Record> = TweakDBInterface.GetGrenadeRecord(ItemID.GetTDBID(grenadeID));
    return this.GetRechargeDuration(grenadeRecord);
  }

  public final func GetRechargeDuration(item: ref<Grenade_Record>) -> Int32 {
    let rechargeDuration: Int32 = Cast<Int32>(this.m_statSystem.GetStatValue(Cast<StatsObjectID>(this.m_player.GetEntityID()), gamedataStatType.GrenadesRechargeDuration));
    if PlayerDevelopmentSystem.GetInstance(this.m_player).IsNewPerkBought(this.m_player, gamedataNewPerkType.Tech_Left_Perk_3_3) == 1 {
      if item.TagsContains(n"FlashGrenade") || item.TagsContains(n"SmokeGrenade") || item.TagsContains(n"ReconGrenade") {
        rechargeDuration /= 2;
      };
    };
    return rechargeDuration;
  }

  public final func GetRechargeDurationClean() -> Int32 {
    return Cast<Int32>(this.m_statSystem.GetStatValue(Cast<StatsObjectID>(this.m_player.GetEntityID()), gamedataStatType.GrenadesRechargeDuration));
  }

  public func GetCharges() -> Int32 {
    return this.m_currentStatPoolValue / this.GetRechargeDuration();
  }

  public final func GetCharges(item: ref<Grenade_Record>) -> Int32 {
    return this.m_currentStatPoolValue / this.GetRechargeDuration(item);
  }

  private func Recharged() -> Void {
    let item: ref<Item_Record> = this.GetActiveItem(EHotkey.RB);
    if Equals(item.ItemType().Type(), gamedataItemType.Gad_Grenade) {
      this.PlayRechagedSoundEvent();
    };
  }
}

public class ProjectileLauncherChargeStatListener extends BaseChargesStatListener {

  public func Init(player: wref<PlayerPuppet>) -> Void {
    super.Init(player);
    this.m_rechargeSoundCue = n"ui_grenade_recharged";
    this.m_finalString = GetLocalizedText("LocKey#52430") + " " + GetLocalizedText("LocKey#3722");
  }

  public func GetRechargeDuration() -> Int32 {
    return Cast<Int32>(this.m_statSystem.GetStatValue(Cast<StatsObjectID>(this.m_player.GetEntityID()), gamedataStatType.ProjectileLauncherRechargeDuration));
  }

  private func Recharged() -> Void {
    let item: ref<Item_Record> = this.GetActiveItem(EHotkey.RB);
    if Equals(item.ItemType().Type(), gamedataItemType.Cyb_Launcher) {
      this.PlayRechagedSoundEvent();
    };
  }
}

public class OpticalCamoChargeStatListener extends BaseChargesStatListener {

  public func Init(player: wref<PlayerPuppet>) -> Void {
    super.Init(player);
    this.m_rechargeSoundCue = n"ui_grenade_recharged";
    this.m_finalString = GetLocalizedText("LocKey#52430") + " " + GetLocalizedText("LocKey#3702");
  }

  protected cb func OnStatPoolMaxValueReached(value: Float) -> Bool {
    let item: ref<Item_Record> = this.GetActiveItem(EHotkey.RB);
    if Equals(item.ItemType().Type(), gamedataItemType.Cyb_Ability) && Equals(item.FriendlyName(), "OpticalCamo") {
      this.PlayRechagedSoundEvent();
    };
  }

  protected cb func OnStatPoolMinValueReached(value: Float) -> Bool {
    StatusEffectHelper.RemoveStatusEffect(this.m_player, t"BaseStatusEffect.OpticalCamoCoolPerkShort");
  }

  public func GetRechargeDuration() -> Int32 {
    return Cast<Int32>(this.m_statSystem.GetStatValue(Cast<StatsObjectID>(this.m_player.GetEntityID()), gamedataStatType.OpticalCamoRechargeDuration));
  }

  public func OnStatPoolValueChanged(oldValue: Float, newValue: Float, percToPoints: Float) -> Void;
}

public class OverclockChargeListener extends BaseChargesStatListener {

  public func Init(player: wref<PlayerPuppet>) -> Void {
    super.Init(player);
    this.m_rechargeSoundCue = n"ui_iconic_cyberwear_recharged";
  }

  protected cb func OnStatPoolMaxValueReached(value: Float) -> Bool {
    let item: ref<Item_Record> = this.GetActiveItem(EHotkey.LBRB);
    if Equals(item.ItemType().Type(), gamedataItemType.Cyb_Ability) {
      this.PlayRechagedSoundEvent();
    };
  }

  protected cb func OnStatPoolMinValueReached(value: Float) -> Bool {
    StatusEffectHelper.RemoveStatusEffect(this.m_player, t"BaseStatusEffect.Intelligence_Central_Milestone_3_Overclock_Buff");
  }
}
