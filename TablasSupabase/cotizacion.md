<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Propuesta Amazon Camp - Desarrollo Web</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            background: linear-gradient(135deg, #2c5530 0%, #1a4d1f 100%);
            min-height: 100vh;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .header {
            text-align: center;
            color: white;
            margin-bottom: 40px;
            animation: fadeInDown 1s ease-out;
        }

        .header h1 {
            font-size: 3.5rem;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
            background: linear-gradient(45deg, #4CAF50, #8BC34A);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .header p {
            font-size: 1.3rem;
            opacity: 0.9;
            margin-bottom: 10px;
        }

        .header .date {
            font-size: 1rem;
            opacity: 0.8;
            font-style: italic;
        }

        .packages-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(380px, 1fr));
            gap: 30px;
            margin-bottom: 40px;
        }

        .package-card {
            background: white;
            border-radius: 20px;
            padding: 35px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.8s ease-out;
        }

        .package-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 25px 50px rgba(0,0,0,0.2);
        }

        .package-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 6px;
            background: linear-gradient(90deg, #4CAF50, #8BC34A);
        }

        .package-basic::before {
            background: linear-gradient(90deg, #3498db, #5dade2);
        }

        .package-medium::before {
            background: linear-gradient(90deg, #f39c12, #f7dc6f);
        }

        .package-advanced::before {
            background: linear-gradient(90deg, #e74c3c, #ec7063);
        }

        .package-header {
            text-align: center;
            margin-bottom: 25px;
        }

        .package-title {
            font-size: 2rem;
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .package-price {
            font-size: 3rem;
            font-weight: bold;
            color: #27ae60;
            margin-bottom: 10px;
        }

        .package-savings {
            background: #e8f5e8;
            color: #27ae60;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: bold;
            display: inline-block;
            margin-bottom: 15px;
        }

        .package-objective {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 25px;
            border-left: 4px solid #4CAF50;
        }

        .package-objective h3 {
            color: #2c3e50;
            margin-bottom: 12px;
            font-size: 1.2rem;
        }

        .package-objective p {
            font-size: 1.05rem;
            line-height: 1.7;
        }

        .features-list {
            list-style: none;
            margin-bottom: 25px;
        }

        .features-list li {
            padding: 15px 0;
            border-bottom: 1px solid #ecf0f1;
            position: relative;
            padding-left: 35px;
            transition: all 0.3s ease;
            font-size: 1.05rem;
        }

        .features-list li:hover {
            background: #f8f9fa;
            padding-left: 40px;
        }

        .features-list li::before {
            content: '✓';
            position: absolute;
            left: 10px;
            color: #27ae60;
            font-weight: bold;
            font-size: 1.3rem;
        }

        .features-list li strong {
            color: #2c3e50;
        }

        .benefits-section {
            background: #e8f4f8;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 20px;
        }

        .benefits-section h3 {
            color: #2c3e50;
            margin-bottom: 15px;
            font-size: 1.3rem;
        }

        .benefits-section ul {
            list-style: none;
        }

        .benefits-section ul li {
            padding: 8px 0;
            padding-left: 25px;
            position: relative;
        }

        .benefits-section ul li::before {
            content: '💡';
            position: absolute;
            left: 0;
        }

        .maintenance-info {
            background: #fff3cd;
            padding: 25px;
            border-radius: 15px;
            border: 2px solid #ffeaa7;
            margin-bottom: 20px;
        }

        .maintenance-info h3 {
            color: #856404;
            margin-bottom: 15px;
            font-size: 1.2rem;
        }

        .maintenance-info p {
            margin-bottom: 8px;
            font-size: 1.05rem;
        }

        .delivery-time {
            background: #d4edda;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            font-weight: bold;
            color: #155724;
            font-size: 1.1rem;
        }

        .ready-badge {
            background: #28a745;
            color: white;
            padding: 10px 20px;
            border-radius: 25px;
            font-size: 0.9rem;
            font-weight: bold;
            display: inline-block;
            margin-bottom: 15px;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        .value-proposition {
            background: #e8f5e8;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 25px;
            border: 2px solid #4CAF50;
        }

        .value-proposition h3 {
            color: #27ae60;
            margin-bottom: 15px;
            font-size: 1.3rem;
        }

        .value-proposition ul {
            list-style: none;
        }

        .value-proposition ul li {
            padding: 10px 0;
            padding-left: 30px;
            position: relative;
            font-size: 1.05rem;
        }

        .value-proposition ul li::before {
            content: '🎯';
            position: absolute;
            left: 0;
        }

        .comparison-table {
            background: white;
            border-radius: 20px;
            padding: 40px;
            margin: 40px 0;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            animation: fadeInUp 1s ease-out;
        }

        .comparison-table h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
            font-size: 2.2rem;
        }

        .table-responsive {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        th, td {
            padding: 18px;
            text-align: left;
            border-bottom: 2px solid #ecf0f1;
            font-size: 1.05rem;
        }

        th {
            background: linear-gradient(135deg, #2c5530, #1a4d1f);
            color: white;
            font-weight: bold;
            font-size: 1.1rem;
        }

        td {
            background: #f8f9fa;
        }

        .price-cell {
            font-weight: bold;
            color: #27ae60;
            font-size: 1.2rem;
        }

        .recommendation-section {
            background: white;
            border-radius: 20px;
            padding: 40px;
            margin: 40px 0;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            animation: fadeInUp 1.2s ease-out;
        }

        .recommendation-section h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
            font-size: 2.2rem;
        }

        .recommendation-item {
            margin-bottom: 30px;
            padding: 25px;
            background: #f8f9fa;
            border-radius: 15px;
            border-left: 6px solid #4CAF50;
        }

        .recommendation-item h3 {
            color: #2c3e50;
            margin-bottom: 15px;
            font-size: 1.4rem;
        }

        .recommendation-item p {
            font-size: 1.1rem;
            line-height: 1.7;
        }

        .why-choose-section {
            background: white;
            border-radius: 20px;
            padding: 40px;
            margin: 40px 0;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
        }

        .why-choose-section h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
            font-size: 2.2rem;
        }

        .why-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
        }

        .why-item {
            text-align: center;
            padding: 25px;
            background: #f8f9fa;
            border-radius: 15px;
        }

        .why-item .icon {
            font-size: 3rem;
            margin-bottom: 15px;
        }

        .why-item h3 {
            color: #2c3e50;
            margin-bottom: 15px;
            font-size: 1.3rem;
        }

        .cta-section {
            text-align: center;
            background: white;
            border-radius: 20px;
            padding: 50px;
            margin: 40px 0;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
        }

        .cta-section h2 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-size: 2.2rem;
        }

        .cta-button {
            display: inline-block;
            background: linear-gradient(135deg, #2c5530, #1a4d1f);
            color: white;
            padding: 18px 45px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: bold;
            font-size: 1.2rem;
            transition: all 0.3s ease;
            margin: 15px;
        }

        .cta-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(44, 85, 48, 0.4);
        }

        .download-section {
            position: fixed;
            bottom: 30px;
            right: 30px;
            z-index: 1000;
        }

        .download-button {
            background: #27ae60;
            color: white;
            border: none;
            border-radius: 50px;
            padding: 18px 30px;
            font-size: 1.1rem;
            cursor: pointer;
            box-shadow: 0 5px 15px rgba(39, 174, 96, 0.4);
            transition: all 0.3s ease;
            font-weight: bold;
        }

        .download-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(39, 174, 96, 0.6);
            background: #219a52;
        }

        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .package-card:nth-child(1) { animation-delay: 0.2s; }
        .package-card:nth-child(2) { animation-delay: 0.4s; }
        .package-card:nth-child(3) { animation-delay: 0.6s; }

        @media (max-width: 768px) {
            .header h1 {
                font-size: 2.5rem;
            }
            
            .package-price {
                font-size: 2.2rem;
            }
            
            .packages-grid {
                grid-template-columns: 1fr;
            }
            
            .download-section {
                bottom: 20px;
                right: 20px;
            }
        }

        @media print {
            body {
                background: white;
            }
            
            .download-section {
                display: none;
            }
            
            .package-card {
                break-inside: avoid;
                page-break-inside: avoid;
            }
        }

        .contact-info {
            background: linear-gradient(135deg, #2c5530, #1a4d1f);
            color: white;
            padding: 30px;
            border-radius: 20px;
            margin: 40px 0;
            text-align: center;
        }

        .contact-info h3 {
            margin-bottom: 20px;
            font-size: 1.5rem;
        }

        .contact-info p {
            margin-bottom: 10px;
            font-size: 1.1rem;
        }
    </style>
</head>
<body>
    <div class="container" id="content">
        <div class="header">
            <h1>🌿 AMAZON CAMP</h1>
            <p>Propuesta Profesional de Desarrollo Web y Marketing Digital</p>
            <div class="date">Propuesta válida hasta: 30 días | Junio 2025</div>
        </div>

        <div class="packages-grid">
            <!-- Paquete Básico -->
            <div class="package-card package-basic">
                <div class="ready-badge">✅ 95% COMPLETADO - LISTO PARA IMPLEMENTAR</div>
                
                <div class="package-header">
                    <h2 class="package-title">Paquete Básico</h2>
                    <div class="package-price">$300 USD</div>
                    <div class="package-savings">Ahorro: $200 USD vs desarrollo desde cero</div>
                </div>

                <div class="package-objective">
                    <h3>🎯 Objetivo Específico:</h3>
                    <p>Lanzar Amazon Camp al mercado digital de forma inmediata con una plataforma web completamente funcional que permita gestionar reservas, crear paquetes turísticos y recibir notificaciones automáticas, todo en menos de 2 días.</p>
                </div>

                <div class="value-proposition">
                    <h3>💎 Valor Agregado Inmediato:</h3>
                    <ul>
                        <li>Plataforma ya desarrollada al 95% - Solo faltan detalles finales</li>
                        <li>Acceso inmediato al panel de administración</li>
                        <li>Sistema probado y optimizado</li>
                        <li>Reducción de tiempo de desarrollo de 2 semanas a 2 días</li>
                    </ul>
                </div>

                <h3>📋 Funcionalidades Técnicas Incluidas:</h3>
                <ul class="features-list">
                    <li><strong>Frontend Responsivo Personalizado:</strong> Diseño único para Amazon Camp con optimización mobile-first, carga rápida y experiencia de usuario premium</li>
                    <li><strong>Sistema CMS Personalizado:</strong> Panel administrativo intuitivo donde podrás crear, editar y eliminar paquetes con subida de imágenes, descripciones detalladas y precios</li>
                    <li><strong>Motor de Reservas Avanzado:</strong> Formulario inteligente con validación automática, calendario de disponibilidad y confirmación instantánea</li>
                    <li><strong>Integración WhatsApp Business API:</strong> Notificaciones automáticas con todos los detalles de la reserva, datos del cliente y información del paquete</li>
                    <li><strong>Base de Datos Segura:</strong> Sistema de almacenamiento con respaldos automáticos, cifrado de datos y acceso controlado</li>
                    <li><strong>Dashboard de Gestión:</strong> Vista general de reservas, estadísticas básicas y herramientas de administración</li>
                    <li><strong>Optimización SEO Básica:</strong> Meta tags, estructura optimizada y velocidad de carga mejorada</li>
                    <li><strong>Hosting Premium Incluido:</strong> Servidor optimizado, SSL certificado y dominio configurado</li>
                </ul>

                <div class="benefits-section">
                    <h3>💡 Beneficios Comerciales Inmediatos:</h3>
                    <ul>
                        <li>Comenzar a recibir reservas online en 48 horas</li>
                        <li>Reducir tiempo de gestión manual en 70%</li>
                        <li>Mejorar imagen profesional y credibilidad</li>
                        <li>Acceso 24/7 desde cualquier dispositivo</li>
                        <li>Organización automática de información de clientes</li>
                    </ul>
                </div>

                <div class="maintenance-info">
                    <h3>🔧 Soporte y Mantenimiento:</h3>
                    <p><strong>Costo Mensual:</strong> $50 USD</p>
                    <p><strong>Incluye:</strong> Actualizaciones de seguridad, respaldos automáticos, soporte técnico por email, ajustes menores</p>
                    <p><strong>Garantía:</strong> 30 días de soporte completo sin costo adicional</p>
                </div>

                <div class="delivery-time">
                    ⚡ IMPLEMENTACIÓN INMEDIATA: Solo 1-2 días para personalización final y entrega de accesos
                </div>
            </div>

            <!-- Paquete Medio -->
            <div class="package-card package-medium">
                <div class="package-header">
                    <h2 class="package-title">Paquete Medio</h2>
                    <div class="package-price">$625 USD</div>
                    <div class="package-savings">Ahorro: $375 USD vs desarrollo independiente</div>
                </div>

                <div class="package-objective">
                    <h3>🎯 Objetivo Estratégico:</h3>
                    <p>Automatizar completamente el proceso de reservas y pagos de Amazon Camp, eliminando la intervención manual y proporcionando herramientas profesionales de gestión tipo Google Calendar para maximizar la eficiencia operativa.</p>
                </div>

                <div class="value-proposition">
                    <h3>🚀 Transformación Digital Completa:</h3>
                    <ul>
                        <li>Eliminación del 90% del trabajo manual</li>
                        <li>Pagos automáticos las 24 horas</li>
                        <li>Sistema de gestión nivel empresarial</li>
                        <li>Experiencia de cliente premium</li>
                    </ul>
                </div>

                <h3>📋 Funcionalidades Avanzadas:</h3>
                <ul class="features-list">
                    <li><strong>Todo del Paquete Básico Mejorado</strong></li>
                    <li><strong>Gateway de Pagos Múltiples:</strong> Integración completa con MercadoPago, PayU, Stripe y PayPal con procesamiento automático y confirmación instantánea</li>
                    <li><strong>Sistema de Reservas Inteligente:</strong> Automatización completa desde la selección hasta la confirmación, sin intervención manual</li>
                    <li><strong>Panel Google Calendar Integrado:</strong> Sincronización bidireccional con Google Calendar + panel personalizado con vista mensual, semanal y diaria</li>
                    <li><strong>Gestión Automática de Inventario:</strong> Control de disponibilidad en tiempo real, bloqueo automático de fechas ocupadas</li>
                    <li><strong>Sistema de Usuarios Completo:</strong> Cuentas personalizadas para clientes con historial de reservas, descargas de comprobantes y perfil personalizado</li>
                    <li><strong>Notificaciones Multicapa:</strong> Email automático + WhatsApp + SMS con confirmaciones, recordatorios y seguimiento</li>
                    <li><strong>Reportes Financieros:</strong> Dashboard con ingresos, reservas por período, clientes frecuentes y análisis de tendencias</li>
                </ul>

                <div class="benefits-section">
                    <h3>💡 Impacto en el Negocio:</h3>
                    <ul>
                        <li>Aumento del 40% en conversión de visitantes a clientes</li>
                        <li>Reducción del 90% en tiempo de gestión administrativa</li>
                        <li>Funcionamiento 24/7 sin supervisión</li>
                        <li>Mejora significativa en experiencia del cliente</li>
                        <li>Escalabilidad para crecimiento futuro</li>
                    </ul>
                </div>

                <div class="maintenance-info">
                    <h3>🔧 Mantenimiento Profesional:</h3>
                    <p><strong>Costo Mensual:</strong> $250 USD</p>
                    <p><strong>Incluye:</strong> Monitoreo de automatizaciones, optimización de rendimiento, actualizaciones de integraciones de pago, soporte prioritario, reportes mensuales</p>
                </div>

                <div class="delivery-time">
                    🔄 DESARROLLO: 1 semana para integración completa de automatizaciones
                </div>
            </div>

            <!-- Paquete Avanzado -->
            <div class="package-card package-advanced">
                <div class="package-header">
                    <h2 class="package-title">Paquete Avanzado</h2>
                    <div class="package-price">$925 USD</div>
                    <div class="package-savings">ROI Estimado: 300% en los primeros 6 meses</div>
                </div>

                <div class="package-objective">
                    <h3>🎯 Objetivo de Crecimiento:</h3>
                    <p>Escalar Amazon Camp como líder en turismo digital mediante marketing automatizado, SEO profesional y campañas publicitarias optimizadas para maximizar la adquisición de clientes y el crecimiento exponencial del negocio.</p>
                </div>

                <div class="value-proposition">
                    <h3>📈 Estrategia de Crecimiento 360°:</h3>
                    <ul>
                        <li>Campaña publicitaria profesional gestionada</li>
                        <li>Posicionamiento orgánico automatizado</li>
                        <li>Optimización continua basada en datos</li>
                        <li>Escalabilidad para mercados internacionales</li>
                    </ul>
                </div>

                <h3>📋 Suite de Marketing Digital Completa:</h3>
                <ul class="features-list">
                    <li><strong>Todo del Paquete Medio Optimizado</strong></li>
                    <li><strong>Gestión Publicitaria Facebook/Instagram:</strong> Creación, optimización y gestión completa de campañas con segmentación avanzada, pruebas A/B y optimización diaria</li>
                    <li><strong>Presupuesto Publicitario Recomendado:</strong> $300-500 USD mensuales gestionados profesionalmente para máximo ROI</li>
                    <li><strong>Optimización de Conversión CRO:</strong> Análisis de comportamiento, heat maps, pruebas de conversión y optimización continua</li>
                    <li><strong>Sistema de Analytics Avanzado:</strong> Google Analytics 4, Facebook Pixel, seguimiento de conversiones y reportes detallados semanales</li>
                    <li><strong>Automatización de Contenido SEO:</strong> Generación automática de artículos optimizados, blog integrado y estrategia de palabras clave</li>
                    <li><strong>Email Marketing Automatizado:</strong> Secuencias de seguimiento, newsletters, recuperación de carritos abandonados</li>
                    <li><strong>Soporte Premium 24/7:</strong> Chat directo, llamadas de estrategia mensual, consultoría de crecimiento</li>
                    <li><strong>Integración CRM:</strong> Sistema de gestión de clientes potenciales y seguimiento de pipeline de ventas</li>
                </ul>

                <div class="benefits-section">
                    <h3>💡 Resultados Esperados (3-6 meses):</h3>
                    <ul>
                        <li>Aumento del 200-400% en tráfico web cualificado</li>
                        <li>Incremento del 150% en reservas mensuales</li>
                        <li>Mejora del 60% en tasa de conversión</li>
                        <li>Posicionamiento en top 3 de Google para palabras clave principales</li>
                        <li>Base de datos de clientes potenciales automatizada</li>
                    </ul>
                </div>

                <div class="maintenance-info">
                    <h3>🔧 Gestión Integral Mensual:</h3>
                    <p><strong>Costo Total:</strong> $400 USD mensuales</p>
                    <p><strong>Desglose:</strong></p>
                    <p>• $250 USD - Mantenimiento técnico y automatizaciones</p>
                    <p>• $150 USD - Gestión profesional de campañas publicitarias</p>
                    <p><strong>Incluye:</strong> Reportes semanales, optimización continua, consultoría estratégica, ajustes basados en rendimiento</p>
                </div>

                <div class="delivery-time">
                    🚀 LANZAMIENTO COMPLETO: 10 días para configuración integral y lanzamiento de campañas
                </div>
            </div>
        </div>

        <!-- Tabla Comparativa Mejorada -->
        <div class="comparison-table">
            <h2>📊 Comparativo de Inversión y Valor</h2>
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Característica</th>
                            <th>Básico - $300</th>
                            <th>Medio - $625</th>
                            <th>Avanzado - $925</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><strong>Sitio Web Profesional</strong></td>
                            <td>✅ Completo</td>
                            <td>✅ Completo</td>
                            <td>✅ Optimizado</td>
                        </tr>
                        <tr>
                            <td><strong>Sistema de Reservas</strong></td>
                            <td>✅ Manual</td>
                            <td>✅ Automático</td>
                            <td>✅ Inteligente</td>
                        </tr>
                        <tr>
                            <td><strong>Pagos Online</strong></td>
                            <td>❌ No incluido</td>
                            <td>✅ Múltiples gateways</td>
                            <td>✅ Optimizado</td>
                        </tr>
                        <tr>
                            <td><strong>Marketing Digital