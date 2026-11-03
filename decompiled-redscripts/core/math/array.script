
public static func ArraySort(arr: [Int32]) -> [Int32] {
  let j: Int32;
  let minIndex: Int32;
  let temp: Int32;
  let sortedArray: array<Int32> = arr;
  let i: Int32 = 0;
  while i < ArraySize(sortedArray) {
    minIndex = i;
    j = i + 1;
    while j < ArraySize(sortedArray) {
      if sortedArray[j] < sortedArray[minIndex] {
        minIndex = j;
      };
      j += 1;
    };
    if minIndex != i {
      temp = sortedArray[i];
      sortedArray[i] = sortedArray[minIndex];
      sortedArray[minIndex] = temp;
    };
    i += 1;
  };
  return sortedArray;
}

public static func ArraySortReverse(arr: [Int32]) -> [Int32] {
  let j: Int32;
  let maxIndex: Int32;
  let temp: Int32;
  let sortedArray: array<Int32> = arr;
  let i: Int32 = 0;
  while i < ArraySize(sortedArray) {
    maxIndex = i;
    j = i + 1;
    while j < ArraySize(sortedArray) {
      if sortedArray[j] > sortedArray[maxIndex] {
        maxIndex = j;
      };
      j += 1;
    };
    if maxIndex != i {
      temp = sortedArray[i];
      sortedArray[i] = sortedArray[maxIndex];
      sortedArray[maxIndex] = temp;
    };
    i += 1;
  };
  return sortedArray;
}
