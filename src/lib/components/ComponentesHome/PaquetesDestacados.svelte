<script>
  import { onMount } from 'svelte';
  import { supabase } from '$lib/../supabaseClient.js';

  let paquetes = [];
  let cargando = true;
  let error = '';

  // Al montar el componente, obtener los paquetes reales desde Supabase
  onMount(async () => {
    cargando = true;
    error = '';
    const { data, error: errorSupabase } = await supabase
      .from('paquetes')
      .select('*')
      .order('creado_en', { ascending: false });
    console.log('PAQUETES DESDE SUPABASE:', data);
    if (errorSupabase) {
      error = 'No se pudieron cargar los paquetes.';
      paquetes = [];
    } else {
      paquetes = (data || []).map(paquete => ({
        slug: paquete.slug || '',
        nombre: paquete.titulo || '',
        incluye: (typeof paquete.incluye === 'string' ? paquete.incluye.split('\n').map(s => s.trim()).filter(Boolean) :
        Array.isArray(paquete.incluye) ? paquete.incluye : []).slice(0, 3),
        duracion: paquete.duracion || '',
        descripcion_corta: paquete.descripcion_corta || '',

        precio: paquete.precio_desde ? `Desde ${paquete.precio_desde} USD` : '',
        imagen: paquete.imagen_principal || 'https://via.placeholder.com/400x225?text=Sin+imagen',
      }));
    }
    cargando = false;
  });

  // Función para recortar texto
  function recortar(texto, max) {
    if (!texto) return '';
    return texto.length > max ? texto.slice(0, max).trim() + '...' : texto;
  }
</script>

{#if cargando}
  <div class="text-center py-10 text-orange-500 font-bold">Cargando paquetes...</div>
{:else if error}
  <div class="text-center py-10 text-red-600 font-bold">{error}</div>
{:else if paquetes.length === 0}
  <div class="text-center py-10 text-gray-600 font-bold">No hay paquetes para mostrar.</div>
{/if}

<section class="py-16 relative bg-gradient-to-b from-orange-50 to-white">
  <img src="https://images.unsplash.com/photo-1464983953574-0892a716854b?auto=format&fit=crop&w=1200&q=80" alt="textura animales" class="absolute inset-0 w-full h-full object-cover opacity-20 pointer-events-none select-none" style="z-index:0;" />
  <div class="max-w-5xl mx-auto px-4">
    <h2 class="text-3xl md:text-4xl font-extrabold text-orange-600 mb-8 text-center animate-fade-in">
      ¡Descubre nuestros <span class="text-green-600">paquetes estrella</span>!
    </h2>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
      {#each paquetes.slice(0, 4) as paquete (paquete.slug)}
        <div class="relative bg-white rounded-2xl shadow-xl overflow-hidden group transform transition duration-300 hover:scale-105 animate-pop-in">
          <img src={paquete.imagen} alt={paquete.nombre} class="w-full h-56 object-cover group-hover:scale-110 transition duration-300" loading="lazy" />
          <div class="absolute inset-0 bg-black/30 opacity-0 group-hover:opacity-70 transition duration-300"></div>
          <div class="p-6 relative z-10">
            <h3 class="text-2xl font-bold text-orange-600 mb-2 drop-shadow animate-fade-in">{paquete.nombre}</h3>
            <ul class="mb-2 text-green-700 font-semibold text-sm flex flex-wrap gap-2 animate-fade-in">
              {#each paquete.incluye as item}
                <li class="bg-green-100 rounded-full px-3 py-1">{item}</li>
              {/each}
            </ul>
            <p class="text-sm text-gray-500 font-semibold mb-1">{paquete.duracion}</p>
            <p class="text-gray-800 mb-2 animate-fade-in">{recortar(paquete.descripcion_corta, 130)}</p>
            <div class="flex items-center justify-between">
              <span class="text-lg font-bold text-green-600 animate-fade-in">{paquete.precio}</span>
              <a href={`/paquetes/${paquete.slug}`} class="inline-block bg-orange-500 hover:bg-orange-600 text-white font-bold px-4 py-2 rounded-xl shadow transition animate-fade-in">
                Ver detalles
              </a>
            </div>
          </div>
        </div>
      {/each}
    </div>
    <div class="flex justify-center mt-10">
      <a href="/paquetes" class="bg-orange-100 hover:bg-orange-200 text-orange-700 font-bold px-8 py-3 rounded-full shadow-lg text-lg transition animate-fade-in">
        Ver todos los paquetes
      </a>
    </div>
  </div>
</section>

<style>
  .animate-fade-in {
    animation: fadeIn 0.7s cubic-bezier(.4,0,.2,1);
  }
  @keyframes fadeIn {
    from { opacity: 0; transform: translateY(24px) scale(0.98); }
    to { opacity: 1; transform: none; }
  }
  .animate-pop-in {
    animation: popIn 0.5s cubic-bezier(.4,0,.2,1);
  }
  @keyframes popIn {
    0% { transform: scale(0.92); opacity: 0; }
    70% { transform: scale(1.04); opacity: 1; }
    100% { transform: scale(1); opacity: 1; }
  }
  section {
    padding-top: 150px;
  }
</style>
