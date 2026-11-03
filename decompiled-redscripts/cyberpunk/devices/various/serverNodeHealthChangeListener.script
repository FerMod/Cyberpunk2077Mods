
public class ServerNodeHealthChangeListener extends CustomValueStatPoolsListener {

  private let m_serverNode: wref<ServerNode>;

  public final static func Create(serverNode: ref<ServerNode>) -> ref<ServerNodeHealthChangeListener> {
    let instance: ref<ServerNodeHealthChangeListener> = new ServerNodeHealthChangeListener();
    instance.m_serverNode = serverNode;
    return instance;
  }

  public func OnStatPoolValueChanged(oldValue: Float, newValue: Float, percToPoints: Float) -> Void {
    this.m_serverNode.OnHealthChanged(newValue);
  }
}
