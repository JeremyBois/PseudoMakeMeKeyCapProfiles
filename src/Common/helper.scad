///
/// ----- Helper functions
///

function sign_x(i,n) =
    i < n/4 || i > n-n/4  ?  1 :
    i > n/4 && i < n-n/4  ? -1 :
    0;

function sign_y(i,n) =
    i > 0 && i < n/2  ?  1 :
    i > n/2 ? -1 :
    0;

/// Linear interpolation from a to b.
function lerp(a, b, t) = (1 - t) * a + t * b;
