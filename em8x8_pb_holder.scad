/*
 *  Pixelblaze holder and 8x8 LED mount
 *
 *  The pcb_mount_v2() function fits the Pixelblaze V2 board
 *  and should also fit V3 (but I don't have one yet to test).
 *
 *  The mount could be used as a component in other projects.
 *
 *  TODO: Add Pixelblaze Pico PCB mount.
 */

led_full_side = 8.5;  // dimension of one LED cube on 8x8 matrix
side = 8 * led_full_side + 0.8;

width = 8;
th = 1.6;

h_side = 4;
module holder() {
    pcb_th = 5.25;
    h_off = 3;

    cube([h_side, h_side, th + h_off], true);
    translate([0, h_side/4, (th+h_off)/2]) {
        cube([h_side, h_side/2, pcb_th], true);
    }
    translate([0, 0, (th+pcb_th+h_off)/2]) {
        cube([h_side, h_side, th], true);
    }
}

/*
 *  Standoff holder for PCB
 */
module pcb_mount_v2() {
    pcb_len = 40.25;
    pcb_wid = 27.5 + 0.1;

    difference() {
        cube([pcb_len, pcb_wid, th], true);
        cube([pcb_len-8, pcb_wid-8, th], true);
    }
    translate([(pcb_len-h_side)/2, pcb_wid/2, 3/2]) {
        holder();
    }
    translate([(pcb_len-h_side)/2, -pcb_wid/2, 3/2]) {
        rotate([0, 0, 180]) {
            holder();
        }
    }
    translate([-10, -pcb_wid/2, 3/2]) {
        rotate([0, 0, 180]) {
            holder();
        }
    }
    translate([-((40.25/2)-9.5), (pcb_wid/2-6), 0]) {
        cylinder(r=2, h=3.6, $fn=90);
        cylinder(r=1, h=3.6+1.6, $fn=90);
        cube([4, 8, th], true);
    }
}

module box_frame() {
    soh = 4;
    sow = 2;

    cube([side, width, th], true);
    translate([(side-sow)/2, 0, (soh-th)/2]) {
        cube([sow, width+4, soh], true);
    }
    translate([-(side-sow)/2, 0, (soh-th)/2]) {
        cube([sow, width+4, soh], true);
    }

    cube([width, side, th], true);
    translate([0, (side-sow)/2, (soh-th)/2]) {
        cube([width+4, sow, soh], true);
    }
    translate([0, -(side-sow)/2, (soh-th)/2]) {
        cube([width+4, sow, soh], true);
    }

    // wire clip
    translate([-6, 22, -th/2]) {
        difference() {
            cube([10, 5, 5]);
            translate([4, 0, 0]) {
                cube([6, 5, 3.5]);
            }
        }
    }

    pcb_mount_v2();
}

// pcb_mount_v2();
box_frame();
