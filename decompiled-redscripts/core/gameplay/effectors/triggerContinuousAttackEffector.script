
public class TriggerContinuousAttackEffector extends ContinuousEffector {

  public let m_owner: wref<GameObject>;

  public let m_attackTDBID: TweakDBID;

  public let m_attack: ref<Attack_GameEffect>;

  public let m_delayTime: Float;

  public let m_timeDilationDriver: gamedataEffectorTimeDilationDriver;

  protected func Initialize(record: TweakDBID, game: GameInstance, parentRecord: TweakDBID) -> Void {
    let effectorRecord: ref<ContinuousAttackEffector_Record> = TweakDBInterface.GetContinuousAttackEffectorRecord(record);
    this.m_attackTDBID = effectorRecord.AttackRecord().GetID();
    this.m_delayTime = effectorRecord.DelayTime();
    this.m_timeDilationDriver = effectorRecord.TimeDilationDriver().Type();
  }

  protected func Uninitialize(game: GameInstance) -> Void {
    if IsDefined(this.m_attack) {
      this.m_attack.StopAttack();
      this.m_attack = null;
    };
  }

  protected func ContinuousAction(owner: ref<GameObject>, instigator: ref<GameObject>) -> Void {
    let flag: SHitFlag;
    let hitFlags: array<SHitFlag>;
    let i: Int32;
    let sourceObject: wref<GameObject>;
    let tempArr: array<String>;
    if !IsDefined(this.m_attack) {
      tempArr = TweakDBInterface.GetAttackRecord(this.m_attackTDBID).HitFlags();
      i = 0;
      while i < ArraySize(tempArr) {
        flag.flag = IntEnum<hitFlag>(Cast<Int32>(EnumValueFromString("hitFlag", tempArr[i])));
        flag.source = n"Attack";
        ArrayPush(hitFlags, flag);
        i += 1;
      };
      sourceObject = instigator;
      this.m_attack = RPGManager.PrepareGameEffectAttack(owner.GetGame(), instigator, sourceObject, this.m_attackTDBID, owner.GetWorldPosition(), hitFlags, owner, this.m_delayTime);
      switch this.m_timeDilationDriver {
        case gamedataEffectorTimeDilationDriver.Source:
          this.m_attack.OverrideTimeDilationDriver(instigator as TimeDilatable);
          break;
        case gamedataEffectorTimeDilationDriver.Target:
          this.m_attack.OverrideTimeDilationDriver(owner as TimeDilatable);
          break;
        default:
          this.m_attack.OverrideTimeDilationDriver(null);
      };
      this.m_attack.StartAttackContinous();
    } else {
      this.m_attack.SetAttackPosition(owner.GetWorldPosition());
    };
  }
}
