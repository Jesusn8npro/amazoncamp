<script>
  import SidebarAdmin from '$lib/components/Admin/SidebarAdmin.svelte';
  import HeaderAdmin from '$lib/components/Admin/HeaderAdmin.svelte';
  import BottomNavAdmin from '$lib/components/Admin/BottomNavAdmin.svelte';
  import { supabase } from '../../supabaseClient.js';
  import { goto } from '$app/navigation';
  import { onMount } from 'svelte';

  onMount(async () => {
    const { data: { user } } = await supabase.auth.getUser();
    if (!user) {
      goto('/'); // No logueado
      return;
    }
    const { data: perfil, error } = await supabase
      .from('perfiles')
      .select('rol')
      .eq('id', user.id)
      .single();
    if (error || !perfil || perfil.rol !== 'administrador') {
      goto('/'); // No es admin
    }
  });
</script>

<div class="admin-layout">
  <div class="sidebar-responsive">
    <SidebarAdmin />
  </div>
  <div class="admin-main">
    <HeaderAdmin />
    <slot />
  </div>
</div>
<BottomNavAdmin />

<style>
.admin-layout {
  display: flex;
  min-height: 100vh;
}
.admin-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  background: #f7fafc;
}
/* Sidebar solo visible en escritorio */
.sidebar-responsive {
  display: block;
}
@media (max-width: 1023px) {
  .sidebar-responsive {
    display: none;
  }
}
</style>
