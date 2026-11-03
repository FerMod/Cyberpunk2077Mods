
public class VehicleOfferLogicController extends BaseButtonView {

  private edit let m_vehicleImage: inkImageRef;

  private edit let m_border: inkWidgetRef;

  private edit let m_ownedIndicator: inkWidgetRef;

  private edit let m_nameText: inkTextRef;

  private edit let m_gunImage: inkImageRef;

  private edit let m_rocketImage: inkImageRef;

  private edit let m_custoImage: inkImageRef;

  private edit let m_priceTextWrapper: inkWidgetRef;

  private edit let m_priceText: inkTextRef;

  private edit let m_originalPriceTextWrapper: inkWidgetRef;

  private edit let m_originalPriceText: inkTextRef;

  private edit let m_discountedPriceTextWrapper: inkWidgetRef;

  private edit let m_discountedPriceText: inkTextRef;

  private edit let m_discountWrapper: inkWidgetRef;

  private edit let m_discountText: inkTextRef;

  private edit let m_discoutImage: inkWidgetRef;

  private let m_offerRecord: wref<VehicleOffer_Record>;

  private let m_state: EVehicleOfferState;

  private let m_styleWidget: wref<inkWidget>;

  private let m_discount: Float;

  private let m_discountApplicable: Bool;

  protected cb func OnInitialize() -> Bool {
    this.m_styleWidget = this.GetRootWidget();
    super.OnInitialize();
  }

  public final func SetUp(offerRecord: wref<VehicleOffer_Record>, state: EVehicleOfferState, opt discount: Float) -> Void {
    this.m_offerRecord = offerRecord;
    this.m_discount = discount;
    this.m_discountApplicable = this.m_offerRecord.DiscountApplicable();
    let price: Int32 = this.m_offerRecord.Price().OverrideValue();
    inkWidgetRef.SetVisible(this.m_ownedIndicator, Equals(state, EVehicleOfferState.Owned));
    inkTextRef.SetText(this.m_nameText, this.m_offerRecord.Name());
    inkImageRef.SetAtlasResource(this.m_vehicleImage, this.m_offerRecord.PreviewImage().AtlasResourcePath());
    inkImageRef.SetTexturePart(this.m_vehicleImage, this.m_offerRecord.PreviewImage().AtlasPartName());
    inkWidgetRef.SetVisible(this.m_gunImage, this.m_offerRecord.HasMachineGun());
    inkWidgetRef.SetVisible(this.m_rocketImage, this.m_offerRecord.HasRocketLauncher());
    inkWidgetRef.SetVisible(this.m_custoImage, this.m_offerRecord.HasCustomization());
    inkTextRef.SetText(this.m_priceText, IntToString(price));
    inkTextRef.SetText(this.m_originalPriceText, IntToString(price));
    inkTextRef.SetText(this.m_discountedPriceText, IntToString(VehicleShopUtils.GetDiscountedPrice(price, this.m_discount)));
    inkTextRef.SetText(this.m_discountText, FloatToStringPrec(this.m_discount * 100.00, 0));
    this.UpdateState(state);
  }

  public final func UpdateState(state: EVehicleOfferState) -> Void {
    this.m_state = state;
    this.m_styleWidget.SetState(this.StateValueToName(state));
    this.UpdateDiscountVisibility();
  }

  private final func UpdateDiscountVisibility() -> Void {
    let discountVisible: Bool = this.m_discountApplicable && this.m_discount > 0.00 && NotEquals(this.m_state, EVehicleOfferState.Owned) && NotEquals(this.m_state, EVehicleOfferState.Locked);
    inkWidgetRef.SetVisible(this.m_priceTextWrapper, !discountVisible);
    inkWidgetRef.SetVisible(this.m_originalPriceTextWrapper, discountVisible);
    inkWidgetRef.SetVisible(this.m_discountedPriceTextWrapper, discountVisible);
    inkWidgetRef.SetVisible(this.m_discountWrapper, discountVisible);
    inkWidgetRef.SetVisible(this.m_discoutImage, discountVisible);
  }

  public final func SetHoverState(isHovered: Bool) -> Void {
    if isHovered {
      switch this.m_state {
        case EVehicleOfferState.New:
          this.m_styleWidget.SetState(n"HoverNew");
          break;
        case EVehicleOfferState.Owned:
          this.m_styleWidget.SetState(n"HoverOwned");
          break;
        case EVehicleOfferState.Locked:
          this.m_styleWidget.SetState(n"HoverLocked");
          break;
        default:
          this.m_styleWidget.SetState(n"Hover");
      };
    } else {
      this.UpdateState(Equals(this.m_state, EVehicleOfferState.New) ? EVehicleOfferState.Default : this.m_state);
    };
  }

  private final func StateValueToName(state: EVehicleOfferState) -> CName {
    switch state {
      case EVehicleOfferState.New:
        return n"New";
      case EVehicleOfferState.Owned:
        return n"Owned";
      case EVehicleOfferState.Locked:
        return n"Locked";
      default:
        return n"Default";
    };
  }

  public final func GetOfferRecord() -> wref<VehicleOffer_Record> {
    return this.m_offerRecord;
  }

  public final func GetState() -> EVehicleOfferState {
    return this.m_state;
  }
}
