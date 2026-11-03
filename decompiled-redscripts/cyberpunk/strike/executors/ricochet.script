
public native class gameEffectExecutor_Ricochet extends EffectExecutor {

  public final func OnSnap(ctx: EffectScriptContext, entity: ref<Entity>) -> Void {
    let data: OutlineData;
    let evt: ref<OutlineRequestEvent> = new OutlineRequestEvent();
    data.outlineType = EOutlineType.GREEN;
    data.outlineOpacity = 1.00;
    let id: CName = n"gameEffectExecutor_Ricochet";
    evt.outlineRequest = OutlineRequest.CreateRequest(id, data);
    evt.outlineDuration = 0.00;
    entity.QueueEvent(evt);
  }
}
