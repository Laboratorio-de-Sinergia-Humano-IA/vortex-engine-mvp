// ===============================================
// MOTOR DE VÓRTICE MVP v1.0 - EXPORTAR TURBINA PELTON STL
// Archivo específico para generar turbina_pelton.stl
// ===============================================

// PARÁMETROS PRINCIPALES
shaft_diameter   = 3.2;
turbine_diameter = 45;
turbine_height = 18;
num_buckets = 10;

echo("=== EXPORTANDO TURBINA PELTON ===");
echo("Diámetro:", turbine_diameter, "mm");
echo("Altura:", turbine_height, "mm");
echo("Número de aspas:", num_buckets);
echo("Agujero eje:", shaft_diameter + 0.3, "mm");

// ====================
// TURBINA PELTON (OPTIMIZADA PARA IMPRESIÓN)
// ====================
module pelton_turbine() {
    difference() {
        union() {
            // Cubo central reforzado
            cylinder(h = turbine_height, r = shaft_diameter/2 + 4, center = true, $fn=35);
            
            // Aspas tipo cuchara optimizadas
            for(i = [0:num_buckets-1]) {
                rotate(i * 360/num_buckets)
                translate([turbine_diameter/2 - 7, 0, 0])
                union() {
                    // Base del aspa
                    rotate([90, 0, 0])
                    cylinder(h = 8, r = 4, center = true, $fn=25);
                    
                    // Cuchara de captura
                    translate([0, 0, 2])
                    rotate([90, 0, 0])
                    scale([1.3, 1.0, 0.9])
                    sphere(r = 5, $fn=20);
                }
            }
            
            // Refuerzos entre aspas
            for(i = [0:num_buckets-1]) {
                rotate(i * 360/num_buckets + 18)
                translate([turbine_diameter/2 - 12, 0, 0])
                cube([6, 2, turbine_height - 4], center = true);
            }
        }
        
        // Eje central con tolerancia
        cylinder(h = turbine_height + 2, r = shaft_diameter/2 + 0.15, center = true, $fn=25);
        
        // Tornillo de seguridad (prusiano)
        translate([0, 0, turbine_height/2 - 2])
        cylinder(h = 5, r = shaft_diameter/2 + 0.8, $fn=6);
        
        // Alivio de peso en cubo central
        translate([0, 0, 0])
        cylinder(h = turbine_height + 4, r = shaft_diameter/2 + 1.5, center = true, $fn=30);
    }
    
    // Anillo de refuerzo exterior
    difference() {
        cylinder(h = 4, r = turbine_diameter/2 + 1, center = true, $fn=60);
        cylinder(h = 5, r = turbine_diameter/2 - 2, center = true, $fn=60);
    }
}

// ====================
// TURBINA ORIENTADA PARA IMPRESIÓN ÓPTIMA
// ====================
rotate([0, 0, 18])  // Orientar para mejor distribución de fuerzas
pelton_turbine();

echo("=== INSTRUCCIONES IMPRESIÓN TURBINA ===");
echo("Material: PETG (OBLIGATORIO - por resistencia al agua)");
echo("Orientación: Como aparece (aspas hacia arriba)");
echo("Altura capa: 0.12-0.16mm (alta calidad)");
echo("Relleno: 40-50% (alta densidad)");
echo("Soportes: SOLO para el anillo exterior si es necesario");
echo("Velocidad: 30-40mm/s (lento para mejor calidad)");
echo("Balsa: SÍ activar");
echo("Perímetros: 4-5 capas");
echo("Fan: 100% después de 3ra capa");
echo("=== INSTALACIÓN ===");
echo("Usar tornillo M3 prusiano para fijar al eje");
echo("Aplicar sellador en las uniones si habrá contacto con agua");
echo("Balancear después de impresa (girar y verificar que no vibre)");