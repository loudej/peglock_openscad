

default_peg_diameter=6;
default_peg_spacing=25.4;
default_highpeg_stickout=4.6;
default_highpeg_angleout=8;
default_highpeg_stickup=6;
default_lowpeg_stickout=8;

default_base_width=30;
default_base_height=60;

$peg_diameter = default_peg_diameter;
$peg_spacing = default_peg_spacing;
$highpeg_stickout = default_highpeg_stickout;
$highpeg_angleout = default_highpeg_angleout;
$highpeg_stickup = default_highpeg_stickup;
$lowpeg_stickout = default_lowpeg_stickout;

$base_width = default_base_width;
$base_height = default_base_height;

$peg_radius = default_peg_diameter / 2;
$holder_height = 25.4 + 6 + 4;

module peglockInit(
    peg_diameter = default_peg_diameter,
    peg_spacing = default_peg_spacing,
    highpeg_stickout = default_highpeg_stickout,
    highpeg_angleout = default_highpeg_angleout,
    highpeg_stickup = default_highpeg_stickup,
    lowpeg_stickout = default_lowpeg_stickout,
    base_width = default_base_width,
    base_height = default_base_height
    ) {
    $peg_diameter = peg_diameter;
    $peg_spacing = peg_spacing;
    $highpeg_stickout = highpeg_stickout;
    $highpeg_angleout = highpeg_angleout;
    $highpeg_stickup = highpeg_stickup;
    $lowpeg_stickout = lowpeg_stickout;
    $base_width = base_width;
    $base_height = base_height;

    $peg_radius = $peg_diameter/2;
    $holder_height = 25.4 + 6 + 4;

    children();
}

module quartersphere(radius=$peg_radius) {
    rotate_extrude(angle=-180, $fn=42) intersection() {
        square(radius);
        circle(radius, $fn=42);
    };
}

module halfcylinder(length, radius=$peg_radius) {
    rotate_extrude(angle=-180, $fn=42) square([radius,length]);
    translate([0,0,length]) children();
}

module angledhalfcylinder(length, radius=$peg_radius) {
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

module halfHolder(is_cutting=false) {
    translate(is_cutting ? [0,0,-5] : [0,0,0])
    cube([3,6,$holder_height] + (is_cutting ? [0,.25,5] : [0,0,0]));

    translate([3,0,0]) {
        linear_extrude($holder_height, scale=0)
        polygon([[0,0], [8,0], [0,6]]);

        if (is_cutting) {
            translate([0,0,-5]) 
            linear_extrude(5) 
            polygon([[0,0], [8,0], [0,6]]);
        }
    }
}

module holder(is_cutting=false) {
    double() halfHolder(is_cutting); 
}

module halfPeglockAttachment() {
    translate([0, -$holder_height/2]) rotate([-90,0,0]) rotate([0,0,-90])
    halfHolder();

    translate([6, -$peg_spacing/2]) rotate([-90,0,-90])
    halfcylinder($lowpeg_stickout)
    quartersphere();
    
    translate([6, +$peg_spacing/2]) rotate([-90,0,-90])
    halfcylinder($highpeg_stickout)
    angledhalfcylinder($highpeg_angleout)
    halfcylinder($highpeg_stickup)
    quartersphere();
}

module peglockAttachment() {
    difference() {
        union() {
            double() translate([.25,0,0]) halfPeglockAttachment();
            linear_extrude(.2) square([.5,$holder_height], center=true); 
        }
        translate([0,0,-.5]) linear_extrude(12) square([6.5,14], center=true); 
    }
}

module chamfer(pt, v0, v1, v2) {
    multmatrix([
        [v0[0],v1[0],v2[0],pt[0]],
        [v0[1],v1[1],v2[1],pt[1]],
        [v0[2],v1[2],v2[2],pt[2]],
    ]) 
    linear_extrude(1) polygon([[0,0],[1,0],[0,1]]);

    translate(pt) cube(1, center=true);
}

module peglockBase(
    width=$base_width,
    height=$base_height
) {
    topright = [width/2, 0, height/2];
    depth = [0, 6.25+.85, 0];

    render() difference() {
        translate(-topright)
        cube(topright * 2 + depth);

        translate([0, .85, 5-height/2]) 
        holder(is_cutting=true);

        double([1,0,0]) {
            double([0,0,1]) {
                chamfer(topright, [-3,0,0], [0,0,-3], depth);
                chamfer(topright, [-2,0,0], [0,2,0], [0,0,-height/2]);
            }
            translate(topright - [0,0,3]) rotate([0,45,0]) chamfer([0,0,0], [0,0,-2], [0,2,0], [-sqrt(18),0,0]);
        }
        chamfer(topright, [0,0,-2], [0,2,0], [-width,0,0]);        
    }
}
