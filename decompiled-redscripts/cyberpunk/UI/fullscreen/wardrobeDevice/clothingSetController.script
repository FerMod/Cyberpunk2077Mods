
public class ClothingSetController extends BaseButtonView {

  protected edit let m_setName: inkTextRef;

  private let m_clothingSet: ref<ClothingSet>;

  @default(ClothingSetController, false)
  private let m_equipped: Bool;

  @default(ClothingSetController, false)
  private let m_selected: Bool;

  @default(ClothingSetController, false)
  private let m_defined: Bool;

  @default(ClothingSetController, false)
  private let m_isHovered: Bool;

  @default(ClothingSetController, false)
  private let m_hasChanges: Bool;

  @default(ClothingSetController, false)
  private let m_disabled: Bool;

  private let m_styleWidget: wref<inkWidget>;

  protected cb func OnInitialize() -> Bool {
    this.m_clothingSet = new ClothingSet();
    this.m_styleWidget = this.GetRootWidget();
    super.OnInitialize();
  }

  protected func ButtonStateChanged(oldState: inkEButtonState, newState: inkEButtonState) -> Void {
    if Equals(newState, inkEButtonState.Hover) {
      this.m_isHovered = true;
    } else {
      if Equals(oldState, inkEButtonState.Hover) {
        this.m_isHovered = false;
      };
    };
    this.UpdateVisualState();
  }

  private final func UpdateVisualState() -> Void {
    if this.m_disabled {
      if this.m_selected {
        this.m_styleWidget.SetState(n"DisabledSelected");
      } else {
        this.m_styleWidget.SetState(n"Disabled");
      };
    } else {
      if this.m_isHovered {
        if this.m_selected {
          if this.m_equipped {
            this.m_styleWidget.SetState(n"EquippedSelectedHover");
          } else {
            if this.m_defined || this.m_hasChanges {
              this.m_styleWidget.SetState(n"DefaultSelectedHover");
            } else {
              this.m_styleWidget.SetState(n"DisabledSelectedHover");
            };
          };
        } else {
          if this.m_equipped {
            this.m_styleWidget.SetState(n"EquippedHover");
          } else {
            if this.m_defined || this.m_hasChanges {
              this.m_styleWidget.SetState(n"DefaultHover");
            } else {
              this.m_styleWidget.SetState(n"DisabledHover");
            };
          };
        };
      } else {
        if this.m_selected {
          if this.m_equipped {
            this.m_styleWidget.SetState(n"EquippedSelected");
          } else {
            if this.m_defined || this.m_hasChanges {
              this.m_styleWidget.SetState(n"DefaultSelected");
            } else {
              this.m_styleWidget.SetState(n"DisabledSelected");
            };
          };
        } else {
          if this.m_equipped {
            this.m_styleWidget.SetState(n"Equipped");
          } else {
            if this.m_defined || this.m_hasChanges {
              this.m_styleWidget.SetState(n"Default");
            } else {
              this.m_styleWidget.SetState(n"Disabled");
            };
          };
        };
      };
    };
  }

  public final func SetClothingSet(clothingSet: ref<ClothingSet>, showName: Bool) -> Void {
    this.m_clothingSet = clothingSet;
    this.SetDefined(true);
    inkWidgetRef.SetVisible(this.m_setName, showName);
  }

  public final func UpdateNumbering(slotNumber: Int32) -> Void {
    let textParams: ref<inkTextParams> = new inkTextParams();
    textParams.AddNumber("0", slotNumber + 1);
    inkTextRef.SetText(this.m_setName, "{0}", textParams);
    this.m_clothingSet.setID = WardrobeSystem.NumberToWardrobeClothingSetIndex(slotNumber);
  }

  public final func GetClothingSet() -> ref<ClothingSet> {
    return this.m_clothingSet;
  }

  public final func SetSelected(selected: Bool) -> Void {
    this.m_selected = selected;
    this.UpdateVisualState();
  }

  public final func SetDefined(defined: Bool) -> Void {
    this.m_defined = defined;
    this.UpdateVisualState();
  }

  public final func SetEquipped(equipped: Bool) -> Void {
    this.m_equipped = equipped;
    this.UpdateVisualState();
  }

  public final func SetClothingSetChanged(changed: Bool) -> Void {
    this.m_hasChanges = changed;
    this.UpdateVisualState();
  }

  public final func GetDefined() -> Bool {
    return this.m_defined;
  }

  public final func GetEquipped() -> Bool {
    return this.m_equipped;
  }

  public final func GetClothingSetChanged() -> Bool {
    return this.m_hasChanges;
  }

  public final func SetDisabled(disabled: Bool) -> Void {
    this.m_disabled = disabled;
    this.UpdateVisualState();
  }

  public final func IsDisabled() -> Bool {
    return this.m_disabled;
  }

  public final func IsHovered() -> Bool {
    return this.m_isHovered;
  }
}
