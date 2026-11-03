
public class SmartWindowController extends ComputerController {

  public const func GetPS() -> ref<SmartWindowControllerPS> {
    return this.GetBasePS() as SmartWindowControllerPS;
  }
}

public class SmartWindowControllerPS extends ComputerControllerPS {

  protected func GetBannerWidgetTweakDBID() -> TweakDBID {
    return t"DevicesUIDefinitions.WindowBannerWidget";
  }

  protected func GetFileThumbnailWidgetTweakDBID() -> TweakDBID {
    return t"DevicesUIDefinitions.WindowFileThumbnailWidget";
  }

  protected func GetMailThumbnailWidgetTweakDBID() -> TweakDBID {
    return t"DevicesUIDefinitions.WindowMailThumbnailWidget";
  }

  protected func GetFileWidgetTweakDBID() -> TweakDBID {
    return t"DevicesUIDefinitions.WindowFileWidget";
  }

  protected func GetMailWidgetTweakDBID() -> TweakDBID {
    return t"DevicesUIDefinitions.WindowMailWidget";
  }

  protected func DetermineGameplayViability(const context: script_ref<GetActionsContext>, hasActiveActions: Bool) -> Bool {
    return SmartWindowViabilityInterpreter.Evaluate(this, hasActiveActions);
  }
}
