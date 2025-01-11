use <helper.scad>

///
/// ------- Shapes profiles
///

/**
 * Ellipse centered at a apex (a, 0) to avoid inverted faces.
 * \param a The semi-major axis of the ellipse. This determines the "width" of the ellipse (along the x-axis).
 * \param b The semi-minor axis of the ellipse. This determines the "height" of the ellipse (along the y-axis).
 * \param d A distortion factor that deforms the ellipse. This affects how the y-coordinates are scaled based on the x-coordinate as you traverse along the ellipse.
 * \param rot1 The starting angle for the parametrization.
 * \param rot2 The ending angle for the parametrization.
 * \param step The increment of the angle t for each sample point. This controls the resolution of the ellipse's points.
 */
function Ellipse(a, b, d = 0, rot1 = 0, rot2 = 360, step) =
    [for (t = [rot1:step:rot2])[a * cos(t) + a, b *sin(t) * (1 + d * cos(t))]];

/**
 * An Ellipse shape. Default values will create a the low part of an ellipse (semi ellipse).
 */
function DishShapeConcave(a, b, d, step) = Ellipse(a, b, d = d, rot1 = 90,
                                                   rot2 = 270, step = step);

function DishShapeConcave2(a, b, phi = 200, theta, r, step) = concat(
    Ellipse(a, b, d = 0, rot1 = 90, rot2 = phi, step = step),

    [for (t = [step:step * 2:theta]) let(
        sig = atan(a * cos(phi) / -b *
                   sin(phi)))[r * cos(-atan(-a * cos(phi) / b * sin(phi)) - t) +
                                  a * cos(phi) - r * cos(sig) + a,

                              r *sin(-atan(-a *cos(phi) / b * sin(phi)) - t) +
                                  b *sin(phi) + r *sin(sig)]],

    [[a, b *sin(phi) - r *sin(theta) * 2]] // bounday vertex to clear ends
);

function DishShapeConvex(a, b, c, d, step) = concat(
    [[c + a, -b]],
    Ellipse(a, b, d = 0, rot1 = 270, rot2 = 450, step = step),
    [[c + a, b]]
);

function rounded_rectangle_profile(size = [ 1, 1 ], r = 1, fn = 32) =
    [for (index = [0:fn - 1]) let(a = index / fn * 360) r * [ cos(a), sin(a) ] +
        sign_x(index, fn) * [ size[0] / 2 - r, 0 ] +
        sign_y(index, fn) * [ 0, size[1] / 2 - r ]];

function elliptical_rectangle_profile(a = [ 1, 1 ], b = [ 1, 1 ], fn = 32) = [
  for (index = [0:fn - 1]) // Wall Right
      let(theta1 = -atan(a[1] / b[1]) +
                   2 * atan(a[1] / b[1]) * index /
                       fn)[b[1] * cos(theta1), a[1] * sin(theta1)] +
      [ a[0] * cos(atan(b[0] / a[0])), 0 ] -
      [ b[1] * cos(atan(a[1] / b[1])), 0 ],

  for (index = [0:fn - 1]) // Wall Front
      let(theta2 = atan(b[0] / a[0]) +
                   (180 - 2 * atan(b[0] / a[0])) * index /
                       fn)[a[0] * cos(theta2), b[0] * sin(theta2)] -
      [ 0, b[0] * sin(atan(b[0] / a[0])) ] +
      [ 0, a[1] * sin(atan(a[1] / b[1])) ],

  for (index = [0:fn - 1]) // Wall Left
      let(theta3 = -atan(a[1] / b[1]) + 180 +
                   2 * atan(a[1] / b[1]) * index /
                       fn)[b[1] * cos(theta3), a[1] * sin(theta3)] -
      [ a[0] * cos(atan(b[0] / a[0])), 0 ] +
      [ b[1] * cos(atan(a[1] / b[1])), 0 ],

  for (index = [0:fn - 1]) // Wall Back
      let(theta4 = atan(b[0] / a[0]) + 180 +
                   (180 - 2 * atan(b[0] / a[0])) * index /
                       fn)[a[0] * cos(theta4), b[0] * sin(theta4)] +
      [ 0, b[0] * sin(atan(b[0] / a[0])) ] -
      [ 0, a[1] * sin(atan(a[1] / b[1])) ]
] / 2;
