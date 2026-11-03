
public class WrappedGOGRewardPack extends IScriptable {

  public let index: Uint64;

  public let data: GOGRewardPack;

  public final static func Make(index: Uint64, data: script_ref<GOGRewardPack>) -> ref<WrappedGOGRewardPack> {
    let instance: ref<WrappedGOGRewardPack> = new WrappedGOGRewardPack();
    instance.index = index;
    instance.data = Deref(data);
    return instance;
  }
}
