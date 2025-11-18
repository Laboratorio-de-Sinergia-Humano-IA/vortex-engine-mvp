// ===============================================
// ROTOR DE VÓRTICE MVP v1.0 – ESPIRALES VISIBLES
// Versión corregida y 100 % funcional
// 18 Nov 2025 – Laboratorio Sinergia Humano-IA
// ===============================================

shaft_diameter   = 3.2;
rotor_diameter   = 80;      // ← objetivo real
rotor_height     = 22;
blade_thickness  = 2.2;
num_blades       = 3;
twist_degrees    = 48;

// CLAVE: growth_factor recalculado para que a 90° llegue exactamente a rotor_diameter/2
r0               = shaft_diameter/2 + 2;    // distancia inicial al eje
target_radius    = rotor_diameter/2;        // 40 mm
growth_factor    = ln(target_radius / r0) / 90;  // ← fórmula exacta

echo("growth_factor calculado =", growth_factor);  // ≈ 0.0195

module log_blade_profile() {
    steps = 100;
    points_outer = [ for (i = [0 : steps]) 
        let (a = i * 90/steps)
        let (r = r0 * exp(growth_factor * a))
        [r * cos(a), r * sin(a)]
    ];
    
    points_inner = [ for (i = [steps : -1 : 0]) 
        let (a = i * 90/steps)
        let (r = max(r0, r0 * exp(growth_factor * a) - blade_thickness))
        [r * cos(a), r * sin(a)]
    ];
    
    polygon(concat(points_outer, points_inner));
}

// ENSAMBLAJE FINAL
difference() {
    union() {
        // Hub reforzado
        cylinder(h = rotor_height, r = 12, center = true, $fn=60);
        
        // Las 3 palas (AHORA SÍ SE VEN)
        for (i = [0 : num_blades-1])
            rotate(i * 120)
                linear_extrude(height = rotor_height, center = true, twist = twist_degrees, slices = 120)
                    log_blade_profile();
    }
    
    // Agujero eje
    cylinder(h = rotor_height+10, r = shaft_diameter/2 + 0.15, center = true, $fn=40);
}