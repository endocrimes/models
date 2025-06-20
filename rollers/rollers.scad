width = 120.00;
height = 150.00;
depth = 8.00;

tubing_diameter = 70.0;

support_diameter = 12;

bearing_screw_diameter = 8;
bearing_screw_padding = 6.0;

$fn = 600;

module foot(width, depth) {
  difference() {
    foot_width = width / 5;
    cube([foot_width, 8.0, depth * 2.5]);

    // Cutouts for screws
    translate([foot_width / 2, 30, depth + ((1.5 * depth) * .5)])
      rotate([90, 0, 0])
        cylinder(h = 100.0, d = 5.0);
  }
}

// repeats the child shape in a circle with a given radius and number of points.
module repeatCircle(radius, num_holes) {
  for(i = [0:num_holes]) {
    translate([radius * cos(i * (360 / num_holes)), radius * sin(i * (360 / num_holes)), 0]) {
      children();
    }
  }
}

module halfBodyShape() {
  difference() {
    // Start with A Block
    square([width / 2, height]);

    // Cut out a side gap for weight
    // savings and shape
    translate([-10, 0.5 * height, 0]) {
      scale([1, 2, 1]) {
        circle(d = 0.5 * height);
      }
    }

    // cut out a notch for tubing to rest "within"
    translate([width / 2, height + (0.1 * tubing_diameter), 0])
      circle(d = tubing_diameter);

    // cut out bearing screw holes - Make a circle of holes then offset them to the correct location.
    // a hack that limits precision, but fine for now.
    translate([width / 2, height + 0.1 * tubing_diameter, 0])
      repeatCircle(tubing_diameter / 2 + bearing_screw_padding, 20)
        circle(d = bearing_screw_diameter);

    // add support
    translate([width / 2, height / 2, 0]) {
      circle(d = support_diameter);
    }

    // cut out a squished circle in the bottom
    translate([width / 2, 0, 0])
      scale([1, 0.8, 0])
        circle(d = (width / 2));
  }
}

// The for(mirror(translate is to account for the fact that the half body shape draws the left half, starting at
// 0:0:0, and I don't know a better  way to mirror it for the other side. It works, but is a little ugly.
for(m = [0:1])
  mirror([m, 0, 0])
    translate([-(width / 2), 0, 0])
      union() {
        // screw feet need to be offset slightly to account for the curve.
        // should probably be fixed to be properly parametric but I'm... lazy.
        translate([7, 0, 0])
          foot(width, depth);

        // main body
        linear_extrude(depth) {
          halfBodyShape();
        }
      }
