
public native struct Color {

  public native let Red: Uint8;

  public native let Green: Uint8;

  public native let Blue: Uint8;

  public native let Alpha: Uint8;

  public final static func ToHDRColorDirect(color: Color) -> HDRColor {
    return new HDRColor(Cast<Float>(color.Red) / 255.00, Cast<Float>(color.Green) / 255.00, Cast<Float>(color.Blue) / 255.00, Cast<Float>(color.Alpha) / 255.00);
  }

  public final static func HSBToColor(hue: Float, onlyHue: Bool, opt saturation: Float, opt brightness: Float) -> Color {
    let color: Color;
    let p: Float;
    let pScaled: Int32;
    let q: Float;
    let qScaled: Int32;
    let sector: Int32;
    let sectorFraction: Float;
    let t: Float;
    let tScaled: Int32;
    let vScaled: Int32;
    if onlyHue {
      saturation = 1.00;
      brightness = 1.00;
    };
    hue /= 360.00;
    sector = FloorF(hue * 6.00) % 6;
    sectorFraction = hue * 6.00 - Cast<Float>(FloorF(hue * 6.00));
    p = brightness * (1.00 - saturation);
    q = brightness * (1.00 - sectorFraction * saturation);
    t = brightness * (1.00 - (1.00 - sectorFraction) * saturation);
    pScaled = Cast<Int32>(p * 255.00);
    qScaled = Cast<Int32>(q * 255.00);
    tScaled = Cast<Int32>(t * 255.00);
    vScaled = Cast<Int32>(brightness * 255.00);
    switch sector {
      case 0:
        color = new Color(Cast<Uint8>(vScaled), Cast<Uint8>(tScaled), Cast<Uint8>(pScaled), 255u);
        break;
      case 1:
        color = new Color(Cast<Uint8>(qScaled), Cast<Uint8>(vScaled), Cast<Uint8>(pScaled), 255u);
        break;
      case 2:
        color = new Color(Cast<Uint8>(pScaled), Cast<Uint8>(vScaled), Cast<Uint8>(tScaled), 255u);
        break;
      case 3:
        color = new Color(Cast<Uint8>(pScaled), Cast<Uint8>(qScaled), Cast<Uint8>(vScaled), 255u);
        break;
      case 4:
        color = new Color(Cast<Uint8>(tScaled), Cast<Uint8>(pScaled), Cast<Uint8>(vScaled), 255u);
        break;
      default:
        color = new Color(Cast<Uint8>(vScaled), Cast<Uint8>(pScaled), Cast<Uint8>(qScaled), 255u);
    };
    return color;
  }

  public final static func ColorToHSB(color: Color) -> HSBColor {
    let hsbColor: HSBColor;
    let min: Float = color.Red < color.Green ? Cast<Float>(color.Red) / 255.00 : Cast<Float>(color.Green) / 255.00;
    min = min < Cast<Float>(color.Blue) / 255.00 ? min : Cast<Float>(color.Blue) / 255.00;
    let max: Float = color.Red > color.Green ? Cast<Float>(color.Red) / 255.00 : Cast<Float>(color.Green) / 255.00;
    max = max > Cast<Float>(color.Blue) / 255.00 ? max : Cast<Float>(color.Blue) / 255.00;
    hsbColor.Brightness = max;
    let delta: Float = max - min;
    if delta < 0.00 {
      hsbColor.Saturation = 0.00;
      hsbColor.Hue = 0.00;
      return hsbColor;
    };
    if max > 0.00 {
      hsbColor.Saturation = delta / max;
    } else {
      hsbColor.Saturation = 0.00;
      hsbColor.Hue = 0.00;
      return hsbColor;
    };
    if Cast<Float>(color.Red) / 255.00 >= max {
      hsbColor.Hue = (Cast<Float>(color.Green) / 255.00 - Cast<Float>(color.Blue) / 255.00) / delta;
    } else {
      if Cast<Float>(color.Green) / 255.00 >= max {
        hsbColor.Hue = 2.00 + (Cast<Float>(color.Blue) / 255.00 - Cast<Float>(color.Red) / 255.00) / delta;
      } else {
        hsbColor.Hue = 4.00 + (Cast<Float>(color.Red) / 255.00 - Cast<Float>(color.Green) / 255.00) / delta;
      };
    };
    hsbColor.Hue *= 60.00;
    if hsbColor.Hue < 0.00 {
      hsbColor.Hue += 360.00;
    };
    return hsbColor;
  }

  public final static func Equals(colorA: Color, colorB: Color, opt tolerance: Int32) -> Bool {
    return Abs(Cast<Int32>(colorA.Red) - Cast<Int32>(colorB.Red)) <= tolerance && Abs(Cast<Int32>(colorA.Green) - Cast<Int32>(colorB.Green)) <= tolerance && Abs(Cast<Int32>(colorA.Blue) - Cast<Int32>(colorB.Blue)) <= tolerance && Abs(Cast<Int32>(colorA.Alpha) - Cast<Int32>(colorB.Alpha)) <= tolerance;
  }

  public final static func ToLinear(sRGBColor: Color) -> Color {
    return new Color(Cast<Uint8>(PowF(Cast<Float>(sRGBColor.Red) / 255.00, 2.20) * 255.00), Cast<Uint8>(PowF(Cast<Float>(sRGBColor.Green) / 255.00, 2.20) * 255.00), Cast<Uint8>(PowF(Cast<Float>(sRGBColor.Blue) / 255.00, 2.20) * 255.00), sRGBColor.Alpha);
  }

  public final static func ToSRGB(linearColor: Color) -> Color {
    return new Color(Cast<Uint8>(PowF(Cast<Float>(linearColor.Red) / 255.00, 0.45) * 255.00), Cast<Uint8>(PowF(Cast<Float>(linearColor.Green) / 255.00, 0.45) * 255.00), Cast<Uint8>(PowF(Cast<Float>(linearColor.Blue) / 255.00, 0.45) * 255.00), linearColor.Alpha);
  }
}
