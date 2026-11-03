
public static func InitializeScripts() -> Void {
  StatsEffectsEnumToTDBID(-1);
}

public static func ProcessCompare(comparator: EComparisonType, valA: Float, valB: Float) -> Bool {
  switch comparator {
    case EComparisonType.Greater:
      return valA > valB;
    case EComparisonType.GreaterOrEqual:
      return valA >= valB;
    case EComparisonType.Equal:
      return valA == valB;
    case EComparisonType.NotEqual:
      return valA != valB;
    case EComparisonType.Less:
      return valA < valB;
    default:
      return valA <= valB;
  };
}

public static func ProcessCompareInt(comparator: EComparisonType, valA: Int32, valB: Int32) -> Bool {
  switch comparator {
    case EComparisonType.Greater:
      return valA > valB;
    case EComparisonType.GreaterOrEqual:
      return valA >= valB;
    case EComparisonType.Equal:
      return valA == valB;
    case EComparisonType.NotEqual:
      return valA != valB;
    case EComparisonType.Less:
      return valA < valB;
    default:
      return valA <= valB;
  };
}
