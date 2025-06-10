<script>
  import { onMount } from 'svelte';
  import { page } from '$app/stores';
  import { supabase } from '$lib/../supabaseClient.js';
  import HeroArticulo from '$lib/components/Admin/blog/Articulos/HeroArticulo.svelte';
// Se usará bind:contenidoConIds para obtener el HTML procesado con IDs de encabezado
let contenidoConIds = '';
  import SidebarArticulo from '$lib/components/Admin/blog/Articulos/SidebarArticulo.svelte';

  let articulo = null;
  let cargando = true;
  let error = '';
  let recientes = [];
  let destacados = [];
  $: slug = $page.params.slug;

  // Función para embeber videos de YouTube en el contenido
  function embedYouTube(html) {
    if (!html) return '';
    return html.replace(/https?:\/\/(www\.)?(youtube\.com\/watch\?v=|youtu\.be\/)([\w-]{11})/g, (match, _, __, videoId) => {
      return `<div class='youtube-embed'><iframe width='100%' height='340' src='https://www.youtube.com/embed/${videoId}' title='YouTube video' frameborder='0' allowfullscreen></iframe></div>`;
    });
  }

  onMount(async () => {
    cargando = true;
    error = '';
    articulo = null;
    try {
      // Obtener el artículo principal
      const { data: art, error: errorArt } = await supabase
        .from('blog_articulos')
        .select('*')
        .eq('slug', slug)
        .eq('estado', 'publicado')
        .single();
      if (errorArt || !art) {
        error = 'No se encontró el artículo.';
      } else {
        articulo = art;
      }
      // Obtener artículos recientes
      const { data: recs } = await supabase
        .from('blog_articulos')
        .select('titulo, slug, imagen_url, creado_en')
        .eq('estado', 'publicado')
        .order('creado_en', { ascending: false })
        .limit(5);
      recientes = recs?.filter(a => a.slug !== slug) || [];
      // Obtener destacados (puedes mejorar la lógica)
      destacados = recientes.slice(0, 3);
    } catch (e) {
      error = 'Error al cargar los datos.';
    }
    cargando = false;
  });
</script>

<main class="pagina-articulo-blog">
  {#if cargando}
    <div class="cargando">Cargando artículo...</div>
  {:else if error}
    <div class="error">{error}</div>
  {:else if articulo}
    <div class="layout-articulo">
      <section class="principal-articulo">
        <HeroArticulo
          titulo={articulo.titulo}
          autor={articulo.autor}
          fecha={articulo.creado_en}
          imagen_url={articulo.imagen_url}
          resumen={articulo.resumen}
          contenidoHtml={articulo.contenido}
          bind:contenidoConIds
        />
        <article class="contenido-articulo-blog">
  {@html embedYouTube(contenidoConIds)}
</article>
      </section>
      <SidebarArticulo {recientes} {destacados} />
    </div>
  {/if}
</main>

<style>
.pagina-articulo-blog {
  width: 100%;
  min-height: 100vh;
  background: #f6faf7;
}
.layout-articulo {
  display: flex;
  flex-direction: row;
  align-items: flex-start;
  justify-content: center;
  max-width: 1600px;
  margin: 0 auto;
  padding: 36px 18px 60px 18px;
  gap: 38px;
}
.principal-articulo {
  flex: 1;
  min-width: 0;
}
.contenido-articulo-blog {
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 2px 12px rgba(44,85,48,0.06);
  padding: 32px 28px;
  margin-top: 18px;
  font-size: 1.13rem;
  color: #333;
  line-height: 1.7;
  word-break: break-word;
  overflow-wrap: anywhere;
}
.cargando, .error {
  text-align: center;
  margin-top: 80px;
  font-size: 1.2rem;
  color: #2c5530;
}
@media (max-width: 900px) {
  .layout-articulo {
    flex-direction: column;
    gap: 24px;
    padding: 18px 4vw;
  }
}
</style>

