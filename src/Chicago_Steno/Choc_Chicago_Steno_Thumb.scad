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

// Choc Chord version Chicago Stenographer with sculpte Thumb cluster

mirror([1,0,0])keycap(
  keyID   = 1, //change profile refer to KeyParameters Struct
  cutLen  = 0, //Don't change. for chopped caps
  stem    = true, //tusn on shell and stems
  stemRot = stemRot,//change stem orientation by deg
  homeDot = false, //turn on homedots
  dish    = true, //turn on dish cut
  secondaryDish = true, //turn on dish cut
  visualizeDish = false, // turn on debug visual of Dish
  crossSection  = false, // center cut to check internal
  legends = false,
  stab    = 0
);

// ----- Parameters
wallthickness = 1.1; // 1.75 for mx size, 1.1
topthickness = 3.0;  // 2 for phat 3 for chicago
stepsize = 60;       // resolution of Trajectory
step = 0.5;          // resolution of ellipes
fn = 60;             // resolution of Rounded Rectangles: 60 for output
layers = 50;         // resolution of vertical Sweep: 50 for output
dotRadius = 0.55;

// ----- Stem Parameters
slop    = 0.3;
stemRot = 0;
stemWid = 8;
stemLen = 6;
stemCrossHeight = 1.8;
extra_vertical = 0.6;
stemBrimDep     = 0;
stemLayers = 50; //resolution of stem to cap top transition
stemDriftAngle = 0; //degrees
//#cube([18.16, 18.16, 10], center = true); // sanity check border

//TODO: Add wall thickness transition?

keyParameters = //keyParameters[KeyID][ParameterID]
[
//  BotWid, BotLen, TWDif, TLDif, keyh, WSft, LSft  XSkew, YSkew, ZSkew, WEx, LEx, CapR0i, CapR0f, CapR1i, CapR1f, CapREx, StemEx
    //Column 0
    //Levee: Chicago in choc Dimension for ref
    [17.20,  16.00,   5.6, 	   5,  5.0,    0,   .0,     5,    -0,    -0,   2, 2.5,    .10,      2,     .10,      3,     2,       2], //Levee Steno R2/R4
    [17.20,  16.00,   5.6, 	   5,  4.6,    0,   .0,     0,    -0,    -0,   2, 2.5,    .10,      3,     .10,      3,     2,       2], //Levee Steno R3
    //Thumb
    [17.20,  16.00,  4.25, 	3.25,  5.0,  -.5,  0.0,    -3,    -3,    -0,   2,   2,    .10,      2,     .10,      2,     2,       2], //Thumb 1
    [15.65,  26.4,   5.5, 	3.25,  4.9,  -.5,  0.0,    -3,    -2,    -2,   2,   2,     .3,      2,      .3,    2.5,     2,       2], //Thumb 1.5
    [15.65,  35.8,  4.25, 	3.25,  4.9, -.25,  0.0,    -2.5,    -4,    -2,   2,   3,     .3,      2,      .3,    2.5,     2,       2], //Thumb 2.0
    //1.25 5
    [21.3,   15.60,  5.6, 	   5,  4.5,    0,   .0,     5,    -0,    -0,   2,   2,     .5,      3,      .5,      3,     2,       2], //Chicago Steno R2/R4 1.25u
    [21.4,   15.60,  5.6, 	   5,  4.5,    0,   .0,     0,    -0,    -0,   2,   2,     .5,      3,      .5,      3,     2,       2], //Chicago Steno R3 1.25u
    //1.5 7
    [26.15,  15.60,   5.6, 	   5,  4.5,    0,   .0,     5,    -0,    -0,   2,   2,     .5,      3,      .5,      3,     2,       2], //Chicago Steno R2/R4 1.5
    [26.15,  15.60,   5.6, 	   5,  4.5,    0,   .0,     0,    -0,    -0,   2,   2,     .5,      3,      .5,      3,     2,       2], //Chicago Steno R3 1.5u
    //1.75 9
    [30.90,  15.60,   5.6, 	   5,  4.5,    0,   .0,     5,    -0,    -0,   2,   2,     .5,      3,      .5,      3,     2,       2], //Chicago Steno R2/R4 1.5
    [30.90,  15.60,   5.6, 	   5,  4.5,    0,   .0,     0,    -0,    -0,   2,   2,     .5,      3,      .5,      3,     2,       2], //Chicago Steno R3 1.5u
    // Ergo shits
    [18.75,  18.75,   5.6, 	   5,    8,    0,   .25,     0,    -0,    -0,   2, 2.5,    .10,      3,     .10,      3,     2,       2], //highpro 19.05 R2|4
    [17.20,  16.00,   5.6, 	   5,  4.7,    0,   .0,      3,    -0,    -0,   2, 2.5,    .10,      2,     .10,      3,     2,       2], //Chicago Steno R2 ALT
    [17.20,  16.00,   5.6, 	   5,  5.5,    0,   .0,      7,    -0,    -0,   2, 2.5,    .10,      2,     .10,      3,     2,       2], //Chicago Steno R1 Steap
    [17.20,  16.00,   5.6, 	   5,  7.0,    0,   .0,     10,    -0,    -0,   2, 2.5,    .10,      2,     .10,      3,     2,       2], //Chicago Steno R1 mild with alt R2

];

dishParameters = //dishParameter[keyID][ParameterID]
[
//FFwd1 FFwd2 FPit1 FPit2  DshDep DshHDif FArcIn FArcFn FArcEx     BFwd1 BFwd2 BPit1 BPit2  BArcIn BArcFn BArcEx FTani FTanf BTani BTanf TanEX PhiInit PhiFin
  //Column 0
  [ 4.5,    4,    7,  -50,      7,    1.7,   11,    17,     2,      4.5,    4,    2,   -35,   11,    15,     2,     3,  4.5,    3,  4.5,   2, 203, 210], //Chicago Steno R2/R4
  [ 4.5,    4,    5,  -40,      7,    1.7,   11,    15,     2,      4.5,    4,    5,   -40,   11,    15,     2,     4,    5,    4,    5,   2, 200, 210], //Chicago Steno R3 flat

  [   5,  5.5,    0,  -40,      7,    1.7,   16,    18,     2,       5.5,  3.5,    5,   -50,   16,    18,     2,     5,   3.75,    2,    3.75,   2, 199, 210], //T1
  [  10,  4.5,    0,  -40,      7,    1.7,   16,    15,     2,        10,  3.5,    5,   -50,   16,    18,     2,     3,   3.75,    .75,    3.75,   2, 200, 210], //1.5u
  [  14.5, 4.5,   4,  -40,      7,    1.7,   16,    18,     2,      14.5,  4.5,    2,   -35,   16,    23,     2,     3,   3.75,    .75,    3.75,   2, 200, 210], //2.0u
  //1.25
  [ 4.5,    4,    7,  -40,      8,    1.8,   15,    20,     2,      4.5,    4,    2,   -35,   15,    20,     2,     3,    5,    7,    5,   2, 200, 210], //Chicago Steno R2/R4
  [ 4.5,    4,    5,  -40,      8,    1.8,   15,    20,     2,      4.5,    4,    5,   -40,   15,    20,     2,     3,    5,    7,    5,   2, 200, 210], //Chicago Steno R3
  //1.5
  [ 4.5,    4,    7,  -40,      8,    1.8,   19,    25,     2,      4.5,    4,    2,   -35,   19,    25,     2], //Chicago Steno R2/R4
  [ 4.5,    4,    5,  -40,      8,    1.8,   19,    25,     2,      4.5,    4,    5,   -40,   19,    25,     2], //Chicago Steno R3
  //1.75
  [ 4.5,    4,    7,  -40,      8,    1.8,   22.5,  27,     2,      4.5,    4,    2,   -35,   22.5,  27,     2], //Chicago Steno R2/R4
  [ 4.5,    4,    5,  -40,      8,    1.8,   22.5,  27,     2,      4.5,    4,    5,   -40,   22.5,  27,     2], //Chicago Steno R3


  [   5,    5,    5,  -40,      7,    1.7,   11,    15,     2,        5,    5,    5,   -40,   11,    15,     2], //Chicago Steno R3 flat
  [ 4.5,    4,    7,  -50,      7,    1.7,   11,    17,     2,      4.5,    4,    2,   -35,   11,    15,     2], //Chicago Steno R1
  [ 4.5,    4,    7,  -50,      7,    1.7,   11,    17,     2,      4.5,    4,    2,   -35,   11,    15,     2], //Chicago Steno R1
  [ 4.5,    4,    7,  -50,      7,    1.7,   11,    17,     2,      4.5,    4,    2,   -35,   11,    15,     2], //Chicago Steno R1

];

SecondaryDishParam =
[
  [   6,  3.5,    7,  -50,      3,    2,    8,     8,     2,          5,    5,    5,    15,   10,   20,     2], //Chicago Steno R2/R4
  [   6,  3.5,    7,  -50,      3,  2.5,    8,    20,     3,          2,  4.2,    8,     0,    8,    8,     3], //Chicago Steno R3 flat
  [   6,  3.5,    7,  -50,      3,  2.5,    8,    20,     3,          2,  4.2,    8,     0,    8,    8,     3], //Chicago Steno R3 chord

  [   6,  3.5,    7,  -50,      3,    2,    8,     8,     2,          5,    5,    5,    15,   10,    20,     2], //Levee Steno R2/R4
  [   6,  3.5,    7,  -50,      5,  1.0,   16,    23,     2,          6,  3.5,    7,   -50,   16,    23,     2], //Levee Steno R2/R4
  //1.25
  [   6,  3.5,    7,  -50,      3,    2,    8,     8,     2,          5,    5,    5,    15,   10,    20,     2], //Chicago Steno R2/R4
  [   6,  3.5,    7,  -50,      3,  2.5,    8,    20,     3,          2,  4.2,    8,     0,    8,     8,     3], //Chicago Steno R3 flat
  //1.50
  [   6,  3.5,    7,  -50,      3,    2,    8,     8,     2,          5,    5,    5,    15,   10,    20,     2], //Chicago Steno R2/R4
  [   6,  3.5,    7,  -50,      3,  2.5,    8,    20,     3,          2,  4.2,    8,     0,    8,     8,     3], //Chicago Steno R3 flat


  [   6,  3.5,    7,  -50,      3,    2,    8,     8,     2,          5,    5,    5,    15,   10,    20,     2], //Chicago Steno R1
  [   6,  3.5,    7,  -50,      3,    2,    8,     8,     2,          5,    5,    5,    15,   10,    20,     2], //Chicago Steno R1
  [   6,  3.5,    7,  -50,      3,    2,    8,     8,     2,          5,    5,    5,    15,   10,    20,     2], //Chicago Steno R1

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
function StemExponent(keyID) = keyParameters[keyID][17];

function FrontForward1(keyID) = dishParameters[keyID][0];  //
function FrontForward2(keyID) = dishParameters[keyID][1];  //
function FrontPitch1(keyID)   = dishParameters[keyID][2];  //
function FrontPitch2(keyID)   = dishParameters[keyID][3];  //
function DishDepth(keyID)     = dishParameters[keyID][4];  //
function DishHeightDif(keyID) = dishParameters[keyID][5];  //
function FrontInitArc(keyID)  = dishParameters[keyID][6];
function FrontFinArc(keyID)   = dishParameters[keyID][7];
function FrontArcExpo(keyID)  = dishParameters[keyID][8];
function BackForward1(keyID)  = dishParameters[keyID][9];  //
function BackForward2(keyID)  = dishParameters[keyID][10];  //
function BackPitch1(keyID)    = dishParameters[keyID][11];  //
function BackPitch2(keyID)    = dishParameters[keyID][12];  //
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

function SFrontForward1(keyID) = SecondaryDishParam[keyID][0];  //
function SFrontForward2(keyID) = SecondaryDishParam[keyID][1];  //
function SFrontPitch1(keyID)   = SecondaryDishParam[keyID][2];  //
function SFrontPitch2(keyID)   = SecondaryDishParam[keyID][3];  //
function SDishDepth(keyID)     = SecondaryDishParam[keyID][4];  //
function SDishHeightDif(keyID) = SecondaryDishParam[keyID][5];  //
function SFrontInitArc(keyID)  = SecondaryDishParam[keyID][6];
function SFrontFinArc(keyID)   = SecondaryDishParam[keyID][7];
function SFrontArcExpo(keyID)  = SecondaryDishParam[keyID][8];
function SBackForward1(keyID)  = SecondaryDishParam[keyID][9];  //
function SBackForward2(keyID)  = SecondaryDishParam[keyID][10];  //
function SBackPitch1(keyID)    = SecondaryDishParam[keyID][11];  //
function SBackPitch2(keyID)    = SecondaryDishParam[keyID][12];  //
function SBackInitArc(keyID)   = SecondaryDishParam[keyID][13];
function SBackFinArc(keyID)    = SecondaryDishParam[keyID][14];
function SBackArcExpo(keyID)   = SecondaryDishParam[keyID][15];


function FrontTrajectory(keyID) =
  [
    trajectory(forward = FrontForward1(keyID), pitch =  FrontPitch1(keyID)), //more param available: yaw, roll, scale
    trajectory(forward = FrontForward2(keyID), pitch =  FrontPitch2(keyID))  //You can add more traj if you wish
  ];

function BackTrajectory (keyID) =
  [
    trajectory(backward = BackForward1(keyID), pitch =  -BackPitch1(keyID)),
    trajectory(backward = BackForward2(keyID), pitch =  -BackPitch2(keyID)),
  ];

function SFrontTrajectory(keyID) =
  [
    trajectory(forward = SFrontForward1(keyID), pitch =  SFrontPitch1(keyID)), //more param available: yaw, roll, scale
    trajectory(forward = SFrontForward2(keyID), pitch =  SFrontPitch2(keyID)),  //You can add more traj if you wish
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
    ((1-t)/layers*TopWidShift(keyID)),   //X shift
    ((1-t)/layers*TopLenShift(keyID)),   //Y shift
    (t/layers*KeyHeight(keyID))    //Z shift
  ];

function InnerTranslation(t, keyID) =
  [
    ((1-t)/layers*TopWidShift(keyID)),   //X shift
    ((1-t)/layers*TopLenShift(keyID)),   //Y shift
    (t/layers*(KeyHeight(keyID)-topthickness))    //Z shift
  ];

function CapRotation(t, keyID) =
  [
    ((1-t)/layers*XAngleSkew(keyID)),   //X shift
    ((1-t)/layers*YAngleSkew(keyID)),   //Y shift
    ((1-t)/layers*ZAngleSkew(keyID))    //Z shift
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
    0,   //X shift
    0,   //Y shift
    stemCrossHeight+.1 + (t/stemLayers*(KeyHeight(keyID)- topthickness - stemCrossHeight-.1))    //Z shift
  ];

function StemRotation(t, keyID) =
  [
    ((1-t)/stemLayers*XAngleSkew(keyID)),   //X shift
    ((1-t)/stemLayers*YAngleSkew(keyID)),   //Y shift
    ((1-t)/stemLayers*ZAngleSkew(keyID))    //Z shift
  ];

function StemTransform(t, keyID) =
  [
    pow(t/stemLayers, StemExponent(keyID))*(BottomWidth(keyID) -TopLenDiff(keyID)-wallthickness*2) + (1-pow(t/stemLayers, StemExponent(keyID)))*(stemWid - 2*slop),
    pow(t/stemLayers, StemExponent(keyID))*(BottomLength(keyID)-TopLenDiff(keyID)-wallthickness*2) + (1-pow(t/stemLayers, StemExponent(keyID)))*(stemLen - 2*slop)
  ];

function StemRadius(t, keyID) = pow(t/stemLayers,3)*3 + (1-pow(t/stemLayers, 3))*1;

function FTanRadius(t, keyID) = pow(t/stepsize,TanArcExpo(keyID) )*ForwardTanInit(keyID) + (1-pow(t/stepsize, TanArcExpo(keyID) ))*ForwardTanFin(keyID);

function BTanRadius(t, keyID) = pow(t/stepsize,TanArcExpo(keyID) )*BackTanInit(keyID)  + (1-pow(t/stepsize, TanArcExpo(keyID) ))*BackTanFin(keyID);

function TanTransition(t, keyID) = pow(t/stepsize,TanArcExpo(keyID) )*TransitionAngleInit(keyID)  + (1-pow(t/stepsize, TanArcExpo(keyID) ))*TransitionAngleFin(keyID);


///----- KEY Builder Module
module keycap(
  keyID = 0,
  cutLen = 0,
  stem = true,
  stemRot = 0,
  homeDot = false,
  dish = true,
  secondaryDish = false,
  visualizeDish = false,
  crossSection = false,
  legends = false,
  stab = 0,
) {

  // Set Parameters for dish shape
  FrontPath = quantize_trajectories(FrontTrajectory(keyID), steps = stepsize, loop=false, start_position= $t*4);
  BackPath  = quantize_trajectories(BackTrajectory(keyID),  steps = stepsize, loop=false, start_position= $t*4);

  // Scaling initial and final dim tranformation by exponents
  function _FrontDishArc(t) =  pow((t)/(len(FrontPath)),FrontArcExpo(keyID))*FrontFinArc(keyID) + (1-pow(t/(len(FrontPath)),FrontArcExpo(keyID)))*FrontInitArc(keyID);
  function _BackDishArc(t)  =  pow((t)/(len(FrontPath)),BackArcExpo(keyID))*BackFinArc(keyID) + (1-pow(t/(len(FrontPath)),BackArcExpo(keyID)))*BackInitArc(keyID);

  FrontCurve = [ for(i=[0:len(FrontPath)-1]) transform(FrontPath[i], DishShapeConcave2( a= DishDepth(keyID), b= _FrontDishArc(i), phi = TransitionAngleInit(keyID) , theta= 60
    , r = FTanRadius(i, keyID), step=step)) ];
  BackCurve  = [ for(i=[0:len(BackPath)-1])  transform(BackPath[i],  DishShapeConcave2(DishDepth(keyID), _BackDishArc(i), phi = TransitionAngleInit(keyID), theta= 60
    , r = BTanRadius(i, keyID), step=step)) ];

  // Secondary Dish
  SFrontPath = quantize_trajectories(SFrontTrajectory(keyID), steps = stepsize, loop=false, start_position= $t*4);
  SBackPath  = quantize_trajectories(SBackTrajectory(keyID),  steps = stepsize, loop=false, start_position= $t*4);

  // Scaling initial and final dim tranformation by exponents
  function _SFrontDishArc(t) =  pow((t)/(len(SFrontPath)),SFrontArcExpo(keyID))*SFrontFinArc(keyID) + (1-pow(t/(len(SFrontPath)),SFrontArcExpo(keyID)))*SFrontInitArc(keyID);
  function _SBackDishArc(t)  =  pow((t)/(len(SBackPath)),SBackArcExpo(keyID))*SBackFinArc(keyID) + (1-pow(t/(len(SFrontPath)),SBackArcExpo(keyID)))*SBackInitArc(keyID);

  SFrontCurve = [ for(i=[0:len(SFrontPath)-1]) transform(SFrontPath[i], DishShapeConcave(SDishDepth(keyID), _SFrontDishArc(i), 1, d = 0, step=step)) ];
  SBackCurve  = [ for(i=[0:len(SBackPath)-1])  transform(SBackPath[i],  DishShapeConcave(SDishDepth(keyID),  _SBackDishArc(i), 1, d = 0, step=step)) ];

  // Builds
  difference(){
    union(){
      difference(){
        // Create outer shell
        skin([for (i=[0:layers-1]) transform(translation(CapTranslation(i, keyID)) * rotation(CapRotation(i, keyID)), elliptical_rectangle_profile(CapTransform(i, keyID), b = CapRoundness(i,keyID), fn=fn))]);

        // Cut inner shell
        if(stem == true){
          translate([0,0,-.001])skin([for (i=[0:layers-1]) transform(translation(InnerTranslation(i, keyID)) * rotation(CapRotation(i, keyID)), elliptical_rectangle_profile(InnerTransform(i, keyID), b = CapRoundness(i,keyID), fn=fn))]);
        }

        // Make sure XY plane is flat
        translate([-50,-50,-10]) cube([100,100,10], center=false);
      }

      if(stem == true){
        translate([0,0,stemBrimDep]) rotate([0,0,stemRot]) Choc_Stem(driftAngle = stemDriftAngle);
        // if (stab != 0){
        //   translate([stab/2,0,0])rotate([0,0,stemRot])cherry_stem(KeyHeight(keyID), slop);
        //   translate([-stab/2,0,0])rotate([0,0,stemRot])cherry_stem(KeyHeight(keyID), slop);
        // }

        // Transition Support for taller profile (from inner top cap to stem base)
        rotate([0,0,stemRot]) translate([0,0,-.001]) skin([for (i=[0:stemLayers-1]) transform(translation(StemTranslation(i, keyID)) * rotation(StemRotation(i, keyID)), rounded_rectangle_profile(StemTransform(i, keyID), r=StemRadius(i, keyID), fn=fn))]);
      }
    }

    // Cuts

    // Fonts
    if(cutLen != 0){
      translate([sign(cutLen)*(BottomLength(keyID)+CapRound0i(keyID)+abs(cutLen))/2,0,0])
        cube([BottomWidth(keyID)+CapRound1i(keyID)+1,BottomLength(keyID)+CapRound0i(keyID),50], center = true);
    }

    // Legends
    if(legends ==  true){
      #rotate([-XAngleSkew(keyID),YAngleSkew(keyID),ZAngleSkew(keyID)])translate([-1,-5,KeyHeight(keyID)-2.5])linear_extrude(height = 1)text( text = "ver2", font = "Constantia:style=Bold", size = 3, valign = "center", halign = "center" );
      //  #rotate([-XAngleSkew(keyID),YAngleSkew(keyID),ZAngleSkew(keyID)])translate([0,-3.5,0])linear_extrude(height = 0.5)text( text = "Me", font = "Constantia:style=Bold", size = 3, valign = "center", halign = "center" );
    }

    // Dish (primary)
    if(dish == true){
      if(visualizeDish == true){
        #translate([-TopWidShift(keyID),.0001-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(FrontCurve);
        #translate([-TopWidShift(keyID),-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(BackCurve);
      }
      else {
        translate([-TopWidShift(keyID),.0001-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(FrontCurve);
        translate([-TopWidShift(keyID),-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(BackCurve);
      }

      // Dish (secondary)
      if(secondaryDish == true){
        if(visualizeDish == true){
          #mirror([1,0,0])translate([BottomWidth(keyID)/2,-BottomLength(keyID)/2,KeyHeight(keyID)-SDishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90-XAngleSkew(keyID),270-ZAngleSkew(keyID)])skin(SBackCurve);
        }
        else {
          mirror([1,0,0])translate([BottomWidth(keyID)/2,-BottomLength(keyID)/2,KeyHeight(keyID)-SDishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90-XAngleSkew(keyID),270-ZAngleSkew(keyID)])skin(SBackCurve);
          // translate([BottomWidth(keyID)/2,-BottomLength(keyID)/2,KeyHeight(keyID)-SDishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(SFrontCurve);
          // rotate([0,0,180])translate([BottomWidth(keyID)/2,-BottomLength(keyID)/2,KeyHeight(keyID)-SDishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90-XAngleSkew(keyID),270-ZAngleSkew(keyID)])skin(SBackCurve);
          // rotate([0,0,180])translate([BottomWidth(keyID)/2,-BottomLength(keyID)/2,KeyHeight(keyID)-SDishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(SFrontCurve);
        }
      }
    }

    // Debug internals
    if(crossSection == true) {
      translate([0,-25,-.1])cube([15,50,15]);
    }
  }

  // Homing
  if(homeDot == true)
  {
    translate([0,0,KeyHeight(keyID)-DishHeightDif(keyID)-.25])sphere(r = dotRadius);
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
