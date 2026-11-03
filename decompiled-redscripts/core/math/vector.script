
public native struct Vector3 {

  public native let X: Float;

  public native let Y: Float;

  public native let Z: Float;

  public final static func Lerp(a: Vector3, b: Vector3, t: Float) -> Vector3 {
    let x: Float = a.X + (b.X - a.X) * t;
    let y: Float = a.Y + (b.Y - a.Y) * t;
    let z: Float = a.Z + (b.Z - a.Z) * t;
    return new Vector3(x, y, z);
  }
}

public native struct Vector4 {

  public native let X: Float;

  public native let Y: Float;

  public native let Z: Float;

  public native let W: Float;

  public final static func Lerp(a: Vector4, b: Vector4, t: Float) -> Vector4 {
    let x: Float = a.X + (b.X - a.X) * t;
    let y: Float = a.Y + (b.Y - a.Y) * t;
    let z: Float = a.Z + (b.Z - a.Z) * t;
    let w: Float = a.W + (b.W - a.W) * t;
    return new Vector4(x, y, z, w);
  }

  public final static native func Dot2D(a: Vector4, b: Vector4) -> Float;

  public final static native func Dot(a: Vector4, b: Vector4) -> Float;

  public final static native func Cross(a: Vector4, b: Vector4) -> Vector4;

  public final static native func Length2D(a: Vector4) -> Float;

  public final static native func LengthSquared(a: Vector4) -> Float;

  public final static native func Length(a: Vector4) -> Float;

  public final static native func Normalize2D(a: Vector4) -> Vector4;

  public final static native func Normalize(a: Vector4) -> Vector4;

  public final static native func Rand2D() -> Vector4;

  public final static native func Rand() -> Vector4;

  public final static func UP() -> Vector4 {
    let v: Vector4;
    v.Z = 1.00;
    return v;
  }

  public final static func FRONT() -> Vector4 {
    let v: Vector4;
    v.Y = 1.00;
    return v;
  }

  public final static func RIGHT() -> Vector4 {
    let v: Vector4;
    v.X = 1.00;
    return v;
  }

  public final static func RandRing(minRadius: Float, maxRadius: Float) -> Vector4 {
    let r: Float = RandRangeF(minRadius, maxRadius);
    let angle: Float = RandRangeF(0.00, 6.28);
    return new Vector4(r * CosF(angle), r * SinF(angle), 0.00, 1.00);
  }

  public final static func RandCone(coneDir: Float, coneAngle: Float, minRadius: Float, maxRadius: Float) -> Vector4 {
    let r: Float = RandRangeF(minRadius, maxRadius);
    let angleMin: Float = Deg2Rad(coneDir - coneAngle * 0.50 + 90.00);
    let angleMax: Float = Deg2Rad(coneDir + coneAngle * 0.50 + 90.00);
    let angle: Float = RandRangeF(angleMin, angleMax);
    return new Vector4(r * CosF(angle), r * SinF(angle), 0.00, 1.00);
  }

  public final static func RandRingStatic(seed: Int32, minRadius: Float, maxRadius: Float) -> Vector4 {
    let r: Float = RandNoiseF(seed, maxRadius, minRadius);
    let angle: Float = RandNoiseF(seed, 6.28);
    return new Vector4(r * CosF(angle), r * SinF(angle), 0.00, 1.00);
  }

  public final static native func Mirror(dir: Vector4, normal: Vector4) -> Vector4;

  public final static native func Distance(from: Vector4, to: Vector4) -> Float;

  public final static native func DistanceSquared(from: Vector4, to: Vector4) -> Float;

  public final static native func Distance2D(from: Vector4, to: Vector4) -> Float;

  public final static native func DistanceSquared2D(from: Vector4, to: Vector4) -> Float;

  public final static native func DistanceToEdge(point: Vector4, a: Vector4, b: Vector4) -> Float;

  public final static native func NearestPointOnEdge(point: Vector4, a: Vector4, b: Vector4) -> Vector4;

  public final static native func ToRotation(dir: Vector4) -> EulerAngles;

  public final static native func Heading(dir: Vector4) -> Float;

  public final static native func FromHeading(heading: Float) -> Vector4;

  public final static native func Transform(m: Matrix, point: Vector4) -> Vector4;

  public final static native func TransformDir(m: Matrix, point: Vector4) -> Vector4;

  public final static native func TransformH(m: Matrix, point: Vector4) -> Vector4;

  public final static native func GetAngleBetween(from: Vector4, to: Vector4) -> Float;

  public final static native func GetAngleDegAroundAxis(dirA: Vector4, dirB: Vector4, axis: Vector4) -> Float;

  public final static native func ProjectPointToPlane(p1: Vector4, p2: Vector4, p3: Vector4, toProject: Vector4) -> Vector4;

  public final static native func RotateAxis(vector: Vector4, axis: Vector4, angle: Float) -> Vector4;

  public final static native func RotByAngleXY(vec: Vector4, angleDeg: Float) -> Vector4;

  public final static native func Interpolate(v1: Vector4, v2: Vector4, ratio: Float) -> Vector4;

  public final static func ToString(vec: Vector4) -> String {
    return FloatToString(vec.X) + " " + FloatToString(vec.Y) + " " + FloatToString(vec.Z) + " " + FloatToString(vec.W);
  }

  public final static func ToStringPrec(vec: Vector4, precision: Int32) -> String {
    return FloatToStringPrec(vec.X, precision) + " " + FloatToStringPrec(vec.Y, precision) + " " + FloatToStringPrec(vec.Z, precision) + " " + FloatToStringPrec(vec.W, precision);
  }

  public final static native func Zero(out self: Vector4) -> Void;

  public final static native func IsZero(self: Vector4) -> Bool;

  public final static native func IsXYZZero(self: Vector4) -> Bool;

  public final static func EmptyVector() -> Vector4 {
    let vec: Vector4;
    return vec;
  }

  public final static native func ClampLength(self: Vector4, min: Float, max: Float) -> Vector4;

  public final static native func Vector3To4(v3: Vector3) -> Vector4;

  public final static native func Vector4To3(v4: Vector4) -> Vector3;
}

public static func VectorToString(vec: Vector4) -> String {
  let str: String = "x: " + FloatToString(vec.X) + " y: " + FloatToString(vec.Y) + " z: " + FloatToString(vec.Z);
  return str;
}
