module straight_segment(length, width, thickness, wallThickness=0) {

  if (wallThickness > 0) {
    difference () {
      straight_segment(length, width, thickness);
      straight_segment(length, width-(2*wallThickness), thickness-(2*wallThickness));
    }
  } else {
    translate([0,length/2, 0])
      cube([width, length, thickness], center=true);
  }
}

module add_straight_segment(length, width, thickness, wallThickness=0) {
  straight_segment(length, width, thickness, wallThickness);
  translate([0,length, 0])
    for(i = [0 : $children - 1])
      children(i);
}

// Testing
echo("##########");
echo("In straight_segment.scad");
echo("This file should not be included, use ''use <filemane>'' instead.");
echo("##########");

p = 1;
if (p==1) {
  add_straight_segment(10,5,3)
    straight_segment(100,20,3,0.1);
}
