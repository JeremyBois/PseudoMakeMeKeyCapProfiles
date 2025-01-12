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

//Choc Chord version Chicago Stenographer

// Global overloadable epsilon at different scope
$eps = 1/80;

//
// Testers
//

// translate([-19, 0, 0])keycap(
//   keyID  = 28, //change profile refer to KeyParameters Struct
//   cutLen = 0, //Don't change. for chopped caps
//   stem   = false, // Turn on inner shell, brim and stems
//   stemRot = 0, //change stem orientation by deg
//   homeDot = false, //turn on homedots,
//   homeBar = false, //turn on homebar,
//   dish   = true, //turn on dish cut
//   visualizeDish = false, // turn on debug visual of Dish
//   crossSection  = false, // center cut to check internal
//   legends = false,
//   verbose = false
//   );
// translate([-19, 0, 10]) cube(size = [1, 1, 1], center = true);

keycap(
  keyID  = 25, //change profile refer to KeyParameters Struct
  cutLen = 0, //Don't change. for chopped caps
  stem   = true, // Turn on inner shell, brim and stems
  stemRot = 0, //change stem orientation by deg
  homeDot = false, //turn on homedots,
  homeBar = false, //turn on homebar,
  dish   = true, //turn on dish cut
  visualizeDish = false, // turn on debug visual of Dish
  crossSection  = false, // center cut to check internal
  legends = false,
  verbose = false
  // , tag = str("8")
  );

// translate([19, 0, 0]) keycap(
//   keyID  = 26, //change profile refer to KeyParameters Struct
//   cutLen = 0, //Don't change. for chopped caps
//   stem   = false, // Turn on inner shell, brim and stems
//   stemRot = 0, //change stem orientation by deg
//   homeDot = false, //turn on homedots,
//   homeBar = false, //turn on homebar,
//   dish   = true, //turn on dish cut
//   visualizeDish = false, // turn on debug visual of Dish
//   crossSection  = false, // center cut to check internal
//   legends = false,
//   verbose = false,
//   tag = str("8")
//   );

//#cube([18.16, 18.16, 10], center = true); // sanity check border

// ----- Parameters
wallthickness = 1.1;  // 1.75 (MX) 1.1 (Choc)
topthickness = 2.8;   // 2.80 (MX) 2.80 (Choc)
stepsize = 60;        // Resolution of Trajectory
step = 0.5;           // Resolution of ellipes
fn = 60;              // Resolution of Rounded Rectangles: 60 for output
layers = 50;          // Resolution of vertical Sweep: 50 for output
dotRadius = 0.55;

// ----- Brim and Stem Parameters
brimEndWidth = 7.5;    // X 7.5
brimEndLength = 5.5;   // Y 5.5
brimEndHeight = 1.7;   // Z 1.7
brimlayers = 50;       // Resolution of brim to transition from cap to stem
stemDriftAngle = 0;    // Drift in legs holes


keyParameters = //keyParameters[KeyID][ParameterID]
[
    // BrimEx : Control the curve exponent when extruding the brim to transition from inner cap to stem top
//  BotWid, BotLen, TWDif, TLDif, keyh, WSft, LSft, XSkew, YSkew, ZSkew, WEx, LEx, CapR0i, CapR0f, CapR1i, CapR1f, CapREx, BrimEx
    //Column 0
    //Levee: Chicago in choc Dimension
    [17.20,  16.00,   5.6, 	   5,  4.9,    0,   .0,     5,    -0,    -0,   2, 2.5,    .10,      2,     .10,      3,     2,       2], //Chicago Steno R2/R4
    [17.20,  16.00,   5.6, 	   5,  4.5,    0,   .0,     0,    -0,    -0,   2, 2.5,    .10,      3,     .10,      3,     2,       2], //Chicago Steno R3 flat
    [17.20,  16.00,  1.25, 	1.25,  4.5,    0,   .0,     0,    -0,    -0,   2, 2.5,    .10,     .5,     .10,     .5,     2,       2], //Chicago Steno R3 chord
    //mods 3
    [17.20,  16.00,  4.25, 	3.25,  5.5,  -.7,  0.7,     0,    -4,    -0,   2,   2,    .10,      2,     .10,      2,     2,       2], //Levee Corner R2
    [17.20,  16.00,  4.25, 	3.25,  5.2,  -.8,  0.6,     0,    -4,    -0,   2,   3,    .10,      2,     .10,      2,     2,       2], //Levee Corner R2
    //1.25: [5, 6]
    [21.7,   15.60,  5.6, 	   5,  4.9,    0,   .0,     5,    -0,    -0,   2, 2.5,     .1,      2,      .1,      3,     2,       2], //Chicago Steno R2/R4 1.25u
    [21.7,   15.60,  5.6, 	   5,  4.5,    0,   .0,     0,    -0,    -0,   2, 2.5,     .1,      3,      .1,      3,     2,       2], //Chicago Steno R3 1.25u
    //1.5: [7, 8]
    [26.20,  15.60,   5.6, 	   5,  4.9,    0,   .0,     5,    -0,    -0,   2, 2.5,     .1,      2,      .1,      3,     2,       2], //Chicago Steno R2/R4 1.5
    [26.20,  15.60,   5.6, 	   5,  4.5,    0,   .0,     0,    -0,    -0,   2, 2.5,     .1,      3,      .1,      3,     2,       2], //Chicago Steno R3 1.5u
    //1.75: [9, 10]
    [30.70,  15.60,   5.6, 	   5,  4.9,    0,   .0,     5,    -0,    -0,   2, 2.5,     .1,      2,      .1,      3,     2,       2], //Chicago Steno R2/R4 1.5
    [30.70,  15.60,   5.6, 	   5,  4.5,    0,   .0,     0,    -0,    -0,   2, 2.5,     .1,      3,      .1,      3,     2,       2], //Chicago Steno R3 1.5u
    //2.00: [11, 12]
    [35.20,  15.60,   5.6, 	   5,  4.9,    0,   .0,     5,    -0,    -0,   2, 2.5,     .1,      2,      .1,      3,     2,       2], //Chicago Steno R2/R4 1.5
    [35.20,  15.60,   5.6, 	   5,  4.5,    0,   .0,     0,    -0,    -0,   2, 2.5,     .1,      3,      .1,      3,     2,       2], //Chicago Steno R3 1.5u
    //2.25: [13, 14]
    [39.70,  15.60,   5.6, 	   5,  4.9,    0,   .0,     5,    -0,    -0,   2, 2.5,     .1,      2,      .1,      3,     2,       2], //Chicago Steno R2/R4 1.5
    [39.70,  15.60,   5.6, 	   5,  4.5,    0,   .0,     0,    -0,    -0,   2, 2.5,     .1,      3,      .1,      3,     2,       2], //Chicago Steno R3 1.5u
    // Ergo shits [15, 18]
    [18.75,  18.75,   5.6, 	   5,    8,    0,   .25,     0,    -0,    -0,   2, 2.5,    .10,      3,     .10,      3,     2,       2], //highpro 19.05 R2|4
    [17.20,  16.00,   5.6, 	   5,  4.7,    0,   .0,      3,    -0,    -0,   2, 2.5,    .10,      2,     .10,      3,     2,       2], //Chicago Steno R2 ALT
    [17.20,  16.00,   5.6, 	   5,  5.5,    0,   .0,      7,    -0,    -0,   2, 2.5,    .10,      2,     .10,      3,     2,       2], //Chicago Steno R1 Steap
    [17.20,  16.00,   5.6, 	   5,  7.0,    0,   .0,     10,    -0,    -0,   2, 2.5,    .10,      2,     .10,      3,     2,       2], //Chicago Steno R1 mild with alt R2


    //
    // Custom
    //
    // BotWid, BotLen,  TWDif,TLDif, keyh, WSft, LSft, XSkew, YSkew, ZSkew, WEx, LEx, CapR0i, CapR0f, CapR1i, CapR1f, CapREx, BrimEx

    // Tests [19, 20]
    [30,  15.00,   5.6,     5,  10,    0,   .0,     50,    -0,    -0,   2, 2.5,    .10,      3,     .10,      3,     2,       2], //Chicago Steno R3 flat
    [30,  15.00,   5.6,     5,  4.5,    0,   .0,     0,    -0,    -0,   2, 2.5,    .10,      3,     .10,      3,     2,       2], //Chicago Steno R3 flat

    // Choc spacing [21, 23]
    [17.20,  16.00,   5.6,     5,  4.9,    0,   .0,     5,    -0,    -0,   2, 2.5,    .10,      2,     .10,      3,     2,       1], //Chicago Steno R2/R4
    [17.20,  16.00,   5.6,     5,  4.5,    0,   .0,     0,    -0,    -0,   2, 2.5,    .10,      3,     .10,      3,     2,       1], //Chicago Steno R3 flat
    [17.20,  16.00,  1.25,  1.25,  4.5,    0,   .0,     0,    -0,    -0,   2, 2.5,    .10,     .5,     .10,     .5,     2,       2], //Chicago Steno R3 chord (@TODO)

    // MX spacing [24, 25]
    // v8
    [18.00,  18.00,   6.1,     6.3,  5.0,    0,   .0,     5,    -0,    -0,   2, 2.5,    .10,      2,     .10,      3,     2,       1], //Chicago Steno R2/R4
    [18.00,  18.00,   6.1,     6.3,  4.6,    0,   .0,     0,    -0,    -0,   2, 2.5,    .10,      3,     .10,      3,     2,       1], //Chicago Steno R3 flat
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
  //
  // Default
  //
  // 1U
  [ 7,   1.7,       4.5,   4.0,   7,  -50,   11.5,   17.5,   2,       4.5,   4.0,   2,   -35,   11.5,   15.0,   2], //Chicago Steno R2/R4
  [ 7,   1.7,       4.5,   4.0,   5,  -40,   11.5,   15.0,   2,       4.5,   4.0,   5,   -40,   11.5,   15.0,   2], //Chicago Steno R3 flat
  [ 7,   1.7,       4.5,   4.0,   5,  -40,   11.5,   15.0,   2,       4.5,   4.0,   5,   -40,   11.5,   15.0,   2], //Chicago Steno R3 chord
  [ 5,   1.0,       6.0,   3.5,   7,  -50,   16.0,   23.0,   2,       6.0,   3.5,   7,   -50,   16.0,   23.0,   2], //Levee Steno R2/R4
  [ 5,   1.0,       6.0,   3.5,   7,  -50,   16.0,   23.0,   2,       6.0,   3.5,   7,   -50,   16.0,   23.0,   2], //Levee Steno R2/R4
  // 1.25U
  [ 8,   1.7,       4.5,   4.0,   7,  -40,   16.0,   22.5,   2,       4.5,   4.0,   2,   -35,   16.0,   19.5,   2], //Chicago Steno R2/R4
  [ 8,   1.7,       4.5,   4.0,   5,  -40,   16.0,   19.5,   2,       4.5,   4.0,   5,   -40,   16.0,   19.5,   2], //Chicago Steno R3
  // 1.5U
  [ 8,   1.7,       4.5,   4.0,   7,  -40,   20.5,   26.5,   2,       4.5,   4.0,   2,   -35,   20.5,   24.0,   2], //Chicago Steno R2/R4
  [ 8,   1.7,       4.5,   4.0,   5,  -40,   20.5,   24.0,   2,       4.5,   4.0,   5,   -40,   20.5,   24.0,   2], //Chicago Steno R3
  // 1.75U
  [ 8,   1.7,       4.5,   4.0,   7,  -40,   25.0,   31.0,   2,       4.5,   4.0,   2,   -35,   25.0,   28.5,   2], //Chicago Steno R2/R4
  [ 8,   1.7,       4.5,   4.0,   5,  -40,   25.0,   28.5,   2,       4.5,   4.0,   5,   -40,   25.0,   28.5,   2], //Chicago Steno R3
  // 2.00U
  [ 8,   1.7,       4.5,   4.0,   7,  -40,   29.5,   35.5,   2,       4.5,   4.0,   2,   -35,   29.5,   33.0,   2], //Chicago Steno R2/R4
  [ 8,   1.7,       4.5,   4.0,   5,  -40,   29.5,   33.0,   2,       4.5,   4.0,   5,   -40,   29.5,   33.0,   2], //Chicago Steno R3
  // 2.25U
  [ 8,   1.7,       4.5,   4.0,   7,  -40,   33.0,   39.0,   2,       4.5,   4.0,   2,   -35,   33.0,   36.5,   2], //Chicago Steno R2/R4
  [ 8,   1.7,       4.5,   4.0,   5,  -40,   33.0,   36.5,   2,       4.5,   4.0,   5,   -40,   33.0,   36.5,   2], //Chicago Steno R3

  [ 7,   1.7,       5.0,   5.0,   5,  -40,   11.0,   15.0,   2,       5.0,   5.0,   5,   -40,   11.0,   15.0,   2], //Chicago Steno R3 flat
  [ 7,   1.7,       4.5,   4.0,   7,  -50,   11.0,   17.0,   2,       4.5,   4.0,   2,   -35,   11.0,   15.0,   2], //Chicago Steno R1
  [ 7,   1.7,       4.5,   4.0,   7,  -50,   11.0,   17.0,   2,       4.5,   4.0,   2,   -35,   11.0,   15.0,   2], //Chicago Steno R1
  [ 7,   1.7,       4.5,   4.0,   7,  -50,   11.0,   17.0,   2,       4.5,   4.0,   2,   -35,   11.0,   15.0,   2], //Chicago Steno R1

  //
  // Custom
  //
  // Tests
  [ 7,   1.7,       10.,   8.0,   7,   -40,   15.0,   22.0,   2,       10.0,  8.0,   5,   -40,   15.0,   22.0,   2],
  [ 7,   1.7,       4.5,   4.0,   5,   -40,   11.5,   15.0,   2,       4.5,   4.0,   5,   -40,   11.5,   15.0,   2],

  // Choc spacing
  // 1U
  [ 7,   1.7,       4.5,   4.0,   7,   -50,   11.5,   17.5,   2,       4.5,   4.0,   2,   -35,   11.5,   15.0,   2], //Chicago Steno R2/R4
  [ 7,   1.7,       4.5,   4.0,   5,   -40,   11.5,   15.0,   2,       4.5,   4.0,   5,   -40,   11.5,   15.0,   2], //Chicago Steno R3 flat
  [ 7,   1.7,       4.5,   4.0,   5,   -40,   11.5,   15.0,   2,       4.5,   4.0,   5,   -40,   11.5,   15.0,   2], //Chicago Steno R3 chord

  // MX spacing
  // 1U
  // v8
  [ 8,   1.85,      4.8,   4.5,  10,   -45,   12.0,   17.5,   2,       4.8,   4.5,   5,   -30,   12.0,   17.0,   2], //Chicago Steno R2/R4
  [ 8,   1.85,      4.8,   4.5,   7,   -45,   12.0,   17.0,   2,       4.8,   4.5,   7,   -45,   12.0,   17.0,   2], //Chicago Steno R3
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
    trajectory(backward = BackForward1(keyID), pitch =  -BackPitch1(keyID)),
    trajectory(backward = BackForward2(keyID), pitch =  -BackPitch2(keyID))
  ];


//--------------Function definng Cap
function CapTranslation(t, keyID) =
  [
    ((1-t)/layers*TopWidShift(keyID)), // X shift
    ((1-t)/layers*TopLenShift(keyID)), // Y shift
    (t/layers*KeyHeight(keyID))        // Z shift
  ];

function InnerTranslation(t, keyID) =
  [
    ((1-t)/layers*TopWidShift(keyID)),         // X shift
    ((1-t)/layers*TopLenShift(keyID)),         // Y shift
    (t/layers*(KeyHeight(keyID)-topthickness)) // Z shift
  ];

function CapRotation(t, keyID) =
  [
    ((1-t)/layers*XAngleSkew(keyID)), // X shift
    ((1-t)/layers*YAngleSkew(keyID)), // Y shift
    ((1-t)/layers*ZAngleSkew(keyID))  // Z shift
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

function InnerTransform(t, keyID) =
  [
    pow(t/layers, WidExponent(keyID))*(BottomWidth(keyID) -TopLenDiff(keyID)-wallthickness*2) + (1-pow(t/layers, WidExponent(keyID)))*(BottomWidth(keyID) -wallthickness*2),
    pow(t/layers, LenExponent(keyID))*(BottomLength(keyID)-TopLenDiff(keyID)-wallthickness*2) + (1-pow(t/layers, LenExponent(keyID)))*(BottomLength(keyID)-wallthickness*2)
  ];

function StemTranslation(t, keyID) =
  [
    ((1-t)/brimlayers*TopWidShift(keyID)),   // X shift
    ((1-t)/brimlayers*TopLenShift(keyID)),   // Y shift
    // Distance between innerTop and stemTop to force a connection between stems and cap
    // Use of $eps to make sure they merge (hint for union)
    brimEndHeight - $eps + (t/brimlayers * (KeyHeight(keyID) - topthickness - brimEndHeight + $eps*2.0))    // Z shift
  ];

function StemRotation(t, keyID) =
  [
    ((1-t)/brimlayers*XAngleSkew(keyID)),   // X shift
    ((1-t)/brimlayers*YAngleSkew(keyID)),   // Y shift
    ((1-t)/brimlayers*ZAngleSkew(keyID))    // Z shift
  ];

function StemTransform(t, keyID) =
  [
    pow(t/brimlayers, BrimExponent(keyID))*(BottomWidth(keyID) -TopLenDiff(keyID)-wallthickness*2) + (1-pow(t/brimlayers, BrimExponent(keyID)))*brimEndWidth,
    pow(t/brimlayers, BrimExponent(keyID))*(BottomLength(keyID)-TopLenDiff(keyID)-wallthickness*2) + (1-pow(t/brimlayers, BrimExponent(keyID)))*brimEndLength
  ];

function StemRadius(t, keyID) = pow(t/brimlayers,3)*3 + (1-pow(t/brimlayers, 3))*1;

///----- KEY Builder Module
module keycap(
  keyID = 0,
  cutLen = 0,
  stem = true,
  stemRot = 0,
  homeDot = false,
  homeBar = false,
  dish = true,
  visualizeDish = false,
  crossSection = false,
  legends = false,
  verbose = false,
  tag = "",
) {
  $fn = fn;

  // Set Parameters for dish shape
  FrontPath = quantize_trajectories(FrontTrajectory(keyID), steps = stepsize, loop=false);
  BackPath  = quantize_trajectories(BackTrajectory(keyID),  steps = stepsize, loop=false);

  // Use exponent to control the curvature (shrinkage) from init to final sub-trajectories
  function FrontDishArc(t) = pow((t) / (len(FrontPath)), FrontArcExpo(keyID)) * FrontFinArc(keyID) + (1-pow(t/(len(FrontPath)), FrontArcExpo(keyID)))*FrontInitArc(keyID);
  function BackDishArc(t)  =  pow((t)/(len(FrontPath)),BackArcExpo(keyID))*BackFinArc(keyID) + (1-pow(t/(len(FrontPath)),BackArcExpo(keyID)))*BackInitArc(keyID);

  // Force normals to be on the same side for both forward and backward directions
  FrontCurve = [ for(i=[0:len(FrontPath)-1]) transform(FrontPath[i], DishShapeConcave(DishDepth(keyID), FrontDishArc(i), d = 0, step=step)) ];
  BackCurve  = [ for(i=[len(BackPath)-1:-1:0])  transform(BackPath[i],  DishShapeConcave(DishDepth(keyID),  BackDishArc(i), d = 0, step=step)) ];

  // Builds
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
        brimTop = transform(translation(StemTranslation(brimlayers, keyID)) * rotation(StemRotation(brimlayers, keyID)), [[0, 0, 0]]);
        brimBottom = transform(translation(StemTranslation(0, keyID)) * rotation(StemRotation(0, keyID)), [[0, 0, 0]]);
        innerTopToStemTop = brimTop[0][2]-brimBottom[0][2];
        assert(innerTopToStemTop > 0.0, str("Inner top surface is lower than stem Z origin, innerTopToStemTop = ", str(innerTopToStemTop)));

        // Avoid degenerate brim that will shorten the stem height or/and flip some faces
        shapeSize = StemTransform(brimlayers, keyID);
        rollSlopeZ = abs(shapeSize[1] / 2.0 * sin(XAngleSkew(keyID)));
        pitchSlopeZ = abs(shapeSize[0] / 2.0 * sin(YAngleSkew(keyID)));
        slopeMaxZ = max(rollSlopeZ, pitchSlopeZ);
        slopeBottomToStemTop = innerTopToStemTop - slopeMaxZ;
        assert(slopeBottomToStemTop > 0.0, str("Brim too low due to angle (roll or pitch), slopeBottomToStemTop = ", str(slopeBottomToStemTop)));

        // Draw Stem
        rotate([0,0,stemRot]) Choc_Stem(driftAngle = stemDriftAngle, originZ=brimEndHeight);

        // Draw Brim (link cap and stem)
        layerHeight = layers > 0 ? innerTopToStemTop / layers : 1.0;
        maxAbsAngle = slopeMaxZ == rollSlopeZ ? XAngleSkew(keyID) : YAngleSkew(keyID);
        layerAngle = maxAbsAngle > 0 ? slopeMaxZ / maxAbsAngle : 1.0;
        if (BrimExponent(keyID) > 1) {
          if (layerHeight < 0.01) {
            echo_warn("Brim extrusion set to linear to avoid a degenerated shape. Available height too small for good looking slope.");
            echo_info(str("layerHeight: ", layerHeight));
            adjustedSteps = [0, brimlayers];
            rotate([0,0,stemRot]) translate([0,0,-$eps]) skin([for (i=adjustedSteps) transform(translation(StemTranslation(i, keyID)) * rotation(StemRotation(i, keyID)), rounded_rectangle_profile(StemTransform(i, keyID), r=StemRadius(i, keyID), fn=fn))]);
          }
          else if (layerAngle < 0.05) {
            echo_warn("Brim extrusion set to linear to avoid a degenerated shape. Angle too step for available height.");
            echo_info(str("layerAngle: ", layerAngle));
            adjustedSteps = [0, brimlayers];
            rotate([0,0,stemRot]) translate([0,0,-$eps]) skin([for (i=adjustedSteps) transform(translation(StemTranslation(i, keyID)) * rotation(StemRotation(i, keyID)), rounded_rectangle_profile(StemTransform(i, keyID), r=StemRadius(i, keyID), fn=fn))]);
          }
          else {
            rotate([0,0,stemRot]) translate([0,0,-$eps]) skin([for (i=[0:brimlayers]) transform(translation(StemTranslation(i, keyID)) * rotation(StemRotation(i, keyID)), rounded_rectangle_profile(StemTransform(i, keyID), r=StemRadius(i, keyID), fn=fn))]);
          }
        }
        else {
          rotate([0,0,stemRot]) translate([0,0,-$eps]) skin([for (i=[0:brimlayers]) transform(translation(StemTranslation(i, keyID)) * rotation(StemRotation(i, keyID)), rounded_rectangle_profile(StemTransform(i, keyID), r=StemRadius(i, keyID), fn=fn))]);
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
          echo_info(str("layerAngle: ", layerAngle));
          echo_info(str("layerHeight: ", layerHeight));
        }
      }
    }

    // Cuts
    if(cutLen != 0){
      translate([sign(cutLen)*(BottomLength(keyID)+CapRound0i(keyID)+abs(cutLen))/2,0,0])
        cube([BottomWidth(keyID)+CapRound1i(keyID)+1,BottomLength(keyID)+CapRound0i(keyID),50], center = true);
    }

    // Fonts
    if(legends ==  true){
      #rotate([-XAngleSkew(keyID),YAngleSkew(keyID),ZAngleSkew(keyID)])translate([-1,-5,KeyHeight(keyID)-2.5])linear_extrude(height = 1)text( text = "ver2", font = "Constantia:style=Bold", size = 3, valign = "center", halign = "center" );
    }

    // Tag / Version (negative version, could affect the top surface when thickness is small)
    if(tag != ""){
      tagheight = 0.1;
      translate(StemTranslation(0, keyID) + [0, 0, -$eps]) rotate(StemRotation(0, keyID)) {
          linear_extrude(height = tagheight)rotate([0, 180, 0])text( text = tag, font = "Constantia:style=Bold", size = 3, valign = "center", halign = "center" );
      }
    }

    // Dish Shape
    if(dish == true){
      if(visualizeDish == true){
        #translate([-TopWidShift(keyID),$eps-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(FrontCurve);
        #translate([-TopWidShift(keyID),-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(BackCurve);
      }
      else {
        translate([-TopWidShift(keyID),$eps-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(FrontCurve);
        translate([-TopWidShift(keyID),-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(BackCurve);
      }
    }
    else if(visualizeDish == true){
      %translate([-TopWidShift(keyID),$eps-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(FrontCurve);
      %translate([-TopWidShift(keyID),-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(BackCurve);
    }

    // Debug internals
    if(crossSection == true) {
      translate([0,-25,-.1])cube([15,50,15]);
    }
  }

  // Homing
  if(homeDot == true){
      x = 2;
      y = -4.5;
      z = KeyHeight(keyID)-DishHeightDif(keyID) + 0.3 * dotRadius;

      translate([x, y, z])sphere(dotRadius);
      translate([-x, y, z])sphere(dotRadius);
  }

  if(homeBar == true) {
    homey = -4.5;
    homez = KeyHeight(keyID)-DishHeightDif(keyID) + 0.15;
    l = 5.5;

    translate([0, homey, homez])
    rotate([0,90,0])
    translate([0, 0, -l / 2])
    union () {
        translate([0, 0, dotRadius]) sphere(r = dotRadius);
        translate([0, 0, dotRadius])cylinder(h = l -dotRadius * 2, r= dotRadius);
        translate([0, 0, l -dotRadius])sphere(r = dotRadius);
    }
  }
}


//lp_production_base();
//for(i = [0:3-1]){
//        for(j = [0:2-1]){
//            translate([(1-i)*21, (.5-j)*21,0]){
//            keycap(keyID = 1, cutLen = 0, Stem =false,  Dish = true, SecondaryDish = false ,Stab = 0 , visualizeDish =false , crossSection = false, homeDot = true, Legends = false);
////              import("R3X.stl");
//          }
//        }
//      }
//for(i = [0:1-1]){
//        for(j = [0:2-1]){
//            translate([(1-i)*21, (.5-j)*21,0]){
//            keycap(keyID = 1, cutLen = 0, Stem =false,  Dish = true, SecondaryDish = false ,Stab = 0 , visualizeDish =false , crossSection = false, homeDot = true, Legends = false);
//          }
//        }
//      }
//translate([(1-0)*21, (.5-0)*21,0])
