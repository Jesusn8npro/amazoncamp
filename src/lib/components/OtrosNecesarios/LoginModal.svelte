<script>
  import { createEventDispatcher } from 'svelte';
  import { supabase } from '../../../supabaseClient';
  let nombre = '';
  let apellido = '';
  let whatsapp = '';
  let prefijo = '+57'; // Por defecto Colombia
  let pais = '';
  let email = '';
  let password = '';
  let confirmPassword = '';
  let loading = false;
  let error = '';
  let isLogin = true;
  let recordar = false;
  let mostrarRecuperar = false;
  const dispatch = createEventDispatcher();

  import { goto } from '$app/navigation';

  async function submitForm() {
    loading = true;
    error = '';
    if (mostrarRecuperar) {
      // Recuperar contraseña
      const { error: err } = await supabase.auth.resetPasswordForEmail(email);
      loading = false;
      if (err) {
        error = err.message;
      } else {
        error = 'Si el correo existe, recibirás instrucciones para restablecer tu contraseña.';
      }
      return;
    }
    if (isLogin) {
      const { error: err } = await supabase.auth.signInWithPassword({
        email,
        password
      });
      loading = false;
      if (err) {
        error = err.message;
      } else {
        // Obtener usuario actual
        const { data: { user } } = await supabase.auth.getUser();
        if (user) {
          // Buscar el perfil para obtener el rol
          const { data: perfil, error: perfilError } = await supabase
            .from('perfiles')
            .select('rol')
            .eq('id', user.id)
            .single();
          if (perfilError) {
            error = 'No se pudo obtener el perfil';
            dispatch('close');
          } else if (perfil.rol === 'administrador') {
            goto('/administrador/paquetes');
          } else {
            dispatch('close');
          }
        } else {
          dispatch('close');
        }
      }
    } else {
      if (password !== confirmPassword) {
        error = 'Las contraseñas no coinciden';
        loading = false;
      } else {
        try {
          const { data, error: err } = await supabase.auth.signUp({
            email,
            password
          });
          loading = false;
          if (err) {
            error = err.message;
          } else {
            const userId = data.user?.id;
            if (userId) {
              const { error: perfilError } = await supabase
                .from('perfiles')
                .insert([{
                  id: userId,
                  email,
                  nombre,
                  apellido,
                  whatsapp: `${prefijo}${whatsapp}`,
                  pais,
                  foto_url: '',
                  rol: 'cliente'
                }]);
              if (perfilError) {
                error = 'Error al crear el perfil: ' + (perfilError.message || '');
                return;
              }
            }
            dispatch('close');
          }
        } catch (error) {
          error = 'Ocurrió un error inesperado.';
        }
        loading = false;
      }
    }
  }
</script>

<div class="fondo-modal">
  <div class="contenedor-modal" on:click|stopPropagation>
    <div class="tabs">
      <button class:activo={isLogin && !mostrarRecuperar} on:click={() => { isLogin = true; mostrarRecuperar = false; }}>
        Iniciar sesión
      </button>
      <button class:activo={!isLogin && !mostrarRecuperar} on:click={() => { isLogin = false; mostrarRecuperar = false; }}>
        Crear cuenta
      </button>
    </div>
    <form class="formulario" on:submit|preventDefault={submitForm}>
      <h2>{mostrarRecuperar ? 'Recuperar contraseña' : isLogin ? 'Iniciar sesión' : 'Crear cuenta'}</h2>
      {#if !isLogin && !mostrarRecuperar}
        <div class="grid-campos">
  <input type="text" placeholder="Nombre" class="input-estilizado" bind:value={nombre} required />
  <input type="text" placeholder="Apellido" class="input-estilizado" bind:value={apellido} required />
</div>
<div class="grid-campos">
  <div class="input-prefijo-whatsapp">
    <select class="input-estilizado prefijo-select" bind:value={prefijo} required>
      <option value="+57">+57 (Colombia)</option>
      <option value="+52">+52 (México)</option>
      <option value="+54">+54 (Argentina)</option>
      <option value="+51">+51 (Perú)</option>
      <option value="+56">+56 (Chile)</option>
      <option value="+593">+593 (Ecuador)</option>
      <option value="+58">+58 (Venezuela)</option>
      <option value="+1">+1 (EE.UU./Canadá)</option>
      <option value="+34">+34 (España)</option>
      <option value="+55">+55 (Brasil)</option>
      <option value="+507">+507 (Panamá)</option>
      <option value="+502">+502 (Guatemala)</option>
      <option value="+53">+53 (Cuba)</option>
      <option value="+595">+595 (Paraguay)</option>
      <option value="+598">+598 (Uruguay)</option>
      <option value="+591">+591 (Bolivia)</option>
      <option value="+505">+505 (Nicaragua)</option>
      <option value="+504">+504 (Honduras)</option>
      <option value="+506">+506 (Costa Rica)</option>
      <option value="+592">+592 (Guyana)</option>
      <option value="+597">+597 (Surinam)</option>
      <!-- Puedes agregar más países relevantes aquí -->
    </select>
    <input type="text" placeholder="WhatsApp" class="input-estilizado" bind:value={whatsapp} required style="flex:1;" />
  </div>
  <input type="text" placeholder="País" class="input-pais-limpio" bind:value={pais} required />
</div>
<input type="email" placeholder="Correo electrónico" class="input-estilizado" bind:value={email} required />
<input type="password" placeholder="Contraseña" class="input-estilizado" bind:value={password} required />
<input type="password" placeholder="Confirmar contraseña" class="input-estilizado" bind:value={confirmPassword} required />
      {/if}
      {#if isLogin && !mostrarRecuperar}
        <input type="email" placeholder="Correo electrónico" class="input-estilizado" bind:value={email} required />
        <input type="password" placeholder="Contraseña" class="input-estilizado" bind:value={password} required />
      {/if}
      {#if isLogin && !mostrarRecuperar}
        <div class="opciones-extra">
          <label class="recordar">
            <input type="checkbox" bind:checked={recordar} /> Recordar sesión
          </label>
          <a href="#" class="recuperar" on:click|preventDefault={() => { mostrarRecuperar = true; }}>¿Olvidaste tu contraseña?</a>
        </div>
      {/if}
      {#if error}
        <div class="error">{error}</div>
      {/if}
      <button type="submit" class="boton-enviar" disabled={loading}>
        {#if loading}
          Cargando...
        {:else}
          {mostrarRecuperar ? 'Enviar instrucciones' : isLogin ? 'Iniciar sesión' : 'Crear cuenta'}
        {/if}
      </button>
      {#if mostrarRecuperar}
        <a href="#" class="volver" on:click|preventDefault={() => { mostrarRecuperar = false; }}>Volver a iniciar sesión</a>
      {:else}
        <div class="cambiar-form">
          {#if isLogin}
            ¿No tienes cuenta? <a href="#" on:click|preventDefault={() => { isLogin = false; }}>Regístrate</a>
          {:else}
            ¿Ya tienes cuenta? <a href="#" on:click|preventDefault={() => { isLogin = true; }}>Inicia sesión</a>
          {/if}
        </div>
      {/if}
    </form>
    <button class="cerrar-modal" aria-label="Cerrar modal" on:click={() => dispatch('close')}>&times;</button>
  </div>
</div>

<style>
  /* Fondo con imagen difuminada y overlay oscuro */
  .fondo-modal {
    position: fixed;
    inset: 0;
    z-index: 9999;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(rgba(20,30,40,0.65), rgba(20,30,40,0.85)), url('https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80') center/cover no-repeat;
    backdrop-filter: blur(2.5px);
  }
  .contenedor-modal {
    background: rgba(255,255,255,0.98);
    border-radius: 1.3rem;
    box-shadow: 0 8px 40px #0005;
    min-width: 340px;
    max-width: 500px;
    width: 100%;
    padding: 2.5rem 2.2rem 2.2rem 2.2rem;
    position: relative;
    display: flex;
    flex-direction: column;
    align-items: center;
    overflow: hidden;
  }
  .tabs {
    display: flex;
    justify-content: center;
    gap: 5rem;
    margin-bottom: 2.2rem;
    width: 100%;
  }
  .tabs button {
    background: none;
    border: none;
    font-size: 1.14rem;
    font-weight: 600;
    color: #7a7a7a;
    padding-bottom: 0.3rem;
    border-bottom: 2.5px solid transparent;
    transition: color 0.2s, border 0.2s;
    cursor: pointer;
    outline: none;
  }
  .tabs button.activo {
    color: #18e0e9;
    border-bottom: 2.5px solid #18e0e9;
  }
  .formulario {
    width: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
  }
  h2 {
    text-align: center;
    font-size: 2rem;
    font-weight: 700;
    margin-bottom: 1.7rem;
    color: #222;
    letter-spacing: 0.01em;
  }
  .input-estilizado {
    width: 100%;
    padding: 0.95rem 1.1rem;
    border: 1.5px solid #e5e7eb;
    border-radius: 0.7rem;
    font-size: 1.1em;
    background: #f7faff;
    margin-bottom: 1.15rem;
    margin-top: 0.1rem;
    transition: border 0.2s;
    box-sizing: border-box;
  }
  .input-estilizado:focus {
    border: 1.5px solid #00c9e0;
    outline: none;
    background: #fff;
  }
  .opciones-extra {
    width: 100%;
    padding: 0.85rem 1rem;
    border: 1.5px solid #e5e7eb;
    border-radius: 0.7rem;
    font-size: 1.1em;
    background: #f7faff;
    margin-bottom: 0;
    transition: border 0.2s;
    box-sizing: border-box;
  }
  .input-estilizado:focus {
    border: 1.5px solid #00c9e0;
    outline: none;
    background: #fff;
  }
  .opciones-extra {
    width: 100%;
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1.2rem;
  }
  .recordar {
    font-size: 0.98rem;
    color: #444;
    display: flex;
    align-items: center;
    gap: 0.4rem;
  }
  .recuperar {
    font-size: 0.97rem;
    color: #18e0e9;
    cursor: pointer;
    text-decoration: underline;
    transition: color 0.2s;
  }
  .recuperar:hover {
    color: #13bfc3;
  }
  .error {
    color: #d32f2f;
    background: #ffeaea;
    border-radius: 0.5rem;
    padding: 0.7rem 1.1rem;
    margin-bottom: 1.1rem;
    font-size: 1.01rem;
    text-align: center;
    width: 100%;
  }
  .boton-enviar {
    width: 100%;
    background: linear-gradient(90deg, #18e0e9 0%, #00b8d9 100%);
    color: #fff;
    border: none;
    border-radius: 0.7rem;
    padding: 1rem 0;
    font-size: 1.15rem;
    font-weight: bold;
    cursor: pointer;
    margin-bottom: 1.2rem;
    box-shadow: 0 2px 12px #00b8d933;
    transition: background 0.2s, box-shadow 0.2s;
  }
  .boton-enviar:hover:enabled {
    background: linear-gradient(90deg, #13bfc3 0%, #0094b4 100%);
    box-shadow: 0 4px 16px #00b8d955;
  }
  .cambiar-form {
    text-align: center;
    font-size: 1rem;
    color: #444;
    margin-top: 0.6rem;
  }
  .cambiar-form a, .volver {
    color: #18e0e9;
    cursor: pointer;
    text-decoration: underline;
    transition: color 0.2s;
    margin-left: 0.2rem;
  }
  .cambiar-form a:hover, .volver:hover {
    color: #13bfc3;
  }
  .volver {
    display: block;
    text-align: center;
    margin-top: 0.5rem;
    font-size: 1rem;
  }
  .cerrar-modal {
    position: absolute;
    top: 1.1rem;
    right: 1.3rem;
    background: none;
    border: none;
    font-size: 2.2rem;
    color: #ff7a1a;
    cursor: pointer;
    z-index: 10;
    transition: color 0.2s;
  }
  .cerrar-modal:hover {
    color: #e05d00;
  }
  .grid-campos {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1rem;
    margin-bottom: 0.8rem;
  }
  .input-prefijo-whatsapp {
    display: grid;
    grid-template-columns: 8.5rem 1.5fr;
    gap: 1.1rem;
    align-items: center;
    width: 100%;
    margin-bottom: 1.2rem;
}
.input-prefijo-whatsapp .prefijo-select {
    width: 100%;
    min-width: 0;
    max-width: 100%;
    height: 48px;
    font-size: 1.07em;
    padding: 0.7rem 0.7rem 0.7rem 1rem;
}
.input-prefijo-whatsapp input[type="text"] {
    height: 48px;
    font-size: 1.07em;
    padding: 0.7rem 1rem;
    margin-bottom: 0;
}
.input-pais-limpio {
    width: 100%;
    height: 48px;
    font-size: 1.07em;
    padding: 0.7rem 1rem;
    margin-bottom: 1.2rem;
    border-radius: 0.7rem;
    border: 1.5px solid #e5e7eb;
    background: #f7faff;
    box-sizing: border-box;
}
@media (max-width: 640px) {
  .input-prefijo-whatsapp {
    grid-template-columns: 1fr;
    gap: 0.7rem;
  }
  .input-pais-limpio {
    margin-bottom: 1.15rem;
  }
}

  .prefijo-select {
    width: 7.5rem;
    min-width: 7.5rem;
    max-width: 9rem;
    padding-right: 0.3rem;
  }
  @media (max-width: 640px) {
    .contenedor-modal {
      padding: 1.2rem 0.5rem 1.2rem 0.5rem;
      margin: 50px;
    }
    .grid-campos {
      grid-template-columns: 1fr;
      gap: 0.7rem;
    }
  }
</style>
