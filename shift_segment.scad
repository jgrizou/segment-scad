use <../MCAD/rotate.scad>;

use <elbow_segment.scad>;
use <straight_segment.scad>;


module shift_segment(length, shift, angle, radius, width, thickness, planar, wallThickness=0) {
  // length is the length pf the segment on the y axis
  // shift is the delta X (if planar==true) or Z (if planar==false) of the segment
  // radius is the curvature of the transition
  // angle is the angle, i.e. the smoothness, of the transition

  shiftFromElbow = abs((cos(angle)-1)*radius*2);
  shiftNeeded = abs(shift) - shiftFromElbow;
  if (shiftNeeded < 0) {
    echo("## WARNING ##");
    echo();
    echo("In shift_segment: impossible combination of angle and radius");
    echo();
    echo("#############");
  }

  middleSegmentLenght = shiftNeeded / cos(90-angle);

  lenghtAdded = middleSegmentLenght * sin(90-angle);
  diffLengthElbow = (sin(angle) - sin(-angle)) * radius + lenghtAdded;

  totalLenghtToCover = length - diffLengthElbow;

  if (totalLenghtToCover < 0) {
    echo("## WARNING ##");
    echo();
    echo("In shift_segment: impossible combination of angle and radius");
    echo();
    echo("#############");
  }

  if (wallThickness > 0) {
    difference () {
      shift_segment(length, shift, angle, radius, width, thickness, planar);
      shift_segment(length, shift, angle, radius, width-(2*wallThickness), thickness-(2*wallThickness), planar);
    }
  } else {
    if (planar) {
      if (sign(shift) > 0) {
        add_straight_segment(totalLenghtToCover/2, width, thickness)
          add_elbow_segment(-angle, radius, width, thickness, planar)
            add_straight_segment(middleSegmentLenght, width, thickness)
              add_elbow_segment(angle, radius, width, thickness, planar)
                straight_segment(totalLenghtToCover/2, width, thickness);
      } else {
        add_straight_segment(totalLenghtToCover/2, width, thickness)
          add_elbow_segment(angle, radius, width, thickness, planar)
            add_straight_segment(middleSegmentLenght, width, thickness)
              add_elbow_segment(-angle, radius, width, thickness, planar)
                straight_segment(totalLenghtToCover/2, width, thickness);
      }
    } else {
      rotate([0,-90,0])
        shift_segment(length, shift, angle, radius, thickness, width, planar=true);
    }
  }
}

module add_shift_segment(length, shift, angle, radius, width, thickness, planar, wallThickness=0) {

  shift_segment(length, shift, angle, radius, width, thickness, planar, wallThickness);

  if (planar) {
      translate([shift,length,0])
        for(i = [0 : $children - 1])
          children(i);
  } else {
      translate([0,length,shift])
        for(i = [0 : $children - 1])
          children(i);
  }
}

// Testing
echo("##########");
echo("In shift_segment.scad");
echo("This file should not be included, use ''use <finemane>'' instead.");
echo("##########");

length = 20;
shift = 5;
angle = 35;
radius = 5;
width = 5;
thickness = 2;

p = 1;
if (p==1){
  add_shift_segment(length, shift, angle, radius, width, thickness, false)
    shift_segment(length, -shift, angle, radius, width, thickness, false);
  translate([20,0,0])
    add_shift_segment(length, shift, angle, radius, width, thickness, true, 0.5)
      shift_segment(length, -shift, angle, radius, width, thickness, true, 0.5);
}
