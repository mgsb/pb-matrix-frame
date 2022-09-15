#include <BOSL2/std.scad>

/* [Global] */
// show grid (true) or frame box (false)
show_grid = false;

/* [Frame (Box)] */
// height (mm) of frame (box)
frame_height = 20.0;

// thickness (mm) of clear front panel - affects light dispersion/brightness
frame_front_clear = 2.0;

// thickness (mm) of frame walls (multiple of nozzle size)
frame_wall = 1.6;

/* [Grid] */
// height (mm) of 8x8 grid
grid_height = 5;

/* [Hidden] */
full_side = 8.5;

cap_width = 1.3;
cell_wall = (cap_width + 2*0.4) / 2.0;
cell_side = full_side - 2*cell_wall;

module cell() {
    side = full_side;
    t = cell_wall;
    h = grid_height;
    difference() {
        cube([side, side, h]);
        translate([t, t, 0])
            cube([side-2*t, side-2*t, h]);
    }
}

module capacitor() {
    cube([2.8, cap_width, 1.1]);
}

module row() {
    difference() {
        grid2d([full_side, full_side], [8,1])
            cell();
        translate([cell_side/2-0.5, -cap_width/2, 0]) {
            grid2d([full_side, full_side], [8, 1])
                capacitor();
        }
        translate([cell_side/2-0.5, full_side-(cap_width/2), 0]) {
            grid2d([full_side, full_side], [8, 1])
                capacitor();
        }
    }
}

module grid_base() {
    union() {
        grid2d([0,full_side],[1,8])
            row();
        translate([-full_side*8/2+(full_side/2), -full_side*8/2++(full_side/2), 0]) {
            difference() {
                cube([8*full_side,8*full_side,1]);
                translate([1, 1, 0])
                    cube([8*full_side-2,8*full_side-2, 1]);
            }
        }
    }
}

module grid() {
    difference() {
        grid_base();
        translate([-3 * full_side - 3.5, 3.5 * full_side - 0.75, 0]) {
            cube([8, 1.5, 1.5]);
        }
        translate([-3 * full_side - 3.5, -(2.5 * full_side + 0.75), 0]) {
            cube([8, 1.5, 1.5]);
        }
    }
}

module hollow_box(ix, iy, h, wall) {
    difference() {
        cube([ix + 2 * wall, iy + 2 * wall, h]);
        translate([wall, wall, 0]) {
            cube([ix, iy, h]);
        }
    }
}

module box() {
    side = 8 * full_side + 0.8;
    difference() {
        wall = frame_wall;
        depth = frame_height;
        union() {
            hollow_box(side, side, depth, wall);
            cube([side + 2*wall, side + 2*wall, frame_front_clear]);
        }
    }
/*
        width = side + 2 * wall;
        inset = 2 + 5 + 2;
        center = inset + (depth - inset) / 2;
        translate([width/2, wall, center]) {
            rotate([90, 0, 0]) {
                color([1, 0, 0]) cylinder(r=6.16/2, h=0.75, $fn=90);
            }
        }
        translate([width-12, wall, center]) {
            rotate([90, 0, 0]) {
                color([1, 0, 0]) cylinder(r=6.16/2, h=0.7, $fn=90);
            }
        }
        translate([12, wall, center]) {
            rotate([90, 0, 0]) {
                color([1, 0, 0]) cylinder(r=6.16/2, h=0.7, $fn=90);
            }
        }
    }

    translate([(side + 2)/2 - 25, 1, 13.0]) {
        rotate([70, 0, 0]) {
            cube([50, 7.5, 1]);
        }
    }
    translate([0.8, side/2 - 5, 7.1]) {
        cube([1.5, 10, 1.2]);
    }
    translate([side-0.2, side/2 - 5, 7.1]) {
        cube([1.5, 10, 1.2]);
    }
*/

}

if (show_grid) {
    grid();
}
else {
    box();
}
