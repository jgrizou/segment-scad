use <../MCAD/rotate.scad>;

use <elliptic_segment.scad>
use <straight_segment.scad>

module square_to_square_transition_segment(length, startWidth, startThickness, endWidth, endThickness, wallThickness=0) {

  if (wallThickness > 0) {
    difference () {
      square_to_square_transition_segment(length, startWidth, startThickness, endWidth, endThickness);
      square_to_square_transition_segment(length, startWidth-(2*wallThickness), startThickness-(2*wallThickness), endWidth-(2*wallThickness), endThickness-(2*wallThickness));
    }
  } else {
    // there should be an easier, more elegant, solution, indeed using linear extrude!!!
    // cf twist_transition_segment
    // WARNING it is more difficult to do a twisted transition with linear extrude, the scale parameter is not what we would want
    rotate([-90,0,0])
      intersection() {
        // width
        hull() {
          translate([0, -endThickness, 0])
            linear_extrude(height=length, scale=endWidth/startWidth)
              square([startWidth, startThickness], center=true);
          translate([0, endThickness, 0])
            linear_extrude(height=length, scale=endWidth/startWidth)
              square([startWidth, startThickness], center=true);
        }
        // thickness
        hull() {
          translate([-endWidth, 0, 0])
            linear_extrude(height=length, scale=endThickness/startThickness)
              square([startWidth, startThickness], center=true);
          translate([endWidth, 0, 0])
            linear_extrude(height=length, scale=endThickness/startThickness)
              square([startWidth, startThickness], center=true);
        }
      }
  }
}

module add_square_to_square_transition_segment(length, startWidth, startThickness, endWidth, endThickness, wallThickness=0) {
  square_to_square_transition_segment(length, startWidth, startThickness, endWidth, endThickness, wallThickness);
  translate([0,length, 0])
    for(i = [0 : $children - 1])
      children(i);
}

module elliptic_to_elliptic_transition_segment(length, startWidth, startHeight, endWidth, endHeight, wallThickness=0) {
    elliptic_segment(length, startWidth, startHeight, 0, [endWidth/startWidth,endHeight/startHeight], wallThickness);
}

module add_elliptic_to_elliptic_transition_segment(length, startWidth, startHeight, endWidth, endHeight, wallThickness=0) {
  add_elliptic_segment(length, startWidth, startHeight, 0, [endWidth/startWidth,endHeight/startHeight], wallThickness)
    for(i = [0 : $children - 1])
      children(i);
}

module elliptic_to_square_transition_segment(length, ellipseWidth, ellipseHeight, squareWidth, squareThickness, tipLenght=0.1, wallThickness=0) {

  if (wallThickness > 0) {
    difference () {
      elliptic_to_square_transition_segment(length, ellipseWidth, ellipseHeight, squareWidth, squareThickness, tipLenght);
      elliptic_to_square_transition_segment(length, ellipseWidth-(2*wallThickness), ellipseHeight-(2*wallThickness), squareWidth-(2*wallThickness), squareThickness-(2*wallThickness), tipLenght);
    }
  } else {
    hull() {
      elliptic_segment(tipLenght,ellipseWidth,ellipseHeight);
      translate([0,length-tipLenght,0])
        straight_segment(tipLenght,squareWidth,squareThickness);
    }
  }
}

module add_elliptic_to_square_transition_segment(length, ellipseWidth, ellipseHeight, squareWidth, squareThickness, tipLenght=0.1, wallThickness=0) {

  elliptic_to_square_transition_segment(length, ellipseWidth, ellipseHeight, squareWidth, squareThickness, tipLenght, wallThickness);

  translate([0,length, 0])
    for(i = [0 : $children - 1])
      children(i);
}

module square_to_elliptic_transition_segment(length, squareWidth, squareThickness, ellipseWidth, ellipseHeight, tipLenght=0.1, wallThickness=0) {

  if (wallThickness > 0) {
    difference () {
      square_to_elliptic_transition_segment(length, squareWidth, squareThickness, ellipseWidth, ellipseHeight, tipLenght);
      square_to_elliptic_transition_segment(length, squareWidth-(2*wallThickness), squareThickness-(2*wallThickness), ellipseWidth-(2*wallThickness), ellipseHeight-(2*wallThickness), tipLenght);
    }
  } else {
    hull() {
      straight_segment(tipLenght,squareWidth,squareThickness);
      translate([0,length-tipLenght,0])
        elliptic_segment(tipLenght,ellipseWidth,ellipseHeight);
    }
  }
}

module add_square_to_elliptic_transition_segment(length, squareWidth, squareThickness, ellipseWidth, ellipseHeight, tipLenght=0.1, wallThickness=0) {

  square_to_elliptic_transition_segment(length, squareWidth, squareThickness, ellipseWidth, ellipseHeight, tipLenght, wallThickness);

  translate([0,length, 0])
  for(i = [0 : $children - 1])
  children(i);
}

// Testing
echo("##########");
echo("In transition_segment.scad");
echo("This file should not be included, use ''use <filemane>'' instead.");
echo("##########");

$fn=50;
p = 2;
if (p==1) {
  add_square_to_square_transition_segment(20,10,10,10,10,0.5)
    add_square_to_square_transition_segment(20,10,10,20,5,0.5)
      square_to_square_transition_segment(20,20,5,20,5,0.5);
}
if (p==2) {
  add_elliptic_to_elliptic_transition_segment(25,5,10,20,10,0.5)
    add_elliptic_to_square_transition_segment(50, 20, 10, 10, 20, 0.1, 0.5)
      add_square_to_square_transition_segment(20,10,20,30,5,0.5)
        square_to_elliptic_transition_segment(50, 30, 5, 20, 20, 0.1, 0.5);
}
