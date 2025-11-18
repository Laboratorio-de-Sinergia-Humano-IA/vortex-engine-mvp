// ===============================================
// MOTOR DE VÓRTICE - CAVIDAD INFERIOR STL  
// Archivo individual para cavidad_inferior.stl
// ===============================================

// PARÁMETROS PRINCIPALES
cavity_height    = 120;
cavity_major     = 50;
cavity_minor     = 35;
wall_thickness   = 3;
outlet_diameter  = 10;

echo("=== EXPORTANDO CAVIDAD INFERIOR ===");
echo("Altura:", cavity_height/2, "mm");
echo("Diámetro mayor:", cavity_major * 2, "mm");
echo("Diámetro menor:", cavity_minor * 2, "mm");

// ====================
// MITAD INFERIOR DE LA CAVIDAD
// ====================
module cavity_lower_half() {
    difference() {
        // Media esfera inferior
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
                
                // Salida central inferior
                translate([0, 0, -cavity_height/2])
                cylinder(h = 20, r = outlet_diameter/2, $fn=30);
            }
            
            // Corte para mantener solo mitad inferior
            translate([0, 0, -2])
            cube([cavity_major*3, cavity_minor*3, cavity_height], center = true);
        }
        
        // Ranura para junta tórica
        translate([0, 0, 1])
        cylinder(h = 3, r = cavity_major - 8, $fn=60);
        
        // Agujeros para tornillos de unión
        for(i = [0:3]) {
            rotate(i * 90)
            translate([cavity_major - 12, 0, 5])
            cylinder(h = 10, r = 1.8, $fn=20);
        }
        
        // Soporte para montaje en base
        translate([0, 0, -cavity_height/2 + 5])
        cylinder(h = 10, r = cavity_major - 5, $fn=50);
    }
    
    // Pestañas de refuerzo
    for(i = [0:3]) {
        rotate(i * 90)
        translate([cavity_major - 15, 0, 8])
        cylinder(h = 6, r = 3, $fn=25);
    }
    
    // Refuerzos para la salida de agua
    for(i = [0:2]) {
        rotate(i * 120)
        translate([0, 0, -cavity_height/2 + 8])
        cylinder(h = 12, r = 2, $fn=20);
    }
}

// ====================
// RENDERIZAR CAVIDAD INFERIOR
// ====================
cavity_lower_half();

echo("=== INSTRUCCIONES IMPRESIÓN ===");
echo("Material: PETG");
echo("Tiempo estimado: 8-12 horas");
echo("Soportes: SÍ necesarios");
echo("Balsa: SÍ activar");