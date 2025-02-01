use <logging.scad>

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


// Choc

/*
 * Remaining space between plate and bottom of cap (based on choc V1 specifications)
 * \param topPlateThickness Thickness of top plate (1.3 if switches are clipped to plate).
 * \param topPlateHeight Delta in height between PCB top and top plate bottom (0.9 if switches are clipped to plate).
 * \param stemLength Vertical length of the stem including margin if any.
 * \param stemHeightToCapBottom Vertical distance between cap bottom and stem top
 */
module Choc_KeyFreeSpace(topPlateThickness=1.3, pcbToTopPlate=0.9, stemLength, capBottomToStemTop)
{
  pcbTopToSwitchTop = 5 + 3; // Delta in height between PCB top and switch top
  // Stem travel is reduced due to a small protusion (0.5mm) until stem length becomes
  // bigger than the protusion + stem max travel
  stemTravel = stemLength < 3.5 ? 3.0 - 0.5 : 3.0;
  // Cap Travel is fixed until stem length becomes bigger than the protusion + stem max travel
  capTravel = stemTravel > 2.5 ? stemTravel - (stemLength - 3.0) : 2.5;
  capBottomHeight = pcbTopToSwitchTop - pcbToTopPlate - topPlateThickness - capBottomToStemTop - capTravel;
  echo_info("*** Choc cap tester ***");
  echo_info(str("Stem travel: ", stemTravel));
  echo_info(str("Cap travel: ", capTravel));
  echo_info(str("Available free space below bottom of the cap: ", capBottomHeight));
}
