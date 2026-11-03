
public class DialerContactDataView extends ScriptableDataView {

  private let m_compareBuilder: ref<CompareBuilder>;

  public let m_sortMethod: ContactsSortMethod;

  public final func Setup() -> Void {
    this.m_compareBuilder = CompareBuilder.Make();
    this.m_sortMethod = ContactsSortMethod.ByName;
  }

  public func SortItem(left: ref<IScriptable>, right: ref<IScriptable>) -> Bool {
    let leftData: ref<ContactData> = left as ContactData;
    let rightData: ref<ContactData> = right as ContactData;
    this.m_compareBuilder.Reset();
    return Equals(this.m_sortMethod, ContactsSortMethod.ByTime) ? this.SortByTime(leftData, rightData) : this.SortByName(leftData, rightData);
  }

  public func FilterItem(data: ref<IScriptable>) -> Bool {
    return true;
  }

  private final func SortByTime(leftData: wref<ContactData>, rightData: wref<ContactData>) -> Bool {
    return this.m_compareBuilder.BoolTrue(leftData.questRelated, rightData.questRelated).BoolTrue(leftData.hasQuestImportantReply, rightData.hasQuestImportantReply).GameTimeDesc(leftData.timeStamp, rightData.timeStamp).GetBool();
  }

  private final func SortByName(leftData: wref<ContactData>, rightData: wref<ContactData>) -> Bool {
    return this.m_compareBuilder.BoolTrue(leftData.questRelated, rightData.questRelated).BoolTrue(leftData.hasQuestImportantReply, rightData.hasQuestImportantReply).BoolTrue(leftData.isCallable, rightData.isCallable).UnicodeStringAsc(GetLocalizedText(leftData.localizedName), GetLocalizedText(rightData.localizedName)).GetBool();
  }
}

public class DialerContactTemplateClassifier extends inkVirtualItemTemplateClassifier {

  public func ClassifyItem(data: Variant) -> Uint32 {
    let contactData: ref<ContactData> = FromVariant<ref<IScriptable>>(data) as ContactData;
    switch contactData.type {
      case MessengerContactType.Contact:
        return 1u;
      case MessengerContactType.Fake_ShowAll:
        return 3u;
      default:
        return 0u;
    };
  }
}
