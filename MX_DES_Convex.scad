use <scad-utils/morphology.scad> //for cheaper minwoski
use <scad-utils/transformations.scad>
use <scad-utils/shapes.scad>
use <scad-utils/trajectory.scad>
use <scad-utils/trajectory_path.scad>

use <list-comprehension/sweep.scad>
use <list-comprehension/skin.scad>

use <utils/shape.scad>
use <utils/stem.scad>
use <utils/key.scad>

/*DES (Distorted Elliptical Saddle) Sculpted Profile
Version 2: Eliptical Rectangle
*/

//NOTE: with sweep cuts, top surface may not be visible in review, it should be visible once rendered
mirror([0,0,0])keycap(
    keyID  = 4, //change profile refer to KeyParameters Struct
    cutLen = 0, //Don't change. for chopped caps
    stem   = true, //tusn on shell and stems
    dish   = true, //turn on dish cut
    homeDot = false, //turn on homedots
    homeRing = false, //turn on homing rings
    crossSection  = false, // center cut to check internal
    visualizeDish = false // turn on debug visual of Dish
);

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

// roll for trajectories
fr1 = 0;
fr2 = 0;
br1 = 0;
br2 = 0;

// ----- Stem Parameters
stemTol = 0.00; //stem tolerance
stemRot = 0;
stemRad = 5.55; // stem outer radius
stemLen = 5.55 ;
stemCrossHeight = 4;
extra_vertical  = 0.6;
stemBrimDep = 0.25;
stemLayers      = 50; //resolution of stem to cap top transition

keyParameters = //keyParameters[KeyID][ParameterID]
[
//  BotWid, BotLen, TWDif, TLDif, keyh, WSft, LSft  XSkew, YSkew, ZSkew, WEx, LEx, CapR0i, CapR0f, CapR1i, CapR1f, CapREx, StemEx
//normie hipro v1 0~3
    [17.16,  17.16,   6.5, 	 6.5, 11.5,    0,    0,    -3,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5
    [35.46,  17.16,   6.5, 	 6.5, 11.0,    0,    0,   -10,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5 2u
    [17.16,  17.16,   6.5, 	 6.5,    9,    0,    0,     3,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R3 Home
    [35.56,   6.5, 	 6.5,  8.6,    0,    0,    -8,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5 2u low pro 3
//normie hi-sculpt 4 row system  4~15
    [MX_KeyWidth(1.00),  17.16,   6.5, 	 6.5, 11.0,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5  4
    [MX_KeyWidth(1.25),  17.16,   6.5, 	 6.5, 11.0,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5 1.25u
    [MX_KeyWidth(1.50),  17.16,   6.5, 	 6.5, 11.0,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5 1.5u
    [MX_KeyWidth(1.75),  17.16,   6.5, 	 6.5, 11.0,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5 1.75u
    [MX_KeyWidth(2.00),  17.16,   6.5, 	 6.5, 11.0,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5 2.0u
    [MX_KeyWidth(2.25),  17.16,   6.5, 	 6.5, 11.0,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5 2.25u
    [MX_KeyWidth(2.75),  17.16,   6.5, 	 6.5, 11.0,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5 2.75u
    [MX_KeyWidth(3.00),  17.16,   6.5, 	 6.5, 11.0,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5 3.00u
    [MX_KeyWidth(4.00),  17.16,   6.5, 	 6.5, 11.0,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5 4.00u
    [MX_KeyWidth(6.00),  17.16,   6.5, 	 6.5, 11.0,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5 4.00u
    [MX_KeyWidth(6.25),  17.16,   6.5, 	 6.5, 11.0,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5 4.00u
    [MX_KeyWidth(7.00),  17.16,   6.5, 	 6.5, 11.0,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5 4.00u
//normie  mild  4 row system 16~20
    [17.16,  17.16,    6.5, 	 6.5, 10.3,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5
    [22.26,  17.16,    6.5, 	 6.5, 10.3,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5
    [26.66,  17.16,    6.5, 	 6.5, 10.3,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5
    [31.06,  17.16,    6.5, 	 6.5, 10.3,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5
    [35.56,  17.16,    6.5, 	 6.5, 10.3,    0,    0,    -9,     0,     0,   2,   2,      1,      5,      1,    3.5,     2,       2], //R5
//nueron R5s 21~24
    [35.46,  17.96,    6.5,    6.5, 10.5,    0,    0,    -5,     0,     0,   2,   2,      1,      5,      1,      5,     2,       2], //R5  2u
    [26.66,  17.16,    6.5, 	 6.5, 10.5,    0,    0,    -3,     0,     0,   2,   2,      1,      5,      1,      5,     2,       2], //R5 1.5u
    [40.66,  17.16,    6.5, 	 6.5, 10.5,    0,    0,    -3,     0,     0,   2,   2,      1,      5,      1,      5,     2,       2], //R5 2.25u
    [49.86,  17.16,    6.5, 	 6.5, 10.5,    0,    0,    -3,     0,     0,   2,   2,      1,      5,      1,      5,     2,       2], //R5 2.75u
];

dishParameters = //dishParameter[keyID][ParameterID]
[
//FFwd1 FFwd2 FPit1 FPit2  DshDepi DishDepf,DshHDif FArcIn FArcFn FArcEx     BFwd1 BFwd2 BPit1 BPit2  BArcIn BArcFn BArcEx
  [   4,    4,  -10,  -20,      3,      7,   8.2,     9,     2,        4,    9,    3,   15,    8.2,     9,     2], //R5
  [   4,  3.5,  -13,  -50,      2,    4.5,  18.2,  17.5,     2,       4.5,  2.5,   -5,  -50,   18.2,    17,     2], //R5 2u
  [   3,    3,  -10,  -50,      3,      7,   8.8,     9,     2,        4,    3,   -5,  -30,    8.8,     9,     2],  //R3
  [   3, 3.25,  -10,  -45,      2,    4.3,  18.2,    21,     2,        5,    3,  -10,  -30,   18.2,    21,     2], //R4
//normie hi-sculpt 4 row system  17~24
  [   4,    3,  -10,  -20,    1.5,      4,   8.2,    9.0,     2,        4,    3,  -10,  -30,    8.2,    9.0,      2], //R5
  [   4,    3,  -10,  -20,    1.5,      4,  10.6,   11.4,     2,        4,    3,  -10,  -30,   10.6,   11.4,      2],//R5 1.25u
  [   4,    3,  -10,  -20,    1.5,      4,  13.0,   13.8,     2,        4,    3,  -10,  -30,   13.0,   13.8,      2], //R5 1.5u
  [   4,    3,  -10,  -20,    1.5,      4,  15.4,   16.1,     2,        4,    3,  -10,  -30,   15.4,   16.1,      2], //R5 1.75u
  [   4,    3,  -10,  -20,    1.5,      4,  17.7,   18.5,     2,        4,    3,  -10,  -30,   17.7,   18.5,      2], //R5 2.0u
  [   4,    3,  -10,  -20,    1.5,      4,  20.1,   20.9,     2,        4,    3,  -10,  -30,   20.1,   20.9,      2], //R5 2.25u
  [   4,    3,  -10,  -20,    1.5,      4,  24.9,   27.7,     2,        4,    3,  -10,  -30,   24.9,   27.7,      2], //R5 2.75u
  [   4,    3,  -10,  -20,    1.5,      4,  27.3,   28.1,     2,        4,    3,  -10,  -30,   27.3,   28.1,      2], //R5 3.00u
  [   4,    3,  -10,  -20,    1.5,      4,  36.8,   37.6,     2,        4,    3,  -10,  -30,   36.8,   37.6,      2], //R5 4.00u
  [   4,    3,  -10,  -20,    1.5,      4,  55.8,   56.6,     2,        4,    3,  -10,  -30,   55.8,   56.6,      2], //R5 6.00u
  [   4,    3,  -10,  -20,    1.5,      4,  58.2,   60.0,     2,        4,    3,  -10,  -30,   58.2,   60.0,      2], //R5 6.25u
  [   4,    3,  -10,  -20,    1.5,      4,  65.4,   66.2,     2,        4,    3,  -10,  -30,   65.4,   66.2,      2], //R5 7.00u
//normie hi-sculpt 4 row system  17~24
  [   4,    3,  -10,  -20,    1.5,      4,   8.2,     9,     2,        4,    3,  -10,  -30,    8.2,     9,     2], //R5
  [   4,    3,  -10,  -20,    1.5,      4,  10.2,    11,     2,        4,    3,  -10,  -30,   10.2,    11,     2],//R5 1.25u
  [   4,    3,  -10,  -20,    1.5,      4,  12.4,    13,     2,        4,    3,  -10,  -30,   12.4,    13,     2], //R5 1.5u
  [   4,    3,  -10,  -20,    1.5,      4,  14.6,    15,     2,        4,    3,  -10,  -30,   14.6,    15,     2], //R5 1.75u
  [   4,    3,  -10,  -20,    1.5,      4,  16.8,    17,     2,        4,    3,  -10,  -30,   16.8,    17,     2], //R5 2.0u
//
  [   4,    3,  -10,  -20,    1.8,    4.5,  17.5,    19,     2,        4,   10,    3,   15,   17.5,    19,     2], //R5
  [   4,    3,  -10,  -20,    1.5,      4,  11.8,    12,     2,        4,    3,  -10,  -30,   11.8,    12,     2], //R5 1.5u
  [   4,    3,  -10,  -20,    1.5,      4,  18.8,  18.8,     2,        4,    3,  -10,  -30,   18.8,  18.8,     2], //R5 2.25u
  [   4,    3,  -10,  -20,    1.5,      4,  23.5,    24,     2,        4,    3,  -10,  -30,   23.5,    24,     2], //R5 2.75u
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
    trajectory(forward = FrontForward1(keyID), pitch =  FrontPitch1(keyID), roll = fr1), //more param available: yaw, roll, scale
    trajectory(forward = FrontForward2(keyID), pitch =  FrontPitch2(keyID), roll = fr2)  //You can add more traj if you wish
  ];

function BackTrajectory (keyID) =
  [
    trajectory(forward = BackForward1(keyID), pitch =  BackPitch1(keyID), roll = br1),
    trajectory(forward = BackForward2(keyID), pitch =  BackPitch2(keyID), roll = br2),
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
  keyID  = 0,
  cutLen = 0,
  stem = true,
  dish = true,
  homeDot = false,
  homeRing = false,
  crossSection = false,
  visualizeDish = false,
) {
  $fn = fn;

  // Set Parameters for dish shape
  FrontPath = quantize_trajectories(FrontTrajectory(keyID), steps = stepsize, loop=false, start_position= $t*4);
  BackPath  = quantize_trajectories(BackTrajectory(keyID),  steps = stepsize, loop=false, start_position= $t*4);

  // Scaling initial and final dim tranformation by exponents
  function FrontDishArc(t) =  pow((t)/(len(FrontPath)),FrontArcExpo(keyID))*FrontFinArc(keyID) + (1-pow(t/(len(FrontPath)),FrontArcExpo(keyID)))*FrontInitArc(keyID);
  function BackDishArc(t)  =  pow((t)/(len(FrontPath)),BackArcExpo(keyID))*BackFinArc(keyID) + (1-pow(t/(len(FrontPath)),BackArcExpo(keyID)))*BackInitArc(keyID);

  FrontCurve = [ for(i=[0:len(FrontPath)-1]) transform(FrontPath[i], DishShapeConvex(DishDepth(keyID), FrontDishArc(i), DishDepth(keyID)+2.5, d = 0, step=step)) ];
  BackCurve  = [ for(i=[0:len(BackPath)-1])  transform(BackPath[i],  DishShapeConvex(DishDepth(keyID),  BackDishArc(i), DishDepth(keyID)+2.5, d = 0, step=step)) ];

  // Builds
  difference(){
    union(){
        difference(){
          // Create outer shell
          skin([for (i=[0:layers-1]) transform(translation(CapTranslation(i, keyID)) * rotation(CapRotation(i, keyID)), elliptical_rectangle_profile(CapTransform(i, keyID), b = CapRoundness(i,keyID),fn=fn))]); //outer shell

          // Cut inner shell
          if(stem == true){
            translate([0,0,-.001])skin([for (i=[0:layers-1]) transform(translation(InnerTranslation(i, keyID)) * rotation(CapRotation(i, keyID)), elliptical_rectangle_profile(InnerTransform(i, keyID), b = CapRoundness(i,keyID),fn=fn))]);
          }

          // Make sure XY plane is flat
          translate([-50,-50,-10]) cube([100,100,10], center=false);
        }

        if(stem == true){
          u = MX_KeyUnit(BottomWidth(keyID));
          MX_Cylinderical_Stems(u, KeyHeight(keyID), stemRot, stemBrimDep, tolerance=stemTol, $fn= 32);
        }
    }

    // Cuts

    // Fonts

    // Dish Shape
    if(dish == true){
      if(visualizeDish == true){
        #translate([-TopWidShift(keyID),.00001-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)]) rotate([0,-YAngleSkew(keyID),0])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(FrontCurve);
        #translate([-TopWidShift(keyID),-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90-XAngleSkew(keyID),270-ZAngleSkew(keyID)])skin(BackCurve);
      }
      else {
        translate([-TopWidShift(keyID),.00001-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(FrontCurve);
        translate([-TopWidShift(keyID),-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90-XAngleSkew(keyID),270-ZAngleSkew(keyID)])skin(BackCurve);
      }
    }

    if(crossSection == true) {
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
