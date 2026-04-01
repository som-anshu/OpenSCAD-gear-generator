include <BOSL2/std.scad>
include <BOSL2/gears.scad>

/* [Gear Specifications] */
// Tooth size - 2-digit precision
gear_module = 1.00; // [0.1:0.01:5.0]
// Number of Teeth
teeth_count = 11;    
// Pressure Angle (Degrees)
pressure_angle_val = 20.00; // [14.5, 20, 25]
// Thickness of the gear (mm)
gear_thickness = 10.00; // [1:0.1:50]
// Space between teeth (Backlash) - 2-digit precision
backlash_val = 0.00; // [0.0:0.01:1.0]

/* [Hub/Boss Specs] */
hub_diameter = 8.00; // [5:0.1:100]
hub_height = 6.50; // [0:0.1:50]

/* [Industrial Shaft Library] */
// Selection: NEMA17, BO_MOTOR, KEYED_8MM, DUAL_FLAT_6MM, HEX_12MM, SQUARE_10MM, SERVO_MG996R, ROUND_5MM, ROUND_6MM
motor_shaft_type = "NEMA17"; // ["NEMA17", "BO_MOTOR", "KEYED_8MM", "DUAL_FLAT_6MM", "HEX_12MM", "SQUARE_10MM", "SERVO_MG996R", "ROUND_5MM", "ROUND_6MM"]
// Extra clearance (Hole tolerance) - 2-digit precision
hole_tol = 0.20; // [0.0:0.01:1.0]

/* [Fasteners] */
set_screw_dia = 0.00; // [1:0.1:10]
add_nut_trap = false;
dual_screws = false; 

// --- Internal Calculations ---
total_h = gear_thickness + hub_height;
$fn = 64;

// --- Main Render ---
difference() {
    union() {
        // Main Gear
        spur_gear(
            mod = gear_module, 
            teeth = teeth_count,       
            thickness = gear_thickness, 
            pressure_angle = pressure_angle_val,
            backlash = backlash_val
        );
        // Boss/Hub
        translate([0, 0, gear_thickness/2])
            cylinder(d = hub_diameter, h = hub_height);
    }

    // Shaft hole cut through the whole assembly
    translate([0, 0, hub_height/2])
        motor_shaft_library(motor_shaft_type, total_h + 5, hole_tol);
    
    // Set-screws (Only if not a servo)
    if (motor_shaft_type != "SERVO_MG996R") {
        place_screw_and_nut(0);
        if (dual_screws) place_screw_and_nut(90);
    }
}

// --- Modules ---

module place_screw_and_nut(ang) {
    rotate([0, 0, ang])
    translate([0, 0, gear_thickness/2 + hub_height/2])
        rotate([0, 90, 0]) {
            cylinder(d = set_screw_dia, h = hub_diameter);
            if (add_nut_trap)
                translate([0, 0, hub_diameter/2 - 3.5])
                    rotate([0, 0, 30])
                        cylinder(d = 6.4, h = 3, $fn = 6);
        }
}

module motor_shaft_library(type, h, tol) {
    if (type == "NEMA17") {
        intersection() {
            cylinder(d = 5.0 + tol, h = h, center = true);
            translate([0, -0.25, 0]) cube([5.0 + tol, 4.5 + tol, h + 1], center = true);
        }
    } 
    else if (type == "BO_MOTOR") {
        // Double-D: major 5.5, minor 3.7
        intersection() {
            cylinder(d = 5.5 + tol, h = h, center = true);
            // Oversized Y dimension (8) to ensure we don't accidentally clip the round sides
            cube([3.7 + tol, 8 + tol, h + 1], center = true);
        }
    } 
    else if (type == "HEX_12MM") {
        cylinder(d = 12 + tol, h = h, center = true, $fn = 6);
    }
    else if (type == "SQUARE_10MM") {
        cube([10 + tol, 10 + tol, h], center = true);
    }
    else if (type == "DUAL_FLAT_6MM") {
        intersection() {
            cylinder(d = 6.0 + tol, h = h, center = true);
            cube([4.5 + tol, 8 + tol, h + 1], center = true);
        }
    }
    else if (type == "KEYED_8MM") {
        union() {
            cylinder(d = 8.0 + tol, h = h, center = true);
            translate([0, 4, 0]) cube([3.0 + tol, 3.0 + tol, h + 1], center = true);
        }
    }
    else if (type == "SERVO_MG996R") {
        union() {
            cylinder(d = 5.0 + tol, h = h, center = true); 
            translate([0, 0, (h/2) - 4.5]) cylinder(d = 12.5 + tol, h = 9.0, center = false);
        }
    }
    else {
        cylinder(d = 6.0 + tol, h = h, center = true);
    }
}