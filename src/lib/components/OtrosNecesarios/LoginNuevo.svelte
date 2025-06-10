<script>
  import { createEventDispatcher } from 'svelte';
  import { supabase } from '../../../supabaseClient';
  import { goto } from '$app/navigation';
  let nombre = '';
  let apellido = '';
  let whatsapp = '';
  let prefijo = '+57';
  let pais = '';
  let email = '';
  let password = '';
  let confirmPassword = '';
  let loading = false;
  let error = '';
  let showLogin = true;
  let recordar = false;
  const dispatch = createEventDispatcher();

  async function login() {
    loading = true;
    error = '';
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
  }

  async function register() {
    loading = true;
    error = '';
    if (!nombre || !apellido || !pais || !whatsapp || !email || !password || !confirmPassword) {
      error = 'Por favor completa todos los campos.';
      loading = false;
      return;
    }
    if (password !== confirmPassword) {
      error = 'Las contraseñas no coinciden';
      loading = false;
      return;
    }
    try {
      const { data, error: err } = await supabase.auth.signUp({
        email,
        password
      });
      if (err) {
        error = err.message;
        loading = false;
        return;
      }
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
          loading = false;
          return;
        }
      }
      dispatch('close');
    } catch (e) {
      error = 'Ocurrió un error inesperado.';
    }
    loading = false;
  }
</script>

{#if showLogin}
  <div class="modal-overlay">
    <div class="modal-box">
      <button class="close-btn" aria-label="Cerrar" on:click={() => dispatch('close')}>&times;</button>
      <h2 class="modal-title">Iniciar Sesión</h2>
      <form class="modal-form" on:submit|preventDefault={login}>
        <div class="input-group">
          <input type="email" placeholder="Correo electrónico" bind:value={email} required />
          <span class="input-icon"><svg width="18" height="18" fill="none" stroke="currentColor"><path d="M4 4h10v10H4z"/><path d="M4 4l5 5 5-5"/></svg></span>
        </div>
        <div class="input-group">
          <input type="password" placeholder="Contraseña" bind:value={password} required />
          <span class="input-icon"><svg width="18" height="18" fill="none" stroke="currentColor"><path d="M12 11v2m-4-2v2m8-7v10a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2z"/></svg></span>
        </div>
        {#if error}
          <div class="error">{error}</div>
        {/if}
        <button type="submit" class="register-btn" disabled={loading}>{loading ? 'Entrando...' : 'Entrar'}</button>
      </form>
      <div class="modal-footer">
        ¿No tienes cuenta? <a href="#" on:click={() => { showLogin = false; error = ''; }}>Regístrate</a>
      </div>
    </div>
  </div>
{:else}
  <div class="modal-overlay">
    <div class="modal-box">
      <button class="close-btn" aria-label="Cerrar" on:click={() => dispatch('close')}>&times;</button>
      <h2 class="modal-title">Registro</h2>
      <form class="modal-form" on:submit|preventDefault={register}>
        <div class="input-group">
          <input type="text" placeholder="Nombre" bind:value={nombre} required />
        </div>
        <div class="input-group">
          <input type="text" placeholder="Apellido" bind:value={apellido} required />
        </div>
        <div class="input-group">
          <select bind:value={prefijo} required style="max-width: 7.5rem;">
            <option value="+57">+57 (Colombia)</option>
            <option value="+52">+52 (México)</option>
            <option value="+34">+34 (España)</option>
            <option value="+1">+1 (USA)</option>
            <option value="+51">+51 (Perú)</option>
            <option value="+54">+54 (Argentina)</option>
            <option value="+56">+56 (Chile)</option>
            <option value="+593">+593 (Ecuador)</option>
            <option value="+598">+598 (Uruguay)</option>
            <option value="+595">+595 (Paraguay)</option>
            <option value="+507">+507 (Panamá)</option>
            <option value="+58">+58 (Venezuela)</option>
            <option value="+591">+591 (Bolivia)</option>
            <option value="+53">+53 (Cuba)</option>
            <option value="+506">+506 (Costa Rica)</option>
            <option value="+502">+502 (Guatemala)</option>
            <option value="+503">+503 (El Salvador)</option>
            <option value="+504">+504 (Honduras)</option>
            <option value="+505">+505 (Nicaragua)</option>
            <option value="+509">+509 (Haití)</option>
            <option value="+592">+592 (Guyana)</option>
            <option value="+597">+597 (Surinam)</option>
          </select>
          <input type="text" placeholder="WhatsApp" bind:value={whatsapp} required style="flex:1; margin-left:0.7rem;" />
        </div>
        <div class="input-group">
          <input type="text" placeholder="País" bind:value={pais} required />
        </div>
        <div class="input-group">
          <input type="email" placeholder="Correo electrónico" bind:value={email} required />
        </div>
        <div class="input-group">
          <input type="password" placeholder="Contraseña" bind:value={password} required />
        </div>
        <div class="input-group">
          <input type="password" placeholder="Confirmar contraseña" bind:value={confirmPassword} required />
        </div>
        {#if error}
          <div class="error">{error}</div>
        {/if}
        <button type="submit" class="register-btn" disabled={loading}>
          {loading ? 'Registrando...' : 'Registrarse'}
        </button>
      </form>
      <div class="modal-footer">
        ¿Ya tienes cuenta? <a href="#" on:click={() => { showLogin = true; error = ''; }}>Inicia sesión</a>
      </div>
    </div>
  </div>
{/if}

<style>
  .modal-overlay {
    position: fixed;
    inset: 0;
    z-index: 9999;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(30,30,40,0.25);
    backdrop-filter: blur(6px);
    animation: fadeInBg 0.5s;
  }
  .modal-box {
    background: rgba(255,255,255,0.15);
    border-radius: 1.2rem;
    box-shadow: 0 8px 40px #0007;
    padding: 2.5rem 2.2rem 2.2rem 2.2rem;
    min-width: 320px;
    max-width: 340px;
    width: 100%;
    position: relative;
    display: flex;
    flex-direction: column;
    align-items: center;
    border: 1.5px solid #fff6;
    backdrop-filter: blur(12px);
    animation: fadeInUp 0.6s cubic-bezier(.77,0,.18,1);
  }
  .modal-title {
    color: #2b1e3a;
    font-size: 2rem;
    font-weight: 700;
    margin-bottom: 2.1rem;
    text-align: center;
    letter-spacing: 0.01em;
    text-shadow: 0 1px 8px #fff7;
  }
  .modal-form {
    width: 100%;
    display: flex;
    flex-direction: column;
    align-items: stretch;
    gap: 1.1rem;
  }
  .input-group {
    position: relative;
    display: flex;
    align-items: center;
  }
  .input-group input {
    width: 100%;
    padding: 1rem 2.1rem 1rem 1.1rem;
    border: none;
    border-radius: 0.7rem;
    font-size: 1.1em;
    background: #fff7;
    color: #2b1e3a;
    box-shadow: 0 2px 12px #fff4;
    transition: border 0.2s, box-shadow 0.2s;
    outline: none;
  }
  .input-group input:focus {
    background: #fff;
    box-shadow: 0 2px 16px #fff9;
  }
  .input-icon {
    position: absolute;
    right: 1.1rem;
    top: 50%;
    transform: translateY(-50%);
    color: #a36be6;
    opacity: 0.8;
    pointer-events: none;
  }
  .terms-row {
    display: flex;
    align-items: center;
    gap: 0.6rem;
    font-size: 0.98em;
    margin-bottom: 0.7rem;
    color: #2b1e3a;
  }
  .terms-row input[type="checkbox"] {
    accent-color: #a36be6;
    width: 1.1em;
    height: 1.1em;
  }
  .register-btn {
    width: 100%;
    background: linear-gradient(90deg, #a36be6 0%, #6a47b3 100%);
    color: #fff;
    border: none;
    border-radius: 0.7rem;
    padding: 1rem 0;
    font-size: 1.15rem;
    font-weight: bold;
    cursor: pointer;
    margin-top: 0.5rem;
    margin-bottom: 0.5rem;
    box-shadow: 0 2px 12px #a36be633;
    transition: background 0.2s, box-shadow 0.2s;
  }
  .register-btn:hover:enabled {
    background: linear-gradient(90deg, #6a47b3 0%, #a36be6 100%);
    box-shadow: 0 4px 16px #a36be655;
  }
  .modal-footer {
    text-align: center;
    font-size: 1em;
    color: #fff;
    margin-top: 0.4rem;
    text-shadow: 0 1px 8px #a36be6cc;
  }
  .modal-footer a {
    color: #fff;
    text-decoration: underline;
    font-weight: 600;
    cursor: pointer;
    margin-left: 0.2rem;
    transition: color 0.2s;
  }
  .modal-footer a:hover {
    color: #a36be6;
  }
  .close-btn {
    position: absolute;
    top: 1.1rem;
    right: 1.3rem;
    background: none;
    border: none;
    font-size: 2.2rem;
    color: #fff;
    cursor: pointer;
    z-index: 10;
    transition: color 0.2s;
    opacity: 0.7;
  }
  .close-btn:hover {
    color: #a36be6;
    opacity: 1;
  }
  .error {
    color: #d32f2f;
    background: #ffeaea;
    border-radius: 0.5rem;
    padding: 0.7rem 1.1rem;
    margin-bottom: 0.7rem;
    font-size: 1.01rem;
    text-align: center;
    width: 100%;
  }
  @keyframes fadeInBg {
    from { opacity: 0; }
    to { opacity: 1; }
  }
  @keyframes fadeInUp {
    from { opacity: 0; transform: translateY(40px); }
    to { opacity: 1; transform: none; }
  }
</style>
