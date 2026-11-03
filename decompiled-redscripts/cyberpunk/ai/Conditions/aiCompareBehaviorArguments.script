
public class CompareArgumentsBooleans extends CompareArguments {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(Equals(ScriptExecutionContext.GetArgumentBool(context, this.m_var1), ScriptExecutionContext.GetArgumentBool(context, this.m_var2)));
  }
}

public class CompareArgumentsInts extends CompareArguments {

  public edit let m_comparator: ECompareOp;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(Compare(this.m_comparator, ScriptExecutionContext.GetArgumentInt(context, this.m_var1), ScriptExecutionContext.GetArgumentInt(context, this.m_var2)));
  }
}

public class CompareArgumentsFloats extends CompareArguments {

  public edit let m_comparator: ECompareOp;

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(CompareF(this.m_comparator, ScriptExecutionContext.GetArgumentFloat(context, this.m_var1), ScriptExecutionContext.GetArgumentFloat(context, this.m_var2)));
  }
}

public class CompareArgumentsNames extends CompareArguments {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(Equals(ScriptExecutionContext.GetArgumentName(context, this.m_var1), ScriptExecutionContext.GetArgumentName(context, this.m_var2)));
  }
}

public class CompareArgumentsVectors extends CompareArguments {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(Equals(ScriptExecutionContext.GetArgumentVector(context, this.m_var1), ScriptExecutionContext.GetArgumentVector(context, this.m_var2)));
  }
}

public class CompareArgumentsObjects extends CompareArguments {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(ScriptExecutionContext.GetArgumentObject(context, this.m_var1) == ScriptExecutionContext.GetArgumentObject(context, this.m_var2));
  }
}

public class CompareArgumentsNodeRefs extends CompareArguments {

  protected func Check(context: ScriptExecutionContext) -> AIbehaviorConditionOutcomes {
    return Cast<AIbehaviorConditionOutcomes>(Equals(ScriptExecutionContext.GetArgumentNodeRef(context, this.m_var1), ScriptExecutionContext.GetArgumentNodeRef(context, this.m_var2)));
  }
}
