
public class BountyManager extends IScriptable {

  public final static func GenerateBounty(target: wref<NPCPuppet>) -> Bounty {
    let bounty: wref<Bounty_Record>;
    let bountyChoices: array<wref<Bounty_Record>>;
    let bountyData: Bounty;
    let bountyDrawTable: wref<BountyDrawTable_Record>;
    let characterRecord: wref<Character_Record>;
    let count: Int32;
    let i: Int32;
    let j: Int32;
    let randomDraw: Float;
    let totalWeight: Float;
    let visualTagFilter: CName;
    let weightSum: Float;
    let bountyID: TweakDBID = target.GetPuppetPS().GetBountyID();
    if !TDBID.IsValid(bountyID) {
      characterRecord = TweakDBInterface.GetCharacterRecord(target.GetRecordID());
      bountyDrawTable = characterRecord.BountyDrawTable();
      if IsDefined(bountyDrawTable) {
        bountyDrawTable.BountyChoices(bountyChoices);
        if ArraySize(bountyChoices) > 0 {
          i = ArraySize(bountyChoices) - 1;
          while i >= 0 {
            count = bountyChoices[i].GetVisualTagsFilterCount();
            j = 0;
            while j < count {
              visualTagFilter = bountyChoices[i].GetVisualTagsFilterItem(j);
              if NPCManager.HasVisualTag(target, visualTagFilter) {
                ArrayErase(bountyChoices, i);
                break;
              };
              j += 1;
            };
            i -= 1;
          };
          if ArraySize(bountyChoices) == 0 {
            bountyData.m_filteredOut = true;
            NPCPuppet.SetBountyObject(target, bountyData);
            return bountyData;
          };
        };
        i = 0;
        while i < ArraySize(bountyChoices) {
          totalWeight += bountyChoices[i].DrawWeight();
          i += 1;
        };
        randomDraw = RandRangeF(0.00, totalWeight);
        i = 0;
        while i < ArraySize(bountyChoices) {
          weightSum += bountyChoices[i].DrawWeight();
          if randomDraw < weightSum {
            bounty = bountyChoices[i];
            bountyID = bounty.GetID();
            break;
          };
          i += 1;
        };
      };
    };
    bountyData = BountyManager.SetBountyFromID(bountyID, target);
    return bountyData;
  }

  public final static func SetBountyFromID(bountyID: TweakDBID, target: wref<NPCPuppet>) -> Bounty {
    let bounty: Bounty;
    let bountySeverity: Float;
    let currencyArr: array<wref<CurrencyReward_Record>>;
    let expArr: array<wref<XPPoints_Record>>;
    let i: Int32;
    let mean: Float;
    let quantityMods: array<wref<StatModifier_Record>>;
    let randomDraw: Float;
    let rarityString: String;
    let standardDeviation: Float;
    let totalSeverity: Float;
    let totalWeight: Float;
    let transgressionTable: array<wref<Transgression_Record>>;
    let transgressionsIDs: array<TweakDBID>;
    let wantedStarCount: Float;
    let weightSum: Float;
    let player: wref<PlayerPuppet> = GetPlayer(target.GetGame());
    bounty.m_bountID = bountyID;
    let bountyRecord: wref<Bounty_Record> = TweakDBInterface.GetBountyRecord(bountyID);
    if IsDefined(bountyRecord) {
      if IsDefined(bountyRecord.BountySetter()) {
        bounty.m_bountySetter = bountyRecord.BountySetter().GetID();
      };
      if IsDefined(bountyRecord.Reward()) {
        bountyRecord.Reward().Experience(expArr);
      };
    };
    if ArraySize(expArr) > 0 {
      expArr[0].QuantityModifiers(quantityMods);
    };
    bounty.m_streetCredAmount = Cast<Int32>(RPGManager.GetRarityMultiplier(target, n"power_level_to_bounty_cred_mult") * RPGManager.CalculateStatModifiers(quantityMods, player.GetGame(), player, Cast<StatsObjectID>(target.GetEntityID())));
    ArrayClear(quantityMods);
    if IsDefined(bountyRecord) && IsDefined(bountyRecord.Reward()) {
      bountyRecord.Reward().CurrencyPackage(currencyArr);
    };
    if ArraySize(currencyArr) > 0 {
      currencyArr[0].QuantityModifiers(quantityMods);
    };
    bounty.m_moneyAmount = Cast<Int32>(RPGManager.GetRarityMultiplier(target, n"power_level_to_bounty_money_mult") * RPGManager.CalculateStatModifiers(quantityMods, player.GetGame(), player, Cast<StatsObjectID>(target.GetEntityID())));
    transgressionsIDs = target.GetPuppetPS().GetTransgressions();
    if ArraySize(transgressionsIDs) > 0 {
      i = 0;
      while i < ArraySize(transgressionsIDs) {
        ArrayPush(bounty.m_transgressions, transgressionsIDs[i]);
        i += 1;
      };
    } else {
      bountyRecord.Transgressions(transgressionTable);
      i = 0;
      while i < ArraySize(transgressionTable) {
        totalWeight += transgressionTable[i].DrawWeight();
        i += 1;
      };
      totalSeverity = GameInstance.GetStatsDataSystem(target.GetGame()).GetValueFromCurve(n"puppet_bounty_scaling", GameInstance.GetStatsSystem(target.GetGame()).GetStatValue(Cast<StatsObjectID>(target.GetEntityID()), gamedataStatType.PowerLevel), n"power_level_to_severity");
      totalSeverity *= RPGManager.GetRarityMultiplier(target, n"power_level_to_bounty_severity_mult");
      while bountySeverity <= totalSeverity && ArraySize(transgressionTable) != 0 {
        weightSum = 0.00;
        randomDraw = RandRangeF(0.00, totalWeight);
        i = 0;
        while i < ArraySize(transgressionTable) {
          weightSum += transgressionTable[i].DrawWeight();
          if randomDraw < weightSum {
            ArrayPush(bounty.m_transgressions, transgressionTable[i].GetID());
            totalWeight -= transgressionTable[i].DrawWeight();
            bountySeverity += transgressionTable[i].Severity();
            ArrayErase(transgressionTable, i);
            break;
          };
          i += 1;
        };
      };
    };
    if bountyRecord.WantedStars() == 0 {
      rarityString = EnumValueToString("gamedataNPCRarity", Cast<Int64>(EnumInt(target.GetNPCRarity())));
      mean = TweakDBInterface.GetFloat(TDBID.Create("Constants.BountySystem.meanStars" + rarityString), 3.00);
      standardDeviation = TweakDBInterface.GetFloat(TDBID.Create("Constants.BountySystem.stdDevStars" + rarityString), 1.00);
      wantedStarCount = MathHelper.RandFromNormalDist(mean, standardDeviation);
      bounty.m_wantedStars = Clamp(RoundMath(wantedStarCount), 1, 5);
    } else {
      bounty.m_wantedStars = bountyRecord.WantedStars();
    };
    NPCPuppet.SetBountyObject(target, bounty);
    return bounty;
  }

  private final static func GetTransgressionRecords(const transgressions: script_ref<[TweakDBID]>) -> [wref<Transgression_Record>] {
    let record: wref<Transgression_Record>;
    let records: array<wref<Transgression_Record>>;
    let i: Int32 = 0;
    while i < ArraySize(Deref(transgressions)) {
      record = TweakDBInterface.GetTransgressionRecord(Deref(transgressions)[i]);
      if IsDefined(record) {
        ArrayPush(records, record);
      };
      i += 1;
    };
    return records;
  }

  public final static func CompleteBounty(target: wref<NPCPuppet>) -> Void {
    let bountyCompleteEvent: ref<BountyCompletionEvent>;
    let expEvt: ref<ExperiencePointsEvent>;
    let rarity: gamedataNPCRarity;
    let rewardID: TweakDBID;
    let player: wref<PlayerPuppet> = GetPlayer(target.GetGame());
    let bounty: Bounty = target.GetBounty();
    if bounty.m_awarded {
      return;
    };
    if ArraySize(bounty.m_transgressions) <= 0 {
      bounty = BountyManager.GenerateBounty(target);
    };
    if GameInstance.GetStatsSystem(player.GetGame()).GetStatValue(Cast<StatsObjectID>(player.GetEntityID()), gamedataStatType.HasLinkToBountySystem) > 0.00 {
      expEvt = new ExperiencePointsEvent();
      expEvt.amount = bounty.m_streetCredAmount;
      expEvt.type = gamedataProficiencyType.StreetCred;
      expEvt.isDebug = false;
      player.QueueEvent(expEvt);
      GameInstance.GetTransactionSystem(target.GetGame()).GiveItem(player, MarketSystem.Money(), bounty.m_moneyAmount);
      NPCPuppet.SetBountyObject(target, bounty);
      bountyCompleteEvent = new BountyCompletionEvent();
      bountyCompleteEvent.streetCredAwarded = bounty.m_streetCredAmount;
      bountyCompleteEvent.moneyAwarded = bounty.m_moneyAmount;
      GameInstance.GetUISystem(player.GetGame()).QueueEvent(bountyCompleteEvent);
    };
    target.SetBountyAwarded(true);
    if target.AwardsExperience() {
      rarity = target.GetNPCRarity();
      switch rarity {
        case gamedataNPCRarity.Trash:
          rewardID = t"RPGActionRewards.NeutralizeTrashEnemy";
          break;
        case gamedataNPCRarity.Weak:
          rewardID = t"RPGActionRewards.NeutralizeWeakEnemy";
          break;
        case gamedataNPCRarity.Normal:
          rewardID = t"RPGActionRewards.NeutralizeNormalEnemy";
          break;
        case gamedataNPCRarity.Rare:
          rewardID = t"RPGActionRewards.NeutralizeRareEnemy";
          break;
        case gamedataNPCRarity.Officer:
          rewardID = t"RPGActionRewards.NeutralizeRareEnemy";
          break;
        case gamedataNPCRarity.Elite:
          rewardID = t"RPGActionRewards.NeutralizeEliteEnemy";
          break;
        case gamedataNPCRarity.Boss:
          rewardID = t"RPGActionRewards.NeutralizeBossEnemy";
      };
      RPGManager.GiveReward(target.GetGame(), rewardID, Cast<StatsObjectID>(target.GetEntityID()));
    };
  }
}

public class SetBountyEvent extends Event {

  @runtimeProperty("customEditor", "TweakDBGroupInheritance;Bounty")
  public edit let bountyID: TweakDBID;

  public final func GetFriendlyDescription() -> String {
    return "Set Bounty";
  }
}
