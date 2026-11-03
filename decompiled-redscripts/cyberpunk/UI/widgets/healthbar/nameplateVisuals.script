
public class NameplateVisualsLogicController extends inkLogicController {

  private let m_rootWidget: wref<inkCompoundWidget>;

  private edit let m_nameTextMain: inkTextRef;

  private edit let m_nameFrame: inkWidgetRef;

  private edit let m_healthbarWidget: inkWidgetRef;

  private edit let m_healthBarFull: inkWidgetRef;

  private edit let m_healthBarFrame: inkWidgetRef;

  private edit let m_stealthMappinSlot: inkCompoundRef;

  private edit let m_damagePreviewWrapper: inkWidgetRef;

  private edit let m_damagePreviewWidget: inkWidgetRef;

  private edit let m_damagePreviewArrow: inkWidgetRef;

  private edit let m_rarityHolder: inkWidgetRef;

  private edit const let m_rarities: [inkWidgetRef];

  private let m_cachedPuppet: wref<GameObject>;

  private let m_cachedIncomingData: NPCNextToTheCrosshair;

  private let m_isBoss: Bool;

  private let m_isElite: Bool;

  private let m_isRare: Bool;

  private let m_isNCPD: Bool;

  private let m_canCallReinforcements: Bool;

  private let m_isBurning: Bool;

  private let m_isPoisoned: Bool;

  private let m_bossColor: Color;

  private let m_npcDefeated: Bool;

  private let m_isStealthMappinVisible: Bool;

  private let m_playerZone: gamePSMZones;

  private let m_npcNamesEnabled: Bool;

  private let m_healthController: wref<NameplateBarLogicController>;

  private let m_hasCenterIcon: Bool;

  private let m_animatingObject: inkWidgetRef;

  private let m_isAnimating: Bool;

  private let m_animProxy: ref<inkAnimProxy>;

  private let m_alpha_fadein: ref<inkAnimDef>;

  private let m_damagePreviewAnimProxy: ref<inkAnimProxy>;

  @default(NameplateVisualsLogicController, false)
  private let m_isQuestTarget: Bool;

  @default(NameplateVisualsLogicController, false)
  private let m_forceHide: Bool;

  private let m_isHardEnemy: Bool;

  private let m_npcIsAggressive: Bool;

  private let m_playerAimingDownSights: Bool;

  private let m_playerInCombat: Bool;

  private let m_playerInStealth: Bool;

  private let m_healthNotFull: Bool;

  private let m_healthbarVisible: Bool;

  private let m_levelContainerShouldBeVisible: Bool;

  private let m_currentHealth: Int32;

  private let m_maximumHealth: Int32;

  private let m_currentDamagePreviewValue: Int32;

  protected cb func OnInitialize() -> Bool {
    this.m_rootWidget = this.GetRootWidget() as inkCompoundWidget;
    this.m_healthController = inkWidgetRef.GetController(this.m_healthbarWidget) as NameplateBarLogicController;
    this.m_npcDefeated = false;
    this.m_playerAimingDownSights = false;
    this.m_playerInCombat = false;
    this.m_playerInStealth = false;
    this.m_healthNotFull = false;
    this.m_healthbarVisible = false;
    inkWidgetRef.SetVisible(this.m_healthbarWidget, false);
  }

  public final func SetVisualData(puppet: ref<GameObject>, const incomingData: script_ref<NPCNextToTheCrosshair>, opt isNewNpc: Bool) -> Void {
    this.m_cachedPuppet = puppet;
    this.m_cachedIncomingData = Deref(incomingData);
    let npc: ref<NPCPuppet> = Deref(incomingData).npc as NPCPuppet;
    if IsDefined(npc) {
      if Equals(Deref(incomingData).attitude, EAIAttitude.AIA_Hostile) {
        this.m_npcIsAggressive = true;
      } else {
        if npc.IsAggressive() && NotEquals(Deref(incomingData).attitude, EAIAttitude.AIA_Friendly) {
          this.m_npcIsAggressive = true;
        } else {
          this.m_npcIsAggressive = false;
        };
      };
    } else {
      if IsDefined(Deref(incomingData).npc) && Deref(incomingData).npc.IsTurret() {
        if NotEquals(Deref(incomingData).attitude, EAIAttitude.AIA_Friendly) {
          this.m_npcIsAggressive = true;
        } else {
          this.m_npcIsAggressive = false;
        };
      } else {
        this.m_npcIsAggressive = false;
      };
    };
    this.m_currentHealth = Deref(incomingData).currentHealth;
    this.m_maximumHealth = Deref(incomingData).maximumHealth;
    this.m_healthNotFull = Deref(incomingData).currentHealth + 1 < Deref(incomingData).maximumHealth;
    this.m_npcDefeated = !ScriptedPuppet.IsActive(Deref(incomingData).npc);
    if IsDefined(npc) && !this.m_npcDefeated {
      this.m_npcDefeated = npc.IsAboutToBeDefeated() || npc.IsAboutToDie();
    };
    this.SetNPCType(puppet as ScriptedPuppet);
    this.SetAttitudeColors(puppet as ScriptedPuppet, incomingData);
    this.SetElementVisibility(incomingData);
    if !IsDefined(Deref(incomingData).npc) || Deref(incomingData).level == 0 && !Deref(incomingData).npc.IsTurret() {
      this.m_levelContainerShouldBeVisible = false;
    };
    this.UpdateHealthbarVisibility();
    if Deref(incomingData).maximumHealth == 0 {
      this.m_healthController.SetNameplateBarProgress(0.00, isNewNpc);
    } else {
      this.m_healthController.SetNameplateBarProgress(Cast<Float>(Deref(incomingData).currentHealth) / Cast<Float>(Deref(incomingData).maximumHealth), isNewNpc);
    };
    if this.m_currentDamagePreviewValue > 0 {
      this.PreviewDamage(this.m_currentDamagePreviewValue);
    };
  }

  public final func PreviewDamage(value: Int32) -> Void {
    let animOptions: inkAnimOptions;
    let currentHealthPercentage: Float;
    let damagePercentage: Float;
    let offset: Float;
    let renderTransformXPivot: Float;
    this.m_currentDamagePreviewValue = value;
    if value <= 0 {
      if IsDefined(this.m_damagePreviewAnimProxy) && this.m_damagePreviewAnimProxy.IsPlaying() {
        this.m_damagePreviewAnimProxy.Stop();
      };
      inkWidgetRef.SetVisible(this.m_damagePreviewWrapper, false);
    } else {
      if this.m_maximumHealth > 0 {
        currentHealthPercentage = Cast<Float>(this.m_currentHealth) / Cast<Float>(this.m_maximumHealth);
        damagePercentage = Cast<Float>(value) / Cast<Float>(this.m_maximumHealth);
        damagePercentage = MinF(damagePercentage, currentHealthPercentage);
        renderTransformXPivot = damagePercentage < 1.00 ? (currentHealthPercentage - damagePercentage) / (1.00 - damagePercentage) : 1.00;
        offset = 100.00 + 150.00 * damagePercentage - 150.00 * currentHealthPercentage;
        inkWidgetRef.SetRenderTransformPivot(this.m_damagePreviewWidget, new Vector2(renderTransformXPivot, 1.00));
        inkWidgetRef.SetScale(this.m_damagePreviewWidget, new Vector2(damagePercentage, 1.00));
        inkWidgetRef.SetMargin(this.m_damagePreviewArrow, 0.00, -22.00, offset, 0.00);
        if !IsDefined(this.m_damagePreviewAnimProxy) || !this.m_damagePreviewAnimProxy.IsPlaying() {
          animOptions.loopType = inkanimLoopType.Cycle;
          animOptions.loopInfinite = true;
          this.m_damagePreviewAnimProxy = this.PlayLibraryAnimation(n"damage_preview_looping", animOptions);
        };
        inkWidgetRef.SetVisible(this.m_damagePreviewWrapper, true);
      };
    };
  }

  public final func UpdateBecauseOfMapPin() -> Void {
    this.SetVisualData(this.m_cachedPuppet, this.m_cachedIncomingData);
  }

  public final func UpdatePlayerZone(zone: gamePSMZones, opt onlySetValue: Bool) -> Void {
    this.m_playerZone = zone;
    if IsDefined(this.m_cachedPuppet) && !onlySetValue {
      this.SetVisualData(this.m_cachedPuppet, this.m_cachedIncomingData);
    };
  }

  public final func UpdatePlayerAimStatus(state: gamePSMUpperBodyStates, opt onlySetValue: Bool) -> Void {
    this.m_playerAimingDownSights = Equals(state, gamePSMUpperBodyStates.Aim);
    if IsDefined(this.m_cachedPuppet) && !onlySetValue {
      this.UpdateHealthbarVisibility();
    };
  }

  public final func UpdatePlayerCombat(state: gamePSMCombat, opt onlySetValue: Bool) -> Void {
    this.m_playerInCombat = Equals(state, gamePSMCombat.InCombat);
    this.m_playerInStealth = Equals(state, gamePSMCombat.Stealth);
    if IsDefined(this.m_cachedPuppet) && !onlySetValue {
      this.UpdateHealthbarVisibility();
    };
  }

  public final func UpdateNPCNamesEnabled(value: Bool, opt onlySetValue: Bool) -> Void {
    this.m_npcNamesEnabled = value;
    if IsDefined(this.m_cachedPuppet) && !onlySetValue {
      this.SetVisualData(this.m_cachedPuppet, this.m_cachedIncomingData);
    };
  }

  public final func UpdateHealthbarColor(isHostile: Bool) -> Void {
    if isHostile {
      inkWidgetRef.SetState(this.m_healthbarWidget, n"Hostile");
      inkWidgetRef.SetState(this.m_healthBarFull, n"Hostile");
      inkWidgetRef.SetState(this.m_healthBarFrame, n"Hostile");
    } else {
      if this.m_isNCPD {
        inkWidgetRef.SetState(this.m_healthbarWidget, n"Prevention_Blue");
        inkWidgetRef.SetState(this.m_healthBarFull, n"Prevention_Blue");
        inkWidgetRef.SetState(this.m_healthBarFrame, n"Prevention_Blue");
      } else {
        inkWidgetRef.SetState(this.m_healthbarWidget, n"Neutral_Enemy");
        inkWidgetRef.SetState(this.m_healthBarFull, n"Neutral_Enemy");
        inkWidgetRef.SetState(this.m_healthBarFrame, n"Neutral_Enemy");
      };
    };
  }

  private final func UpdateHealthbarVisibility() -> Void {
    let playerPuppet: wref<PlayerPuppet>;
    let threatPuppet: wref<NPCPuppet>;
    let hpVisible: Bool = this.m_npcIsAggressive && (this.m_healthNotFull || this.m_playerAimingDownSights || this.m_playerInCombat || this.m_playerInStealth);
    let nameplateHpVisible: Bool = hpVisible && !this.m_isBoss;
    if NotEquals(this.m_healthbarVisible, nameplateHpVisible) {
      this.m_healthbarVisible = nameplateHpVisible;
      inkWidgetRef.SetVisible(this.m_healthbarWidget, this.m_healthbarVisible);
    };
    if this.m_isBoss && IsDefined(this.m_cachedPuppet) {
      playerPuppet = GetPlayer(this.m_cachedPuppet.GetGame());
      threatPuppet = this.m_cachedPuppet as NPCPuppet;
      if ScriptedPuppet.IsAlive(threatPuppet) && hpVisible && !ScriptedPuppet.IsDefeated(threatPuppet) {
        BossHealthBarGameController.ReevaluateBossHealthBar(threatPuppet, playerPuppet);
      };
    };
  }

  private final func SetNPCType(puppet: wref<ScriptedPuppet>) -> Void {
    let puppetRarity: gamedataNPCRarity;
    this.m_isBoss = false;
    this.m_canCallReinforcements = false;
    this.m_isElite = false;
    this.m_isRare = false;
    this.m_isNCPD = false;
    if IsDefined(puppet) {
      this.m_isNCPD = puppet.IsCharacterPolice();
      puppetRarity = puppet.GetNPCRarity();
      switch puppetRarity {
        case gamedataNPCRarity.Boss:
        case gamedataNPCRarity.MaxTac:
          this.m_isBoss = true;
          break;
        case gamedataNPCRarity.Elite:
          this.m_isElite = true;
          break;
        case gamedataNPCRarity.Rare:
          this.m_isRare = true;
          break;
        case gamedataNPCRarity.Weak:
      };
      this.m_canCallReinforcements = GameInstance.GetStatsSystem(puppet.GetGame()).GetStatBoolValue(Cast<StatsObjectID>(puppet.GetEntityID()), gamedataStatType.CanCallReinforcements);
    };
  }

  private final func SetAttitudeColors(puppet: wref<gamePuppetBase>, const incomingData: script_ref<NPCNextToTheCrosshair>) -> Void {
    let attitudeColor: CName;
    inkTextRef.SetLetterCase(this.m_nameTextMain, textLetterCase.UpperCase);
    inkTextRef.SetText(this.m_nameTextMain, Deref(incomingData).name);
    switch Deref(incomingData).attitude {
      case EAIAttitude.AIA_Hostile:
        attitudeColor = n"Hostile";
        break;
      case EAIAttitude.AIA_Friendly:
        attitudeColor = n"Friendly";
        break;
      case EAIAttitude.AIA_Neutral:
        attitudeColor = n"Neutral";
        break;
      default:
        attitudeColor = n"Civilian";
    };
    if this.m_npcIsAggressive {
      inkWidgetRef.SetState(this.m_nameTextMain, this.m_isQuestTarget ? n"Quest" : n"Hostile");
      if this.m_isNCPD {
        inkWidgetRef.SetState(this.m_nameTextMain, this.m_isQuestTarget ? n"Quest" : n"Prevention_Blue");
      };
    } else {
      inkWidgetRef.SetState(this.m_nameTextMain, this.m_isQuestTarget ? n"Quest" : attitudeColor);
    };
    if this.m_isBoss {
      attitudeColor = n"Boss";
    };
    if puppet != null && puppet.IsPlayer() {
      inkWidgetRef.SetState(this.m_nameTextMain, n"CPO_Player");
    };
  }

  private final func SetElementVisibility(const incomingData: script_ref<NPCNextToTheCrosshair>) -> Void {
    let enemyDifficulty: gameEPowerDifferential;
    let isTurret: Bool;
    let npc: ref<NPCPuppet>;
    inkWidgetRef.SetVisible(this.m_nameTextMain, false);
    this.m_levelContainerShouldBeVisible = false;
    this.m_isHardEnemy = false;
    inkWidgetRef.SetVisible(this.m_rarityHolder, false);
    inkWidgetRef.SetVisible(this.m_rarities[0], true);
    inkWidgetRef.SetVisible(this.m_rarities[1], true);
    isTurret = IsDefined(Deref(incomingData).npc) && Deref(incomingData).npc.IsTurret();
    npc = Deref(incomingData).npc as NPCPuppet;
    if IsDefined(npc) || isTurret {
      this.m_rootWidget.SetVisible(!this.m_forceHide && (Deref(incomingData).npc.IsPlayer() || !this.m_npcDefeated));
    };
    if this.m_npcIsAggressive {
      if isTurret {
        enemyDifficulty = gameEPowerDifferential.NORMAL;
      } else {
        enemyDifficulty = RPGManager.CalculatePowerDifferential(npc);
      };
      if !isTurret && (Equals(enemyDifficulty, gameEPowerDifferential.IMPOSSIBLE) || NPCManager.HasVisualTag(npc, n"Sumo")) {
        this.m_isHardEnemy = true;
      } else {
        this.m_isHardEnemy = false;
        this.m_isAnimating = false;
        if IsDefined(this.m_animProxy) {
          this.m_animProxy.Stop();
          this.m_animProxy.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnFadeInComplete");
          this.m_animProxy.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnFadeOutComplete");
          this.m_animProxy.UnregisterFromCallback(inkanimEventType.OnFinish, this, n"OnScreenDelayComplete");
        };
      };
      this.m_levelContainerShouldBeVisible = true;
      if this.m_isElite {
        inkWidgetRef.SetVisible(this.m_rarityHolder, true);
      } else {
        if this.m_isRare {
          inkWidgetRef.SetVisible(this.m_rarityHolder, true);
          inkWidgetRef.SetVisible(this.m_rarities[0], false);
        };
      };
      if this.m_isRare {
        inkWidgetRef.SetScale(this.m_healthbarWidget, new Vector2(0.90, 1.00));
      } else {
        if this.m_isElite || this.m_isBoss {
          inkWidgetRef.SetScale(this.m_healthbarWidget, new Vector2(1.00, 1.00));
        } else {
          inkWidgetRef.SetScale(this.m_healthbarWidget, new Vector2(0.60, 1.00));
        };
      };
    };
    if IsDefined(npc) && npc.IsVendor() {
      inkWidgetRef.SetVisible(this.m_nameTextMain, this.m_npcNamesEnabled);
      this.m_levelContainerShouldBeVisible = false;
    };
    if Equals(Deref(incomingData).attitude, EAIAttitude.AIA_Friendly) && !isTurret {
      inkWidgetRef.SetVisible(this.m_nameTextMain, this.m_npcNamesEnabled);
      this.m_levelContainerShouldBeVisible = false;
    };
  }

  public final func IsAnyElementVisible() -> Bool {
    return inkWidgetRef.IsVisible(this.m_nameTextMain) || this.m_levelContainerShouldBeVisible;
  }

  public final func IsQuestTarget() -> Bool {
    return this.m_isQuestTarget;
  }

  public final func SetQuestTarget(value: Bool) -> Void {
    this.m_isQuestTarget = value;
  }

  public final func SetForceHide(value: Bool) -> Void {
    this.m_forceHide = value;
  }
}
