
public class NetworkMinigameProgramController extends inkLogicController {

  protected edit let m_text: inkTextRef;

  protected edit const let m_commandElementSlotsContainer: [inkWidgetRef];

  protected edit let m_elementLibraryName: CName;

  protected edit let m_completedMarker: inkWidgetRef;

  protected edit let m_imageRef: inkImageRef;

  protected let m_slotList: [[wref<NetworkMinigameElementController>]];

  protected let m_data: ProgramData;

  private let m_animProxy: ref<inkAnimProxy>;

  protected cb func OnInitialize() -> Bool {
    inkWidgetRef.SetVisible(this.m_completedMarker, false);
    inkTextRef.SetText(this.m_text, "");
  }

  public final func Spawn(const data: script_ref<ProgramData>) -> Void {
    let i: Int32;
    let j: Int32;
    let slot: wref<inkWidget>;
    let slotLogic: wref<NetworkMinigameElementController>;
    let slotLogicContent: array<wref<NetworkMinigameElementController>>;
    this.m_data = Deref(data);
    inkTextRef.SetText(this.m_text, Deref(data).id);
    this.RefreshImage();
    j = 0;
    while j < ArraySize(Deref(data).commandLists) {
      ArrayClear(slotLogicContent);
      i = 0;
      while i < ArraySize(Deref(data).commandLists[j]) {
        slot = this.SpawnFromLocal(inkWidgetRef.Get(this.m_commandElementSlotsContainer[j]), this.m_elementLibraryName);
        slotLogic = slot.GetController() as NetworkMinigameElementController;
        slotLogic.SetContent(Deref(data).commandLists[j][i]);
        ArrayPush(slotLogicContent, slotLogic);
        i += 1;
      };
      ArrayPush(this.m_slotList, slotLogicContent);
      j += 1;
    };
  }

  public final func UpdatePartialCompletionState(const progress: script_ref<ProgramProgressData>) -> Void {
    if Deref(progress).isComplete {
      if !this.m_data.wasCompleted {
        this.ShowCompleted(Deref(progress).revealLocalizedName);
      };
      return;
    };
    this.SetHighlightedUpUntil(Deref(progress).completionProgress);
  }

  private final func SetHighlightedUpUntil(const lastHighlighted: script_ref<[Int32]>) -> Void {
    let i: Int32;
    let j: Int32 = 0;
    while j < ArraySize(this.m_slotList) {
      i = 0;
      while i < ArraySize(this.m_slotList[j]) {
        this.m_slotList[j][i].SetHighlightStatus(i < Deref(lastHighlighted)[j]);
        i += 1;
      };
      j += 1;
    };
  }

  public func ShowCompleted(revealLocalizedName: Bool) -> Void {
    inkWidgetRef.SetVisible(this.m_completedMarker, true);
    this.m_data.wasCompleted = true;
    if revealLocalizedName {
      inkTextRef.SetText(this.m_text, this.m_data.localizationKey);
    };
    this.PlayAnim(n"program_unlocked");
  }

  public final func GetData() -> ProgramData {
    return this.m_data;
  }

  public final func RefreshImage() -> Void {
    switch this.m_data.id {
      case "Encrypted Data Package":
        inkImageRef.SetTexturePart(this.m_imageRef, n"program_ico_01");
        break;
      case "Basic Access":
        inkImageRef.SetTexturePart(this.m_imageRef, n"program_ico_01");
        break;
      case "Network Cache":
        inkImageRef.SetTexturePart(this.m_imageRef, n"program_ico_02");
        break;
      case "Camera Malfunction":
        inkImageRef.SetTexturePart(this.m_imageRef, n"program_ico_03");
        break;
      case "Officer tracing":
        inkImageRef.SetTexturePart(this.m_imageRef, n"program_ico_04");
    };
  }

  public final func PlayAnim(anim: CName) -> Void {
    this.m_animProxy = this.PlayLibraryAnimation(anim);
  }
}

public class NetworkMinigameBasicProgramController extends NetworkMinigameProgramController {

  public func ShowCompleted(revealLocalizedName: Bool) -> Void {
    inkWidgetRef.SetVisible(this.m_completedMarker, true);
    this.m_data.wasCompleted = true;
    if revealLocalizedName {
      inkTextRef.SetText(this.m_text, this.m_data.localizationKey);
    };
    this.PlayAnim(n"basic_access_unlocked");
  }
}

public class NetworkMinigameProgramListController extends inkLogicController {

  protected edit let m_programPlayerContainer: inkWidgetRef;

  protected edit let m_programNetworkContainer: inkWidgetRef;

  protected edit let m_programLibraryName: CName;

  protected let m_slotList: [wref<NetworkMinigameProgramController>];

  private let m_animProxy_02: ref<inkAnimProxy>;

  private edit let m_headerBG: inkWidgetRef;

  public final func Spawn(const contents: script_ref<[ProgramData]>) -> Void {
    let i: Int32 = 0;
    while i < ArraySize(Deref(contents)) {
      ArrayPush(this.m_slotList, this.SpawnSlot(Deref(contents)[i]));
      i += 1;
    };
  }

  private final func SpawnSlot(const data: script_ref<ProgramData>) -> wref<NetworkMinigameProgramController> {
    let toAppendTo: inkWidgetRef = this.GetDesignatedParent(data);
    let slot: wref<inkWidget> = this.SpawnFromLocal(inkWidgetRef.Get(toAppendTo), this.m_programLibraryName);
    let slotLogic: wref<NetworkMinigameProgramController> = slot.GetController() as NetworkMinigameProgramController;
    slotLogic.Spawn(data);
    return slotLogic;
  }

  private final func GetDesignatedParent(const data: script_ref<ProgramData>) -> inkWidgetRef {
    switch Deref(data).type {
      case ProgramType.ExtraPlayerProgram:
        return this.m_programPlayerContainer;
      case ProgramType.ExtraServerProgram:
        return this.m_programNetworkContainer;
    };
    return this.m_programPlayerContainer;
  }

  public final func UpdatePartialCompletionState(const progressList: script_ref<[ProgramProgressData]>) -> Void {
    let j: Int32;
    let i: Int32 = 0;
    while i < ArraySize(Deref(progressList)) {
      j = this.FindSlotIndexByID(Deref(progressList)[i].id);
      if j >= 0 {
        this.m_slotList[j].UpdatePartialCompletionState(Deref(progressList)[i]);
      };
      i += 1;
    };
  }

  public final func ShowCompleted(const id: script_ref<String>, revealLocalizedName: Bool) -> Void {
    let i: Int32 = this.FindSlotIndexByID(id);
    if i >= 0 {
      this.m_slotList[i].ShowCompleted(revealLocalizedName);
    };
  }

  public final func PlaySideBarAnim() -> Void {
    inkWidgetRef.SetVisible(this.m_headerBG, true);
  }

  public final func ProcessListModified(shouldModify: Bool, const playerProgramsAdded: script_ref<[ProgramData]>, const playerProgramsRemoved: script_ref<[ProgramData]>) -> Void {
    let i: Int32;
    let j: Int32;
    let parentCompound: wref<inkCompoundWidget>;
    let parentCompoundRef: inkWidgetRef;
    if shouldModify {
      i = 0;
      while i < ArraySize(Deref(playerProgramsRemoved)) {
        j = this.FindSlotIndexByID(Deref(playerProgramsRemoved)[i].id);
        if j >= 0 {
          parentCompoundRef = this.GetDesignatedParent(Deref(playerProgramsRemoved)[i]);
          parentCompound = inkWidgetRef.Get(parentCompoundRef) as inkCompoundWidget;
          parentCompound.RemoveChild(this.m_slotList[j].GetRootWidget());
          ArrayErase(this.m_slotList, j);
        };
        i += 1;
      };
      i = 0;
      while i < ArraySize(Deref(playerProgramsAdded)) {
        ArrayPush(this.m_slotList, this.SpawnSlot(Deref(playerProgramsAdded)[i]));
        i += 1;
      };
    };
  }

  private final func FindSlotIndexByID(const id: script_ref<String>) -> Int32 {
    let data: ProgramData;
    let i: Int32 = 0;
    while i < ArraySize(this.m_slotList) {
      data = this.m_slotList[i].GetData();
      if Equals(id, data.id) {
        return i;
      };
      i += 1;
    };
    return -1;
  }
}
