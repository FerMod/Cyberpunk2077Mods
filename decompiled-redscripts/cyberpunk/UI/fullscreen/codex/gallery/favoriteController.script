
public class GalleryFavoriteManager extends inkLogicController {

  private let m_favoritesSettingGroup: CName;

  private let m_favoritesSettingVar: CName;

  private let m_systemHandler: wref<inkISystemRequestsHandler>;

  private let m_favoritesValue: [Uint32];

  public final func Setup(systemHandler: wref<inkISystemRequestsHandler>) -> Void {
    this.m_systemHandler = systemHandler;
  }

  public final func InitValues(values: [Uint32]) -> Void {
    this.m_favoritesValue = values;
  }

  public final func IsFavorite(hash: Uint32) -> Bool {
    return ArrayContains(this.m_favoritesValue, hash);
  }

  public final func SetFavorite(hash: Uint32, favorite: Bool) -> Void {
    if favorite && !this.IsFavorite(hash) {
      ArrayPush(this.m_favoritesValue, hash);
    } else {
      ArrayRemove(this.m_favoritesValue, hash);
    };
    this.m_systemHandler.RequestSaveFavorites(this.m_favoritesValue);
  }

  public final func CountFavorites(screenshotInfos: [GameScreenshotInfo]) -> Int32 {
    let count: Int32 = 0;
    let i: Int32 = 0;
    i = 0;
    while i < ArraySize(screenshotInfos) {
      if this.IsFavorite(screenshotInfos[i].pathHash) {
        count += 1;
      };
      i += 1;
    };
    return count;
  }
}
