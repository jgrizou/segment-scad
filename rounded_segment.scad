module rounded_start_segment(width, thickness, wallThickness=0) {
  if (wallThickness > 0) {
    difference () {
      rounded_start_segment(width, thickness);
      rounded_start_segment(width-(2*wallThickness), thickness-(2*wallThickness));
    }
  } else {
    difference () {
      cylinder(h=thickness, r=width/2, center=true);

      translate([0,width/4,0])
        cube([width,width/2,thickness], center=true);
    }
  }
}

module add_rounded_start_segment(width, thickness, wallThickness=0) {
  rounded_start_segment(width, thickness, wallThickness);
  for(i = [0 : $children - 1])
    children(i);
}

module rounded_stop_segment(width, thickness, wallThickness=0) {
  if (wallThickness > 0) {
    difference () {
      rounded_stop_segment(width, thickness);
      rounded_stop_segment(width-(2*wallThickness), thickness-(2*wallThickness));
    }
  } else {
    difference () {
      cylinder(h=thickness, r=width/2, center=true);

      translate([0,-width/4,0])
        cube([width,width/2,thickness], center=true);
    }
  }
}

module add_rounded_stop_segment(width, thickness, wallThickness=0) {
  rounded_stop_segment(width, thickness, wallThickness);
  for(i = [0 : $children - 1])
    children(i);
}

// Testing
echo("##########");
echo("In rounded_segment.scad");
echo("This file should not be included, use ''use <filemane>'' instead.");
echo("##########");

p = 1;
if (p==1) {
  add_rounded_start_segment(20,3)
    translate([0,20,0])
      rounded_stop_segment(20,3,0.5);
}
