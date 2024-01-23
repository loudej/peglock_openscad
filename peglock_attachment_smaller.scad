
use <peglock_modules.scad>

peg_diameter = 5.7; // [2:.1:10]
peg_spacing=25.4;
highpeg_stickout=3.5;
highpeg_angleout=6;
highpeg_stickup=5;
lowpeg_stickout=6;

peglockInit(
    peg_diameter = peg_diameter,
    peg_spacing = peg_spacing,
    highpeg_stickout = highpeg_stickout,
    highpeg_angleout = highpeg_angleout,
    highpeg_stickup = highpeg_stickup,
    lowpeg_stickout = lowpeg_stickout) {
    peglockAttachment();
}
