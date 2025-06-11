<script>
  import FormularioLanding from './FormularioLanding.svelte';
  export let paquete = {};
  export let fechaInicial = '';
  export let adultos = 1;
  export let ninos = 0;
  export let parejas = 0;

  // Lógica de precio temporal (simulada, reemplazar por lógica real más adelante)
  $: precioBase = paquete.precio_desde || 100;
  $: precioTotal = (adultos * precioBase) + (ninos * (precioBase * 0.7)) + (parejas * (precioBase * 1.8));

</script>

<section class="hero-paquete" style="background-image: linear-gradient(rgba(0,0,0,0.45),rgba(0,0,0,0.55)), url('{paquete.imagen_principal || 'https://via.placeholder.com/1200x600?text=Paquete'}');">
  <div class="contenedor">
    <div class="info-izq">
      <h1 class="titulo animate-titulo">{paquete.titulo}</h1>
      <p class="descripcion-corta">{paquete.descripcion_corta}</p>
      <button class="btn-cta animate-bounce">
        ¡Reserva tu lugar ahora!
      </button>
    </div>
    <div class="form-der">
      <FormularioLanding 
        tituloPaquete={paquete.titulo ?? 'Paquete'} 
        precioBase={paquete.precio_desde || 100}
        fechaInicial={fechaInicial}
        adultos={adultos}
        ninos={ninos}
        parejas={parejas}
        slug={paquete.slug}
      />
    </div>
  </div>
</section>

<style>
.hero-paquete {
  min-height: 420px;
  background-size: cover;
  background-position: center;
  display: flex;
  align-items: center;
  padding: 0;
  position: relative;
}
.contenedor {
  max-width: 1500px;
  margin: 0 auto;
  display: flex;
  justify-content: space-between;
  align-items: stretch;
  width: 100%;
  padding: 56px 36px 48px 36px;
  gap: 56px;
}

.info-izq {
  color: #fff;
  display: flex;
  flex-direction: column;
  justify-content: center;
  z-index: 2;
  padding-right: 32px;
  margin-bottom: 0;
  max-width: 700px  ;
}
.titulo {
  font-size: 2.7rem;
  font-weight: 900;
  margin-bottom: 18px;
  line-height: 1.1;
  letter-spacing: -1px;
  animation: fadeInDown 1s;
}
.animate-titulo {
  animation: pop-in 0.7s cubic-bezier(.4,0,.2,1);
}
.descripcion-corta {
  font-size: 1.25rem;
  font-weight: 500;
  margin-bottom: 22px;
  color: #f8fafc;
  text-shadow: 0 2px 8px rgba(0,0,0,0.17);
}
.form-der {
  background: #fff;
  border-radius: 18px;
  box-shadow: 0 6px 32px rgba(0,0,0,0.12);
  padding: 40px 32px 32px 32px;
  flex: 1 1 380px;
  max-width: 600px;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2;
  margin-top: 0;
}
.formulario-reserva {
  display: flex;
  flex-direction: column;
  gap: 17px;
  width: 100%;
}
.form-titulo {
  font-size: 1.3rem;
  font-weight: 700;
  color: #ea580c;
  margin-bottom: 8px;
}
label {
  display: flex;
  flex-direction: column;
  font-weight: 600;
  color: #222;
  font-size: 1rem;
  gap: 4px;
}
input[type="date"],
input[type="number"] {
  border: 1px solid #e5e7eb;
  border-radius: 7px;
  padding: 9px 11px;
  font-size: 1rem;
  margin-top: 3px;
}
.precio-total {
  font-size: 1.1rem;
  color: #14532d;
  background: #e0f2fe;
  border-radius: 8px;
  padding: 9px 13px;
  margin: 7px 0 0 0;
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.btn-reservar {
  background: linear-gradient(90deg, #ea580c 0%, #fbbf24 100%);
  color: #fff;
  font-weight: 800;
  font-size: 1.07rem;
  border: none;
  border-radius: 9px;
  padding: 13px 0;
  margin-top: 10px;
  cursor: pointer;
  box-shadow: 0 2px 10px rgba(234,88,12,0.10);
  transition: background 0.2s;
}
.btn-reservar:hover {
  background: linear-gradient(90deg, #fbbf24 0%, #ea580c 100%);
}
.mensaje-error {
  color: #dc2626;
  font-weight: 700;
  margin-top: 7px;
}
.mensaje-exito {
  color: #16a34a;
  font-weight: 700;
  margin-top: 7px;
}
.btn-cta {
  margin-top: 18px;
  background: linear-gradient(90deg, #fbbf24 0%, #ea580c 100%);
  color: #fff;
  font-weight: 900;
  font-size: 1.22rem;
  border: none;
  border-radius: 12px;
  padding: 15px 38px;
  box-shadow: 0 4px 24px rgba(234,88,12,0.17);
  cursor: pointer;
  transition: background 0.2s, transform 0.2s, box-shadow 0.2s;
  animation: bounceIn 1.1s cubic-bezier(.4,0,.2,1);
}
.btn-cta:hover {
  background: linear-gradient(90deg, #ea580c 0%, #fbbf24 100%);
  transform: scale(1.05) translateY(-2px);
  box-shadow: 0 8px 32px rgba(251,191,36,0.18);
}
@keyframes bounceIn {
  0% { opacity: 0; transform: scale(0.7) translateY(80px); }
  60% { opacity: 1; transform: scale(1.08) translateY(-12px); }
  80% { transform: scale(0.95) translateY(6px); }
  100% { opacity: 1; transform: scale(1) translateY(0); }
}
@media (max-width: 900px) {
  .contenedor {
    flex-direction: column;
    gap: 12px;
    padding: 10px 7px 7px 7px;
    box-sizing: border-box;
  }
  .info-izq {
    padding: 0;
    margin-bottom: 14px;
    text-align: center;
  }
  .form-der {
    max-width: 100%;
    width: 100%;
    margin-top: 0;
    padding: 20px;
    box-sizing: border-box;
  }
}
@keyframes pop-in {
  0% { opacity: 0; transform: scale(0.92) translateY(30px); }
  100% { opacity: 1; transform: scale(1) translateY(0); }
}
@keyframes fadeInDown {
  0% { opacity: 0; transform: translateY(-30px); }
  100% { opacity: 1; transform: translateY(0); }
}
</style>
