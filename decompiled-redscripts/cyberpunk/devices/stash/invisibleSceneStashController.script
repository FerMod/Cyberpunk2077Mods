
public class InvisibleSceneStashController extends ScriptableDeviceComponent {

  public const func GetPS() -> ref<InvisibleSceneStashControllerPS> {
    return this.GetBasePS() as InvisibleSceneStashControllerPS;
  }
}

public class InvisibleSceneStashControllerPS extends ScriptableDeviceComponentPS {

  protected persistent let m_storedItems: [ItemID];

  public final func StoreItems(const items: script_ref<[ItemID]>) -> Void {
    let i: Int32;
    if ArraySize(this.m_storedItems) > 0 {
      i = 0;
      while i < ArraySize(Deref(items)) {
        ArrayPush(this.m_storedItems, Deref(items)[i]);
        i += 1;
      };
    } else {
      this.m_storedItems = Deref(items);
    };
  }

  public final const func GetItems() -> [ItemID] {
    return this.m_storedItems;
  }

  public final func ClearStoredItems() -> Void {
    ArrayClear(this.m_storedItems);
  }
}
