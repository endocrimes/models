width = 120.00;
height = 150.00;
depth = 13.00;

tubing_diameter = 70.0;

support_diameter = 20.0;

bearing_screw_diameter = 8.0;
bearing_screw_padding = 6.0;

$fn=600;

for (m=[0:1]) mirror([m,0,0])
mirror([1,0,0])
translate([-(width/2),0,0])
union() {
// screw feet
    translate([7, 0, 0])
difference() {
    foot_width = width / 5;
    cube([foot_width, 8.0, depth*2.5]);
    
    // Cutouts for screws
    translate([foot_width/2, 30, depth + ((1.5*depth)*.5)])
        rotate([90, 0, 0])
        cylinder(h=100.0, d=5.0);
}
// main body
linear_extrude(depth) {
    difference() {
        // Start with A Block
        square([width/2, height]);
        
            // Cut out a side gap for weight
            // savings and shape
            translate([-10, 0.5*height,0]) {
                scale([1, 2, 1]) {
                    circle(d=0.5*height);
                }
            }
    
        // cut out a notch for tubing to rest "within"
        translate([width/2, height+(0.1*tubing_diameter), 0])
            circle(d=tubing_diameter);
        
        // cut out bearing screw holes - Make a circle of holes then offset them to the correct location.
        // a hack that limits precision, but fine for now.
        num_holes=20;
        pathRadius=tubing_diameter/2 + bearing_screw_padding;
        for (i = [1:num_holes])
            translate([width/2, height+0.1*tubing_diameter, 0])
                translate([pathRadius*cos(i*(360/num_holes)), pathRadius*sin(i*(360/num_holes)),0])
                    circle(d=bearing_screw_diameter);
            
        // add support
        translate([width/2, height/2, 0]) {
                circle(d=support_diameter);
            }
        
        // cut out a squished circle in the bottom
       translate([width/2, 0, 0])
           scale([1, 0.8, 0])
          circle(d=(width/2));
}
}
}
