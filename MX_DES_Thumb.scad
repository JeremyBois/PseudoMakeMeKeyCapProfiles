use <scad-utils/morphology.scad> //for cheaper minwoski
use <scad-utils/transformations.scad>
use <scad-utils/shapes.scad>
use <scad-utils/trajectory.scad>
use <scad-utils/trajectory_path.scad>

use <list-comprehension/sweep.scad>
use <list-comprehension/skin.scad>

use <utils/shape.scad>
use <utils/stem.scad>

/*DES (Distorted Elliptical Saddle) Sculpted Profile for 6x3 and corne thumb
Version 2: Eliptical Rectangle
*/


mirror([0,0,0])keycap(
  keyID  = 1, //change profile refer to KeyParameters Struct
  cutLen = 0, //Don't change. for chopped caps
  stem   = true, //tusn on shell and stems
  dish   = true, //turn on dish cut
  homeDot = false, //turn on homedots
  homeRing = false, //turn on home ring
  legends = false,
  crossSection  = false, // center cut to check internal
  visualizeDish = false // turn on debug visual of Dish
 );

/*corne thumb hi pro*/
//color("royalblue")translate([-0,33,0]){
//  translate([-15, -4, 0])rotate([0,0,30])mirror([1,0,0])keycap(keyID = 0, cutLen = 0, Stem =false,  Dish = true, visualizeDish = false, crossSection = false);
//  translate([6, 0, 0])rotate([0,0,15])keycap(keyID = 1, cutLen = 0, Stem =false,  Dish = true, visualizeDish = false, crossSection = false);
//  translate([26, 2.2, 0])rotate([0,0,0])keycap(keyID = 2, cutLen = 0, Stem =false,  Dish = true, visualizeDish = false, crossSection = false);
//}
/*corne thumb low pro*/
//color("gray"){
//  translate([-15, -4, 0])rotate([0,0,30])keycap(keyID =3, cutLen = 0, Stem =true,  Dish = true, visualizeDish = false, crossSection = false);
//  translate([6, 0, 0])rotate([0,0,15])keycap(keyID = 6, cutLen = 0, Stem =true,  Dish = true, visualizeDish = false, crossSection = false);
//  translate([26, 2.2, 0])rotate([0,0,0])keycap(keyID = 7, cutLen = 0, Stem =true,  Dish = true, visualizeDish = false, crossSection = false);
//}

/*kyria Thumb*/
//// translate([-39, 0, 0])rotate([0,0,30])translate([0,-19.5, 0])keycap(keyID = 15 , cutLen = 0, Stem =false,  Dish = true, visualizeDish = false, crossSection = false);
// translate([-39, 0, 0])rotate([0,0,30])translate([0,-19.5, 0])keycap(keyID = 13, cutLen = 0, Stem =false,  Dish = true, visualizeDish = false, crossSection = false);
// translate([-39, 0, 0])rotate([0,0,30])translate([0,0, 0])keycap(keyID = 14, cutLen = 0, Stem =false,  Dish = true, visualizeDish = false, crossSection = false);
//// translate([-39, 0, 0])rotate([0,0,30])translate([0, -1, 0])keycap(keyID = 13, cutLen = 0, Stem =false,  Dish = true, visualizeDish = false, crossSection = false);
// //  translate([-17, 0, 0])rotate([0,0,30])translate([0, 1 , 0])keycap(keyID = 12, cutLen = 0, Stem =false,  Dish = true, visualizeDish = false, crossSection = false);
// translate([-17, 0, 0])rotate([0,0,30])translate([0,-8.5, 0])mirror([1,0,0])keycap(keyID = 16, cutLen = 0, Stem =false,  Dish = true, visualizeDish = false, crossSection = false);
// translate([-17, 0, 0])rotate([0,0,30])translate([0, 10, 0])mirror([1,0,0])keycap(keyID = 17, cutLen = 0, Stem =false,  Dish = true, visualizeDish = false, crossSection = false);
// translate([6, 0, 0])rotate([0,0,15])keycap(keyID = 18, cutLen = 0, Stem =false,  Dish = true, visualizeDish = false, crossSection = false);
// translate([26, 2.2, 0])rotate([0,0,0])keycap(keyID = 19, cutLen = 0, Stem =false,  Dish = true, visualizeDish = false, crossSection = false);


//#translate([0,38,13])cube([18-5.7, 18-5.7,1],center = true);
//echo(len(keyParameters));

// ----- Parameters
//  The lower the lower the keycap (required for both Choc V2 and Gateron KS33)
heightShift = -2.5;  // Pseudoku (0) | Zzeneg (-3 in minY-minZ)
wallthickness = 1.6; // 1.5 for norm, 1.25 for cast master
topthickness = 3.4;  // 3 for norm, 2.5 for cast master
stepsize = 50;       // resolution of Trajectory
step = 0.5;          // resolution of ellipes
fn = 60;             // resolution of Rounded Rectangles: 60 for output
layers = 50;         // resolution of vertical Sweep: 50 for output
dotRadius = 0.55;    // home dot size

// ----- Stem Parameters
stemTol = 0;
stemRot = 0;
stemWid = 7.2;
stemLen = 5.5;
stemCrossHeight = 4;
extra_vertical  = 0.6;
stemBrimDep     = -1;
stemLayers      = 50; // resolution of stem to cap top transition

keyParameters = // keyParameters[KeyID][ParameterID]
[
//  BotWid, BotLen, TWDif, TLDif, keyh, WSft, LSft  XSkew, YSkew, ZSkew, WEx, LEx, CapR0i, CapR0f, CapR1i, CapR1f, CapREx, StemEx
//corne thumb high pro 0~2
    [17.16,  26.66,     6, 	   7,   12,    0,    0,   -0,    10,    -5,   2,   2,      1,   4.85,      1,      3,     2,       2], //R5 1.5 Corne thumb
    [17.16,  17.16,     4, 	   5,   11,    0,    0,   -0,     5,     0,   2,   2,      1,      5,      1,      3,     2,       2], //R5  corne thumb
    [17.16,  17.16,     4, 	   6,   13,    0,    0,   -0,    10,    15,   2,   2,      1,      5,      1,      2,     2,       2], //R5  corne thumb
//Low profile corne thumb 3 3~7
    [17.16,  26.66,     6, 	   7, 9.0,    0,    0,    -8,    10,    -5,   2,   2,      1,   4.85,      1,      3,     2,       2], //T1R5  external rot 3
    [17.16,  26.66,     6, 	   7, 9.0,    0,    0,    -8,    10,    -0,   2,   2,      1,   4.85,      1,      3,     2,       2], //T1R5  nuetral
    [17.16,  26.66,     6, 	   7, 9.0,    0,    0,    -8,    10,     5,   2,   2,      1,   4.85,      1,      3,     2,       2], //T1R5  internal rot Corne thumb
    [17.16,  17.16,     4, 	   5, 10.,    0,    0,   -12,     5,     0,   2,   2,      1,      5,      1,      3,     2,       2], //R5  corne thumb
    [17.16,  17.16,     4, 	   6,  11,    0,    0,   -12,    10,    15,   2,   2,      1,      5,      1,      2,     2,       2], //R5  corne thumb
//Column high sculpt 3 row system 8~11
    [17.16,  17.16,   6.5, 	 6.5,10.55,    0,    0,     9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R4 8
    [17.16,  17.16,   6.5, 	 6.5, 8.75,    0,   .5,     4,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R3 Home
    [17.16,  17.16,   6.5, 	 6.5, 9.75,    0,    0,   -13,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R2
    [17.16,  17.16,   6.5, 	 6.5, 8.75,    0,    0,     4,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R3 deepdish
 //kyria Thumbs   12 ~ 18
    [17.16,  35.56,     4, 	   7, 13.5,    0,    0,    -8,     5,     0,   2,   2,      1,     6.,      1,    3.5,     2,       2], //T0R1 2u
    [17.16,  17.16,     6, 	   5,   11,  -.5,    0,    -9,     7,    10,   2,   2,      1,      5,      1,      3,     2,       2], //T0R1 1u
    [17.16,  17.16,     6, 	   5,   13,  -.5,    0,    -9,     7,     5,   2,   2,      1,      5,      1,    3.5,     2,       2], //T0R2 1u
    [17.16,  35.56,     6, 	   7,   11,    0,    0,    -8,    10,    -5,   2,   2,      1,   4.85,      1,    3.5,     2,       2], //T1R1 2u
    [17.16,  17.16,     4, 	   6,   12,   .5,    0,   -13,    -7,    10,   2,   2,      1,      5,      1,      2,     2,       2], //T1R1 1u
    [17.16,  17.16,     6, 	   5,   15,  -.5,    0,    -9,    -7,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //T1R2 1u
    [17.16,  17.16,     4, 	   6,   13,   .5,    0,   -13,    10,    15,   2,   2,      1,      5,      1,      2,     2,       2], //T2R1
    [17.16,  17.16,     4, 	   6,   13,    0,    0,    -8,    10,    20,   2,   2,      1,      5,      1,      2,     2,       2], //T3R1

//lowest profile 20-23
    [17.16,  17.16,   6.5, 	 6.5, 7.25,    0,    0,     3,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R4 6
    [17.16,  17.16,   6.5, 	 6.5,    7,    0,   .5,  .001,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R3 Home
    [17.16,  17.16,   6.5, 	 6.5, 7.25,    0, -.25,    -5,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R2
    [17.16,  17.16,   6.5, 	 6.5,    7,    0,   .5,  .001,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R3 deepdish
];

dishParameters = //dishParameter[keyID][ParameterID]
[
//FFwd1 FFwd2 FPit1 FPit2  DshDep DshHDif FArcIn FArcFn FArcEx     BFwd1 BFwd2 BPit1 BPit2  BArcIn BArcFn BArcEx
  //higt corne thumb
  [   8,   5,    -1,  -39,      4,    1.8,   9.5,    15,     2,       10,    4,    8,  -30,    9.5,    20,     2], //R5
  [   5,  4.3,   -2,  -48,      5,      2,  10.5,    10,     2,        6,    4,   13,  -30,   10.5,    18,     2], //R5
  [   5,  4.3,   -2,  -48,      4,    1.9,    11,    12,     2,        6,    4,   13,  -35,     11,    28,     2], //R5

  [ 8.5,  5.0,    7,  -39,      4,    1.9,   9.5,    15,     2,       10,    4,    8,  -30,    9.5,    20,     2], //R5
  [ 8.3,  5.0,    7,  -39,      4,    1.9,   9.5,    15,     2,       10,    4,    8,  -30,    9.5,    20,     2], //R5
  [ 8.5,  5.0,    7,  -39,      4,    1.9,   9.5,    15,     2,       10,    4,    8,  -30,    9.5,    20,     2], //R5
  [   5,  4.8,    5,  -48,      5,    2.2,  10.5,    10,     2,        6,    4,   13,  -30,   10.5,    18,     2], //R5
  [   5,  4.8,    5,  -48,      4,    2.0,    11,    12,     2,        6,    4,   13,  -35,     11,    28,     2], //R5

  // low pro 3 row system
  [   6,    3,   18,  -50,      5,    1.8,   8.8,    15,     2,        5,  4.4,    5,  -55,    8.8,    15,     2], //R4
  [   5,  3.5,   10,  -55,      5,    1.8,   8.5,    15,     2,        5,  3.7,   10,  -55,    8.5,    15,     2], //R3
  [   6,    3,   10,  -50,      5,    1.8,   8.8,    15,     2,        6,    4,   13,   30,    8.8,    16,     2], //R2
  [ 4.8,  3.3,   18,  -55,      5,    2.0,   8.5,    15,     2,      4.8,  3.3,   18,  -55,    8.5,    15,     2], //R3 deep
  //kyria
  [  13,  5.5,    5,  -40,      4,    1.8,  10.5,    30,     2,       12,    8,   5,    -5,    10.5,     40,     2], //T1R1 2u
  [   5,  4.4,    5,  -48,      5,      2,  10.5,    10,     2,        6,    4,    2,  -30,   10.5,    18,     2], //T0R1 1u
  [   5,  4.3,    5,  -48,      5,      2,  10.5,    10,     2,        6,    4,    2,  -30,   10.5,    18,     2], //T0R2 1u
  [  13,  4.5,    7,  -39,      4,    1.8,  10.5,    15,     2,       13,    4,    8,  -30,   10.5,    20,     2], //T1R1 2u
  [   5,  4.4,    5,  -48,      4,    1.9,    11,    12,     2,      5.5,  3.5,    8,  -50,     11,    28,     2], //T1R1 1u
  [   5,  4.3,    5,  -48,      5,      2,  10.5,    10,     2,        6,    4,    2,  -30,   10.5,    18,     2], //T1R2 1u
  [   5,  4.4,    5,  -48,      4,    1.9,    11,    12,     2,        6,    4,   13,  -35,     11,    28,     2], //T2R1
  [   5,  4.4,    5,  -48,      4,    1.9,    11,    12,     2,        6,    4,   13,  -35,     11,    28,     2], //T3R1
  // low pro mil sculpt 3 row system
  [   6,    3,   18,  -50,      5,    1.8,   8.8,    15,     2,        5,  4.4,    5,  -55,    8.8,    15,     2], //R4
  [   5,  3.8,    8,  -55,      5,    1.8,   8.5,    15,     2,        5,  4.2,    8,  -55,    8.5,    15,     2], //R3
  [   6,    3,   10,  -50,      5,    1.8,   8.8,    15,     2,        6,    4,   13,   30,    8.8,    16,     2], //R2
  [5.25,  3.,   16,  -55,      5,    1.8,   8.5,    15,     2,       5.25,  3.1,   16,  -55,    8.5,    15,     2], //R3 deep
];

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

function BottomWidth(keyID)  = keyParameters[keyID][0];  //
function BottomLength(keyID) = keyParameters[keyID][1];  //
function TopWidthDiff(keyID) = keyParameters[keyID][2];  //
function TopLenDiff(keyID)   = keyParameters[keyID][3];  //
function KeyHeight(keyID)    = keyParameters[keyID][4] + heightShift;  //
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

function FrontTrajectory(keyID) =
  [
    trajectory(forward = FrontForward1(keyID), pitch =  FrontPitch1(keyID), roll  = 0), //more param available: yaw, roll, scale
    trajectory(forward = FrontForward2(keyID), pitch =  FrontPitch2(keyID))  //You can add more traj if you wish
  ];

function BackTrajectory (keyID) =
  [
    trajectory(forward = BackForward1(keyID), pitch =  BackPitch1(keyID), roll  = -0, yaw = 0),
    trajectory(forward = BackForward2(keyID), pitch =  BackPitch2(keyID)),
  ];

//--------------Function definng Cap
function CapTranslation(t, keyID) =
  [
    ((1-t)/layers*TopWidShift(keyID)),   //X shift
    ((1-t)/layers*TopLenShift(keyID)),   //Y shift
    (t/layers*KeyHeight(keyID))    //Z shift
  ];

function InnerTranslation(t, keyID) =
  [
    // MX
    // ((1-t)/layers*TopWidShift(keyID)),   //X shift
    // ((1-t)/layers*TopLenShift(keyID)),   //Y shift
    // (t/layers*(KeyHeight(keyID)-topthickness))    //Z shift
    // MX and KS33
    0,   //X shift
    ((1-t)/layers*-0.25),   //Y shift
    (t/layers*(KeyHeight(keyID)-topthickness))    //Z shift
  ];

function CapRotation(t, keyID, isInner=false) =
  [
    ((1-t)/layers*XAngleSkew(keyID)),   //X shift
    ((1-t)/layers*YAngleSkew(keyID)),   //Y shift
    ((1-t)/layers*(isInner ? 0 : ZAngleSkew(keyID)))    //Z shift (MX and KS33)
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
    pow(t/layers, WidExponent(keyID))*(BottomWidth(keyID) -TopLenDiff(keyID)+wallthickness) + (1-pow(t/layers, WidExponent(keyID)))*(BottomWidth(keyID) -wallthickness*2),
    pow(t/layers, LenExponent(keyID))*(BottomLength(keyID)-TopLenDiff(keyID)+wallthickness) + (1-pow(t/layers, LenExponent(keyID)))*(BottomLength(keyID)-wallthickness*2)
  ];

function StemTranslation(t, keyID) =
  [
    ((1-t)/stemLayers*TopWidShift(keyID)),   //X shift
    ((1-t)/stemLayers*TopLenShift(keyID)),   //Y shift
    stemCrossHeight+.1+stemBrimDep + (t/stemLayers*(KeyHeight(keyID)- topthickness - stemCrossHeight-.1 -stemBrimDep))    //Z shift
  ];

function StemRotation(t, keyID) =
  [
    ((1-t)/stemLayers*XAngleSkew(keyID)),   //X shift
    ((1-t)/stemLayers*YAngleSkew(keyID)),   //Y shift
    ((1-t)/stemLayers*ZAngleSkew(keyID))    //Z shift
  ];

function StemTransform(t, keyID) =
  [
    pow(t/stemLayers, StemExponent(keyID))*(BottomWidth(keyID) -TopLenDiff(keyID)-wallthickness) + (1-pow(t/stemLayers, StemExponent(keyID)))*(stemWid - 2*slop),
    pow(t/stemLayers, StemExponent(keyID))*(BottomLength(keyID)-TopLenDiff(keyID)-wallthickness) + (1-pow(t/stemLayers, StemExponent(keyID)))*(stemLen - 2*slop)
  ];

function StemRadius(t, keyID) = pow(t/stemLayers,3)*3 + (1-pow(t/stemLayers, 3))*1;


///----- KEY Builder Module
module keycap(
  keyID = 0,
  cutLen = 0,
  dish = true,
  stem = true,
  homeDot = false,
  homeRing = false,
  legends = false,
  crossSection = false,
  visualizeDish = false
) {
  $fn = fn;

  //Set Parameters for dish shape
  FrontPath = quantize_trajectories(FrontTrajectory(keyID), steps = stepsize, loop=false, start_position= $t*4);
  BackPath  = quantize_trajectories(BackTrajectory(keyID),  steps = stepsize, loop=false, start_position= $t*4);

  //Scaling initial and final dim transformation by exponents
  function FrontDishArc(t) =  pow((t)/(len(FrontPath)),FrontArcExpo(keyID))*FrontFinArc(keyID) + (1-pow(t/(len(FrontPath)),FrontArcExpo(keyID)))*FrontInitArc(keyID);
  function BackDishArc(t)  =  pow((t)/(len(FrontPath)),BackArcExpo(keyID))*BackFinArc(keyID) + (1-pow(t/(len(FrontPath)),BackArcExpo(keyID)))*BackInitArc(keyID);

  FrontCurve = [ for(i=[0:len(FrontPath)-1]) transform(FrontPath[i], DishShapeConcave(DishDepth(keyID), FrontDishArc(i), 1, d = 0, step=step)) ];
  BackCurve  = [ for(i=[0:len(BackPath)-1])  transform(BackPath[i],  DishShapeConcave(DishDepth(keyID),  BackDishArc(i), 1, d = 0, step=step)) ];

  // Builds
  difference(){
    union(){
      difference(){
        // Create outer shell
        skin([for (i=[0:layers-1]) transform(translation(CapTranslation(i, keyID)) * rotation(CapRotation(i, keyID)), elliptical_rectangle_profile(CapTransform(i, keyID), b = CapRoundness(i,keyID),fn=fn))]); //outer shell

        // Substract inner shell
        if(stem == true){
          translate([0,0,-.001])skin([for (i=[0:layers-1]) transform(translation(InnerTranslation(i, keyID)) * rotation(CapRotation(i, keyID, true)), elliptical_rectangle_profile(InnerTransform(i, keyID),fn=fn))]);
        }

        // Make sure XY plane is flat
        translate([-50,-50,-10]) cube([100,100,10], center=false);
      }

      if (stem == true){
        MX_Cylinderical_Stem(KeyHeight(keyID), stemBrimDep, stemRot, tolerance=stemTol, $fn= 32);
      }
    }

    // Cuts

    // Fonts
    if(legends ==  true){
      #rotate([-XAngleSkew(keyID),YAngleSkew(keyID),ZAngleSkew(keyID)])translate([-1,-5,KeyHeight(keyID)-2.5])linear_extrude(height = 1)text( text = "ver2", font = "Constantia:style=Bold", size = 3, valign = "center", halign = "center" );
      // #rotate([-XAngleSkew(keyID),YAngleSkew(keyID),ZAngleSkew(keyID)])translate([0,-3.5,0])linear_extrude(height = 0.5)text( text = "Me", font = "Constantia:style=Bold", size = 3, valign = "center", halign = "center" );
      }

    // Dish Shape
    if(dish == true){
      if(visualizeDish == true) {
        #translate([-TopWidShift(keyID),.00001-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)]) rotate([0,-YAngleSkew(keyID),0])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(FrontCurve);
        #translate([-TopWidShift(keyID),-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90-XAngleSkew(keyID),270-ZAngleSkew(keyID)])skin(BackCurve);
      }
      else {
        translate([-TopWidShift(keyID),.00001-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(FrontCurve);
        translate([-TopWidShift(keyID),-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90-XAngleSkew(keyID),270-ZAngleSkew(keyID)])skin(BackCurve);
      }
    }

    // Cut caps in half to check the internal
    if(crossSection == true){
      translate([0,-15,-.1])cube([15,30,20]);
      // translate([-15.1,-15,-.1])cube([15,30,20]);
    }
  }

  // Homing
  if(homeDot == true){
    // One dot (center)
    #translate([0,0,KeyHeight(keyID)-DishHeightDif(keyID)-0.1])sphere(r = dotRadius);

    // // Double dots (low)
    // #rotate([-XAngleSkew(keyID),YAngleSkew(keyID),ZAngleSkew(keyID)])
    //     translate([.75,-4.5,KeyHeight(keyID)-DishHeightDif(keyID)+0.5])
    //     sphere(r = dotRadius, $fn=16);
    // #rotate([-XAngleSkew(keyID),YAngleSkew(keyID),ZAngleSkew(keyID)])
    //     translate([-.75,-4.5,KeyHeight(keyID)-DishHeightDif(keyID)+0.5])
    //     sphere(r = dotRadius, $fn=16);

    // // Triforce dots (center)
    // #rotate([0,YAngleSkew(keyID),ZAngleSkew(keyID)])translate([0,0,KeyHeight(keyID)-DishHeightDif(keyID)-0.1]){
    //    rotate([0,0,0])translate([0,.75,0])sphere(r = dotRadius); // center dot
    //    rotate([0,0,120])translate([0,.75,0])sphere(r = dotRadius); // center dot
    //    rotate([0,0,240])translate([0,.75,0])sphere(r = dotRadius); // center dot
    //  }
  }

  if (homeRing == true) {
        z = KeyHeight(keyID)-DishHeightDif(keyID) - 0.3;

        #rotate([ - XAngleSkew(keyID) * 0.5, -YAngleSkew(keyID), ZAngleSkew(keyID)])
        translate([0, 0, z])

        for (i = [0:3]) {
            translate([0, 0, i * 0.15])
            rotate_extrude(convexity = 10, $fn = 100)
            translate([i * 1.3, 0, 0])
            circle(r = .3, $fn = 100);
        }
    }
}
