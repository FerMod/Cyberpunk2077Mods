
public class ResourceLibraryComponent extends ScriptableComponent {

  @runtimeProperty("category", "Effects Resources")
  private edit const let resources: [FxResourceMapData];

  public final const func GetResource(key: CName) -> FxResource {
    let resource: FxResource;
    let i: Int32 = 0;
    while i < ArraySize(this.resources) {
      if Equals(this.resources[i].key, key) {
        resource = this.resources[i].resource;
        break;
      };
      i += 1;
    };
    return resource;
  }
}
