<script lang="ts">
	import '../app.css';
	import MenuSuperior from '$lib/components/ComponentesHome/MenuSuperior.svelte';
	import { page } from '$app/stores';

	let { children } = $props();
</script>

{#if !$page.url.pathname.startsWith('/administrador')}
  <MenuSuperior />
{/if}

{@render children()}
