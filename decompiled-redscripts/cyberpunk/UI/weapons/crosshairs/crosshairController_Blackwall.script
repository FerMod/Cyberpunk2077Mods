
public class CrosshairGameController_BlackwallForce extends CrosshairGameController_Smart_Rifl {

  public let m_lastSmartParams: ref<smartGunUIParameters>;

  public let m_smartGunData: ref<smartGunUIParameters>;

  public let m_targetList: [smartGunUITargetParameters];

  public let m_targetData: smartGunUITargetParameters;

  public let m_numOfTargets: Int32;

  public let m_owner: wref<GameObject>;

  protected cb func OnSmartGunParams(argParams: Variant) -> Bool {
    let i: Int32;
    let statusEffectSystem: ref<StatusEffectSystem> = GameInstance.GetStatusEffectSystem(this.GetGame());
    super.OnSmartGunParams(argParams);
    this.m_smartGunData = FromVariant<ref<smartGunUIParameters>>(argParams);
    this.m_lastSmartParams = this.m_smartGunData;
    this.m_targetList = this.m_smartGunData.targets;
    this.m_numOfTargets = ArraySize(this.m_targetList);
    i = 0;
    while i < this.m_numOfTargets {
      this.m_targetData = this.m_targetList[i];
      if Equals(this.m_targetData.state, gamesmartGunTargetState.Locked) && !statusEffectSystem.HasStatusEffectWithTag(this.m_targetData.entityID, n"BlackwallMark") {
        statusEffectSystem.ApplyStatusEffect(this.m_targetData.entityID, t"BaseStatusEffect.SoMi_Q306_BlackwallMark");
      };
      i += 1;
    };
  }

  protected cb func OnInputActivatedToUploadBlackwallEvent(evt: ref<InputActivatedToUploadBlackwallEvent>) -> Bool {
    let forceKillEvt: ref<ForceBlackwallKillNPCSEvent>;
    let i: Int32;
    let randomDelay: Float;
    let statusEffectSystem: ref<StatusEffectSystem> = GameInstance.GetStatusEffectSystem(this.GetGame());
    this.m_owner = this.GetOwnerEntity() as GameObject;
    let minDelay: Float = TDB.GetFloat(t"Items.BlackwallForce.minRandomDelay");
    let maxDelay: Float = TDB.GetFloat(t"Items.BlackwallForce.maxRandomDelay");
    StatusEffectHelper.ApplyStatusEffect(this.m_owner, t"BaseStatusEffect.BlackwallSQCooldown");
    GameObjectEffectHelper.StartEffectEvent(this.m_owner, n"blackwall_use_force");
    GameInstance.GetAudioSystem(this.GetGame()).SetTriggerEffectModeTimed(n"te_wea_somi_blackwall_charge_attack", 3.00);
    i = 0;
    while i < this.m_numOfTargets {
      this.m_targetData = this.m_targetList[i];
      if statusEffectSystem.HasStatusEffectWithTag(this.m_targetData.entityID, n"BlackwallMark") && !statusEffectSystem.HasStatusEffectWithTag(this.m_targetData.entityID, n"BlackwallHack") {
        if this.m_numOfTargets == 1 {
          statusEffectSystem.ApplyStatusEffect(this.m_targetData.entityID, t"BaseStatusEffect.SoMi_Q306_BlackwallHackUpload");
        } else {
          forceKillEvt = new ForceBlackwallKillNPCSEvent();
          forceKillEvt.targetID = this.m_targetData.entityID;
          randomDelay = RandRangeF(minDelay, maxDelay);
          GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(this.m_owner, forceKillEvt, randomDelay);
        };
      };
      i += 1;
    };
  }

  protected cb func OnForceKillNPCEvent(evt: ref<ForceBlackwallKillNPCSEvent>) -> Bool {
    let statusEffectSystem: ref<StatusEffectSystem> = GameInstance.GetStatusEffectSystem(this.GetGame());
    statusEffectSystem.ApplyStatusEffect(evt.targetID, t"BaseStatusEffect.SoMi_Q306_BlackwallHackUpload");
  }
}
