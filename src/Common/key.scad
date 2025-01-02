///
/// ------- Utility for key spacing
///


function KeySize(u = 1, spacing, clearance) = u * spacing - clearance;
function KeyUnit(width, spacing, clearance) = (width + clearance) / spacing;

// MX
function MX_KeySpacing() = 19.05;
function MX_KeyClearance() = 1.89;
function MX_KeyWidth(u = 1) = KeySize(u, MX_KeySpacing(), MX_KeyClearance());
function MX_KeyHeight(u = 1) = KeySize(u, MX_KeySpacing(), MX_KeyClearance());
function MX_KeyUnit(width) = KeyUnit(width, MX_KeySpacing(), MX_KeyClearance());

