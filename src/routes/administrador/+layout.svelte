<script>
  import SidebarAdmin from '$lib/components/Admin/SidebarAdmin.svelte';
  import HeaderAdmin from '$lib/components/Admin/HeaderAdmin.svelte';
</script>

<div class="admin-layout">
  <SidebarAdmin />
  <div class="admin-main">
    <HeaderAdmin />
    <slot />
  </div>
</div>

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
</style>
