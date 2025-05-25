width = 150.00;
height = 180.00;
depth = 15.00;

tubing_diameter = 70.0;

support_diameter = 20.0;

$fn=600;

for (m=[0:1]) mirror([m,0,0])
mirror([1,0,0])
translate([-(width/2),0,0])
union() {
// screw feet
difference() {
        cube([45.0, 10.0, depth*2.5]);
        translate([22.5, 30, depth + ((1.5*depth)*.5)])
            rotate([90, 0, 0])
            cylinder(h=100.0, r=5.0);
}
// main body
linear_extrude(depth) {
    difference() {
        // Start with A Block
        square([width/2, height]);
        
        // Cut out a side gap for weight
        // savings and shape
        translate([0, 0.5*height,0]) {
            scale([0.7, 1.2, 1]) {
                circle(d=0.6*height);
            }
        }
    
        // cut out a notch for tubing to rest "within"
        polygon([
            [width/2, height],
            [width/2, height-tubing_diameter],
            [(width/2)-(tubing_diameter/2), height]
        ],
        [
            [0, 1, 2],
        ]);
        
        // cut out a slide for bearings
        part_width = width/2;
        polygon([
            [part_width-(tubing_diameter/2)-10.0, height-10.0],
            [part_width-14.0, height-tubing_diameter],
            [part_width-20.0, height-tubing_diameter],
            [part_width-(tubing_diameter/2)-16.0, height-10.0],
        ],
        [[0, 1, 2, 3]]
        );
            
        // add support
        translate([part_width, height/2-10, 0]) {
                circle(d=support_diameter);
            }
        
        // cut out a squished circle in the bottom
       translate([width/2, 0, 0])
           scale([0.81, 0.8, 0])
          circle(d=(width/2));
}
}
}
