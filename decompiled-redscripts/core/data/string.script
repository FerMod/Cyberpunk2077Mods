
public static func SpaceFill(str: String, length: Int32, opt mode: ESpaceFillMode, opt fillChar: String) -> String {
  let addLeft: Int32;
  let addRight: Int32;
  let i: Int32;
  let strLen: Int32;
  let fillLen: Int32 = StrLen(fillChar);
  if fillLen == 0 {
    fillChar = " ";
  } else {
    if fillLen > 1 {
      fillChar = StrChar(0);
    };
  };
  strLen = StrLen(str);
  if strLen >= length {
    return str;
  };
  if Equals(mode, ESpaceFillMode.JustifyLeft) {
    addLeft = 0;
    addRight = length - strLen;
  } else {
    if Equals(mode, ESpaceFillMode.JustifyRight) {
      addLeft = length - strLen;
      addRight = 0;
    } else {
      if Equals(mode, ESpaceFillMode.JustifyCenter) {
        addLeft = FloorF((Cast<Float>(length) - Cast<Float>(strLen)) / 2.00);
        addRight = length - strLen - addLeft;
      };
    };
  };
  i = 0;
  while i < addLeft {
    str = fillChar + str;
    i += 1;
  };
  i = 0;
  while i < addRight {
    str += fillChar;
    i += 1;
  };
  return str;
}

public static func OperatorMultiply(a: String, count: Int32) -> String {
  let result: String;
  let bit: String = a;
  let i: Int32 = 0;
  while i < count {
    result = result + bit;
    i += 1;
  };
  return result;
}
