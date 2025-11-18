// ===============================================
// MOTOR DE VÓRTICE - CAVIDAD SUPERIOR STL
// Archivo individual para cavidad_superior.stl
// ===============================================

// PARÁMETROS PRINCIPALES
cavity_height    = 120;
cavity_major     = 50;
cavity_minor     = 35;
wall_thickness   = 3;
inlet_diameter   = 16;

echo("=== EXPORTANDO CAVIDAD SUPERIOR ===");
echo("Altura:", cavity_height/2, "mm");
echo("Diámetro mayor:", cavity_major * 2, "mm");
echo("Diámetro menor:", cavity_minor * 2, "mm");

// ====================
// MITAD SUPERIOR DE LA CAVIDAD
// ====================
module cavity_upper_half() {
    difference() {
        // Media esfera superior
        intersection() {
            // Cavidad completa
            difference() {
                // Pared exterior
                resize([cavity_major*2, cavity_minor*2, cavity_height])
                sphere(r = cavity_major, $fn=80);
                
                // Vacío interior
                translate([0, 0, wall_thickness/2])
                resize([
                    (cavity_major - wall_thickness)*2, 
                    (cavity_minor - wall_thickness)*2, 
                    cavity_height - wall_thickness
                ])
                sphere(r = cavity_major - wall_thickness, $fn=80);
                
                // Entrada tangencial del fluido
                translate([cavity_major - 5, 0, -cavity_height/4])
                rotate([0, 90, 0])
                cylinder(h = 25, r = inlet_diameter/2, $fn=30);
            }
            
            // Corte para mantener solo mitad superior
            translate([0, 0, 2])
            cube([cavity_major*3, cavity_minor*3, cavity_height], center = true);
        }
        
        // Ranura para junta tórica
        translate([0, 0, -1])
        cylinder(h = 3, r = cavity_major - 8, $fn=60);
        
        // Agujeros para tornillos de unión
        for(i = [0:3]) {
            rotate(i * 90)
            translate([cavity_major - 12, 0, -5])
            cylinder(h = 10, r = 1.8, $fn=20);
        }
    }
    
    // Pestañas de refuerzo
    for(i = [0:3]) {
        rotate(i * 90)
        translate([cavity_major - 15, 0, -8])
        cylinder(h = 6, r = 3, $fn=25);
    }
    
    // Refuerzos estructurales internos
    for(i = [0:2]) {
        rotate(i * 120)
        translate([cavity_major - 10, 0, cavity_height/4])
        rotate([0, 90, 0])
        cylinder(h = 15, r = 2, $fn=20);
    }
}

// ====================
// RENDERIZAR CAVIDAD SUPERIOR
// ====================
cavity_upper_half();

echo("=== INSTRUCCIONES IMPRESIÓN ===");
echo("Material: PETG");
echo("Tiempo estimado: 8-12 horas");
echo("Soportes: SÍ necesarios");
echo("Balsa: SÍ activar");
