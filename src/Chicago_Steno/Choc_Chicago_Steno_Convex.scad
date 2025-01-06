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

// Global overloadable epsilon at different scope
$eps = 1/80;

//NOTE: with sweep cuts, top surface may not be visible in review, it should be visible once rendered

mirror([0,0,0])keycap(
  keyID  = 2, //change profile refer to KeyParameters Struct
  cutLen = 0, //Don't change. for chopped caps
  stem   = true, //tusn on shell and stems
  stemRot = stemRot,//change stem orientation by deg
  homeDot = false, //turn on homedots
  dish   = true, //turn on dish cut
  visualizeDish = false,  // turn on debug visual of Dish
  crossSection  = false, // center cut to check internal
  legends = false,
  stab   = 0
);

//Parameters
wallthickness = 1.1;
topthickness  = 3;   //
stepsize      = 60;  //resolution of Trajectory
step          = 0.5;   //resolution of ellipes
fn            = 60;  //resolution of Rounded Rectangles: 60 for output
layers        = 50;  //resolution of vertical Sweep: 50 for output
dotRadius     = 0.55; //home dot size

//---Stem param
slop    = 0.3;
stemRot = 0;
stemWid = 8;
stemLen = 6;
stemOriginZ = 1.7;
stemBrimDep     = 0;
stemLayers      = 50; //resolution of stem to cap top transition
stemDriftAngle  = 0;  // degrees
//#cube([18.16, 18.16, 10], center = true); // sanity check border


keyParameters = //keyParameters[KeyID][ParameterID]
[
//  BotWid, BotLen, TWDif, TLDif, keyh, WSft, LSft  XSkew, YSkew, ZSkew, WEx, LEx, CapR0i, CapR0f, CapR1i, CapR1f, CapREx, StemEx
    //Column 0
    //Levee: Chicago in choc Dimension [0:3]
    [17.20,  16.00,   5.6, 	   5,  3.8,    0,  -.5,     7,    -0,    -0,   2, 2,    .10,      3,     .10,      3,     2,       2], //Chicago Steno R2x 1u
    [17.20,  16.00,   5.6, 	   5,  4.4,    0,   .0,     0,    -0,    -0,   2, 2,    .10,      3,     .10,      3,     2,       2], //Chicago Steno R3x 1u

    // R3x 1.25~2.25u [4:8]
    [21.7,   15.60,   5.6, 	   5.6,  4.5,   0,   .0,   0,    -0,    -0,   2, 2.5,   .1,      3,     .1,      3,     2,       2], //Chicago Steno R3x 1.25u
    [26.20,  15.60,   5.6, 	   5.6,  4.5,   0,   .0,   0,    -0,    -0,   2, 2.5,   .1,      3,     .1,      3,     2,       2], //Chicago Steno R3x 1.5u
    [30.70,  15.60,   5.6, 	   5.6,  4.5,   0,   .0,   0,    -0,    -0,   2, 2.5,   .1,      3,     .1,      3,     2,       2], //Chicago Steno R3x 1.75u
    [35.20,  15.60,   5.6, 	   5.6,  4.5,   0,   .0,   0,    -0,    -0,   2, 2.5,   .1,      3,     .1,      3,     2,       2], //Chicago Steno R3x 2.0u
    [39.70,  15.60,   5.6, 	   5.6,  4.5,   0,   .0,   0,    -0,    -0,   2, 2.5,   .1,      3,     .1,      3,     2,       2], //Chicago Steno R3x 2.25u

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

dishParameters = //dishParameter[keyID][ParameterID]
[
//FFwd1 FFwd2 FPit1    FPit2  DshDepi    DshHDif FArcIn  FArcFn FArcEx  BFwd1 BFwd2 BPit1 BPit2  BArcIn BArcFn BArcEx
  [   5,  2.3,    2,     -55,    1.5,    3.75,     8.5,    8.5,    2,      5,    3,    2,  -50,    8.5,    8.7 ,     2], //R2x 1u
  [ 4.5,  3.3,   -3,     -45,    1.5,    3.75,     8.5,    8.7,    2,    4.5,  3.3,   -3,  -45,    8.5,   8.7,     2], //R3x 1u

  // R3x 1.25~2.25u [4:8]
  [ 4.5,  3.2,   -7,     -45,    1.5,    3.75,    10.75,   10.95,  2,    4.5,  3.2,   -7,  -45,   10.75,   10.95,  2], //R3x 1.25u
  [ 4.5,  3.2,   -7,     -45,    1.5,    3.75,    13.00,   13.20,  2,    4.5,  3.2,   -7,  -45,   13.00,   13.20,  2], //R3x 1.5u
  [ 4.5,  3.2,   -7,     -45,    1.5,    3.75,    15.25,   15.45,  2,    4.5,  3.2,   -7,  -45,   15.25,   15.45,  2], //R3x 1.75u
  [ 4.5,  3.2,   -7,     -45,    1.5,    3.75,    17.50,   17.70,  2,    4.5,  3.2,   -7,  -45,   17.50,   17.70,  2], //R3x 2.00u
  [ 4.5,  3.2,   -7,     -45,    1.5,    3.75,    19.75,   19.95,  2,    4.5,  3.2,   -7,  -45,   19.75,   19.95,  2], //R3x 2.25u

//  original from pseudo, mislabled/ missing params?
//  [ 4.5,  3.2,   -5,  -45,    1.5,   3.75,  19.0,    18,     2,     4.5,  3.2,   -5,  -45,   19.0,    18,     2], //R3x 2u
//  [ 4.5,  3.2,   -5,  -45,    1.5,   3.75,  19.0,    18,     2,     4.5,  3.2,   -5,  -45,   19.0,    18,     2], //R3x 2u
//  ---
//  [   4,  4.2,   -5,  -15,      1,      3,  18.2,    21,     2,       5,    3,   -5,  -15,   18.2,    21,     2], //R3 2u
//  [  4.,  1.5,    8,  -55,      3,      7,   9.0,     9,     2,       4,    3,    3,  -50,    9,     9,     2],  //R3
//  [  4.,  1.5,   -0,  -50,      3,      7,   9.0,     9,     2,       4,    3,    -10,  -50,    9,     9,     2],  //R3
//  [   5,  3.5,    8,  -50,      5,    1.8,   8.8,    15,     2,       6,    4,   13,   30,    8.8,    16,     2], //R1
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

function FrontTrajectory(keyID) =
  [
    trajectory(forward = FrontForward1(keyID), pitch =  FrontPitch1(keyID)), //more param available: yaw, roll, scale
    trajectory(forward = FrontForward2(keyID), pitch =  FrontPitch2(keyID))  //You can add more traj if you wish
  ];

function BackTrajectory (keyID) =
  [
    trajectory(forward = BackForward1(keyID), pitch =  BackPitch1(keyID)),
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
    // Distance between innerTop and stemTop to force a connection between stems and cap
    // Use of $eps to make sure they merge (hint for union)
    stemOriginZ - $eps + (t/stemLayers * (KeyHeight(keyID) - topthickness - stemOriginZ + $eps*2.0))    // Z shift
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
  stem = true,
  stemRot = 0,
  homeDot = false,
  dish = true,
  visualizeDish = false,
  crossSection = false,
  legends = false,
  stab = 0
) {
  $fn = fn;

  //Set Parameters for dish shape
  FrontPath = quantize_trajectories(FrontTrajectory(keyID), steps = stepsize, loop=false, start_position= $t*4);
  BackPath  = quantize_trajectories(BackTrajectory(keyID),  steps = stepsize, loop=false, start_position= $t*4);

  //Scaling initial and final dim tranformation by exponents
  function FrontDishArc(t) =  pow((t)/(len(FrontPath)),FrontArcExpo(keyID))*FrontFinArc(keyID) + (1-pow(t/(len(FrontPath)),FrontArcExpo(keyID)))*FrontInitArc(keyID);
  function BackDishArc(t)  =  pow((t)/(len(FrontPath)),BackArcExpo(keyID))*BackFinArc(keyID) + (1-pow(t/(len(FrontPath)),BackArcExpo(keyID)))*BackInitArc(keyID);

  FrontCurve = [ for(i=[0:len(FrontPath)-1]) transform(FrontPath[i], DishShapeConvex(DishDepth(keyID), FrontDishArc(i), DishDepth(keyID)+1.5, d = 0, step=step)) ];
  BackCurve  = [ for(i=[0:len(BackPath)-1])  transform(BackPath[i],  DishShapeConvex(DishDepth(keyID),  BackDishArc(i), DishDepth(keyID)+1.5, d = 0, step=step)) ];

  //builds
  difference(){
    union(){
      difference(){
        // Create outer shell
        skin([for (i=[0:layers]) transform(translation(CapTranslation(i, keyID)) * rotation(CapRotation(i, keyID)), elliptical_rectangle_profile(CapTransform(i, keyID), b = CapRoundness(i,keyID),fn=fn))]);

        // Cut inner shell
        if(stem == true){
          translate([0,0,-.001])skin([for (i=[0:layers]) transform(translation(InnerTranslation(i, keyID)) * rotation(CapRotation(i, keyID)), elliptical_rectangle_profile(InnerTransform(i, keyID), b = CapRoundness(i,keyID),fn=fn))]);
        }

        // Make sure XY plane is flat
        translate([-50,-50,-10]) cube([100,100,10], center=false);
      }

      if(stem == true){
        translate([0,0,stemBrimDep]) rotate([0,0,stemRot]) Choc_Stem(driftAngle = stemDriftAngle);
        // if (stab != 0){
        //   // translate([Stab/2,0,0])rotate([0,0,stemRot])cherry_stem(KeyHeight(keyID), slop);
        //   // translate([-Stab/2,0,0])rotate([0,0,stemRot])cherry_stem(KeyHeight(keyID), slop);
        //   //TODO add binding support?
        // }

        // Transition Support for taller profile (from inner top cap to stem base)
        rotate([0,0,stemRot]) translate([0,0,-.001]) skin([for (i=[0:stemLayers]) transform(translation(StemTranslation(i, keyID)) * rotation(StemRotation(i, keyID)), rounded_rectangle_profile(StemTransform(i, keyID),r=StemRadius(i, keyID), fn=fn))]);
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

    // Debug internals
    if(crossSection == true) {
      translate([0,-15,-.1])cube([15,30,15]);
    }
  }

  // Homing
  if(homeDot == true)
  {
    // @WIP
    translate([0,0,KeyHeight(keyID)-DishHeightDif(keyID)-.25])sphere(r = dotRadius);
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
//translate([0,19,0])keycap(keyID = 1, cutLen = 0, Stem =false,  Dish = true, Stab = 0 , visualizeDish = true, crossSection = false, homeDot = false, Legends = false);
//translate([0,0,0])lp_master_base(xu = 2, yu = 1 );
//stem_cavity_negative(lp_key, x=1, y=1);
//}
//#translate([0,0,0])cube([14.5, 13.5, 10], center = true); // internal check
//#translate([0,0,0])cube([17.5, 16.5, 10], center = true); // external check
//translate([0,17,0])mirror([0,1,0])keycap(keyID = 0, cutLen = 0, Stem =false,  Dish = true, Stab = 0 , visualizeDish = false, crossSection = false, homeDot = false, Legends = false);
//translate([18,0,0])mirror([0,0,0])keycap(keyID = 0, cutLen = 0, Stem =false,  Dish = true, Stab = 0 , visualizeDish = false, crossSection = false, homeDot = false, Legends = false);
//n translate([0,19, 0])keycap(keyID = 3, cutLen = 0, Stem =true,  Dish = true, visualizeDish = true, crossSection = true, homeDot = false, Legends = false);
// translate([0,38, 0])mirror([0,1,0])keycap(keyID = 2, cutLen = 0, Stem =true,  Dish = true, visualizeDish = false, crossSection = true, homeDot = false, Legends = false);
