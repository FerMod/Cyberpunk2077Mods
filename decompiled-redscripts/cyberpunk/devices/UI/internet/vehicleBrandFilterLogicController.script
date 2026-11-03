
public class VehicleBrandFilterLogicController extends BaseButtonView {

  private edit let m_brandLogo: inkImageRef;

  private edit let m_brandText: inkTextRef;

  private let m_brand: CName;

  private let m_brandAsString: String;

  private let m_state: EVehicleBrandState;

  private let m_isHovered: Bool;

  private let m_styleWidget: wref<inkWidget>;

  private let m_newOffers: [CName];

  protected cb func OnInitialize() -> Bool {
    this.m_styleWidget = this.GetRootWidget();
    this.m_isHovered = false;
    super.OnInitialize();
  }

  public final func SetUp(brand: CName, state: EVehicleBrandState) -> Void {
    this.m_brand = brand;
    this.m_brandAsString = VehicleShopUtils.BrandToTexturePartString(brand);
    inkImageRef.SetTexturePart(this.m_brandLogo, StringToName(this.m_brandAsString + "_logo"));
    inkTextRef.SetText(this.m_brandText, GetLocalizedText(VehicleShopUtils.BrandToLocKey(this.m_brand)));
    this.UpdateState(state);
  }

  protected func ButtonStateChanged(oldState: inkEButtonState, newState: inkEButtonState) -> Void {
    if Equals(newState, inkEButtonState.Hover) {
      this.UpdateState(EVehicleBrandState.Selected);
    } else {
      if Equals(oldState, inkEButtonState.Hover) {
        this.UpdateState(EVehicleBrandState.Default);
      };
    };
  }

  public final func UpdateState(state: EVehicleBrandState) -> Void {
    this.m_state = state;
    this.RefreshState();
  }

  public final func SetHoverState(isHovered: Bool) -> Void {
    this.m_isHovered = isHovered;
    if this.m_isHovered {
      this.RefreshState();
    } else {
      this.UpdateState(this.m_state);
    };
  }

  public final func RefreshState() -> Void {
    this.m_styleWidget.SetState(this.StateValueToName(this.m_state));
  }

  private final func StateValueToName(state: EVehicleBrandState) -> CName {
    switch state {
      case EVehicleBrandState.New:
        return this.m_isHovered ? n"HoverNew" : n"New";
      case EVehicleBrandState.Selected:
        if this.m_isHovered {
          return this.HasNewOffers() ? n"HoverSelectedNew" : n"HoverSelected";
        };
        return this.HasNewOffers() ? n"SelectedNew" : n"Selected";
      default:
        return this.m_isHovered ? n"Hover" : n"Default";
    };
  }

  public final func AddNewOffer(offerFact: CName) -> Void {
    if !ArrayContains(this.m_newOffers, offerFact) {
      ArrayPush(this.m_newOffers, offerFact);
    };
  }

  public final func RemoveNewOffer(offerFact: CName) -> Void {
    if ArrayContains(this.m_newOffers, offerFact) {
      ArrayRemove(this.m_newOffers, offerFact);
      if ArraySize(this.m_newOffers) == 0 {
        this.UpdateState(EVehicleBrandState.Selected);
      };
    };
  }

  public final func HasNewOffers() -> Bool {
    return ArraySize(this.m_newOffers) > 0;
  }

  public final func GetBrand() -> CName {
    return this.m_brand;
  }
}
