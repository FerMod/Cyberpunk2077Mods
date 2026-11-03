
public class PerksMenuAttributeDisplayController extends BaseButtonView {

  protected edit let m_widgetWrapper: inkWidgetRef;

  protected edit let m_foregroundWrapper: inkWidgetRef;

  protected edit let m_attributeName: inkTextRef;

  protected edit let m_attributeIcon: inkImageRef;

  protected edit let m_attributeLevel: inkTextRef;

  protected edit let m_frameHovered: inkWidgetRef;

  protected edit let m_accent1Hovered: inkWidgetRef;

  protected edit let m_accent1BGHovered: inkWidgetRef;

  protected edit let m_accent2Hovered: inkWidgetRef;

  protected edit let m_accent2BGHovered: inkWidgetRef;

  protected edit let m_topConnectionContainer: inkWidgetRef;

  protected edit let m_bottomConnectionContainer: inkWidgetRef;

  protected edit let m_levelContainer: inkWidgetRef;

  protected let m_dataManager: ref<PlayerDevelopmentDataManager>;

  protected let m_attribute: PerkMenuAttribute;

  protected let m_attributeData: ref<AttributeData>;

  protected cb func OnInitialize() -> Bool {
    this.ResetHoverOpacity();
    super.OnInitialize();
  }

  public final func Setup(attribute: PerkMenuAttribute, dataManager: ref<PlayerDevelopmentDataManager>) -> Void {
    this.m_dataManager = dataManager;
    this.m_attribute = attribute;
    this.m_attributeData = dataManager.GetAttribute(this.m_dataManager.GetAttributeRecordIDFromEnum(attribute));
    inkWidgetRef.SetVisible(this.m_levelContainer, NotEquals(attribute, PerkMenuAttribute.Espionage));
    this.GetRootWidget().SetState(NotEquals(attribute, PerkMenuAttribute.Espionage) ? n"Default" : n"Espionage");
    this.ResetHoverOpacity();
    this.Update();
  }

  public final func UpdateData(attributeData: ref<AttributeData>) -> Void {
    this.m_attributeData = attributeData;
    this.Update();
  }

  public final func GetStatType() -> gamedataStatType {
    return this.m_attributeData.type;
  }

  public final func SetHovered(value: Bool) -> Void {
    this.PlayHoverAnimation(value);
    inkWidgetRef.SetState(this.m_widgetWrapper, value ? n"Hovered" : n"Default");
    if Equals(this.m_attribute, PerkMenuAttribute.Johnny) {
      inkWidgetRef.Get(this.m_widgetWrapper).SetEffectEnabled(inkEffectType.Glitch, n"Glitch_0", value);
    };
  }

  public final func GetAttributeData() -> ref<AttributeData> {
    return this.m_attributeData;
  }

  protected final func Update() -> Void {
    this.UpdateConnections();
    if Equals(this.m_attribute, PerkMenuAttribute.Johnny) {
      return;
    };
    this.UpdateIcon();
    this.UpdateName();
    this.UpdateLevel();
  }

  protected final func UpdateIcon() -> Void {
    let relicIcon: ResRef = r"base\\gameplay\\gui\\fullscreen\\perks\\atlas_perks.inkatlas";
    let attributeIcon: ResRef = r"base\\gameplay\\gui\\common\\icons\\attributes_icons.inkatlas";
    if Equals(this.m_attribute, PerkMenuAttribute.Espionage) {
      inkImageRef.SetAtlasResource(this.m_attributeIcon, relicIcon);
      inkImageRef.SetTexturePart(this.m_attributeIcon, n"ico_atrib_relic");
    } else {
      inkImageRef.SetAtlasResource(this.m_attributeIcon, attributeIcon);
      inkImageRef.SetTexturePart(this.m_attributeIcon, PerkAttributeHelper.GetIconAtlasPart(this.m_attribute));
    };
  }

  protected final func UpdateName() -> Void {
    inkTextRef.SetText(this.m_attributeName, this.m_attributeData.label);
  }

  protected final func UpdateLevel() -> Void {
    inkTextRef.SetText(this.m_attributeLevel, IntToString(this.m_attributeData.value));
  }

  protected final func UpdateConnections() -> Void {
    inkWidgetRef.SetState(this.m_topConnectionContainer, PerkAttributeHelper.GetTopConnectionState(this.m_attribute));
    inkWidgetRef.SetState(this.m_bottomConnectionContainer, PerkAttributeHelper.GetBottomConnectionState(this.m_attribute));
  }

  protected final func PlayHoverAnimation(value: Bool) -> Void {
    let transparencyInterpolator2: ref<inkAnimTransparency>;
    let transparencyAnimation: ref<inkAnimDef> = new inkAnimDef();
    let transparencyAnimation2: ref<inkAnimDef> = new inkAnimDef();
    let transparencyInterpolator: ref<inkAnimTransparency> = new inkAnimTransparency();
    transparencyInterpolator.SetDuration(0.35);
    transparencyInterpolator.SetDirection(inkanimInterpolationDirection.To);
    transparencyInterpolator.SetType(inkanimInterpolationType.Linear);
    transparencyInterpolator.SetMode(inkanimInterpolationMode.EasyIn);
    transparencyInterpolator.SetEndTransparency(value ? 1.00 : 0.00);
    transparencyInterpolator2 = new inkAnimTransparency();
    transparencyInterpolator2.SetDuration(0.35);
    transparencyInterpolator2.SetDirection(inkanimInterpolationDirection.To);
    transparencyInterpolator2.SetType(inkanimInterpolationType.Linear);
    transparencyInterpolator2.SetMode(inkanimInterpolationMode.EasyIn);
    transparencyInterpolator2.SetEndTransparency(value ? 0.13 : 0.00);
    transparencyAnimation.AddInterpolator(transparencyInterpolator);
    transparencyAnimation2.AddInterpolator(transparencyInterpolator2);
    inkWidgetRef.PlayAnimation(this.m_frameHovered, transparencyAnimation);
    inkWidgetRef.PlayAnimation(this.m_accent1Hovered, transparencyAnimation);
    inkWidgetRef.PlayAnimation(this.m_accent2Hovered, transparencyAnimation);
    inkWidgetRef.PlayAnimation(this.m_accent1BGHovered, transparencyAnimation2);
    inkWidgetRef.PlayAnimation(this.m_accent2BGHovered, transparencyAnimation2);
  }

  public final func PlayAnimation(animation: CName) -> ref<inkAnimProxy> {
    return this.PlayLibraryAnimation(animation);
  }

  private final func ResetHoverOpacity() -> Void {
    inkWidgetRef.SetOpacity(this.m_frameHovered, 0.00);
    inkWidgetRef.SetOpacity(this.m_accent1Hovered, 0.00);
    inkWidgetRef.SetOpacity(this.m_accent2Hovered, 0.00);
    inkWidgetRef.SetOpacity(this.m_accent1BGHovered, 0.00);
    inkWidgetRef.SetOpacity(this.m_accent2BGHovered, 0.00);
  }
}

public struct PerkAttributeHelper {

  public final static func GetTopConnectionState(attribute: PerkMenuAttribute) -> CName {
    switch attribute {
      case PerkMenuAttribute.Technical_Ability:
      case PerkMenuAttribute.Reflex:
      case PerkMenuAttribute.Body:
        return n"Text";
      case PerkMenuAttribute.Johnny:
      case PerkMenuAttribute.Intelligence:
      case PerkMenuAttribute.Cool:
        return n"Image";
    };
    return n"Default";
  }

  public final static func GetBottomConnectionState(attribute: PerkMenuAttribute) -> CName {
    switch attribute {
      case PerkMenuAttribute.Technical_Ability:
      case PerkMenuAttribute.Reflex:
      case PerkMenuAttribute.Body:
        return n"Image";
      case PerkMenuAttribute.Johnny:
      case PerkMenuAttribute.Intelligence:
      case PerkMenuAttribute.Cool:
        return n"Text";
    };
    return n"Default";
  }

  public final static func GetName(attribute: PerkMenuAttribute) -> String {
    switch attribute {
      case PerkMenuAttribute.Body:
        return "Body";
      case PerkMenuAttribute.Reflex:
        return "Reflex";
      case PerkMenuAttribute.Technical_Ability:
        return "Technical Ability";
      case PerkMenuAttribute.Cool:
        return "Cool";
      case PerkMenuAttribute.Intelligence:
        return "Intelligence";
      case PerkMenuAttribute.Espionage:
        return "Espionage";
    };
    return "";
  }

  public final static func GetIconAtlasPart(attribute: PerkMenuAttribute) -> CName {
    switch attribute {
      case PerkMenuAttribute.Body:
        return n"ico_body";
      case PerkMenuAttribute.Reflex:
        return n"ico_ref";
      case PerkMenuAttribute.Technical_Ability:
        return n"ico_tech";
      case PerkMenuAttribute.Cool:
        return n"ico_cool";
      case PerkMenuAttribute.Intelligence:
        return n"ico_int";
      case PerkMenuAttribute.Espionage:
        return n"ico_ep1_tree";
    };
    return n"undiscovered";
  }

  public final static func GetShortNameLocKey(attribute: PerkMenuAttribute) -> String {
    switch attribute {
      case PerkMenuAttribute.Body:
        return "LocKey#43676";
      case PerkMenuAttribute.Reflex:
        return "LocKey#43679";
      case PerkMenuAttribute.Technical_Ability:
        return "LocKey#43680";
      case PerkMenuAttribute.Cool:
        return "LocKey#43677";
      case PerkMenuAttribute.Intelligence:
        return "LocKey#43678";
    };
    return "";
  }

  public final static func BaseStatToAttribute(statType: gamedataStatType) -> TweakDBID {
    switch statType {
      case gamedataStatType.Strength:
        return t"NewPerks.BodyAttributeData";
      case gamedataStatType.Reflexes:
        return t"NewPerks.ReflexesAttributeData";
      case gamedataStatType.Intelligence:
        return t"NewPerks.IntelligenceAttributeData";
      case gamedataStatType.TechnicalAbility:
        return t"NewPerks.TechnicalAbilityAttributeData";
      case gamedataStatType.Cool:
        return t"NewPerks.CoolAttributeData";
      case gamedataStatType.Espionage:
        return t"NewPerks.EspionageAttributeData";
    };
    return TDBID.None();
  }

  public final static func BaseStatToPerkMenuAttribute(statType: gamedataStatType) -> PerkMenuAttribute {
    switch statType {
      case gamedataStatType.Strength:
        return PerkMenuAttribute.Body;
      case gamedataStatType.Reflexes:
        return PerkMenuAttribute.Reflex;
      case gamedataStatType.Intelligence:
        return PerkMenuAttribute.Intelligence;
      case gamedataStatType.TechnicalAbility:
        return PerkMenuAttribute.Technical_Ability;
      case gamedataStatType.Cool:
        return PerkMenuAttribute.Cool;
      case gamedataStatType.Espionage:
        return PerkMenuAttribute.Espionage;
    };
    return PerkMenuAttribute.Invalid;
  }

  public final static func PerkMenuAttributeToStat(perkMenuAttribute: PerkMenuAttribute) -> gamedataStatType {
    switch perkMenuAttribute {
      case PerkMenuAttribute.Body:
        return gamedataStatType.Strength;
      case PerkMenuAttribute.Reflex:
        return gamedataStatType.Reflexes;
      case PerkMenuAttribute.Intelligence:
        return gamedataStatType.Intelligence;
      case PerkMenuAttribute.Technical_Ability:
        return gamedataStatType.TechnicalAbility;
      case PerkMenuAttribute.Cool:
        return gamedataStatType.Cool;
      case PerkMenuAttribute.Espionage:
        return gamedataStatType.Espionage;
    };
    return gamedataStatType.Invalid;
  }

  public final static func PerkMenuAttributeToAttributeDataType(perkMenuAttribute: PerkMenuAttribute) -> gamedataAttributeDataType {
    switch perkMenuAttribute {
      case PerkMenuAttribute.Body:
        return gamedataAttributeDataType.BodyAttributeData;
      case PerkMenuAttribute.Reflex:
        return gamedataAttributeDataType.ReflexesAttributeData;
      case PerkMenuAttribute.Intelligence:
        return gamedataAttributeDataType.IntelligenceAttributeData;
      case PerkMenuAttribute.Technical_Ability:
        return gamedataAttributeDataType.TechnicalAbilityAttributeData;
      case PerkMenuAttribute.Cool:
        return gamedataAttributeDataType.CoolAttributeData;
      case PerkMenuAttribute.Espionage:
        return gamedataAttributeDataType.EspionageAttributeData;
    };
    return gamedataAttributeDataType.Invalid;
  }
}
