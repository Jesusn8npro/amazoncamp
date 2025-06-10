<script>
  import { onMount } from 'svelte';
  import { page } from '$app/stores';
  import { supabase } from '$lib/../supabaseClient.js';
  import HeroPaquete from '$lib/components/LandingPagePaquetes/HeroPaquete.svelte';
import GaleriaPaquete from '$lib/components/LandingPagePaquetes/GaleriaPaquete.svelte';
import IncluyePaquete from '$lib/components/LandingPagePaquetes/IncluyePaquete.svelte';
import TestimoniosClientes from '$lib/components/ComponentesHome/TestimoniosClientes.svelte';
import BeneficiosExclusivos from '$lib/components/LandingPagePaquetes/BeneficiosExclusivos.svelte';

  let paquete = null;
  let cargando = true;
  let error = '';

  $: slug = $page.params.slug;

  // Extrae los parámetros de la URL de forma robusta
  $: searchParams = $page.url.searchParams;
  $: adultos = Number(searchParams.get('adultos')) > 0 ? Number(searchParams.get('adultos')) : (Number(searchParams.get('pasajeros')) || 1);
  $: ninos = Number(searchParams.get('ninos')) >= 0 ? Number(searchParams.get('ninos')) : 0;
  $: parejas = Number(searchParams.get('parejas')) >= 0 ? Number(searchParams.get('parejas')) : 0;
  $: fechaInicial = searchParams.get('fecha') || '';

  onMount(async () => {
    cargando = true;
    error = '';
    paquete = null;
    try {
      const { data, error: errorSupabase } = await supabase
        .from('paquetes')
        .select('*')
        .eq('slug', slug)
        .single();
      if (errorSupabase || !data) {
        error = 'No se encontró el paquete.';
      } else {
        paquete = data;
      }
    } catch (e) {
      error = 'Error al cargar el paquete.';
    }
    cargando = false;
  });
</script>

{#if cargando}
  <div>Cargando paquete...</div>
{:else if error}
  <div>{error}</div>
{:else}
  <HeroPaquete 
    {paquete}
    fechaInicial={fechaInicial}
    adultos={adultos}
    ninos={ninos}
    parejas={parejas}
  />

  <GaleriaPaquete imagenes={paquete.galeria ?? [paquete.imagen_principal ?? 'https://via.placeholder.com/800x600?text=Amazon+Camp']} />
  <IncluyePaquete incluye={paquete.incluye ?? [
    'Traslados aeropuerto/albergue',
    'Alojamiento en lodge',
    'Todas las comidas incluidas',
    'Excursiones y actividades',
    'Guía local experto',
    'Tours en bote',
    'Visita a comunidades nativas',
    'Seguro de viaje básico'
  ]} />

  <TestimoniosClientes />

  <BeneficiosExclusivos 
  beneficios={(paquete.beneficios && paquete.beneficios.length > 0) ? paquete.beneficios.slice(0,6) : [
    { icono: '🦜', titulo: 'Contacto directo con la naturaleza', descripcion: 'Vive la selva real, lejos de lo típico y cerca de la vida silvestre.' },
    { icono: '👨‍🏫', titulo: 'Guías expertos locales', descripcion: 'Acompañamiento de guías nativos apasionados y conocedores de cada rincón.' },
    { icono: '🌅', titulo: 'Experiencias únicas', descripcion: 'Actividades auténticas: avistamiento de fauna, talleres ancestrales y más.' },
    { icono: '🔒', titulo: 'Seguridad y comodidad', descripcion: 'Lodge seguro, transporte privado y atención personalizada 24/7.' }
  ]}
  tituloPaquete={paquete.titulo ?? 'Paquete'}
/>
{/if}
