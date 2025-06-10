<script>
  
  import HeroSlider from '$lib/components/ComponentesHome/HeroSlider.svelte';
import PaquetesDestacados from '$lib/components/ComponentesHome/PaquetesDestacados.svelte';
import BeneficiosAmazonCamp from '$lib/components/ComponentesHome/BeneficiosAmazonCamp.svelte';
import TestimoniosClientes from '$lib/components/ComponentesHome/TestimoniosClientes.svelte';
import ProcesoReservaAnimado from '$lib/components/ComponentesHome/ProcesoReservaAnimado.svelte';
import CtaFinalWhatsapp from '$lib/components/ComponentesHome/CtaFinalWhatsapp.svelte';
import FormularioReservaResponsive from '$lib/components/ComponentesHome/FormularioReservaResponsive.svelte';
import WhatsappFlotante from '$lib/components/OtrosNecesarios/WhatsappFlotante.svelte';
import { onMount } from 'svelte';

let anchoPantalla = 1200;
function actualizarAnchoPantalla() {
  anchoPantalla = window.innerWidth;
}
onMount(() => {
  actualizarAnchoPantalla();
  window.addEventListener('resize', actualizarAnchoPantalla);
});
</script>

<!-- Nuevo Hero2Slider para desarrollo paso a paso -->
<div class="hero-contenedor">
  <HeroSlider />
  <!-- Formulario de reserva rápido y funcional -->
  <FormularioReservaResponsive />
</div>

<PaquetesDestacados />



 
<!-- Beneficios diferenciales de Amazon Camp -->
<BeneficiosAmazonCamp />
<!-- <BeneficiosAmazonCamp /> -->


<!-- Testimonios de clientes -->
<TestimoniosClientes />

<!-- Proceso de reserva animado -->
<ProcesoReservaAnimado />

<!-- Galería visual de experiencias -->
<!-- <GaleriaVisual /> -->



<!-- Preguntas frecuentes -->
<!-- <PreguntasFrecuentes /> -->

<!-- CTA final y WhatsApp -->
<!-- <LlamadoAccionFinal /> -->

<CtaFinalWhatsapp />

<!-- Pie de página -->
<!-- <PieDePagina /> -->

<style>

</style>

<WhatsappFlotante telefono="573228176411" mensaje="¡Hola! Necesito ayuda con un paquete o reserva." />
