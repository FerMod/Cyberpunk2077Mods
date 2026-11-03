
public class RipperdocBarTooltip extends AGenericTooltipController {

  @runtimeProperty("category", "Main")
  private edit let m_statsHolder: inkWidgetRef;

  @runtimeProperty("category", "Main")
  private edit let m_perksHolder: inkWidgetRef;

  @runtimeProperty("category", "Main")
  private edit let m_capacityDescription: inkWidgetRef;

  @runtimeProperty("category", "Main")
  private edit let m_armorDescription: inkWidgetRef;

  @runtimeProperty("category", "Main")
  private edit let m_armorReductionDescription: inkTextRef;

  @runtimeProperty("category", "Title")
  private edit let m_titleHolder: inkWidgetRef;

  @runtimeProperty("category", "Title")
  private edit let m_titleName: inkTextRef;

  @runtimeProperty("category", "Title")
  private edit let m_titleTotalValue: inkTextRef;

  @runtimeProperty("category", "Title")
  private edit let m_titleMaxValue: inkTextRef;

  @runtimeProperty("category", "Stats")
  private edit let m_stats1: inkWidgetRef;

  @runtimeProperty("category", "Stats")
  private edit let m_stats1Name: inkTextRef;

  @runtimeProperty("category", "Stats")
  private edit let m_stats1Value: inkTextRef;

  @runtimeProperty("category", "Stats")
  private edit let m_stats2: inkWidgetRef;

  @runtimeProperty("category", "Stats")
  private edit let m_stats2Name: inkTextRef;

  @runtimeProperty("category", "Stats")
  private edit let m_stats2Value: inkTextRef;

  @runtimeProperty("category", "Stats")
  private edit let m_stats3: inkWidgetRef;

  @runtimeProperty("category", "Stats")
  private edit let m_stats3Name: inkTextRef;

  @runtimeProperty("category", "Stats")
  private edit let m_stats3Value: inkTextRef;

  @runtimeProperty("category", "Perks")
  private edit let m_perkTypeName: inkTextRef;

  @runtimeProperty("category", "Perks")
  private edit let m_perk1: inkWidgetRef;

  @runtimeProperty("category", "Perks")
  private edit let m_perk1Icon: inkImageRef;

  @runtimeProperty("category", "Perks")
  private edit let m_perk1Name: inkTextRef;

  @runtimeProperty("category", "Perks")
  private edit let m_perk2: inkWidgetRef;

  @runtimeProperty("category", "Perks")
  private edit let m_perk2Icon: inkImageRef;

  @runtimeProperty("category", "Perks")
  private edit let m_perk2Name: inkTextRef;

  @runtimeProperty("category", "Perks")
  private edit let m_perkTreeInput: inkWidgetRef;

  @runtimeProperty("category", "Perks")
  private edit let m_perkTreeIcon: inkImageRef;

  @runtimeProperty("category", "Resources Capacity")
  private edit let m_capacityTitleNameLocKey: CName;

  @runtimeProperty("category", "Resources Capacity")
  private edit let m_capacityStat1LocKey: CName;

  @runtimeProperty("category", "Resources Capacity")
  private edit let m_capacityStat2LocKey: CName;

  @runtimeProperty("category", "Resources Capacity")
  private edit let m_capacityStat3LocKey: CName;

  @runtimeProperty("category", "Resources Capacity")
  private edit let m_capacityPerkTitleLocKey: CName;

  @runtimeProperty("category", "Resources Capacity")
  private edit let m_capacityPerk1IconsName: CName;

  @runtimeProperty("category", "Resources Capacity")
  private edit let m_capacityPerk1LocKey: CName;

  @runtimeProperty("category", "Resources Capacity")
  private edit let m_capacityPerk2IconsName: CName;

  @runtimeProperty("category", "Resources Capacity")
  private edit let m_capacityPerk2LocKey: CName;

  @runtimeProperty("category", "Resources Armor")
  private edit let m_armorTitleNameLocKey: CName;

  @runtimeProperty("category", "Resources Armor")
  private edit let m_armorStat1LocKey: CName;

  @runtimeProperty("category", "Resources Armor")
  private edit let m_armorStat2LocKey: CName;

  @runtimeProperty("category", "Resources Armor")
  private edit let m_armorStat3LocKey: CName;

  @runtimeProperty("category", "Resources Armor")
  private edit let m_armorPerkTitleLocKey: CName;

  @runtimeProperty("category", "Resources Armor")
  private edit let m_armorPerk1IconsName: CName;

  @runtimeProperty("category", "Resources Armor")
  private edit let m_armorPerk1LocKey: CName;

  public func SetData(tooltipData: ref<ATooltipData>) -> Void {
    let i: Int32;
    let val: Int32;
    let data: ref<RipperdocBarTooltipTooltipData> = tooltipData as RipperdocBarTooltipTooltipData;
    let isCapacityOverallocated: Bool = false;
    inkWidgetRef.SetVisible(this.m_capacityDescription, false);
    inkWidgetRef.SetVisible(this.m_armorDescription, false);
    inkWidgetRef.SetVisible(this.m_armorReductionDescription, false);
    if IsDefined(data) {
      inkTextRef.SetText(this.m_titleTotalValue, IntToString(data.totalValue));
      inkTextRef.SetText(this.m_titleMaxValue, IntToString(data.maxValue));
      if Equals(data.barType, BarType.CurrentCapacity) {
        inkTextRef.SetLocalizedText(this.m_titleName, this.m_capacityTitleNameLocKey);
        inkWidgetRef.SetVisible(this.m_capacityDescription, true);
        inkTextRef.SetLocalizedText(this.m_perkTypeName, this.m_capacityPerkTitleLocKey);
        if data.capacityPerk1Bought {
          i = 0;
          while i < ArraySize(data.statsData) {
            if Equals(data.statsData[i].type, gamedataStatType.HumanityAllocated) {
              inkTextRef.SetText(this.m_titleTotalValue, IntToString(data.statsData[i].value));
            };
            if Equals(data.statsData[i].type, gamedataStatType.HumanityTotalMaxValue) {
              inkTextRef.SetText(this.m_titleMaxValue, IntToString(data.statsData[i].value));
            };
            if Equals(data.statsData[i].type, gamedataStatType.HumanityOverallocated) {
              inkTextRef.SetLocalizedText(this.m_stats1Name, this.m_capacityStat1LocKey);
              inkTextRef.SetText(this.m_stats1Value, IntToString(data.statsData[i].value));
              isCapacityOverallocated = data.statsData[i].value > 0;
              inkTextRef.SetLocalizedText(this.m_stats3Name, this.m_capacityStat3LocKey);
              inkTextRef.SetText(this.m_stats3Value, FloatToStringPrec(data.statsData[i].valueF * 0.10, 1) + "%");
            };
            if Equals(data.statsData[i].type, gamedataStatType.EdgerunnerHealthReduction) {
              inkTextRef.SetLocalizedText(this.m_stats2Name, this.m_capacityStat2LocKey);
              if FloatIsEqual(data.statsData[i].valueF, 0.00) {
                inkTextRef.SetText(this.m_stats2Value, IntToString(0));
              } else {
                val = RoundMath(data.health / (1.00 - data.statsData[i].valueF) * data.statsData[i].valueF);
                inkTextRef.SetText(this.m_stats2Value, "-" + IntToString(val));
              };
            };
            i += 1;
          };
          inkWidgetRef.SetVisible(this.m_statsHolder, false);
        } else {
          inkWidgetRef.SetVisible(this.m_statsHolder, false);
        };
        isCapacityOverallocated ? inkWidgetRef.SetState(this.m_titleHolder, n"Edgerunner") : inkWidgetRef.SetState(this.m_titleHolder, n"Default");
        isCapacityOverallocated ? inkWidgetRef.SetState(this.m_stats1, n"Edgerunner") : inkWidgetRef.SetState(this.m_stats1, n"Default");
        isCapacityOverallocated ? inkWidgetRef.SetState(this.m_stats2, n"Edgerunner") : inkWidgetRef.SetState(this.m_stats2, n"Default");
        inkWidgetRef.SetVisible(this.m_perk1, true);
        inkTextRef.SetLocalizedText(this.m_perk1Name, this.m_capacityPerk1LocKey);
        inkImageRef.SetTexturePart(this.m_perk1Icon, this.m_capacityPerk1IconsName);
        data.capacityPerk1Bought ? inkWidgetRef.SetState(this.m_perk1, n"Bought") : inkWidgetRef.SetState(this.m_perk1, n"Default");
        inkWidgetRef.SetVisible(this.m_perk2, true);
        inkTextRef.SetLocalizedText(this.m_perk2Name, this.m_capacityPerk2LocKey);
        inkImageRef.SetTexturePart(this.m_perk2Icon, this.m_capacityPerk2IconsName);
        data.capacityPerk2Bought ? inkWidgetRef.SetState(this.m_perk2, n"Bought") : inkWidgetRef.SetState(this.m_perk2, n"Default");
      } else {
        if Equals(data.barType, BarType.Armor) {
          inkTextRef.SetLocalizedText(this.m_titleName, this.m_armorTitleNameLocKey);
          inkWidgetRef.SetState(this.m_titleHolder, n"Default");
          inkWidgetRef.SetVisible(this.m_armorDescription, true);
          inkTextRef.SetLocalizedText(this.m_perkTypeName, this.m_armorPerkTitleLocKey);
          inkWidgetRef.SetVisible(this.m_statsHolder, false);
          this.ShowArmorReduction(data.maxDamageReduction);
          inkTextRef.SetLocalizedText(this.m_stats1Name, this.m_armorStat1LocKey);
          inkTextRef.SetText(this.m_stats1Value, IntToString(data.statValue));
          inkWidgetRef.SetState(this.m_stats1, n"Default");
          i = 0;
          while i < ArraySize(data.statsData) {
            if Equals(data.statsData[i].type, gamedataStatType.Armor) {
              inkTextRef.SetText(this.m_titleTotalValue, IntToString(data.statsData[i].value));
            };
            if Equals(data.statsData[i].type, gamedataStatType.MitigationChance) {
              inkTextRef.SetText(this.m_stats2Name, GetLocalizedText(data.statsData[i].statName));
              inkTextRef.SetText(this.m_stats2Value, FloatToStringPrec(data.statsData[i].valueF, 1) + "%");
              inkWidgetRef.SetState(this.m_stats2, n"Default");
            };
            if Equals(data.statsData[i].type, gamedataStatType.MitigationStrength) {
              inkTextRef.SetText(this.m_stats3Name, GetLocalizedText(data.statsData[i].statName));
              inkTextRef.SetText(this.m_stats3Value, FloatToStringPrec(data.statsData[i].valueF, 0) + "%");
            };
            i += 1;
          };
          inkWidgetRef.SetVisible(this.m_perk1, true);
          inkTextRef.SetText(this.m_perk1Name, this.GetPerkNameLevel(this.m_armorPerk1IconsName, 2));
          inkImageRef.SetTexturePart(this.m_perk1Icon, this.m_armorPerk1IconsName);
          data.armorPerk1Bought ? inkWidgetRef.SetState(this.m_perk1, n"Bought") : inkWidgetRef.SetState(this.m_perk1, n"Default");
          inkWidgetRef.SetVisible(this.m_perk2, false);
        } else {
          if Equals(data.barType, BarType.Edgerunner) {
            inkTextRef.SetLocalizedText(this.m_titleName, this.m_capacityPerk1LocKey);
            inkWidgetRef.SetVisible(this.m_capacityDescription, false);
            inkTextRef.SetLocalizedText(this.m_perkTypeName, this.m_capacityPerkTitleLocKey);
            if data.capacityPerk1Bought {
              i = 0;
              while i < ArraySize(data.statsData) {
                if Equals(data.statsData[i].type, gamedataStatType.HumanityAllocated) {
                  inkTextRef.SetText(this.m_titleTotalValue, IntToString(data.statsData[i].value));
                };
                if Equals(data.statsData[i].type, gamedataStatType.HumanityTotalMaxValue) {
                  inkTextRef.SetText(this.m_titleMaxValue, IntToString(data.statsData[i].value));
                };
                if Equals(data.statsData[i].type, gamedataStatType.HumanityOverallocated) {
                  inkTextRef.SetLocalizedText(this.m_stats1Name, this.m_capacityStat1LocKey);
                  inkTextRef.SetText(this.m_stats1Value, IntToString(data.statsData[i].value));
                  isCapacityOverallocated = data.statsData[i].value > 0;
                  inkTextRef.SetLocalizedText(this.m_stats3Name, this.m_capacityStat3LocKey);
                  inkTextRef.SetText(this.m_stats3Value, FloatToStringPrec(data.statsData[i].valueF * 0.10, 1) + "%");
                };
                if Equals(data.statsData[i].type, gamedataStatType.EdgerunnerHealthReduction) {
                  inkTextRef.SetLocalizedText(this.m_stats2Name, this.m_capacityStat2LocKey);
                  if FloatIsEqual(data.statsData[i].valueF, 0.00) {
                    inkTextRef.SetText(this.m_stats2Value, IntToString(0));
                  } else {
                    val = RoundMath(data.health / (1.00 - data.statsData[i].valueF) * data.statsData[i].valueF);
                    inkTextRef.SetText(this.m_stats2Value, "-" + IntToString(val));
                  };
                };
                i += 1;
              };
              inkWidgetRef.SetVisible(this.m_statsHolder, isCapacityOverallocated);
            } else {
              inkWidgetRef.SetVisible(this.m_statsHolder, false);
            };
            isCapacityOverallocated ? inkWidgetRef.SetState(this.m_titleHolder, n"Edgerunner") : inkWidgetRef.SetState(this.m_titleHolder, n"Default");
            isCapacityOverallocated ? inkWidgetRef.SetState(this.m_stats1, n"Edgerunner") : inkWidgetRef.SetState(this.m_stats1, n"Default");
            isCapacityOverallocated ? inkWidgetRef.SetState(this.m_stats2, n"Edgerunner") : inkWidgetRef.SetState(this.m_stats2, n"Default");
            inkWidgetRef.SetVisible(this.m_perk1, true);
            inkTextRef.SetLocalizedText(this.m_perk1Name, this.m_capacityPerk1LocKey);
            inkImageRef.SetTexturePart(this.m_perk1Icon, this.m_capacityPerk1IconsName);
            data.capacityPerk1Bought ? inkWidgetRef.SetState(this.m_perk1, n"Bought") : inkWidgetRef.SetState(this.m_perk1, n"Default");
            inkWidgetRef.SetVisible(this.m_perk2, true);
            inkTextRef.SetLocalizedText(this.m_perk2Name, this.m_capacityPerk2LocKey);
            inkImageRef.SetTexturePart(this.m_perk2Icon, this.m_capacityPerk2IconsName);
            data.capacityPerk2Bought ? inkWidgetRef.SetState(this.m_perk2, n"Bought") : inkWidgetRef.SetState(this.m_perk2, n"Default");
          };
        };
      };
    };
  }

  private final func ShowArmorReduction(damageReduction: Float) -> Void {
    let parameters: ref<inkTextParams> = new inkTextParams();
    parameters.AddNumber("float_0", damageReduction);
    inkTextRef.SetLocalizedTextScript(this.m_armorReductionDescription, "LocKey#93545", parameters);
    inkWidgetRef.SetVisible(this.m_armorReductionDescription, true);
  }

  private final func GetPerkNameLevel(name: CName, level: Int32) -> String {
    let text: String = GetLocalizedItemNameByCName(this.m_armorPerk1LocKey);
    text += " (";
    text += GetLocalizedItemNameByCName(n"Gameplay-RPG-Skills-LevelName");
    text += " ";
    text += IntToString(level);
    text += ")";
    return text;
  }
}
