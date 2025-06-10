<script>
  export let telefono = '51999999999'; // Cambia por el número real
  export let mensaje = '¡Hola! Necesito ayuda con un paquete.';
  let abierto = false;

  function irAWhatsapp() {
    const url = `https://wa.me/${telefono}?text=${encodeURIComponent(mensaje)}`;
    window.open(url, '_blank');
  }

  function toggleModal() {
    abierto = !abierto;
  }
</script>

<style>
.whatsapp-flotante {
  position: fixed;
  bottom: 32px;
  right: 32px;
  z-index: 2000;
  display: flex;
  flex-direction: column;
  align-items: flex-end;
}
.boton-wsp {
  background: #25d366;
  color: white;
  border-radius: 50%;
  width: 64px;
  height: 64px;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 16px rgba(0,0,0,0.2);
  cursor: pointer;
  font-size: 2.2rem;
  animation: pulse 1.5s infinite;
  border: none;
  outline: none;
  transition: transform 0.2s;
}
.boton-wsp:hover {
  transform: scale(1.1) rotate(-7deg);
  box-shadow: 0 8px 24px rgba(37, 211, 102, 0.3);
}
@keyframes pulse {
  0% { box-shadow: 0 0 0 0 rgba(37,211,102, 0.5); }
  70% { box-shadow: 0 0 0 16px rgba(37,211,102, 0); }
  100% { box-shadow: 0 0 0 0 rgba(37,211,102, 0); }
}

.modal-wsp {
  background: white;
  border-radius: 1.5rem;
  box-shadow: 0 4px 32px rgba(0,0,0,0.15);
  padding: 1.2rem 1.5rem 1.2rem 1.5rem;
  margin-bottom: 1rem;
  max-width: 320px;
  animation: aparecer 0.4s cubic-bezier(.6,-0.28,.74,.05);
  border: 2px solid #25d366;
  display: flex;
  align-items: center;
  gap: 1rem;
}
@keyframes aparecer {
  from { opacity: 0; transform: translateY(40px) scale(0.7); }
  to { opacity: 1; transform: translateY(0) scale(1); }
}
.cerrar-modal {
  background: none;
  border: none;
  font-size: 1.5rem;
  color: #25d366;
  cursor: pointer;
  margin-left: auto;
}
.texto-wsp {
  color: #222;
  font-size: 1rem;
  font-weight: 500;
}
@media (max-width: 600px) {
  .whatsapp-flotante {
    bottom: 18px;
    right: 18px;
  }
  .boton-wsp {
    width: 52px;
    height: 52px;
    font-size: 1.5rem;
  }
  .modal-wsp {
    max-width: 95vw;
    padding: 1rem;
  }
}
</style>

<div class="whatsapp-flotante">
  {#if abierto}
    <div class="modal-wsp" tabindex="0">
      <span class="texto-wsp">¿Tienes dudas? ¡Chatea con nosotros por WhatsApp!</span>
      <button class="cerrar-modal" aria-label="Cerrar" on:click={toggleModal}>&times;</button>
      <button class="boton-wsp" aria-label="Ir a WhatsApp" on:click={irAWhatsapp}>
        <i class="fab fa-whatsapp"></i>
      </button>
    </div>
  {/if}
  <button class="boton-wsp" aria-label="Abrir chat de WhatsApp" on:click={toggleModal}>
    <i class="fab fa-whatsapp"></i>
  </button>
</div>

<!-- Asegúrate de tener FontAwesome cargado para el ícono -->
