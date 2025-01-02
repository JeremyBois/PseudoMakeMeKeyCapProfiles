use <list-comprehension/skin.scad>
use <scad-utils/trajectory.scad>
use <scad-utils/trajectory_path.scad>
use <scad-utils/transformations.scad>

use <key.scad>

///
/// ----- Keycap stems
///

/**
 * Choc stem (two flat legs).
 */
module Choc_Stem(driftAngle = 5) {
  stemHeight = 3.1;
  dia = .15;
  rad = dia / 2;
  wids = 1.1 / 2;
  lens = 2.9 / 2;
  module _Stem() {
    difference() {
      translate([ 0, 0, -stemHeight / 2 ]) linear_extrude(height = stemHeight) {
        hull() {
          translate([ wids - rad, -lens + rad ]) circle(d = dia);
          translate([ -wids + rad, -lens + rad ]) circle(d = dia);
          translate([ wids - rad, lens - rad ]) circle(d = dia);
          translate([ -wids + rad, lens - rad ]) circle(d = dia);
        }
      }

      // Cuts
      translate([ 3.9, 0 ]) cylinder(d1 = 7 + sin(driftAngle) * stemHeight,
                                     d2 = 7, 3.5, center = true, $fn = 64);
      translate([ -3.9, 0 ]) cylinder(d1 = 7 + sin(driftAngle) * stemHeight,
                                      d2 = 7, 3.5, center = true, $fn = 64);
    }
  }

  translate([ 5.7 / 2, 0, -stemHeight / 2 + 2 ]) _Stem();
  translate([ -5.7 / 2, 0, -stemHeight / 2 + 2 ]) _Stem();
}

/** MX stem (cross shape) with a cylinderical body.
 * \param height Height of the cylindrical body
 * \param rotation Rotation of the inner shape
 * \param brimDepth Z offset (from cap shape)
 * \param tolerance Cross section tolerance
 */
module MX_Cylinderical_Stem(height, rotation, brimDepth, tolerance = 0.0) {

  /** MX stem (cross shape) with a cylinderical body.
   * \param sc Scale the cross by this amount
   * \param hLength Horizontal size of the cross
   * \param vLength Vertical size of the cross
   * \param hThickness Thickness of the horizontal cross part
   * \param vThickness Thickness of the vertical cross part
   */
  function _CrossShape(sc = 1, hLength, vLength, hThickness, vThickness) =
      sc *[[vThickness, vLength], [vThickness, hThickness],
           [hLength, hThickness], [hLength, -hThickness],
           [vThickness, -hThickness], [vThickness, -vLength],
           [-vThickness, -vLength], [-vThickness, -hThickness],
           [-hLength, -hThickness], [-hLength, hThickness],
           [-vThickness, hThickness], [-vThickness, vLength]];

  function _StemTrajectory1() = [trajectory(forward = 5.25)];

  function _StemTrajectory2() = [trajectory(forward = .5)];

  // Inner shape (MX / KS33 2D cross)
  hLength = 4.03 / 2 + tolerance;    // horizontal lenght
  vLength = 4.03 / 2 + tolerance;    // vertical length
  hThickness = 1.10 / 2 + tolerance; // horizontal thickness
  vThickness = 1.23 / 2 + tolerance; // vertical thickness
  cross2D = _CrossShape(1, hLength, vLength, hThickness, vThickness);

  // Outer shape (Cherry cylinder)
  diameter = 5.5;

  // Build trajectory to extrude the cross shape
  crossTrajectory1 = _StemTrajectory1();
  crosspath1 = quantize_trajectories(crossTrajectory1, steps = 1, loop = false,
                                     start_position = $t * 4);
  crossCurve1 =
      [for (i = [0:len(crosspath1) - 1]) transform(crosspath1[i], cross2D)];

  crossTrajectory2 = _StemTrajectory2();
  crossPath2 = quantize_trajectories(crossTrajectory2, steps = 10, loop = false,
                                     start_position = $t * 4);
  crossCurve2 = [for (i = [0:len(crossPath2) - 1])
          transform(crossPath2[i] * scaling([
                      (1.1 - .1 * i / (len(crossPath2) - 1)),
                      (1.1 - .1 * i / (len(crossPath2) - 1)), 1
                    ]),
                    cross2D)];
  // Center, rotate and cut cylindrical  outer shape with cross inner shape
  translate([ 0, 0, brimDepth ]) rotate(rotation) difference() {
    cylinder(d = diameter, h = height - brimDepth, $fn = $fn);
    skin(crossCurve1);
    skin(crossCurve2);
  }
}

/** Generate as many MX stem as required based on key size.
 * \param keyUnit Size in key unit (1u, 2u, ...)
 * \param height Height of the cylindrical body
 * \param rotation Rotation of the inner shape
 * \param brimDepth Z offset (from cap shape)
 * \param tolerance Cross section tolerance
 */
module MX_Cylinderical_Stems(keyUnit, height, rotation, brimDepth,
                             tolerance = 0.0) {
  union() {
    MX_Cylinderical_Stem(height, rotation, brimDepth, tolerance = tolerance);

    // Stabilizer for >=2u.
    if (keyUnit >= 2 && keyUnit < 3) {
      // MX spec for 2u (1.25 * 19.05 = 23.8mm).
      spacing = 1.25 * MX_KeySpacing();
      translate([ spacing / 2, 0, 0 ]) MX_Cylinderical_Stem(
          height, rotation, brimDepth, tolerance = tolerance);
      translate([ -spacing / 2, 0, 0 ]) MX_Cylinderical_Stem(
          height, rotation, brimDepth, tolerance = tolerance);
    }

    if (keyUnit >= 3) {
      spacing = (keyUnit - 1) * MX_KeySpacing();
      translate([ spacing / 2, 0, 0 ]) MX_Cylinderical_Stem(
          height, rotation, brimDepth, tolerance = tolerance);
      translate([ -spacing / 2, 0, 0 ]) MX_Cylinderical_Stem(
          height, rotation, brimDepth, tolerance = tolerance);
    }
  }
}
