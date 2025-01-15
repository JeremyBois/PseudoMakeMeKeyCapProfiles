use <scad-utils/morphology.scad> //for cheaper minwoski
use <scad-utils/transformations.scad>
use <scad-utils/shapes.scad>
use <scad-utils/trajectory.scad>
use <scad-utils/trajectory_path.scad>

use <list-comprehension/sweep.scad>
use <list-comprehension/skin.scad>

//use <z-butt.scad>

use <../Common/shape.scad>
use <../Common/stem.scad>
use <../Common/logging.scad>

// Global overloadable epsilon at different scope
$eps = 1/80;


mirror([0,0,0])keycap(
  keyID  = 8,  //change profile refer to KeyParameters Struct
  stem   = true,  // Turn on inner shell, brim and stems
  dish   = true,  //turn on dish cut
  homeDot = false,  //turn on homedots,
  visualizeStem = true,  // turn on debug visual of Stem
  visualizeDish = false,  // turn on debug visual of Dish
  crossSection  = true,  // center cut to check internal
  verbose = true,
  stemRot = 0,  //change stem orientation by deg
  cutLen = 0,  //Don't change. for chopped caps
  legends = false,
  tag = "0"
);

//#cube([18.16, 18.16, 10], center = true); // sanity check border

// ----- Parameters
wallthickness = 1.1;  // 1.75 ?? (MX) 1.10 (Choc)
topthickness  = 2.8;  // 2.90 ?? (MX) 2.90 (Choc)
stepsize      = 60;   // Resolution of Trajectory
fn            = 60;   // Resolution of Rounded Rectangles: 60 for output
layers        = 50;   // Resolution of vertical Sweep: 50 for output
step          = 0.5;  // Resolution of ellipes
homeRadius    = 0.55;

// ----- Stem Parameters
brimEndWidth   = 7.5;   // X 7.5
brimEndLength  = 5.5;   // Y 5.5
brimlayers     = 50;    // Resolution of brim to transition from cap to stem

// ----- Stem Parameters
stemHeight     = 1.7;   // Z 1.7
stemMargin     = 0.1;   // Allowed stem insertion inside the cap thickness
stemDriftAngle = 0.0;   // Drift in legs holes


keyParameters = //keyParameters[KeyID][ParameterID]
[
//  BotWid, BotLen, TWDif, TLDif, keyh, WSft, LSft  XSkew, YSkew, ZSkew, WEx, LEx, CapR0i, CapR0f, CapR1i, CapR1f, CapREx, StemEx
    //Column 0
    //Levee: Chicago in choc Dimension [0:1]
    [17.20,  16.00,   5.6, 	   5,  3.8,    0,  -.5,     7,    -0,    -0,   2, 2,    .10,      3,     .10,      3,     2,       2], //Chicago Steno R2x 1u
    [17.20,  16.00,   5.6, 	   5,  4.4,    0,   .0,     0,    -0,    -0,   2, 2,    .10,      3,     .10,      3,     2,       2], //Chicago Steno R3x 1u

    // R3x 1.25~2.25u [2:6]
    [21.7,   15.60,   5.6, 	   5.6,  4.5,   0,   .0,   0,    -0,    -0,   2, 2.5,   .1,      3,     .1,      3,     2,       2], //Chicago Steno R3x 1.25u
    [26.20,  15.60,   5.6, 	   5.6,  4.5,   0,   .0,   0,    -0,    -0,   2, 2.5,   .1,      3,     .1,      3,     2,       2], //Chicago Steno R3x 1.5u
    [30.70,  15.60,   5.6, 	   5.6,  4.5,   0,   .0,   0,    -0,    -0,   2, 2.5,   .1,      3,     .1,      3,     2,       2], //Chicago Steno R3x 1.75u
    [35.20,  15.60,   5.6, 	   5.6,  4.5,   0,   .0,   0,    -0,    -0,   2, 2.5,   .1,      3,     .1,      3,     2,       2], //Chicago Steno R3x 2.0u
    [39.70,  15.60,   5.6, 	   5.6,  4.5,   0,   .0,   0,    -0,    -0,   2, 2.5,   .1,      3,     .1,      3,     2,       2], //Chicago Steno R3x 2.25u


    //
    // Custom
    //
    // BotWid, BotLen,  TWDif,TLDif, keyh, WSft, LSft, XSkew, YSkew, ZSkew, WEx, LEx, CapR0i, CapR0f, CapR1i, CapR1f, CapREx, StemEx

    // Choc spacing [7:8]
    [17.20,  16.00,   5.6,     5,  3.9,    0,  -.5,     7,    -0,    -0,   2, 2,    .10,      3,     .10,      3,     2,       1], //Chicago Steno R2x 1u
    [17.20,  16.00,   5.6,     5,  4.5,    0,   .0,     0,    -0,    -0,   2, 2,    .10,      3,     .10,      3,     2,       1], //Chicago Steno R3x 1u

    // MX spacing [11, 12]
    // @TODO

//  Kept as reference until validation
//  original from pseudo, mislabled/ missing params?
//    [35.85,  15.65,     7, 	   7,  4.4,    0,   .0,     0,    -0,    -0,   2, 2,    .30,      5,     .30,      5,     2,       2], //Chicago Steno R3x 2u
//    [35.85,  15.65,     7, 	   7,  4.4,    0,   .0,     0,    -0,    -0,   2, 2,    .30,      5,     .30,      5,     2,       2], //Chicago Steno R3x 2u
//    //mods 3
//    [17.20,  16.00,  4.25, 	3.25,  5.5,  -.7,  0.7,     0,    -4,    -0,   2,   2,    .10,      2,     .10,      2,     2,       2], //Levee Corner R2
//    [17.20,  16.00,  4.25, 	3.25,  5.2,  -.8,  0.6,     0,    -4,    -0,   2,   3,    .10,      2,     .10,      2,     2,       2], //Levee Corner R2
//    //1.25 5
//    [21.3,   15.60,  5.6, 	   5,  4.5,    0,   .0,     5,    -0,    -0,   2,   2,     .5,      3,      .5,      3,     2,       2], //Chicago Steno R2/R4 1.25u
//    [21.4,   15.60,  5.6, 	   5,  4.5,    0,   .0,     0,    -0,    -0,   2,   2,     .5,      3,      .5,      3,     2,       2], //Chicago Steno R3 1.25u
//    //1.5 7
//    [26.15,  15.60,   5.6, 	   5,  4.5,    0,   .0,     5,    -0,    -0,   2,   2,     .5,      3,      .5,      3,     2,       2], //Chicago Steno R2/R4 1.5
//    [26.15,  15.60,   5.6, 	   5,  4.5,    0,   .0,     0,    -0,    -0,   2,   2,     .5,      3,      .5,      3,     2,       2], //Chicago Steno R3 1.5u
//    //1.75 9
//    [30.90,  15.60,   5.6, 	   5,  4.5,    0,   .0,     5,    -0,    -0,   2,   2,     .5,      3,      .5,      3,     2,       2], //Chicago Steno R2/R4 1.5
//    [30.90,  15.60,   5.6, 	   5,  4.5,    0,   .0,     0,    -0,    -0,   2,   2,     .5,      3,      .5,      3,     2,       2], //Chicago Steno R3 1.5u
//    // Ergo shits
//    [18.75,  18.75,   5.6, 	   5,    8,    0,   .25,     0,    -0,    -0,   2, 2.5,    .10,      3,     .10,      3,     2,       2], //highpro 19.05 R2|4
//    [17.20,  16.00,   5.6, 	   5,  4.7,    0,   .0,      3,    -0,    -0,   2, 2.5,    .10,      2,     .10,      3,     2,       2], //Chicago Steno R2 ALT
//    [17.20,  16.00,   5.6, 	   5,  5.5,    0,   .0,      7,    -0,    -0,   2, 2.5,    .10,      2,     .10,      3,     2,       2], //Chicago Steno R1 Steap
//    [17.20,  16.00,   5.6, 	   5,  7.0,    0,   .0,     10,    -0,    -0,   2, 2.5,    .10,      2,     .10,      3,     2,       2], //Chicago Steno R1 mild with alt R2
];

// Dish is built using two sub-dishes: Center to Front (F) and Center to Back (B)
// Each sub-dish follow a trajectory built with two sub-trajectories (more can be added if needed ...)
//      FRONT                BACK
// DishDepth     [0] - DishDepth     [0] : Dish size on the Z axis
// DishHeightDif [1] - DishHeightDif [1] : Dish Z position shift relative to key height (0 means dish bottom just touch the key top)
// FrontForward1 [2] - BackForward1  [9] : Dish first trajectory forward/backward distance (Y axis)
// FrontForward2 [3] - BackForward2 [10] : Dish second trajectory forward/backward distance (Y axis)
// FrontPitch1   [4] - BackPitch1   [11] : Dish first trajectory rotation/-rotation (pitch, rotation around X axis)
// FrontPitch2   [5] - BackPitch2   [12] : Dish second trajectory rotation/-rotation (pitch, rotation around X axis)
// FrontInitArc  [6] - BackInitArc  [13] : Dish Initial size (X axis) (key front)
// FrontFinArc   [7] - BackFinArc   [14] : Dish Final size (X axis) (key center)
// FrontArcExpo  [8] - BackArcExpo  [15] : Dish curvature exponent (control X curvature from init to end arc)
dishParameters = //dishParameter[keyID][ParameterID]
[
  [1.5,   3.75,       5.0,   2.3,    2,   -55,    8.50,    8.50,   2,       5.0,   3.0,    2,   -50,    8.50,   8.70,   2], //R2x 1u
  [1.5,   3.75,       4.5,   3.3,   -3,   -45,    8.50,    8.70,   2,       4.5,   3.3,   -3,   -45,    8.50,   8.70,   2], //R3x 1u

  // R3x 1.25~2.25u
  [1.5,   3.75,       4.5,   3.2,   -7,   -45,   10.75,   10.95,   2,       4.5,   3.2,   -7,   -45,   10.75,   10.95,   2], //R3x 1.25u
  [1.5,   3.75,       4.5,   3.2,   -7,   -45,   13.00,   13.20,   2,       4.5,   3.2,   -7,   -45,   13.00,   13.20,   2], //R3x 1.5u
  [1.5,   3.75,       4.5,   3.2,   -7,   -45,   15.25,   15.45,   2,       4.5,   3.2,   -7,   -45,   15.25,   15.45,   2], //R3x 1.75u
  [1.5,   3.75,       4.5,   3.2,   -7,   -45,   17.50,   17.70,   2,       4.5,   3.2,   -7,   -45,   17.50,   17.70,   2], //R3x 2.00u
  [1.5,   3.75,       4.5,   3.2,   -7,   -45,   19.75,   19.95,   2,       4.5,   3.2,   -7,   -45,   19.75,   19.95,   2], //R3x 2.25u

  //
  // Custom
  //
  // Choc spacing
  // 1U
  [1.5,   2.25,       5.0,   2.3,    2,   -55,    8.50,    8.50,   2,       5.0,   3.0,    2,   -50,    8.50,   8.70,   2], //R2x 1u
  [1.5,   2.25,       4.6,   3.3,   -3,   -45,    8.50,    8.70,   2,       4.5,   3.3,   -3,   -45,    8.50,   8.70,   2], //R3x 1u

  // MX spacing
  // 1U
  // @TODO

//  Kept as reference until validation (Columns 4 and 5 must be placed at 0 and 1)
//  original from pseudo, mislabled/ missing params?
//  [ 4.5,  3.2,   -5,  -45,    1.5,   3.75,  19.0,    18,     2,     4.5,  3.2,   -5,  -45,   19.0,    18,     2], //R3x 2u
//  [ 4.5,  3.2,   -5,  -45,    1.5,   3.75,  19.0,    18,     2,     4.5,  3.2,   -5,  -45,   19.0,    18,     2], //R3x 2u
//  ---
//  [   4,  4.2,   -5,  -15,      1,      3,  18.2,    21,     2,       5,    3,   -5,  -15,   18.2,    21,     2], //R3 2u
//  [  4.,  1.5,    8,  -55,      3,      7,   9.0,     9,     2,       4,    3,    3,  -50,    9,     9,     2],  //R3
//  [  4.,  1.5,   -0,  -50,      3,      7,   9.0,     9,     2,       4,    3,    -10,  -50,    9,     9,     2],  //R3
//  [   5,  3.5,    8,  -50,      5,    1.8,   8.8,    15,     2,       6,    4,   13,   30,    8.8,    16,     2], //R1
];

function BottomWidth(keyID)  = keyParameters[keyID][0];
function BottomLength(keyID) = keyParameters[keyID][1];
function TopWidthDiff(keyID) = keyParameters[keyID][2];
function TopLenDiff(keyID)   = keyParameters[keyID][3];
function KeyHeight(keyID)    = keyParameters[keyID][4];
function TopWidShift(keyID)  = keyParameters[keyID][5];
function TopLenShift(keyID)  = keyParameters[keyID][6];
function XAngleSkew(keyID)   = keyParameters[keyID][7];
function YAngleSkew(keyID)   = keyParameters[keyID][8];
function ZAngleSkew(keyID)   = keyParameters[keyID][9];
function WidExponent(keyID)  = keyParameters[keyID][10];
function LenExponent(keyID)  = keyParameters[keyID][11];
function CapRound0i(keyID)   = keyParameters[keyID][12];
function CapRound0f(keyID)   = keyParameters[keyID][13];
function CapRound1i(keyID)   = keyParameters[keyID][14];
function CapRound1f(keyID)   = keyParameters[keyID][15];
function ChamExponent(keyID) = keyParameters[keyID][16];
function BrimExponent(keyID) = keyParameters[keyID][17];

function DishDepth(keyID)     = dishParameters[keyID][0];
function DishHeightDif(keyID) = dishParameters[keyID][1];
function FrontForward1(keyID) = dishParameters[keyID][2];
function FrontForward2(keyID) = dishParameters[keyID][3];
function FrontPitch1(keyID)   = dishParameters[keyID][4];
function FrontPitch2(keyID)   = dishParameters[keyID][5];
function FrontInitArc(keyID)  = dishParameters[keyID][6];
function FrontFinArc(keyID)   = dishParameters[keyID][7];
function FrontArcExpo(keyID)  = dishParameters[keyID][8];
function BackForward1(keyID)  = dishParameters[keyID][9];
function BackForward2(keyID)  = dishParameters[keyID][10];
function BackPitch1(keyID)    = dishParameters[keyID][11];
function BackPitch2(keyID)    = dishParameters[keyID][12];
function BackInitArc(keyID)   = dishParameters[keyID][13];
function BackFinArc(keyID)    = dishParameters[keyID][14];
function BackArcExpo(keyID)   = dishParameters[keyID][15];


function FrontTrajectory(keyID) =
  [
    trajectory(forward = FrontForward1(keyID), pitch =  FrontPitch1(keyID)),
    trajectory(forward = FrontForward2(keyID), pitch =  FrontPitch2(keyID))
  ];

function BackTrajectory (keyID) =
  [
    trajectory(forward = BackForward1(keyID), pitch =  BackPitch1(keyID)),
    trajectory(forward = BackForward2(keyID), pitch =  BackPitch2(keyID))
  ];

//--------------Function definng Cap
function CapTranslation(t, keyID) =
  [
    ((1-t)/layers*TopWidShift(keyID)),  // X shift
    ((1-t)/layers*TopLenShift(keyID)),  // Y shift
    (t/layers*KeyHeight(keyID))         // Z shift
  ];

function CapRotation(t, keyID) =
  [
    ((1-t)/layers*XAngleSkew(keyID)),  // X shift
    ((1-t)/layers*YAngleSkew(keyID)),  // Y shift
    ((1-t)/layers*ZAngleSkew(keyID))   // Z shift
  ];

function CapTransform(t, keyID) =
  [
    pow(t/layers, WidExponent(keyID))*(BottomWidth(keyID) -TopWidthDiff(keyID)) + (1-pow(t/layers, WidExponent(keyID)))*BottomWidth(keyID) ,
    pow(t/layers, LenExponent(keyID))*(BottomLength(keyID)-TopLenDiff(keyID)) + (1-pow(t/layers, LenExponent(keyID)))*BottomLength(keyID)
  ];

function CapRoundness(t, keyID) =
  [
    pow(t/layers, ChamExponent(keyID))*(CapRound0f(keyID)) + (1-pow(t/layers, ChamExponent(keyID)))*CapRound0i(keyID),
    pow(t/layers, ChamExponent(keyID))*(CapRound1f(keyID)) + (1-pow(t/layers, ChamExponent(keyID)))*CapRound1i(keyID)
  ];

function CapRadius(t, keyID) = pow(t/layers, ChamExponent(keyID))*ChamfFinRad(keyID) + (1-pow(t/layers, ChamExponent(keyID)))*ChamfInitRad(keyID);


function InnerTranslation(t, keyID) =
  [
    ((1-t)/layers*TopWidShift(keyID)),          // X shift
    ((1-t)/layers*TopLenShift(keyID)),          // Y shift
    (t/layers*(KeyHeight(keyID)-topthickness))  // Z shift
  ];

function InnerTransform(t, keyID) =
  [
    pow(t/layers, WidExponent(keyID))*(BottomWidth(keyID) -TopLenDiff(keyID)-wallthickness*2) + (1-pow(t/layers, WidExponent(keyID)))*(BottomWidth(keyID) -wallthickness*2),
    pow(t/layers, LenExponent(keyID))*(BottomLength(keyID)-TopLenDiff(keyID)-wallthickness*2) + (1-pow(t/layers, LenExponent(keyID)))*(BottomLength(keyID)-wallthickness*2)
  ];


function BrimTranslation(t, keyID) =
  [
    ((1-t)/brimlayers*TopWidShift(keyID)),                                                          // X shift
    ((1-t)/brimlayers*TopLenShift(keyID)),                                                          // Y shift
    // Distance between innerTop and stemTop to force a connection between stems and cap
    // Use of $eps to make sure they merge (hint for union)
    stemHeight - $eps + (t/brimlayers * (KeyHeight(keyID) - topthickness - stemHeight + $eps*2.0))  // Z shift
  ];

function BrimRotation(t, keyID) =
  [
    ((1-t)/brimlayers*XAngleSkew(keyID)),   // X shift
    ((1-t)/brimlayers*YAngleSkew(keyID)),   // Y shift
    ((1-t)/brimlayers*ZAngleSkew(keyID))    // Z shift
  ];

function BrimTransform(t, keyID) =
  [
    pow(t/brimlayers, BrimExponent(keyID))*(BottomWidth(keyID) -TopLenDiff(keyID)-wallthickness*2) + (1-pow(t/brimlayers, BrimExponent(keyID)))*brimEndWidth,
    pow(t/brimlayers, BrimExponent(keyID))*(BottomLength(keyID)-TopLenDiff(keyID)-wallthickness*2) + (1-pow(t/brimlayers, BrimExponent(keyID)))*brimEndLength
  ];

function BrimRadius(t, keyID) = pow(t/brimlayers,3)*3 + (1-pow(t/brimlayers, 3))*1;


///----- KEY Builder Module
module keycap(
  keyID = 0,
  dish = true,
  stem = true,
  stemRot = 0,
  homeDot = false,
  visualizeStem = false,
  visualizeDish = false,
  crossSection = false,
  tag = "",
  cutLen = 0,
  legends = false,
  verbose = false,
) {
  $fn = fn;

  //Set Parameters for dish shape
  FrontPath = quantize_trajectories(FrontTrajectory(keyID), steps = stepsize, loop=false, start_position= $t*4);
  BackPath  = quantize_trajectories(BackTrajectory(keyID),  steps = stepsize, loop=false, start_position= $t*4);

  //Scaling initial and final dim tranformation by exponents
  function FrontDishArc(t) =  pow((t)/(len(FrontPath)),FrontArcExpo(keyID))*FrontFinArc(keyID) + (1-pow(t/(len(FrontPath)),FrontArcExpo(keyID)))*FrontInitArc(keyID);
  function BackDishArc(t)  =  pow((t)/(len(FrontPath)),BackArcExpo(keyID))*BackFinArc(keyID) + (1-pow(t/(len(FrontPath)),BackArcExpo(keyID)))*BackInitArc(keyID);

  FrontCurve = [ for(i=[0:len(FrontPath)-1]) transform(FrontPath[i], DishShapeConvex(DishDepth(keyID), FrontDishArc(i), DishDepth(keyID)+DishHeightDif(keyID), d = 0, step=step)) ];
  BackCurve  = [ for(i=[0:len(BackPath)-1])  transform(BackPath[i],  DishShapeConvex(DishDepth(keyID),  BackDishArc(i), DishDepth(keyID)+DishHeightDif(keyID), d = 0, step=step)) ];

  //builds
  difference(){
    union(){
      difference(){
        // Create outer shell
        skin([for (i=[0:layers]) transform(translation(CapTranslation(i, keyID)) * rotation(CapRotation(i, keyID)), elliptical_rectangle_profile(CapTransform(i, keyID), b = CapRoundness(i,keyID),fn=fn))]);

        // Cut inner shell
        if(stem == true){
          translate([0,0,-$eps])skin([for (i=[0:layers]) transform(translation(InnerTranslation(i, keyID)) * rotation(CapRotation(i, keyID)), elliptical_rectangle_profile(InnerTransform(i, keyID), b = CapRoundness(i,keyID),fn=fn))]);
        }

        // Make sure XY plane is flat
        translate([-50,-50,-10]) cube([100,100,10], center=false);
      }

      if(stem == true){
        // Avoid reversed brim that will shorten the stem height
        brimTop = transform(translation(BrimTranslation(brimlayers, keyID)) * rotation(BrimRotation(brimlayers, keyID)), [[0, 0, 0]]);
        brimBottom = transform(translation(BrimTranslation(0, keyID)) * rotation(BrimRotation(0, keyID)), [[0, 0, 0]]);
        innerTopToStemTop = brimTop[0][2]-brimBottom[0][2];
        assert(innerTopToStemTop > -stemMargin/2.0, str("Inner top surface is lower than stem Z origin, innerTopToStemTop = ", str(innerTopToStemTop)));

        // Avoid degenerate brim that will shorten the stem height or/and flip some faces
        shapeSize = BrimTransform(brimlayers, keyID);
        rollSlopeZ = abs(shapeSize[1] / 2.0 * sin(XAngleSkew(keyID)));
        pitchSlopeZ = abs(shapeSize[0] / 2.0 * sin(YAngleSkew(keyID)));
        slopeMaxZ = max(rollSlopeZ, pitchSlopeZ);
        maxAbsAngle = slopeMaxZ == rollSlopeZ ? XAngleSkew(keyID) : YAngleSkew(keyID);
        slopeBottomToStemTop = innerTopToStemTop - slopeMaxZ;
        assert(slopeBottomToStemTop > -stemMargin/2.0, str("Brim too low due to angle (roll or pitch), slopeBottomToStemTop = ", str(slopeBottomToStemTop), ", innerTopToStemTop = ", str(innerTopToStemTop)));

        // Draw Stem
        if(visualizeStem == true){
          #rotate([0,0,stemRot]) Choc_Stem(originZ=stemHeight, margin=stemMargin, driftAngle = stemDriftAngle);
        }
        else {
          rotate([0,0,stemRot]) Choc_Stem(originZ=stemHeight, margin=stemMargin, driftAngle = stemDriftAngle);
          }

        // Draw Brim (link cap and stem) if stem not already inside the cap thickness
        if (innerTopToStemTop > 0.0){
          if (BrimExponent(keyID) > 1) {
            layerHeight = brimlayers > 0 ? innerTopToStemTop / brimlayers : 1.0;
            layerAngle = maxAbsAngle > 0 ? slopeMaxZ / maxAbsAngle : 1.0;
            if (layerHeight < 0.01) {
              echo_warn("Brim extrusion set to linear to avoid a degenerated shape. Available height too small for good looking slope.");
              echo_info(str("layerHeight: ", layerHeight));
              adjustedSteps = [0, brimlayers];
              rotate([0,0,stemRot]) translate([0,0,-$eps]) skin([for (i=adjustedSteps) transform(translation(BrimTranslation(i, keyID)) * rotation(BrimRotation(i, keyID)), rounded_rectangle_profile(BrimTransform(i, keyID), r=BrimRadius(i, keyID), fn=fn))]);
            }
            else if (layerAngle < 0.05) {
              echo_warn("Brim extrusion set to linear to avoid a degenerated shape. Angle too step for available height.");
              echo_info(str("layerAngle: ", layerAngle));
              adjustedSteps = [0, brimlayers];
              rotate([0,0,stemRot]) translate([0,0,-$eps]) skin([for (i=adjustedSteps) transform(translation(BrimTranslation(i, keyID)) * rotation(BrimRotation(i, keyID)), rounded_rectangle_profile(BrimTransform(i, keyID), r=BrimRadius(i, keyID), fn=fn))]);
            }
            else {
              rotate([0,0,stemRot]) translate([0,0,-$eps]) skin([for (i=[0:brimlayers]) transform(translation(BrimTranslation(i, keyID)) * rotation(BrimRotation(i, keyID)), rounded_rectangle_profile(BrimTransform(i, keyID), r=BrimRadius(i, keyID), fn=fn))]);
            }
          }
          else {
            rotate([0,0,stemRot]) translate([0,0,-$eps]) skin([for (i=[0:brimlayers]) transform(translation(BrimTranslation(i, keyID)) * rotation(BrimRotation(i, keyID)), rounded_rectangle_profile(BrimTransform(i, keyID), r=BrimRadius(i, keyID), fn=fn))]);
          }
        }

        // Debug helper
        if (verbose == true) {
          echo_info(str("shapeSize: ", shapeSize));
          echo_info(str("roll: ", XAngleSkew(keyID)));
          echo_info(str("pitch: ", YAngleSkew(keyID)));
          echo_info(str("maxAbsAngle: ", maxAbsAngle));
          echo_info(str("rollSlopeZ: ", rollSlopeZ));
          echo_info(str("pitchSlopeZ: ", pitchSlopeZ));
          echo_info(str("slopeMaxZ: ", slopeMaxZ));
          echo_info(str("brimTop: ", brimTop));
          echo_info(str("brimBottom: ", brimBottom));
          echo_info(str("innerTopToStemTop / available: ", innerTopToStemTop));
          echo_info(str("slopeBottomToStemTop: ", slopeBottomToStemTop));
          echo_info(str("layerAngle: ", is_undef(layerAngle) ? str("Not defined") : layerAngle));
          echo_info(str("layerHeight: ", is_undef(layerHeight) ? str("Not defined") : layerHeight));
        }
        else if(visualizeStem == true){
          %rotate([0,0,stemRot]) Choc_Stem(originZ=stemHeight, margin=stemMargin, driftAngle = stemDriftAngle);
        }
      }
    }

    // Cuts (unused for now, imported from concave version)
    if(cutLen != 0){
      translate([sign(cutLen)*(BottomLength(keyID)+CapRound0i(keyID)+abs(cutLen))/2,0,0])
        cube([BottomWidth(keyID)+CapRound1i(keyID)+1,BottomLength(keyID)+CapRound0i(keyID),50], center = true);
    }

    // Fonts
    if(legends ==  true){
      #rotate([-XAngleSkew(keyID),YAngleSkew(keyID),ZAngleSkew(keyID)])translate([-1,-5,KeyHeight(keyID)-2.5])linear_extrude(height = 1)text( text = "ver2", font = "Constantia:style=Bold", size = 3, valign = "center", halign = "center" );
      // #rotate([-XAngleSkew(keyID),YAngleSkew(keyID),ZAngleSkew(keyID)])translate([0,-3.5,0])linear_extrude(height = 0.5)text( text = "Me", font = "Constantia:style=Bold", size = 3, valign = "center", halign = "center" );
    }

    // Tag / Version (negative version, could affect the top surface when thickness is small)
    if(tag != ""){
      tagheight = 0.1;
      translate(BrimTranslation(0, keyID) + [0, 0, -$eps]) rotate(BrimRotation(0, keyID)) {
          linear_extrude(height = tagheight)rotate([0, 180, 0])text( text = tag, font = "Constantia:style=Bold", size = 3, valign = "center", halign = "center" );
      }
    }

    // Dish Shape
    if(dish == true){
      if(visualizeDish == true) {
        #translate([-TopWidShift(keyID),$eps-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)-DishDepth(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(FrontCurve);
        #translate([-TopWidShift(keyID),-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)-DishDepth(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90-XAngleSkew(keyID),270-ZAngleSkew(keyID)])skin(BackCurve);
      }
      else {
        translate([-TopWidShift(keyID),$eps-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)-DishDepth(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(FrontCurve);
        translate([-TopWidShift(keyID),-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)-DishDepth(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90-XAngleSkew(keyID),270-ZAngleSkew(keyID)])skin(BackCurve);
      }
    }
    else if(visualizeDish == true){
      %translate([-TopWidShift(keyID),$eps-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)-DishDepth(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(FrontCurve);
      %translate([-TopWidShift(keyID),-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)-DishDepth(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90-XAngleSkew(keyID),270-ZAngleSkew(keyID)])skin(BackCurve);
    }

    // Debug internals
    if(crossSection == true) {
      translate([-10,-15,-10])cube([13,30,20]);
    }
  }

  // Homing
  if(homeDot == true)
  {
    // @WIP
    translate([0,0,KeyHeight(keyID)-DishHeightDif(keyID)-.25])sphere(r = homeRadius);
  }
}


//lp_key = [
////     "base_sx", 18.5,
////     "base_sy", 18.5,
//     "base_sx", 17.65,
//     "base_sy", 16.5,
//     "cavity_sx", 16.1,
//     "cavity_sy", 14.9,
//     "cavity_sz", 1.6,
//     "cavity_ch_xy", 1.6,
//     "indent_inset", 1.5
//     ];
//Choc Chord version Chicago Stenographer
//#square([18.16, 18.16], center = true);
//translate([0,19,0])keycap(keyID = 1, Stem =false,  Dish = true, stab = 0 , visualizeDish = true, crossSection = false, homeDot = false, Legends = false);
//translate([0,0,0])lp_master_base(xu = 2, yu = 1 );
//stem_cavity_negative(lp_key, x=1, y=1);
//}
//#translate([0,0,0])cube([14.5, 13.5, 10], center = true); // internal check
//#translate([0,0,0])cube([17.5, 16.5, 10], center = true); // external check
//translate([0,17,0])mirror([0,1,0])keycap(keyID = 0, Stem =false,  Dish = true, stab = 0 , visualizeDish = false, crossSection = false, homeDot = false, Legends = false);
//translate([18,0,0])mirror([0,0,0])keycap(keyID = 0, Stem =false,  Dish = true, stab = 0 , visualizeDish = false, crossSection = false, homeDot = false, Legends = false);
//n translate([0,19, 0])keycap(keyID = 3, Stem =true,  Dish = true, visualizeDish = true, crossSection = true, homeDot = false, Legends = false);
// translate([0,38, 0])mirror([0,1,0])keycap(keyID = 2, Stem =true,  Dish = true, visualizeDish = false, crossSection = true, homeDot = false, Legends = false);
