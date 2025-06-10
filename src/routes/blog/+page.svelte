<script>
  import HeroBlog from '$lib/components/Admin/blog/HeroBlog.svelte';
  import TarjetaArticulo from '$lib/components/Admin/blog/TarjetaArticulo.svelte';
  import SidebarDerechaBlog from '$lib/components/Admin/blog/SidebarDerechaBlog.svelte';
  import { onMount } from 'svelte';
  import { supabase } from '$lib/../supabaseClient.js';

  let articulos = [];
  let cargando = true;
  let error = '';

  onMount(async () => {
    cargando = true;
    error = '';
    try {
      let { data, error: errorSupabase } = await supabase
        .from('blog_articulos')
        .select('*')
        .eq('estado', 'publicado')
        .order('creado_en', { ascending: false });
      if (errorSupabase) {
        error = 'Error al cargar los artículos.';
      } else {
        articulos = data;
      }
    } catch (e) {
      error = 'Error inesperado al cargar los artículos.';
    }
    cargando = false;
  });
</script>

<main class="pagina-blog">
  <HeroBlog />
  <div class="contenido-blog">
    <section class="listado-articulos">
      {#each articulos as articulo}
        <TarjetaArticulo {...articulo} />
      {/each}
    </section>
    <SidebarDerechaBlog />
  </div>
</main>

<style>
.pagina-blog {
  width: 100%;
  min-height: 100vh;
  background: #f6faf7;
}
.contenido-blog {
  display: flex;
  flex-direction: row;
  align-items: flex-start;
  justify-content: center;
  max-width: 1400px;
  margin: 0 auto;
  padding: 36px 18px 60px 18px;
  gap: 38px;
}
.listado-articulos {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
  gap: 30px;
  flex: 1;
}
@media (max-width: 900px) {
  .contenido-blog {
    flex-direction: column;
    gap: 24px;
    padding: 18px 4vw;
  }
  .listado-articulos {
    grid-template-columns: 1fr;
    gap: 18px;
  }
}
</style>
