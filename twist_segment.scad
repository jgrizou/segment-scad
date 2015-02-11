use <../MCAD/rotate.scad>;

module twist_segment(length, width, thickness, twistAngle, scale=[1,1], wallThickness=0) {
  // handle the scale parameter with caution. it is not that intuitive especially for angle non multiple of 90 degree

  convexity = ceil(abs(twistAngle/90));

  if (wallThickness > 0) {
    difference () {
      twist_segment(length, width, thickness, twistAngle, scale);
      twist_segment(length, width-(2*wallThickness), thickness-(2*wallThickness), twistAngle, scale);
    }
  } else {
    rotate([-90,0,0])
      linear_extrude(height=length, twist=twistAngle, scale=scale, convexity=convexity)
        square([width,thickness], center=true);
    }
}

module add_twist_segment(length, width, thickness, twistAngle, scale=[1,1], wallThickness=0) {
  twist_segment(length,width,thickness,twistAngle,scale, wallThickness);
  translate([0,length, 0])
    rotate([0,-twistAngle,0])
      for(i = [0 : $children - 1])
        children(i);
}


// Testing
echo("##########");
echo("In twist_segment.scad");
echo("This file should not be included, use ''use <finemane>'' instead.");
echo("##########");

$fn=100;
p = 1;
if (p==1) {
  add_twist_segment(20,10,3,90,wallThickness=0.5)
    #twist_segment(20,10,3,90,wallThickness=0.5);
}
