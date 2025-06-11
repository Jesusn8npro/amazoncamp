<script lang="ts">
	import '../app.css';
	import MenuSuperior from '$lib/components/ComponentesHome/MenuSuperior.svelte';
	import WhatsappFlotante from '$lib/components/OtrosNecesarios/WhatsappFlotante.svelte';
	import { page } from '$app/stores';

	let { children } = $props();
</script>

{#if !$page.url.pathname.startsWith('/administrador')}
  <MenuSuperior />
{/if}

<WhatsappFlotante telefono="573228176411" mensaje="¡Hola! Necesito ayuda con un paquete o reserva." />

{@render children()}
