
public class FactTextGameController extends inkGameController {

  private edit const let m_factTextArray: [FactTextStruct];

  protected cb func OnInitialize() -> Bool {
    let factTextIteration: FactTextStruct;
    let locKeyNum: Int32;
    let i: Int32 = 0;
    while i < ArraySize(this.m_factTextArray) {
      factTextIteration = this.m_factTextArray[i];
      locKeyNum = GetFact(this.GetPlayerControlledObject().GetGame(), factTextIteration.m_factName);
      if locKeyNum != -1 {
        if ArraySize(factTextIteration.m_locKeyList) <= locKeyNum {
          if !IsFinal() {
            inkWidgetRef.SetVisible(factTextIteration.m_description, true);
            inkTextRef.SetText(factTextIteration.m_description, "ERROR: The fact\'s index is bigger than the array\'s length");
          } else {
            inkWidgetRef.SetVisible(factTextIteration.m_description, false);
          };
        } else {
          inkTextRef.SetLocalizedText(factTextIteration.m_description, factTextIteration.m_locKeyList[locKeyNum]);
          inkWidgetRef.SetVisible(factTextIteration.m_description, true);
        };
      } else {
        inkWidgetRef.SetVisible(factTextIteration.m_description, false);
      };
      i += 1;
    };
  }
}
