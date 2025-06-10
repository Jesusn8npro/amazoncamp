<script>
  import WhatsappFlotante from '$lib/components/OtrosNecesarios/WhatsappFlotante.svelte';
  let nombre = '';
  let email = '';
  let mensaje = '';
  let enviado = false;
  let error = '';

  function enviarFormulario(e) {
    e.preventDefault();
    if (!nombre || !email || !mensaje) {
      error = 'Por favor, completa todos los campos.';
      return;
    }
    // Aquí puedes agregar la lógica real de envío (API, email, etc.)
    enviado = true;
    error = '';
    nombre = '';
    email = '';
    mensaje = '';
  }
</script>

<style>
.contacto-hero {
  background: linear-gradient(120deg, #25d366 0%, #ffb347 100%);
  color: #fff;
  padding: 2.5rem 1.2rem 2rem 1.2rem;
  text-align: center;
  border-radius: 0 0 2.5rem 2.5rem;
  box-shadow: 0 4px 32px rgba(37,211,102,0.08);
  margin-bottom: 2rem;
  animation: fadeInDown 0.8s cubic-bezier(.6,-0.28,.74,.05);
}
@keyframes fadeInDown {
  from { opacity: 0; transform: translateY(-40px); }
  to { opacity: 1; transform: translateY(0); }
}
.contacto-hero h1 {
  font-size: 2.2rem;
  font-weight: bold;
  margin-bottom: 0.4rem;
  letter-spacing: 1px;
  text-shadow: 0 2px 8px #25d36633;
}
.contacto-hero p {
  font-size: 1.2rem;
  font-weight: 500;
  margin-bottom: 0.7rem;
}
.contacto-main {
  display: flex;
  flex-wrap: wrap;
  gap: 2.5rem;
  justify-content: center;
  align-items: flex-start;
  padding: 0 1.2rem 2rem 1.2rem;
  max-width: 1000px;
  margin: 0 auto;
}
.form-contacto {
  background: #fff;
  border-radius: 1.5rem;
  box-shadow: 0 2px 24px #25d36618;
  padding: 2rem 2.2rem 1.5rem 2.2rem;
  min-width: 320px;
  max-width: 400px;
  flex: 1 1 340px;
  display: flex;
  flex-direction: column;
  gap: 1.1rem;
  animation: aparecerForm 0.7s cubic-bezier(.6,-0.28,.74,.05);
}
@keyframes aparecerForm {
  from { opacity: 0; transform: scale(0.9); }
  to { opacity: 1; transform: scale(1); }
}
.form-contacto label {
  font-weight: 600;
  color: #25d366;
  margin-bottom: 0.2rem;
}
.form-contacto input,
.form-contacto textarea {
  border: 1.5px solid #25d36644;
  border-radius: 0.8rem;
  padding: 0.7rem 1rem;
  font-size: 1.05rem;
  outline: none;
  transition: border 0.2s;
  width: 100%;
  background: #f9f9f9;
}
.form-contacto input:focus,
.form-contacto textarea:focus {
  border: 1.5px solid #25d366;
}
.form-contacto textarea {
  min-height: 90px;
  resize: vertical;
}
.form-contacto button {
  background: linear-gradient(90deg, #25d366 60%, #ffb347 100%);
  color: #fff;
  font-weight: bold;
  font-size: 1.1rem;
  border: none;
  border-radius: 1.2rem;
  padding: 0.8rem 0;
  margin-top: 0.6rem;
  cursor: pointer;
  box-shadow: 0 2px 12px #25d36633;
  transition: background 0.2s, transform 0.2s;
  animation: pulseBtn 1.6s infinite;
}
.form-contacto button:hover {
  background: linear-gradient(90deg, #1da851 60%, #ffb347 100%);
  transform: scale(1.04);
}
@keyframes pulseBtn {
  0% { box-shadow: 0 0 0 0 #25d36644; }
  70% { box-shadow: 0 0 0 10px #25d36600; }
  100% { box-shadow: 0 0 0 0 #25d36600; }
}
.form-contacto .error {
  color: #e74c3c;
  font-weight: 500;
  margin-bottom: 0.3rem;
  text-align: center;
}
.form-contacto .exito {
  color: #25d366;
  font-weight: bold;
  text-align: center;
  margin-bottom: 0.3rem;
}
.contacto-datos {
  background: #fffbe6;
  border-radius: 1.5rem;
  box-shadow: 0 2px 12px #ffb34722;
  padding: 2rem 2.2rem 1.5rem 2.2rem;
  min-width: 280px;
  max-width: 350px;
  flex: 1 1 260px;
  display: flex;
  flex-direction: column;
  gap: 1.1rem;
  align-items: flex-start;
  animation: aparecerDatos 0.7s cubic-bezier(.6,-0.28,.74,.05);
}
@keyframes aparecerDatos {
  from { opacity: 0; transform: scale(0.9); }
  to { opacity: 1; transform: scale(1); }
}
.contacto-datos h2 {
  color: #d35400;
  font-size: 1.2rem;
  font-weight: bold;
  margin-bottom: 0.3rem;
}
.contacto-datos .dato {
  display: flex;
  align-items: center;
  gap: 0.7rem;
  font-size: 1.07rem;
  color: #444;
  margin-bottom: 0.2rem;
}
.contacto-datos .dato i {
  color: #25d366;
  font-size: 1.2rem;
}
@media (max-width: 900px) {
  .contacto-main {
    flex-direction: column;
    gap: 1.7rem;
    align-items: stretch;
  }
  .form-contacto,
  .contacto-datos {
    max-width: 100vw;
    min-width: 0;
  }
}
</style>

<div class="contacto-hero">
  <h1>¿Listo para vivir la <span style="color:#ffb347;">experiencia Amazon Camp</span>?</h1>
  <p>¡Nuestro equipo está listo para ayudarte a reservar, resolver dudas o crear tu viaje soñado!<br />
    Escríbenos y te responderemos lo más rápido posible.</p>
</div>

<div class="contacto-main">
  <form class="form-contacto" on:submit={enviarFormulario} autocomplete="off">
    {#if error}
      <div class="error">{error}</div>
    {/if}
    {#if enviado}
      <div class="exito">¡Mensaje enviado! Pronto te contactaremos.</div>
    {/if}
    <div>
      <label for="nombre">Nombre</label>
      <input id="nombre" type="text" bind:value={nombre} placeholder="Tu nombre completo" required />
    </div>
    <div>
      <label for="email">Email</label>
      <input id="email" type="email" bind:value={email} placeholder="tu@email.com" required />
    </div>
    <div>
      <label for="mensaje">Mensaje</label>
      <textarea id="mensaje" bind:value={mensaje} placeholder="¿En qué podemos ayudarte?" required></textarea>
    </div>
    <button type="submit">Enviar mensaje</button>
  </form>
  <div class="contacto-datos">
    <h2>¿Prefieres contacto directo?</h2>
    <div class="dato"><i class="fas fa-phone"></i> <a href="tel:+573228176411">+57 322 817 6411</a></div>
    <div class="dato"><i class="fab fa-whatsapp"></i> <a href="https://wa.me/573228176411" target="_blank">WhatsApp directo</a></div>
    <div class="dato"><i class="fas fa-envelope"></i> <a href="mailto:info@amazoncamp.net">info@amazoncamp.net</a></div>
    <div class="dato"><i class="fas fa-map-marker-alt"></i> Iquitos, Perú / Leticia, Colombia</div>
    <div style="margin-top:1rem;">
      <b>Síguenos:</b>
      <a href="https://www.facebook.com/amazoncamp" target="_blank" style="margin-left:0.5rem;"><i class="fab fa-facebook"></i></a>
      <a href="https://www.instagram.com/amazoncamp" target="_blank" style="margin-left:0.5rem;"><i class="fab fa-instagram"></i></a>
      <a href="https://www.youtube.com/@amazoncamp" target="_blank" style="margin-left:0.5rem;"><i class="fab fa-youtube"></i></a>
    </div>
  </div>
</div>

<WhatsappFlotante telefono="573228176411" mensaje="¡Hola! Quiero recibir información sobre Amazon Camp." />
<!-- Asegúrate de tener FontAwesome en tu proyecto para los íconos -->
