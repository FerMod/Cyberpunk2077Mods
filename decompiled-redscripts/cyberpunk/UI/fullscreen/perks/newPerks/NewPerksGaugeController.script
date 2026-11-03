
public class NewPerksGaugeController extends inkLogicController {

  public edit let m_bar: inkWidgetRef;

  public edit let m_possibleBar: inkWidgetRef;

  public edit let m_currentLevelIndicator: inkWidgetRef;

  public edit let m_possibleLevelIndicator: inkWidgetRef;

  public edit let m_levelText: inkTextRef;

  public edit const let m_levels: [NewPerksGaugePointDetails];

  private final func SetBottomMargin(widget: inkWidgetRef, bottomMargin: Float) -> Void {
    let margin: inkMargin = inkWidgetRef.GetMargin(widget);
    margin.bottom = bottomMargin;
    inkWidgetRef.SetMargin(widget, margin);
  }

  public final func RefreshLevelRequirementsFromTDB() -> Void {
    let level: Int32 = TDB.GetInt(t"NewPerks.NoviceNewPerkTier.requiredAttributePoints");
    this.m_levels[1].m_level = level;
    level = TDB.GetInt(t"NewPerks.AdeptNewPerkTier.requiredAttributePoints");
    this.m_levels[2].m_level = level;
    level = TDB.GetInt(t"NewPerks.ExpertNewPerkTier.requiredAttributePoints");
    this.m_levels[3].m_level = level;
    level = TDB.GetInt(t"NewPerks.MasterNewPerkTier.requiredAttributePoints");
    this.m_levels[4].m_level = level;
  }

  public final func UpdateLevel(currentLevel: Int32, possibleLevel: Int32) -> Void {
    let i: Int32;
    let isOnAnyLevel: Bool;
    let limit: Int32;
    let possibleHeight: Float;
    let currentHeight: Float = this.GetHeight(currentLevel);
    if currentLevel != possibleLevel {
      possibleHeight = this.GetHeight(possibleLevel) - currentHeight;
      inkWidgetRef.SetVisible(this.m_possibleBar, true);
      inkWidgetRef.SetVisible(this.m_possibleLevelIndicator, true);
      inkWidgetRef.SetHeight(this.m_possibleBar, Cast<Float>(CeilF(possibleHeight)));
      this.SetBottomMargin(this.m_possibleBar, Cast<Float>(CeilF(currentHeight)));
      this.SetBottomMargin(this.m_possibleLevelIndicator, Cast<Float>(CeilF(currentHeight + possibleHeight)));
    } else {
      inkWidgetRef.SetVisible(this.m_possibleBar, false);
      inkWidgetRef.SetVisible(this.m_possibleLevelIndicator, false);
    };
    i = 0;
    limit = ArraySize(this.m_levels);
    while i < limit {
      if this.m_levels[i].m_level == currentLevel {
        isOnAnyLevel = true;
      };
      inkWidgetRef.SetState(this.m_levels[i].m_widget, this.m_levels[i].m_level <= currentLevel ? n"Achieved" : n"Default");
      i += 1;
    };
    inkTextRef.SetText(this.m_levelText, IntToString(currentLevel));
    inkWidgetRef.SetVisible(this.m_levelText, !isOnAnyLevel);
    inkWidgetRef.SetHeight(this.m_bar, Cast<Float>(CeilF(currentHeight)));
    this.SetBottomMargin(this.m_currentLevelIndicator, Cast<Float>(CeilF(currentHeight)));
  }

  public final func GetLevels() -> [NewPerksGaugePointDetails] {
    return this.m_levels;
  }

  private final func GetHeight(level: Int32) -> Float {
    let height: Float;
    let i: Int32;
    let levelDiff: Int32;
    let limit: Int32 = ArraySize(this.m_levels);
    if limit > 2 {
      height += Cast<Float>(Min(level, this.m_levels[1].m_level)) * this.m_levels[1].m_height / Cast<Float>(this.m_levels[1].m_level);
      level -= Min(level, this.m_levels[1].m_level);
      i = 2;
      while i < limit {
        levelDiff = this.m_levels[i].m_level - this.m_levels[i - 1].m_level;
        height += Cast<Float>(Min(level, levelDiff)) * (this.m_levels[i].m_height - this.m_levels[i - 1].m_height) / Cast<Float>(levelDiff);
        level -= Min(level, levelDiff);
        i += 1;
      };
    };
    return height;
  }
}
