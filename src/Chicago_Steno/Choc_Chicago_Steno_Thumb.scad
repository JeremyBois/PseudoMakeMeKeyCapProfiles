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
use <../Common/key.scad>
use <../Common/logging.scad>

// Choc Chord version Chicago Stenographer with sculpte Thumb cluster


// Global overloadable epsilon at different scope
$eps = 1/80;

//
// Testers
//
Xspacing = 18;
Yspacing = 17;

mirror([0,180,0])keycap(
  keyID  = 16,  //change profile refer to KeyParameters Struct
  cutLen = 0,  //Don't change. for chopped caps
  stem   = true,  // Turn on inner shell, brim and stems
  stemRot = 90,  //change stem orientation by deg
  homeDot = false,  //turn on homedots,
  homeBar = false,  //turn on homebar,
  dish   = true,  //turn on dish cut
  secondaryDish = false, //turn on dish cut
  visualizeDish = false,  // turn on debug visual of Dish
  visualizeSecondaryDish = false,  // turn on debug visual of Dish
  visualizeStem = false,  // turn on debug visual of Stem
  crossSection  = false,  // center cut to check internal
  legends = false,
  verbose = false
);

//#cube([18.16, 18.16, 10], center = true); // sanity check border

// ----- Parameters
wallthickness = 1.1;  // 1.75 ?? (MX) 1.10 (Choc)
topthickness  = 2.9;  // 2.90 ?? (MX) 2.90 (Choc)
stepsize      = 60;   // Resolution of Trajectory
fn            = 60;   // Resolution of Rounded Rectangles
layers        = 50;   // Resolution of vertical Sweep
step          = 0.5;  // Resolution of ellipes
homeRadius    = 0.55;

// ----- Stem Parameters
brimEndWidth   = 7.5;   // X 7.5
brimEndLength  = 5.5;   // Y 5.5
brimLayers     = 50;    // Resolution of brim to transition from cap to stem

// ----- Stem Parameters
stemHeight     = 1.7;   // Z 1.7 < 2.0 (5.8 - 3 - 0.8) based on Choc specifications
stemMargin     = 0.1;   // Allowed stem insertion inside the cap thickness
stemDriftAngle = 0.0;   // Drift in legs holes

Choc_KeyFreeSpace(1.4, 1.4, 3.0 + stemMargin, stemHeight);  // Current case


keyParameters = //keyParameters[KeyID][ParameterID]
[
//  BotWid, BotLen, TWDif, TLDif, keyh, WSft, LSft  XSkew, YSkew, ZSkew, WEx, LEx, CapR0i, CapR0f, CapR1i, CapR1f, CapREx, StemEx
    //Column 0
    //Levee: Chicago in choc Dimension for ref
    [17.20,  16.00,   5.6, 	   5,  5.0,    0,   .0,     5,    -0,    -0,   2, 2.5,    .10,      2,     .10,      3,     2,       2, 0], //Levee Steno R2/R4
    [17.20,  16.00,   5.6, 	   5,  4.6,    0,   .0,     0,    -0,    -0,   2, 2.5,    .10,      3,     .10,      3,     2,       2, 0], //Levee Steno R3
    //Thumb
    [17.20,  16.00,  4.25, 	3.25,  5.0,  -.5,  0.0,    -3,    -3,    -0,   2,   2,    .10,      2,     .10,      2,     2,       2, 0], //Thumb 1
    [15.65,  26.4,   5.5, 	3.25,  4.9,  -.5,  0.0,    -3,    -2,    -2,   2,   2,     .3,      2,      .3,    2.5,     2,       2, 0], //Thumb 1.5
    [15.65,  35.8,  4.25, 	3.25,  4.9, -.25,  0.0,    -2.5,    -4,    -2,   2,   3,     .3,      2,      .3,    2.5,     2,       2, 0], //Thumb 2.0
    //1.25 5
    [21.3,   15.60,  5.6, 	   5,  4.5,    0,   .0,     5,    -0,    -0,   2,   2,     .5,      3,      .5,      3,     2,       2, 0], //Chicago Steno R2/R4 1.25u
    [21.4,   15.60,  5.6, 	   5,  4.5,    0,   .0,     0,    -0,    -0,   2,   2,     .5,      3,      .5,      3,     2,       2, 0], //Chicago Steno R3 1.25u
    //1.5 7
    [26.15,  15.60,   5.6, 	   5,  4.5,    0,   .0,     5,    -0,    -0,   2,   2,     .5,      3,      .5,      3,     2,       2, 0], //Chicago Steno R2/R4 1.5
    [26.15,  15.60,   5.6, 	   5,  4.5,    0,   .0,     0,    -0,    -0,   2,   2,     .5,      3,      .5,      3,     2,       2, 0], //Chicago Steno R3 1.5u
    //1.75 9
    [30.90,  15.60,   5.6, 	   5,  4.5,    0,   .0,     5,    -0,    -0,   2,   2,     .5,      3,      .5,      3,     2,       2, 0], //Chicago Steno R2/R4 1.5
    [30.90,  15.60,   5.6, 	   5,  4.5,    0,   .0,     0,    -0,    -0,   2,   2,     .5,      3,      .5,      3,     2,       2, 0], //Chicago Steno R3 1.5u
    // Ergo shits
    [18.75,  18.75,   5.6, 	   5,    8,    0,   .25,     0,    -0,    -0,   2, 2.5,    .10,      3,     .10,      3,     2,       2, 0], //highpro 19.05 R2|4
    [17.20,  16.00,   5.6, 	   5,  4.7,    0,   .0,      3,    -0,    -0,   2, 2.5,    .10,      2,     .10,      3,     2,       2, 0], //Chicago Steno R2 ALT
    [17.20,  16.00,   5.6, 	   5,  5.5,    0,   .0,      7,    -0,    -0,   2, 2.5,    .10,      2,     .10,      3,     2,       2, 0], //Chicago Steno R1 Steap
    [17.20,  16.00,   5.6, 	   5,  7.0,    0,   .0,     10,    -0,    -0,   2, 2.5,    .10,      2,     .10,      3,     2,       2, 0], //Chicago Steno R1 mild with alt R2

    //
    // ******* Custom *******
    //
    // BotWid, BotLen,  TWDif,TLDif, keyh, WSft, LSft, XSkew, YSkew, ZSkew, WEx, LEx, CapR0i, CapR0f, CapR1i, CapR1f, CapREx, BrimEx
    //
    // Choc spacing
    //
    // v1 [15, 17]
    [17.20,  16.00,       4.25,  3.25,  4.9,  -0.50,  0.0,       -3.0,  -3,  -0,       2,  2,       0.1,  2,  0.1,  2.0,  2,       1,       1], // CS Thumb 1u
    [16.00,  26.40,       5.50,  3.25,  4.9,  -0.50,  0.0,       -3.0,  -2,  -2,       2,  2,       0.3,  2,  0.3,  2.5,  2,       1,       1], // CS Thumb 1.5u
    // [16.00,  26.40,       5.50,  3.25,  4.9,  -0.50,  0.0,          -30.0,    0,  0,       2,  2,       0.3,  2,  0.3,  2.5,  2,       1,       1], // CS Thumb 1.5u
    [16.00,  35.80,       4.25,  3.25,  4.9,  -0.25,  0.0,       -2.5,  -4,  -2,       2,  3,       0.3,  2,  0.3,  2.5,  2,       1,       1], // CS Thumb 2.0u
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
// DshDep DshHDif   FFwd1 FFwd2 FPit1 FPit2 FArcIn FArcFn FArcEx     BFwd1 BFwd2 BPit1 BPit2  BArcIn BArcFn BArcEx FTani FTanf BTani BTanf TanEX PhiInit PhiFin
  [ 7,    1.7,     4.5,    4,    7,  -50,     11,    17,     2,      4.5,    4,    2,   -35,   11,    15,     2,     3,  4.5,    3,  4.5,   2, 203, 210], //Chicago Steno R2/R4
  [ 7,    1.7,     4.5,    4,    5,  -40,     11,    15,     2,      4.5,    4,    5,   -40,   11,    15,     2,     4,    5,    4,    5,   2, 200, 210], //Chicago Steno R3 flat

  [ 7,    1.7,       5,  5.5,    0,  -40,     16,    18,     2,       5.5,  3.5,    5,   -50,   16,    18,     2,     5,   3.75,    2,    3.75,   2, 199, 210], //T1
  [ 7,    1.7,      10,  4.5,    0,  -40,     16,    15,     2,        10,  3.5,    5,   -50,   16,    18,     2,     3,   3.75,    .75,    3.75,   2, 200, 210], //1.5u
  [ 7,    1.7,      14.5, 4.5,   4,  -40,     16,    18,     2,      14.5,  4.5,    2,   -35,   16,    23,     2,     3,   3.75,    .75,    3.75,   2, 200, 210], //2.0u
  //1.25
  [ 8,    1.8,     4.5,    4,    7,  -40,     15,    20,     2,      4.5,    4,    2,   -35,   15,    20,     2,     3,    5,    7,    5,   2, 200, 210], //Chicago Steno R2/R4
  [ 8,    1.8,     4.5,    4,    5,  -40,     15,    20,     2,      4.5,    4,    5,   -40,   15,    20,     2,     3,    5,    7,    5,   2, 200, 210], //Chicago Steno R3
  //1.5
  [ 8,    1.8,     4.5,    4,    7,  -40,     19,    25,     2,      4.5,    4,    2,   -35,   19,    25,     2], //Chicago Steno R2/R4
  [ 8,    1.8,     4.5,    4,    5,  -40,     19,    25,     2,      4.5,    4,    5,   -40,   19,    25,     2], //Chicago Steno R3
  //1.75
  [ 8,    1.8,     4.5,    4,    7,  -40,     22.5,  27,     2,      4.5,    4,    2,   -35,   22.5,  27,     2], //Chicago Steno R2/R4
  [ 8,    1.8,     4.5,    4,    5,  -40,     22.5,  27,     2,      4.5,    4,    5,   -40,   22.5,  27,     2], //Chicago Steno R3


  [ 7,    1.7,       5,    5,    5,  -40,     11,    15,     2,        5,    5,    5,   -40,   11,    15,     2], //Chicago Steno R3 flat
  [ 7,    1.7,     4.5,    4,    7,  -50,     11,    17,     2,      4.5,    4,    2,   -35,   11,    15,     2], //Chicago Steno R1
  [ 7,    1.7,     4.5,    4,    7,  -50,     11,    17,     2,      4.5,    4,    2,   -35,   11,    15,     2], //Chicago Steno R1
  [ 7,    1.7,     4.5,    4,    7,  -50,     11,    17,     2,      4.5,    4,    2,   -35,   11,    15,     2], //Chicago Steno R1

  //
  // ******* Custom *******
  //
  // Choc spacing
  //
  // v1 [15, 17]
  [ 7,    1.7,       5.00,  5.5,  0,  -40,  16,  18,  2,       5.50,  3.5,  5,  -50,  16,  18,  2,       5,  3.75,  2.0,  3.75,  2,  199,  210], // CS Thumb 1u
  [ 7,    1.7,       10.0,  4.5,  0,  -40,  16,  15,  2,       10.0,  3.5,  5,  -50,  16,  18,  2,       3,  3.75,  .75,  3.75,  2,  200,  210], // CS Thumb 1.5u
  [ 7,    1.7,       14.5,  4.5,  4,  -40,  16,  18,  2,       14.5,  4.5,  2,  -35,  16,  23,  2,       3,  3.75,  .75,  3.75,  2,  200,  210], // CS Thumb 2.0u
];

secondaryDishParam =
[
  [ 3,    2,          6,  3.5,    7,  -50,    8,     8,     2,          5,    5,    5,    15,   10,   20,     2], //Chicago Steno R2/R4
  [ 3,  2.5,          6,  3.5,    7,  -50,    8,    20,     3,          2,  4.2,    8,     0,    8,    8,     3], //Chicago Steno R3 flat
  [ 3,  2.5,          6,  3.5,    7,  -50,    8,    20,     3,          2,  4.2,    8,     0,    8,    8,     3], //Chicago Steno R3 chord

  [ 3,    2,          6,  3.5,    7,  -50,    8,     8,     2,          5,    5,    5,    15,   10,    20,     2], //Levee Steno R2/R4
  [ 5,  1.0,          6,  3.5,    7,  -50,   16,    23,     2,          6,  3.5,    7,   -50,   16,    23,     2], //Levee Steno R2/R4
  //1.25
  [ 3,    2,          6,  3.5,    7,  -50,    8,     8,     2,          5,    5,    5,    15,   10,    20,     2], //Chicago Steno R2/R4
  [ 3,  2.5,          6,  3.5,    7,  -50,    8,    20,     3,          2,  4.2,    8,     0,    8,     8,     3], //Chicago Steno R3 flat
  //1.50
  [ 3,    2,          6,  3.5,    7,  -50,    8,     8,     2,          5,    5,    5,    15,   10,    20,     2], //Chicago Steno R2/R4
  [ 3,  2.5,          6,  3.5,    7,  -50,    8,    20,     3,          2,  4.2,    8,     0,    8,     8,     3], //Chicago Steno R3 flat


  [ 3,    2,          6,  3.5,    7,  -50,    8,     8,     2,          5,    5,    5,    15,   10,    20,     2], //Chicago Steno R1
  [ 3,    2,          6,  3.5,    7,  -50,    8,     8,     2,          5,    5,    5,    15,   10,    20,     2], //Chicago Steno R1
  [ 3,    2,          6,  3.5,    7,  -50,    8,     8,     2,          5,    5,    5,    15,   10,    20,     2], //Chicago Steno R1

  // Placeholders
  [ 3,    2,          6,  3.5,  7,  -50,  8,  8,  2,       5,  5,  5,  15,  10,  20,  2], //Chicago Steno R1
  [ 3,    2,          6,  3.5,  7,  -50,  8,  8,  2,       5,  5,  5,  15,  10,  20,  2], //Chicago Steno R1
  [ 3,    2,          6,  3.5,  7,  -50,  8,  8,  2,       5,  5,  5,  15,  10,  20,  2], //Chicago Steno R1
  // Placeholders

  //
  // ******* Custom *******
  //
  // BotWid, BotLen,  TWDif,TLDif, keyh, WSft, LSft, XSkew, YSkew, ZSkew, WEx, LEx, CapR0i, CapR0f, CapR1i, CapR1f, CapREx, BrimEx
  //
  // Choc spacing
  //
  // v1 [15, 17]
  [ 3,  2.5,          6,  3.5,  7,  -50,  8,  20,  3,       2,  4.2,  8,  0,  8,  8,  3],  // CS Thumb 1u
  [ 3,  2.5,          6,  3.5,  7,  -50,  8,  20,  3,       2,  4.2,  8,  0,  8,  8,  3],  // CS Thumb 1.5u
  [ 3,  2.5,          6,  3.5,  7,  -50,  8,  20,  3,       2,  4.2,  8,  0,  8,  8,  3],  // CS Thumb 2.0u


];
function BottomWidth(keyID)  = keyParameters[keyID][0];  //
function BottomLength(keyID) = keyParameters[keyID][1];  //
function TopWidthDiff(keyID) = keyParameters[keyID][2];  //
function TopLenDiff(keyID)   = keyParameters[keyID][3];  //
function KeyHeight(keyID)    = keyParameters[keyID][4];  //
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
function Version(keyID)      = str(keyParameters[keyID][18]);


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
function ForwardTanInit(keyID)= dishParameters[keyID][16];
function ForwardTanFin(keyID) = dishParameters[keyID][17];
function BackTanInit(keyID)   = dishParameters[keyID][18];
function BackTanFin(keyID)    = dishParameters[keyID][19];
function TanArcExpo(keyID)    = dishParameters[keyID][20];
function TransitionAngleInit(keyID) = dishParameters[keyID][21];
function TransitionAngleFin(keyID)  = dishParameters[keyID][22];

function SDishDepth(keyID)     = secondaryDishParam[keyID][0];
function SDishHeightDif(keyID) = secondaryDishParam[keyID][1];
function SFrontForward1(keyID) = secondaryDishParam[keyID][2];
function SFrontForward2(keyID) = secondaryDishParam[keyID][3];
function SFrontPitch1(keyID)   = secondaryDishParam[keyID][4];
function SFrontPitch2(keyID)   = secondaryDishParam[keyID][5];
function SFrontInitArc(keyID)  = secondaryDishParam[keyID][6];
function SFrontFinArc(keyID)   = secondaryDishParam[keyID][7];
function SFrontArcExpo(keyID)  = secondaryDishParam[keyID][8];
function SBackForward1(keyID)  = secondaryDishParam[keyID][9];
function SBackForward2(keyID)  = secondaryDishParam[keyID][10];
function SBackPitch1(keyID)    = secondaryDishParam[keyID][11];
function SBackPitch2(keyID)    = secondaryDishParam[keyID][12];
function SBackInitArc(keyID)   = secondaryDishParam[keyID][13];
function SBackFinArc(keyID)    = secondaryDishParam[keyID][14];
function SBackArcExpo(keyID)   = secondaryDishParam[keyID][15];


function FrontTrajectory(keyID) =
  [
    trajectory(forward = FrontForward1(keyID), pitch =  FrontPitch1(keyID)),
    trajectory(forward = FrontForward2(keyID), pitch =  FrontPitch2(keyID))
  ];

function BackTrajectory (keyID) =
  [
    trajectory(backward = BackForward1(keyID), pitch =  -BackPitch1(keyID)),
    trajectory(backward = BackForward2(keyID), pitch =  -BackPitch2(keyID)),
  ];

function SFrontTrajectory(keyID) =
  [
    trajectory(forward = SFrontForward1(keyID), pitch =  SFrontPitch1(keyID)),
    trajectory(forward = SFrontForward2(keyID), pitch =  SFrontPitch2(keyID)),
  ];

function SBackTrajectory (keyID) =
  [
    trajectory(forward = SBackForward1(keyID), pitch =  SBackPitch1(keyID)),
    trajectory(forward = SBackForward2(keyID), pitch =  SBackPitch2(keyID)),
    trajectory(forward = 4, pitch =  -15),
    trajectory(forward = 6, pitch =  -5),
  ];

//--------------Function defining Cap
function CapTranslation(t, keyID) =
  [
    (-t/layers*TopWidShift(keyID)), // X shift
    (-t/layers*TopLenShift(keyID)), // Y shift
    (t/layers*KeyHeight(keyID))        // Z shift
  ];

function InnerTranslation(t, keyID) =
  [
    (-t/layers*TopWidShift(keyID)),         // X shift
    (-t/layers*TopLenShift(keyID)),         // Y shift
    (t/layers*(KeyHeight(keyID)-topthickness)) // Z shift
  ];

function CapRotation(t, keyID) =
  [
    (-t/layers*XAngleSkew(keyID)), // X shift
    (-t/layers*YAngleSkew(keyID)), // Y shift
    (-t/layers*ZAngleSkew(keyID))  // Z shift
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

function BrimTranslation(t, keyID) =
  [
    (-t/brimLayers*TopWidShift(keyID)),   // X shift
    (-t/brimLayers*TopLenShift(keyID)),   // Y shift
    // Distance between innerTop and stemTop to force a connection between stems and cap
    // Use of $eps to make sure they merge (hint for union)
    stemHeight - $eps + (t/brimLayers * (KeyHeight(keyID) - topthickness - stemHeight + $eps*2.0))    // Z shift
  ];

function BrimRotation(t, keyID) =
  [
    (-t/brimLayers*XAngleSkew(keyID)),   //X shift
    (-t/brimLayers*YAngleSkew(keyID)),   //Y shift
    (-t/brimLayers*ZAngleSkew(keyID))    //Z shift
  ];

function BrimTransform(t, keyID) =
  [
    pow(t/brimLayers, BrimExponent(keyID))*(BottomWidth(keyID) -TopLenDiff(keyID)-wallthickness*2) + (1-pow(t/brimLayers, BrimExponent(keyID)))*brimEndWidth,
    pow(t/brimLayers, BrimExponent(keyID))*(BottomLength(keyID)-TopLenDiff(keyID)-wallthickness*2) + (1-pow(t/brimLayers, BrimExponent(keyID)))*brimEndLength
  ];

function BrimRadius(t, keyID) = pow(t/brimLayers,3)*3 + (1-pow(t/brimLayers, 3))*1;

module BrimHull(keyID, stemRotation, fn) {
  // Rotation will create a spiral path if lerp over the skinning
  // Using hull we create the simplest possible shape without any weird distorsions
  translate([0,0,-$eps]) hull() {
    translate(BrimTranslation(0, keyID)) rotate([0, 0, stemRotation]) {
      linear_extrude(height = 0.01*$eps, center = true) polygon(rounded_rectangle_profile(BrimTransform(0, keyID), r=BrimRadius(0, keyID), fn=fn));
    }
    translate(BrimTranslation(brimLayers, keyID)) rotate(BrimRotation(brimLayers, keyID)) {
      linear_extrude(height = 0.01*$eps, center = true) polygon(rounded_rectangle_profile(BrimTransform(brimLayers, keyID), r=BrimRadius(brimLayers, keyID), fn=fn));
    }
  }
}

function FTanRadius(t, keyID) = pow(t/stepsize,TanArcExpo(keyID) )*ForwardTanInit(keyID) + (1-pow(t/stepsize, TanArcExpo(keyID) ))*ForwardTanFin(keyID);

function BTanRadius(t, keyID) = pow(t/stepsize,TanArcExpo(keyID) )*BackTanInit(keyID)  + (1-pow(t/stepsize, TanArcExpo(keyID) ))*BackTanFin(keyID);

function TanTransition(t, keyID) = pow(t/stepsize,TanArcExpo(keyID) )*TransitionAngleInit(keyID)  + (1-pow(t/stepsize, TanArcExpo(keyID) ))*TransitionAngleFin(keyID);


///----- KEY Builder Module
module keycap(
  keyID = 0,
  dish = true,
  secondaryDish = false,
  stem = true,
  stemRot = 0,
  homeDot = false,
  homeBar = false,
  visualizeStem = false,
  visualizeDish = false,
  visualizeSecondaryDish = false,
  crossSection = false,
  cutLen = 0,
  legends = false,
  verbose = false,
  stab = 0,
  tag,
) {

  $fn = fn;

  // Use version as tag if none provided
  tag = is_undef(tag) ? Version(keyID) : tag;

  // Set Parameters for dish shape
  FrontPath = quantize_trajectories(FrontTrajectory(keyID), steps = stepsize, loop=false, start_position= $t*4);
  BackPath  = quantize_trajectories(BackTrajectory(keyID),  steps = stepsize, loop=false, start_position= $t*4);

  // Scaling initial and final dim tranformation by exponents
  function FrontDishArc(t) =  pow((t)/(len(FrontPath)),FrontArcExpo(keyID))*FrontFinArc(keyID) + (1-pow(t/(len(FrontPath)),FrontArcExpo(keyID)))*FrontInitArc(keyID);
  function BackDishArc(t)  =  pow((t)/(len(FrontPath)),BackArcExpo(keyID))*BackFinArc(keyID) + (1-pow(t/(len(FrontPath)),BackArcExpo(keyID)))*BackInitArc(keyID);

  FrontCurve = [ for(i=[0:len(FrontPath)-1]) transform(FrontPath[i], DishShapeConcave2( a= DishDepth(keyID), b= FrontDishArc(i), phi = TransitionAngleInit(keyID) , theta= 60
    , r = FTanRadius(i, keyID), step=step)) ];
  BackCurve  = [ for(i=[len(BackPath)-1:-1:0])  transform(BackPath[i],  DishShapeConcave2(DishDepth(keyID), BackDishArc(i), phi = TransitionAngleInit(keyID), theta= 60
    , r = BTanRadius(i, keyID), step=step)) ];

  // Secondary Dish
  SFrontPath = quantize_trajectories(SFrontTrajectory(keyID), steps = stepsize, loop=false, start_position= $t*4);
  SBackPath  = quantize_trajectories(SBackTrajectory(keyID),  steps = stepsize, loop=false, start_position= $t*4);

  // Scaling initial and final dim tranformation by exponents
  function SFrontDishArc(t) =  pow((t)/(len(SFrontPath)),SFrontArcExpo(keyID))*SFrontFinArc(keyID) + (1-pow(t/(len(SFrontPath)),SFrontArcExpo(keyID)))*SFrontInitArc(keyID);
  function SBackDishArc(t)  =  pow((t)/(len(SBackPath)),SBackArcExpo(keyID))*SBackFinArc(keyID) + (1-pow(t/(len(SFrontPath)),SBackArcExpo(keyID)))*SBackInitArc(keyID);

  SFrontCurve = [ for(i=[0:len(SFrontPath)-1]) transform(SFrontPath[i], DishShapeConcave(SDishDepth(keyID), SFrontDishArc(i), d = 0, step=step)) ];
  SBackCurve  = [ for(i=[0:len(SBackPath)-1])  transform(SBackPath[i],  DishShapeConcave(SDishDepth(keyID),  SBackDishArc(i), d = 0, step=step)) ];

  // Builds
  difference(){
    union(){
      difference(){
        // Create outer shell
        skin([for (i=[0:layers]) transform(translation(CapTranslation(i, keyID)) * rotation(CapRotation(i, keyID)), elliptical_rectangle_profile(CapTransform(i, keyID), b = CapRoundness(i,keyID), fn=fn))]);

        // Cut inner shell
        // if(stem == true){
          translate([0,0,-$eps])skin([for (i=[0:layers]) transform(translation(InnerTranslation(i, keyID)) * rotation(CapRotation(i, keyID)), elliptical_rectangle_profile(InnerTransform(i, keyID), b = CapRoundness(i,keyID), fn=fn))]);
        // }

        // Make sure XY plane is flat
        translate([-50,-50,-10]) cube([100,100,10], center=false);
      }

      if(stem == true){
        // Draw Stem
        if(visualizeStem == true){
          #rotate([0,0,stemRot]) Choc_Stem(originZ=stemHeight, margin=stemMargin, driftAngle = stemDriftAngle);
        }
        else {
          rotate([0,0,stemRot]) Choc_Stem(originZ=stemHeight, margin=stemMargin, driftAngle = stemDriftAngle);
        }

        // Avoid reversed brim that will shorten the stem height or/and flip some faces
        brimTop = transform(translation(BrimTranslation(brimLayers, keyID)) * rotation(BrimRotation(brimLayers, keyID)), [[0, 0, 0]]);
        brimBottom = transform(translation(BrimTranslation(0, keyID)) * rotation(BrimRotation(0, keyID)), [[0, 0, 0]]);
        innerTopToStemTop = brimTop[0][2]-brimBottom[0][2];
        assert(innerTopToStemTop > -stemMargin/2.0, str("Inner top surface is lower than stem Z origin, innerTopToStemTop = ", str(innerTopToStemTop)));

        // Avoid degenerate brim that will shorten the stem height or/and flip some faces
        shapeSize = BrimTransform(brimLayers, keyID);
        rollSlopeZ = abs(shapeSize[1] / 2.0 * sin(XAngleSkew(keyID)));
        pitchSlopeZ = abs(shapeSize[0] / 2.0 * sin(YAngleSkew(keyID)));
        slopeMaxZ = max(rollSlopeZ, pitchSlopeZ);
        maxAbsAngle = slopeMaxZ == rollSlopeZ ? XAngleSkew(keyID) : YAngleSkew(keyID);
        layerHeight = brimLayers > 0 ? innerTopToStemTop / brimLayers : 1.0;
        layerAngle = maxAbsAngle > 0 ? slopeMaxZ / maxAbsAngle : 1.0;

        // Draw Brim (link cap and stem) if stem not already inside the cap thickness
        if (innerTopToStemTop > 0.0) {
          if (stemRot != 0.0) {
            echo_warn("Brim extrusion using Hull to avoid a spiral like shape due to stem rotation.");
            BrimHull(keyID, stemRot, fn);
          }
          else if (layerHeight < 0.01) {
            echo_warn("Brim extrusion using Hull to avoid a degenerated shape. Available height too small for good looking slope.");
            BrimHull(keyID, stemRot, fn);
          }
          else if (layerAngle < 0.05) {
            echo_warn("Brim extrusion using Hull to avoid a degenerated shape. Angle too step for available height.");
            BrimHull(keyID, stemRot, fn);
          }
          else {
            translate([0,0,-$eps]) skin([for (i=[0:brimLayers]) transform(translation(BrimTranslation(i, keyID)) * rotation(BrimRotation(i, keyID)), rounded_rectangle_profile(BrimTransform(i, keyID), r=BrimRadius(i, keyID), fn=fn))]);
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
          echo_info(str("innerTopToStemTop: ", innerTopToStemTop));
          echo_info(str("layerAngle: ", is_undef(layerAngle) ? str("Not defined") : layerAngle));
          echo_info(str("layerHeight: ", is_undef(layerHeight) ? str("Not defined") : layerHeight));
        }
      }
      else if(visualizeStem == true){
        %rotate([0,0,stemRot]) Choc_Stem(originZ=stemHeight, margin=stemMargin, driftAngle = stemDriftAngle);
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
      // #rotate([-XAngleSkew(keyID),YAngleSkew(keyID),ZAngleSkew(keyID)])translate([0,-3.5,0])linear_extrude(height = 0.5)text( text = "Me", font = "Constantia:style=Bold", size = 3, valign = "center", halign = "center" );
    }

    // Tag
    if(tag != ""){
      minHeight = 0.15;
      tagheight = minHeight-0.025+$eps;  // @UNSURE Why 0.025 ??

      // No rotation other than stem one because zone is always flat around the stems
      rotate([0, 0, stemRot]) linear_extrude(height = tagheight+stemHeight, center=false) rotate([0, 180, 0])text( text = tag, font = "Constantia:style=Bold", size = 3, valign = "center", halign = "center" );
    }

    // Dish (primary)
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

    // Dish (secondary)
    if(secondaryDish == true){
      if(visualizeSecondaryDish == true){
        #translate([BottomWidth(keyID)/2,-BottomLength(keyID)/2,KeyHeight(keyID)-SDishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90-XAngleSkew(keyID),270-ZAngleSkew(keyID)])skin(SBackCurve);
        #mirror([1,0,0])translate([BottomWidth(keyID)/2,-BottomLength(keyID)/2,KeyHeight(keyID)-SDishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90-XAngleSkew(keyID),270-ZAngleSkew(keyID)])skin(SBackCurve);
      }
      else {
        translate([BottomWidth(keyID)/2,-BottomLength(keyID)/2,KeyHeight(keyID)-SDishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90-XAngleSkew(keyID),270-ZAngleSkew(keyID)])skin(SBackCurve);
        mirror([1,0,0])translate([BottomWidth(keyID)/2,-BottomLength(keyID)/2,KeyHeight(keyID)-SDishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90-XAngleSkew(keyID),270-ZAngleSkew(keyID)])skin(SBackCurve);
        // translate([BottomWidth(keyID)/2,-BottomLength(keyID)/2,KeyHeight(keyID)-SDishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(SFrontCurve);
        // rotate([0,0,180])translate([BottomWidth(keyID)/2,-BottomLength(keyID)/2,KeyHeight(keyID)-SDishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90-XAngleSkew(keyID),270-ZAngleSkew(keyID)])skin(SBackCurve);
        // rotate([0,0,180])translate([BottomWidth(keyID)/2,-BottomLength(keyID)/2,KeyHeight(keyID)-SDishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(SFrontCurve);
      }
    }
    else if(visualizeSecondaryDish == true){
      %translate([BottomWidth(keyID)/2,-BottomLength(keyID)/2,KeyHeight(keyID)-SDishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90-XAngleSkew(keyID),270-ZAngleSkew(keyID)])skin(SBackCurve);
      %mirror([1,0,0])translate([BottomWidth(keyID)/2,-BottomLength(keyID)/2,KeyHeight(keyID)-SDishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90-XAngleSkew(keyID),270-ZAngleSkew(keyID)])skin(SBackCurve);
    }

    // Debug internals
    if(crossSection == true) {
      // translate([0,-25,-.1])cube([15,50,15]);
      translate([0,-50,-.1])cube([15,50,15]);
    }
  }

  // Homing
  if(homeDot == true){
    // @WIP
      x = 2;
      y = -4.5;
      z = KeyHeight(keyID)-DishHeightDif(keyID) + 0.3 * homeRadius;

      translate([x, y, z])sphere(homeRadius);
      translate([-x, y, z])sphere(homeRadius);
  }

  if(homeBar == true) {
    // @WIP
  }
}


// lp_key = [
// //     "base_sx", 18.5,
// //     "base_sy", 18.5,
//      "base_sx", 17.65,
//      "base_sy", 16.5,
//      "cavity_sx", 16.1,
//      "cavity_sy", 14.9,
//      "cavity_sz", 1.6,
//      "cavity_ch_xy", 1.6,
//      "indent_inset", 1.5
//      ];

/*Tester */
//translate([0,0,0])lp_master_base(xu = 2, yu = 1 );
// lp_production_base();
//      for(i = [0:2]){
//        for(j = [0:1]){
//          translate([(1-i)*21, (.5-j)*21,0]){
//            translate([0, 0, -.05])rotate([0,0,0])mirror([0,j,0])keycap(keyID = 2, cutLen = 0, Stem =false,  Dish = true, SecondaryDish = false ,Stab = 0 , visualizeDish = false, crossSection = false, homeDot = false, Legends = false);
//          }
//        }
//      }
//
//   lp_production_base15();
//      for(i = [0:1]){
//        for(j = [0:1]){
//            translate([(.75-i*1.5)*21, (.5-j)*21,0]){
//            translate([0, 0, -.05])rotate([0,0,90])mirror([j,0,0])keycap(keyID = 3, cutLen = 0, Stem =false,  Dish = true, SecondaryDish = false ,Stab = 0 , visualizeDish = false, crossSection = false, homeDot = false, Legends = false);
//          }
//        }
//      }

//translate([-19, 3.5, -.05])rotate([0,0,10])mirror([0,0,0])keycap(keyID = 3, cutLen = 0, Stem =false,  Dish = true, SecondaryDish = false ,Stab = 0 , visualizeDish = false, crossSection = false, homeDot = false, Legends = false);
//translate([0, -17, 0])rotate([0,0,0])mirror([0,0,0])keycap(keyID = 0, cutLen = 0, Stem =false,  Dish = true, SecondaryDish = false ,Stab = 0 , visualizeDish = false, crossSection = false, homeDot = false, Legends = false);

//translate([0, 34, 0])rotate([0,0,0])mirror([0,1,0])keycap(keyID = 7, cutLen = 0, Stem =true,  Dish = true, SecondaryDish = false ,Stab = 0 , visualizeDish = false, crossSection = false, homeDot = false, Legends = false);
//translate([0, -17, 0])rotate([0,0,0])mirror([0,0,0])keycap(keyID = 0, cutLen = 0, Stem =true,  Dish = true, SecondaryDish = false ,Stab = 0 , visualizeDish = false, crossSection = false, homeDot = false, Legends = false);


//translate([-3, 0, 0])rotate([0,0,0])mirror([0,0,0])keycap(keyID = 2, cutLen = 7, Stem =true,  Dish = true, SecondaryDish = false ,Stab = 0 , visualizeDish = false, crossSection = false, homeDot = false, Legends = false);
//translate([3, 0, 0])rotate([0,0,0])mirror([0,0,0])keycap(keyID =  3, cutLen = -7, Stem =true,  Dish = true, SecondaryDish = false ,Stab = 0 , visualizeDish = false, crossSection = false, homeDot = false, Legends = false);
//translate([0, 18, 0])rotate([0,0,0])mirror([0,0,0])keycap(keyID =  4, cutLen = 0, Stem =true,  Dish = true, SecondaryDish = false ,Stab = 0 , visualizeDish = false, crossSection = false, homeDot = false, Legends = false);

//  translate([0,-17.5, 0])rotate([0,0,0])mirror([0,1,0])keycap(keyID = 1, cutLen = -ChocCut, Stem =true,  Dish = true, SecondaryDish = true ,Stab = 0 , visualizeDish = false, crossSection = false, homeDot = false, Legends = false);
//
//  translate([18,-17.5, 0])rotate([0,0,180])mirror([0,0,0])keycap(keyID = 1, cutLen = -ChocCut, Stem =true,  Dish = true, SecondaryDish = true ,Stab = 0 , visualizeDish = false, crossSection = false, homeDot = false, Legends = false);
//  translate([18, 0, 0])rotate([0,0,180])mirror([0,1,0])keycap(keyID = 1, cutLen = -ChocCut, Stem =true,  Dish = true, SecondaryDish = true ,Stab = 0 , visualizeDish = false, crossSection = false, homeDot = true, Legends = false);
//

//#translate([0,17,0])cube([14.5, 13.5, 4], center = true); // internal check
//#translate([0,0,5])cube([19.05, 19.05, 10], center = true); // internal check
//#translate([0,0,0])cube([17.5, 16.5, 10], center = true); // internal check
