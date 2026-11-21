// Expected result: empty intersection. OpenSCAD exits 1 for empty STL.
// Assembly poses below match the current default design; update if edited.
// 0.001 mm lift excludes intentional mating-plane contact.
use <socket-enclosure.scad>
union() {
 intersection() { base(); translate([6.4,6.4,63.001]) guard(); }
 intersection() { base(); translate([0,180,73.001]) rotate([180,0,0]) lid(); }
}
