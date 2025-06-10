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
</section>

<style>
.hero-articulo {
  display: flex;
  flex-direction: column;
  background: #fff;
  border-radius: 18px;
  box-shadow: 0 8px 32px rgba(44,85,48,0.09);
  overflow: hidden;
  margin-bottom: 32px;
  position: relative;
}
.hero-imagen {
  display: block;
  margin: 0 auto;
  width: 100%;
  max-width: 720px;
  max-height: 340px;
  object-fit: cover;
  border-radius: 22px 22px 0 0;
  box-shadow: 0 4px 18px rgba(44,85,48,0.13);
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
