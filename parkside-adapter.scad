//
// Adapter for Parkside X 20V TEAM battery
// 
// 2 Ah variant of the battery:
// https://www.lidl.de/p/parkside-20-v-akku-pap-20-b1-2-ah-mit-cell-balancing/p100331949
//
// 4 Ah variant of the battery:
// https://www.lidl.de/p/parkside-20-v-akku-pap-20-b3-4-ah/p100350901
//
// 2 Ah battery with charger:
// https://www.lidl.de/p/parkside-20-v-akku-pap-20-b1-2-ah-und-ladegerat-plg-20-c1-2-4-a/p100345081
//

tol = 0.1;
tol_large = 0.5;

connector_width = 30.5 - tol_large;
connector_height = 10.0;
connector_depth = 15.0;

pin_height = 6.5;
pin1_x = 3.45;
pin_dist = (connector_width - 2 * pin1_x) / 3;
tounge_len = 10;
tounge_thickness = 1.1;

outer_pin_dist = 24;

pin_r = 5.2/2;
//pin_r2 = 6.1/2;
pin_l = connector_depth;

back_len = 9;

top_plate_height = 6.3;
top_plate_width = 67.5;
top_plate_length = 67.5;

top_plate2_height = top_plate_height;
top_plate2_width = 32;
top_plate2_length = top_plate_length + 9.5;

lock_nut_width = 24;
lock_nut_height = 5;
lock_nut_length = 7.3;

inner_nut_width = 38.1 + tol_large;
outer_nut_width = 46.4 + tol_large;

nut_w = 4;
nut_h = 4.8;
nut_l = 46;

onut_w = (top_plate_width - outer_nut_width)/2; // 11.5;
onut_l = nut_l + 0.5;
onut_h = connector_height + tol;

back_w = top_plate_width;

vcyl_h = connector_height + top_plate_height - connector_height / 2;

mut_r = 6.4/2 + tol;
mut_h = 3 + tol_large;

scr_r = 3.6/2 + tol;
scr_h = 20 + tol;

scr_dist = 6;

module connector_block() {
    difference() {
        translate([-connector_width/2, 0, 0])
            cube([connector_width, connector_depth, connector_height]);

        for (s =[-1:2:1]) {
            translate([-tounge_thickness / 2 + s * outer_pin_dist / 2, connector_depth -2, (connector_height - pin_height) / 2])
                cube([tounge_thickness, tounge_len, pin_height]);

            translate([s * (outer_pin_dist / 2 - pin_r + tounge_thickness), connector_depth + tol, connector_height / 2])
                rotate([90,0,0])
                    cylinder(connector_depth + 2*tol, pin_r, pin_r, $fn = 60);
        }
    }
}

module adapter() {
    difference() {
        union() {
        connector_block();

            // platte oben
            translate([-top_plate_width/2, -back_len, connector_height])
                cube([top_plate_width, top_plate_length+4, top_plate_height]);

            // Verschlussplatte oben (schmaler Teil)
            translate([-top_plate2_width/2, -back_len, connector_height])
                cube([top_plate2_width, top_plate2_length, top_plate2_height]);

            for (s =[-1:2:1]) {
                // innere Nutführung
                translate([s * (inner_nut_width/2 + nut_w/2 + 2*tol) - nut_w/2, 0, 0])
                    cube([nut_w , nut_l, nut_h]);

                // äußere Nutführung
                translate([-onut_w/2 + s * (outer_nut_width/2 + onut_w/2), 0, 0])
                    cube([onut_w, onut_l, onut_h]);

                // Verlängerung der onut
                translate([-onut_w/2 + s * (outer_nut_width/2 + onut_w/2), onut_l, 0])
                    cube([onut_w, top_plate_length - onut_l - back_len, connector_height + tol]);

            }

            // Rückwandblock
            translate([-back_w/2, -9, 0])
                cube([back_w, back_len, onut_h]);
        }

        for (s =[-1:2:1]) {
            // Vertikale Löcher
            translate([s * (outer_pin_dist / 2 - pin_r + tounge_thickness),0,connector_height / 2])
                cylinder(vcyl_h + 1, pin_r, pin_r, $fn = 60);

            // Kugel im Knick
            translate([s * (outer_pin_dist / 2 - pin_r + tounge_thickness),0,connector_height / 2])
                sphere(pin_r, $fa=5, $fs=0.1);

            // Ecken (hinten) abschrägen
            translate([s*(top_plate_width/2+3), -9, -1])
                rotate([0, 0, s*45])
                    translate([-5, -5, 0])
                        cube([10, 10, 20]);

            // Nutführung abschrägen 1
            translate([s*(inner_nut_width/2 - 3.5), +45, -1])
                rotate([0, 0, s*85])
                    translate([-5, -4.15, -1])
                        cube([10, 10, 10]);

            // Nutführung abschrägen 2
            translate([s*(inner_nut_width/2 - 1 + tol*1.5), +43.3, -.35])
                rotate([-5, 0, 0])
                    translate([-5, -5, nut_h])
                        cube([10, 10, 3]);

            // Schrauben hinten            
            screwsYback =  -back_len + scr_dist;
            screwsDeltaX2 = s * (top_plate_width/2 - scr_dist);
            translate([screwsDeltaX2, screwsYback, -tol]) {
    //            rotate([0, 0, 30])
                    cylinder(mut_h, mut_r, mut_r, $fn = 6);
                cylinder(scr_h + 1, scr_r, scr_r, $fn = 60);
            }

            // Schrauben vorne        
            screwsYfront = 1.5 + onut_l  - scr_dist;
            translate([screwsDeltaX2, screwsYfront, -tol]) {
    //            rotate([0, 0, 30])
                    cylinder(mut_h, mut_r, mut_r, $fn = 6);
                cylinder(scr_h + 1, scr_r, scr_r, $fn = 60);
            }

            screwsDeltaY = screwsYfront - screwsYback;
            echo(screwsDeltaY = screwsDeltaY);
            echo(screwsDeltaX = abs(screwsDeltaX2 *2));

            // Abschrägung onut2
            block_w = 7.3492+onut_w;
            translate([-block_w/2 + s * (outer_nut_width/2 - block_w/2 + onut_w) - tol, onut_l + top_plate_length - onut_l -21, -1])
                rotate([-47, 0, 0])
                    cube([block_w + 2*tol , top_plate_length - onut_l - back_len , 6+connector_height * 2+ tol]);
        }

        // Verschluss-Aussparung
        translate([-lock_nut_width/2, top_plate_length - lock_nut_height - 2.5, 10 - tol])
            cube([lock_nut_width + tol, lock_nut_height + tol, lock_nut_height + tol]);

        // Abschrägung Verschluss-Aussparung
        // translate([-lock_nut_width/2, top_plate_length - lock_nut_height , 11.8 - tol])
        //     rotate([-60, 0, 0])
        //         cube([lock_nut_width + tol , lock_nut_height + 1,  lock_nut_height + tol]);
        
    }
}

rotate([90,0,180])
adapter();