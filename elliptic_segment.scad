use <../MCAD/rotate.scad>;
use <../MCAD/2Dshapes.scad>

module elliptic_segment(length, width, heigth, twistAngle=0, scale=[1,1], wallThickness=0) {

  convexity = ceil(abs(twistAngle/90));

  if (wallThickness > 0) {
    difference () {
      elliptic_segment(length, width, heigth, twistAngle, scale);
      elliptic_segment(length, width-(2*wallThickness), heigth-(2*wallThickness), twistAngle, scale);
    }
  } else {
    rotate([-90,0,0])
      linear_extrude(height=length, twist=twistAngle, scale=scale, convexity=convexity)
        ellipse(width, heigth);
  }
}

module add_elliptic_segment(length, width, heigth, twistAngle=0, scale=[1,1], wallThickness=0) {
  elliptic_segment(length,width,heigth,twistAngle,scale, wallThickness);
  translate([0,length, 0])
    rotate([0,-twistAngle,0])
      for(i = [0 : $children - 1])
        children(i);
}

// Testing
echo("##########");
echo("In elliptic_segment.scad");
echo("This file should not be included, use ''use <finemane>'' instead.");
echo("##########");

p = 1;
if (p==1) {
  add_elliptic_segment(40,20,5,0, wallThickness=1)
    elliptic_segment(40,20,5,180, wallThickness=1);
  /*hull() {
    cube([10,10,10], center=true);
    translate([0,50,0])
      sphere(10);
  }*/
}
