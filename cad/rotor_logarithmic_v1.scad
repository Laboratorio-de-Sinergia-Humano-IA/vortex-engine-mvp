// ===============================================
// ROTOR DE VÓRTICE MVP 
// Laboratorio de Sinergia Humano-IA

// --- PARÁMETROS EDITABLES ---
shaft_diameter   = 3.2;     // Diámetro del eje (ajusta a tu motor: 3, 3.17, 4 mm)
rotor_diameter   = 80;      // Diámetro total del rotor (mm)
rotor_height     = 22;      // Altura total (mm)
blade_thickness  = 2.0;     // Grosor de la pala (mm)
num_blades       = 3;       // 3 palas = estabilidad perfecta
twist_degrees    = 48;      // Torsión total (Schauberger usaba ~45-50°)
growth_factor    = 0.038;   // Factor de crecimiento logarítmico (ajustado para 90° → diámetro final)

// --- FUNCIÓN: ESPIRAL LOGARÍTMICA PERFECTA ---
function log_spiral(r0, k, angle) = r0 * exp(k * angle * PI/180);

module log_blade_profile() {
    r0 = shaft_diameter/2 + 1.5;  // Radio inicial (deja espacio al eje)
    steps = 120;                  // Resolución alta = impresión suave
    
    points_outer = [ for (i = [0 : steps])
        let (a = i * 90/steps)
        let (r = log_spiral(r0, growth_factor, a))
        [r * cos(a), r * sin(a)]
    ];
    
    points_inner = [ for (i = [steps : -1 : 0])
        let (a = i * 90/steps)
        let (r = log_spiral(r0, growth_factor, a) - blade_thickness)
        [r * cos(a), r * sin(a)]
    ];
    
    all_points = concat(points_outer, points_inner);
    polygon(all_points);
}

// --- ENSAMBLAJE FINAL OPTIMIZADO ---
difference() {
    union() {
        // Hub central reforzado
        cylinder(h = rotor_height, r = rotor_diameter/6, center = true, $fn=60);
        
        // Generar las N palas simétricas
        for (i = [0 : num_blades-1]) {
            rotate(i * 360/num_blades)
                linear_extrude(height = rotor_height, center = true, twist = twist_degrees, slices = 120)
                    log_blade_profile();
        }
    }
    
    // Agujero del eje (con tolerancia +0.2 mm)
    cylinder(h = rotor_height + 5, r = shaft_diameter/2 + 0.1, center = true, $fn=40);
}

// --- SOPORTES OPCIONALES DE IMPRESIÓN (desactívalos si no los necesitas) ---
// %cylinder(h=0.2, r=rotor_diameter/2, center=true);  // base fantasma para soporte

echo("=== ROTOR MVP v1.0 GENERADO ===");
echo("Diámetro total:", rotor_diameter, "mm");
echo("Torsión:", twist_degrees, "°");
echo("Peso estimado (PLA): ~", (rotor_diameter/10)^3 * 0.012, "g");
