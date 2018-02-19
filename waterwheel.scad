// spirals   = how many spirals
// thickness = how thick you want the arms to be
// rmax      = maximum radius
module archimedean_spiral(spirals=1, thickness=1, rmax = 100){
    s = spirals*360;
    t = thickness;
    a = sqrt(pow(rmax,2)/(pow(s,2)*(pow(cos(s),2) + pow(sin(s),2))));
    points=[
        for(i = [0:$fa:s]) [
            (i*a)*cos(i),
            (i*a)*sin(i)
        ]
    ];
    points_inner=[
        for(i = [s:-$fa:0]) [
            (((i*a)+t)*cos(i)),
            (((i*a)+t)*sin(i))
        ]
    ];
    polygon(concat(points,points_inner));
}

module spin_spiral(slices = 4, arc = 360, radius = 100, thickness = 5, offset = 0){
    div = arc / slices;
    for(a = [0:div:arc]) {
        rotate([0, 0, a])
        translate([offset, 0, 0])
        archimedean_spiral(spirals = 2/12, thickness = 5, rmax = radius);
    }
}

module assemble(slices = 4, arc = 360, radius = 100, thickness = 5, top = false) {
    difference() {
        union() {
            cylinder(1, r = rad + thick + off);
            
            // Uncomment notches here for bottom half
            if (top) {
                difference() {
                    translate([0, 0, 3])
                    linear_extrude(ex_height)
                    spin_spiral(slices = cups, radius = rad, thickness = thick - 3, offset = off);
                    cylinder(ex_height*2, r=10);
                }
            }
            
            linear_extrude(ex_height)
            spin_spiral(slices = cups, radius = rad, thickness = thickness, offset = off);
        }
        
        /*
        // Notches
        rotate([0,0,5])
        translate([0,0,1])
        linear_extrude(ex_height - .5)
        spin_spiral(slices = cups, radius = rad, thickness = thickness, offset = off);
        */

        translate([0,0,-1*ex_height/2])
        cylinder(ex_height*2, r=2);
    }
}


$fa = 1;
$fn = 100;

rad = 30;
thick = 5;
cups = 6;
ex_height = 10;
off = 1;
printTop = true;

if (printTop) {
    mirror()
    assemble(slices = cups, radius = rad, thickness = thick, offset = off, top = true);
}
else {
    assemble(slices = cups, radius = rad, thickness = thick, offset = off, top = false);
}
