
public class HubMenuUtils extends IScriptable {

  public final static func SetMenuData(menuButton: inkWidgetRef, identifier: HubMenuItems, parentIdentifier: HubMenuItems, fullscreenName: CName, icon: CName, labelKey: CName, opt userData: ref<IScriptable>) -> ref<MenuItemController> {
    let data: MenuData;
    data.label = GetLocalizedTextByKey(labelKey);
    data.icon = icon;
    data.fullscreenName = fullscreenName;
    data.identifier = EnumInt(identifier);
    data.parentIdentifier = EnumInt(parentIdentifier);
    data.userData = userData;
    let menuItemLogicController: ref<MenuItemController> = inkWidgetRef.GetController(menuButton) as MenuItemController;
    menuItemLogicController.Init(data);
    return menuItemLogicController;
  }

  public final static func SetMenuData(menuButton: inkWidgetRef, const data: script_ref<MenuData>) -> ref<MenuItemController> {
    let menuItemLogicController: ref<MenuItemController> = inkWidgetRef.GetController(menuButton) as MenuItemController;
    menuItemLogicController.Init(data);
    return menuItemLogicController;
  }

  public final static func SetMenuHyperlinkData(menuButton: inkWidgetRef, identifier: HubMenuItems, parentIdentifier: HubMenuItems, fullscreenName: CName, icon: CName, labelKey: CName, opt userData: ref<IScriptable>) -> ref<MenuItemController> {
    let menuItemLogicController: ref<MenuItemController> = HubMenuUtils.SetMenuData(menuButton, identifier, parentIdentifier, fullscreenName, icon, labelKey, userData);
    menuItemLogicController.SetHyperlink(true);
    return menuItemLogicController;
  }

  public final static func SetRadialMenuData(menuButton: inkWidgetRef, identifier: HubMenuItems, parentIdentifier: HubMenuItems, fullscreenName: CName, icon: CName, labelKey: CName, opt userData: ref<IScriptable>) -> ref<RadialMenuItemController> {
    let data: MenuData;
    data.label = GetLocalizedTextByKey(labelKey);
    data.icon = icon;
    data.fullscreenName = fullscreenName;
    data.identifier = EnumInt(identifier);
    data.parentIdentifier = EnumInt(parentIdentifier);
    data.userData = userData;
    let menuItemLogicController: ref<RadialMenuItemController> = inkWidgetRef.GetController(menuButton) as RadialMenuItemController;
    menuItemLogicController.Init(data);
    return menuItemLogicController;
  }

  public final static func SetRadialMenuData(menuButton: inkWidgetRef, const data: script_ref<MenuData>) -> ref<RadialMenuItemController> {
    let menuItemLogicController: ref<RadialMenuItemController> = inkWidgetRef.GetController(menuButton) as RadialMenuItemController;
    menuItemLogicController.Init(data);
    return menuItemLogicController;
  }

  public final static func SetRadialMenuHyperlinkData(menuButton: inkWidgetRef, identifier: HubMenuItems, parentIdentifier: HubMenuItems, fullscreenName: CName, icon: CName, labelKey: CName, opt userData: ref<IScriptable>) -> ref<RadialMenuItemController> {
    let menuItemLogicController: ref<RadialMenuItemController> = HubMenuUtils.SetRadialMenuData(menuButton, identifier, parentIdentifier, fullscreenName, icon, labelKey, userData);
    menuItemLogicController.SetHyperlink(true);
    return menuItemLogicController;
  }
}
