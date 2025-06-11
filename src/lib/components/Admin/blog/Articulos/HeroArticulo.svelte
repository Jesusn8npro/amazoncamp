<script>
  export let titulo = 'Título del artículo';
  export let autor = 'Autor';
  export let fecha = '';
  export let imagen_url = '';
  export let resumen = '';
  export let contenidoHtml = '';

  // Procesa el HTML y agrega IDs únicos a los encabezados
  export let contenidoConIds = '';
  function agregarIdsAEncabezados(html) {
    if (!html || typeof window === 'undefined') return html;
    const parser = new DOMParser();
    const doc = parser.parseFromString(html, 'text/html');
    const headers = Array.from(doc.querySelectorAll('h2, h3'));
    if (headers.length < 2) return html;
    headers.forEach((h, i) => {
      if (!h.id) h.id = 'toc-h' + i;
    });
    return doc.body.innerHTML;
  }
  $: contenidoConIds = agregarIdsAEncabezados(contenidoHtml);

  // Extrae los encabezados como array reactivo para la TOC
  import { onMount } from 'svelte';
  let headers = [];
  $: {
    if (contenidoHtml && typeof window !== 'undefined') {
      const parser = new DOMParser();
      const doc = parser.parseFromString(contenidoHtml, 'text/html');
      headers = Array.from(doc.querySelectorAll('h2, h3')).map((h, i) => {
        if (!h.id) h.id = 'toc-h' + i;
        return {
          id: h.id,
          text: h.textContent,
          level: h.tagName,
        };
      });
    } else {
      headers = [];
    }
  }

</script>


<section class="hero-articulo">
  {#if imagen_url}
    <img class="hero-imagen" src={imagen_url} alt={titulo} loading="eager" />
  {/if}
  <div class="hero-contenido">
    <h1>{titulo}</h1>
    <div class="meta-autor">
      <span class="autor">{autor}</span>
      {#if fecha}
        <span class="fecha">· {new Date(fecha).toLocaleDateString('es-ES', { year: 'numeric', month: 'short', day: 'numeric' })}</span>
      {/if}
    </div>
    {#if resumen}
      <p class="resumen">{resumen}</p>
    {/if}
    <div class="botones-sociales">
      <button aria-label="Compartir en Facebook">👍</button>
      <button aria-label="Compartir en Twitter">🐦</button>
      <button aria-label="Compartir en WhatsApp">💬</button>
    </div>
    {#if headers.length >= 2}
      <nav class="toc">
        <div class="toc-titulo"><span class="toc-icono">📑</span> Tabla de Contenidos</div>
        <div class="toc-desc">Navega fácilmente por el contenido de este artículo.</div>
        <ul>
          {#each headers as h}
            <li class={h.level === 'H2' ? 'toc-h2' : 'toc-h3'}>
              <a href={'#' + h.id} on:click|preventDefault={() => {
                const el = document.getElementById(h.id);
                if (el) el.scrollIntoView({ behavior: 'smooth' });
              }}>
                {h.text}
              </a>
            </li>
          {/each}
        </ul>
      </nav>
    {/if}
  </div>
  <!-- Render HTML del artículo sin contenedor extra -->
</section>

<style>
:global(h1),
:global(h2),
:global(h3),
:global(p),
:global(ul),
:global(ol),
:global(li),
:global(blockquote),
:global(img),
:global(pre),
:global(code),
:global(strong),
:global(b) {
  font-family: 'Montserrat', 'Segoe UI', Arial, sans-serif;
  color: #232323;
  font-size: 1.09rem;
  line-height: 1.75;
  max-width: 100%;
  word-break: break-word;
  overflow-wrap: anywhere;
  box-sizing: border-box;
}
:global(h1) {
  font-size: 2.1rem;
  font-weight: 800;
  border-bottom: 2.5px solid #13b67a22;
  padding-bottom: 0.18em;
}
:global(h2) {
  font-size: 1.5rem;
  font-weight: 800;
  border-bottom: 2px solid #13b67a22;
  padding-bottom: 0.13em;
}
:global(h3) {
  font-size: 1.18rem;
  font-weight: 700;
  color: #1976d2;
}
:global(strong),
:global(b) {
  font-weight: bold;
  color: #222;
}
:global(p) {
  margin-bottom: 1.1em;
}
:global(ul) {
  margin-left: 2em;
  margin-bottom: 1.1em;
  padding-left: 1.2em;
  list-style-type: disc;
  list-style-position: inside;
}
:global(ul li)::marker {
  color: #13b67a;
  font-size: 1.15em;
}
:global(ol) {
  margin-left: 2em;
  margin-bottom: 1.1em;
  padding-left: 1.2em;
  list-style-type: decimal;
  list-style-position: inside;
}
:global(ol li)::marker {
  color: #1976d2;
  font-size: 1.1em;
}
:global(li) {
  margin-bottom: 0.45em;
}
:global(blockquote) {
  border-left: 4px solid #b6e7a0;
  background: #f8fff3;
  margin: 1.2em 0;
  padding: 0.9em 1.3em;
  color: #3a5c3c;
  font-style: italic;
  border-radius: 0 14px 14px 0;
}
:global(img) {
  display: block;
  margin: 20px auto;
  max-width: 100%;
  border-radius: 12px;
  box-shadow: 0 2px 12px #0001;
}
:global(pre) {
  background: #f4fcff;
  border-radius: 7px;
  padding: 1em;
  overflow-x: auto;
  margin-bottom: 1.2em;
}
:global(code) {
  background: #eafbe6;
  border-radius: 4px;
  padding: 0.15em 0.5em;
  font-size: 0.97em;
}
.hero-imagen {
  display: block;
  width: 100%;
  height: 400px;
  border-radius: 22px 22px 0 0;
  object-fit: cover;
  box-shadow: 0 4px 18px rgba(44,85,48,0.13);
  max-width: none;
  max-height: none;
}
.hero-contenido {
  padding: 36px 32px 22px 32px;
}
.hero-contenido h1 {
  font-size: 2.2rem;
  font-family: 'Montserrat', 'Segoe UI', Arial, sans-serif;
  margin-bottom: 12px;
  color: #2c5530;
}
.meta-autor {
  font-size: 1.02rem;
  color: #7a7a7a;
  margin-bottom: 14px;
}
.resumen {
  font-size: 1.08rem;
  color: #385c3c;
  margin-bottom: 18px;
  background: #f3fbe9;
  border-radius: 10px;
  padding: 10px 16px 10px 16px;
  max-height: 120px;
  overflow-y: auto;
  word-break: break-word;
  overflow-wrap: anywhere;
  box-shadow: 0 1px 8px #0001;
  line-height: 1.5;
  transition: box-shadow 0.18s;
}
.resumen:focus,
.resumen:hover {
  box-shadow: 0 2px 16px #13b67a33;
}
.botones-sociales {
  display: flex;
  gap: 12px;
}
.botones-sociales button {
  background: #eafbe6;
  border: none;
  border-radius: 50%;
  width: 38px;
  height: 38px;
  font-size: 1.4rem;
  cursor: pointer;
  transition: background 0.18s, transform 0.18s;
}
.botones-sociales button:hover {
  background: #4CAF50;
  color: #fff;
  transform: scale(1.13);
}
.toc {
  background: #f6fff1;
  border: 2px solid #b6e7a0;
  border-radius: 18px;
  box-shadow: 0 4px 18px #b5e3a326;
  padding: 22px 28px 16px 28px;
  margin: 28px 0 38px 0;
  max-width: 100%;
  font-size: 1.08rem;
  color: #215a2b;
  animation: toc-fadein 0.7s cubic-bezier(.39,.58,.57,1) both;
}
@keyframes toc-fadein {
  0% { opacity: 0; transform: translateY(24px); }
  100% { opacity: 1; transform: none; }
}
.toc-titulo {
  display: flex;
  align-items: center;
  font-weight: 800;
  font-size: 1.25rem;
  color: #2e7d32;
  margin-bottom: 7px;
  letter-spacing: 0.02em;
  text-shadow: 0 1px 0 #e2f7d1;
}
.toc-icono {
  font-size: 1.4em;
  margin-right: 9px;
  filter: drop-shadow(0 1px 0 #b6e7a0);
}
.toc-desc {
  font-size: 1.01rem;
  color: #548d5b;
  margin-bottom: 13px;
  font-family: 'Montserrat', 'Segoe UI', Arial, sans-serif;
  letter-spacing: 0.01em;
}
.toc ul {
  list-style: none;
  padding: 0;
  margin: 0;
}
.toc li {
  margin: 0;
  padding: 0;
  border-bottom: 1px solid #e0eeda;
  transition: background 0.18s;
  position: relative;
  min-height: 36px;
  display: flex;
  align-items: center;
}
.toc li:last-child {
  border-bottom: none;
}
.toc li::before {
  content: '';
  display: inline-block;
  width: 13px;
  height: 13px;
  background: radial-gradient(circle at 60% 40%, #7be07a 70%, #4caf50 100%);
  border-radius: 50%;
  margin-right: 13px;
  box-shadow: 0 1px 5px #a5e7a266;
  transition: transform 0.19s cubic-bezier(.39,.58,.57,1);
}
.toc-h3::before {
  margin-left: 18px;
  width: 10px;
  height: 10px;
  background: radial-gradient(circle at 60% 40%, #b8e8b6 60%, #8fdc7d 100%);
}
.toc a {
  display: block;
  width: 100%;
  padding: 8px 0 8px 0;
  color: #267a3c;
  text-decoration: none;
  border-radius: 7px;
  font-weight: 600;
  font-family: 'Montserrat', 'Segoe UI', Arial, sans-serif;
  transition: background 0.18s, color 0.18s, box-shadow 0.18s;
  outline: none;
  position: relative;
  z-index: 1;
}
.toc a:hover, .toc a:focus {
  background: #eafbe6;
  color: #1b4b24;
  box-shadow: 0 2px 10px #6edb8c22;
  font-size: 1.07em;
}
.toc-h2 > a {
  font-size: 1.08em;
  font-weight: 700;
}
.toc-h3 > a {
  font-size: 0.99em;
  font-weight: 400;
  margin-left: 18px;
}
@media (max-width: 700px) {
  .hero-contenido { padding: 18px 8vw 12px 8vw; }
  .hero-contenido h1 { font-size: 1.3rem; }
  .hero-imagen { min-height: 120px; }
  .toc {
    max-width: 100vw;
    padding: 13px 4vw 10px 4vw;
    font-size: 0.97rem;
  }
  .toc-titulo {
    font-size: 1.08rem;
  }
  .toc-desc {
    font-size: 0.96rem;
  }
}
</style>
