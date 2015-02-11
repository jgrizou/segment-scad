use <../MCAD/rotate.scad>;
use <../MCAD/partial_rotate_extrude.scad>;

module elbow_segment(angle, radius, width, thickness, planar, wallThickness=0) {

  if (angle==0){
    echo("## WARNING ##");
    echo();
    echo("In elbow_segment: Angle should not be 0");
    echo();
    echo("#############");
  }

  if (abs(angle)>360){
    echo("## WARNING ##");
    echo();
    echo("In elbow_segment: Angle should not be more than 360");
    echo();
    echo("#############");
  }

  if (wallThickness > 0) {
    difference () {
      elbow_segment(angle, radius, width, thickness, planar);
      elbow_segment(angle, radius, width-(2*wallThickness), thickness-(2*wallThickness), planar);
    }
  } else {
    if (planar) {

      if (radius < width/2){
        echo("## WARNING ##");
        echo();
        echo("In elbow_segment: when planar=true, radius should be at least width/2");
        echo();
        echo("#############");
      }

      if (angle < 0) {
        mirror([1,0,0])
        elbow_segment(-angle, radius, width, thickness, planar=true);
      } else {
        translate([-radius,0,0])
          partial_rotate_extrude(angle, radius, [width/2, thickness/2], convex = 4)
            square([width, thickness], center = true);
      }

    } else {

      if (radius < thickness/2){
        echo("## WARNING ##");
        echo();
        echo("In elbow_segment: when planar=false, radius should be at least thickness/2");
        echo();
        echo("#############");
      }

      rotate([0,90,0])
        elbow_segment(angle, radius, thickness, width, planar=true);
    }
  }
}

module add_elbow_segment(angle, radius, width, thickness, planar, wallThickness=0) {

  elbow_segment(angle, radius, width, thickness, planar, wallThickness);

  if (planar) {
    if (angle < 0) {
      translate([radius-(cos(angle)*radius),-sin(angle)*radius,0])
        rotate([0,0,angle])
          for(i = [0 : $children - 1])
            children(i);
    } else {
      translate([-radius+(cos(angle)*radius),sin(angle)*radius,0])
        rotate([0,0,angle])
          for(i = [0 : $children - 1])
            children(i);
    }
  } else {
    if (angle < 0) {
      translate([0,-sin(angle)*radius,-radius+(cos(angle)*radius)])
        rotate([angle,0,0])
          for(i = [0 : $children - 1])
            children(i);
    } else {
      translate([0,sin(angle)*radius,radius-(cos(angle)*radius)])
        rotate([angle,0,0])
          for(i = [0 : $children - 1])
            children(i);
    }
  }
}

// Testing
echo("##########");
echo("In elbow_segment.scad");
echo("This file should not be included, use ''use <filemane>'' instead.");
echo("##########");

p = 3;
if (p==1){
  elbow_segment(angle=270,radius=10,width=10,thickness=3,planar=true);
  elbow_segment(angle=180,radius=15,width=10,thickness=3,planar=false);
  elbow_segment(angle=-90,radius=10,width=10,thickness=3,planar=true);
  elbow_segment(angle=-90,radius=10,width=10,thickness=3,planar=false);
}
if (p==2) {
  add_elbow_segment(90,10,10,3,false)
    add_elbow_segment(-90,10,10,3,true)
      add_elbow_segment(90,10,10,3,false)
        add_elbow_segment(-90,10,10,3,true)
          add_elbow_segment(90,10,10,3,false)
            elbow_segment(-90,10,10,3,true);
}
if (p==3) {
  elbow_segment(angle=270,radius=10,width=10,thickness=3,planar=true,wallThickness=0.01);
  elbow_segment(angle=180,radius=15,width=10,thickness=3,planar=false,wallThickness=0.1);
  elbow_segment(angle=-90,radius=10,width=10,thickness=3,planar=true,wallThickness=1);
  elbow_segment(angle=-90,radius=10,width=10,thickness=3,planar=false,wallThickness=1.4);
}
