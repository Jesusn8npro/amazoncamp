<script>
  // Puedes agregar lógica futura aquí si lo deseas
</script>

<style>
.soon-container {
  min-height: 70vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: linear-gradient(120deg, #f7fafc 60%, #a36be6 100%);
  box-shadow: 0 8px 32px #a36be622;
  margin: 2.5rem auto;
  padding: 2.5rem 1.5rem;
  max-width: 520px;
  animation: fadeInSoon 1s cubic-bezier(.77,0,.18,1);
}
.soon-icon {
  font-size: 4.5rem;
  color: #a36be6;
  margin-bottom: 1.2rem;
  animation: bounce 1.3s infinite alternate;
  filter: drop-shadow(0 2px 8px #a36be655);
}
.soon-title {
  font-size: 2.3rem;
  font-weight: 800;
  color: #2b1e3a;
  margin-bottom: 1.1rem;
  text-shadow: 0 1px 14px #fff5;
  text-align: center;
}
.soon-desc {
  color: #333;
  font-size: 1.15rem;
  margin-bottom: 1.4rem;
  text-align: center;
}
.soon-note {
  color: #a36be6;
  font-size: 1.08rem;
  font-style: italic;
  text-align: center;
  margin-bottom: 0.8rem;
}
@keyframes fadeInSoon {
  from { opacity: 0; transform: translateY(40px); }
  to { opacity: 1; transform: none; }
}
@keyframes bounce {
  0% { transform: translateY(0); }
  100% { transform: translateY(-16px); }
}
</style>

<div class="soon-container">
  <div class="soon-icon">⏳</div>
  <div class="soon-title">¡Próximamente Disponible!</div>
  <div class="soon-desc">
    La sección de gestión de <b>usuarios y clientes</b> estará habilitada muy pronto.<br>
    <span class="soon-note">
      Esperando confirmación del representante del negocio para acceder a la información y control de clientes.
    </span>
    <br>
    <span style="color:#d32f2f;font-weight:600;">Acceso restringido hasta regularización de pagos pendientes.</span>
  </div>
  <div style="margin-top:1.2rem;">
    <svg width="60" height="60" viewBox="0 0 60 60" fill="none"><circle cx="30" cy="30" r="28" stroke="#a36be6" stroke-width="4" fill="#fff"/><path d="M20 35c0-5.523 4.477-10 10-10s10 4.477 10 10" stroke="#a36be6" stroke-width="2.5" stroke-linecap="round"/><circle cx="30" cy="25" r="4.5" fill="#a36be6"/></svg>
  </div>
</div>
