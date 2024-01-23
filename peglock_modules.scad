
peg_diameter=6; // [3:.1:10]
peg_spacing=25.4;
highpeg_stickout=4.6;
highpeg_angleout=8;
highpeg_stickup=6;
lowpeg_stickout=8;

peg_radius = peg_diameter / 2;
holder_height = 25.4 + 6 + 4;

module quartersphere(radius=peg_radius) {
    rotate_extrude(angle=-180) intersection() {
        square(radius);
        circle(radius);
    };
}

module halfcylinder(length, radius=peg_radius) {
    rotate_extrude(angle=-180) square([radius,length]);
    translate([0,0,length]) children();
}

module angledhalfcylinder(length, radius=peg_radius) {
    intersection() {
        multmatrix([
            [1, 0,-1, 0],
            [0, 1, 0, 0],
            [0, 0, 1, 0]
        ])
        halfcylinder(length + radius, radius);
        
        translate([-length, -radius, 0])
        cube([length + radius, radius, length + radius]);
    };

    translate([-length, 0, length])
    rotate([0,-90,0])
    children();
}

module double(v=[1,0,0]) {
    children();
    mirror(v) children();
}

module halfHolder() {
    cube([3,6,holder_height]);

    translate([3,0,0]) 
    linear_extrude(holder_height, scale=0)
    polygon([[0,0], [8,0], [0,6]]);
}

module holder() {
    double() halfHolder(); 
}

module halfPeglockAttachment() {
    translate([0, -holder_height/2]) rotate([-90,0,0]) rotate([0,0,-90])
    halfHolder();

    translate([6, -peg_spacing/2]) rotate([-90,0,-90])
    halfcylinder(lowpeg_stickout)
    quartersphere();
    
    translate([6, +peg_spacing/2]) rotate([-90,0,-90])
    halfcylinder(highpeg_stickout)
    angledhalfcylinder(highpeg_angleout)
    halfcylinder(highpeg_stickup)
    quartersphere();
}

module peglockAttachment() {
    difference() {
        union() {
            double() translate([.25,0,0]) halfPeglockAttachment();
            linear_extrude(.2) square([.5,holder_height], center=true); 
        }
        translate([0,0,-.5]) linear_extrude(12) square([6.5,14], center=true); 
    }
}

$fs=.08;
peglockAttachment();

translate([25.4,0,0]) holder();