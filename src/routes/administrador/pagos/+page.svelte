<script>
  // Aquí puedes agregar lógica futura para listar/controlar pagos
</script>

<style>
.pagos-main {
  min-height: 70vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  background: linear-gradient(120deg, #fff 60%, #a36be6 100%);
  box-shadow: 0 12px 48px #a36be644;
  margin: 2.5rem auto;
  padding: 2.7rem 1.7rem 2.2rem 1.7rem;
  max-width: 650px;
  animation: fadeInPagos 1.1s cubic-bezier(.77,0,.18,1);
}
.pagos-header {
  display: flex;
  align-items: center;
  gap: 1.3rem;
  margin-bottom: 1.8rem;
}
.pagos-icon {
  font-size: 4.2rem;
  color: #6a47b3;
  filter: drop-shadow(0 2px 12px #a36be655);
  animation: pulsePagos 1.4s infinite alternate;
}
.pagos-title {
  font-size: 2.7rem;
  font-weight: 900;
  color: #2b1e3a;
  letter-spacing: 0.02em;
  text-shadow: 0 2px 16px #a36be633;
}
.pagos-summary {
  background: #f7fafc;
  border-left: 6px solid #a36be6;
  border-radius: 0.9rem;
  padding: 1.4rem 1.5rem 1.2rem 1.5rem;
  margin-bottom: 1.6rem;
  box-shadow: 0 2px 12px #a36be622;
  width: 100%;
  max-width: 520px;
  font-size: 1.18rem;
  color: #333;
  font-weight: 500;
}
.pagos-firme {
  color: #d32f2f;
  font-size: 1.13rem;
  font-weight: 700;
  margin-bottom: 0.9rem;
  text-align: center;
  letter-spacing: 0.01em;
}
.pagos-note {
  color: #a36be6;
  font-size: 1.06rem;
  font-style: italic;
  text-align: center;
}
@keyframes fadeInPagos {
  from { opacity: 0; transform: translateY(40px); }
  to { opacity: 1; transform: none; }
}
@keyframes pulsePagos {
  0% { transform: scale(1); }
  100% { transform: scale(1.13); }
}
</style>

<div class="pagos-main">
  <div class="pagos-header">
    <span class="pagos-icon">💼</span>
    <span class="pagos-title">Gestión de Pagos</span>
  </div>
  <div class="pagos-summary">
    <b>Control total y transparente de pagos del negocio.</b><br>
    Aquí podrás revisar, aprobar y registrar todos los movimientos financieros relacionados con Amazon Camp.<br>
    <span class="pagos-firme">Acceso reservado. Solo usuarios autorizados pueden visualizar y gestionar los pagos.</span>
    <span class="pagos-note">Funcionalidad avanzada próximamente: integración de reportes, historial y alertas de pagos pendientes.</span>
  </div>
  <div style="margin:1.6rem 0 0.5rem 0;">
    <svg width="64" height="64" viewBox="0 0 64 64" fill="none"><rect x="8" y="16" width="48" height="32" rx="6" fill="#a36be6"/><rect x="12" y="20" width="40" height="24" rx="4" fill="#fff"/><rect x="20" y="28" width="24" height="8" rx="2" fill="#a36be6"/><circle cx="32" cy="40" r="2.5" fill="#6a47b3"/></svg>
  </div>
</div>
