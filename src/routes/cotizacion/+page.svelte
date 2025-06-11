<script>
  // Paquetes y detalles
  const paquetes = [
    {
      nombre: 'Básico',
      precio: '$300 USD',
      cop: '$1.200.000 COP',
      descripcion: 'Tu sitio actual, listo para operar. Ideal para lanzar Amazon Camp al mundo digital en tiempo récord.',
      detalles: [
        'Frontend responsivo personalizado',
        'CMS fácil de usar para paquetes',
        'Reservas manuales y notificaciones WhatsApp',
        'Dashboard de gestión básica',
        'SEO básico y hosting premium',
        'Soporte técnico incluido 30 días',
      ],
      beneficios: [
        'Recibe reservas online ya mismo',
        'Reduce 70% la gestión manual',
        'Mejora tu imagen profesional',
        'Organiza clientes automáticamente',
      ],
      mantenimiento: 'Soporte y ajustes menores: $50 USD/mes',
      ideal: 'Para empezar y validar el negocio online. ¡Ya está implementado!'
    },
    {
      nombre: 'Medio',
      precio: '$625 USD',
      cop: '$2.500.000 COP',
      descripcion: 'Automatización total de reservas y pagos. Panel tipo Google Calendar y gestión avanzada.',
      detalles: [
        'Todo lo del Básico mejorado',
        'Pagos automáticos (MercadoPago, PayU, Stripe, PayPal)',
        'Reservas automáticas sin intervención manual',
        'Gestión de calendario y disponibilidad',
        'Panel Google Calendar integrado',
        'Usuarios con historial y reportes',
        'Notificaciones email, WhatsApp y SMS',
        'Dashboard financiero y de tendencias',
      ],
      beneficios: [
        'Aumenta 40% la conversión',
        'Reduce 90% el tiempo administrativo',
        'Operación 24/7 sin supervisión',
        'Escalabilidad asegurada',
      ],
      mantenimiento: 'Automatizaciones y soporte prioritario: $250 USD/mes',
      ideal: 'Para crecer y automatizar el negocio. ¡El siguiente paso inteligente!'
    },
    {
      nombre: 'Avanzado',
      precio: '$925 USD',
      cop: '$3.700.000 COP',
      descripcion: 'Marketing digital, SEO, campañas publicitarias y CRM. ¡Haz de Amazon Camp una referencia nacional!',
      detalles: [
        'Todo lo del Medio optimizado',
        'Gestión publicitaria profesional',
        'SEO avanzado y blog automatizado',
        'Optimización de conversión (CRO)',
        'Analytics y reportes semanales',
        'Email marketing automatizado',
        'Soporte premium 24/7',
        'CRM y consultoría de crecimiento',
      ],
      beneficios: [
        'Aumenta 200-400% el tráfico web',
        'Incrementa 150% las reservas',
        'Mejora 60% la conversión',
        'Posicionamiento top en Google',
      ],
      mantenimiento: 'Gestión integral y campañas: $400 USD/mes',
      ideal: 'Para liderar el mercado y escalar sin límites. ¡El verdadero salto digital!'
    }
  ];

  let modalActivo = null;
  function abrirModal(idx) { modalActivo = idx; }
  function cerrarModal() { modalActivo = null; }
</script>

<style>
  .intro {
    text-align: center;
    margin-bottom: 2rem;
    color: #155724;
    animation: fadeInDown 1s;
  }
  .comparativa {
    width: 100%;
    background: #f8f9fa;
    border-radius: 20px;
    box-shadow: 0 8px 32px rgba(44,85,48,0.08);
    overflow-x: auto;
    margin-bottom: 2.5rem;
    animation: fadeInUp 1s;
  }
  table {
    width: 100%;
    border-collapse: collapse;
    min-width: 700px;
  }
  th, td {
    padding: 1.1rem 1rem;
    text-align: center;
    border-bottom: 1px solid #e0e0e0;
    font-size: 1.08rem;
  }
  th {
    background: linear-gradient(90deg,#27ae60,#3498db);
    color: #fff;
    font-size: 1.15rem;
    border-radius: 20px 20px 0 0;
  }
  tr:last-child td { border-bottom: none; }
  .paquete-nombre {
    font-weight: bold;
    font-size: 1.15rem;
    color: #1a4d1f;
  }
  .btn-mas {
    background: linear-gradient(90deg,#27ae60,#3498db);
    color: #fff;
    border: none;
    border-radius: 50px;
    padding: 0.7rem 1.6rem;
    font-size: 1rem;
    cursor: pointer;
    transition: box-shadow .2s,transform .2s;
    box-shadow: 0 2px 8px rgba(52,152,219,0.11);
    margin-top: 0.5rem;
    margin-bottom: 0.5rem;
  }
  .btn-mas:hover {
    box-shadow: 0 6px 20px rgba(39,174,96,0.18);
    transform: translateY(-2px) scale(1.04);
  }
  @media (max-width: 800px) {
    table { min-width: 500px; }
    .intro { font-size: 1.1rem; }
  }
  /* Modal */
  .modal-bg {
    position: fixed; top: 0; left: 0; width: 100vw; height: 100vh;
    background: rgba(44,85,48,0.18);
    z-index: 1000;
    display: flex; align-items: center; justify-content: center;
    animation: fadeInBg .3s;
  }
  .modal {
    background: #fff;
    border-radius: 18px;
    box-shadow: 0 8px 32px rgba(44,85,48,0.18);
    padding: 2.2rem 1.7rem 1.7rem 1.7rem;
    max-width: 420px;
    width: 95vw;
    animation: popUp .4s;
    position: relative;
  }
  .modal h2 { color: #27ae60; margin-bottom: 0.5rem; font-size: 1.5rem; }
  .modal .precio { color: #3498db; font-weight: bold; font-size: 1.2rem; margin-bottom: 0.6rem; }
  .modal .cop { color: #1a4d1f; font-size: 1rem; margin-bottom: 0.8rem; }
  .modal ul { margin-bottom: 1.1rem; }
  .modal li { margin-bottom: 0.6rem; text-align: left; }
  .modal .beneficios, .modal .detalles {
    background: #e8f5e8;
    border-radius: 10px;
    padding: 0.8rem 1rem;
    margin-bottom: 1rem;
  }
  .modal .mantenimiento {
    background: #f0f7fa;
    border-radius: 10px;
    padding: 0.7rem 1rem;
    margin-bottom: 1rem;
    color: #155724;
  }
  .modal .ideal {
    background: #eaf7ed;
    color: #1a4d1f;
    border-left: 4px solid #27ae60;
    padding: 0.7rem 1rem;
    border-radius: 8px;
    font-weight: bold;
    margin-bottom: 1rem;
  }
  .modal .cerrar {
    position: absolute; top: 12px; right: 16px;
    background: none; border: none; font-size: 1.7rem; color: #3498db; cursor: pointer;
    transition: color .2s;
  }
  .modal .cerrar:hover { color: #27ae60; }
  @keyframes fadeInDown {
    from { opacity: 0; transform: translateY(-30px); }
    to { opacity: 1; transform: translateY(0); }
  }
  @keyframes fadeInUp {
    from { opacity: 0; transform: translateY(30px); }
    to { opacity: 1; transform: translateY(0); }
  }
  @keyframes fadeInBg {
    from { opacity: 0; } to { opacity: 1; }
  }
  @keyframes popUp {
    from { opacity: 0; transform: scale(0.85); }
    to { opacity: 1; transform: scale(1); }
  }
</style>

<div class="w-full flex flex-col items-center mt-6">
  <h1 class="text-3xl md:text-5xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-green-500 via-blue-500 to-green-400 animate-fade-in mb-2 drop-shadow-lg">
    Amazon Camp: ¡Lleva tu negocio al siguiente nivel!
  </h1>
  <p class="text-center max-w-2xl text-lg md:text-xl text-gray-700 mb-8 animate-slide-in">
    El sitio web básico ya está implementado.<br>
    Ahora elige el paquete ideal para <span class="text-blue-500 font-bold">automatizar, escalar y convertir Amazon Camp en un referente turístico digital</span>.<br>
    <span class="text-green-600 font-bold">¡Compara y descubre el verdadero valor de cada opción!</span>
  </p>
</div>

<div class="w-full flex flex-col md:flex-row gap-8 justify-center items-stretch px-2 md:px-0 mb-14 animate-fade-in-up">
  {#each paquetes as paquete, idx}
    <div class={`flex-1 rounded-3xl shadow-2xl border-4 border-transparent hover:scale-[1.03] transition-all duration-300 relative flex flex-col p-7 md:p-8 mb-6 md:mb-0 ${idx === 0 ? 'bg-gradient-to-br from-green-50 to-green-200' : idx === 1 ? 'bg-gradient-to-br from-blue-50 to-blue-200' : 'bg-gradient-to-br from-purple-50 to-blue-100'} ${idx === 1 ? 'z-10' : 'z-0'}`}
         style="min-width: 320px; max-width: 400px;">
      <div class={`absolute top-0 left-0 w-full h-2 rounded-t-3xl ${idx === 0 ? 'bg-gradient-to-r from-green-400 to-green-600' : idx === 1 ? 'bg-gradient-to-r from-blue-400 to-green-400' : 'bg-gradient-to-r from-purple-400 to-blue-600'}`}></div>
      <h2 class={`text-2xl font-bold mb-2 flex items-center gap-2 ${idx === 0 ? 'text-green-700' : idx === 1 ? 'text-blue-700' : 'text-purple-700'}`}> 
        {paquete.nombre}
        {#if idx === 0}
          <span class="ml-2 text-xs bg-green-200 text-green-800 rounded px-2 py-0.5 font-semibold animate-pulse">Implementado</span>
        {/if}
      </h2>
      <div class={`text-xl font-extrabold mb-1 ${idx === 0 ? 'text-green-600' : idx === 1 ? 'text-blue-600' : 'text-purple-700'}`}>{paquete.precio}</div>
      <div class={`text-base mb-2 ${idx === 0 ? 'text-green-800' : idx === 1 ? 'text-blue-800' : 'text-purple-800'}`}>{paquete.cop}</div>
      <div class="mb-3 text-gray-700 font-medium">{paquete.descripcion}</div>
      <ul class="mb-4 space-y-2">
        {#each paquete.beneficios as beneficio}
          <li class="flex items-center gap-2 font-semibold text-green-700">
            <svg class="w-5 h-5 text-green-400" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-7.414 7.414a1 1 0 01-1.414 0l-3.414-3.414a1 1 0 111.414-1.414l2.707 2.707 6.707-6.707a1 1 0 011.414 0z" clip-rule="evenodd" /></svg>
            {beneficio}
          </li>
        {/each}
      </ul>
      <div class="mb-3 text-sm text-gray-500">{paquete.mantenimiento}</div>
      <div class={`mb-5 text-xs font-bold rounded-lg p-2 ${idx === 0 ? 'bg-green-100 text-green-700' : idx === 1 ? 'bg-blue-100 text-blue-700' : 'bg-purple-100 text-purple-700'}`}>{paquete.ideal}</div>
      <button class={`w-full py-2 mt-auto rounded-full font-bold shadow-md transition-all duration-200 text-lg 
        ${idx === 0 ? 'bg-gradient-to-r from-green-400 to-green-600 text-white hover:from-green-500 hover:to-green-700' : idx === 1 ? 'bg-gradient-to-r from-blue-400 to-green-400 text-white hover:from-blue-500 hover:to-green-500' : 'bg-gradient-to-r from-purple-400 to-blue-600 text-white hover:from-purple-500 hover:to-blue-700'}`}
        on:click={() => abrirModal(idx)}>
        Más información
      </button>
    </div>
  {/each}
</div>

<!-- Modal -->
{#if modalActivo !== null}
  <div class="fixed inset-0 bg-black bg-opacity-40 flex items-center justify-center z-50 animate-fade-in" on:click={cerrarModal}>
    <div class="bg-white rounded-3xl shadow-2xl p-8 max-w-md w-[95vw] max-h-[90vh] overflow-y-auto relative animate-pop-up" on:click|stopPropagation tabindex="0" aria-modal="true" role="dialog">
      <button class="absolute top-4 right-4 text-2xl text-blue-400 hover:text-green-500 transition" on:click={cerrarModal} aria-label="Cerrar modal">&times;</button>
      <h2 class="text-2xl font-bold text-green-700 mb-2">{paquetes[modalActivo].nombre}</h2>
      <div class="text-xl font-extrabold text-blue-600 mb-1">{paquetes[modalActivo].precio}</div>
      <div class="text-base text-green-700 mb-2">{paquetes[modalActivo].cop}</div>
      <div class="mb-3 text-gray-700 font-medium">{paquetes[modalActivo].descripcion}</div>
      <div class="mb-2 font-bold text-green-700">¿Qué incluye?</div>
      <ul class="mb-4 space-y-2">
        {#each paquetes[modalActivo].detalles as detalle}
          <li class="flex items-center gap-2 text-gray-700">
            <svg class="w-4 h-4 text-green-400" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-7.414 7.414a1 1 0 01-1.414 0l-3.414-3.414a1 1 0 111.414-1.414l2.707 2.707 6.707-6.707a1 1 0 011.414 0z" clip-rule="evenodd" /></svg>
            {detalle}
          </li>
        {/each}
      </ul>
      <div class="mb-2 font-bold text-green-700">Beneficios clave</div>
      <ul class="mb-4 space-y-2">
        {#each paquetes[modalActivo].beneficios as beneficio}
          <li class="flex items-center gap-2 text-green-700 font-semibold">
            <svg class="w-4 h-4 text-blue-400" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-7.414 7.414a1 1 0 01-1.414 0l-3.414-3.414a1 1 0 111.414-1.414l2.707 2.707 6.707-6.707a1 1 0 011.414 0z" clip-rule="evenodd" /></svg>
            {beneficio}
          </li>
        {/each}
      </ul>
      <div class="mb-3 text-sm text-gray-500"><strong>Mantenimiento:</strong> {paquetes[modalActivo].mantenimiento}</div>
      <div class="mb-2 text-xs text-blue-600 font-bold bg-blue-50 rounded-lg p-2">{paquetes[modalActivo].ideal}</div>
    </div>
  </div>
{/if}
