
public class HitHistory extends IScriptable {

  private let m_hitHistory: [HitHistoryItem];

  @default(HitHistory, 5)
  private let m_maxEntries: Int32;

  public final func AddHit(evt: ref<gameHitEvent>) -> Void {
    let hitTime: Float;
    let instigator: wref<GameObject> = null;
    let attackType: gamedataAttackType = gamedataAttackType.Invalid;
    if IsDefined(evt.attackData) {
      instigator = evt.attackData.GetInstigator();
      attackType = evt.attackData.GetAttackType();
    };
    if IsDefined(instigator) {
      hitTime = EngineTime.ToFloat(GameInstance.GetSimTime(instigator.GetGame()));
      this.Add(instigator, hitTime, attackType);
    };
  }

  public final func GetLastDamageTime(object: ref<GameObject>, out isMelee: Bool) -> Float {
    let i: Int32 = 0;
    while i < ArraySize(this.m_hitHistory) {
      if this.m_hitHistory[i].instigator == object {
        isMelee = AttackData.IsMelee(this.m_hitHistory[i].attackType);
        return this.m_hitHistory[i].hitTime;
      };
      i += 1;
    };
    return -1.00;
  }

  public final func GetLastDamageType(instigator: ref<GameObject>) -> gamedataAttackType {
    let i: Int32 = 0;
    while i < ArraySize(this.m_hitHistory) {
      if this.m_hitHistory[i].instigator == instigator {
        return this.m_hitHistory[i].attackType;
      };
      i += 1;
    };
    return gamedataAttackType.Invalid;
  }

  private final func Add(instigator: wref<GameObject>, hitTime: Float, attackType: gamedataAttackType) -> Void {
    let hitHistoryItem: HitHistoryItem;
    let oldestEntryTime: Float = -1.00;
    let oldestEntryNdx: Int32 = -1;
    let entryNdx: Int32 = -1;
    let i: Int32 = 0;
    while i < ArraySize(this.m_hitHistory) {
      if this.m_hitHistory[i].instigator == instigator {
        entryNdx = i;
        break;
      };
      if oldestEntryTime == -1.00 || oldestEntryTime > this.m_hitHistory[i].hitTime {
        oldestEntryNdx = i;
        oldestEntryTime = this.m_hitHistory[i].hitTime;
      };
      i += 1;
    };
    hitHistoryItem.instigator = instigator;
    hitHistoryItem.hitTime = hitTime;
    hitHistoryItem.attackType = attackType;
    if entryNdx == -1 {
      if ArraySize(this.m_hitHistory) < this.m_maxEntries {
        ArrayPush(this.m_hitHistory, hitHistoryItem);
      } else {
        this.m_hitHistory[oldestEntryNdx] = hitHistoryItem;
      };
    } else {
      this.m_hitHistory[entryNdx] = hitHistoryItem;
    };
  }
}
