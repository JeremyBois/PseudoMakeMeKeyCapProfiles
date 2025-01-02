use <helper.scad>

///
/// ------- Shapes profiles
///

/**
 * Ellipse centered at a apex to avoid inverted face
 */
function Ellipse(a, b, d = 0, rot1 = 0, rot2 = 360, step) =
    [for (t = [rot1:step:rot2])[a * cos(t) + a, b *sin(t) * (1 + d * cos(t))]];

function DishShapeConcave(a, b, c, d, step) = Ellipse(a, b, d = 0, rot1 = 90,
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
  for (index = [0:fn - 1]) // section Right
      let(theta1 = -atan(a[1] / b[1]) +
                   2 * atan(a[1] / b[1]) * index /
                       fn)[b[1] * cos(theta1), a[1] * sin(theta1)] +
      [ a[0] * cos(atan(b[0] / a[0])), 0 ] -
      [ b[1] * cos(atan(a[1] / b[1])), 0 ],

  for (index = [0:fn - 1]) // section Top
      let(theta2 = atan(b[0] / a[0]) +
                   (180 - 2 * atan(b[0] / a[0])) * index /
                       fn)[a[0] * cos(theta2), b[0] * sin(theta2)] -
      [ 0, b[0] * sin(atan(b[0] / a[0])) ] +
      [ 0, a[1] * sin(atan(a[1] / b[1])) ],

  for (index = [0:fn - 1]) // section Left
      let(theta3 = -atan(a[1] / b[1]) + 180 +
                   2 * atan(a[1] / b[1]) * index /
                       fn)[b[1] * cos(theta3), a[1] * sin(theta3)] -
      [ a[0] * cos(atan(b[0] / a[0])), 0 ] +
      [ b[1] * cos(atan(a[1] / b[1])), 0 ],

  for (index = [0:fn - 1]) // section Bottom
      let(theta4 = atan(b[0] / a[0]) + 180 +
                   (180 - 2 * atan(b[0] / a[0])) * index /
                       fn)[a[0] * cos(theta4), b[0] * sin(theta4)] +
      [ 0, b[0] * sin(atan(b[0] / a[0])) ] -
      [ 0, a[1] * sin(atan(a[1] / b[1])) ]
] / 2;
