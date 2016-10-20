/*  Feiyutech Mini3D Gimbal Adapter 
    Author: SuperRoach / Brett James 2016 
    http://www.thingiverse.com/SuperRoach/
    
    The design of this adapts to if you are going to use it with a velcrostrap, and you can choose other options below too. Please measure your battery up and adjust to get a fit for your battery. The settings below worked for a 1000mAh 2S Lipo sitting around spare from Hobbyking.
    
    Please leave this message intact when redistributing.
    

/* Primary Gimbal Connection */
$width = 20;
$smoothness = 164; // I used 164 for the Final STLS
$blockoutheight = 30;

$holderheight = 40;
$holderwidth = 10;

$smallholderheight = 15;


    /* Battery holder */
// Measure out the dimensions of your battery, rounding up where possible to allow for printers being well printers and getting their tolerance wrong.
$batteryheight = 73;
$batterywidth = 35; 
$batterylength = 15.5; 
$batterybottombuffer = 7;
$batterytopspacebuffer = 16;

    /* Velcro Strap? */
// Set this to true if you want the top to be chamfered and a slot added (with extra top padding) to allow for routing through a velcro strap to hold the gimbal in place. This doubles as locking the handle together.
$velcrostrap = true;
$velcrowidth = 21;
$velcroheightpadding = 27;

/* Battery notch? */
// When true, this will add a small .2mm notch above your measured battery height. It'll help keep it in position when you allow for slightly more room to fit the battery. Not really needed when there is a velcro strap.
$notch = false;


$summedheight = $velcrostrap ? ($batteryheight + $batterybottombuffer + $batterytopspacebuffer + $velcroheightpadding): ($batteryheight + $batterybottombuffer + $batterytopspacebuffer );

$batterynotchheight = $velcrostrap ? $batterytopspacebuffer + $velcroheightpadding : $batterytopspacebuffer; 

//#cube([55,55,40], center = true) {};

/*
difference() {
    cube([55,55,40], center = true) {};
    rotate([180,0,0]) strap(0,0,-$blockoutheight);
}
*/

//rotate([180,0,0]) strap(0,0,-$blockoutheight);
/*
// split in half
//difference() {
/*
difference()
{
    translate([0,0,-($batteryheight+$batterybottombuffer)]) rotate([0,0,0]) handle(true);
    translate([0, 0, -$batterybottom]) rotate([90,90,0]) batteryinside($batteryheight,$batterywidth,$batterylength);
}


    //translate([-30,0,-($batteryheight+$batterybottombuffer)-6]) cube([75,50,100]);
//}
*/

//#cube([55,55,40], center = true) {};
//#cube([21,100,3], center = true) {};

//rotate([90, 0 ,0 ]) translate([0,0,-($batterywidth+30*2)/2]) roundedcube($velcrowidth,4,100,rdim= 2);   


assembledhandle(rubberbandholder = true, split = true);

module assembledhandle(rubberbandholder, split)
{

echo ( $summedheight);
    
//    union(){
        if ($notch) {
            rotate([90,90,0]) translate([$batterynotchheight-.5,-$holderwidth/2-.5,-$batterylength/2])  roundedcube($fn = 16, 2,10,.4,rdim= 1);
            }
    difference()
    {
        translate([0,0,-($summedheight)]) rotate([0,0,0]) handle(rubberbandholder);
        // Need to add +1 to avoid manifold errors
        translate([0, 0, $batterybottombuffer+1]) rotate([90,90,0]) batteryinside($batteryheight,$batterywidth,$batterylength, false);
        if (split)    
        {  
        mirror([0,1,0]) translate([-40,0,-250])cube([75,50,300]);
        }                  
    }
 //   }


}

module handle(rubberbandholder)
{
    
        //    translate([-$batterylength*2.5,0, -$batteryheight/10]) cube([75,50,100]);
            difference() {
                    resize([0,40,0], auto=[false,true,false])   
                    cylinder($fn = $smoothness, h=($summedheight), r1=$batterylength+5, r2=$batterylength+10, center=false);
      
    // Use one or the other for the Tripod thread:
    // UNC 1/4 20 - Smaller and typical tripod mount
    //translate([0,5,0]) english_thread (diameter=1/4, threads_per_inch=20, length=.3, internal=true);            
    // UNC 3/8 16 - Larger professional mounting gear            
            translate([0,6,0]) english_thread (diameter=3/8, threads_per_inch=16, length=.3, internal=true);
            if ($velcrostrap) { 
                //Chamfered top edge                
                translate([-$velcrowidth/2,19,$summedheight-$batterybottombuffer-$velcroheightpadding+.2]) rotate([90,0,90]) cylinder($fn = $smoothness, h=($velcrowidth), r1=2, r2=2, center=false);                
                
                // Velcro hole
                rotate([80, 0 ,0 ]) translate([0,($summedheight-$batterybottombuffer-$velcroheightpadding),0]) translate([-$velcrowidth/2, 0, -($batterywidth+30*2)/2]) resize([0,3,0]) roundedcube($fn = 50, $velcrowidth,4,100,rdim= 2); 

    translate([-$velcrowidth/2,$batterywidth/2-12,$summedheight-14.5]) rotate([90,5,90]) 
                linear_extrude($fn = $smoothness, height = $velcrowidth, center = false, convexity = 10, twist = 0) difference()   {square(20);circle(15);}
                
                }
            // Wire piping                 
        translate([$width/2,$batterylength/4,($summedheight)]) rotate([0,90,0]) cylinder($fn = $smoothness, h=100, r1=3, r2=3, center=true);              
            }
                    

    
    if (rubberbandholder)
    {
        $rings = 5;
        for (a = [1 : $rings-1]) {
        translate([0,0,($batterybottombuffer/2)+2+a*17])    
        resize([0,30,0], auto=[false,true,false])      
            cylinder($fn = $smoothness,  5, $batterylength+10, $batterylength+10, true); 
        }
    }
}


module batteryinside(batteryheight,batterywidth,batterylength, opening) {
   translate([0,-batterywidth/2,-batterylength/2]) cube([$summedheight-$batterybottombuffer,batterywidth,batterylength], center = false );
    
    if (opening)
    {
        // This isn't properly working yet. It's not centered properly
        #translate([(batterylength/2-1),batterywidth/3,-batterywidth/2.5]) rotate([0,270,0]) rotate([0,0,45]) translate([0,-batterywidth/2,-batterylength/2+4]) cylinder($fn=4, h=5, r1=batterywidth/2-5, r2=batterywidth/2, center=true);
    }
}


module strap(x,y,z) { 
translate([x,y,z])    
    union() { 
        // strap holder
        difference() {
            rotate([90, 0, 0]) { 
                cylinder($fn = $smoothness, h = $width, r1 = $width/2, r2 = $width/2, center = true);
            }
            
          translate([0,0,-$blockoutheight/2]) cube([$width,30,$blockoutheight],center=true);
        }
        
        union() { 
            translate([0,($holderwidth/2)+($width/2),$holderheight/2]) cube([20,$holderwidth,$holderheight],center=true);
            
                translate([0,-($holderwidth/2)-($width/2),$smallholderheight/2]) cube([20,$holderwidth,$smallholderheight],center=true);
        }
    }
}















//------------- Rounded designs

module roundedcube(xdim ,ydim ,zdim,rdim){
hull(){
translate([rdim,rdim,0])cylinder(h=zdim,r=rdim);
translate([xdim-rdim,rdim,0])cylinder(h=zdim,r=rdim);

translate([rdim,ydim-rdim,0])cylinder(h=zdim,r=rdim);
translate([xdim-rdim,ydim-rdim,0])cylinder(h=zdim,r=rdim);
}
}










//------------------------
/*
 * ISO-standard metric threads, following this specification:
 *          http://en.wikipedia.org/wiki/ISO_metric_screw_thread
 *
 * Dan Kirshner - dan_kirshner@yahoo.com
 *
 * You are welcome to make free use of this software.  Retention of my
 * authorship credit would be appreciated.
 *
 * Version 1.9.  2016-07-03  Option: tapered.
 * Version 1.8.  2016-01-08  Option: (non-standard) angle.
 * Version 1.7.  2015-11-28  Larger x-increment - for small-diameters.
 * Version 1.6.  2015-09-01  Options: square threads, rectangular threads.
 * Version 1.5.  2015-06-12  Options: thread_size, groove.
 * Version 1.4.  2014-10-17  Use "faces" instead of "triangles" for polyhedron
 * Version 1.3.  2013-12-01  Correct loop over turns -- don't have early cut-off
 * Version 1.2.  2012-09-09  Use discrete polyhedra rather than linear_extrude ()
 * Version 1.1.  2012-09-07  Corrected to right-hand threads!
 */

// Examples.
//
// Standard M8 x 1.
// metric_thread (diameter=8, pitch=1, length=4);

// Square thread.
// metric_thread (diameter=8, pitch=1, length=4, square=true);

// Non-standard: long pitch, same thread size.
//metric_thread (diameter=8, pitch=4, length=4, thread_size=1, groove=true);

// Non-standard: 20 mm diameter, long pitch, square "trough" width 3 mm,
// depth 1 mm.
//metric_thread (diameter=20, pitch=8, length=16, square=true, thread_size=6, 
//               groove=true, rectangle=0.333);

// English: 1/4 x 20.
//english_thread (diameter=1/4, threads_per_inch=20, length=1);



// Tapered.  Example -- pipe size 3/4" -- per:
// http://www.engineeringtoolbox.com/npt-national-pipe-taper-threads-d_750.html
// english_thread (diameter=1.05, threads_per_inch=14, length=3/4, taper=1/16);

//english_thread (diameter=1.05, threads_per_inch=14, length=3/4, taper=1/16);

// Thread for mounting on Rohloff hub.
//difference () {
//   cylinder (r=20, h=10, $fn=100);
//
//   metric_thread (diameter=34, pitch=1, length=10, internal=true, n_starts=6);
//}


// ----------------------------------------------------------------------------
function segments (diameter) = min (50, ceil (diameter*6));


// ----------------------------------------------------------------------------
// internal -    true = clearances for internal thread (e.g., a nut).
//               false = clearances for external thread (e.g., a bolt).
//               (Internal threads should be "cut out" from a solid using
//               difference ()).
// n_starts -    Number of thread starts (e.g., DNA, a "double helix," has
//               n_starts=2).  See wikipedia Screw_thread.
// thread_size - (non-standard) size of a single thread "V" - independent of
//               pitch.  Default: same as pitch.
// groove      - (non-standard) subtract inverted "V" from cylinder (rather than
//               add protruding "V" to cylinder).
// square      - Square threads (per
//               https://en.wikipedia.org/wiki/Square_thread_form).
// rectangle   - (non-standard) "Rectangular" thread - ratio depth/width
//               Default: 1 (square).
// angle       - (non-standard) angle (deg) of thread side from perpendicular to
//               axis (default = standard = 30 degrees).
// taper       - diameter change per length (National Pipe Thread/ANSI B1.20.1
//               is 1" diameter per 16" length).
module metric_thread (diameter=8, pitch=1, length=1, internal=false, n_starts=1,
                      thread_size=-1, groove=false, square=false, rectangle=0,
                      angle=30, taper=0)
{
   // thread_size: size of thread "V" different than travel per turn (pitch).
   // Default: same as pitch.
   local_thread_size = thread_size == -1 ? pitch : thread_size;
   local_rectangle = rectangle ? rectangle : 1;

   n_segments = segments (diameter);
   h = (square || rectangle) ? local_thread_size*local_rectangle/2 : local_thread_size * cos (angle);

   h_fac1 = (square || rectangle) ? 0.90 : 0.625;

   // External thread includes additional relief.
   h_fac2 = (square || rectangle) ? 0.95 : 5.3/8;

   if (! groove) {
      metric_thread_turns (diameter, pitch, length, internal, n_starts,
                           local_thread_size, groove, square, rectangle, angle,
                           taper);
   }

   difference () {

      // Solid center, including Dmin truncation.
      tapered_diameter = diameter - length*taper;
      if (groove) {
         cylinder (r1=diameter/2, r2=tapered_diameter/2,
                   h=length, $fn=n_segments);
      } else if (internal) {
         cylinder (r1=diameter/2 - h*h_fac1, r2=tapered_diameter/2 - h*h_fac1,
                   h=length, $fn=n_segments);
      } else {

         // External thread.
         cylinder (r1=diameter/2 - h*h_fac2, r2=tapered_diameter/2 - h*h_fac2,
                   h=length, $fn=n_segments);
      }

      if (groove) {
         metric_thread_turns (diameter, pitch, length, internal, n_starts,
                              local_thread_size, groove, square, rectangle,
                              angle, taper);
      }
   }
}


// ----------------------------------------------------------------------------
// Input units in inches.
// Note: units of measure in drawing are mm!
module english_thread (diameter=0.25, threads_per_inch=20, length=1,
                      internal=false, n_starts=1, thread_size=-1, groove=false,
                      square=false, rectangle=0, angle=30, taper=0)
{
   // Convert to mm.
   mm_diameter = diameter*25.4;
   mm_pitch = (1.0/threads_per_inch)*25.4;
   mm_length = length*25.4;

   echo (str ("mm_diameter: ", mm_diameter));
   echo (str ("mm_pitch: ", mm_pitch));
   echo (str ("mm_length: ", mm_length));
   metric_thread (mm_diameter, mm_pitch, mm_length, internal, n_starts, 
                  thread_size, groove, square, rectangle, angle, taper);
}

// ----------------------------------------------------------------------------
module metric_thread_turns (diameter, pitch, length, internal, n_starts, 
                            thread_size, groove, square, rectangle, angle,
                            taper)
{
   // Number of turns needed.
   n_turns = floor (length/pitch);

   intersection () {

      // Start one below z = 0.  Gives an extra turn at each end.
      for (i=[-1*n_starts : n_turns+1]) {
         translate ([0, 0, i*pitch]) {
            metric_thread_turn (diameter, pitch, internal, n_starts, 
                                thread_size, groove, square, rectangle, angle,
                                taper, i*pitch);
         }
      }

      // Cut to length.
      translate ([0, 0, length/2]) {
         cube ([diameter*3, diameter*3, length], center=true);
      }
   }
}


// ----------------------------------------------------------------------------
module metric_thread_turn (diameter, pitch, internal, n_starts, thread_size,
                           groove, square, rectangle, angle, taper, z)
{
   n_segments = segments (diameter);
   fraction_circle = 1.0/n_segments;
   for (i=[0 : n_segments-1]) {
      rotate ([0, 0, i*360*fraction_circle]) {
         translate ([0, 0, i*n_starts*pitch*fraction_circle]) {
            current_diameter = diameter - taper*(z + i*n_starts*pitch*fraction_circle);
            thread_polyhedron (current_diameter/2, pitch, internal, n_starts, 
                               thread_size, groove, square, rectangle, angle);
         }
      }
   }
}


// ----------------------------------------------------------------------------
// z (see diagram) as function of current radius.
// (Only good for first half-pitch.)
function z_fct (current_radius, radius, pitch, angle)
   = 0.5* (current_radius - (radius - 0.875*pitch*cos (angle)))
                                                       /cos (angle);

// ----------------------------------------------------------------------------
module thread_polyhedron (radius, pitch, internal, n_starts, thread_size,
                          groove, square, rectangle, angle)
{
   n_segments = segments (radius*2);
   fraction_circle = 1.0/n_segments;

   local_rectangle = rectangle ? rectangle : 1;

   h = (square || rectangle) ? thread_size*local_rectangle/2 : thread_size * cos (angle);
   outer_r = radius + (internal ? h/20 : 0); // Adds internal relief.
   //echo (str ("outer_r: ", outer_r));

   // A little extra on square thread -- make sure overlaps cylinder.
   h_fac1 = (square || rectangle) ? 1.1 : 0.875;
   inner_r = radius - h*h_fac1; // Does NOT do Dmin_truncation - do later with
                                // cylinder.

   translate_y = groove ? outer_r + inner_r : 0;
   reflect_x   = groove ? 1 : 0;

   // Make these just slightly bigger (keep in proportion) so polyhedra will
   // overlap.
   x_incr_outer = (! groove ? outer_r : inner_r) * fraction_circle * 2 * PI * 1.02;
   x_incr_inner = (! groove ? inner_r : outer_r) * fraction_circle * 2 * PI * 1.02;
   z_incr = n_starts * pitch * fraction_circle * 1.005;

   /*
    (angles x0 and x3 inner are actually 60 deg)

                          /\  (x2_inner, z2_inner) [2]
                         /  \
   (x3_inner, z3_inner) /    \
                  [3]   \     \
                        |\     \ (x2_outer, z2_outer) [6]
                        | \    /
                        |  \  /|
             z          |[7]\/ / (x1_outer, z1_outer) [5]
             |          |   | /
             |   x      |   |/
             |  /       |   / (x0_outer, z0_outer) [4]
             | /        |  /     (behind: (x1_inner, z1_inner) [1]
             |/         | /
    y________|          |/
   (r)                  / (x0_inner, z0_inner) [0]

   */

   x1_outer = outer_r * fraction_circle * 2 * PI;

   z0_outer = z_fct (outer_r, radius, thread_size, angle);
   //echo (str ("z0_outer: ", z0_outer));

   //polygon ([[inner_r, 0], [outer_r, z0_outer], 
   //        [outer_r, 0.5*pitch], [inner_r, 0.5*pitch]]);
   z1_outer = z0_outer + z_incr;

   // Give internal square threads some clearance in the z direction, too.
   bottom = internal ? 0.235 : 0.25;
   top    = internal ? 0.765 : 0.75;

   translate ([0, translate_y, 0]) {
      mirror ([reflect_x, 0, 0]) {

         if (square || rectangle) {

            // Rule for face ordering: look at polyhedron from outside: points must
            // be in clockwise order.
            polyhedron (
               points = [
                         [-x_incr_inner/2, -inner_r, bottom*thread_size],         // [0]
                         [x_incr_inner/2, -inner_r, bottom*thread_size + z_incr], // [1]
                         [x_incr_inner/2, -inner_r, top*thread_size + z_incr],    // [2]
                         [-x_incr_inner/2, -inner_r, top*thread_size],            // [3]

                         [-x_incr_outer/2, -outer_r, bottom*thread_size],         // [4]
                         [x_incr_outer/2, -outer_r, bottom*thread_size + z_incr], // [5]
                         [x_incr_outer/2, -outer_r, top*thread_size + z_incr],    // [6]
                         [-x_incr_outer/2, -outer_r, top*thread_size]             // [7]
                        ],

               faces = [
                         [0, 3, 7, 4],  // This-side trapezoid

                         [1, 5, 6, 2],  // Back-side trapezoid

                         [0, 1, 2, 3],  // Inner rectangle

                         [4, 7, 6, 5],  // Outer rectangle

                         // These are not planar, so do with separate triangles.
                         [7, 2, 6],     // Upper rectangle, bottom
                         [7, 3, 2],     // Upper rectangle, top

                         [0, 5, 1],     // Lower rectangle, bottom
                         [0, 4, 5]      // Lower rectangle, top
                        ]
            );
         } else {

            // Rule for face ordering: look at polyhedron from outside: points must
            // be in clockwise order.
            polyhedron (
               points = [
                         [-x_incr_inner/2, -inner_r, 0],                        // [0]
                         [x_incr_inner/2, -inner_r, z_incr],                    // [1]
                         [x_incr_inner/2, -inner_r, thread_size + z_incr],      // [2]
                         [-x_incr_inner/2, -inner_r, thread_size],              // [3]

                         [-x_incr_outer/2, -outer_r, z0_outer],                 // [4]
                         [x_incr_outer/2, -outer_r, z0_outer + z_incr],         // [5]
                         [x_incr_outer/2, -outer_r, thread_size - z0_outer + z_incr], // [6]
                         [-x_incr_outer/2, -outer_r, thread_size - z0_outer]    // [7]
                        ],

               faces = [
                         [0, 3, 7, 4],  // This-side trapezoid

                         [1, 5, 6, 2],  // Back-side trapezoid

                         [0, 1, 2, 3],  // Inner rectangle

                         [4, 7, 6, 5],  // Outer rectangle

                         // These are not planar, so do with separate triangles.
                         [7, 2, 6],     // Upper rectangle, bottom
                         [7, 3, 2],     // Upper rectangle, top

                         [0, 5, 1],     // Lower rectangle, bottom
                         [0, 4, 5]      // Lower rectangle, top
                        ]
            );
         }
      }
   }
}


